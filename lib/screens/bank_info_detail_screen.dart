import 'package:flutter/material.dart';
import '../models/bank.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BankDetailScreen extends StatelessWidget {
  final Bank bank;

  const BankDetailScreen({super.key, required this.bank});

  Color getRatingColor(String r) {
    switch (r) {
      case "A":
        return Colors.green;
      case "B":
        return Colors.blue;
      case "C":
        return Colors.orange;
      case "D":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(title: Text(bank.name), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: getRatingColor(bank.rating),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Rating: ${bank.rating}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (bank.images.isNotEmpty)
            CarouselSlider(
              items: bank.images.map((img) {
                return Builder(
                  builder: (context) {
                    final mq = MediaQuery.of(context);
                    final int cacheW = (mq.size.width * mq.devicePixelRatio)
                        .toInt();

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            insetPadding: const EdgeInsets.all(8),
                            child: InteractiveViewer(
                              panEnabled: true,
                              clipBehavior: Clip.none,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.asset(
                                  img,
                                  fit: BoxFit.contain,
                                  cacheWidth: cacheW,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Image.asset(
                            img,
                            fit: BoxFit.cover,
                            cacheWidth: cacheW,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.92,
              ),
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
