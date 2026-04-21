import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/remote_config.dart';
import '../utils/seo.dart';
import '../utils/language.dart';
import '../lang/app_strings.dart';

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
    } catch (_) {}
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);
        final isDevBuild = _version == 'dev' && _buildNumber == 'dev';

        return Scaffold(
          appBar: AppBar(title: Text(s.aboutTitle)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Wallity',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  s.aboutDescription,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.versionLabel,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(isDevBuild
                            ? s.devBuild
                            : s.appVersion(_version, _buildNumber)),
                        const Text('Databáze (remote): ${RemoteConfig.dataVersion}'),
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
                        Text(s.howItWorks,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          s.howItWorksBody,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.cloud_download_outlined),
                          title: Text(s.onlineData),
                          subtitle: const Text(RemoteConfig.baseDataUrl),
                          onTap: () => _openUrl(RemoteConfig.baseDataUrl),
                        ),
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
                        Text(s.importantNotice,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          s.noticeBody,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () => _openUrl('https://wallity.cz'),
                  child: Text(s.openWebsite),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => _openUrl('https://github.com/HonzaCzSk/wallity'),
                  child: Text(s.githubRepo),
                ),

                const SizedBox(height: 18),
                Text(
                  s.license,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
