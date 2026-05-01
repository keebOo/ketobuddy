import '../config/score_config_loader.dart';
import '../models/keto_score.dart';
import '../models/nutrition_data.dart';
import '../utils/nutrition_helpers.dart';

class ScoringService {
  final ScoreConfig config;

  const ScoringService(this.config);

  KetoScore calculate(NutritionData? nutrition, List<String>? ingredientsTags) {
    if (nutrition == null || nutrition.carbohydrates100g == null) {
      return KetoScore.noData();
    }

    final warnings = <String>[];

    // Net carbs score
    final netCarbs = calculateNetCarbs(
        nutrition.carbohydrates100g, nutrition.fiber100g);
    final netCarbsScore = _scoreNetCarbs(netCarbs!);

    // Fat/protein ratio score
    double? ratioScore;
    if (nutrition.fat100g != null && nutrition.proteins100g != null) {
      final ratio = nutrition.proteins100g! > 0
          ? nutrition.fat100g! / nutrition.proteins100g!
          : (nutrition.fat100g! > 0 ? 999.0 : 0.0);
      ratioScore = _scoreFatProteinRatio(ratio).toDouble();
    }

    // Sugar penalty
    final sugarPenalty = _scoreSugarPenalty(nutrition.sugars100g ?? 0.0);

    // Fiber bonus
    final fiberBonus = _fiberBonus(nutrition.fiber100g ?? 0.0);

    // Sweetener check
    int sweetenerPenalty = 0;
    if (ingredientsTags != null) {
      for (final tag in ingredientsTags) {
        final normalized = tag.replaceAll('en:', '').toLowerCase();
        for (final bad in config.penalizeSweeteners) {
          if (normalized.contains(bad.toLowerCase())) {
            sweetenerPenalty = config.sweetenerPenalty;
            warnings.add(bad);
            break;
          }
        }
      }
    }

    // Weighted score
    double weighted = netCarbsScore * config.netCarbsWeight;
    if (ratioScore != null) {
      weighted += ratioScore * config.fatProteinRatioWeight;
    } else {
      // redistribute weight to net carbs when ratio not available
      weighted += netCarbsScore * config.fatProteinRatioWeight;
    }

    // Sugar: invert penalty (score = 100 - penalty)
    final sugarScore = (100.0 - sugarPenalty).clamp(0.0, 100.0);
    weighted += sugarScore * config.sugarPenaltyWeight;

    // Add fiber bonus and subtract sweetener penalty
    weighted = (weighted + fiberBonus - sweetenerPenalty).clamp(0.0, 100.0);

    final finalScore = weighted.round().clamp(0, 100);
    final label = _scoreLabel(finalScore);

    return KetoScore(
      score: finalScore,
      label: label,
      netCarbs: netCarbs,
      hasEnoughData: true,
      warnings: warnings,
    );
  }

  double _scoreNetCarbs(double netCarbs) {
    final t = config.netCarbsThresholds;
    if (netCarbs <= (t['excellent']['max'] as num).toDouble()) return 100.0;
    if (netCarbs <= (t['good']['max'] as num).toDouble()) return 75.0;
    if (netCarbs <= (t['fair']['max'] as num).toDouble()) return 45.0;
    if (netCarbs <= (t['poor']['max'] as num).toDouble()) return 20.0;
    return 0.0;
  }

  double _scoreFatProteinRatio(double ratio) {
    final t = config.fatProteinThresholds;
    if (ratio >= (t['excellent']['min_ratio'] as num).toDouble()) return 100.0;
    if (ratio >= (t['good']['min_ratio'] as num).toDouble()) return 80.0;
    if (ratio >= (t['fair']['min_ratio'] as num).toDouble()) return 50.0;
    if (ratio >= (t['poor']['min_ratio'] as num).toDouble()) return 25.0;
    return 0.0;
  }

  double _scoreSugarPenalty(double sugars) {
    final t = config.sugarPenaltyThresholds;
    if (sugars <= (t['none']['max'] as num).toDouble()) return 0.0;
    if (sugars <= (t['low']['max'] as num).toDouble()) return 10.0;
    if (sugars <= (t['medium']['max'] as num).toDouble()) return 25.0;
    return 50.0;
  }

  double _fiberBonus(double fiber) {
    final bonus = fiber * config.fiberBonusPerGram;
    return bonus.clamp(0.0, config.fiberMaxBonus);
  }

  ScoreLabel _scoreLabel(int score) {
    if (score >= 75) return ScoreLabel.excellent;
    if (score >= 50) return ScoreLabel.good;
    if (score >= 25) return ScoreLabel.fair;
    return ScoreLabel.bad;
  }
}
