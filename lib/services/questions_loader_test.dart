// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:wallity/services/questions_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Loads kids questions without crashing', () async {
    final q = await loadQuestions(kidsMode: true);
    expect(q.isNotEmpty, true);
  });

  test('Loads normal questions without crashing', () async {
    final q = await loadQuestions(kidsMode: false);
    expect(q.isNotEmpty, true);
  });
}
