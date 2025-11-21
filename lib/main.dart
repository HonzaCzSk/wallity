import 'package:flutter/material.dart';
import 'package:safe_banking_app/screens/home_page.dart';

void main() {
  runApp(const SafeBankingApp());
}

class SafeBankingApp extends StatelessWidget {
  const SafeBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Banking',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
