import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All banks contain required security fields', () async {
    final raw = await rootBundle.loadString('assets/data/banks.json');
    final decoded = jsonDecode(raw) as List<dynamic>;

    expect(decoded.isNotEmpty, true);

    for (final bank in decoded) {
      final map = bank as Map<String, dynamic>;

      expect(map.containsKey('websiteUrl'), true,
          reason: '${map['name']} missing websiteUrl');

      expect(map.containsKey('cardBlockPhone'), true,
          reason: '${map['name']} missing cardBlockPhone');

      final website = (map['websiteUrl'] ?? '').toString();
      final phone = (map['cardBlockPhone'] ?? '').toString();

      expect(website.isNotEmpty, true,
          reason: '${map['name']} websiteUrl is empty');

      expect(phone.isNotEmpty, true,
          reason: '${map['name']} cardBlockPhone is empty');

      expect(website.startsWith('https://'), true,
          reason: '${map['name']} websiteUrl must start with https://');

      expect(phone.startsWith('+'), true,
          reason: '${map['name']} cardBlockPhone must start with +');
    }
  });
}
