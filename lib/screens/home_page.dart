import 'package:flutter/material.dart';

import 'emergency_screen.dart';
import '../utils/seo.dart';
import '../utils/language.dart';
import '../lang/app_strings.dart';
import 'home_screen.dart';
import 'about_page.dart';
import 'kids_training_screen.dart';
import 'security_training_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Wallity – Ochrana před finančními podvody',
      description: 'Rozpoznej podvod, zablokuj kartu a jednej správně. Offline aplikace s kontakty bank.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F9FF),
          appBar: AppBar(
            title: Text(
              s.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              // ── Tlačítko přepínání jazyka ──────────────────────────
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: () => languageNotifier.value = !languageNotifier.value,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.20),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isEn ? '🇨🇿 CZ' : '🇬🇧 EN',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  s.welcomeTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  s.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Nouzový režim
                Center(
                  child: SizedBox(
                    width: 280,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmergencyScreen(),
                          ),
                        );
                      },
                      child: Text(
                        s.emergencyMode,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Vyhledat banku
                Center(
                  child: SizedBox(
                    width: 280,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF2196F3),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(focusSearch: true, initialTab: 0),
                          ),
                        );
                      },
                      child: Text(
                        s.searchBank,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Procházet banky
                Center(
                  child: SizedBox(
                    width: 280,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF2196F3)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(initialTab: 1),
                          ),
                        );
                      },
                      child: Text(s.browseBanks),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Trénink
                Center(
                  child: SizedBox(
                    width: 280,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SecurityTrainingScreen(),
                          ),
                        );
                      },
                      child: Text(s.training),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Dětský trénink
                Center(
                  child: SizedBox(
                    width: 280,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF7C4DFF)),
                        backgroundColor: const Color(0x117C4DFF),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KidsTrainingScreen(),
                          ),
                        );
                      },
                      child: Text(s.kidsTraining),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // O aplikaci
                Center(
                  child: SizedBox(
                    width: 280,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutPage()),
                        );
                      },
                      child: Text(s.about),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  s.copyright,
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
