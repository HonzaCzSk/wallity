import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O aplikaci'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SizedBox(height: 8),
            Text(
              'Safe Banking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('Verze: 1.0.0'),
            SizedBox(height: 12),
            Text(
              'Tato aplikace poskytuje uživatelům přehled bezpečnostních doporučení týkajících se bankovních služeb, '
              'návody pro zablokování karty a interaktivní výcvik v rozpoznávání podvodů. Obsah je pouze informativní a '
              'nenahrazuje oficiální komunikaci s vaší bankou.',
            ),
            SizedBox(height: 16),
            Text(
              'Autoři / Kontakt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Jan Votroubek – student SŠ a VOŠ Aplikované kybernetiky v Hradci Králové.',
            ),
            SizedBox(height: 16),
            Text(
              'Právní upozornění',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Informace v aplikaci jsou poskytovány bez záruky. V případě nouze vždy kontaktujte svoji banku přímo pomocí '
              'oficiálních kanálů. Aplikace neukládá citlivé údaje uživatele.\n',
            ),
          ],
        ),
      ),
    );
  }
}
