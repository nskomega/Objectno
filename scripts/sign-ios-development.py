#!/usr/bin/env python3
"""Sign a built iOS app for the one connected, already-provisioned device.

Uses existing local profiles/identities only. Does not register devices or make
requests to the developer portal. No private keys are exported.
"""
import argparse
import datetime
import hashlib
import plistlib
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('app', type=Path)
args = parser.parse_args()
app = args.app.resolve()
info = plistlib.loads((app / 'Info.plist').read_bytes())
bundle = info['CFBundleIdentifier']
udid = subprocess.check_output(['ideviceinfo', '-k', 'UniqueDeviceID'], text=True).strip()
identities = set(re.findall(r'\b[0-9A-F]{40}\b', subprocess.check_output(
    ['security', 'find-identity', '-v', '-p', 'codesigning'], text=True)))
roots = [Path.home() / 'Library/Developer/Xcode/UserData/Provisioning Profiles',
         Path.home() / 'Library/MobileDevice/Provisioning Profiles']
selected = None
for root in roots:
    for profile in sorted(root.glob('*.mobileprovision')):
        result = subprocess.run(['security', 'cms', '-D', '-i', str(profile)], capture_output=True)
        if result.returncode:
            continue
        data = plistlib.loads(result.stdout)
        entitlements = data.get('Entitlements', {})
        teams = data.get('TeamIdentifier', [])
        if not teams or entitlements.get('application-identifier') != teams[0] + '.*':
            continue
        if udid not in data.get('ProvisionedDevices', []):
            continue
        if data['ExpirationDate'] <= datetime.datetime.now(datetime.timezone.utc).replace(tzinfo=None):
            continue
        if entitlements.get('get-task-allow') is not True:
            continue
        fingerprints = [hashlib.sha1(c).hexdigest().upper() for c in data['DeveloperCertificates']]
        match = next((f for f in fingerprints if f in identities), None)
        if match:
            selected = profile, entitlements, teams[0], match
            break
    if selected:
        break
if selected is None:
    raise SystemExit('No valid local wildcard development profile and identity includes this device.')
profile, entitlements, team, identity = selected
entitlements['application-identifier'] = team + '.' + bundle
entitlements['keychain-access-groups'] = [group.replace('*', bundle)
    for group in entitlements.get('keychain-access-groups', [])]
shutil.copy2(profile, app / 'embedded.mobileprovision')
with tempfile.TemporaryDirectory(prefix='objectno-signing-') as folder:
    path = Path(folder) / 'entitlements.plist'
    path.write_bytes(plistlib.dumps(entitlements))
    nested = list((app / 'Frameworks').rglob('*.framework')) + list((app / 'Frameworks').rglob('*.dylib'))
    for target in sorted(nested, key=lambda p: len(p.parts), reverse=True):
        subprocess.run(['codesign', '--force', '--sign', identity, '--timestamp=none', str(target)], check=True)
    subprocess.run(['codesign', '--force', '--sign', identity, '--timestamp=none',
        '--entitlements', str(path), '--generate-entitlement-der', str(app)], check=True)
subprocess.run(['codesign', '--verify', '--deep', '--strict', str(app)], check=True)
print('Development signature verified for the connected provisioned device.')
