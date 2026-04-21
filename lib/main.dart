import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';
import 'utils/language.dart';

void main() {
  runApp(const WallityApp());
}

class WallityApp extends StatelessWidget {
  const WallityApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder zajistí rebuild celé app při změně jazyka.
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        return MaterialApp(
          title: 'Wallity',
          theme: AppTheme.light(),
          home: const HomePage(),
        );
      },
    );
  }
}
