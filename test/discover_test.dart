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
      write: (key, value) async {
        cache[key] = value;
      });
}

String update(void Function(Map<String, dynamic>) edit) {
  final data = jsonDecode(discoverSeedJson) as Map<String, dynamic>;
  data['revision'] = 2;
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
  test('Bundled catalog matches canonical source and covers all categories',
      () {
    final source =
        jsonDecode(File('assets/data/discover.json').readAsStringSync());
    expect(jsonDecode(discoverSeedJson), source);
    final catalog = DiscoverCatalog.parse(discoverSeedJson);
    expect(catalog.entries.length, 18);
    for (final c in discoverCategories) {
      expect(catalog.entries.any((e) => e.categories.contains(c.title)), isTrue,
          reason: c.title);
    }
    for (final e in catalog.entries) {
      expect(e.sources, isNotEmpty);
      for (final p in e.photos) {
        expect(File(p.asset!).existsSync(), isTrue, reason: p.asset);
      }
    }
  });
  test('Each official photograph is a decodable raster image', () async {
    final paths = DiscoverCatalog.parse(discoverSeedJson)
        .entries
        .expand((e) => e.photos)
        .map((p) => p.asset!)
        .toSet();
    for (final path in paths) {
      final codec = await ui.instantiateImageCodec(File(path).readAsBytesSync(),
          targetWidth: 200);
      final frame = await codec.getNextFrame();
      expect(frame.image.width, greaterThan(1), reason: path);
      frame.image.dispose();
      codec.dispose();
    }
  });
  test('Updates replace records atomically and survive restart', () async {
    final cache = <String, String>{};
    final raw = update((j) {
      j['entries'][0]['name'] = 'Yeni şube adı';
      j['entries'][1]['active'] = false;
    });
    final repo = repository(fetch: () async => raw, storage: cache);
    await repo.refresh(force: true);
    expect(repo.catalog.revision, 2);
    expect(repo.find('bosporus-jbr')!.name, 'Yeni şube adı');
    expect(repo.find('bosporus-dubai-mall'), isNull);
    final restored = repository(storage: cache);
    await restored.initialize();
    expect(restored.catalog.revision, 2);
    expect(restored.find('bosporus-jbr')!.name, 'Yeni şube adı');
  });
  test('Invalid, duplicate, unsafe and older feeds preserve last good data',
      () async {
    final valid = update((j) {});
    var response = valid;
    final repo = repository(fetch: () async => response);
    await repo.refresh(force: true);
    for (final invalid in [
      '{bad json',
      discoverSeedJson,
      update((j) => j['entries'][0]['website'] = 'javascript:alert(1)'),
      update((j) => j['entries'][0]['latitude'] = 99),
      update((j) => j['entries'].add(j['entries'][0])),
      update((j) => j['schemaVersion'] = 9),
    ]) {
      response = invalid;
      await repo.refresh(force: true);
      expect(repo.catalog.raw, valid);
      expect(repo.updateError, isNotNull);
    }
  });
  test('Offline update retains data, throttles retries and allows manual retry',
      () async {
    var requests = 0;
    final repo = repository(fetch: () async {
      requests++;
      throw const SocketException('offline');
    });
    await repo.refresh();
    await repo.refresh();
    expect(requests, 1);
    expect(repo.catalog.entries, hasLength(18));
    expect(repo.updateError, isNotNull);
    await repo.refresh(force: true);
    expect(requests, 2);
  });
  test('Favorites persist and filters combine including Turkish search',
      () async {
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
    filter.query = 'BOSPORUS';
    expect(filter.apply(restored), hasLength(1));
    filter.area = 'Downtown';
    expect(filter.apply(restored), isEmpty);
    expect((DiscoverFilter()..query = 'HAFIZ MUSTAFA').apply(repo).single.id,
        'hafiz-dubai-mall');
    final culture =
        (DiscoverFilter()..category = 'Kültür & Türk Etkinlikleri').apply(repo);
    expect(culture.single.id, 'oydo');
    expect(
        (DiscoverFilter()
              ..entityType = 'professional'
              ..turkishOnly = true)
            .apply(repo)
            .every((e) => e.entityType == 'professional' && e.turkishService),
        isTrue);
    await restored.toggleFavorite('bosporus-jbr');
    expect(restored.favorites, isEmpty);
  });
  test(
      'Maps use verified coordinates or exact addresses without invented Dubai suffix',
      () {
    final repo = repository();
    final sultan = repo.find('sultan-dubai')!;
    expect(sultan.directions('google').queryParameters['destination'],
        '25.1319637,55.2120418');
    expect(sultan.directions('waze').queryParameters['ll'],
        '25.1319637,55.2120418');
    final kargo = repo.find('kargo-dubai')!;
    expect(kargo.directions('google').queryParameters['destination'],
        kargo.address);
    expect(kargo.directions('waze').queryParameters['q'], contains('İstanbul'));
    expect(repo.find('elvan-sener')!.hasLocation, isFalse);
    expect(
        () => repo.find('elvan-sener')!.directions('waze'), throwsStateError);
  });
  testWidgets(
      'Search, category choice and applied menu filter change actual cards',
      (tester) async {
    final repo = repository();
    await pumpDiscover(tester, DiscoverPage(repository: repo));
    await tester.enterText(find.byType(TextField), 'HAFIZ');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('discover-hafiz-dubai-mall')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('discover-bosporus-jbr')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('discover-filters')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menüsü yayımlananlar'));
    await tester.tap(find.byKey(const ValueKey('apply-discover-filters')));
    await tester.pumpAndSettle();
    expect(find.text('Bu filtrelerle kayıt bulunamadı.'), findsOneWidget);
    await tester.tap(find.text('Tüm kayıtları göster'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tüm kategoriler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sağlık'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('discover-dr-tosun')), findsOneWidget);
    expect(find.byKey(const ValueKey('discover-bosporus-jbr')), findsNothing);
  });
  testWidgets('Detail opens official menu and separate Google and Waze targets',
      (tester) async {
    final repo = repository();
    final item = repo.find('sultan-dubai')!;
    final opened = <Uri>[];
    await pumpDiscover(
        tester,
        PlaceDetailPage(
            item: item,
            repository: repo,
            openLink: (uri) async {
              opened.add(uri);
            }));
    Future<void> tapRevealed(Finder target) async {
      await tester.scrollUntilVisible(target, 180,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    await tapRevealed(find.text('Resmî menüyü aç'));
    await tapRevealed(find.byKey(const ValueKey('google-directions')));
    await tapRevealed(find.byKey(const ValueKey('waze-directions')));
    expect(opened, [
      Uri.parse(item.menuUrl!),
      item.directions('google'),
      item.directions('waze')
    ]);
  });
  for (final width in [320.0, 393.0, 430.0]) {
    testWidgets('Discover fits width $width with large text and all categories',
        (tester) async {
      await pumpDiscover(tester, DiscoverPage(repository: repository()),
          width: width, scale: 1.3);
      for (var i = 0; i < 23; i++) {
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
  testWidgets(
      'All detail pages fit small screens and missing locations show no map buttons',
      (tester) async {
    final repo = repository();
    for (final item in repo.catalog.entries) {
      await pumpDiscover(tester,
          PlaceDetailPage(key: ValueKey(item.id), item: item, repository: repo),
          width: 320, scale: 1.3);
      for (var i = 0; i < 6; i++) {
        await tester.drag(find.byType(ListView).first, const Offset(0, -450));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: item.id);
      }
      if (!item.hasLocation) {
        expect(find.byKey(const ValueKey('google-directions')), findsNothing);
      }
    }
  });
}
