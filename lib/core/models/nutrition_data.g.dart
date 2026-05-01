// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionDataImpl _$$NutritionDataImplFromJson(Map<String, dynamic> json) =>
    _$NutritionDataImpl(
      carbohydrates100g: (json['carbohydrates100g'] as num?)?.toDouble(),
      fiber100g: (json['fiber100g'] as num?)?.toDouble(),
      sugars100g: (json['sugars100g'] as num?)?.toDouble(),
      fat100g: (json['fat100g'] as num?)?.toDouble(),
      proteins100g: (json['proteins100g'] as num?)?.toDouble(),
      energyKcal100g: (json['energyKcal100g'] as num?)?.toDouble(),
      salt100g: (json['salt100g'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$NutritionDataImplToJson(_$NutritionDataImpl instance) =>
    <String, dynamic>{
      'carbohydrates100g': instance.carbohydrates100g,
      'fiber100g': instance.fiber100g,
      'sugars100g': instance.sugars100g,
      'fat100g': instance.fat100g,
      'proteins100g': instance.proteins100g,
      'energyKcal100g': instance.energyKcal100g,
      'salt100g': instance.salt100g,
    };
