import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const BizimDubaiApp());

const brand = Color(0xFFE51B2B);
const ink = Color(0xFF17181C);
const muted = Color(0xFF7B818C);
const canvas = Color(0xFFF6F7F9);
const logoAsset = 'assets/images/logo.png';

class BizimDubaiApp extends StatelessWidget {
  const BizimDubaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bizim Dubai',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: brand),
        fontFamily: 'SF Pro Display',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1.3),
          headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -.9),
          titleLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -.5),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(height: 1.35),
          bodyMedium: TextStyle(height: 1.35),
        ),
      ),
      home: const SplashGate(),
    );
  }
}

class BrandLogo extends StatelessWidget {
  final double size;
  final bool shadow;
  const BrandLogo({super.key, this.size = 52, this.shadow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .08),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * .3),
        border: Border.all(color: const Color(0xFFEFF0F2)),
        boxShadow: shadow
            ? const [BoxShadow(color: Color(0x17000000), blurRadius: 18, offset: Offset(0, 7))]
            : null,
      ),
      child: Image.asset(
        logoAsset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => const _FallbackBrandMark(),
      ),
    );
  }
}

class _FallbackBrandMark extends StatelessWidget {
  const _FallbackBrandMark();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(bottom: 5, child: Container(width: 6, height: 30, decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(4)))),
        Positioned(bottom: 5, left: 8, child: Container(width: 8, height: 19, decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(4)))),
        Positioned(bottom: 5, right: 8, child: Container(width: 8, height: 16, decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(4)))),
        Positioned(bottom: 1, left: 5, child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: brand, shape: BoxShape.circle))),
        Positioned(bottom: 1, right: 5, child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: brand, shape: BoxShape.circle))),
      ],
    );
  }
}

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});
  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fade;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    fade = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    scale = Tween(begin: .84, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    controller.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: const AppShell()),
      ));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brand,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1518684079-3c830dcef090?auto=format&fit=crop&w=1400&q=90',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33000000), Color(0x8895000A), Color(0xF0B20A16)],
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: fade,
              child: ScaleTransition(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const BrandLogo(size: 122),
                      const SizedBox(height: 26),
                      const Text('Bizim Dubai', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1.8)),
                      const SizedBox(height: 10),
                      const Text('Dubai’de Türklerin yanında', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white24)),
                        child: const Text('🇹🇷 Aynı kültür. Aynı şehir. Tek topluluk.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5)),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  final pages = const [HomeScreen(), DiscoverScreen(), CommunityScreen(), GuideScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: pages)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 26, offset: Offset(0, -7))],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          height: 72,
          indicatorColor: const Color(0xFFFFE7EA),
          selectedIndex: index,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
            NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Keşfet'),
            NavigationDestination(icon: Icon(Icons.groups_2_rounded), label: 'Topluluk'),
            NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Rehber'),
            NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(viewportFraction: 1);
  int page = 0;
  Timer? timer;

  final slides = const [
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1518684079-3c830dcef090?auto=format&fit=crop&w=1400&q=90',
      eyebrow: 'BİZİM DUBAİ',
      title: 'Dubai’de Türk topluluğu daha güçlü.',
      subtitle: 'Mekanlar, etkinlikler, rehberler ve günlük hayat tek uygulamada.',
      cta: 'Keşfet',
    ),
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1400&q=88',
      eyebrow: 'TÜRK MEKANLARI',
      title: 'En sevilen Türk mekanlarını keşfet.',
      subtitle: 'Gerçek mekanlar, güçlü öneriler ve tek dokunuşla yol tarifi.',
      cta: 'Mekanlara git',
    ),
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?auto=format&fit=crop&w=1400&q=88',
      eyebrow: 'TOPLULUK',
      title: 'Dubai’de yalnız değilsin.',
      subtitle: 'Buluşmalar, spor aktiviteleri, aile etkinlikleri ve daha fazlası.',
      cta: 'Topluluğa katıl',
    ),
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1400&q=88',
      eyebrow: 'REHBER',
      title: 'Dubai’de işini daha hızlı çöz.',
      subtitle: 'Ev, sağlık, ulaşım, eğitim ve günlük yaşam için pratik rehberler.',
      cta: 'Rehbere git',
    ),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!pageController.hasClients) return;
      final next = (page + 1) % slides.length;
      pageController.animateToPage(next, duration: const Duration(milliseconds: 580), curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const AppHeader(),
              const SizedBox(height: 18),
              SizedBox(
                height: 335,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => page = i),
                  itemBuilder: (_, i) => HeroCard(slide: slides[i]),
                ),
              ),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: page == i ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(color: page == i ? brand : const Color(0xFFD5D7DB), borderRadius: BorderRadius.circular(20)),
                )),
              ),
              const SizedBox(height: 30),
              const SectionTitle('Hızlı erişim', trailing: 'Tümünü gör'),
              const SizedBox(height: 14),
              const QuickAccessGrid(),
              const SizedBox(height: 30),
              const SectionTitle('Senin için önerilenler', trailing: 'Tümünü gör'),
              const SizedBox(height: 14),
              SizedBox(
                height: 258,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    VenueCard(image: 'https://www.citysearch.ae/UF/Albums/43186/bosporus-jbr-dubai_133819976.jpg', title: 'Bosporus Turkish Cuisine', meta: 'JBR · Türk mutfağı', rating: '4.9'),
                    VenueCard(image: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=900&q=85', title: 'MADO Dubai Mall', meta: 'Downtown · Tatlı & Kahvaltı', rating: '4.8'),
                    VenueCard(image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=900&q=85', title: 'ZouZou JBR', meta: 'JBR · Restoran', rating: '4.7'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const SectionTitle('Yaklaşan etkinlikler', trailing: 'Tümünü gör'),
              const SizedBox(height: 12),
              const EventCard(date: '12\nEyl', title: 'Türk Topluluğu Buluşması', meta: 'Dubai Marina · 19:00 – 22:00', image: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=500&q=84'),
              const EventCard(date: '13\nEyl', title: 'Cuma Halı Saha', meta: 'Al Quoz · 21:00 · 9/14 kişi', image: 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?auto=format&fit=crop&w=500&q=84'),
              const SizedBox(height: 28),
              const CommunityCallout(),
              const SizedBox(height: 14),
            ]),
          ),
        ),
      ],
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const BrandLogo(size: 54),
      const SizedBox(width: 12),
      const Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bizim Dubai', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: -1.1, color: ink)),
          SizedBox(height: 2),
          Text('Dubai’de Türklerin yanında', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 12.8)),
        ]),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFECEDEF))),
        child: const Row(children: [Icon(Icons.location_on_rounded, color: brand, size: 18), SizedBox(width: 4), Text('Dubai', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))]),
      ),
      const SizedBox(width: 8),
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFECEDEF))),
        child: Stack(alignment: Alignment.center, children: [
          const Icon(Icons.notifications_none_rounded, color: ink, size: 22),
          Positioned(top: 7, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: brand, shape: BoxShape.circle))),
        ]),
      ),
    ]);
  }
}

class HeroSlide {
  final String image;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String cta;
  const HeroSlide({required this.image, required this.eyebrow, required this.title, required this.subtitle, required this.cta});
}

class HeroCard extends StatelessWidget {
  final HeroSlide slide;
  const HeroCard({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(fit: StackFit.expand, children: [
        Image.network(slide.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFB90F1B))),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x12000000), Color(0x33000000), Color(0xD9000000)],
            ),
          ),
        ),
        Positioned(
          left: 22,
          right: 22,
          bottom: 23,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white24)),
              child: Text(slide.eyebrow, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 10),
            Text(slide.title, style: const TextStyle(color: Colors.white, fontSize: 31, height: 1.04, fontWeight: FontWeight.w900, letterSpacing: -1.15)),
            const SizedBox(height: 9),
            Text(slide.subtitle, style: const TextStyle(color: Color(0xFFF2F2F2), fontSize: 14.5, fontWeight: FontWeight.w500, height: 1.35)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(999)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(slide.cta, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(width: 7),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class QuickItem {
  final String title;
  final String subtitle;
  final String image;
  const QuickItem(this.title, this.subtitle, this.image);
}

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      QuickItem('Restoranlar', 'Türk mutfağı ve daha fazlası', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Market & Gıda', 'Türk ürünleri kapında', 'https://images.unsplash.com/photo-1543168256-418811576931?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Sağlık', 'Doktor, klinik ve eczane', 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Güzellik', 'Kuaför, bakım ve estetik', 'https://images.unsplash.com/photo-1562322140-8baeececf3df?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Ev & Emlak', 'Kiralık, satılık ve danışmanlık', 'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Eğitim', 'Okul, kurs ve özel ders', 'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Spor', 'Aktivite, PT ve wellness', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=700&q=84'),
      QuickItem('İkinci El', 'Al, sat, değerlendir', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=700&q=84'),
      QuickItem('Diğer Kategoriler', 'Tüm hizmetleri keşfet', 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=700&q=84'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: .73,
      ),
      itemBuilder: (_, i) => QuickAccessCard(item: items[i]),
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  final QuickItem item;
  const QuickAccessCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9EBEF)),
        boxShadow: const [BoxShadow(color: Color(0x09000000), blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFEEF1), child: const Icon(Icons.image_outlined, color: brand, size: 32)),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.2, fontWeight: FontWeight.w800, height: 1.08, color: ink)),
                const SizedBox(height: 4),
                Expanded(child: Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.6, color: muted, fontWeight: FontWeight.w600, height: 1.18))),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final String image;
  final String title;
  final String meta;
  final String rating;
  const VenueCard({super.key, required this.image, required this.title, required this.meta, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(height: 145, width: double.infinity, child: Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE8EA)))),
            Positioned(top: 10, right: 10, child: Container(width: 35, height: 35, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, size: 20))),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
              const SizedBox(height: 4),
              Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 9),
              Row(children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFB400), size: 19),
                const SizedBox(width: 3),
                Text(rating, style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                const Icon(Icons.location_on_outlined, size: 17, color: muted),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String title;
  final String meta;
  final String image;
  const EventCard({super.key, required this.date, required this.title, required this.meta, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFECEEF1))),
      child: Row(children: [
        Container(width: 50, height: 62, decoration: BoxDecoration(color: const Color(0xFFFFEDF0), borderRadius: BorderRadius.circular(16)), alignment: Alignment.center, child: Text(date, textAlign: TextAlign.center, style: const TextStyle(color: brand, fontWeight: FontWeight.w900, height: 1.05))),
        const SizedBox(width: 10),
        ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: 68, height: 62, child: Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F3F5))))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 5),
          Text(meta, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 12.2)),
        ])),
        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: muted),
      ]),
    );
  }
}

class CommunityCallout extends StatelessWidget {
  const CommunityCallout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFEFF1), Color(0xFFFFFAFA)]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFDDE2)),
      ),
      child: const Row(children: [
        CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Icon(Icons.groups_2_rounded, color: brand, size: 27)),
        SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Türk topluluğuna katıl', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: ink)),
          SizedBox(height: 3),
          Text('Etkinlikler, duyurular ve yeni bağlantılar', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 12.8)),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, color: brand, size: 18),
      ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionTitle(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ink, letterSpacing: -.6))),
      if (trailing != null) Row(mainAxisSize: MainAxisSize.min, children: [
        Text(trailing!, style: const TextStyle(color: brand, fontWeight: FontWeight.w700, fontSize: 13.3)),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_rounded, color: brand, size: 16),
      ]),
    ]);
  }
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Keşfet', subtitle: 'Gerçek Türk mekanları ve Türkçe hizmet noktaları.');
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Topluluk', subtitle: 'Dubai’deki Türklerle buluş, etkinliklere katıl.');
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Rehber', subtitle: 'Dubai’de günlük hayatı adım adım çöz.');
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Profil', subtitle: 'Favoriler, ilanlar, etkinlikler ve ayarlar.');
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  const PlaceholderPage({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
      children: [
        const AppHeader(),
        const SizedBox(height: 34),
        Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 24),
        Container(
          height: 220,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), border: Border.all(color: const Color(0xFFECEEF1))),
          alignment: Alignment.center,
          child: const Column(mainAxisSize: MainAxisSize.min, children: [
            BrandLogo(size: 72),
            SizedBox(height: 14),
            Text('Bu ekran sıradaki adımda aynı tasarım diliyle tamamlanacak.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, color: muted)),
          ]),
        ),
      ],
    );
  }
}
