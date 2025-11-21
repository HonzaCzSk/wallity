import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/bank.dart';

class BlockCardScreen extends StatefulWidget {
  const BlockCardScreen({super.key});

  @override
  State<BlockCardScreen> createState() => _BlockCardScreenState();
}

class _BlockCardScreenState extends State<BlockCardScreen> {
  List<Bank> banks = [];
  final Map<int, String> _customPhones = {};

  @override
  void initState() {
    super.initState();
    _loadBanks();
    _loadSavedPhones();
  }

  Future<void> _loadBanks() async {
    final raw = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/banks.json');
    final data = jsonDecode(raw) as List<dynamic>;
    setState(() {
      banks = data.map((e) => Bank.fromJson(e)).toList();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Zkopírováno do schránky')));
  }

  Future<void> _promptAddPhone(Bank bank) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Přidat telefon pro ${bank.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Zadejte telefonní číslo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zrušit'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Uložit'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _customPhones[bank.id] = result.trim();
      });
      await _savePhones();
      _copyToClipboard(result.trim());
    }
  }

  Future<void> _loadSavedPhones() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('customPhones');
    if (raw == null) return;
    try {
      final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _customPhones.clear();
        data.forEach((k, v) {
          final id = int.tryParse(k);
          if (id != null && v is String) _customPhones[id] = v;
        });
      });
    } catch (_) {
      // ignore malformed prefs
    }
  }

  Future<void> _savePhones() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> data = {};
    _customPhones.forEach((k, v) => data[k.toString()] = v);
    await prefs.setString('customPhones', jsonEncode(data));
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Nelze zahájit hovor.')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Chyba při volání.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const sampleScript =
        'Dobrý den, potřebuji okamžitě zablokovat svou platební kartu. '
        'Číslo karty nechci sdělovat v textu; prosím přepněte mě na blokaci karty a potvrďte identifikaci.';

    return Scaffold(
      appBar: AppBar(title: const Text('Zablokovat kartu'), centerTitle: true),
      backgroundColor: const Color(0xFFF5F9FF),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Okamžité kroky',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1) Pokud jste online obětí podvodu: zastavte další akce a odpojte zařízení od internetu.',
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Offline kroky: Pokud máte podezření nebo ztratíte kartu, použijte oficiální kanály banky (telefon na zadní straně karty nebo na výpisu, oficiální web). '
                    'V případě, že nemáte přístup k telefonu, navštivte nejbližší pobočku s občanským průkazem.',
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '2) Zavolejte bance a nechte kartu okamžitě zablokovat.',
                  ),
                  const Text(
                    '3) Zkontrolujte poslední transakce a nahlaste neoprávněné platby.',
                  ),
                  const Text(
                    '4) Změňte přístupové údaje k internetovému bankovnictví.',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _copyToClipboard(sampleScript),
                          child: const Text('Kopírovat vzor'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _copyToClipboard(
                            'Chci zablokovat kartu - ztráta/krádež.',
                          ),
                          child: const Text('Kopírovat krátkou zprávu'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kontakty bank (rychlé)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Stiskněte tlačítko u své banky pro zkopírování názvu nebo vzorové zprávy. '
                    'Poté zavolejte číslo z oficiálních stránek banky.',
                  ),
                  const SizedBox(height: 12),
                  if (banks.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    ...banks.map((b) {
                      final phone = _customPhones[b.id];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(b.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rating: ${b.rating}'),
                            if (phone != null) Text('Tel: $phone'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Kopírovat název banky',
                              icon: const Icon(Icons.copy),
                              onPressed: () => _copyToClipboard(b.name),
                            ),
                            IconButton(
                              tooltip: 'Kopírovat zprávu',
                              icon: const Icon(Icons.message),
                              onPressed: () => _copyToClipboard(
                                'Prosím zablokujte moji kartu u banky ${b.name} — ztráta/krádež.',
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (phone != null) ...[
                              IconButton(
                                tooltip: 'Zavolat',
                                icon: const Icon(Icons.phone),
                                onPressed: () => _callPhone(phone),
                              ),
                              IconButton(
                                tooltip: 'Kopírovat telefon',
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyToClipboard(phone),
                              ),
                            ] else
                              IconButton(
                                tooltip: 'Přidat telefon',
                                icon: const Icon(Icons.phone_android),
                                onPressed: () => _promptAddPhone(b),
                              ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Co očekávat při hovoru',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Banka vás vyzve k identifikaci. Připravte doklad totožnosti a údaje účtu.',
                  ),
                  Text(
                    '- Banka okamžitě zablokuje kartu a nabídne další kroky (nová karta, reklamace transakcí).',
                  ),
                  Text(
                    '- Pokud došlo k finanční ztrátě, požádejte o instrukce k nahlášení reklamace.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              'Bezpečnostní doporučení',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Nikdy neodesílejte celé číslo karty na neznámé kontakty.',
          ),
          const Text(
            '- Nepovolujte vzdálený přístup k vašemu zařízení třetím stranám.',
          ),
          const Text('- Změňte hesla a aktivujte 2FA tam, kde je to možné.'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
