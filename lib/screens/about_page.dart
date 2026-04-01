import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/remote_config.dart';
import '../utils/seo.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '-';
  String _buildNumber = '-';

  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'O aplikaci – Wallity',
      description: 'Informace o aplikaci Wallity, verze, zdroj dat a důležitá upozornění.',
    );
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        final v = info.version.trim();
        final b = info.buildNumber.trim();

        _version = v.isEmpty ? 'dev' : v;
        _buildNumber = b.isEmpty ? 'dev' : b;
      });
    } catch (_) {
      // necháme '-' (např. web build / omezení prostředí)
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("O aplikaci")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Wallity", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Offline průvodce bezpečností: rychlé kontakty bank, nouzové kroky a krátké tréninky proti podvodům.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Verze", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      _version == 'dev' && _buildNumber == 'dev'
                          ? "Aplikace: dev build"
                          : "Aplikace: $_version (build $_buildNumber)",
                    ),
                    const Text("Databáze (remote): ${RemoteConfig.dataVersion}"),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Jak to funguje", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      "Aplikace funguje offline. Když je internet k dispozici, může si stáhnout novější data (např. otázky a databázi bank).",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.cloud_download_outlined),
                      title: const Text("Online data"),
                      subtitle: const Text(RemoteConfig.baseDataUrl),
                      onTap: () => _openUrl(RemoteConfig.baseDataUrl),
                    ),
                  ],
                ),
              ),
            ),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Důležité upozornění", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      "• Wallity není banka ani státní instituce.\n"
                      "• Nikdy neposílejte kódy z SMS ani přihlašovací údaje.\n"
                      "• V nouzi používejte pouze oficiální kontakty a webové adresy.",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => _openUrl("https://wallity.cz"),
              child: const Text("Otevřít wallity.cz"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _openUrl("https://github.com/HonzaCzSk/wallity"),
              child: const Text("GitHub repozitář"),
            ),

            const SizedBox(height: 18),
            const Text(
              "Licence: MIT",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
