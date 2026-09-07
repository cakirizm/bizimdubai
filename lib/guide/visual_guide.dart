part of '../main.dart';

const _guideVisualRed = Color(0xFFE30613);
const _guideVisualInk = Color(0xFF15171B);
const _guideVisualMuted = Color(0xFF707782);

String _guideVisualAsset(GuideArticle article) {
  switch (article.id) {
    case 'sim':
    case 'emirates-id':
    case 'uae-pass':
      return 'assets/images/home/community.jpg';
    case 'bank-account':
      return 'assets/images/home/dubai.jpg';
    case 'rent-home':
    case 'ejari':
    case 'dewa':
    case 'home-internet':
      return 'assets/images/home/homes.jpg';
    case 'nol':
    case 'driving-licence':
    case 'vehicle-registration':
    case 'salik-parking':
      return 'assets/images/discover/auto.jpg';
    case 'health-insurance':
      return 'assets/images/home/health.jpg';
    case 'schools':
      return 'assets/images/home/education.jpg';
    case 'employment':
      return 'assets/images/home/community.jpg';
    case 'leaving-dubai':
      return 'assets/images/home/dubai.jpg';
    default:
      return 'assets/images/home/dubai.jpg';
  }
}

GuideArticle _guideById(String id) => guideArticles.firstWhere((article) => article.id == id);

class VisualGuidePage extends StatefulWidget {
  const VisualGuidePage({super.key});

  @override
  State<VisualGuidePage> createState() => _VisualGuidePageState();
}

class _VisualGuidePageState extends State<VisualGuidePage> {
  final _searchController = TextEditingController();
  String query = '';
  String? category;

  static const _primaryCategories = <(String, IconData)>[
    ('Yeni Geldim', Icons.flight_land_rounded),
    ('Kimlik & Resmî', Icons.badge_outlined),
    ('Ev & Yaşam', Icons.home_rounded),
    ('Banka & Para', Icons.account_balance_rounded),
    ('Araç & Ulaşım', Icons.directions_car_rounded),
    ('Sağlık', Icons.favorite_rounded),
  ];

  static const _featuredIds = <String>[
    'sim',
    'bank-account',
    'ejari',
    'dewa',
    'driving-licence',
    'health-insurance',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final items = guideArticles.where((article) {
      final categoryMatches = category == null || article.category == category;
      final haystack = '${article.title} ${article.subtitle} ${article.category} ${article.steps.join(' ')}'.toLowerCase();
      return categoryMatches && (normalized.isEmpty || haystack.contains(normalized));
    }).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final featured = [for (final id in _featuredIds) _guideById(id)];

    return SafeArea(
      child: CustomScrollView(
        key: const ValueKey('visual-guide-scroll'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandHeader(compact: true),
                  const SizedBox(height: 16),
                  _GuideVisualHero(
                    onOpenJourney: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const VisualGuideJourneyPage()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const ValueKey('guide-search'),
                    controller: _searchController,
                    onChanged: (value) => setState(() => query = value),
                    decoration: InputDecoration(
                      hintText: 'Rehberde ara… Ehliyet, banka, Ejari',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: query.isEmpty
                          ? IconButton(
                              tooltip: 'Filtreler',
                              onPressed: () {},
                              icon: const Icon(Icons.tune_rounded),
                            )
                          : IconButton(
                              tooltip: 'Aramayı temizle',
                              onPressed: () => setState(() {
                                query = '';
                                _searchController.clear();
                              }),
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFFE7E9ED)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFFE7E9ED)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _GuideCategoryGrid(
                    selected: category,
                    categories: _primaryCategories,
                    onChanged: (value) => setState(() => category = category == value ? null : value),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final extra in guideCategories.where((c) => !_primaryCategories.any((p) => p.$1 == c.$1)))
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(extra.$1),
                              avatar: Icon(extra.$2, size: 16),
                              selected: category == extra.$1,
                              onSelected: (_) => setState(() => category = category == extra.$1 ? null : extra.$1),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _GuideSectionRow(
                    title: 'Öne Çıkan Rehberler',
                    action: 'Tümünü gör',
                    onTap: () => setState(() {
                      query = '';
                      category = null;
                      _searchController.clear();
                    }),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    key: const ValueKey('guide-featured-grid'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featured.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 10,
                      childAspectRatio: .72,
                    ),
                    itemBuilder: (_, index) => _GuideVisualFeatureCard(article: featured[index]),
                  ),
                  const SizedBox(height: 24),
                  _GuideSectionRow(title: category ?? 'Tüm Rehberler', action: '${items.length} konu'),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Bu aramayla eşleşen rehber bulunamadı.')),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: _GuideVisualLibraryCard(article: items[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideVisualHero extends StatelessWidget {
  const _GuideVisualHero({required this.onOpenJourney});
  final VoidCallback onOpenJourney;

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        color: Colors.black,
        child: InkWell(
          key: const ValueKey('guide-hero'),
          onTap: onOpenJourney,
          child: SizedBox(
            height: 260,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/home/dubai.jpg', fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x10000000), Color(0xD9000000)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text('YENİ GELENLER İÇİN', style: TextStyle(color: _guideVisualRed, fontSize: 9, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Dubai’ye\nyeni mi geldin?',
                        style: TextStyle(color: Colors.white, fontSize: 30, height: .98, fontWeight: FontWeight.w900, letterSpacing: -.8),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'SIM → Emirates ID → UAE Pass → banka → ev → Ejari',
                        style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.35, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(width: 34, height: 3, decoration: BoxDecoration(color: _guideVisualRed, borderRadius: BorderRadius.circular(99))),
                          const SizedBox(width: 9),
                          const Text('Adım adım yol haritası', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_forward_rounded, color: _guideVisualRed),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _GuideCategoryGrid extends StatelessWidget {
  const _GuideCategoryGrid({required this.selected, required this.categories, required this.onChanged});
  final String? selected;
  final List<(String, IconData)> categories;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => GridView.builder(
        key: const ValueKey('guide-category-grid'),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 9,
          mainAxisSpacing: 9,
          childAspectRatio: 1.18,
        ),
        itemBuilder: (_, index) {
          final item = categories[index];
          final isSelected = selected == item.$1;
          return Material(
            color: isSelected ? _guideVisualRed : const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('guide-category-${item.$1}'),
              onTap: () => onChanged(item.$1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.$2, color: isSelected ? Colors.white : _guideVisualInk, size: 25),
                    const SizedBox(height: 8),
                    Text(
                      item.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isSelected ? Colors.white : _guideVisualInk, fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

class _GuideSectionRow extends StatelessWidget {
  const _GuideSectionRow({required this.title, required this.action, this.onTap});
  final String title, action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -.4))),
          if (onTap != null)
            TextButton(onPressed: onTap, child: Text(action))
          else
            Text(action, style: const TextStyle(color: _guideVisualMuted, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      );
}

class _GuideVisualFeatureCard extends StatelessWidget {
  const _GuideVisualFeatureCard({required this.article});
  final GuideArticle article;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => VisualGuideArticlePage(article: article))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(_guideVisualAsset(article), fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x00000000), Color(0x66000000)]),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      bottom: 7,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(article.icon, color: _guideVisualRed, size: 17),
                      ),
                    ),
                    if (article.featured)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: _guideVisualRed, borderRadius: BorderRadius.circular(7)),
                          child: const Text('ÖNEMLİ', style: TextStyle(color: Colors.white, fontSize: 7.5, fontWeight: FontWeight.w900)),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, height: 1.15, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Expanded(child: Text(article.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, height: 1.2, color: _guideVisualMuted, fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _GuideVisualLibraryCard extends StatelessWidget {
  const _GuideVisualLibraryCard({required this.article});
  final GuideArticle article;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('guide-article-${article.id}'),
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => VisualGuideArticlePage(article: article))),
          child: SizedBox(
            height: 104,
            child: Row(
              children: [
                SizedBox(
                  width: 106,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(_guideVisualAsset(article), fit: BoxFit.cover),
                      Container(color: Colors.black.withValues(alpha: .08)),
                      Center(
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), shape: BoxShape.circle),
                          child: Icon(article.icon, color: _guideVisualRed, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, height: 1.15, fontWeight: FontWeight.w900))),
                            const Icon(Icons.chevron_right_rounded, color: _guideVisualRed, size: 20),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(7)),
                              child: Text(article.category, style: const TextStyle(color: _guideVisualRed, fontSize: 8.5, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 7),
                            Text('${article.steps.length} adım', style: const TextStyle(color: _guideVisualMuted, fontSize: 9.5, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class VisualGuideJourneyPage extends StatelessWidget {
  const VisualGuideJourneyPage({super.key});

  static const _ids = <String>[
    'sim',
    'emirates-id',
    'uae-pass',
    'bank-account',
    'rent-home',
    'ejari',
    'dewa',
    'nol',
    'health-insurance',
    'driving-licence',
  ];

  @override
  Widget build(BuildContext context) {
    final items = [for (final id in _ids) _guideById(id)];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC80613),
        foregroundColor: Colors.white,
        title: const Text('Yeni gelenler yol haritası', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        key: const ValueKey('guide-journey-list'),
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 34),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(-18, 0, -18, 16),
            height: 205,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/home/dubai.jpg', fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x55C80613), Color(0xE6C80613)]),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text('Doğru adımlar,\ndaha güçlü başlangıç.', style: TextStyle(color: Colors.white, fontSize: 26, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -.5)),
                      SizedBox(height: 7),
                      Text('10 temel işlemi doğru sıraya koyduk.', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < items.length; i++)
            _GuideJourneyStep(index: i, article: items[i], isLast: i == items.length - 1),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: _guideVisualRed, minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => VisualGuideArticlePage(article: items.first))),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Hemen Başla', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _GuideJourneyStep extends StatelessWidget {
  const _GuideJourneyStep({required this.index, required this.article, required this.isLast});
  final int index;
  final GuideArticle article;
  final bool isLast;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 42,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: _guideVisualRed,
                    foregroundColor: Colors.white,
                    child: Text('${index + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: const Color(0xFFF1A4AA))),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: ValueKey('guide-journey-${article.id}'),
                    onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => VisualGuideArticlePage(article: article))),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(width: 70, child: Image.asset(_guideVisualAsset(article), fit: BoxFit.cover)),
                          const SizedBox(width: 12),
                          Container(width: 36, height: 36, decoration: const BoxDecoration(color: Color(0xFFFFECEE), shape: BoxShape.circle), child: Icon(article.icon, color: _guideVisualRed, size: 19)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 3),
                                Text(article.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _guideVisualMuted, fontSize: 10.5)),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 10), child: Icon(Icons.chevron_right_rounded, color: _guideVisualMuted)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class VisualGuideArticlePage extends StatelessWidget {
  const VisualGuideArticlePage({super.key, required this.article});
  final GuideArticle article;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: CustomScrollView(
          key: ValueKey('guide-detail-${article.id}'),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 270,
              backgroundColor: Colors.white,
              foregroundColor: _guideVisualInk,
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border_rounded)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(_guideVisualAsset(article), fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x10000000), Color(0x66000000)]),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      bottom: 18,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(article.icon, color: _guideVisualRed, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 34),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(article.title, style: const TextStyle(fontSize: 28, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -.7)),
                  const SizedBox(height: 8),
                  Text(article.subtitle, style: const TextStyle(color: _guideVisualMuted, fontSize: 14, height: 1.45, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  _GuideQuickFact(article: article),
                  const SizedBox(height: 22),
                  const _GuideVisualHeader(icon: Icons.format_list_numbered_rounded, title: 'Adım adım'),
                  const SizedBox(height: 10),
                  for (var i = 0; i < article.steps.length; i++) _GuideVisualStep(index: i, text: article.steps[i]),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 600;
                      final prepare = _GuidePreparePanel(article: article);
                      final place = _GuidePlacePanel(article: article);
                      return stacked
                          ? Column(children: [prepare, const SizedBox(height: 12), place])
                          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: prepare), const SizedBox(width: 12), Expanded(child: place)]);
                    },
                  ),
                  const SizedBox(height: 22),
                  const _GuideVisualHeader(icon: Icons.verified_outlined, title: 'Resmî kaynaklar'),
                  const SizedBox(height: 10),
                  for (final link in article.links) _GuideOfficialLink(article: article, link: link),
                  if (article.tips.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _GuideVisualHeader(icon: Icons.lightbulb_outline_rounded, title: 'İşe yarayan notlar'),
                    const SizedBox(height: 10),
                    _GuideTipsPanel(tips: article.tips),
                  ],
                  if (article.warning != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(18)),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.info_outline_rounded, color: _guideVisualRed),
                        const SizedBox(width: 10),
                        Expanded(child: Text(article.warning!, style: const TextStyle(height: 1.4, fontWeight: FontWeight.w700))),
                      ]),
                    ),
                  ],
                  const SizedBox(height: 18),
                  FilledButton(
                    key: const ValueKey('guide-primary-action'),
                    style: FilledButton.styleFrom(backgroundColor: _guideVisualRed, minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    onPressed: article.links.isEmpty ? null : () => _openGuideUrl(context, article.links.first.url),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Resmî İşleme Git', style: TextStyle(fontWeight: FontWeight.w900)), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded)]),
                  ),
                  const SizedBox(height: 12),
                  const Text('Son kontrol: Eylül 2026. Ücretler, uygunluk ve belgeler değişebilir; işlem yapmadan önce resmî kaynağı aç.', textAlign: TextAlign.center, style: TextStyle(color: _guideVisualMuted, fontSize: 10.5, height: 1.35)),
                ]),
              ),
            ),
          ],
        ),
      );
}

class _GuideQuickFact extends StatelessWidget {
  const _GuideQuickFact({required this.article});
  final GuideArticle article;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Container(width: 38, height: 38, decoration: const BoxDecoration(color: _guideVisualRed, shape: BoxShape.circle), child: Icon(article.icon, color: Colors.white, size: 20)),
            const SizedBox(width: 11),
            Expanded(child: Text('${article.steps.length} adım · ${article.links.length} resmî kaynak · ${article.places.length} lokasyon', style: const TextStyle(fontSize: 12, height: 1.35, fontWeight: FontWeight.w800))),
            const Icon(Icons.chevron_right_rounded, color: _guideVisualRed),
          ],
        ),
      );
}

class _GuideVisualHeader extends StatelessWidget {
  const _GuideVisualHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: _guideVisualRed, size: 21),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -.3)),
      ]);
}

class _GuideVisualStep extends StatelessWidget {
  const _GuideVisualStep({required this.index, required this.text});
  final int index;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 14, backgroundColor: _guideVisualRed, foregroundColor: Colors.white, child: Text('${index + 1}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900))),
            const SizedBox(width: 11),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45, fontWeight: FontWeight.w600))),
          ],
        ),
      );
}

class _GuidePreparePanel extends StatelessWidget {
  const _GuidePreparePanel({required this.article});
  final GuideArticle article;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [Icon(Icons.description_outlined, color: _guideVisualRed, size: 20), SizedBox(width: 8), Text('Hazırla', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))]),
            const SizedBox(height: 10),
            for (final item in article.checklist)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_circle_rounded, color: _guideVisualRed, size: 17),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 11.5, height: 1.3, fontWeight: FontWeight.w700))),
                ]),
              ),
          ],
        ),
      );
}

class _GuidePlacePanel extends StatelessWidget {
  const _GuidePlacePanel({required this.article});
  final GuideArticle article;

  @override
  Widget build(BuildContext context) {
    if (article.places.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.location_on_outlined, color: _guideVisualRed, size: 20), SizedBox(width: 8), Text('Nereye gidebilirim?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))]),
          SizedBox(height: 12),
          Text('Bu işlem için zorunlu fiziksel merkez belirtilmiyor. Önce resmî online kanalı kullan.', style: TextStyle(color: _guideVisualMuted, height: 1.4, fontSize: 12)),
        ]),
      );
    }

    final place = article.places.first;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.location_on_outlined, color: _guideVisualRed, size: 20), SizedBox(width: 8), Text('Nereye gidebilirim?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))]),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(height: 92, width: double.infinity, child: Image.asset(_guideVisualAsset(article), fit: BoxFit.cover))),
          const SizedBox(height: 9),
          Text(place.name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(place.area, style: const TextStyle(color: _guideVisualMuted, fontSize: 10.5)),
          if (place.note.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(place.note, style: const TextStyle(fontSize: 10.5, height: 1.3))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => _openGuideUrl(context, _guideMapUri(place.query).toString()), icon: const Icon(Icons.map_outlined, size: 16), label: const Text('Maps', style: TextStyle(fontSize: 11)))),
              const SizedBox(width: 7),
              Expanded(child: OutlinedButton.icon(onPressed: () => _openGuideUrl(context, _guideWazeUri(place.query).toString()), icon: const Icon(Icons.directions_car_outlined, size: 16), label: const Text('Waze', style: TextStyle(fontSize: 11)))),
            ],
          ),
          if (article.places.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('+ ${article.places.length - 1} alternatif lokasyon daha', style: const TextStyle(color: _guideVisualRed, fontSize: 10.5, fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }
}

class _GuideOfficialLink extends StatelessWidget {
  const _GuideOfficialLink({required this.article, required this.link});
  final GuideArticle article;
  final GuideLink link;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: ListTile(
          onTap: () => _openGuideUrl(context, link.url),
          leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(13)), child: Icon(article.icon, color: _guideVisualRed, size: 20)),
          title: Text(link.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
          subtitle: Text(link.note.isEmpty ? Uri.parse(link.url).host : link.note, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: _guideVisualMuted)),
          trailing: const Icon(Icons.open_in_new_rounded, color: _guideVisualRed, size: 18),
        ),
      );
}

class _GuideTipsPanel extends StatelessWidget {
  const _GuideTipsPanel({required this.tips});
  final List<String> tips;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFFFFF8E8), borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            for (final tip in tips)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFFD89500), size: 17),
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip, style: const TextStyle(fontSize: 11.5, height: 1.35, fontWeight: FontWeight.w700))),
                ]),
              ),
          ],
        ),
      );
}
