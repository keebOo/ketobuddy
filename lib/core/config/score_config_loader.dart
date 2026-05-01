import 'dart:convert';
import 'package:flutter/services.dart';

class ScoreConfig {
  final double netCarbsWeight;
  final Map<String, dynamic> netCarbsThresholds;
  final double fatProteinRatioWeight;
  final Map<String, dynamic> fatProteinThresholds;
  final double sugarPenaltyWeight;
  final Map<String, dynamic> sugarPenaltyThresholds;
  final List<String> okSweeteners;
  final List<String> penalizeSweeteners;
  final int sweetenerPenalty;
  final double fiberBonusPerGram;
  final double fiberMaxBonus;
  final int historyMaxItems;

  const ScoreConfig({
    required this.netCarbsWeight,
    required this.netCarbsThresholds,
    required this.fatProteinRatioWeight,
    required this.fatProteinThresholds,
    required this.sugarPenaltyWeight,
    required this.sugarPenaltyThresholds,
    required this.okSweeteners,
    required this.penalizeSweeteners,
    required this.sweetenerPenalty,
    required this.fiberBonusPerGram,
    required this.fiberMaxBonus,
    required this.historyMaxItems,
  });

  factory ScoreConfig.fromJson(Map<String, dynamic> json) {
    return ScoreConfig(
      netCarbsWeight: (json['net_carbs']['weight'] as num).toDouble(),
      netCarbsThresholds: json['net_carbs']['thresholds_per_100g'] as Map<String, dynamic>,
      fatProteinRatioWeight: (json['fat_protein_ratio']['weight'] as num).toDouble(),
      fatProteinThresholds: json['fat_protein_ratio']['thresholds'] as Map<String, dynamic>,
      sugarPenaltyWeight: (json['sugar_penalty']['weight'] as num).toDouble(),
      sugarPenaltyThresholds: json['sugar_penalty']['thresholds_per_100g'] as Map<String, dynamic>,
      okSweeteners: List<String>.from(json['sweetener_rules']['ok'] as List),
      penalizeSweeteners: List<String>.from(json['sweetener_rules']['penalize'] as List),
      sweetenerPenalty: (json['sweetener_rules']['penalty_if_bad_sweetener'] as num).toInt(),
      fiberBonusPerGram: (json['fiber_bonus']['bonus_per_gram_per_100g'] as num).toDouble(),
      fiberMaxBonus: (json['fiber_bonus']['max_bonus'] as num).toDouble(),
      historyMaxItems: (json['history']['max_items'] as num).toInt(),
    );
  }
}

class ScoreConfigLoader {
  static ScoreConfig? _cached;

  static Future<ScoreConfig> load() async {
    if (_cached != null) return _cached!;
    final raw = await rootBundle.loadString('assets/config/keto_score_config.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cached = ScoreConfig.fromJson(json);
    return _cached!;
  }
}
