import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/bank.dart';

class SecurityTrainingScreen extends StatefulWidget {
  const SecurityTrainingScreen({super.key});

  @override
  State<SecurityTrainingScreen> createState() => _SecurityTrainingScreenState();
}

class _SecurityTrainingScreenState extends State<SecurityTrainingScreen> {
  List<String> _questions = [];
  int _score = 0;
  int _index = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final raw = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/banks.json');
    final data = jsonDecode(raw) as List<dynamic>;
    final banks = data.map((e) => Bank.fromJson(e)).toList();

    // Build simple question pool from phishing_examples
    final pool = <String>[];
    for (final b in banks) {
      pool.addAll(b.phishingExamples);
    }

    pool.shuffle(Random());

    setState(() {
      _questions = pool.take(10).toList();
      _loading = false;
      _index = 0;
      _score = 0;
    });
  }

  void _answer(bool isPhishing) {
    final correct = true;
    final wasCorrect = (isPhishing == correct);
    if (wasCorrect) _score++;

    _showExplanation(wasCorrect).then((_) {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1).clamp(0, _questions.length);
      });
    });
  }

  Future<void> _showExplanation(bool wasCorrect) async {
    final explanation = wasCorrect
        ? 'Správně — tyto příklady obsahují často následující znaky phishingu: naléhavé výzvy, neznámé odkazy, gramatické chyby nebo požadavky na sdílení citlivých údajů.'
        : 'Nesprávně — tento příklad byl připraven jako phishingový vzor. Hledejte známky jako nečekané požadavky, zkrácené odkazy nebo naléhavý jazyk.';

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(wasCorrect ? 'Správně' : 'Špatně'),
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Další'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Výcvik bezpečnosti'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _index >= _questions.length
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hotovo! Skóre: $_score / ${_questions.length}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadQuestions,
                          child: const Text('Zkusit znovu'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Otázka ${_index + 1} z ${_questions.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _questions[_index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () => _answer(true),
                          child: const Text('To je phishing'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => _answer(false),
                          child: const Text('To je legitimní'),
                        ),
                        const SizedBox(height: 24),
                        Text('Skóre: $_score', textAlign: TextAlign.center),
                      ],
                    ),
            ),
    );
  }
}
