// lib/screens/panic_scenario_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emergency_bank_select_screen.dart';
import 'report_scam_screen.dart';

enum PanicScenarioType {
  vishing,
  smishing,
  highRisk,
}

class PanicScenarioConfig {
  final String title;        // do AppBaru
  final String headline;     // krátce co se děje
  final List<String> doNow;  // 5–7 bodů co dělat teď
  final List<String> avoid;  // čemu se vyhnout
  final String copyScript;   // text ke kopírování

  const PanicScenarioConfig({
    required this.title,
    required this.headline,
    required this.doNow,
    required this.avoid,
    required this.copyScript,
  });
}

class PanicScenarioScreen extends StatefulWidget {
  final PanicScenarioType scenario;

  const PanicScenarioScreen({
    super.key,
    required this.scenario,
  });

  @override
  State<PanicScenarioScreen> createState() => _PanicScenarioScreenState();
}

class _PanicScenarioScreenState extends State<PanicScenarioScreen> {
  late final PanicScenarioConfig cfg;
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    cfg = _configFor(widget.scenario);
    checked = List<bool>.filled(cfg.doNow.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);

    final panicTheme = base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF7A0C0C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF7A0C0C),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final leave = await _confirmLeave();
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        if (leave) Navigator.of(context).pop();
      },
      child: Theme(
        data: panicTheme,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Text('⚠️  '),
                Expanded(
                  child: Text(
                    cfg.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _panicNoticeCard(),
                const SizedBox(height: 12),

                Text(
                  cfg.headline,
                  style: base.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ CTA nahoře (rychlá akce)
                _primaryActions(context),

                const SizedBox(height: 16),

                // Copy text hned po CTA (praktické během hovoru)
                OutlinedButton.icon(
                  onPressed: _copyScript,
                  icon: const Icon(Icons.copy),
                  label: const Text('Kopírovat text pro banku/policii'),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _noteCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Poznámka (volitelné)',
                    hintText: 'Čas, částka, co se stalo, číslo volajícího…',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: _copySummary,
                  icon: const Icon(Icons.assignment),
                  label: const Text('Kopírovat souhrn incidentu'),
                ),

                const SizedBox(height: 18),

                _sectionTitle(context, 'Co dělat teď'),
                const SizedBox(height: 8),
                ..._buildChecklist(),

                const SizedBox(height: 16),
                _sectionTitle(context, 'Čemu se vyhnout'),
                const SizedBox(height: 8),
                _avoidList(),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _primaryActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EmergencyBankSelectScreen(),
                ),
              );
            },
            icon: const Icon(Icons.phone_in_talk),
            label: const Text('Vybrat banku a jednat'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReportScamScreen(),
                ),
              );
            },
            icon: const Icon(Icons.description),
            label: const Text('Postup při podvodu'),
          ),
        ),
        const SizedBox(height: 10),

        // ✅ Zavolat 158 (s "sure" potvrzením)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _confirmAndCall158,
            icon: const Icon(Icons.local_police),
            label: const Text('Zavolat 158 (Policie)'),
          ),
        ),
      ],
    );
  }

  Widget _panicNoticeCard() {
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
              'Používejte jen oficiální kontakty.\n'
              'Nevolejte zpět na čísla z SMS/e-mailu a neklikejte na odkazy.',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copySummary() async {
    final checkedSteps = <String>[];
    for (var i = 0; i < cfg.doNow.length; i++) {
      if (checked[i]) checkedSteps.add(cfg.doNow[i]);
    }

    final scenarioLabel = switch (widget.scenario) {
      PanicScenarioType.vishing => 'Podezřelý hovor (vishing)',
      PanicScenarioType.smishing => 'Kliknutí na odkaz (phishing/smishing)',
      PanicScenarioType.highRisk => 'Zadány údaje/kód (vysoké riziko)',
    };

    final note = _noteCtrl.text.trim();

    final text = StringBuffer()
      ..writeln('SOUHRN INCIDENTU (doplňte čas/částky)')
      ..writeln('Scénář: $scenarioLabel')
      ..writeln('Popis: ${cfg.headline}')
      ..writeln('Čas události: ____')
      ..writeln('Částka (pokud): ____')
      ..writeln('')
      ..writeln('Co už jsem udělal/a:');

    if (checkedSteps.isEmpty) {
      text.writeln('- (zatím nic nezaškrtnuto)');
    } else {
      for (final s in checkedSteps) {
        text.writeln('- $s');
      }
    }

    if (note.isNotEmpty) {
      text
        ..writeln('')
        ..writeln('Poznámka:')
        ..writeln(note);
    }

    await Clipboard.setData(ClipboardData(text: text.toString()));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Souhrn zkopírován do schránky')),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }

  List<Widget> _buildChecklist() {
    return List.generate(cfg.doNow.length, (i) {
      return CheckboxListTile(
        value: checked[i],
        onChanged: (v) => setState(() => checked[i] = v ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        title: Text(cfg.doNow[i]),
      );
    });
  }

  Widget _avoidList() {
    return Column(
      children: cfg.avoid
          .map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(t)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _copyScript() async {
    await Clipboard.setData(ClipboardData(text: cfg.copyScript));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zkopírováno do schránky')),
    );
  }

  // --- NEW: 158 with "sure" confirm ---

  Future<void> _confirmAndCall158() async {
    final ok = await _confirmCall158();
    if (!mounted) return;
    if (!ok) return;

    final uri = Uri(scheme: 'tel', path: '158');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!mounted) return;

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nepodařilo se spustit telefonní hovor.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Volání se nepodařilo spustit.')),
      );
    }
  }

  Future<bool> _confirmCall158() async {
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Zavolat 158?'),
          content: const Text(
            'Tímto se pokusíte zahájit hovor na tísňovou linku Policie ČR.\n\n'
            'Pokračujte jen pokud je situace vážná / hrozí škoda / jde o trestný čin.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Zrušit'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Ano'),
            ),
          ],
        );
      },
    );

    return res ?? false;
  }

  // --- NEW: leave confirm ---

  Future<bool> _confirmLeave() async {
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
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
        );
      },
    );

    return res ?? false;
  }

  PanicScenarioConfig _configFor(PanicScenarioType type) {
    switch (type) {
      case PanicScenarioType.vishing:
        return const PanicScenarioConfig(
          title: 'Volali mi z banky / policie',
          headline: 'Pravděpodobně vishing – někdo vás tlačí do rychlé akce.',
          doNow: [
            'Okamžitě ukončete hovor.',
            'Nic neinstalujte (AnyDesk/TeamViewer), nic nepotvrzujte.',
            'Zablokujte kartu / internetové bankovnictví v aplikaci banky, pokud můžete.',
            'Zavolejte bance zpět jen přes oficiální číslo (web/app/karta).',
            'Zkontrolujte poslední platby a příjemce, hledejte neznámé transakce.',
            'Změňte hesla (bankovnictví + e-mail), zapněte 2FA.',
          ],
          avoid: [
            'Neposkytujte autorizační kódy ani údaje z karty.',
            'Nevěřte „ověření identity“ přes SMS kód – to je často schválení platby.',
            'Nevolat zpět na číslo z hovoru; používat jen oficiální kontakty.',
          ],
          copyScript:
              'Dobrý den, měl/a jsem podezřelý hovor, kde se volající vydával za banku/policii.\n'
              'Prosím o kontrolu účtu a okamžité zajištění: blokace karty/přístupů, prověření posledních transakcí, '
              'případně zrušení/stopnutí plateb a změnu bezpečnostních nastavení.\n'
              'Čas události: ____  Jméno/číslo volajícího (pokud mám): ____  Co po mně chtěl: ____',
        );

      case PanicScenarioType.smishing:
        return const PanicScenarioConfig(
          title: 'Kliknutí na odkaz',
          headline: 'Smishing/phishing – mohlo dojít ke krádeži přístupů nebo instalaci škodlivého obsahu.',
          doNow: [
            'Okamžitě zavřete stránku a nic dalšího nevyplňujte.',
            'Pokud jste zadal/a přihlašovací údaje: změňte heslo hned teď.',
            'Zkontrolujte e-mail (změny pravidel přeposílání, přihlášení, zařízení).',
            'Zkontrolujte banku: poslední pohyby, limity, příjemce, nastavení notifikací.',
            'Spusťte kontrolu zařízení (antivirus/Play Protect) a odinstalujte podezřelé aplikace.',
            'Uložte důkazy: screenshot SMS/e-mailu, URL, čas.',
          ],
          avoid: [
            'Neklikejte na další odkazy a neodpovídejte na SMS/e-mail.',
            'Nepřihlašujte se přes odkaz – jděte vždy přes oficiální appku/web.',
            'Nesdílejte kódy z SMS a potvrzení v bankovní aplikaci.',
          ],
          copyScript:
              'Dobrý den, klikl/a jsem na podezřelý odkaz a mám obavu z phishingu/smishingu.\n'
              'Prosím o kontrolu bezpečnosti účtu a případné preventivní kroky (blokace, limity, kontrola transakcí).\n'
              'Čas: ____  Odkaz/zdroj: ____  Co jsem udělal/a: ____',
        );

      case PanicScenarioType.highRisk:
        return const PanicScenarioConfig(
          title: 'Kompromitovaná karta',
          headline: 'Vysoké riziko – je potřeba jednat hned, minuty rozhodují.',
          doNow: [
            'Okamžitě zablokujte kartu / platební tokeny v aplikaci banky.',
            'Zavolejte do banky přes oficiální číslo a nahlaste kompromitaci.',
            'Zkontrolujte a zrušte podezřelé transakce / příjemce (pokud to jde).',
            'Změňte hesla (banka + e-mail) a zapněte 2FA všude, kde to jde.',
            'Pokud šlo o autorizační kód: berte to jako schválenou platbu – řešte to hned s bankou.',
            'Sepište časovou osu a uložte důkazy (screenshoty, čísla, URL).',
          ],
          avoid: [
            'Nečekejte „jestli se něco stane“ – jednejte okamžitě.',
            'Neprovádějte další „ověření“ s podvodníkem.',
            'Nedávejte další kódy, fotky dokladů, ani vzdálený přístup.',
          ],
          copyScript:
              'Dobrý den, zadal/a jsem údaje z karty / autorizační kód na podezřelé stránce.\n'
              'Žádám okamžité zajištění účtu: blokace karty/přístupů, prověření a případné stopnutí transakcí.\n'
              'Čas: ____  Co přesně uniklo (karta/kód): ____  Podezřelá transakce: ____',
        );
    }
  }

  final TextEditingController _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }
}
