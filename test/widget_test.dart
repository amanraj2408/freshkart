import 'package:flutter_test/flutter_test.dart';
import 'package:freshkart/main.dart';

void main() {
  testWidgets('FreshKart App Smoke Test - verifies launch and brand rendering', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FreshKartApp());

    // Verify FreshKart brand text is rendered on the splash screen
    expect(find.text('FreshKart'), findsOneWidget);
    expect(find.text('10 MINS GROCERY DELIVERY'), findsOneWidget);
  });
}
