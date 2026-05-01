import 'dart:convert';
import 'keto_score.dart';
import 'nutrition_data.dart';
import 'product.dart';

class ScanRecord {
  final String barcode;
  final String? productName;
  final String? brand;
  final String? imageUrl;
  final int score;
  final ScoreLabel scoreLabel;
  final DateTime scannedAt;
  final NutritionData? nutritionData;
  final List<String>? ingredientsTags;

  const ScanRecord({
    required this.barcode,
    this.productName,
    this.brand,
    this.imageUrl,
    required this.score,
    required this.scoreLabel,
    required this.scannedAt,
    this.nutritionData,
    this.ingredientsTags,
  });

  factory ScanRecord.fromProductAndScore(Product product, KetoScore ketoScore) {
    return ScanRecord(
      barcode: product.barcode,
      productName: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      score: ketoScore.score,
      scoreLabel: ketoScore.label,
      scannedAt: DateTime.now(),
      nutritionData: product.nutritionData,
      ingredientsTags: product.ingredientsTags,
    );
  }

  Product toProduct() => Product(
        barcode: barcode,
        name: productName,
        brand: brand,
        imageUrl: imageUrl,
        nutritionData: nutritionData,
        ingredientsTags: ingredientsTags,
      );

  String toJson() => jsonEncode(_toMap());

  factory ScanRecord.fromJson(String source) =>
      ScanRecord._fromMap(Map<String, dynamic>.from(jsonDecode(source) as Map));

  Map<String, dynamic> _toMap() => {
        'barcode': barcode,
        'productName': productName,
        'brand': brand,
        'imageUrl': imageUrl,
        'score': score,
        'scoreLabel': scoreLabel.name,
        'scannedAt': scannedAt.toIso8601String(),
        'nutritionData': nutritionData?.toJson(),
        'ingredientsTags': ingredientsTags,
      };

  factory ScanRecord._fromMap(Map<String, dynamic> map) {
    return ScanRecord(
      barcode: map['barcode'] as String,
      productName: map['productName'] as String?,
      brand: map['brand'] as String?,
      imageUrl: map['imageUrl'] as String?,
      score: map['score'] as int,
      scoreLabel: ScoreLabel.values.firstWhere(
        (e) => e.name == map['scoreLabel'],
        orElse: () => ScoreLabel.noData,
      ),
      scannedAt: DateTime.parse(map['scannedAt'] as String),
      nutritionData: map['nutritionData'] != null
          ? NutritionData.fromJson(
              Map<String, dynamic>.from(map['nutritionData'] as Map),
            )
          : null,
      ingredientsTags: (map['ingredientsTags'] as List?)?.cast<String>(),
    );
  }
}
