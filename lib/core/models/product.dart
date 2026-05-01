import 'package:freezed_annotation/freezed_annotation.dart';
import 'nutrition_data.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String barcode,
    String? name,
    String? imageUrl,
    String? brand,
    NutritionData? nutritionData,
    List<String>? ingredientsTags,
  }) = _Product;
}
