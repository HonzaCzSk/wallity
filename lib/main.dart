import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const WallityApp());
}

class WallityApp extends StatelessWidget {
  const WallityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallity',
      theme: AppTheme.light(),
      home: const HomePage(),
    );
  }
}