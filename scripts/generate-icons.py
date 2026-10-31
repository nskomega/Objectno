#!/usr/bin/env python3
"""Regenerate platform icons from our original using macOS sips."""
import json
import subprocess
from pathlib import Path
root = Path(__file__).resolve().parent.parent
source = root / 'assets/branding/objectno-icon-source.png'
def resize(path, size):
    path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(['sips', '-z', str(size), str(size), str(source), '--out', str(path)], check=True, stdout=subprocess.DEVNULL)
resize(root / 'assets/branding/objectno-icon-1024.png', 1024)
resize(root / 'assets/branding/google-play-icon-512.png', 512)
catalog = root / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for item in json.loads((catalog / 'Contents.json').read_text())['images']:
    size = round(float(item['size'].split('x')[0]) * float(item['scale'].rstrip('x')))
    resize(catalog / item['filename'], size)
res = root / 'android/app/src/main/res'
for density, size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    resize(res / f'mipmap-{density}/ic_launcher.png', size)
resize(res / 'drawable-nodpi/ic_launcher_foreground.png', 1024)
for size in [192,512]:
    resize(root / f'web/icons/Icon-{size}.png', size)
    resize(root / f'web/icons/Icon-maskable-{size}.png', size)
resize(root / 'web/favicon.png', 32)
print('Generated iOS, Android, web and store icons.')
