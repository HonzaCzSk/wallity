import 'package:flutter/material.dart';
import 'package:wallity/screens/report_scam_screen.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouzový režim")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              "Co potřebujete udělat?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "V nouzi neklikejte na odkazy z SMS/e-mailu. Používejte jen oficiální kontakty.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Zablokovat kartu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportScamScreen()),
                );
              },
              child: const Text(
                "Zablokovat kartu",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            // Nahlásit podvod (zatím placeholder)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Nahlášení podvodu"),
                    content: const Text(
                      "Tady přidáme: postup, doporučené kroky a kontakty (banka / policie / CSIRT).",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                "Nahlásit podvod",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Tip: pokud jste už zadali údaje z karty nebo autorizační kód, jednejte okamžitě.",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
