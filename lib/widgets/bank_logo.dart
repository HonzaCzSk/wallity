import 'package:flutter/material.dart';

class BankLogo extends StatelessWidget {
  final String? assetPath;
  final String? imageUrl;
  final String name;
  final double size;
  final String? websiteUrl;

  const BankLogo({
    super.key,
    required this.name,
    this.assetPath,
    this.imageUrl,
    this.websiteUrl,
    this.size = 44,
  });

  String _initials() {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final second = parts.length >= 2 ? parts[1].characters.first : '';
    return (first + second).toUpperCase();
  }

  String? _deriveHighResFaviconUrl() {
    if (websiteUrl == null || websiteUrl!.trim().isEmpty) return null;
    try {
      final uri = Uri.parse(websiteUrl!.trim());
      var host = uri.host;
      if (host.isEmpty) return null;
      if (host.startsWith('www.')) host = host.substring(4);
      // Use a stable, direct high-res favicon endpoint (avoids redirects from /s2/favicons).
      return 'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://$host&size=128';
    } catch (_) {
      return null;
    }
  }

  String? _bestNetworkUrl() {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) return _deriveHighResFaviconUrl();

    // If a bank points at a low-res favicon.ico, prefer a higher-res variant.
    if (url.toLowerCase().endsWith('/favicon.ico')) {
      final derived = _deriveHighResFaviconUrl();
      if (derived != null) return derived;
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    Widget fallback = CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.white,
      child: Text(
        _initials(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: size * 0.32,
          color: Colors.black87,
        ),
      ),
    );

    Widget wrap(Widget child) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: Colors.black12),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (assetPath != null && assetPath!.isNotEmpty) {
      return wrap(
        Image.asset(
          assetPath!,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    final bestUrl = _bestNetworkUrl();
    if (bestUrl != null && bestUrl.isNotEmpty) {
      final dpr = MediaQuery.of(context).devicePixelRatio;
      final cacheW = (size * dpr).round();
      return wrap(
        Image.network(
          bestUrl,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          cacheWidth: cacheW,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    return fallback;
  }
}

