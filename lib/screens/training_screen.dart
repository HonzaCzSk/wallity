// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../services/questions_loader.dart';
import '../utils/seo.dart';
import '../utils/language.dart';
import '../lang/app_strings.dart';

class TrainingScreen extends StatefulWidget {
  final bool kidsMode;
  const TrainingScreen({super.key, required this.kidsMode});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late Future<QuestionsLoadResult> _futureAll;

  int _level = 1;
  bool _fromRemote = false;

  List<QuizQuestion> _questions = [];
  int _originalTotal = 0;
  bool _loaded = false;

  int _index = 0;
  int _score = 0;
  bool _answered = false;
  int? _selected;

  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Bezpečnostní trénink – Wallity',
      description: 'Interaktivní kvízy pro rozpoznání phishingu a finančních podvodů.',
    );
    _futureAll = loadQuestions(kidsMode: widget.kidsMode);
  }

  void _applyLevel(List<QuizQuestion> all, int level) {
    final filtered = all.where((q) => q.difficulty == level).toList();
    final use = filtered.isNotEmpty ? filtered : all;
    final shuffled = List<QuizQuestion>.from(use)..shuffle();

    setState(() {
      _level = level;
      _originalTotal = use.length;
      _questions = shuffled.take(5).toList();
      _loaded = true;
      _index = 0;
      _score = 0;
      _answered = false;
      _selected = null;
    });
  }

  void _answer(QuizQuestion q, int picked) {
    if (_answered) return;
    final correct = picked == q.correctIndex;
    setState(() {
      _answered = true;
      _selected = picked;
      if (correct) _score++;
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _answered = false;
      _selected = null;
    });
  }

  void _next(S s) {
    if (_index >= _questions.length - 1) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(widget.kidsMode ? s.doneKids : s.doneNormal),
          content: Text(s.scoreDialog(_score, _questions.length)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restart();
              },
              child: Text(widget.kidsMode ? s.playAgainKids : s.playAgainNormal),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _loaded = false);
              },
              child: Text(s.changeDifficulty),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(s.back),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _index++;
      _answered = false;
      _selected = null;
    });
  }

  Widget _buildLevelPicker(List<QuizQuestion> all, S s) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Text(s.selectDifficulty, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            widget.kidsMode ? s.difficultyHintKids : s.difficultyHintNormal,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Text(
            _fromRemote ? s.loadedOnline : s.loadedOffline,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _applyLevel(all, 1),
            child: Text(widget.kidsMode ? s.easyKids : s.easyNormal),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _applyLevel(all, 2),
            child: Text(widget.kidsMode ? s.harderKids : s.harderNormal),
          ),
          const SizedBox(height: 16),
          Text(
            widget.kidsMode ? s.tipKids : s.tipNormal,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.kidsMode ? s.kidsTrainingTitle : s.securityTrainingTitle),
          ),
          body: FutureBuilder<QuestionsLoadResult>(
            future: _futureAll,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('${s.errorPrefix}${snap.error}'));
              }

              final result = snap.data;
              final all = result?.questions ?? [];
              _fromRemote = result?.fromRemote ?? false;

              if (all.isEmpty) {
                return Center(child: Text(s.noQuestions));
              }

              if (!_loaded) {
                return _buildLevelPicker(all, s);
              }

              final q = _questions[_index];
              final total = _questions.length;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.levelLabel(_level),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(s.scoreLabel(_score, total, _originalTotal),
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: (_index + 1) / total),
                    const SizedBox(height: 6),
                    Text(
                      _fromRemote ? s.loadedOnline : s.loadedOffline,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => _loaded = false),
                        child: Text(s.changeDifficulty),
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(
                      s.questionLabel(_index + 1, total, _originalTotal),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(q.localizedPrompt(isEn), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),

                    ...List.generate(q.choices.length, (i) {
                      final isPicked = _selected == i;
                      final isCorrect = i == q.correctIndex;

                      Color? bg;
                      if (_answered) {
                        if (isCorrect) bg = Colors.green.withOpacity(0.15);
                        if (isPicked && !isCorrect) bg = Colors.red.withOpacity(0.15);
                      }

                      final choiceText = q.localizedChoices(isEn)[i];
                      final label = widget.kidsMode ? '👉 $choiceText' : choiceText;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            backgroundColor: bg,
                          ),
                          onPressed: () => _answer(q, i),
                          child: Text(label),
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                    if (_answered) ...[
                      Text(
                        (_selected == q.correctIndex)
                            ? (widget.kidsMode ? s.answerCorrectKids : s.answerCorrectNormal)
                            : (widget.kidsMode ? s.answerWrongKids : s.answerWrongNormal),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(q.localizedExplanation(isEn)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _next(s),
                        child: Text(s.next),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
