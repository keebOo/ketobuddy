import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_data.freezed.dart';
part 'nutrition_data.g.dart';

@freezed
class NutritionData with _$NutritionData {
  const factory NutritionData({
    double? carbohydrates100g,
    double? fiber100g,
    double? sugars100g,
    double? fat100g,
    double? proteins100g,
    double? energyKcal100g,
    double? salt100g,
  }) = _NutritionData;

  factory NutritionData.fromJson(Map<String, dynamic> json) =>
      _$NutritionDataFromJson(json);
}
