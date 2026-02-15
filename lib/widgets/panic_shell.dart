import 'package:flutter/material.dart';

class PanicShell extends StatelessWidget {
  final String title;
  final Widget child;

  const PanicShell({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);

    final panicTheme = base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF7A0C0C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF7A0C0C),
      ),
    );

    return Theme(
      data: panicTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('⚠️  '),
              Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        body: SafeArea(child: child),
      ),
    );
  }
}
