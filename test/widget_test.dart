// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:risy/main.dart';

void main() {
  testWidgets('Risy app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RisyApp());

    // Verify that splash screen loads
    expect(find.text('Risy'), findsOneWidget);
    expect(find.text('Smart Home Automation'), findsOneWidget);
  });
}
