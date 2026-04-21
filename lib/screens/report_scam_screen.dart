import 'package:flutter/material.dart';
import '../utils/seo.dart';
import '../utils/language.dart';
import '../lang/app_strings.dart';
import '../widgets/panic_shell.dart';

class ReportScamScreen extends StatefulWidget {
  const ReportScamScreen({super.key});
  @override
  State<ReportScamScreen> createState() => _ReportScamScreenState();
}

class _ReportScamScreenState extends State<ReportScamScreen> {
  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Postup při podvodu – Wallity',
      description: 'Jak nahlásit podvod, koho kontaktovat a co si připravit pro banku nebo policii.',
    );
  }

  Future<bool> _confirmLeave(BuildContext context) async {
    final s = S(languageNotifier.value);
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(s.confirmLeaveTitle),
        content: Text(s.confirmLeaveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.stayButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(s.leaveButton),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);

        return PopScope(
          canPop: false,
          // ignore: deprecated_member_use
          onPopInvoked: (didPop) async {
            if (didPop) return;
            final leave = await _confirmLeave(context);
            if (!context.mounted) return;
            if (leave) Navigator.of(context).pop();
          },
          child: PanicShell(
            title: s.reportScamTitle,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.whatToDoNow,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(s.reportStep1),
                  Text(s.reportStep2),
                  Text(s.reportStep3),
                  const SizedBox(height: 16),

                  Text(s.whoToContact,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(s.contactStep1),
                  Text(s.contactStep2),
                  const SizedBox(height: 16),

                  Text(s.whatToPrepare,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(s.prepareStep1),
                  Text(s.prepareStep2),
                  Text(s.prepareStep3),
                  const SizedBox(height: 16),

                  Text(s.watchOut,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(s.watchStep1),
                  Text(s.watchStep2),
                  Text(s.watchStep3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
