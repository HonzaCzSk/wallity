// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/language.dart';
import '../lang/app_strings.dart';
import '../widgets/panic_shell.dart';
import 'emergency_bank_select_screen.dart';
import 'report_scam_screen.dart';

enum PanicScenarioType { vishing, smishing, highRisk }

class PanicScenarioScreen extends StatefulWidget {
  final PanicScenarioType scenario;

  const PanicScenarioScreen({super.key, required this.scenario});

  @override
  State<PanicScenarioScreen> createState() => _PanicScenarioScreenState();
}

class _PanicScenarioScreenState extends State<PanicScenarioScreen> {
  final _noteController = TextEditingController();
  late List<bool> _checks;

  List<String> _steps(S s) {
    switch (widget.scenario) {
      case PanicScenarioType.vishing:
        return s.vishingSteps;
      case PanicScenarioType.smishing:
        return s.smishingSteps;
      case PanicScenarioType.highRisk:
        return s.highRiskSteps;
    }
  }

  @override
  void initState() {
    super.initState();
    final s = S(languageNotifier.value);
    _checks = List<bool>.filled(_steps(s).length, false);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<bool> _confirmLeave() async {
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

  String _scenarioTitle(S s) {
    switch (widget.scenario) {
      case PanicScenarioType.vishing:
        return s.vishingScenarioTitle;
      case PanicScenarioType.smishing:
        return s.smishingScenarioTitle;
      case PanicScenarioType.highRisk:
        return s.highRiskScenarioTitle;
    }
  }

  String _scenarioDesc(S s) {
    switch (widget.scenario) {
      case PanicScenarioType.vishing:
        return s.vishingDesc;
      case PanicScenarioType.smishing:
        return s.smishingDesc;
      case PanicScenarioType.highRisk:
        return s.highRiskDesc;
    }
  }

  void _copyText(S s) {
    final text = s.panicCopyText(_scenarioTitle(s), _noteController.text);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.copiedToClipboard)),
    );
  }

  void _copyIncidentSummary(S s) {
    final steps = _steps(s);
    final doneItems = <String>[];
    for (int i = 0; i < steps.length; i++) {
      if (_checks[i]) doneItems.add('✓ ${steps[i]}');
    }
    final note = _noteController.text.trim();
    final summary = StringBuffer();
    summary.writeln('=== ${_scenarioTitle(s)} ===');
    if (doneItems.isNotEmpty) {
      summary.writeln();
      summary.writeln('${s.whatToDoNowSection}:');
      summary.writeAll(doneItems, '\n');
    }
    if (note.isNotEmpty) {
      summary.writeln();
      summary.writeln('${s.noteHint}: $note');
    }
    Clipboard.setData(ClipboardData(text: summary.toString().trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.copiedToClipboard)),
    );
  }

  Future<void> _callPolice() async {
    final uri = Uri(scheme: 'tel', path: '158');
    await launchUrl(uri);
  }

  static const _panicRed = Color(0xFF7A0C0C);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);
        final steps = _steps(s);

        // Resize _checks if language switch causes step count change (shouldn't, but safe).
        if (_checks.length != steps.length) {
          _checks = List<bool>.filled(steps.length, false);
        }

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            final leave = await _confirmLeave();
            if (!mounted) return;
            // ignore: use_build_context_synchronously
            if (leave) Navigator.of(context).pop();
          },
          child: PanicShell(
            title: _scenarioTitle(s),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Notice card ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _panicRed.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _panicRed.withOpacity(0.22)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(s.panicNoticeText)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Scenario description ───────────────────────────────
                Text(
                  _scenarioDesc(s),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Action buttons ─────────────────────────────────────
                _ActionButton(
                  icon: Icons.phone_in_talk,
                  label: s.selectBankAndAct,
                  filled: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EmergencyBankSelectScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                _ActionButton(
                  icon: Icons.description_outlined,
                  label: s.fraudGuide,
                  filled: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ReportScamScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                _ActionButton(
                  icon: Icons.shield_outlined,
                  label: s.callPolice,
                  filled: false,
                  onTap: _callPolice,
                ),
                const SizedBox(height: 8),

                _ActionButton(
                  icon: Icons.copy_outlined,
                  label: s.copyTextForBank,
                  filled: false,
                  onTap: () => _copyText(s),
                ),
                const SizedBox(height: 12),

                // ── Note field ─────────────────────────────────────────
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: s.noteHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _panicRed.withOpacity(0.35)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _panicRed),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                _ActionButton(
                  icon: Icons.summarize_outlined,
                  label: s.copyIncidentSummary,
                  filled: false,
                  onTap: () => _copyIncidentSummary(s),
                ),
                const SizedBox(height: 20),

                // ── What to do now ─────────────────────────────────────
                Text(
                  s.whatToDoNowSection,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                ...List.generate(steps.length, (i) {
                  return CheckboxListTile(
                    value: _checks[i],
                    onChanged: (v) => setState(() => _checks[i] = v ?? false),
                    title: Text(steps[i]),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: _panicRed,
                    contentPadding: EdgeInsets.zero,
                  );
                }),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  static const _panicRed = Color(0xFF7A0C0C);

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: _panicRed),
        label: Text(label, style: const TextStyle(color: _panicRed)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: _panicRed),
      label: Text(label, style: const TextStyle(color: _panicRed)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: _panicRed.withOpacity(0.5)),
      ),
    );
  }
}
