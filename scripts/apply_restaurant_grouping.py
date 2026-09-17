from pathlib import Path

path = Path('lib/discover/discover_screen.dart')
text = path.read_text(encoding='utf-8')

# Restaurant grouping is now part of the committed production UI. Codemagic still
# calls this script for backwards compatibility, so this step must be idempotent:
# validate the wiring, but never inject the same declarations a second time.
required_markers = [
    "String _restaurantBrandName(DiscoverItem item)",
    "class _RestaurantGroup {",
    "class _RestaurantGroupCard extends StatelessWidget {",
    "class _RestaurantBranchesPage extends StatelessWidget {",
    "final restaurantMode = filter.category == 'Restoranlar';",
    "final groupedRestaurants = restaurantMode ? _restaurantGroups(items) : const <_RestaurantGroup>[];",
    "itemCount: restaurantMode ? groupedRestaurants.length : items.length",
]

missing = [marker for marker in required_markers if marker not in text]
if missing:
    raise SystemExit(
        'Restaurant grouping is not fully wired in discover_screen.dart. Missing: '
        + ', '.join(missing)
    )

# These declarations must exist exactly once. The previous version of this script
# used a broad string replacement and duplicated both lines on every Codemagic run.
unique_declarations = [
    "final restaurantMode = filter.category == 'Restoranlar';",
    "final groupedRestaurants = restaurantMode ? _restaurantGroups(items) : const <_RestaurantGroup>[];",
]
for declaration in unique_declarations:
    count = text.count(declaration)
    if count != 1:
        raise SystemExit(
            f'Expected exactly one occurrence of {declaration!r}, found {count}. '
            'Refusing to continue with a duplicated Discover build.'
        )

print('Restaurant grouping already present; build patch validation passed.')
