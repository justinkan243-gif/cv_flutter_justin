import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_justin/main.dart';

void main() {
  testWidgets('L\'application démarre', (tester) async {
    await tester.pumpWidget(const CvFlutterApp());
    expect(find.text('Bienvenue'), findsOneWidget);
  });
}