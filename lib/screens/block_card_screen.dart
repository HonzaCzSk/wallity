import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockCardScreen extends StatefulWidget {
  const BlockCardScreen({super.key});

  @override
  State<BlockCardScreen> createState() => _BlockCardScreenState();
}

class _BlockCardScreenState extends State<BlockCardScreen> {
  late Future<List<Map<String, dynamic>>> _futureBanks;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _futureBanks = _loadBanks();
  }

  Future<List<Map<String, dynamic>>> _loadBanks() async {
    final raw = await rootBundle.loadString('assets/data/banks.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
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
    await launchUrl(uri);
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Používejte jen oficiální kontakty. Nevolejte čísla ze SMS/e-mailů.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: phone.trim().isEmpty ? null : () => _callPhone(phone),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: Text(
                  phone.trim().isEmpty ? "Blokace karty: není k dispozici" : "Zavolat blokaci karty",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: website.trim().isEmpty ? null : () => _openUrl(website),
                child: const Text("Otevřít web banky"),
              ),
              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: (fraud.trim().isEmpty && website.trim().isEmpty)
                    ? null
                    : () => _openUrl(fraud.trim().isEmpty ? website : fraud),
                child: const Text("Bezpečnost / nahlášení podvodu"),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Zablokovat kartu")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Vyhledat banku",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final bank = filtered[i];
                      final name = (bank['name'] ?? 'Banka') as String;
                      final phone = (bank['cardBlockPhone'] ?? '') as String;

                      return Card(
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text(
                            phone.trim().isEmpty ? "Blokace karty: není k dispozici" : "Blokace karty: $phone",
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showBankActions(bank),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
