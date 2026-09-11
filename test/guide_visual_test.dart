import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizimdubai/main.dart';

Future<void> pumpGuide(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualGuidePage())));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('visual Guide matches premium reference structure', (tester) async {
    await pumpGuide(tester);

    expect(find.byKey(const ValueKey('guide-hero')), findsOneWidget);
    expect(find.text('Dubai’ye\nyeni mi geldin?'), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-category-grid')), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-featured-grid')), findsOneWidget);
    expect(find.text('Öne Çıkan Rehberler'), findsOneWidget);
    expect(find.text('SIM / eSIM: du, e&, Virgin Mobile'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Guide hero opens the ordered newcomer journey', (tester) async {
    await pumpGuide(tester);
    await tester.tap(find.byKey(const ValueKey('guide-hero')));
    await tester.pumpAndSettle();

    expect(find.byType(VisualGuideJourneyPage), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-journey-list')), findsOneWidget);
    expect(find.text('Yeni gelenler yol haritası'), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-journey-sim')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('driving licence detail has steps, documents, locations and official links', (tester) async {
    await pumpGuide(tester);
    await tester.tap(find.byKey(const ValueKey('guide-hero')));
    await tester.pumpAndSettle();

    final driving = find.byKey(const ValueKey('guide-journey-driving-licence'));
    await tester.scrollUntilVisible(
      driving,
      220,
      scrollable: find.byType(Scrollable).last,
      maxScrolls: 30,
    );
    await tester.tap(driving);
    await tester.pumpAndSettle();

    expect(find.byType(VisualGuideArticlePage), findsOneWidget);
    expect(find.text('Türk ehliyetini Dubai ehliyetine çevirme'), findsOneWidget);
    expect(find.text('Adım adım'), findsOneWidget);

    final detailScroll = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.text('Hazırla'),
      260,
      scrollable: detailScroll,
      maxScrolls: 20,
    );
    expect(find.text('Hazırla'), findsOneWidget);
    expect(find.text('Nereye gidebilirim?'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Resmî kaynaklar'),
      260,
      scrollable: detailScroll,
      maxScrolls: 20,
    );
    expect(find.text('Resmî kaynaklar'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('guide-primary-action')),
      260,
      scrollable: detailScroll,
      maxScrolls: 20,
    );
    expect(find.byKey(const ValueKey('guide-primary-action')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
