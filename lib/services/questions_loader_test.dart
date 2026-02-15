// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:wallity/services/questions_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Loads kids questions without crashing', () async {
    final result = await loadQuestions(kidsMode: true);
    expect(result.questions.isNotEmpty, true);
    // fromRemote může být true/false podle připojení, netestujeme.
  });

  test('Loads normal questions without crashing', () async {
    final result = await loadQuestions(kidsMode: false);
    expect(result.questions.isNotEmpty, true);
  });
}
