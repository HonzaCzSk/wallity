// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/banks_loader.dart';
import '../widgets/panic_shell.dart';

class EmergencyBankSelectScreen extends StatefulWidget {
  const EmergencyBankSelectScreen({super.key});

  @override
  State<EmergencyBankSelectScreen> createState() =>
      _EmergencyBankSelectScreenState();
}

class _EmergencyBankSelectScreenState extends State<EmergencyBankSelectScreen> {
  late Future<List<Map<String, dynamic>>> _futureBanks;
  String _query = "";

Future<bool> _confirmLeave() async {
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
  void initState() {
    super.initState();
    _futureBanks = loadBanks();
  }

  Future<void> _openUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _callPhone(String phone) async {
    final p = phone.trim();
    if (p.isEmpty) return;

    final uri = Uri(scheme: 'tel', path: p);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showBankActions(Map<String, dynamic> bank) {
    final name = (bank['name'] ?? '') as String;
    final phone = (bank['cardBlockPhone'] ?? '') as String;
    final website = (bank['websiteUrl'] ?? '') as String;
    final fraud = (bank['fraudReportUrl'] ?? '') as String;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name.isEmpty ? "Banka" : name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Používejte jen oficiální kontakty. Nevolejte čísla ze SMS/e-mailů.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: phone.trim().isEmpty ? null : () => _callPhone(phone),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A0C0C),
                ),
                icon: const Icon(Icons.phone, color: Colors.white),
                label: Text(
                  phone.trim().isEmpty
                      ? "Telefon banky: není k dispozici"
                      : "Zavolat bance (oficiální linka)",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed:
                    website.trim().isEmpty ? null : () => _openUrl(website),
                icon: const Icon(Icons.public),
                label: const Text("Otevřít web banky"),
              ),
              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: (fraud.trim().isEmpty && website.trim().isEmpty)
                    ? null
                    : () => _openUrl(fraud.trim().isEmpty ? website : fraud),
                icon: const Icon(Icons.security),
                label: const Text("Bezpečnost / nahlášení podvodu"),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvoked: (didPop) async {
      if (didPop) return;
      final leave = await _confirmLeave();
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      if (leave) Navigator.of(context).pop();
    },
    child: PanicShell(
      title: 'Kontaktovat banku',
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureBanks,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Chyba: ${snap.error}"));
          }

          final banks = snap.data ?? [];
          if (banks.isEmpty) {
            return const Center(child: Text("Žádné banky v databázi."));
          }

          final filtered = banks.where((b) {
            final name = ((b['name'] ?? '') as String).toLowerCase();
            return name.contains(_query.toLowerCase());
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _NoticeCard(),
              const SizedBox(height: 16),

              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: "Hledat banku…",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ...filtered.map((bank) {
                final name = (bank['name'] ?? '') as String;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: Text(
                      name.isEmpty ? "Banka" : name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text("Otevřít oficiální kontakty"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showBankActions(bank),
                  ),
                );
              }),

              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: Text("Nic nenalezeno.")),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF7A0C0C).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7A0C0C).withOpacity(0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nevolejte zpět na číslo z SMS nebo e-mailu.\n'
              'Použijte pouze oficiální web/aplikaci banky nebo kontakt z této obrazovky.',
            ),
          ),
        ],
      ),
    );
  }
}
