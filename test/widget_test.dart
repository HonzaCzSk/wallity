import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallity/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> scrollToText(WidgetTester tester, String text) async {
    final scrollable = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      find.text(text),
      300, // scroll delta
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('App starts and shows Home', (WidgetTester tester) async {
    await tester.pumpWidget(const WallityApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Wallity'), findsWidgets);
  });

  testWidgets('Kids training opens and shows difficulty picker', (WidgetTester tester) async {
    await tester.pumpWidget(const WallityApp());
    await tester.pumpAndSettle();

    // Scroll to kids training button (it can be off-screen on 800x600)
    await scrollToText(tester, 'Dětský trénink 👶');

    await tester.tap(find.text('Dětský trénink 👶'));
    await tester.pumpAndSettle();

    // Difficulty picker should appear
    expect(find.text('Vyber obtížnost'), findsOneWidget);

    // Choose Easy
    await tester.tap(find.text('Lehké 😊'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Skóre:'), findsOneWidget);
  });

  testWidgets('Normal training opens and shows difficulty picker', (WidgetTester tester) async {
    await tester.pumpWidget(const WallityApp());
    await tester.pumpAndSettle();

    // Scroll to normal training button (can also be off-screen)
    await scrollToText(tester, 'Trénink');

    await tester.tap(find.text('Trénink'));
    await tester.pumpAndSettle();

    expect(find.text('Vyber obtížnost'), findsOneWidget);

    await tester.tap(find.text('Lehké'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Skóre:'), findsOneWidget);
  });

  testWidgets('Emergency button opens emergency flow', (WidgetTester tester) async {
    await tester.pumpWidget(const WallityApp());
    await tester.pumpAndSettle();

    // Your Home has "Nouzový režim" (Variant 1). If you renamed it, change here.
    await scrollToText(tester, 'Nouzový režim');

    await tester.tap(find.text('Nouzový režim'));
    await tester.pumpAndSettle();

    // We don't assert exact screen title because you might use "Nouzový režim" / "Zablokovat kartu".
    // Just verify navigation happened by finding an AppBar with some text.
    expect(find.byType(AppBar), findsWidgets);
  });
}
