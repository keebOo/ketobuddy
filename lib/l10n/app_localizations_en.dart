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
  String get noInternetConnection =>
      'Looks like you\'re offline. Check your connection and try again.';

  @override
  String get apiTimeout =>
      'Looks like you\'re offline. Check your connection and try again.';

  @override
  String get serverError =>
      'The server hiccuped. Not your fault — give it another go in a sec.';

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
  String get tooltipScoreInfo => 'About the keto score';

  @override
  String get tooltipShare => 'Share';

  @override
  String get scanAgain => 'Scan another product';

  @override
  String get homeSubtitle => 'Keto Barcode Scanner';

  @override
  String get homeScanButton => 'Scan';

  @override
  String get appVersion => 'v0.1';

  @override
  String get homeHistoryButton => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty => 'No recent scans';

  @override
  String get historyEmptySubtitle => 'Scan a product to get started';

  @override
  String get historyToday => 'Today';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String get historyClear => 'Clear history';

  @override
  String get historyClearTitle => 'Clear history';

  @override
  String get historyClearConfirm => 'Delete all recent scans?';

  @override
  String get onboardingTitle => 'How the score is calculated';

  @override
  String get onboardingLegendTitle => 'Score bands';

  @override
  String get onboardingFactorsTitle => 'What counts in the calculation';

  @override
  String get onboardingFactor1Title => 'Net carbs · 50%';

  @override
  String get onboardingFactor1Body =>
      'Total carbohydrates minus fiber. The main keto parameter: the lower, the better.';

  @override
  String get onboardingFactor2Title => 'Fat / protein ratio · 25%';

  @override
  String get onboardingFactor2Body =>
      'In keto, the ideal is to get more calories from fat than protein. A ratio above 1.5 is optimal.';

  @override
  String get onboardingFactor3Title => 'Sugar penalty · 15%';

  @override
  String get onboardingFactor3Body =>
      'Simple sugars and some sweeteners like maltitol and sorbitol are penalized and flagged with a warning.';

  @override
  String get onboardingExampleTitle => 'Why do eggs score 71 and not 100?';

  @override
  String get onboardingExampleBody =>
      'Eggs have very few carbohydrates — great. But they contain more protein than fat (about 13 g vs 10 g per 100 g): the fat/protein ratio is 0.77, below the optimal threshold of 1.5.\n\nThe score doesn\'t just measure «does it have few carbs?» but how well a food reflects ideal keto macros. Eggs remain excellent in keto: the 71 reflects that they\'re not butter or oil, not that they should be avoided.';

  @override
  String get onboardingNoteTitle => 'Compared to other rating apps';

  @override
  String get onboardingNoteBody =>
      'Traditional apps tend to penalize foods rich in fat. KetoBuddy does the opposite: good fats are rewarded, carbohydrates are penalized.';

  @override
  String get onboardingClose => 'Got it';
}
