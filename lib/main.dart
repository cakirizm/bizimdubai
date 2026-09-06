import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

part 'home/home_screen.dart';
part 'discover/catalog.dart';
part 'discover/discover_screen.dart';
part 'discover/seed_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await discoverRepository.initialize();
  runApp(const BizimDubaiApp());
  unawaited(discoverRepository.refresh());
}

class BizimDubaiApp extends StatelessWidget {
  const BizimDubaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE30613);
    final scheme = ColorScheme.fromSeed(seedColor: red, brightness: Brightness.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizimDubai',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const SplashGate(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  final pages = const [HomePage(), DiscoverPage(), CommunityPage(), GuidePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          for (var i = 0; i < pages.length; i++)
            TickerMode(enabled: index == i, child: pages[i]),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? _homeRed : const Color(0xFF666C75),
            size: 26,
          )),
          labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            color: states.contains(WidgetState.selected) ? _homeRed : const Color(0xFF666C75),
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          )),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          height: 72,
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0x18000000),
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
            NavigationDestination(icon: Icon(CupertinoIcons.search), selectedIcon: Icon(CupertinoIcons.search), label: 'Keşfet'),
            NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Topluluk'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Rehber'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
void openHomeDestination(BuildContext context, Widget page, String title) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) =>
    Scaffold(appBar: AppBar(title: Text(title)), body: page)));
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 52});
  final double size;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * .24),
    child: Image.asset('assets/images/logo.png', width: size, height: size,
      fit: BoxFit.contain, semanticLabel: 'BizimDubai logosu'),
  );
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext context) => Row(children: [
    BrandLogo(size: compact ? 44 : 56),
    const SizedBox(width: 12),
    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('BizimDubai', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1)),
      Text('Dubai’de hayat, birlikte güzel.', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
    ])),
    const Text('🇹🇷', style: TextStyle(fontSize: 26)),
  ]);
}

List<Widget> homeHighlights(BuildContext context) => [
  for (final event in featuredEvents)
    Padding(padding: const EdgeInsets.only(bottom: 10), child: TodayCard(
      icon: event.icon, title: event.title, subtitle: event.subtitle, badge: event.status,
      onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => EventDetailPage(event: event))),
    )),
  TodayCard(icon: classifiedItems[1].icon, title: classifiedItems[1].title,
    subtitle: '${classifiedItems[1].area} · ${classifiedItems[1].category}', badge: classifiedItems[1].price,
    onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ListingDetailPage(item: classifiedItems[1])))),
];

class HomeHighlightsPage extends StatelessWidget {
  const HomeHighlightsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: homeHighlights(context));
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -.4))),
    if (action != null)
      if (onAction != null) TextButton(onPressed: onAction, child: Text(action!))
      else Text(action!, style: const TextStyle(color: Color(0xFFE30613), fontWeight: FontWeight.w800, fontSize: 13)),
  ]);
}

class CommunityEvent {
  const CommunityEvent(this.title, this.subtitle, this.status, this.icon);
  final String title, subtitle, status;
  final IconData icon;
}
const featuredEvents = [
  CommunityEvent('Cuma Halı Saha', 'Cuma · 21:00 · Al Quoz', '9/14 kişi', Icons.sports_soccer),
  CommunityEvent('Yeni Gelenler Kahvesi', 'Cumartesi · 17:30 · Marina', '12 kişi', Icons.coffee),
];
class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.event});
  final CommunityEvent event;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Etkinlik detayı')),
    body: ListView(padding: const EdgeInsets.all(22), children: [
      const BrandHeader(), const SizedBox(height: 28),
      Icon(event.icon, size: 64, color: const Color(0xFFE30613)), const SizedBox(height: 20),
      Text(event.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
      const SizedBox(height: 14), Text(event.subtitle), const SizedBox(height: 10), Text(event.status),
      const SizedBox(height: 24),
      const Text('Bu etkinlik örnek topluluk içeriğidir. Güncel tarih ve organizatör bilgisi henüz eklenmediği için katılım kaydı alınmıyor.', style: TextStyle(height: 1.6, color: Color(0xFF6B7280))),
      const SizedBox(height: 20),
      OutlinedButton.icon(onPressed: () => openHomeDestination(context, const CommunityPage(), 'Topluluk'), icon: const Icon(Icons.groups_outlined), label: const Text('Topluluğu incele')),
    ]));
}

class TodayCard extends StatelessWidget {
  const TodayCard({super.key, required this.icon, required this.title, required this.subtitle, required this.badge, this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Ink(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFFE30613))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600))])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(999)), child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800))),
      ]),
    ),
  );
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});
  @override
  Widget build(BuildContext context) {
    final groups = [
      ('Dubai Türk Futbol', '1.248 üye', Icons.sports_soccer),
      ('Dubai Türk Kadınlar', '2.104 üye', Icons.woman),
      ('JVC Türkleri', '864 üye', Icons.apartment),
      ('Dubai Türk Gamerlar', '592 üye', Icons.sports_esports),
      ('Padel Dubai Türk', '418 üye', Icons.sports_tennis),
      ('Dubai’ye Yeni Gelenler', '1.570 üye', Icons.flight_land),
    ];
    final events = [
      ('Cuma Halı Saha', 'Cuma · 21:00 · Al Quoz', '9/14 kişi', Icons.sports_soccer),
      ('Padel Mix Match', 'Cumartesi · 19:30 · Al Barsha', '6/8 kişi', Icons.sports_tennis),
      ('Yeni Gelenler Kahvesi', 'Cumartesi · 17:30 · Marina', '12 kişi', Icons.coffee),
    ];
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 14, 18, 120), children: [
      const BrandHeader(compact: true),
      const SizedBox(height: 20),
      const SectionTitle(title: 'Topluluk'),
      const SizedBox(height: 4),
      const Text('Sadece konuşma değil; birlikte bir şey yap.', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: FilledButton.icon(onPressed: () => _showCreateEvent(context), icon: const Icon(Icons.add), label: const Text('Etkinlik oluştur'))),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton.icon(onPressed: () => _showCreateGroup(context), icon: const Icon(Icons.group_add_outlined), label: const Text('Grup oluştur'))),
      ]),
      const SizedBox(height: 24),
      const SectionTitle(title: 'Yaklaşan etkinlikler', action: 'Tümü'),
      const SizedBox(height: 10),
      ...events.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: EventCard(title: e.$1, subtitle: e.$2, status: e.$3, icon: e.$4))),
      const SizedBox(height: 14),
      const SectionTitle(title: 'Gruplar', action: 'Tümü'),
      const SizedBox(height: 10),
      ...groups.map((g) => Padding(padding: const EdgeInsets.only(bottom: 10), child: GroupCard(title: g.$1, members: g.$2, icon: g.$3))),
      const SizedBox(height: 8),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(22)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Bir aktivite arıyorsun ama etkinlik yok mu?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)), SizedBox(height: 6), Text('“Cuma halı saha oynamak istiyorum” diye istek bırak. Aynı istekte yeterli kişi olduğunda etkinlik önerelim.', style: TextStyle(height: 1.4, color: Color(0xFF6B7280), fontWeight: FontWeight.w600))]))
    ]));
  }

  void _showCreateEvent(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const CreateEventSheet());
  }

  void _showCreateGroup(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const CreateGroupSheet());
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.title, required this.subtitle, required this.status, required this.icon});
  final String title, subtitle, status;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(children: [
    Container(width: 54, height: 54, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(17)), child: Icon(icon, color: const Color(0xFFE30613), size: 28)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280), fontWeight: FontWeight.w600))])),
    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(999)), child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800))), const SizedBox(height: 4), const Text('Katıl →', style: TextStyle(color: Color(0xFFE30613), fontWeight: FontWeight.w900, fontSize: 11))])
  ]));
}

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.title, required this.members, required this.icon});
  final String title, members;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(children: [
    CircleAvatar(radius: 25, backgroundColor: const Color(0xFFFFECEE), child: Icon(icon, color: const Color(0xFFE30613))),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), Text(members, style: const TextStyle(color: Color(0xFF8B9098), fontWeight: FontWeight.w600, fontSize: 11))])),
    OutlinedButton(onPressed: () {}, child: const Text('Katıl')),
  ]));
}

class CreateEventSheet extends StatefulWidget {
  const CreateEventSheet({super.key});
  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  String type = 'Halı Saha';
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(18, 14, 18, MediaQuery.of(context).viewInsets.bottom + 24),
    child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(10)))),
      const SizedBox(height: 18),
      const Text('Etkinlik oluştur', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(initialValue: type, items: const ['Halı Saha','Padel','Maç İzleme','Kahve & Sosyal','Piknik & Outdoor','Oyun Gecesi','Koşu','Aile & Çocuk'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => type = v ?? type), decoration: const InputDecoration(labelText: 'Etkinlik türü', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const TextField(decoration: InputDecoration(labelText: 'Başlık', hintText: 'Örn. Cuma Halı Saha', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const Row(children: [Expanded(child: TextField(decoration: InputDecoration(labelText: 'Tarih / Saat', border: OutlineInputBorder()))), SizedBox(width: 8), Expanded(child: TextField(decoration: InputDecoration(labelText: 'Kapasite', hintText: '14', border: OutlineInputBorder())))]),
      const SizedBox(height: 10),
      const TextField(decoration: InputDecoration(labelText: 'Konum', hintText: 'Al Quoz', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const TextField(decoration: InputDecoration(labelText: 'Kişi başı ücret (opsiyonel)', hintText: '65 AED', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Açıklama / Kurallar', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Etkinliği Yayınla'))),
    ])),
  );
}

class CreateGroupSheet extends StatelessWidget {
  const CreateGroupSheet({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(18, 14, 18, MediaQuery.of(context).viewInsets.bottom + 24),
    child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(10)))),
      const SizedBox(height: 18),
      const Text('Grup oluştur', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
      const SizedBox(height: 12),
      const TextField(decoration: InputDecoration(labelText: 'Grup adı', hintText: 'Örn. Dubai Türk Padel', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const TextField(decoration: InputDecoration(labelText: 'Kategori', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Açıklama ve kurallar', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Grubu Oluştur'))),
    ])),
  );
}

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});
  @override
  Widget build(BuildContext context) {
    final guides = [
      ('Dubai’ye Yeni Geldim', Icons.flight_land, 'SIM, banka, Emirates ID, ev, ulaşım'),
      ('Ev & Yaşam', Icons.home_outlined, 'Kiralama, Ejari, DEWA, internet, depozito'),
      ('Araç & Ulaşım', Icons.directions_car_outlined, 'Ehliyet, RTA, Salik, park, sigorta'),
      ('Sağlık', Icons.health_and_safety_outlined, 'Sigorta, doktor, eczane, acil durum'),
      ('Aile & Çocuk', Icons.family_restroom, 'Okul, nursery, çocuk doktoru, aktiviteler'),
      ('İş & Kariyer', Icons.work_outline, 'İş arama, CV, sözleşme, maaş & benefits'),
      ('Resmî İşlemler', Icons.account_balance_outlined, 'Doğru kurum, gerekli belge, adım adım'),
      ('Dubai’den Ayrılıyorum', Icons.flight_takeoff, 'DEWA, internet, banka, araç, depozito'),
      ('Acil Durum', Icons.emergency_outlined, 'Polis, ambulans, konsolosluk, kayıp pasaport'),
    ];
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 14, 18, 120), children: [
      const BrandHeader(compact: true),
      const SizedBox(height: 20),
      const Text('Rehber', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.7)),
      const SizedBox(height: 4),
      const Text('Dubai’de bunu nasıl yaparım?', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
      const SizedBox(height: 14),
      TextField(decoration: InputDecoration(hintText: 'Ehliyet, banka, ev kiralama ara…', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(18)))),
      const SizedBox(height: 20),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: guides.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.22, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) {
        final g = guides[i];
        return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideDetailPage(title: g.$1, subtitle: g.$3))), borderRadius: BorderRadius.circular(22), child: Ink(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(14)), child: Icon(g.$2, color: const Color(0xFFE30613))), const Spacer(), Text(g.$1, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), const SizedBox(height: 4), Text(g.$3, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF8B9098), fontWeight: FontWeight.w600, fontSize: 10.5))])));
      }),
    ]));
  }
}

class GuideDetailPage extends StatelessWidget {
  const GuideDetailPage({super.key, required this.title, required this.subtitle});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) {
    final steps = title == 'Ev & Yaşam'
      ? ['Bütçe ve bölgeyi belirle', 'İlan ve emlakçıları karşılaştır', 'Sözleşmeyi kontrol et', 'Ejari kaydını tamamla', 'DEWA bağlantısını aç', 'İnternet bağlantısını ayarla', 'Teslim ve depozito kanıtlarını sakla']
      : ['Gerekli belgeleri kontrol et', 'Resmî kurumu belirle', 'Başvuruyu hazırla', 'Ücret ve randevu adımını tamamla', 'Sonucu ve belgeleri sakla'];
    return Scaffold(appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))), body: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 40), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(22)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: Color(0xFFE30613)), SizedBox(width: 10), Expanded(child: Text('Kurallar ve ücretler değişebilir. Yayın tarihinden önce resmî kaynağı kontrol et.', style: TextStyle(fontWeight: FontWeight.w700, height: 1.35)))])),
      const SizedBox(height: 18),
      Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w700)),
      const SizedBox(height: 18),
      ...List.generate(steps.length, (i) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [CircleAvatar(backgroundColor: const Color(0xFFE30613), foregroundColor: Colors.white, radius: 16, child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12))), const SizedBox(width: 12), Expanded(child: Text(steps[i], style: const TextStyle(fontWeight: FontWeight.w800)))]))),
      const SizedBox(height: 8),
      OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.groups_outlined), label: const Text('Topluluğa Sor')),
      const SizedBox(height: 8),
      FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscoverPage())), icon: const Icon(Icons.explore_outlined), label: const Text('İlgili Türk Hizmetlerini Bul')),
    ]));
  }
}

class ClassifiedItem {
  const ClassifiedItem({required this.title, required this.price, required this.area, required this.category, required this.icon, this.badge = 'Satılık'});
  final String title, price, area, category, badge;
  final IconData icon;
}

const classifiedItems = [
  ClassifiedItem(title: 'iPhone 16 Pro 256 GB', price: '3.100 AED', area: 'JVC', category: 'Elektronik', icon: Icons.phone_iphone, badge: 'Acil Satış'),
  ClassifiedItem(title: 'L koltuk takımı', price: '1.850 AED', area: 'Dubai Marina', category: 'Ev & Mobilya', icon: Icons.chair_alt),
  ClassifiedItem(title: 'PS5 + 2 kol', price: '1.600 AED', area: 'Business Bay', category: 'Elektronik', icon: Icons.sports_esports),
  ClassifiedItem(title: 'Bebek arabası', price: '420 AED', area: 'Al Barsha', category: 'Çocuk & Bebek', icon: Icons.child_friendly),
  ClassifiedItem(title: 'Yemek masası + 4 sandalye', price: '1.250 AED', area: 'JVC', category: 'Ev & Mobilya', icon: Icons.table_restaurant),
  ClassifiedItem(title: 'TV ünitesi', price: '750 AED', area: 'Marina', category: 'Ev & Mobilya', icon: Icons.tv),
];

class ClassifiedsPage extends StatefulWidget {
  const ClassifiedsPage({super.key});
  @override
  State<ClassifiedsPage> createState() => _ClassifiedsPageState();
}

class _ClassifiedsPageState extends State<ClassifiedsPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = classifiedItems.where((e) => '${e.title} ${e.category} ${e.area}'.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('İlanlar', style: TextStyle(fontWeight: FontWeight.w900)), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))]),
      floatingActionButton: FloatingActionButton.extended(backgroundColor: const Color(0xFFE30613), foregroundColor: Colors.white, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateListingPage())), icon: const Icon(Icons.add), label: const Text('İlan Ver', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 100), children: [
        const Text('Dubai’deki Türklerin ikinci el platformu', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        TextField(onChanged: (v) => setState(() => query = v), decoration: InputDecoration(hintText: 'Ne arıyorsun?', prefixIcon: const Icon(Icons.search), suffixIcon: const Icon(Icons.tune), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(18)))),
        const SizedBox(height: 14),
        SizedBox(height: 74, child: ListView(scrollDirection: Axis.horizontal, children: const [
          ClassifiedCategory(icon: Icons.chair_alt, label: 'Ev & Mobilya'),
          ClassifiedCategory(icon: Icons.laptop_mac, label: 'Elektronik'),
          ClassifiedCategory(icon: Icons.directions_car, label: 'Araç'),
          ClassifiedCategory(icon: Icons.child_friendly, label: 'Çocuk & Bebek'),
          ClassifiedCategory(icon: Icons.checkroom, label: 'Moda'),
          ClassifiedCategory(icon: Icons.grid_view, label: 'Tümü'),
        ])),
        const SizedBox(height: 18),
        const SectionTitle(title: 'Yeni İlanlar', action: 'Tümünü Gör'),
        const SizedBox(height: 10),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filtered.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .79, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => ListingCard(item: filtered[i])),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(22)), child: const Row(children: [CircleAvatar(backgroundColor: Color(0xFFE30613), foregroundColor: Colors.white, child: Icon(Icons.flight_takeoff)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Leaving Dubai?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), Text('Tüm ev eşyalarını tek paket ilanla daha hızlı sat.', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600, fontSize: 11))]))]))
      ]),
    );
  }
}

class ClassifiedCategory extends StatelessWidget {
  const ClassifiedCategory({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(width: 82, margin: const EdgeInsets.only(right: 8), child: Column(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: const Color(0xFFE30613))), const SizedBox(height: 5), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800))]));
}

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.item});
  final ClassifiedItem item;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingDetailPage(item: item))),
    borderRadius: BorderRadius.circular(20),
    child: Ink(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF0F1), Color(0xFFFFFAFA)]), borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: Stack(children: [Center(child: Icon(item.icon, size: 58, color: const Color(0xFFE30613))), Positioned(left: 8, top: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE30613), borderRadius: BorderRadius.circular(999)), child: Text(item.badge, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 9)))), const Positioned(right: 8, top: 8, child: CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.favorite_border, size: 16))) ]))),
      Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)), const SizedBox(height: 3), Text(item.price, style: const TextStyle(color: Color(0xFFE30613), fontWeight: FontWeight.w900, fontSize: 15)), const SizedBox(height: 4), Row(children: [const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF8B9098)), Expanded(child: Text(item.area, style: const TextStyle(fontSize: 9.5, color: Color(0xFF8B9098), fontWeight: FontWeight.w700))), const Icon(Icons.star, size: 13, color: Color(0xFFFFB300)), const Text('4.9', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800))])]))
    ])),
  );
}

class ListingDetailPage extends StatelessWidget {
  const ListingDetailPage({super.key, required this.item});
  final ClassifiedItem item;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(), bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline), label: const Text('Mesaj Gönder'))), const SizedBox(width: 8), Expanded(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.chat), label: const Text('WhatsApp')))]))), body: ListView(padding: const EdgeInsets.fromLTRB(18, 0, 18, 30), children: [
    Container(height: 270, decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(colors: [Color(0xFFFFECEE), Color(0xFFFFFFFF)])), child: Center(child: Icon(item.icon, size: 120, color: const Color(0xFFE30613)))),
    const SizedBox(height: 16),
    Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
    Text(item.price, style: const TextStyle(color: Color(0xFFE30613), fontWeight: FontWeight.w900, fontSize: 24)),
    const SizedBox(height: 8),
    Row(children: [const Icon(Icons.location_on_outlined, size: 18), Text(item.area, style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), const Text('3 gün önce', style: TextStyle(color: Color(0xFF8B9098), fontWeight: FontWeight.w600))]),
    const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Row(children: [CircleAvatar(child: Icon(Icons.person)), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Merve K.', style: TextStyle(fontWeight: FontWeight.w900)), Text('⭐ 4.8 · 28 değerlendirme', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.w600))])), Icon(Icons.chevron_right)])),
    const SizedBox(height: 18),
    const SectionTitle(title: 'Açıklama'),
    const SizedBox(height: 8),
    Text('${item.title} temiz kullanılmıştır. Dubai içinde elden teslim tercih edilir. Detaylar için mesaj gönderebilirsin.', style: const TextStyle(height: 1.45, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
  ]));
}

class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('İlan Ver', style: TextStyle(fontWeight: FontWeight.w900))), body: ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 30), children: [
    Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(18)), child: const Row(children: [Icon(Icons.groups, color: Color(0xFFE30613)), SizedBox(width: 10), Expanded(child: Text('Dubai’deki Türk topluluğunun parçası ol. İhtiyacın olanı sat, başkasının ihtiyacını karşıla.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, height: 1.35)))])),
    const SizedBox(height: 14),
    Container(height: 135, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFD9DDE3))), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo_outlined, color: Color(0xFFE30613), size: 34), SizedBox(height: 7), Text('Fotoğraf Ekle', style: TextStyle(color: Color(0xFFE30613), fontWeight: FontWeight.w900)), Text('En az 1, en fazla 10 fotoğraf', style: TextStyle(color: Color(0xFF8B9098), fontSize: 10))])),
    const SizedBox(height: 12),
    const TextField(decoration: InputDecoration(labelText: 'Kategori', border: OutlineInputBorder())),
    const SizedBox(height: 10),
    const TextField(decoration: InputDecoration(labelText: 'Başlık', hintText: 'Örn. L koltuk takımı', border: OutlineInputBorder())),
    const SizedBox(height: 10),
    const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Fiyat (AED)', border: OutlineInputBorder())),
    const SizedBox(height: 10),
    const TextField(maxLines: 4, decoration: InputDecoration(labelText: 'Açıklama', border: OutlineInputBorder())),
    const SizedBox(height: 10),
    const TextField(decoration: InputDecoration(labelText: 'Bölge', hintText: 'JVC, Marina, Al Barsha…', border: OutlineInputBorder())),
    const SizedBox(height: 14),
    const Text('İlan Türü', style: TextStyle(fontWeight: FontWeight.w900)),
    const SizedBox(height: 8),
    const Wrap(spacing: 8, children: [Chip(label: Text('Satılık')), Chip(label: Text('Kiralık')), Chip(label: Text('Ücretsiz')), Chip(label: Text('Ürün Takası'))]),
    const SizedBox(height: 6),
    SwitchListTile(contentPadding: EdgeInsets.zero, value: true, onChanged: null, title: const Text('Leaving Dubai / Acil Satış Paketi', style: TextStyle(fontWeight: FontWeight.w900)), subtitle: const Text('Tüm ev eşyalarını tek ilan altında sun.')),
    const SizedBox(height: 10),
    FilledButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.send), label: const Text('İlanı Yayınla')),
  ]));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 120), children: [
    const Center(child: BrandLogo(size: 84)),
    const SizedBox(height: 10),
    const Center(child: Text('BizimDubai Üyesi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22))),
    const Center(child: Text('Dubai · Topluluğa hoş geldin', style: TextStyle(color: Color(0xFF8B9098), fontWeight: FontWeight.w600))),
    const SizedBox(height: 24),
    const ProfileTile(icon: Icons.favorite_border, title: 'Favorilerim'),
    const ProfileTile(icon: Icons.sell_outlined, title: 'İlanlarım'),
    const ProfileTile(icon: Icons.event_outlined, title: 'Etkinliklerim'),
    const ProfileTile(icon: Icons.groups_outlined, title: 'Gruplarım'),
    const ProfileTile(icon: Icons.notifications_none, title: 'Bildirimler'),
    const ProfileTile(icon: Icons.verified_outlined, title: 'İşletme profilini sahiplen'),
    const ProfileTile(icon: Icons.settings_outlined, title: 'Ayarlar'),
    const ProfileTile(icon: Icons.help_outline, title: 'Yardım & Geri Bildirim'),
  ]));
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 9), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)), child: ListTile(leading: Icon(icon, color: const Color(0xFFE30613)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), trailing: const Icon(Icons.chevron_right)));
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
        pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: const Shell()),
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
      backgroundColor: const Color(0xFFE30613),
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
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white24)),
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
