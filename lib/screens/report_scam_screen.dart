import 'package:flutter/material.dart';

class ReportScamScreen extends StatelessWidget {
  const ReportScamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nahlásit podvod"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Co udělat ihned:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("• Okamžitě kontaktujte svou banku."),
            Text("• Zablokujte kartu nebo přístup k účtu."),
            Text("• Neodpovídejte dále podvodníkovi."),
            SizedBox(height: 16),

            Text(
              "Koho kontaktovat:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("• Oficiální zákaznickou linku vaší banky."),
            Text("• Policii ČR (158) v případě finanční škody."),
            SizedBox(height: 16),

            Text(
              "Co si připravit:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("• Datum a čas incidentu."),
            Text("• Číslo účtu / karty (nikdy nesdělujte celé číslo veřejně)."),
            Text("• Screenshoty komunikace."),
            Text("• Částku, která byla odcizena."),
            SizedBox(height: 16),

            Text(
              "Na co si dát pozor:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("• Banka nikdy nevyžaduje autorizační kód po telefonu."),
            Text("• Nikdy nepřevádějte peníze na 'bezpečný účet'."),
            Text("• Neinstalujte aplikace na žádost neznámé osoby."),
          ],
        ),
      ),
    );
  }
}
