from pathlib import Path

path = Path('lib/discover/discover_screen.dart')
text = path.read_text(encoding='utf-8')

block = """            final restaurantMode = filter.category == 'Restoranlar';
            final groupedRestaurants = restaurantMode ? _restaurantGroups(items) : const <_RestaurantGroup>[];"""

while f"{block}\n{block}" in text:
    text = text.replace(f"{block}\n{block}", block)

path.write_text(text, encoding='utf-8')
print('Restaurant grouping declarations normalized')
