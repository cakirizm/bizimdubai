from pathlib import Path

path = Path('lib/discover/discover_screen.dart')
text = path.read_text()

# Make restaurant images resilient: keep the real remote image first, then use the
# app's bundled restaurant photography instead of a blank/error card if hotlinking
# or a CDN temporarily fails.
text = text.replace(
"  const DiscoverImage(\n      {super.key, required this.photo, this.fit = BoxFit.cover});\n  final DiscoverPhoto photo;\n  final BoxFit fit;",
"  const DiscoverImage(\n      {super.key, required this.photo, this.fit = BoxFit.cover, this.fallbackAsset});\n  final DiscoverPhoto photo;\n  final BoxFit fit;\n  final String? fallbackAsset;"
)
text = text.replace(
"    Widget fallback() => Container(\n        color: const Color(0xFFF3F0F1),\n        alignment: Alignment.center,\n        child: const Column(mainAxisSize: MainAxisSize.min, children: [\n          Icon(Icons.image_not_supported_outlined, color: Colors.grey),\n          SizedBox(height: 6),\n          Text('Fotoğraf yüklenemedi',\n              style: TextStyle(color: Colors.grey, fontSize: 12))\n        ]));",
"    Widget fallback() => fallbackAsset != null\n        ? Image.asset(fallbackAsset!, fit: fit, width: double.infinity, height: double.infinity)\n        : Container(\n            color: const Color(0xFFF3F0F1),\n            alignment: Alignment.center,\n            child: const Column(mainAxisSize: MainAxisSize.min, children: [\n              Icon(Icons.image_not_supported_outlined, color: Colors.grey),\n              SizedBox(height: 6),\n              Text('Fotoğraf yüklenemedi',\n                  style: TextStyle(color: Colors.grey, fontSize: 12))\n            ]));"
)

# Restaurant grouping helpers + branch chooser page.
marker = "class DiscoverCard extends StatelessWidget {"
insert = r'''
String _restaurantBrandName(DiscoverItem item) {
  var name = item.name.split(' · ').first.trim();
  name = name.replaceAll(' (JBR)', '');
  if (name.startsWith('Bosporus')) return 'Bosporus Turkish Cuisine';
  if (name.startsWith('ZouZou')) return 'ZouZou Turkish & Lebanese';
  if (name.startsWith('Hafiz Mustafa') || name.startsWith('Hafız Mustafa')) {
    return 'Hafiz Mustafa 1864';
  }
  if (name.startsWith('MADO')) return 'MADO';
  if (name.startsWith('Turkish Village')) return 'Turkish Village';
  if (name.startsWith('ODÖNER') || name.startsWith('ODONER')) return 'ODÖNER';
  return name;
}

class _RestaurantGroup {
  const _RestaurantGroup(this.name, this.branches);
  final String name;
  final List<DiscoverItem> branches;
  DiscoverItem get hero => branches.first;
}

List<_RestaurantGroup> _restaurantGroups(List<DiscoverItem> items) {
  final map = <String, List<DiscoverItem>>{};
  for (final item in items.where((e) => e.category == 'Restoranlar')) {
    map.putIfAbsent(_restaurantBrandName(item), () => <DiscoverItem>[]).add(item);
  }
  return map.entries.map((e) => _RestaurantGroup(e.key, e.value)).toList();
}

class _RestaurantGroupCard extends StatelessWidget {
  const _RestaurantGroupCard({required this.group, required this.repository});
  final _RestaurantGroup group;
  final DiscoverRepository repository;

  @override
  Widget build(BuildContext context) {
    final hero = group.hero;
    final areas = group.branches.map((e) => e.area).toSet().take(3).join(' · ');
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('discover-${hero.id}'),
        onTap: () {
          if (group.branches.length == 1) {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (_) => PlaceDetailPage(item: hero, repository: repository)));
          } else {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (_) => _RestaurantBranchesPage(group: group, repository: repository)));
          }
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: 1.85,
            child: Stack(fit: StackFit.expand, children: [
              DiscoverImage(photo: hero.photos.first, fallbackAsset: 'assets/images/home/restaurant.jpg'),
              Positioned(
                left: 12, top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: .96), borderRadius: BorderRadius.circular(10)),
                  child: Text(group.branches.length > 1 ? '${group.branches.length} şube' : 'Türk restoranı',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))))
            ])),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(group.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -.3)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 15, color: _discoverRed),
                const SizedBox(width: 6),
                Expanded(child: Text(areas, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF747B87), fontSize: 13))),
                const Icon(Icons.arrow_forward_rounded, color: _discoverRed, size: 19)
              ]),
              if (group.branches.length > 1) ...[
                const SizedBox(height: 9),
                Text('Şubeleri görüntüle, ardından seçtiğin şubenin menü, telefon, Google Maps ve Waze bilgilerine ulaş.',
                  style: const TextStyle(color: Color(0xFF555E6B), height: 1.4, fontSize: 13)),
              ]
            ]))
        ])));
  }
}

class _RestaurantBranchesPage extends StatelessWidget {
  const _RestaurantBranchesPage({required this.group, required this.repository});
  final _RestaurantGroup group;
  final DiscoverRepository repository;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F8FA),
    appBar: AppBar(title: Text(group.name)),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      children: [
        Text('${group.branches.length} Dubai şubesi', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('Şubeyi seç; adres, telefon, menü ve yol tarifi o şubeye özel açılır.',
          style: TextStyle(color: Color(0xFF68717D), height: 1.4)),
        const SizedBox(height: 16),
        for (final branch in group.branches)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: ValueKey('branch-${branch.id}'),
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                  builder: (_) => PlaceDetailPage(item: branch, repository: repository))),
                child: Row(children: [
                  SizedBox(width: 112, height: 104,
                    child: DiscoverImage(photo: branch.photos.first, fallbackAsset: 'assets/images/home/restaurant.jpg')),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(branch.name.split(' · ').length > 1 ? branch.name.split(' · ').sublist(1).join(' · ') : branch.area,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      Text(branch.area, style: const TextStyle(color: Color(0xFF747B87), fontSize: 12)),
                      const SizedBox(height: 5),
                      if (branch.rating != null)
                        Text('★ ${branch.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Row(children: [
                        if (branch.menuUrl != null) const _DiscoverTag(icon: Icons.menu_book_outlined, text: 'Menü'),
                        const SizedBox(width: 6),
                        const _DiscoverTag(icon: Icons.directions_outlined, text: 'Yol tarifi')
                      ])
                    ])))
                ]))))
      ]));
}

'''
if insert not in text:
    text = text.replace(marker, insert + marker)

# Use grouped restaurant cards when Restoranlar is selected.
text = text.replace(
"            final items = filter.apply(repo);",
"            final items = filter.apply(repo);\n            final restaurantMode = filter.category == 'Restoranlar';\n            final groupedRestaurants = restaurantMode ? _restaurantGroups(items) : const <_RestaurantGroup>[];"
)
text = text.replace(
"                                  Text('${items.length} sonuç',",
"                                  Text(restaurantMode ? '${groupedRestaurants.length} restoran · ${items.length} şube' : '${items.length} sonuç',"
)
old_list = """                      SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverList.builder(
                              itemCount: items.length,
                              itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 18),
                                  child: DiscoverCard(
                                      item: items[index], repository: repo)))),"""
new_list = """                      SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverList.builder(
                              itemCount: restaurantMode ? groupedRestaurants.length : items.length,
                              itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 18),
                                  child: restaurantMode
                                      ? _RestaurantGroupCard(group: groupedRestaurants[index], repository: repo)
                                      : DiscoverCard(item: items[index], repository: repo)))),"""
text = text.replace(old_list, new_list)

# Use the local restaurant photography fallback on every restaurant image in cards/details.
text = text.replace(
"                  DiscoverImage(\n                      photo: item.photos.first,\n                      fit: item.entityType == 'professional'\n                          ? BoxFit.contain\n                          : BoxFit.cover),",
"                  DiscoverImage(\n                      photo: item.photos.first,\n                      fallbackAsset: item.category == 'Restoranlar' ? 'assets/images/home/restaurant.jpg' : null,\n                      fit: item.entityType == 'professional'\n                          ? BoxFit.contain\n                          : BoxFit.cover),"
)
text = text.replace(
"                                    child: DiscoverImage(\n                                        photo: item.photos[index],\n                                        fit: item.entityType == 'professional'",
"                                    child: DiscoverImage(\n                                        photo: item.photos[index],\n                                        fallbackAsset: item.category == 'Restoranlar' ? 'assets/images/home/restaurant.jpg' : null,\n                                        fit: item.entityType == 'professional'"
)

path.write_text(text)
print('Restaurant grouping/photo fallback patch applied')
