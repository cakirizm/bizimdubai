import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const BizimDubaiApp());

class BizimDubaiApp extends StatelessWidget {
  const BizimDubaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFE51B2B);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizimDubai',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: brand),
        fontFamily: 'SF Pro Display',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1.2),
          headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -.8),
          titleLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -.4),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(height: 1.35),
          bodyMedium: TextStyle(height: 1.35),
        ),
      ),
      home: const AppShell(),
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
          boxShadow: [BoxShadow(color: Color(0x16000000), blurRadius: 22, offset: Offset(0, -4))],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          height: 72,
          indicatorColor: const Color(0xFFFFE5E8),
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Keşfet'),
            NavigationDestination(icon: Icon(Icons.groups_2_outlined), selectedIcon: Icon(Icons.groups_2), label: 'Topluluk'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Rehber'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

const brand = Color(0xFFE51B2B);
const ink = Color(0xFF17171A);
const muted = Color(0xFF7B808B);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const PremiumHeader(),
              const SizedBox(height: 22),
              _HeroBanner(
                image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=85',
                eyebrow: 'BİZİMDUBAİ',
                title: 'Dubai’de aradığın\nTürk dünyası burada.',
                subtitle: 'Mekanlar, insanlar, etkinlikler ve günlük hayat tek uygulamada.',
              ),
              const SizedBox(height: 28),
              const SectionTitle('Hızlı erişim'),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: const [
                  QuickCard(icon: Icons.restaurant_rounded, title: 'Türk mekanları', subtitle: 'Restoran & kafe', tint: Color(0xFFFFE8EA)),
                  QuickCard(icon: Icons.sell_outlined, title: 'İkinci el', subtitle: 'İlan ver / bul', tint: Color(0xFFFFF0DE)),
                  QuickCard(icon: Icons.sports_soccer, title: 'Etkinlikler', subtitle: 'Halı saha, padel…', tint: Color(0xFFE9F5FF)),
                  QuickCard(icon: Icons.auto_stories_outlined, title: 'Rehber', subtitle: 'Dubai nasıl?', tint: Color(0xFFE9F8EE)),
                ],
              ),
              const SizedBox(height: 30),
              const SectionTitle('Bugün BizimDubai’de', trailing: 'Tümünü gör'),
              const SizedBox(height: 12),
              const EventTile(icon: Icons.sports_soccer, title: 'Cuma Halı Saha', meta: 'Al Quoz · 21:00 · 9/14 kişi', badge: '5 kişi lazım'),
              const EventTile(icon: Icons.coffee_rounded, title: 'Yeni Gelenler Kahvesi', meta: 'JLT · 19:30 · 18 kişi', badge: 'Katıl'),
              const EventTile(icon: Icons.family_restroom, title: 'Aileler Kahvaltısı', meta: 'Jumeirah · Cumartesi 10:30', badge: '8 yer'),
              const SizedBox(height: 28),
              const SectionTitle('Dubai’de öne çıkanlar'),
              const SizedBox(height: 12),
              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    FeatureCard(image: 'https://www.citysearch.ae/UF/Albums/43186/bosporus-jbr-dubai_133819976.jpg', title: 'Bosporus JBR', subtitle: 'Deniz kenarında Türk mutfağı'),
                    FeatureCard(image: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', title: 'Türk kahvaltısı', subtitle: 'Hafta sonu için seçtiklerimiz'),
                    FeatureCard(image: 'https://images.unsplash.com/photo-1524230572899-a752b3835840?auto=format&fit=crop&w=900&q=85', title: 'Dubai’de yaşam', subtitle: 'Yeni gelenler için pratik rehber'),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String category = 'Restoranlar';
  final controller = TextEditingController();

  List<Place> get visible => places.where((p) {
    final byCat = category == 'Tümü' || p.category == category;
    final q = controller.text.trim().toLowerCase();
    return byCat && (q.isEmpty || p.name.toLowerCase().contains(q) || p.area.toLowerCase().contains(q));
  }).toList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          sliver: SliverList(delegate: SliverChildListDelegate([
            const PremiumHeader(),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Restoran, Türk doktor, berber, market ara…',
                hintStyle: const TextStyle(color: Color(0xFF9A9EA7), fontSize: 15),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: const Icon(Icons.tune_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 17),
              ),
            ),
            const SizedBox(height: 22),
            _HeroBanner(
              compact: true,
              image: 'https://www.citysearch.ae/UF/Albums/43186/bosporus-jbr-dubai_133819976.jpg',
              eyebrow: 'KEŞFET',
              title: 'Dubai’de Türkçe\nhayatını kolaylaştır.',
              subtitle: 'Doğrulanmış mekanlar, profesyoneller ve Türkçe hizmet noktaları.',
            ),
            const SizedBox(height: 26),
            const SectionTitle('Kategoriler', trailing: 'Tümünü gör'),
            const SizedBox(height: 12),
            SizedBox(
              height: 112,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final c = categories[i];
                  final selected = category == c.name;
                  return GestureDetector(
                    onTap: () => setState(() => category = c.name),
                    child: Container(
                      width: 104,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selected ? brand : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 16, offset: Offset(0, 5))],
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: selected ? Colors.white.withOpacity(.15) : c.tint, borderRadius: BorderRadius.circular(14)),
                          child: Icon(c.icon, color: selected ? Colors.white : brand),
                        ),
                        const SizedBox(height: 8),
                        Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, color: selected ? Colors.white : ink, fontSize: 13)),
                      ]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(scrollDirection: Axis.horizontal, children: const [
                FilterPill('Tümü'), FilterPill('🇹🇷 Türk işletmesi'), FilterPill('🗣 Türkçe hizmet'), FilterPill('⭐ En yüksek puan'), FilterPill('Açık olanlar'), FilterPill('Yakınımda'),
              ]),
            ),
            const SizedBox(height: 26),
            SectionTitle(category, trailing: '${visible.length} sonuç'),
            const SizedBox(height: 12),
            ...visible.map((p) => PlaceCard(place: p)),
          ])),
        )
      ],
    );
  }
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimplePremiumPage(
    title: 'Topluluk',
    subtitle: 'Dubai’de yalnız değilsin.',
    heroImage: 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?auto=format&fit=crop&w=1200&q=85',
    items: const [
      ('Cuma Halı Saha', 'Al Quoz · 21:00 · 9/14 kişi', Icons.sports_soccer),
      ('Yeni Gelenler', '3.2K üye · bugün 41 mesaj', Icons.waving_hand_outlined),
      ('Dubai Türk Aileler', '1.8K üye · 4 etkinlik', Icons.family_restroom),
      ('Padel Dubai', '846 üye · bu hafta 7 maç', Icons.sports_tennis),
    ],
  );
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimplePremiumPage(
    title: 'Rehber',
    subtitle: 'Dubai’de işini adım adım çöz.',
    heroImage: 'https://images.unsplash.com/photo-1518684079-3c830dcef090?auto=format&fit=crop&w=1200&q=85',
    items: const [
      ('Dubai’ye Yeni Geldim', 'İlk 7 gün checklist', Icons.flight_land),
      ('Ev & Yaşam', 'Ejari, DEWA, internet', Icons.home_work_outlined),
      ('Araç & Ulaşım', 'Ehliyet, Salik, RTA', Icons.directions_car_outlined),
      ('Sağlık', 'Sigorta, klinik, acil durum', Icons.health_and_safety_outlined),
      ('İş & Kariyer', 'CV, sözleşme, çalışma hayatı', Icons.work_outline),
    ],
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
    children: [
      const PremiumHeader(showLocation: false),
      const SizedBox(height: 28),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: const Row(children: [
          CircleAvatar(radius: 32, backgroundColor: Color(0xFFFFE5E8), child: Text('M', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: brand))),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Profilim', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Dubai · BizimDubai üyesi', style: TextStyle(color: muted))])),
          Icon(Icons.chevron_right),
        ]),
      ),
      const SizedBox(height: 18),
      ...[
        ('Favorilerim', Icons.favorite_border), ('İlanlarım', Icons.sell_outlined), ('Etkinliklerim', Icons.event_outlined), ('Bildirimler', Icons.notifications_none), ('Ayarlar', Icons.settings_outlined), ('Yardım & Destek', Icons.help_outline),
      ].map((e) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), leading: Icon(e.$2, color: brand), title: Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right), onTap: () {})),
    ],
  );
}

class PremiumHeader extends StatelessWidget {
  final bool showLocation;
  const PremiumHeader({super.key, this.showLocation = true});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 14)]),
        padding: const EdgeInsets.all(7),
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.location_city, color: brand)),
      ),
      const SizedBox(width: 13),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('BizimDubai', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
        SizedBox(height: 2),
        Text('Dubai’de Türkçe hayat.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
      ])),
      if (showLocation) Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFFFFEDEF), borderRadius: BorderRadius.circular(18)),
        child: const Row(children: [Icon(Icons.location_on, color: brand, size: 18), SizedBox(width: 4), Text('Dubai', style: TextStyle(fontWeight: FontWeight.w800))]),
      )
    ]);
  }
}

class _HeroBanner extends StatelessWidget {
  final String image, eyebrow, title, subtitle;
  final bool compact;
  const _HeroBanner({required this.image, required this.eyebrow, required this.title, required this.subtitle, this.compact = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 235 : 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Color(0x24000000), blurRadius: 26, offset: Offset(0, 12))]),
      child: Stack(fit: StackFit.expand, children: [
        Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: brand)),
        Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x25000000), Color(0xD9000000)]))),
        Positioned(left: 22, right: 22, bottom: 22, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(eyebrow, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 12)),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.white, fontSize: compact ? 27 : 32, height: 1.02, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.35, fontWeight: FontWeight.w600)),
        ])),
      ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionTitle(this.title, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: -.6))),
    if (trailing != null) Text(trailing!, style: const TextStyle(color: brand, fontWeight: FontWeight.w800)),
  ]);
}

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color tint;
  const QuickCard({super.key, required this.icon, required this.title, required this.subtitle, required this.tint});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x0B000000), blurRadius: 18, offset: Offset(0, 7))]),
    child: Row(children: [
      Container(width: 50, height: 50, decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: brand)),
      const SizedBox(width: 12),
      Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: muted, fontSize: 12.5, fontWeight: FontWeight.w600))])),
    ]),
  );
}

class EventTile extends StatelessWidget {
  final IconData icon;
  final String title, meta, badge;
  const EventTile({super.key, required this.icon, required this.title, required this.meta, required this.badge});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
    child: Row(children: [
      Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFFFFE9EC), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: brand)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 4), Text(meta, style: const TextStyle(color: muted, fontWeight: FontWeight.w600))])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFF2F3F5), borderRadius: BorderRadius.circular(14)), child: Text(badge, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
    ]),
  );
}

class FeatureCard extends StatelessWidget {
  final String image, title, subtitle;
  const FeatureCard({super.key, required this.image, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
    width: 210, margin: const EdgeInsets.only(right: 12), clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Image.network(image, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE9EC), child: const Center(child: Icon(Icons.restaurant, color: brand, size: 38))))),
      Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 4), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12.5))])),
    ]),
  );
}

class CategoryDef {
  final String name;
  final IconData icon;
  final Color tint;
  const CategoryDef(this.name, this.icon, this.tint);
}

const categories = [
  CategoryDef('Restoranlar', Icons.restaurant_rounded, Color(0xFFFFE8EA)),
  CategoryDef('Sağlık', Icons.health_and_safety_rounded, Color(0xFFE8F4FF)),
  CategoryDef('Market', Icons.shopping_cart_rounded, Color(0xFFEAF8EE)),
  CategoryDef('Güzellik', Icons.content_cut_rounded, Color(0xFFFFEBF4)),
  CategoryDef('Emlak', Icons.apartment_rounded, Color(0xFFFFF2E3)),
  CategoryDef('Eğitim', Icons.school_rounded, Color(0xFFF0EBFF)),
  CategoryDef('Spor', Icons.fitness_center_rounded, Color(0xFFE8F8F8)),
  CategoryDef('Tümü', Icons.grid_view_rounded, Color(0xFFF0F1F3)),
];

class FilterPill extends StatelessWidget {
  final String text;
  const FilterPill(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14),
    alignment: Alignment.center,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8E9ED))),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
  );
}

class Place {
  final String name, category, area, subtitle, image, phone, website;
  final double rating;
  final String reviews;
  final bool turkishBusiness, turkishService;
  const Place({required this.name, required this.category, required this.area, required this.subtitle, required this.image, required this.rating, required this.reviews, required this.phone, required this.website, this.turkishBusiness = true, this.turkishService = true});
}

const places = [
  Place(name: 'Bosporus Turkish Cuisine · The Beach', category: 'Restoranlar', area: 'JBR', subtitle: 'Türk mutfağı · Kahvaltı · Kebap', image: 'https://www.citysearch.ae/UF/Albums/43186/bosporus-jbr-dubai_133819976.jpg', rating: 4.9, reviews: '24K+', phone: '+97143808090', website: 'https://thebosporus.com/dubai/'),
  Place(name: 'Bosporus · Dubai Mall', category: 'Restoranlar', area: 'Downtown', subtitle: 'Türk mutfağı · Waterfront', image: 'https://www.citysearch.ae/UF/Albums/43186/bosporus-jbr-dubai_133819976.jpg', rating: 4.8, reviews: '17K+', phone: '+97143808090', website: 'https://thebosporus.com/dubai/'),
  Place(name: 'ZouZou Turkish & Lebanese · JBR', category: 'Restoranlar', area: 'JBR', subtitle: 'Türk & Lübnan mutfağı', image: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', rating: 4.8, reviews: '13K+', phone: '+97145640778', website: 'https://zouzoudubai.com/'),
  Place(name: 'MADO · Dubai Mall', category: 'Restoranlar', area: 'Downtown', subtitle: 'Kahvaltı · Dondurma · Türk yemekleri', image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=900&q=85', rating: 4.4, reviews: '400+', phone: '+97143882588', website: 'https://mado.ae/'),
  Place(name: 'MADO · Jumeirah', category: 'Restoranlar', area: 'Umm Suqeim', subtitle: 'Türk mutfağı · Tatlı · Kahvaltı', image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=85', rating: 4.6, reviews: '3K+', phone: '+97142222338', website: 'https://mado.ae/'),
  Place(name: 'Turkish Village · Jumeirah', category: 'Restoranlar', area: 'Jumeirah 1', subtitle: 'Otantik Türk mutfağı · Izgara', image: 'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?auto=format&fit=crop&w=900&q=85', rating: 4.5, reviews: '5K+', phone: '+97143449955', website: 'https://turkishvillage.com/'),
  Place(name: 'Turquaz Gourmet', category: 'Market', area: 'Umm Suqeim', subtitle: 'Türk marketi · Şarküteri · Online sipariş', image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=900&q=85', rating: 4.7, reviews: '300+', phone: '', website: 'https://turquazgourmet.ae/'),
  Place(name: 'Mahalle', category: 'Market', area: 'Dubai Internet City', subtitle: 'Türk ürünleri · Market', image: 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?auto=format&fit=crop&w=900&q=85', rating: 4.6, reviews: '200+', phone: '', website: 'https://mahalle.ae/'),
  Place(name: 'ADRES Turkish Gents Saloon', category: 'Güzellik', area: 'Dubai', subtitle: 'Türk berberi · Erkek bakım', image: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=900&q=85', rating: 4.8, reviews: '500+', phone: '', website: ''),
  Place(name: 'Active Auto Turkish Garage', category: 'Tümü', area: 'Al Quoz', subtitle: 'Türkçe otomotiv servisi · Mekanik · Kaporta', image: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=900&q=85', rating: 4.8, reviews: '200+', phone: '+971501978160', website: 'https://activeauto.me/turkish-garage-dubai'),
  Place(name: 'OYDO Turkish School Dubai', category: 'Eğitim', area: 'Dubai', subtitle: 'Türkçe eğitim · Çocuk programları', image: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=900&q=85', rating: 4.8, reviews: 'Topluluk', phone: '', website: ''),
  Place(name: 'KK13 Human Performance', category: 'Spor', area: 'Dubai', subtitle: 'Türk antrenör · Performans', image: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=900&q=85', rating: 4.9, reviews: 'Topluluk', phone: '', website: ''),
];

class PlaceCard extends StatelessWidget {
  final Place place;
  const PlaceCard({super.key, required this.place});

  Future<void> _open(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 18, offset: Offset(0, 7))]),
    child: Column(children: [
      SizedBox(
        height: 170,
        child: Stack(fit: StackFit.expand, children: [
          Image.network(place.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE9EC), child: const Center(child: Icon(Icons.restaurant, color: brand, size: 42)))),
          const Positioned(top: 12, right: 12, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.favorite_border, color: ink))),
          Positioned(left: 12, bottom: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: Colors.white.withOpacity(.94), borderRadius: BorderRadius.circular(12)), child: Text(place.area, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)))),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(place.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -.3)),
          const SizedBox(height: 5),
          Text(place.subtitle, style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB000), size: 21), const SizedBox(width: 3),
            Text('${place.rating}', style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(width: 4),
            Text('(${place.reviews})', style: const TextStyle(color: muted)),
            const Spacer(),
            if (place.turkishBusiness) _Badge('🇹🇷 Türk işletmesi'),
          ]),
          if (place.turkishService) const Padding(padding: EdgeInsets.only(top: 8), child: _Badge('🗣 Türkçe hizmet')),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => _open('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place.name + ' Dubai')}'), icon: const Icon(Icons.directions_outlined), label: const Text('Yol Tarifi'))),
            const SizedBox(width: 8),
            if (place.phone.isNotEmpty) Expanded(child: OutlinedButton.icon(onPressed: () => _open('tel:${place.phone}'), icon: const Icon(Icons.call_outlined), label: const Text('Ara'))),
            if (place.phone.isNotEmpty) const SizedBox(width: 8),
            Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: brand), onPressed: () => _open(place.website), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Detay'))),
          ]),
        ]),
      ),
    ]),
  );
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFFFFEEF0), borderRadius: BorderRadius.circular(10)),
    child: Text(text, style: const TextStyle(color: brand, fontWeight: FontWeight.w800, fontSize: 11.5)),
  );
}

class _SimplePremiumPage extends StatelessWidget {
  final String title, subtitle, heroImage;
  final List<(String, String, IconData)> items;
  const _SimplePremiumPage({required this.title, required this.subtitle, required this.heroImage, required this.items});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
    children: [
      const PremiumHeader(),
      const SizedBox(height: 22),
      _HeroBanner(image: heroImage, eyebrow: title.toUpperCase(), title: title, subtitle: subtitle, compact: true),
      const SizedBox(height: 26),
      ...items.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFFFE9EC), borderRadius: BorderRadius.circular(15)), child: Icon(e.$3, color: brand)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 3), Text(e.$2, style: const TextStyle(color: muted, fontWeight: FontWeight.w600))])),
          const Icon(Icons.chevron_right),
        ]),
      )),
    ],
  );
}
