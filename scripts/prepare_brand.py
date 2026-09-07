"""Restore the supplied logo and apply it to generated Apple app assets."""
import base64
import json
import plistlib
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parent.parent
logo = root / 'assets/images/logo.png'
logo.write_bytes(base64.b64decode((root / 'assets/images/logo.b64').read_text(), validate=True))
if not logo.read_bytes().startswith(b'\x89PNG\r\n\x1a\n'):
    raise SystemExit('Invalid logo PNG')
assets = root / 'ios/Runner/Assets.xcassets'
for name in ('AppIcon.appiconset', 'LaunchImage.imageset'):
    folder = assets / name
    manifest = folder / 'Contents.json'
    if not manifest.exists():
        raise SystemExit(f'Missing generated asset catalog: {manifest}')
    data = json.loads(manifest.read_text())
    for index, entry in enumerate(data['images']):
        scale = float(entry.get('scale', '1x').rstrip('x'))
        size = round(float(entry.get('size', '160x160').split('x')[0]) * scale)
        filename = entry.get('filename', f'brand-{index}.png')
        entry['filename'] = filename
        subprocess.run(['sips', '-z', str(size), str(size), str(logo), '--out', str(folder / filename)], check=True)
    manifest.write_text(json.dumps(data, indent=2) + '\n')

# App Store Connect export-compliance prompt: the app does not implement
# non-exempt encryption. Because Codemagic regenerates the iOS project on every
# build, enforce the key after `flutter create` each time.
info_plist = root / 'ios/Runner/Info.plist'
if not info_plist.exists():
    raise SystemExit(f'Missing generated Info.plist: {info_plist}')
with info_plist.open('rb') as f:
    info = plistlib.load(f)
info['ITSAppUsesNonExemptEncryption'] = False
with info_plist.open('wb') as f:
    plistlib.dump(info, f, fmt=plistlib.FMT_XML, sort_keys=False)

print('Brand logo, iOS app icons, launch images and export compliance prepared.')
