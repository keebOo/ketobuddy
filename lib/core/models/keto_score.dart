import 'package:freezed_annotation/freezed_annotation.dart';

part 'keto_score.freezed.dart';

enum ScoreLabel { excellent, good, fair, bad, noData }

@freezed
class KetoScore with _$KetoScore {
  const factory KetoScore({
    required int score,
    required ScoreLabel label,
    double? netCarbs,
    required bool hasEnoughData,
    required List<String> warnings,
  }) = _KetoScore;

  factory KetoScore.noData() => const KetoScore(
        score: 0,
        label: ScoreLabel.noData,
        netCarbs: null,
        hasEnoughData: false,
        warnings: [],
      );
}
