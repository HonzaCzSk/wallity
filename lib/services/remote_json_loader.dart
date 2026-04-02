import 'dart:convert';
import 'package:flutter/services.dart';

class JsonLoadResult {
  final List<dynamic> data;
  final bool fromRemote;

  const JsonLoadResult({required this.data, required this.fromRemote});
}

Future<JsonLoadResult> loadJsonListWithFallback({
  String? remoteUrl,
  required String assetPath,
  Duration timeout = const Duration(seconds: 4),
}) async {
  // Always use local asset (no remote for PWA CORS safety)
  // Remote fetching disabled

  // 2) Fallback to asset
  final raw = await rootBundle.loadString(assetPath);
  final decoded = jsonDecode(raw);
  if (decoded is List) {
    return JsonLoadResult(data: decoded, fromRemote: false);
  }

  return const JsonLoadResult(data: <dynamic>[], fromRemote: false);
}
