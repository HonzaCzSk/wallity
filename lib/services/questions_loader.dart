import '../config/remote_config.dart';
import '../models/quiz_question.dart';
import 'remote_json_loader.dart';

class QuestionsLoadResult {
  final List<QuizQuestion> questions;
  final bool fromRemote;

  const QuestionsLoadResult({
    required this.questions,
    required this.fromRemote,
  });
}

Future<QuestionsLoadResult> loadQuestions({required bool kidsMode}) async {
  final remoteUrl =
      kidsMode ? RemoteConfig.kidsQuestionsUrl() : RemoteConfig.normalQuestionsUrl();

  final assetPath =
      kidsMode ? 'assets/data/questions_kids.json' : 'assets/data/questions_normal.json';

  final result = await loadJsonListWithFallback(
    remoteUrl: remoteUrl,
    assetPath: assetPath,
  );

  final questions = result.data
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList();

  return QuestionsLoadResult(
    questions: questions,
    fromRemote: result.fromRemote,
  );
}
