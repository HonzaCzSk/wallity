import 'package:flutter/material.dart';
import 'training_screen.dart';

class KidsTrainingScreen extends StatelessWidget {
  const KidsTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TrainingScreen(kidsMode: true);
  }
}
