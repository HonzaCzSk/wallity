import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class JsonLoadResult {
  final List<dynamic> data;
  final bool fromRemote;

  const JsonLoadResult({required this.data, required this.fromRemote});
}

Future<JsonLoadResult> loadJsonListWithFallback({
  required String remoteUrl,
  required String assetPath,
  Duration timeout = const Duration(seconds: 4),
}) async {
  // 1) Try remote
  try {
    final res = await http.get(Uri.parse(remoteUrl)).timeout(timeout);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        return JsonLoadResult(data: decoded, fromRemote: true);
      }
    }
  } catch (_) {
    // ignore -> fallback
  }

  // 2) Fallback to asset
  final raw = await rootBundle.loadString(assetPath);
  final decoded = jsonDecode(raw);
  if (decoded is List) {
    return JsonLoadResult(data: decoded, fromRemote: false);
  }

  return const JsonLoadResult(data: <dynamic>[], fromRemote: false);
}
