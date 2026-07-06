import 'package:flutter_test/flutter_test.dart';
import 'package:l_addition_app/app.dart';

void main() {
  testWidgets('renders start screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LAdditionApp());

    expect(find.text('The Art of the Split'), findsOneWidget);
  });
}
