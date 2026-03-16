import 'package:flutter/material.dart';
import '../utils/seo.dart';
import 'training_screen.dart';

class KidsTrainingScreen extends StatefulWidget {
  const KidsTrainingScreen({super.key});
  @override
  State<KidsTrainingScreen> createState() => _KidsTrainingScreenState();
}

class _KidsTrainingScreenState extends State<KidsTrainingScreen> {
  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Dětský trénink – Wallity',
      description: 'Hravé otázky pro děti o bezpečnosti na internetu a rozpoznání podvodů.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const TrainingScreen(kidsMode: true);
  }
}
