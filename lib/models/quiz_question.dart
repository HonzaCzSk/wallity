class QuizQuestion {
  final String id;
  final String prompt;
  final String? promptEn;
  final List<String> choices;
  final List<String>? choicesEn;
  final int correctIndex;
  final String explanation;
  final String? explanationEn;
  final int difficulty;

  const QuizQuestion({
    required this.id,
    required this.prompt,
    this.promptEn,
    required this.choices,
    this.choicesEn,
    required this.correctIndex,
    required this.explanation,
    this.explanationEn,
    required this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String? ?? '',
      prompt: json['prompt'] as String,
      promptEn: json['prompt_en'] as String?,
      choices: List<String>.from(json['choices'] as List),
      choicesEn: json['choices_en'] != null
          ? List<String>.from(json['choices_en'] as List)
          : null,
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      explanationEn: json['explanation_en'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }

  /// Returns the prompt in the requested language (falls back to Czech).
  String localizedPrompt(bool en) =>
      (en && promptEn != null && promptEn!.isNotEmpty) ? promptEn! : prompt;

  /// Returns the choices in the requested language (falls back to Czech).
  List<String> localizedChoices(bool en) =>
      (en && choicesEn != null && choicesEn!.isNotEmpty) ? choicesEn! : choices;

  /// Returns the explanation in the requested language (falls back to Czech).
  String localizedExplanation(bool en) =>
      (en && explanationEn != null && explanationEn!.isNotEmpty)
          ? explanationEn!
          : explanation;
}
