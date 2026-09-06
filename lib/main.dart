import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const BizimDubaiApp());

const brand = Color(0xFFE51B2B);
const ink = Color(0xFF17181C);
const muted = Color(0xFF7B818C);
const canvas = Color(0xFFF6F7F9);

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
          headlineLarge: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1.4),
          headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1),
          titleLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -.4),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(height: 1.35),
          bodyMedium: TextStyle(height: 1.35),
        ),
      ),
      home: const SplashGate(),
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
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 950));
    fade = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    scale = Tween(begin: .84, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    controller.forward();
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1518684079-3c830dcef090?auto=format&fit=crop&w=1400&q=90',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFB90F1B)),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33000000), Color(0x88A8000B), Color(0xE6B20A16)],
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: fade,
              child: ScaleTransition(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 34),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 108,
                        height: 108,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 30, offset: Offset(0, 14))],
                        ),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 26),
                      const Text('Bizim Dubai', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1.8)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withOpacity(.28))),
                        child: const Text('🇹🇷 Dubai’de Türkçe hayat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                      const SizedBox(height: 20),
                      const Text('Aynı kültür. Aynı şehir.\nTek topluluk.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 21, height: 1.3)),
                      const Spacer(),
                      const Text('Mekanlar • Topluluk • Rehber • İlanlar', style: TextStyle(color: Color(0xFFEED8DB), fontWeight: FontWeight.w600, fontSize: 13)),
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
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 28, offset: Offset(0, -8))]),
        child: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          height: 74,
          indicatorColor: const Color(0xFFFFE5E8),
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
  final PageController pageController = PageController(viewportFraction: .92);
  int page = 0;
  Timer? timer;

  final slides = const [
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1518684079-3c830dcef090?auto=format&fit=crop&w=1400&q=88',
      eyebrow: 'BİZİM DUBAİ',
      title: 'Dubai’de Türk olmak artık daha kolay.',
      subtitle: 'Mekanlar, insanlar, etkinlikler ve günlük hayat cebinde.',
      cta: 'Keşfet',
    ),
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1400&q=88',
      eyebrow: 'TÜRK MEKANLARI',
      title: 'En sevilen Türk mekanlarını keşfet.',
      subtitle: 'Gerçek mekanlar, gerçek puanlar, tek dokunuşla yol tarifi.',
      cta: 'Mekanlara git',
    ),
    HeroSlide(
      image: 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?auto=format&fit=crop&w=1400&q=88',
      eyebrow: 'TOPLULUK',
      title: 'Dubai’de yalnız değilsin.',
      subtitle: 'Halı saha, kahve buluşmaları, aile etkinlikleri ve daha fazlası.',
      cta: 'Topluluğa katıl',
    ),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!pageController.hasClients) return;
      final next = (page + 1) % slides.length;
      pageController.animateToPage(next, duration: const Duration(milliseconds: 650), curve: Curves.easeInOutCubic);
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
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const AppHeader(),
              const SizedBox(height: 20),
              SizedBox(
                height: 310,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => page = i),
                  itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(right: 10), child: HeroCard(slide: slides[i])),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: page == i ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(color: page == i ? brand : const Color(0xFFD5D7DB), borderRadius: BorderRadius.circular(20)),
                )),
              ),
              const SizedBox(height: 28),
              const SectionTitle('Hızlı erişim'),
              const SizedBox(height: 14),
              const QuickAccessGrid(),
              const SizedBox(height: 30),
              const CommunityBanner(),
              const SizedBox(height: 30),
              const SectionTitle('Senin için önerilenler', trailing: 'Tümünü gör'),
              const SizedBox(height: 14),
              SizedBox(
                height: 250,
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
              const EventCard(date: '12\nEyl', title: 'Türk Topluluğu Buluşması', meta: 'Dubai Marina · 19:00 – 22:00', icon: Icons.people_alt_rounded),
              const EventCard(date: '13\nEyl', title: 'Cuma Halı Saha', meta: 'Al Quoz · 21:00 · 9/14 kişi', icon: Icons.sports_soccer_rounded),
              const SizedBox(height: 10),
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
      Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 6))]),
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      ),
      const SizedBox(width: 12),
      const Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bizim Dubai', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.2, color: ink)),
          SizedBox(height: 2),
          Text('Dubai’de Türklerin yanında', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFECEDEF))),
        child: const Row(children: [Icon(Icons.location_on_rounded, color: brand, size: 19), SizedBox(width: 5), Text('Dubai', style: TextStyle(fontWeight: FontWeight.w700))]),
      ),
      const SizedBox(width: 8),
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFECEDEF))),
        child: Stack(alignment: Alignment.center, children: [
          const Icon(Icons.notifications_none_rounded, color: ink),
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
        Image.network(slide.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFB60E19))),
        Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x10000000), Color(0xCC000000)]))),
        Positioned(
          left: 22,
          right: 22,
          bottom: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white24)),
              child: Text(slide.eyebrow, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 10),
            Text(slide.title, style: const TextStyle(color: Colors.white, fontSize: 30, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
            const SizedBox(height: 9),
            Text(slide.subtitle, style: const TextStyle(color: Color(0xFFF2F2F2), fontSize: 14.5, fontWeight: FontWeight.w500, height: 1.35)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(999)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Text(slide.cta, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), const SizedBox(width: 7), const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18)]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final items = const [
      QuickItem('Restoranlar', 'Türk mutfağı', Icons.restaurant_rounded, Color(0xFFFFE8EB)),
      QuickItem('Market & Gıda', 'Türk ürünleri', Icons.shopping_cart_rounded, Color(0xFFFFF1D9)),
      QuickItem('Sağlık', 'Türkçe hizmet', Icons.health_and_safety_rounded, Color(0xFFE6F7ED)),
      QuickItem('Güzellik', 'Bakım & kuaför', Icons.content_cut_rounded, Color(0xFFFFEAF4)),
      QuickItem('Ev & Emlak', 'Danışman & ev', Icons.home_work_rounded, Color(0xFFE8F1FF)),
      QuickItem('Eğitim', 'Çocuk & ders', Icons.school_rounded, Color(0xFFF0ECFF)),
      QuickItem('Spor', 'Aktivite & PT', Icons.fitness_center_rounded, Color(0xFFE5F6F7)),
      QuickItem('İkinci El', 'Al, sat, keşfet', Icons.sell_rounded, Color(0xFFFFEFE5)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 12, childAspectRatio: .82),
      itemBuilder: (_, i) => QuickAccessItem(item: items[i]),
    );
  }
}

class QuickItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  const QuickItem(this.title, this.subtitle, this.icon, this.tint);
}

class QuickAccessItem extends StatelessWidget {
  final QuickItem item;
  const QuickAccessItem({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFECEEF1))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(color: item.tint, borderRadius: BorderRadius.circular(15)), child: Icon(item.icon, color: brand, size: 24)),
        const SizedBox(height: 8),
        Text(item.title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: ink)),
        const SizedBox(height: 2),
        Text(item.subtitle, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: muted, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class CommunityBanner extends StatelessWidget {
  const CommunityBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFEFF1), Color(0xFFFFF8F8)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFFFD9DE))),
      child: const Row(children: [
        CircleAvatar(radius: 26, backgroundColor: Colors.white, child: Icon(Icons.groups_2_rounded, color: brand, size: 28)),
        SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Türk topluluğuna katıl', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ink)), SizedBox(height: 3), Text('Etkinlikler, duyurular ve gerçek bağlantılar', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13))])),
        Icon(Icons.arrow_forward_ios_rounded, color: brand, size: 18),
      ]),
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
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(height: 135, width: double.infinity, child: Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE8EA), child: const Icon(Icons.restaurant, color: brand, size: 42)))),
            Positioned(top: 10, right: 10, child: Container(width: 34, height: 34, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, size: 20))),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
              const SizedBox(height: 4),
              Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFFFB400), size: 19), const SizedBox(width: 3), Text(rating, style: const TextStyle(fontWeight: FontWeight.w800)), const Spacer(), const Icon(Icons.location_on_outlined, size: 17, color: muted)]),
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
  final IconData icon;
  const EventCard({super.key, required this.date, required this.title, required this.meta, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFECEEF1))),
      child: Row(children: [
        Container(width: 54, height: 58, decoration: BoxDecoration(color: const Color(0xFFFFEDF0), borderRadius: BorderRadius.circular(16)), alignment: Alignment.center, child: Text(date, textAlign: TextAlign.center, style: const TextStyle(color: brand, fontWeight: FontWeight.w900, height: 1.05))),
        const SizedBox(width: 12),
        Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: ink)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)), const SizedBox(height: 4), Text(meta, style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 12.5))])),
        const Icon(Icons.arrow_forward_ios_rounded, size: 17, color: muted),
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
      if (trailing != null) Text(trailing!, style: const TextStyle(color: brand, fontWeight: FontWeight.w700, fontSize: 13.5)),
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset('assets/images/logo.png', width: 72, height: 72),
            const SizedBox(height: 14),
            const Text('Bu ekranı sıradaki adımda premiumlaştıracağız.', style: TextStyle(fontWeight: FontWeight.w700, color: muted)),
          ]),
        ),
      ],
    );
  }
}
