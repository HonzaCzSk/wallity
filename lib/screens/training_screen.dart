// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../services/questions_loader.dart';

class TrainingScreen extends StatefulWidget {
  final bool kidsMode;

  const TrainingScreen({super.key, required this.kidsMode});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late Future<List<QuizQuestion>> _futureAll;
  int _level = 1;

  List<QuizQuestion> _questions = [];
  bool _loaded = false;

  int _index = 0;
  int _score = 0;
  bool _answered = false;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _futureAll = loadQuestions(kidsMode: widget.kidsMode);
  }

void _applyLevel(List<QuizQuestion> all, int level) {
  final filtered = all.where((q) => (q.difficulty == level)).toList();
  final use = filtered.isNotEmpty ? filtered : all;

  // ✅ Random pořadí pokaždé
  final shuffled = List<QuizQuestion>.from(use)..shuffle();

  setState(() {
    _level = level;
    _questions = shuffled;
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

  void _next() {
    if (_index >= _questions.length - 1) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(widget.kidsMode ? "Hotovo! 🎉" : "Dokončeno ✅"),
          content: Text("Skóre: $_score / ${_questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restart();
              },
              child: Text(widget.kidsMode ? "Znovu" : "Spustit znovu"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _loaded = false; // zpět na výběr levelu
                });
              },
              child: const Text("Změnit obtížnost"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Zpět"),
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

  Widget _buildLevelPicker(List<QuizQuestion> all) {
    final title = widget.kidsMode ? "Vyber obtížnost" : "Vyber obtížnost";
    final easy = widget.kidsMode ? "Lehké 😊" : "Lehké";
    final hard = widget.kidsMode ? "Těžší 😈" : "Těžší";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            widget.kidsMode
                ? "Začni lehkým levelem. Když dáš, zkus těžší."
                : "Zvol si obtížnost. Otázky se filtrují podle levelu.",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _applyLevel(all, 1),
            child: Text(easy),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _applyLevel(all, 2),
            child: Text(hard),
          ),

          const SizedBox(height: 16),
          Text(
            widget.kidsMode
                ? "Tip: nikdy nikomu neposílej heslo ani kód z SMS."
                : "Tip: nikdy nesděluj autorizační kód z SMS ani přihlašovací údaje.",
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kidsMode ? "Dětský trénink" : "Bezpečnostní výcvik"),
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _futureAll,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Chyba: ${snap.error}"));
          }

          final all = snap.data ?? [];
          if (all.isEmpty) {
            return const Center(child: Text("Žádné otázky."));
          }

          // Level picker
          if (!_loaded) {
            return _buildLevelPicker(all);
          }

          final q = _questions[_index];
          final total = _questions.length;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ Score + progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Level: $_level",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Skóre: $_score / $total",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: (_index + 1) / total),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _loaded = false;
                      });
                    },
                    child: const Text("Změnit obtížnost"),
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  "Otázka ${_index + 1}/$total",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(q.prompt, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                ...List.generate(q.choices.length, (i) {
                  final isPicked = _selected == i;
                  final isCorrect = i == q.correctIndex;

                  Color? bg;
                  if (_answered) {
                    if (isCorrect) bg = Colors.green.withOpacity(0.15);
                    if (isPicked && !isCorrect) bg = Colors.red.withOpacity(0.15);
                  }

                  final label = widget.kidsMode ? "👉 ${q.choices[i]}" : q.choices[i];

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
                        ? (widget.kidsMode ? "Super! 🌟" : "Správně ✅")
                        : (widget.kidsMode ? "Zkus to znovu 🙂" : "Špatně ❌"),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(q.explanation),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _next,
                    child: const Text("Další"),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}