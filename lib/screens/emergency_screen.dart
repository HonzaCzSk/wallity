import 'package:flutter/material.dart';
import 'panic_scenario_screen.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouzový režim'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            const Text(
              'Vyber situaci',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            _scenarioCard(
              context,
              icon: Icons.phone_in_talk,
              title: 'Volali mi z banky / policie',
              subtitle: 'Možný vishing (falešný hovor)',
              onTap: () => _openScenario(
                context,
                PanicScenarioType.vishing,
              ),
            ),

            _scenarioCard(
              context,
              icon: Icons.sms,
              title: 'Klikl/a jsem na odkaz v SMS/e-mailu',
              subtitle: 'Možný smishing / phishing',
              onTap: () => _openScenario(
                context,
                PanicScenarioType.smishing,
              ),
            ),

            _scenarioCard(
              context,
              icon: Icons.credit_card,
              title: 'Zadal/a jsem údaje z karty / autorizační kód',
              subtitle: 'Vysoké riziko – jednejte okamžitě',
              onTap: () => _openScenario(
                context,
                PanicScenarioType.highRisk,
              ),
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 12),

            const Text(
              'Pokud si nejste jistí, vyberte scénář, který je nejblíže vaší situaci. '
              'Aplikace vás provede konkrétními kroky.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  static void _openScenario(
    BuildContext context,
    PanicScenarioType type,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PanicScenarioScreen(
          scenario: type,
        ),
      ),
    );
  }
}