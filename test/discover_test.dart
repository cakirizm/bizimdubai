import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:bizimdubai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

DiscoverRepository repository(
    {Future<String> Function()? fetch, Map<String, String>? storage}) {
  final cache = storage ?? <String, String>{};
  return DiscoverRepository(
      fetch: fetch ?? () async => discoverSeedJson,
      read: (key) async => cache[key],
      write: (key, value) async => cache[key] = value);
}

String update(void Function(Map<String, dynamic>) edit) {
  final data = jsonDecode(discoverSeedJson) as Map<String, dynamic>;
  data['revision'] = (data['revision'] as int) + 1;
  edit(data);
  return jsonEncode(data);
}

Future<void> pumpDiscover(WidgetTester tester, Widget child,
    {double width = 393, double scale = 1}) async {
  tester.view.physicalSize = Size(width, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!),
      home: Scaffold(body: child)));
  await tester.pumpAndSettle();
}

void main() {
  test('Bundled catalog contains 40 restaurants and all Discover categories', () {
    final catalog = DiscoverCatalog.parse(discoverSeedJson);
    final restaurants =
        catalog.entries.where((e) => e.categories.contains('Restoranlar')).toList();
    expect(restaurants, hasLength(40));
    expect(catalog.entries.length, greaterThanOrEqualTo(53));
    expect(restaurants.any((e) => e.id == 'harput-restaurant-al-barsha-1'), isTrue);
    expect(restaurants.any((e) => e.id == 'el-kasaba-restaurant-lounge-two-seasons-hotel'), isTrue);
    for (final c in discoverCategories) {
      expect(catalog.entries.any((e) => e.categories.contains(c.title)), isTrue,
          reason: c.title);
    }
  });

  test('Bundled local photographs remain decodable', () async {
    final paths = DiscoverCatalog.parse(discoverSeedJson)
        .entries
        .expand((e) => e.photos)
        .where((p) => p.asset != null)
        .map((p) => p.asset!)
        .toSet();
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: path);
      final codec = await ui.instantiateImageCodec(File(path).readAsBytesSync(),
          targetWidth: 120);
      final frame = await codec.getNextFrame();
      expect(frame.image.width, greaterThan(1), reason: path);
      frame.image.dispose();
      codec.dispose();
    }
  });

  test('Updates replace records and survive restart', () async {
    final cache = <String, String>{};
    final raw = update((j) {
      final entries = j['entries'] as List;
      (entries.firstWhere((e) => e['id'] == 'bosporus-jbr')
          as Map<String, dynamic>)['name'] = 'Yeni şube adı';
    });
    final repo = repository(fetch: () async => raw, storage: cache);
    await repo.refresh(force: true);
    expect(repo.find('bosporus-jbr')!.name, 'Yeni şube adı');
    final restored = repository(storage: cache);
    await restored.initialize();
    expect(restored.find('bosporus-jbr')!.name, 'Yeni şube adı');
  });

  test('Offline update retains bundled restaurant data', () async {
    var requests = 0;
    final repo = repository(fetch: () async {
      requests++;
      throw const SocketException('offline');
    });
    await repo.refresh();
    await repo.refresh();
    expect(requests, 1);
    expect(repo.catalog.entries.where((e) => e.category == 'Restoranlar'), hasLength(40));
    expect(repo.updateError, isNotNull);
  });

  test('Search, favorites and routes use merged restaurant data', () async {
    final cache = <String, String>{};
    final repo = repository(storage: cache);
    await repo.toggleFavorite('bosporus-jbr');
    final restored = repository(storage: cache);
    await restored.initialize();
    final filter = DiscoverFilter()
      ..category = 'Restoranlar'
      ..area = 'JBR'
      ..menuOnly = true
      ..favoritesOnly = true;
    expect(filter.apply(restored).map((e) => e.id), ['bosporus-jbr']);
    expect((DiscoverFilter()..query = 'HARPUT').apply(repo).single.id,
        'harput-restaurant-al-barsha-1');
    final kasaba = repo.find('el-kasaba-restaurant-lounge-two-seasons-hotel')!;
    expect(kasaba.directions('google').queryParameters['destination'], kasaba.address);
    expect(kasaba.directions('waze').queryParameters['q'], kasaba.address);
  });

  testWidgets('Restaurant cards and detail actions render', (tester) async {
    final repo = repository();
    await pumpDiscover(tester,
        DiscoverPage(initialCategory: 'Restoranlar', repository: repo));
    expect(find.byKey(const ValueKey('discover-bosporus-jbr')), findsOneWidget);
    expect(find.byKey(const ValueKey('discover-harput-restaurant-al-barsha-1')),
        findsOneWidget);

    final item = repo.find('sultan-dubai')!;
    final opened = <Uri>[];
    await pumpDiscover(
        tester,
        PlaceDetailPage(
            item: item,
            repository: repo,
            openLink: (uri) async => opened.add(uri)));
    Future<void> tapRevealed(Finder target) async {
      await tester.scrollUntilVisible(target, 180,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }
    await tapRevealed(find.text('Resmî menüyü aç'));
    await tapRevealed(find.byKey(const ValueKey('google-directions')));
    await tapRevealed(find.byKey(const ValueKey('waze-directions')));
    expect(opened.length, 3);
  });

  for (final width in [320.0, 393.0, 430.0]) {
    testWidgets('Discover fits width $width with large text', (tester) async {
      await pumpDiscover(tester, DiscoverPage(repository: repository()),
          width: width, scale: 1.3);
      for (var i = 0; i < 8; i++) {
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}
