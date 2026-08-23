import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/app.dart';

void main() {
  testWidgets('App renders landing page smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PushpakApp());
    await tester.pumpAndSettle();

    expect(find.text('Pushpak SaaS'), findsWidgets);
  });
}
