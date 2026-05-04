import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/nutrition_data.dart';

class OpenFoodFactsException implements Exception {
  final String message;
  final OpenFoodFactsErrorType type;
  const OpenFoodFactsException(this.message, this.type);
}

enum OpenFoodFactsErrorType { notFound, noInternet, timeout, serverError, unknown }

class OpenFoodFactsService {
  final Dio _dio;

  OpenFoodFactsService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://world.openfoodfacts.net/api/v2',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  Future<Product> fetchProduct(String barcode) async {
    try {
      final response = await _dio.get(
        '/product/$barcode',
        queryParameters: {
          'fields':
              'product_name,image_url,brands,nutriments,ingredients_tags',
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 0 || data['product'] == null) {
        throw const OpenFoodFactsException(
            'Prodotto non trovato', OpenFoodFactsErrorType.notFound);
      }

      return _parseProduct(barcode, data['product'] as Map<String, dynamic>);
    } on OpenFoodFactsException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 404) {
        throw const OpenFoodFactsException(
            'Prodotto non trovato', OpenFoodFactsErrorType.notFound);
      }
      if (e.type == DioExceptionType.badResponse &&
          (e.response?.statusCode ?? 0) >= 500) {
        throw const OpenFoodFactsException(
            'Server error', OpenFoodFactsErrorType.serverError);
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const OpenFoodFactsException(
            'Timeout della richiesta', OpenFoodFactsErrorType.timeout);
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const OpenFoodFactsException(
            'Nessuna connessione internet', OpenFoodFactsErrorType.noInternet);
      }
      throw OpenFoodFactsException(
          e.message ?? 'Errore sconosciuto', OpenFoodFactsErrorType.unknown);
    }
  }

  Product _parseProduct(String barcode, Map<String, dynamic> p) {
    final nutriments = p['nutriments'] as Map<String, dynamic>?;

    NutritionData? nutritionData;
    if (nutriments != null) {
      nutritionData = NutritionData(
        carbohydrates100g: _toDouble(nutriments['carbohydrates_100g']),
        fiber100g: _toDouble(nutriments['fiber_100g']),
        sugars100g: _toDouble(nutriments['sugars_100g']),
        fat100g: _toDouble(nutriments['fat_100g']),
        proteins100g: _toDouble(nutriments['proteins_100g']),
        energyKcal100g: _toDouble(nutriments['energy-kcal_100g']),
        salt100g: _toDouble(nutriments['salt_100g']),
      );
    }

    final ingredientsTags = p['ingredients_tags'] != null
        ? List<String>.from(p['ingredients_tags'] as List)
        : null;

    return Product(
      barcode: barcode,
      name: p['product_name'] as String?,
      imageUrl: p['image_url'] as String?,
      brand: p['brands'] as String?,
      nutritionData: nutritionData,
      ingredientsTags: ingredientsTags,
    );
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
