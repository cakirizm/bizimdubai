import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizimdubai/main.dart';

Future<void> pumpHome(WidgetTester tester,
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
      home: const Scaffold(body: HomePage())));
  await tester.pumpAndSettle();
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder.hitTestable(), 180,
      scrollable: find.byType(Scrollable).first, maxScrolls: 40);
  await tester.pumpAndSettle();
  expect(finder.hitTestable(), findsOneWidget);
}

void main() {
  testWidgets('Restaurant category opens grouped restaurants and returns to Home',
      (tester) async {
    await pumpHome(tester);
    final shortcut = find.byKey(const ValueKey('category-Restoranlar'));
    await reveal(tester, shortcut);
    await tester.tap(shortcut.hitTestable());
    await tester.pumpAndSettle();
    expect(find.byType(DiscoverPage), findsOneWidget);
    expect(find.text('Harput Restaurant'), findsWidgets);
    expect(find.text('Dr Tosun Dental Clinic'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Recommended event opens the matching event detail',
      (tester) async {
    await pumpHome(tester);
    final rail = find.byKey(const ValueKey('home-recommendations'));
    await reveal(tester, rail);
    await tester.drag(rail, const Offset(-265, 0));
    await tester.pumpAndSettle();
    final card =
        find.widgetWithText(HomeRecommendedCard, 'Yeni Gelenler Kahvesi');
    expect(card.hitTestable(), findsOneWidget);
    await tester.tap(card.hitTestable());
    await tester.pumpAndSettle();
    expect(find.byType(EventDetailPage), findsOneWidget);
    expect(find.text('Cumartesi · 17:30 · Marina'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Carousel advances automatically and supports manual paging',
      (tester) async {
    await pumpHome(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final carousel = find.byKey(const ValueKey('home-carousel'));
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('Mekanlara git').hitTestable(), findsOneWidget);
    await tester.drag(carousel, const Offset(-330, 0));
    await tester.pumpAndSettle();
    expect(find.text('Topluluğa git').hitTestable(), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Favorite button toggles without opening a destination',
      (tester) async {
    await pumpHome(tester);
    await reveal(tester, find.byKey(const ValueKey('home-recommendations')));
    final favorite = find.byTooltip('Favorilere ekle').hitTestable().first;
    await tester.tap(favorite);
    await tester.pump();
    expect(find.byTooltip('Favorilerden çıkar').hitTestable(), findsOneWidget);
    expect(find.byType(PlaceDetailPage), findsNothing);
    await tester.tap(find.byTooltip('Favorilerden çıkar').hitTestable());
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final width in [320.0, 393.0, 430.0]) {
    testWidgets('All Home sections fit at width $width with larger text',
        (tester) async {
      await pumpHome(tester, width: width, scale: 1.3);
      expect(tester.takeException(), isNull);
      final grid = find.byKey(const ValueKey('home-categories'));
      await reveal(tester, grid);
      final widget = tester.widget<GridView>(grid);
      expect(
          (widget.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
              .crossAxisCount,
          3);
      for (var i = 0; i < 8; i++) {
        await tester.drag(
            find.byKey(const ValueKey('home-scroll')), const Offset(0, -180));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
