import 'remote_json_loader.dart';

Future<List<Map<String, dynamic>>> loadBanks() async {
  final result = await loadJsonListWithFallback(
    assetPath: 'assets/data/banks.json',
  );

  return result.data.cast<Map<String, dynamic>>();
}
