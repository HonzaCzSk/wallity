import 'package:flutter/material.dart';
import '../models/bank.dart';
import '../utils/seo.dart';
import '../widgets/bank_logo.dart';

class BankDetailScreen extends StatefulWidget {
  final Bank bank;

  const BankDetailScreen({super.key, required this.bank});

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  Bank get bank => widget.bank;

  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: '\${widget.bank.name} – Wallity',
      description: 'Bezpečnostní informace, kontakty a přehled podvodů pro \${widget.bank.name}.',
    );
  }

  ({Color color, IconData icon, String label}) safetyBadgeFor(String rating) {
    // Keep mapping intentionally simple and user-focused.
    switch (rating) {
      case 'A+':
      case 'A':
      case 'A-':
        return (color: Colors.green, icon: Icons.verified_user, label: 'Vysoká bezpečnost');
      case 'B+':
      case 'B':
      case 'B-':
        return (color: Colors.blue, icon: Icons.shield_outlined, label: 'Dobrá bezpečnost');
      case 'C+':
      case 'C':
      case 'C-':
        return (color: Colors.orange, icon: Icons.report_outlined, label: 'Pozor');
      case 'D':
        return (color: Colors.red, icon: Icons.dangerous_outlined, label: 'Vysoké riziko');
      default:
        return (color: Colors.black54, icon: Icons.help_outline, label: 'Neznámé');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: Row(
          children: [
            BankLogo(
              name: bank.name,
              assetPath: bank.logoAsset,
              imageUrl: bank.logoUrl,
              websiteUrl: bank.websiteUrl,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(bank.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        // Keep the system back button (leading) intact.
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Builder(
            builder: (context) {
              final badge = safetyBadgeFor(bank.rating);
              return Card(
                elevation: 0,
                color: badge.color.withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Icon(badge.icon, color: badge.color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: badge.color,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Hodnocení: ${bank.rating}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Sections
          buildSection("Podvodné SMS / Email", bank.phishingExamples),
          buildSection("Časté podvody", bank.commonScams),
          buildSection("Nedávné incidenty", bank.recentIncidents),
          buildSection(
            "Doporučená bezpečnostní opatření",
            bank.recommendedActions,
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<String> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: items
            .map(
              (e) => ListTile(
                leading: const Icon(Icons.arrow_right),
                title: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
