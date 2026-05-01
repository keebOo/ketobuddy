import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

void showOnboardingDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) => const _OnboardingDialog(),
  );
}

class _OnboardingDialog extends StatelessWidget {
  const _OnboardingDialog();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                l.onboardingTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(l.onboardingLegendTitle),
                    const SizedBox(height: 8),
                    _legendRow(const Color(0xFF2E7D32), l.scoreExcellent),
                    _legendRow(Colors.lightGreen.shade600, l.scoreGood),
                    _legendRow(Colors.orange, l.scoreFair),
                    _legendRow(Colors.red.shade700, l.scoreBad),
                    _legendRow(Colors.grey, l.scoreNoData),
                    const SizedBox(height: 20),
                    _SectionTitle(l.onboardingFactorsTitle),
                    const SizedBox(height: 8),
                    _FactorCard(
                        title: l.onboardingFactor1Title,
                        body: l.onboardingFactor1Body),
                    const SizedBox(height: 8),
                    _FactorCard(
                        title: l.onboardingFactor2Title,
                        body: l.onboardingFactor2Body),
                    const SizedBox(height: 8),
                    _FactorCard(
                        title: l.onboardingFactor3Title,
                        body: l.onboardingFactor3Body),
                    const SizedBox(height: 20),
                    _SectionTitle(l.onboardingExampleTitle),
                    const SizedBox(height: 8),
                    Text(
                      l.onboardingExampleBody,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(l.onboardingNoteTitle),
                    const SizedBox(height: 8),
                    Text(
                      l.onboardingNoteBody,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  l.onboardingClose,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32)),
    );
  }
}

class _FactorCard extends StatelessWidget {
  final String title;
  final String body;
  const _FactorCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(body,
              style: const TextStyle(fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
