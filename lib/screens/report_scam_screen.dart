import 'package:flutter/material.dart';
import '../widgets/panic_shell.dart';

class ReportScamScreen extends StatelessWidget {
  const ReportScamScreen({super.key});

Future<bool> _confirmLeave(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      title: const Text('Opravdu chcete odejít?'),
      content: const Text(
        'Jste v krizovém režimu. Odchod může zpomalit řešení situace.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Zůstat'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Odejít'),
        ),
      ],
    ),
  );
  return res ?? false;
}

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    // ignore: deprecated_member_use
    onPopInvoked: (didPop) async {
      if (didPop) return;
      final leave = await _confirmLeave(context);
      if (!context.mounted) return;
      if (leave) Navigator.of(context).pop();
    },
    child: const PanicShell(
      title: 'Postup při podvodu',
      child: SingleChildScrollView(
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
    ),
  );
  }
}
