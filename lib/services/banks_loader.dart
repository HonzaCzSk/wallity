import '../config/remote_config.dart';
import 'remote_json_loader.dart';

Future<List<Map<String, dynamic>>> loadBanks() async {
  final result = await loadJsonListWithFallback(
    remoteUrl: RemoteConfig.banksUrl(),
    assetPath: 'assets/data/banks.json',
  );

  return result.data.cast<Map<String, dynamic>>();
}
