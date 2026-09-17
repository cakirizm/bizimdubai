part of '../main.dart';

const _discoverRed = Color(0xFFE30613);
String _checkedDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
IconData _categoryIcon(String category) =>
    discoverCategories.firstWhere((c) => c.title == category).icon;

Future<void> _discoverOpen(BuildContext context, Uri uri) async {
  try {
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
  } catch (_) {/* Report a failed handoff to the user. */}
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Bağlantı açılamadı. Cihazınızın bağlantı ve uygulama ayarlarını kontrol edin.')));
  }
}

/// Seed images are official-source snapshots. Updated URLs use the live image,
/// never a stale photograph belonging to another version of the listing.
class DiscoverImage extends StatelessWidget {
  const DiscoverImage(
      {super.key,
      required this.photo,
      this.fit = BoxFit.cover,
      this.fallbackAsset,
      this.maxDecodeWidth = 1200});
  final DiscoverPhoto photo;
  final BoxFit fit;
  final String? fallbackAsset;
  final int maxDecodeWidth;
  static final _bundledUrls = {
    for (final entry in DiscoverCatalog.parse(discoverSeedJson).entries)
      for (final p in entry.photos) p.asset: p.url,
  };
  @override
  Widget build(BuildContext context) {
    Widget fallback() => fallbackAsset != null
        ? Image.asset(
            fallbackAsset!,
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            cacheWidth: 900,
            filterQuality: FilterQuality.medium)
        : Container(
            color: const Color(0xFFF3F0F1),
            alignment: Alignment.center,
            child: const Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.image_not_supported_outlined, color: Colors.grey),
              SizedBox(height: 6),
              Text('Fotoğraf yüklenemedi',
                  style: TextStyle(color: Colors.grey, fontSize: 12))
            ]));
    if (photo.asset != null && _bundledUrls[photo.asset] == photo.url) {
      return LayoutBuilder(builder: (context, constraints) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final logicalWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final decodeWidth =
            (logicalWidth * dpr).round().clamp(320, maxDecodeWidth).toInt();
        return Image.asset(photo.asset!,
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            cacheWidth: decodeWidth,
            filterQuality: FilterQuality.medium,
            semanticLabel: photo.caption,
            errorBuilder: (_, __, ___) => fallback());
      });
    }
    return LayoutBuilder(builder: (context, constraints) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final logicalWidth = constraints.hasBoundedWidth
          ? constraints.maxWidth
          : MediaQuery.sizeOf(context).width;
      final decodeWidth =
          (logicalWidth * dpr).round().clamp(320, maxDecodeWidth).toInt();
      return Image.network(photo.url,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: decodeWidth,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
          semanticLabel: photo.caption,
          errorBuilder: (_, __, ___) => fallback(),
          loadingBuilder: (_, child, loading) => loading == null
              ? child
              : const ColoredBox(color: Color(0xFFF3F0F1)));
    });
  }
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key, this.initialCategory, this.repository});
  final String? initialCategory;
  final DiscoverRepository? repository;
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with WidgetsBindingObserver {
  DiscoverRepository get repo => widget.repository ?? discoverRepository;
  late DiscoverFilter filter = DiscoverFilter()
    ..category = widget.initialCategory;
  final search = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    search.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(repo.refresh());
  }

  void reset() => setState(() {
        filter = DiscoverFilter();
        search.clear();
      });
  Future<void> categories() async {
    final choice = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        builder: (context) => FractionallySizedBox(
            heightFactor: .85,
            child: Column(children: [
              ListTile(
                  title: const Text('Tüm kategoriler',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  trailing: IconButton(
                      tooltip: 'Kapat',
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context))),
              Expanded(
                  child: ListView(children: [
                ListTile(
                    leading:
                        const Icon(Icons.apps_rounded, color: _discoverRed),
                    title: const Text('Tümünü keşfet'),
                    onTap: () => Navigator.pop(context, '*')),
                for (final c in discoverCategories)
                  ListTile(
                      leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFEEF0),
                          foregroundColor: _discoverRed,
                          child: Icon(c.icon)),
                      title: Text(c.title),
                      subtitle: Text(
                          '${repo.catalog.entries.where((e) => e.categories.contains(c.title)).length} kayıt'),
                      trailing: filter.category == c.title
                          ? const Icon(Icons.check_circle, color: _discoverRed)
                          : const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pop(context, c.title)),
              ])),
            ])));
    if (choice != null && mounted) {
      setState(() => filter.category = choice == '*' ? null : choice);
    }
  }

  Future<void> filters() async {
    final areas = repo.catalog.entries.map((e) => e.area).toSet().toList()
      ..sort();
    // Edits stay local until Apply. Dismissing the sheet leaves results intact.
    String? area = filter.area, type = filter.entityType;
    var menu = filter.menuOnly,
        turkish = filter.turkishOnly,
        saved = filter.favoritesOnly;
    var sort = filter.sort;
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        builder: (sheetContext) => StatefulBuilder(
            builder: (context, update) => SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    20, 18, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        const Expanded(
                            child: Text('Keşfini özelleştir',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800))),
                        IconButton(
                            tooltip: 'Kapat',
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close))
                      ]),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                          initialValue: areas.contains(area) ? area : null,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Bölge', border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('Tüm bölgeler')),
                            ...areas.map((a) =>
                                DropdownMenuItem(value: a, child: Text(a)))
                          ],
                          onChanged: (v) => update(() => area = v)),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                          initialValue: type,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Kayıt türü',
                              border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(
                                value: null,
                                child: Text('İşletmeler ve profesyoneller')),
                            DropdownMenuItem(
                                value: 'business', child: Text('İşletmeler')),
                            DropdownMenuItem(
                                value: 'professional',
                                child: Text('Profesyoneller'))
                          ],
                          onChanged: (v) => update(() => type = v)),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                          initialValue: sort,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Sıralama',
                              border: OutlineInputBorder()),
                          items: [
                            'Önerilen sıra',
                            'Ada göre A–Z',
                            'Son kontrol tarihi'
                          ]
                              .map((v) =>
                                  DropdownMenuItem(value: v, child: Text(v)))
                              .toList(),
                          onChanged: (v) => update(() => sort = v!)),
                      SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Menüsü yayımlananlar'),
                          value: menu,
                          onChanged: (v) => update(() => menu = v)),
                      SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Türkçe hizmet'),
                          subtitle: const Text(
                              'Kaynağında Türkçe hizmet bilgisi bulunanlar'),
                          value: turkish,
                          onChanged: (v) => update(() => turkish = v)),
                      SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Sadece favorilerim'),
                          value: saved,
                          onChanged: (v) => update(() => saved = v)),
                      FilledButton(
                          key: const ValueKey('apply-discover-filters'),
                          onPressed: () {
                            setState(() {
                              filter.area = area;
                              filter.entityType = type;
                              filter.menuOnly = menu;
                              filter.turkishOnly = turkish;
                              filter.favoritesOnly = saved;
                              filter.sort = sort;
                            });
                            Navigator.pop(sheetContext);
                          },
                          child: const Text('Filtreleri uygula')),
                      TextButton(
                          onPressed: () {
                            reset();
                            Navigator.pop(sheetContext);
                          },
                          child: const Text('Tüm filtreleri temizle')),
                    ]))));
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: AnimatedBuilder(
          animation: repo,
          builder: (context, _) {
            final items = filter.apply(repo);
            final restaurantMode = filter.category == 'Restoranlar';
            final groupedRestaurants = restaurantMode ? _restaurantGroups(items) : const <_RestaurantGroup>[];
            final restaurantMode = filter.category == 'Restoranlar';
            final groupedRestaurants = restaurantMode ? _restaurantGroups(items) : const <_RestaurantGroup>[];
            return RefreshIndicator(
                onRefresh: () => repo.refresh(force: true),
                child: CustomScrollView(
                    key: const PageStorageKey('discover-scroll'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          sliver: SliverToBoxAdapter(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  if (Navigator.canPop(context))
                                    IconButton(
                                        tooltip: 'Geri',
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                            Icons.arrow_back_ios_new,
                                            size: 20)),
                                  const SizedBox(
                                      width: 36,
                                      height: 46,
                                      child: BrandLogo(size: 40)),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text('Keşfet',
                                            style: TextStyle(
                                                fontSize: 29,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: -.8)),
                                        Text('Şehri birlikte keşfedelim',
                                            style: TextStyle(
                                                color: Color(0xFF727985),
                                                fontSize: 13))
                                      ])),
                                  IconButton.filledTonal(
                                      tooltip: 'Favorilerim',
                                      isSelected: filter.favoritesOnly,
                                      onPressed: () => setState(() =>
                                          filter.favoritesOnly =
                                              !filter.favoritesOnly),
                                      icon: Icon(
                                          filter.favoritesOnly
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: _discoverRed)),
                                ]),
                                const SizedBox(height: 22),
                                TextField(
                                    controller: search,
                                    onChanged: (q) =>
                                        setState(() => filter.query = q),
                                    decoration: InputDecoration(
                                        hintText: 'Mekan, kişi veya hizmet ara',
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon: search.text.isEmpty
                                            ? null
                                            : IconButton(
                                                tooltip: 'Aramayı temizle',
                                                onPressed: () => setState(() {
                                                      search.clear();
                                                      filter.query = '';
                                                    }),
                                                icon: const Icon(Icons.close)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFE7E8EC))),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFE7E8EC))))),
                                const SizedBox(height: 14),
                                Wrap(spacing: 8, runSpacing: 6, children: [
                                  ActionChip(
                                      avatar: const Icon(
                                          Icons.grid_view_rounded,
                                          size: 18),
                                      label: Text(
                                          filter.category ?? 'Tüm kategoriler'),
                                      onPressed: categories),
                                  ActionChip(
                                      key: const ValueKey('discover-filters'),
                                      avatar: const Icon(Icons.tune_rounded,
                                          size: 18),
                                      label: Text(filter.count == 0
                                          ? 'Filtrele'
                                          : 'Filtrele (${filter.count})'),
                                      onPressed: filters),
                                  if (filter.category != null ||
                                      filter.count > 0 ||
                                      search.text.isNotEmpty)
                                    ActionChip(
                                        label: const Text('Temizle'),
                                        onPressed: reset),
                                ]),
                                const SizedBox(height: 16),
                                Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFFFEEF0),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                              Icons.travel_explore_rounded,
                                              color: _discoverRed),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                const Text(
                                                    'Tanıdık bir bağ, yeni keşifler',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800)),
                                                const SizedBox(height: 4),
                                                Text(
                                                    '${repo.catalog.entries.length} kaynaklı kayıt · ${discoverCategories.length} kategori',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF785960))),
                                              ]))
                                        ])),
                                const SizedBox(height: 18),
                                Row(children: [
                                  Expanded(
                                      child: Text(
                                          filter.category ??
                                              'Senin için keşifler',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800))),
                                  Text(restaurantMode ? '${groupedRestaurants.length} restoran · ${items.length} şube' : '${items.length} sonuç',
                                      style: const TextStyle(
                                          color: Color(0xFF747B87),
                                          fontSize: 12))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Text(
                                          'Veri kontrolü: ${_checkedDate(repo.catalog.updatedAt)}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF747B87)))),
                                  IconButton(
                                      tooltip: 'Verileri yenile',
                                      onPressed: repo.refreshing
                                          ? null
                                          : () => repo.refresh(force: true),
                                      icon: repo.refreshing
                                          ? const SizedBox(
                                              width: 17,
                                              height: 17,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2))
                                          : const Icon(Icons.refresh, size: 19))
                                ]),
                                if (repo.updateError != null)
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Text(repo.updateError!,
                                          style: const TextStyle(
                                              color: Color(0xFF8B4A25),
                                              fontSize: 12))),
                              ]))),
                      if (items.isEmpty)
                        SliverToBoxAdapter(
                            child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(children: [
                                  const Icon(Icons.search_off,
                                      size: 48, color: Colors.grey),
                                  const SizedBox(height: 12),
                                  const Text('Bu filtrelerle kayıt bulunamadı.',
                                      textAlign: TextAlign.center),
                                  TextButton(
                                      onPressed: reset,
                                      child: const Text('Tüm kayıtları göster'))
                                ]))),
                      SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverList.builder(
                              itemCount: restaurantMode ? groupedRestaurants.length : items.length,
                              itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 18),
                                  child: restaurantMode
                                      ? _RestaurantGroupCard(group: groupedRestaurants[index], repository: repo)
                                      : DiscoverCard(item: items[index], repository: repo)))),
                    ]));
          }));
}


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

class DiscoverCard extends StatelessWidget {
  const DiscoverCard({super.key, required this.item, required this.repository});
  final DiscoverItem item;
  final DiscoverRepository repository;
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          key: ValueKey('discover-${item.id}'),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) =>
                      PlaceDetailPage(item: item, repository: repository))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AspectRatio(
                aspectRatio: 1.85,
                child: Stack(fit: StackFit.expand, children: [
                  DiscoverImage(
                      photo: item.photos.first,
                      fallbackAsset: item.category == 'Restoranlar' ? 'assets/images/home/restaurant.jpg' : null,
                      fit: item.entityType == 'professional'
                          ? BoxFit.contain
                          : BoxFit.cover),
                  Positioned(
                      top: 12,
                      left: 12,
                      right: 64,
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .96),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(item.kind,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700))))),
                  Positioned(
                      top: 5,
                      right: 6,
                      child: IconButton.filled(
                          tooltip: repository.favorites.contains(item.id)
                              ? 'Favorilerden çıkar'
                              : 'Favorilere ekle',
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: _discoverRed),
                          onPressed: () => repository.toggleFavorite(item.id),
                          icon: Icon(repository.favorites.contains(item.id)
                              ? Icons.favorite
                              : Icons.favorite_border))),
                ])),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -.3)),
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(_categoryIcon(item.category),
                            size: 15, color: _discoverRed),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text(item.area,
                                style: const TextStyle(
                                    color: Color(0xFF747B87), fontSize: 13))),
                        const Icon(Icons.arrow_forward_rounded,
                            color: _discoverRed, size: 19)
                      ]),
                      const SizedBox(height: 9),
                      Text(item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFF555E6B),
                              height: 1.4,
                              fontSize: 13)),
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, runSpacing: 6, children: [
                        _DiscoverTag(icon: Icons.link, text: 'Kaynaklı bilgi'),
                        if (item.menuUrl != null)
                          const _DiscoverTag(
                              icon: Icons.menu_book_outlined, text: 'Menü'),
                        if (item.turkishService)
                          const _DiscoverTag(
                              icon: Icons.chat_bubble_outline, text: 'Türkçe'),
                      ]),
                    ])),
          ])));
}

class _DiscoverTag extends StatelessWidget {
  const _DiscoverTag({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(7)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: const Color(0xFF6A7480)),
        const SizedBox(width: 5),
        Flexible(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7480))))
      ]));
}

class PlaceDetailPage extends StatefulWidget {
  const PlaceDetailPage(
      {super.key, required this.item, this.repository, this.openLink});
  final DiscoverItem item;
  final DiscoverRepository? repository;
  final Future<void> Function(Uri)? openLink;
  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  DiscoverRepository get repo => widget.repository ?? discoverRepository;
  int page = 0;
  Future<void> open(Uri uri) =>
      widget.openLink?.call(uri) ?? _discoverOpen(context, uri);
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: repo,
      builder: (context, _) {
        final item = repo.find(widget.item.id);
        if (item == null) {
          return Scaffold(
              appBar: AppBar(title: const Text('Kayıt güncellendi')),
              body: const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                          'Bu kayıt artık yayımlanmıyor. Güncel yerleri Keşfet ekranından inceleyebilirsiniz.'))));
        }
        return Scaffold(
            backgroundColor: const Color(0xFFF7F8FA),
            appBar: AppBar(title: const Text('Mekan & hizmet'), actions: [
              IconButton(
                  tooltip: 'Favori',
                  onPressed: () => repo.toggleFavorite(item.id),
                  icon: Icon(
                      repo.favorites.contains(item.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _discoverRed))
            ]),
            body: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: AspectRatio(
                          aspectRatio: 1.5,
                          child: Stack(children: [
                            PageView.builder(
                                key: ValueKey(
                                    'gallery-${item.id}-${repo.catalog.revision}'),
                                itemCount: item.photos.length,
                                onPageChanged: (v) => setState(() => page = v),
                                itemBuilder: (_, index) => GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (_) => DiscoverGallery(
                                                photos: item.photos,
                                                initialPage: index))),
                                    child: DiscoverImage(
                                        photo: item.photos[index],
                                        fallbackAsset: item.category == 'Restoranlar' ? 'assets/images/home/restaurant.jpg' : null,
                                        fit: item.entityType == 'professional'
                                            ? BoxFit.contain
                                            : BoxFit.cover))),
                            Positioned(
                                right: 12,
                                bottom: 12,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              '${(page.clamp(0, item.photos.length - 1)) + 1} / ${item.photos.length}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.open_in_full,
                                              color: Colors.white, size: 12),
                                        ]))),
                          ]))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                          item.photos[page.clamp(0, item.photos.length - 1)]
                              .caption,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF737B87)))),
                  const SizedBox(height: 10),
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 27,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -.6)),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    _DiscoverTag(
                        icon: _categoryIcon(item.category), text: item.kind),
                    _DiscoverTag(
                        icon: Icons.location_on_outlined, text: item.area),
                    if (item.turkishService)
                      const _DiscoverTag(
                          icon: Icons.chat_bubble_outline,
                          text: 'Türkçe hizmet')
                  ]),
                  const SizedBox(height: 20),
                  Text(item.subtitle,
                      style: const TextStyle(
                          fontSize: 15, height: 1.6, color: Color(0xFF505968))),
                  const SizedBox(height: 20),
                  if (item.menuUrl != null)
                    FilledButton.icon(
                        onPressed: () => open(Uri.parse(item.menuUrl!)),
                        icon: const Icon(Icons.menu_book_outlined),
                        label: const Text('Resmî menüyü aç')),
                  if (item.category == 'Restoranlar' && item.menuUrl == null)
                    const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                            'Güncel menü bağlantısı yayımlanmamış. Menü için işletmeyle iletişime geçebilirsiniz.',
                            style: TextStyle(
                                color: Color(0xFF737B87), fontSize: 13))),
                  OutlinedButton.icon(
                      onPressed: () => open(Uri.parse(item.website)),
                      icon: const Icon(Icons.language),
                      label: const Text('Resmî site / profil')),
                  if (item.phone != null)
                    OutlinedButton.icon(
                        onPressed: () =>
                            open(Uri(scheme: 'tel', path: item.phone)),
                        icon: const Icon(Icons.call_outlined),
                        label: Text(item.phone!)),
                  if (item.whatsapp != null)
                    OutlinedButton.icon(
                        onPressed: () => open(Uri.https(
                            'wa.me', '/${item.whatsapp!.substring(1)}')),
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('WhatsApp ile iletişim')),
                  if (item.phone == null)
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                            'Yayımlanmış telefon bilgisi yok. İletişim için resmî profili ziyaret edin.',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF737B87)))),
                  const SizedBox(height: 22),
                  const Text('Konum & ulaşım',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: _discoverRed),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: SelectableText(
                                          item.address ??
                                              'Sabit ziyaret adresi yayımlanmamış. Randevu yerini profesyonelle görüşerek belirleyin.',
                                          style: const TextStyle(height: 1.5)))
                                ]),
                            if (item.hasLocation) ...[
                              const SizedBox(height: 12),
                              Text(
                                  item.latitude == null
                                      ? 'Adres ile rota araması açılır. Seçilen şubeyi haritada kontrol edin.'
                                      : 'İşletmenin yayımladığı koordinatlara yönlendirilir.',
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF737B87))),
                              const SizedBox(height: 10),
                              FilledButton.icon(
                                  key: const ValueKey('google-directions'),
                                  onPressed: () =>
                                      open(item.directions('google')),
                                  icon: const Icon(Icons.map_outlined),
                                  label: const Text('Google Maps ile git')),
                              OutlinedButton.icon(
                                  key: const ValueKey('waze-directions'),
                                  onPressed: () =>
                                      open(item.directions('waze')),
                                  icon:
                                      const Icon(Icons.directions_car_outlined),
                                  label: const Text('Waze ile git')),
                            ],
                          ])),
                  if (item.rating != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                            '★ ${item.rating} / 5 · ${item.ratingLabel}\nCanlı puan değildir. Kontrol: ${_checkedDate(item.checkedAt)}',
                            style: const TextStyle(fontSize: 12, height: 1.5))),
                  const SizedBox(height: 24),
                  ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text('Bilgi kaynakları',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(
                          'Son kontrol: ${_checkedDate(item.checkedAt)}',
                          style: const TextStyle(fontSize: 12)),
                      children: [
                        const Text(
                            'Bilgiler aşağıdaki yayımlanmış kaynaklardan derlendi. Menü, fiyat ve hizmet koşulları için güncel işletme sayfasını kontrol edin.',
                            style: TextStyle(fontSize: 12, height: 1.5)),
                        for (final source in {
                          ...item.sources,
                          ...item.photos.map((p) => p.source),
                          if (item.coordinateSource != null)
                            item.coordinateSource!,
                          if (item.ratingSource != null) item.ratingSource!
                        })
                          ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.open_in_new, size: 18),
                              title: Text(Uri.parse(source).host,
                                  style: const TextStyle(fontSize: 13)),
                              subtitle: Text(Uri.parse(source).path,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11)),
                              onTap: () => open(Uri.parse(source))),
                      ]),
                ]));
      });
}

class DiscoverGallery extends StatefulWidget {
  const DiscoverGallery(
      {super.key, required this.photos, required this.initialPage});
  final List<DiscoverPhoto> photos;
  final int initialPage;
  @override
  State<DiscoverGallery> createState() => _DiscoverGalleryState();
}

class _DiscoverGalleryState extends State<DiscoverGallery> {
  late final controller = PageController(initialPage: widget.initialPage);
  late int index = widget.initialPage;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text('Fotoğraflar · ${index + 1}/${widget.photos.length}')),
      body: Column(children: [
        Expanded(
            child: PageView.builder(
                controller: controller,
                itemCount: widget.photos.length,
                onPageChanged: (v) => setState(() => index = v),
                itemBuilder: (_, i) => InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: DiscoverImage(
                        photo: widget.photos[i], fit: BoxFit.contain)))),
        SafeArea(
            top: false,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(widget.photos[index].caption,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13))))
      ]));
}
