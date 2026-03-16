import 'package:flutter/material.dart';
import '../utils/seo.dart';
import 'training_screen.dart';

class SecurityTrainingScreen extends StatefulWidget {
  const SecurityTrainingScreen({super.key});
  @override
  State<SecurityTrainingScreen> createState() => _SecurityTrainingScreenState();
}

class _SecurityTrainingScreenState extends State<SecurityTrainingScreen> {
  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Bezpečnostní trénink – Wallity',
      description: 'Interaktivní kvízy pro rozpoznání phishingu, vishingu a finančních podvodů.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const TrainingScreen(kidsMode: false);
  }
}
