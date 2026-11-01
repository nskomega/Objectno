#!/usr/bin/env python3
"""Build an isolated simulator test app and run real local-model integration."""
import argparse
import http.server
import json
from pathlib import Path
import platform
import shutil
import subprocess
import tempfile
import threading
import urllib.request

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('device',help='Booted iOS Simulator UUID')
    args=parser.parse_args()
    devices=json.loads(subprocess.check_output(['xcrun','simctl','list','devices','booted','--json'],text=True))
    if not any(device['udid']==args.device for values in devices['devices'].values() for device in values):
        raise SystemExit('Select an already booted iOS Simulator, not a physical device')
    flutter=shutil.which('flutter')
    if not flutter:raise SystemExit('Put Flutter on PATH')
    fixture=ROOT/'private/fixtures/coco-397133.jpg'
    if not fixture.exists():raise SystemExit('Missing private kitchen fixture; see docs/native-integration.md')
    with urllib.request.urlopen('http://127.0.0.1:8088/healthz',timeout=5) as health:
        if health.status!=200:raise SystemExit('Start the local Go API first')
    build_number=(ROOT/'VERSION').read_text().strip().rsplit('.',1)[-1]
    common=['--simulator','--debug','--config-only','--build-name=0.1.0',f'--build-number={build_number}',
            '--dart-define=API_BASE_URL=http://127.0.0.1:8088']
    def run(command):subprocess.run(command,cwd=ROOT,check=True)
    with tempfile.TemporaryDirectory(prefix='objectno-public-test-fixture-') as directory:
        shutil.copyfile(fixture,Path(directory)/'fixture.jpg')
        class Handler(http.server.SimpleHTTPRequestHandler):
            def __init__(self,*args,**kwargs):super().__init__(*args,directory=directory,**kwargs)
            def log_message(self,*args):pass
        server=http.server.ThreadingHTTPServer(('127.0.0.1',8768),Handler)
        thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
        try:
            run([flutter,'build','ios',*common,'--target=integration_test/local_analysis_test.dart',
                '--dart-define=OBJECTNO_TEST_FIXTURE_URL=http://127.0.0.1:8768/fixture.jpg',
                '--dart-define=INTEGRATION_TEST_SHOULD_REPORT_RESULTS_TO_NATIVE=false'])
            run(['xcrun','xcodebuild','-workspace','ios/Runner.xcworkspace','-scheme','Runner',
                '-configuration','Debug','-sdk','iphonesimulator','-destination','generic/platform=iOS Simulator',
                f'ARCHS={platform.machine()}','ONLY_ACTIVE_ARCH=YES','CODE_SIGNING_ALLOWED=YES','CODE_SIGN_IDENTITY=-',
                'PRODUCT_BUNDLE_IDENTIFIER=dev.objectno.integration',f'BUILD_DIR={ROOT}/build/integration-ios','build'])
            app=ROOT/'build/integration-ios/Debug-iphonesimulator/Runner.app'
            # Refuse to replace the normal app or accidentally run a production artifact.
            result=subprocess.check_output(['/usr/libexec/PlistBuddy','-c','Print CFBundleIdentifier',str(app/'Info.plist')],text=True).strip()
            if result!='dev.objectno.integration':raise RuntimeError('Integration bundle ID is not isolated')
            run([flutter,'drive','--no-build',f'--use-application-binary={app}',
                '--driver=test_driver/integration_test.dart','--target=integration_test/local_analysis_test.dart',
                '-d',args.device,'--no-publish-port'])
        finally:
            server.shutdown();server.server_close();thread.join(timeout=3)
            subprocess.run(['xcrun','simctl','uninstall',args.device,'dev.objectno.integration'],check=False,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
            run([flutter,'build','ios',*common,'--target=lib/main.dart'])

if __name__=='__main__':main()
