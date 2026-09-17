from pathlib import Path

path = Path('test/discover_test.dart')
text = path.read_text(encoding='utf-8')
original = text
text = text.replace(
    "test('Bundled catalog contains 40 restaurants and all Discover categories', () {",
    "test('Bundled catalog contains expanded restaurants and all Discover categories', () {",
)
text = text.replace(
    "    expect(restaurants, hasLength(40));",
    "    expect(restaurants.length, greaterThanOrEqualTo(50));",
)
text = text.replace(
    "    expect(repo.catalog.entries.where((e) => e.category == 'Restoranlar'), hasLength(40));",
    "    expect(repo.catalog.entries.where((e) => e.category == 'Restoranlar').length, greaterThanOrEqualTo(50));",
)
if text != original:
    path.write_text(text, encoding='utf-8')
    print('Discover tests updated for expanded restaurant catalog')
else:
    print('Discover tests already current')
