part of '../main.dart';

const _homeRed = Color(0xFFED1730);
const _homeInk = Color(0xFF16181D);
const _homeMuted = Color(0xFF777D88);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep the existing application theme; use native typography on Home only.
    final homeTheme = Theme.of(context).copyWith(
      textTheme: Theme.of(context)
          .textTheme
          .apply(fontFamily: '.SF Pro Text', bodyColor: _homeInk),
    );
    return Theme(
        data: homeTheme,
        child: DefaultTextStyle(
            style: homeTheme.textTheme.bodyMedium!,
            child: SafeArea(
                child: ListView(
              key: const ValueKey('home-scroll'),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
              children: [
                const HomeHeader(),
                const SizedBox(height: 16),
                const HomeCarousel(),
                const SizedBox(height: 20),
                HomeSectionHeading(
                    title: 'Hızlı erişim',
                    onTap: () => openHomeDestination(
                        context, const DiscoverPage(), 'Tüm kategoriler')),
                const SizedBox(height: 12),
                const HomeQuickAccessGrid(),
                const SizedBox(height: 24),
                HomeSectionHeading(
                    title: 'Senin için önerilenler',
                    onTap: () => openHomeDestination(
                        context,
                        const HomeRecommendationsPage(),
                        'Senin için önerilenler')),
                const SizedBox(height: 12),
                const HomeRecommendations(),
              ],
            ))));
  }
}

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});
  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool unread = true;

  Widget _controls(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              foregroundColor: _homeInk,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFE9EBEF)),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 44)),
          onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Şehrin',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w800)),
                            ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                    CupertinoIcons.location_solid,
                                    color: _homeRed),
                                title: const Text('Dubai'),
                                subtitle: const Text(
                                    'Mekanlar ve hizmetler Dubai için listelenir.'),
                                trailing:
                                    const Icon(Icons.check, color: _homeRed),
                                onTap: () => Navigator.pop(context)),
                          ])))),
          icon: const Icon(CupertinoIcons.location_solid,
              size: 17, color: _homeRed),
          label: const Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Dubai',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            SizedBox(width: 5),
            Icon(CupertinoIcons.chevron_down, size: 11)
          ]),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE9EBEF))),
            child: Stack(clipBehavior: Clip.none, children: [
              IconButton(
                  tooltip: 'Bildirimler',
                  constraints:
                      const BoxConstraints(minWidth: 44, minHeight: 44),
                  icon: const Icon(CupertinoIcons.bell,
                      size: 23, color: _homeInk),
                  onPressed: () {
                    setState(() => unread = false);
                    showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        builder: (context) => const SafeArea(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(22, 0, 22, 28),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Bildirimler',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800)),
                                      SizedBox(height: 18),
                                      Text('Bizim Dubai’ye hoş geldin',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 8),
                                      Text(
                                          'Mekanları keşfet, yaşam rehberini incele ve Dubai’deki Türk topluluğuyla tanış.',
                                          style: TextStyle(
                                              height: 1.5, color: _homeMuted)),
                                    ]))));
                  }),
              if (unread)
                Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                        child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                                color: _homeRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 1.5))))),
            ])),
      ]);

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final stacked = constraints.maxWidth < 350 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.2;
        final identity = Row(children: [
          const BrandLogo(size: 42),
          const SizedBox(width: 7),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: 'Bizim ', style: TextStyle(color: _homeInk)),
                      TextSpan(text: 'Dubai', style: TextStyle(color: _homeRed))
                    ]),
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.9,
                        height: 1.1)),
                const SizedBox(height: 3),
                Text('Dubai’de Türklerin yanında',
                    style: TextStyle(
                        fontSize: stacked ? 12 : 9.5,
                        color: _homeMuted,
                        height: 1.3)),
              ])),
        ]);
        if (stacked) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                identity,
                const SizedBox(height: 9),
                Align(
                    alignment: Alignment.centerRight, child: _controls(context))
              ]);
        }
        return Row(children: [
          Expanded(child: identity),
          const SizedBox(width: 6),
          _controls(context)
        ]);
      });
}

class HomePhoto extends StatelessWidget {
  const HomePhoto(this.name, {super.key, this.alignment = Alignment.center});
  final String name;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/home/$name.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: alignment,
          excludeFromSemantics: true);
}

class HomeSlideData {
  const HomeSlideData(this.photo, this.badge, this.title, this.subtitle,
      this.cta, this.destination);
  final String photo, badge, title, subtitle, cta;
  final Widget destination;
}

const _homeSlides = [
  HomeSlideData(
      'dubai',
      'BİZİM DUBAİ',
      'Dubai’de Türk topluluğu daha güçlü',
      'Mekanlar, etkinlikler, fırsatlar ve daha fazlası tek uygulamada.',
      'Keşfet',
      DiscoverPage()),
  HomeSlideData(
      'restaurant',
      'TÜRK MEKANLARI',
      'Tanıdık lezzetler, yeni favoriler',
      'Türk restoranlarını ve şehrin buluşma noktalarını keşfet.',
      'Mekanlara git',
      DiscoverPage(initialCategory: 'Restoranlar')),
  HomeSlideData(
      'community',
      'TOPLULUK',
      'Dubai’de yalnız değilsin',
      'Buluşmalar, spor aktiviteleri ve yeni dostluklar.',
      'Topluluğa git',
      CommunityPage()),
  HomeSlideData(
      'homes',
      'YAŞAM REHBERİ',
      'Yeni hayatına güvenle başla',
      'Dubai’de günlük hayat için pratik bilgiler bir arada.',
      'Rehbere git',
      GuidePage()),
];

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});
  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel>
    with WidgetsBindingObserver {
  final controller = PageController();
  Timer? timer;
  int selected = 0;
  bool touching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restartTimer();
  }

  void _restartTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted ||
          touching ||
          !controller.hasClients ||
          !TickerMode.getValuesNotifier(context).value.enabled ||
          MediaQuery.disableAnimationsOf(context) ||
          ModalRoute.of(context)?.isCurrent == false ||
          WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        return;
      }
      _show((selected + 1) % _homeSlides.length);
    });
  }

  void _show(int index) => controller.animateToPage(index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _restartTimer();
    } else {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        double height = (constraints.maxWidth * .65).clamp(265.0, 380.0);
        double measured(String text, TextStyle style, double maxWidth) {
          final painter = TextPainter(
              text: TextSpan(
                  text: text,
                  style: DefaultTextStyle.of(context).style.merge(style)),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context))
            ..layout(maxWidth: maxWidth);
          final result = painter.height;
          painter.dispose();
          return result;
        }

        final contentWidth = constraints.maxWidth - 44;
        for (final slide in _homeSlides) {
          final titleHeight = measured(slide.title, HomeHeroCard.titleStyle,
              contentWidth.clamp(0.0, 285.0));
          final subtitleHeight = measured(slide.subtitle,
              HomeHeroCard.subtitleStyle, contentWidth.clamp(0.0, 295.0));
          final badgeHeight =
              measured(slide.badge, HomeHeroCard.badgeStyle, contentWidth);
          final requiredHeight = 19 +
              30 +
              8 +
              9 +
              12 +
              titleHeight +
              subtitleHeight +
              badgeHeight +
              (20 * scale + 24).clamp(44.0, double.infinity) +
              8;
          if (requiredHeight > height) height = requiredHeight;
        }
        return SizedBox(
            height: height,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(children: [
                  Listener(
                      onPointerDown: (_) => touching = true,
                      onPointerUp: (_) {
                        touching = false;
                        _restartTimer();
                      },
                      onPointerCancel: (_) => touching = false,
                      child: PageView.builder(
                          key: const ValueKey('home-carousel'),
                          controller: controller,
                          itemCount: _homeSlides.length,
                          onPageChanged: (value) =>
                              setState(() => selected = value),
                          itemBuilder: (context, index) =>
                              HomeHeroCard(slide: _homeSlides[index]))),
                  Positioned(
                      bottom: 8,
                      right: 10,
                      child: Row(
                          children: List.generate(
                              _homeSlides.length,
                              (index) => Semantics(
                                  label:
                                      '${index + 1}. poster: ${_homeSlides[index].badge}',
                                  selected: selected == index,
                                  child: IconButton(
                                      tooltip: '${index + 1}. posteri göster',
                                      onPressed: () {
                                        _show(index);
                                        _restartTimer();
                                      },
                                      constraints: const BoxConstraints(
                                          minWidth: 32, minHeight: 44),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      icon: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: selected == index ? 18 : 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                              color: selected == index
                                                  ? _homeRed
                                                  : const Color(0xFFADB0B5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8)))))))),
                ])));
      });
}

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({super.key, required this.slide});
  final HomeSlideData slide;
  static const titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 29,
      height: 1.04,
      letterSpacing: -.8,
      fontWeight: FontWeight.w800);
  static const subtitleStyle =
      TextStyle(color: Color(0xFFF3F3F4), fontSize: 13, height: 1.4);
  static const badgeStyle = TextStyle(
      color: Colors.white,
      fontSize: 9,
      height: 1.2,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w700);
  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
        HomePhoto(slide.photo),
        const DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xAC000000), Color(0x38000000)]))),
        Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () =>
                    openHomeDestination(context, slide.destination, slide.cta),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 19, 22, 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(slide.badge, style: badgeStyle),
                          const SizedBox(height: 8),
                          SizedBox(
                              width: 285,
                              child: Text(slide.title, style: titleStyle)),
                          const SizedBox(height: 9),
                          SizedBox(
                              width: 295,
                              child:
                                  Text(slide.subtitle, style: subtitleStyle)),
                          const SizedBox(height: 12),
                          FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: _homeRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19, vertical: 12),
                                  minimumSize: const Size(0, 44)),
                              onPressed: () => openHomeDestination(
                                  context, slide.destination, slide.cta),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(slide.cta,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 8),
                                    const Icon(CupertinoIcons.arrow_right,
                                        size: 17)
                                  ])),
                        ])))),
      ]);
}

class HomeSectionHeading extends StatelessWidget {
  const HomeSectionHeading(
      {super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.65,
                    height: 1.15))),
        const SizedBox(width: 8),
        TextButton(
            style: TextButton.styleFrom(
                foregroundColor: _homeRed,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 44)),
            onPressed: onTap,
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Tümünü gör',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              SizedBox(width: 5),
              Icon(CupertinoIcons.arrow_right, size: 14)
            ])),
      ]);
}

class HomeCategoryData {
  const HomeCategoryData(
      this.title, this.subtitle, this.photo, this.icon, this.category);
  final String title, subtitle;
  final String? photo, category;
  final IconData icon;
}

const _homeCategories = [
  HomeCategoryData('Restoranlar', 'Türk mutfağı ve daha fazlası', 'restaurant',
      Icons.restaurant, 'Restoranlar'),
  HomeCategoryData('Market & Gıda', 'Türk ürünleri kapınızda', 'market',
      CupertinoIcons.cart_fill, 'Market & Gıda'),
  HomeCategoryData('Sağlık', 'Hastane, klinik ve eczaneler', 'health',
      CupertinoIcons.heart_fill, 'Sağlık'),
  HomeCategoryData('Güzellik', 'Kuaför, bakım ve estetik', 'beauty',
      CupertinoIcons.scissors, 'Güzellik & Bakım'),
  HomeCategoryData('Ev & Emlak', 'Kiralık, satılık ve danışmanlık', 'homes',
      CupertinoIcons.house_fill, 'Ev & Emlak'),
  HomeCategoryData('Eğitim', 'Okullar, kurslar ve özel ders', 'education',
      CupertinoIcons.book_fill, 'Çocuk & Eğitim'),
  HomeCategoryData('Spor', 'Spor salonları ve aktiviteler', 'fitness',
      Icons.fitness_center, 'Spor & Wellness'),
  HomeCategoryData('İkinci El', 'Al, sat, değerlendir', 'furniture',
      CupertinoIcons.tag_fill, null),
  HomeCategoryData('Diğer Kategoriler', 'Tüm hizmetleri keşfet', null,
      CupertinoIcons.ellipsis, null),
];

class HomeQuickAccessGrid extends StatelessWidget {
  const HomeQuickAccessGrid({super.key});
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - 20) / 3;
        final photoHeight = width * .66;
        // Size rows from real text metrics instead of clipping Turkish descriptions.
        double textHeight = 0;
        for (final item in _homeCategories) {
          double measure(String text, TextStyle style) {
            final painter = TextPainter(
                text: TextSpan(text: text, style: style),
                textDirection: Directionality.of(context),
                textScaler: MediaQuery.textScalerOf(context))
              ..layout(maxWidth: width - 16);
            final height = painter.height;
            painter.dispose();
            return height;
          }

          final height = measure(item.title, HomeQuickAccessCard.titleStyle) +
              4 +
              measure(item.subtitle, HomeQuickAccessCard.subtitleStyle);
          if (height > textHeight) textHeight = height;
        }
        return GridView.builder(
            key: const ValueKey('home-categories'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _homeCategories.length,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: photoHeight + 21 + textHeight + 12),
            itemBuilder: (context, index) => HomeQuickAccessCard(
                item: _homeCategories[index], photoHeight: photoHeight));
      });
}

class HomeQuickAccessCard extends StatelessWidget {
  const HomeQuickAccessCard(
      {super.key, required this.item, required this.photoHeight});
  final HomeCategoryData item;
  final double photoHeight;
  static const titleStyle = TextStyle(
      fontFamily: '.SF Pro Text',
      fontSize: 12.5,
      height: 1.15,
      fontWeight: FontWeight.w700,
      color: _homeInk);
  static const subtitleStyle = TextStyle(
      fontFamily: '.SF Pro Text',
      fontSize: 10.5,
      height: 1.22,
      color: _homeMuted);
  @override
  Widget build(BuildContext context) {
    final more = item.photo == null;
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x04000000),
                  blurRadius: 12,
                  offset: Offset(0, 3))
            ]),
        child: Material(
          color: more ? const Color(0xFFFFEFF3) : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: more
                      ? const Color(0xFFFBE4EA)
                      : const Color(0xFFEBEDF1))),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              key: ValueKey('category-${item.title}'),
              onTap: () {
                if (item.title == 'İkinci El') {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const ClassifiedsPage()));
                } else {
                  openHomeDestination(context,
                      DiscoverPage(initialCategory: item.category), item.title);
                }
              },
              child: Column(
                  crossAxisAlignment: more
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    if (more)
                      SizedBox(
                          height: photoHeight + 21,
                          child: Center(child: _icon()))
                    else
                      SizedBox(
                          height: photoHeight + 21,
                          child: Stack(children: [
                            SizedBox(
                                height: photoHeight,
                                child: HomePhoto(item.photo!)),
                            Positioned(
                                left: 8, top: photoHeight - 22, child: _icon()),
                          ])),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                            crossAxisAlignment: more
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Text(item.title,
                                  textAlign:
                                      more ? TextAlign.center : TextAlign.start,
                                  style: titleStyle),
                              const SizedBox(height: 4),
                              Text(item.subtitle,
                                  textAlign:
                                      more ? TextAlign.center : TextAlign.start,
                                  style: subtitleStyle),
                            ])),
                  ])),
        ));
  }

  Widget _icon() => Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          color: const Color(0xFFFFE9EF),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withValues(alpha: .7))),
      child: Icon(item.icon, color: _homeRed, size: 21));
}

class HomeRecommendationData {
  const HomeRecommendationData(this.id, this.photo, this.badge, this.title,
      this.subtitle, this.meta, this.destination);
  final String id, photo, badge, title, subtitle, meta;
  final Widget destination;
}

final _homeRecommendations = [
  HomeRecommendationData(
      'bosporus',
      'restaurant',
      'Öne Çıkan',
      discoverItems[0].name,
      'Türk mutfağı · JBR',
      '4.9 · JBR',
      PlaceDetailPage(item: discoverItems[0])),
  HomeRecommendationData(
      'coffee',
      'dubai',
      'Etkinlik',
      featuredEvents[1].title,
      'Yeni tanışmalar, keyifli sohbetler',
      'Dubai Marina',
      EventDetailPage(event: featuredEvents[1])),
  HomeRecommendationData(
      'zouzou',
      'restaurant',
      'Mekan',
      discoverItems[2].name,
      'Türk & Lübnan mutfağı',
      '4.8 · JBR',
      PlaceDetailPage(item: discoverItems[2])),
];
// Home session favourites are shared between the rail and its full list.
final _homeFavorites = ValueNotifier<Set<String>>(<String>{});

class HomeRecommendations extends StatelessWidget {
  const HomeRecommendations({super.key});
  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return SizedBox(
        height: 252 + (scale - 1).clamp(0.0, 3.0) * 115,
        child: ListView.separated(
            key: const ValueKey('home-recommendations'),
            scrollDirection: Axis.horizontal,
            itemCount: _homeRecommendations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
                width: (MediaQuery.sizeOf(context).width * .72)
                    .clamp(235.0, 320.0),
                child:
                    HomeRecommendedCard(item: _homeRecommendations[index]))));
  }
}

class HomeRecommendedCard extends StatelessWidget {
  const HomeRecommendedCard({super.key, required this.item});
  final HomeRecommendationData item;
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFEBEDF1))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute<void>(builder: (_) => item.destination)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                height: 139,
                child: Stack(children: [
                  HomePhoto(item.photo),
                  Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 6),
                          decoration: BoxDecoration(
                              color: _homeRed,
                              borderRadius: BorderRadius.circular(9)),
                          child: Text(item.badge,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10)))),
                  Positioned(
                      right: 7,
                      top: 5,
                      child: ValueListenableBuilder<Set<String>>(
                          valueListenable: _homeFavorites,
                          builder: (context, favorites, _) {
                            final selected = favorites.contains(item.id);
                            return IconButton.filled(
                                tooltip: selected
                                    ? 'Favorilerden çıkar'
                                    : 'Favorilere ekle',
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        selected ? _homeRed : _homeInk),
                                onPressed: () {
                                  final next = Set<String>.of(favorites);
                                  selected
                                      ? next.remove(item.id)
                                      : next.add(item.id);
                                  _homeFavorites.value = next;
                                },
                                icon: Icon(
                                    selected
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
                                    size: 22));
                          })),
                ])),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.2)),
                      const SizedBox(height: 4),
                      Text(item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: _homeMuted, fontSize: 11, height: 1.25)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Icon(
                            item.badge == 'Etkinlik'
                                ? CupertinoIcons.location
                                : CupertinoIcons.star_fill,
                            color: item.badge == 'Etkinlik'
                                ? _homeMuted
                                : const Color(0xFFF4AB35),
                            size: 13),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(item.meta,
                                style: const TextStyle(
                                    fontSize: 10, color: _homeMuted)))
                      ]),
                    ])),
          ])));
}

class HomeRecommendationsPage extends StatelessWidget {
  const HomeRecommendationsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _homeRecommendations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, index) =>
          HomeRecommendedCard(item: _homeRecommendations[index]));
}
