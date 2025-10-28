// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieexplorer/app.dart';

void main() {
  testWidgets('App renders HomeView title', (WidgetTester tester) async {
    // Build app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the home screen title is present.
    expect(find.text('Movie Explorer'), findsOneWidget);
  });
}
