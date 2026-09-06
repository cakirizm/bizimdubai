"""Restore the supplied logo and apply it to generated Apple app assets."""
import base64
import json
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
print('Brand logo, iOS app icons and launch images prepared.')
