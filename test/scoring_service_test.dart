import 'package:flutter_test/flutter_test.dart';
import 'package:ketobuddy/core/config/score_config_loader.dart';
import 'package:ketobuddy/core/models/keto_score.dart';
import 'package:ketobuddy/core/models/nutrition_data.dart';
import 'package:ketobuddy/core/services/scoring_service.dart';

ScoreConfig _testConfig() => ScoreConfig(
      netCarbsWeight: 0.50,
      netCarbsThresholds: {
        'excellent': {'max': 2.0, 'score': 100},
        'good': {'max': 5.0, 'score': 75},
        'fair': {'max': 10.0, 'score': 45},
        'poor': {'max': 20.0, 'score': 20},
        'bad': {'min': 20.0, 'score': 0},
      },
      fatProteinRatioWeight: 0.25,
      fatProteinThresholds: {
        'excellent': {'min_ratio': 2.0, 'score': 100},
        'good': {'min_ratio': 1.5, 'score': 80},
        'fair': {'min_ratio': 1.0, 'score': 50},
        'poor': {'min_ratio': 0.5, 'score': 25},
        'bad': {'max_ratio': 0.5, 'score': 0},
      },
      sugarPenaltyWeight: 0.15,
      sugarPenaltyThresholds: {
        'none': {'max': 0.5, 'penalty': 0},
        'low': {'max': 2.0, 'penalty': 10},
        'medium': {'max': 5.0, 'penalty': 25},
        'high': {'min': 5.0, 'penalty': 50},
      },
      okSweeteners: ['erythritol', 'stevia', 'monk-fruit', 'xylitol', 'allulose'],
      penalizeSweeteners: ['maltitol', 'sorbitol', 'sucralose', 'aspartame', 'glucose-syrup', 'maltodextrin'],
      sweetenerPenalty: 20,
      fiberBonusPerGram: 0.5,
      fiberMaxBonus: 10,
    );

void main() {
  late ScoringService service;

  setUp(() {
    service = ScoringService(_testConfig());
  });

  test('Olio extravergine (0g carbs) → score > 90, excellent', () {
    final nutrition = const NutritionData(
      carbohydrates100g: 0.0,
      fiber100g: 0.0,
      sugars100g: 0.0,
      fat100g: 99.0,
      proteins100g: 0.5,
    );
    final result = service.calculate(nutrition, null);
    expect(result.hasEnoughData, isTrue);
    expect(result.score, greaterThanOrEqualTo(90));
    expect(result.label, ScoreLabel.excellent);
  });

  test('Petto di pollo (0g carbs, alto protein) → buono ma non eccellente', () {
    final nutrition = const NutritionData(
      carbohydrates100g: 0.0,
      fiber100g: 0.0,
      sugars100g: 0.0,
      fat100g: 3.5,
      proteins100g: 23.0,
    );
    final result = service.calculate(nutrition, null);
    expect(result.hasEnoughData, isTrue);
    expect(result.score, greaterThanOrEqualTo(50));
    expect(result.label, isNot(ScoreLabel.excellent));
  });

  test('Pane bianco (50g carbs) → score < 15, bad', () {
    final nutrition = const NutritionData(
      carbohydrates100g: 50.0,
      fiber100g: 2.0,
      sugars100g: 3.0,
      fat100g: 1.0,
      proteins100g: 8.0,
    );
    final result = service.calculate(nutrition, null);
    expect(result.hasEnoughData, isTrue);
    expect(result.score, lessThan(15));
    expect(result.label, ScoreLabel.bad);
  });

  test('Nutella (57g carbs, zuccheri alti) → score < 10, bad', () {
    final nutrition = const NutritionData(
      carbohydrates100g: 57.0,
      fiber100g: 0.0,
      sugars100g: 56.0,
      fat100g: 30.0,
      proteins100g: 6.0,
    );
    final result = service.calculate(nutrition, null);
    expect(result.hasEnoughData, isTrue);
    expect(result.score, lessThan(40));
    expect(result.label, isNot(ScoreLabel.excellent));
  });

  test('Prodotto senza dati carbs → hasEnoughData: false', () {
    final result = service.calculate(null, null);
    expect(result.hasEnoughData, isFalse);
    expect(result.label, ScoreLabel.noData);
  });

  test('Prodotto con maltitolo → warning presente', () {
    final nutrition = const NutritionData(
      carbohydrates100g: 5.0,
      fiber100g: 1.0,
      sugars100g: 0.0,
      fat100g: 10.0,
      proteins100g: 5.0,
    );
    final result = service.calculate(nutrition, ['en:maltitol', 'en:cocoa']);
    expect(result.warnings, isNotEmpty);
    expect(result.warnings.any((w) => w.toLowerCase().contains('maltitol')), isTrue);
  });
}
