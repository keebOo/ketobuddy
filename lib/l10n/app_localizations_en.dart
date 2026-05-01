// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KetoBuddy';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get scanPageTitle => 'Scan';

  @override
  String get scanInstructions => 'Point the camera at the barcode';

  @override
  String get manualBarcodeHint => 'Enter barcode manually';

  @override
  String get searchButton => 'Search';

  @override
  String get productNotFound =>
      'Product not found.\nYou can add it at openfoodfacts.org';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get apiTimeout => 'Request timed out';

  @override
  String get product => 'Product';

  @override
  String get scoreExcellent => 'Excellent for keto';

  @override
  String get scoreGood => 'Good';

  @override
  String get scoreFair => 'Poor';

  @override
  String get scoreBad => 'Avoid';

  @override
  String get scoreNoData => 'Insufficient data';

  @override
  String get insufficientDataDescription => 'Nutritional data not available';

  @override
  String get netCarbs => 'Net Carbs';

  @override
  String get netCarbsPer100g => 'Net Carbs / 100g';

  @override
  String get carbohydrates => 'Carbohydrates';

  @override
  String get fat => 'Fat';

  @override
  String get proteins => 'Proteins';

  @override
  String get fiber => 'Fiber';

  @override
  String get sugars => 'Sugars';

  @override
  String get energyKcal => 'Energy';

  @override
  String energyValue(String value) {
    return 'Energy: $value kcal / 100g';
  }

  @override
  String get salt => 'Salt';

  @override
  String get per100g => 'per 100g';

  @override
  String get macrosPer100g => 'Macronutrients per 100g';

  @override
  String get warningsTitle => 'Warnings';

  @override
  String warningBadSweetener(String sweetener) {
    return 'Contains: $sweetener';
  }

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get scanAgain => 'Scan another product';

  @override
  String get homeSubtitle => 'Keto Barcode Scanner';

  @override
  String get homeScanButton => 'Scan';

  @override
  String get appVersion => 'v0.1';
}
