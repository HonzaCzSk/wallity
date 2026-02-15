class QuizQuestion {
  final String id;
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final int difficulty;

  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      choices: (json['choices'] as List).cast<String>(),
      correctIndex: json['correctIndex'] as int,
      explanation: (json['explanation'] ?? '') as String,
      difficulty: (json['difficulty'] ?? 1) as int,
    );
  }
}
