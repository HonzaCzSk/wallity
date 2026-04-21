import 'package:flutter/material.dart';
import '../utils/seo.dart';
import '../utils/language.dart';
import '../lang/app_strings.dart';
import 'panic_scenario_screen.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Nouzový režim – Wallity',
      description: 'Vyber situaci a dostaň konkrétní postup: vishing, smishing nebo kompromitace karty.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);

        return Scaffold(
          appBar: AppBar(title: Text(s.emergencyScreenTitle)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  s.selectSituation,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                _scenarioCard(
                  context,
                  icon: Icons.phone_in_talk,
                  title: s.vishingTitle,
                  subtitle: s.vishingSubtitle,
                  onTap: () => _openScenario(context, PanicScenarioType.vishing),
                ),

                _scenarioCard(
                  context,
                  icon: Icons.sms,
                  title: s.smishingTitle,
                  subtitle: s.smishingSubtitle,
                  onTap: () => _openScenario(context, PanicScenarioType.smishing),
                ),

                _scenarioCard(
                  context,
                  icon: Icons.credit_card,
                  title: s.highRiskTitle,
                  subtitle: s.highRiskSubtitle,
                  onTap: () => _openScenario(context, PanicScenarioType.highRisk),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),

                Text(
                  s.emergencyFooter,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _scenarioCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(icon, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  static void _openScenario(BuildContext context, PanicScenarioType type) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PanicScenarioScreen(scenario: type)),
    );
  }
}
