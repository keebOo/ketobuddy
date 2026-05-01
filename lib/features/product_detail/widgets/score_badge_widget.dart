import 'package:flutter/material.dart';
import '../../../core/models/keto_score.dart';
import '../../../l10n/app_localizations.dart';

class ScoreBadgeWidget extends StatelessWidget {
  final KetoScore score;

  const ScoreBadgeWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorForLabel(score.label),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _labelText(score.label, l),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  static Color colorForLabel(ScoreLabel label) {
    switch (label) {
      case ScoreLabel.excellent:
        return const Color(0xFF2E7D32);
      case ScoreLabel.good:
        return const Color(0xFF7CB342);
      case ScoreLabel.fair:
        return const Color(0xFFEF6C00);
      case ScoreLabel.bad:
        return const Color(0xFFC62828);
      case ScoreLabel.noData:
        return const Color(0xFF757575);
    }
  }

  String _labelText(ScoreLabel label, AppLocalizations l) {
    switch (label) {
      case ScoreLabel.excellent:
        return l.scoreExcellent;
      case ScoreLabel.good:
        return l.scoreGood;
      case ScoreLabel.fair:
        return l.scoreFair;
      case ScoreLabel.bad:
        return l.scoreBad;
      case ScoreLabel.noData:
        return l.scoreNoData;
    }
  }
}
