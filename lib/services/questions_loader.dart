import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/quiz_question.dart';

Future<List<QuizQuestion>> loadQuestions({required bool kidsMode}) async {
  final path = kidsMode
      ? 'assets/data/questions_kids.json'
      : 'assets/data/questions_normal.json';

  final raw = await rootBundle.loadString(path);
  final decoded = jsonDecode(raw) as List<dynamic>;

  return decoded
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList();
}
