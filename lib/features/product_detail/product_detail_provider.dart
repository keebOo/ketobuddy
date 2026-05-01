import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/score_config_loader.dart';
import '../../core/models/keto_score.dart';
import '../../core/models/product.dart';
import '../../core/services/scoring_service.dart';

final scoreConfigProvider = FutureProvider<ScoreConfig>((ref) async {
  return ScoreConfigLoader.load();
});

final ketoScoreProvider = FutureProvider.family<KetoScore, Product>((ref, product) async {
  final config = await ref.watch(scoreConfigProvider.future);
  final service = ScoringService(config);
  return service.calculate(product.nutritionData, product.ingredientsTags);
});
