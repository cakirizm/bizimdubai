import json
from copy import deepcopy
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"
DISCOVER = DATA / "discover.json"
SEED = ROOT / "lib" / "discover" / "seed_data.dart"


def photo(url: str, source: str, caption: str) -> dict:
    return {"url": url, "source": source, "caption": caption}


# Curated current imagery. Preference order: official 2026 WebP/AVIF, official current
# CDN image, then the newest verifiable listing image already in the source chunks.
PHOTO_OVERRIDES = {
    "bosporus": [
        photo("https://thebosporus.com/wp-content/uploads/2026/05/menu-hero-1.jpg", "https://thebosporus.com/menu/", "Bosporus · 2026 resmî menü görseli"),
        photo("https://thebosporus.com/wp-content/uploads/2026/05/menu-hero-2.jpg", "https://thebosporus.com/menu/", "Bosporus · 2026 resmî menü görseli"),
    ],
    "zouzou": [
        photo("https://zouzoudubai.com/wp-content/uploads/2026/01/zouzou-gal05-700x560.jpg", "https://zouzoudubai.com/gallery/", "ZouZou · 2026 resmî galeri görseli"),
        photo("https://zouzoudubai.com/wp-content/uploads/2026/01/zouzou-gal02-700x560.jpg", "https://zouzoudubai.com/gallery/", "ZouZou · 2026 resmî galeri görseli"),
    ],
    "mado": [
        photo("https://mado.ae/wp-content/uploads/2026/01/MADO-Header-42.jpg", "https://mado.ae/", "MADO UAE · 2026 resmî görsel"),
        photo("https://mado.ae/wp-content/uploads/2026/01/MADO-Header-41.jpg", "https://mado.ae/", "MADO UAE · 2026 resmî görsel"),
    ],
    "hafiz": [
        photo("https://api.hm1864.ae/uploads/admin/media/1788208808345-29550d.webp", "https://www.hm1864.ae/", "Hafiz Mustafa 1864 UAE · güncel resmî WebP"),
        photo("https://api.hm1864.ae/uploads/admin/media/1789501038990-1a472c.webp", "https://www.hm1864.ae/", "Hafiz Mustafa 1864 UAE · 2026 resmî ürün görseli"),
    ],
    "sultan": [
        photo("https://sultansaray.ae/wp-content/uploads/2025/11/sultan_saray_Images6-1024x674.jpg", "https://sultansaray.ae/dubai/", "Sultan Saray Dubai · güncel resmî görsel"),
        photo("https://sultansaray.ae/wp-content/uploads/2025/11/sultan_saray_Images7-1024x674.jpg", "https://sultansaray.ae/dubai/", "Sultan Saray Dubai · güncel resmî görsel"),
    ],
    "turkish-village": [
        photo("https://cdn.prod.website-files.com/685b9e7614cf5112bd2226e4_Hero_Image.avif", "https://turkishvillage.com/", "Turkish Village · güncel resmî AVIF şube görseli"),
        photo("https://cdn.prod.website-files.com/6817c3641c8686a5b35fe7f9_Ali%20Nazik-14.avif", "https://turkishvillage.com/", "Turkish Village · güncel resmî AVIF yemek görseli"),
    ],
    "kapadokya": [
        photo("https://www.kapadokyadubai.com/ourstory.webp", "https://www.kapadokyadubai.com/", "Kapadokya Turkish Kitchen · güncel resmî WebP iç mekân"),
        photo("https://www.kapadokyadubai.com/kapadokya1.webp", "https://www.kapadokyadubai.com/", "Kapadokya Turkish Kitchen · güncel resmî WebP yemek görseli"),
    ],
    "gunaydin": [
        photo("https://gunaydindubai.com/static/uploads/2026/07/1.webp", "https://www.gunaydindubai.com/en", "Günaydın Dubai · Temmuz 2026 resmî WebP"),
        photo("https://gunaydindubai.com/static/uploads/2026/07/2.webp", "https://www.gunaydindubai.com/en", "Günaydın Dubai · Temmuz 2026 resmî WebP"),
    ],
    "sirali": [
        photo("https://venuewise.com/upload/venue/gallery/opt/2026/03/18/caption_69ba63d47d17e.webp", "https://www.opentable.ae/r/sirali-dubai", "Sıralı Dubai · 2026 güncel mekân görseli"),
    ],
    "huqqabaz": [
        photo("https://images.qfoodbeverage.com.tr/webp/garden-1741289061-oyOPTXFXjW.webp", "https://huqqabaz.com/en/branch/huqqabaz-garden/", "HuQQabaz · güncel resmî WebP"),
        photo("https://images.qfoodbeverage.com.tr/webp/huqqa-moe-007-of-131-1741971722-NnPq4fMQii.webp", "https://huqqabaz.com/en/branch/huqqabaz-garden/", "HuQQabaz · güncel resmî WebP galeri"),
    ],
    "huqqa": [
        photo("https://www.huqqa.com/wp-content/uploads/2026/07/huqqa-dubai-4.webp", "https://www.huqqa.com/dubai-huqqa/", "HuqqA Dubai Mall · Temmuz 2026 resmî WebP"),
        photo("https://www.huqqa.com/wp-content/uploads/2026/09/Q-Food-Beverage-Family.webp", "https://www.huqqa.com/dubai-huqqa/", "HuqqA · Eylül 2026 resmî WebP"),
    ],
    "besh": [
        photo("https://mds-assets.marriott.com/cdn-cgi/image/f=auto,w=900/cms-platform-for-marriott/dxbml-besh-turkish-kitchen/site-images/migrated-images/besh-entrance.jpg", "https://beshdubai.com/", "Besh Turkish Kitchen · güncel resmî Marriott CDN görseli"),
        photo("https://mds-assets.marriott.com/cdn-cgi/image/f=auto,w=900/cms-platform-for-marriott/dxbml-besh-turkish-kitchen/site-images/migrated-images/besh-food.jpg", "https://beshdubai.com/", "Besh Turkish Kitchen · güncel resmî yemek görseli"),
    ],
    "ruya": [
        photo("https://ruyarestaurants.com/wp-content/uploads/2025/11/RUYA-74-e1762253064473.jpg", "https://ruyarestaurants.com/dubai/", "Rüya Dubai · güncel resmî mekân görseli"),
        photo("https://ruyarestaurants.com/wp-content/uploads/2025/07/Ruya-Dubai-Busines-Lunch-2025-scaled.jpg", "https://ruyarestaurants.com/dubai/", "Rüya Dubai · güncel resmî yemek görseli"),
    ],
    "otantik": [
        photo("https://otantik.ae/wp-content/uploads/2025/04/slider-img-3.webp", "https://otantik.ae/", "Otantik · güncel resmî WebP mekân görseli"),
        photo("https://otantik.ae/wp-content/uploads/2024/12/Home-about-section-slider-img-2.jpg", "https://otantik.ae/", "Otantik · güncel resmî restoran görseli"),
    ],
    "ege": [
        photo("https://egerestaurant.com/wp-content/uploads/2025/03/ege-d-683x1024.jpg", "https://egerestaurant.com/", "EGE Restaurant · güncel resmî iç mekân görseli"),
        photo("https://egerestaurant.com/wp-content/uploads/2025/03/FXH21803-%D0%A3%D0%BB%D1%83%D1%87%D1%88%D0%B5%D0%BD%D0%BE-%D0%A3%D0%BC.-%D1%88%D1%83%D0%BC%D0%B0-768x1152.jpg", "https://egerestaurant.com/", "EGE Restaurant · güncel resmî yemek görseli"),
    ],
    "etci": [
        photo("https://www.etciumut.ae/images/dubai.png", "https://www.etciumut.ae/", "Etçi Umut Dubai · güncel resmî şube görseli"),
    ],
    "chef-burak": [
        photo("https://static.wixstatic.com/media/c4e9fa_a63f455feb804c3e8a221be8f67f81db~mv2.jpg/v1/fill/w_900,h_650,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/c4e9fa_a63f455feb804c3e8a221be8f67f81db~mv2.jpg", "https://www.chefburakgurme.com/", "Chef Burak Gurme · güncel resmî mekân görseli"),
        photo("https://static.wixstatic.com/media/040031_249f230b18834f2e83674756cb309a87f000.jpg/v1/fill/w_900,h_650,al_c,q_80,enc_avif,quality_auto/040031_249f230b18834f2e83674756cb309a87f000.jpg", "https://www.chefburakgurme.com/", "Chef Burak Gurme · güncel resmî iç mekân görseli"),
    ],
    "karaf": [
        photo("https://www.karaf.ae/img/karaf-turkish-restaurant-dubai-palm-jumeirah-1400.jpg", "https://www.karaf.ae/", "Karaf by Bahçe · güncel resmî Palm Jumeirah görseli"),
        photo("https://www.karaf.ae/img/karaf-turkish-restaurant-dubai-raki-mezze-terrace-1916.jpg", "https://www.karaf.ae/", "Karaf by Bahçe · güncel resmî teras görseli"),
    ],
    "turk-cuisine": [
        photo("https://turkcuisine.ae/assets/hero.jpg", "https://turkcuisine.ae/", "Turk Cuisine JVC · güncel resmî yemek görseli"),
        photo("https://turkcuisine.ae/assets/grill.jpg", "https://turkcuisine.ae/", "Turk Cuisine JVC · güncel resmî ızgara görseli"),
    ],
}


def rule_key(entry: dict) -> str | None:
    ident = str(entry.get("id", "")).lower()
    name = str(entry.get("name", "")).lower()
    pairs = [
        ("bosporus", ("bosporus",)),
        ("zouzou", ("zouzou",)),
        ("mado", ("mado",)),
        ("hafiz", ("hafiz", "hafız")),
        ("sultan", ("sultan-saray", "sultan saray")),
        ("turkish-village", ("turkish-village", "turkish village")),
        ("kapadokya", ("kapadokya",)),
        ("gunaydin", ("gunaydn", "gunaydin", "günaydın")),
        ("sirali", ("sirali", "sıralı")),
        ("huqqabaz", ("huqqabaz",)),
        ("huqqa", ("huqqa-dubai", "huqqa ·", "huqqa dubai")),
        ("besh", ("besh",)),
        ("ruya", ("ruya", "rüya")),
        ("otantik", ("otantik",)),
        ("ege", ("ege-restaurant", "ege restaurant")),
        ("etci", ("etci-umut", "etçi umut")),
        ("chef-burak", ("chef-burak", "chef burak")),
        ("karaf", ("karaf",)),
        ("turk-cuisine", ("turk-cuisine", "turk cuisine")),
    ]
    haystack = f"{ident} {name}"
    for key, needles in pairs:
        if any(n in haystack for n in needles):
            return key
    return None


def normalize(entry: dict) -> dict:
    e = deepcopy(entry)
    # These scores came from heterogeneous snapshots and age faster than the core listing.
    for stale in ("rating", "ratingSource", "ratingLabel"):
        e.pop(stale, None)
    e["category"] = "Restoranlar"
    cats = list(e.get("categories") or [])
    if "Restoranlar" not in cats:
        cats.insert(0, "Restoranlar")
    e["categories"] = cats
    e["active"] = e.get("active", True) is not False
    key = rule_key(e)
    if key:
        e["photos"] = deepcopy(PHOTO_OVERRIDES[key])
        e["checkedAt"] = datetime.now(timezone.utc).date().isoformat()
    return e


def stable(obj) -> str:
    return json.dumps(obj, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def main() -> None:
    catalog = json.loads(DISCOVER.read_text(encoding="utf-8"))
    non_restaurants = [e for e in catalog["entries"] if e.get("category") != "Restoranlar"]

    merged_by_id: dict[str, dict] = {}
    order: list[str] = []
    chunks = sorted(DATA.glob("restaurants_*.json"))
    if not chunks:
        raise SystemExit("No restaurant chunks found")
    for path in chunks:
        payload = json.loads(path.read_text(encoding="utf-8"))
        for raw in payload.get("entries", []):
            e = normalize(raw)
            ident = e["id"]
            if ident not in merged_by_id:
                order.append(ident)
            merged_by_id[ident] = e

    restaurants = [merged_by_id[i] for i in order if merged_by_id[i].get("active", True)]
    next_entries = restaurants + non_restaurants
    changed = stable(next_entries) != stable(catalog["entries"])
    if changed:
        catalog["revision"] = int(catalog.get("revision", 0)) + 1
        catalog["updatedAt"] = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
        catalog["entries"] = next_entries
        DISCOVER.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    compact = json.dumps(catalog, ensure_ascii=False, separators=(",", ":"))
    seed_text = (
        "// Generated by scripts/sync_restaurant_catalog.py. Do not edit.\n"
        "part of '../main.dart';\n\n"
        f"const discoverSeedJson = r'''{compact}''';\n"
    )
    if not SEED.exists() or SEED.read_text(encoding="utf-8").replace("\r\n", "\n") != seed_text:
        SEED.write_text(seed_text, encoding="utf-8")

    print(f"restaurant_chunks={len(chunks)} restaurants={len(restaurants)} total={len(next_entries)} revision={catalog['revision']} changed={changed}")


if __name__ == "__main__":
    main()
