import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:books_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('first integration test', () {
    testWidgets('see title on main screen', (WidgetTester tester) async {
      print('hello1');
      await app.main();
      print('hello2');
      await tester.pumpAndSettle();
      print('hello3');
      expect(find.text('Books'), findsOneWidget);
    });
  });
}
