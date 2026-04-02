import 'package:flutter/material.dart';

class BankLogo extends StatelessWidget {
  final String? assetPath;
  final String name;
  final double size;
  final String? websiteUrl;

  const BankLogo({
    super.key,
    required this.name,
    this.assetPath,
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

  // Network fetching removed for PWA CORS compatibility; use only local assetPath.

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

    return fallback;
  }
}

