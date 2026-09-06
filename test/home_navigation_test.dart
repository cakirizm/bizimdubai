import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizimdubai/main.dart';

void main() {
  testWidgets('Restaurant shortcut opens the filtered directory and returns', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomePage())));
    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Mekanlar'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Mekanlar'));
    await tester.pumpAndSettle();
    expect(find.text('Bosporus Turkish Cuisine · The Beach'), findsWidgets);
    expect(find.text('Dr Tosun Dental Clinic'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('BİZİM DUBAİ'), findsOneWidget);
  });

  testWidgets('Featured event opens its own details', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomePage())));
    final card = find.widgetWithText(TodayCard, 'Cuma Halı Saha');
    await tester.scrollUntilVisible(card, 250, scrollable: find.byType(Scrollable).first, maxScrolls: 50);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(EventDetailPage), findsOneWidget);
    expect(find.text('Cuma · 21:00 · Al Quoz'), findsOneWidget);
  });

  testWidgets('Home stays within a narrow screen with larger text', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.3)),
      child: child!), home: const Scaffold(body: HomePage())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
