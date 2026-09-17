import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"

PATCHES = {
    "el-kasaba-restaurant-lounge-two-seasons-hotel": {
        "description": "Turkish, Mediterranean. Two Seasons Hotel & Apartments. Daily 10:00–01:00.",
        "photos": [
            {
                "url": "https://image-tc.galaxy.tf/wijpeg-aav94dv43o35pup9lccimiibt/el-kasaba4-drinks-toast_standard.jpg?crop=38%2C0%2C604%2C453",
                "source": "https://www.2seasonshotels.com/dining-in-dubai/elkasaba-restaurant",
                "caption": "EL KASABA · güncel resmî restoran görseli"
            },
            {
                "url": "https://image-tc.galaxy.tf/wijpeg-1w0txqyy4fwgzw4ircj20dfrz/el-kasaba2-drinks-toast_standard.jpg?crop=38%2C0%2C604%2C453",
                "source": "https://www.2seasonshotels.com/dining-in-dubai/elkasaba-restaurant",
                "caption": "EL KASABA · güncel resmî sofra görseli"
            },
            {
                "url": "https://image-tc.galaxy.tf/wijpeg-4klir3neoy9nurr60kj7893go/el-kasaba5_standard.jpg?crop=38%2C0%2C604%2C453",
                "source": "https://www.2seasonshotels.com/dining-in-dubai/elkasaba-restaurant",
                "caption": "EL KASABA · güncel resmî yemek görseli"
            }
        ],
        "checkedAt": "2026-09-17",
        "sources": ["https://www.2seasonshotels.com/dining-in-dubai/elkasaba-restaurant"]
    },
    "nusr-et-dubai": {
        "address": "Restaurant Village, Four Seasons Resort Dubai at Jumeirah Beach, Jumeirah 2, Dubai, UAE",
        "phone": "+97144074100",
        "website": "https://www.nusr-et.com.tr/en/restaurants/dubai",
        "description": "Four Seasons Resort Dubai Restaurant Village'da Nusr-Et Steakhouse Dubai şubesi.",
        "menuUrl": "https://www.nusr-et.com.tr/en/restaurants/dubai",
        "photos": [
            {
                "url": "https://api.nusr-et.com.tr/assets/images/locations/ef1fc928-e2d8-4655-8daf-d9c27bde268c.jpg",
                "source": "https://www.nusr-et.com.tr/en/restaurants/dubai",
                "caption": "Nusr-Et Dubai · güncel resmî şube görseli"
            },
            {
                "url": "https://api.nusr-et.com.tr/assets/images/locations/cda5397f-17c8-4513-9e56-d1f36ddf5e88.jpg",
                "source": "https://www.nusr-et.com.tr/en/restaurants/dubai",
                "caption": "Nusr-Et Dubai · güncel resmî atmosfer görseli"
            }
        ],
        "checkedAt": "2026-09-17",
        "sources": ["https://www.nusr-et.com.tr/en/restaurants/dubai"]
    }
}

changed_files = []
for path in sorted(DATA.glob("restaurants_*.json")):
    payload = json.loads(path.read_text(encoding="utf-8"))
    changed = False
    for entry in payload.get("entries", []):
        patch = PATCHES.get(entry.get("id"))
        if not patch:
            continue
        for key, value in patch.items():
            if entry.get(key) != value:
                entry[key] = value
                changed = True
    if changed:
        path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        changed_files.append(path.name)

print("updated=" + (",".join(changed_files) if changed_files else "none"))
