// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'KetoBuddy';

  @override
  String get error => 'Errore';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get retry => 'Riprova';

  @override
  String get loading => 'Caricamento...';

  @override
  String get scanPageTitle => 'Scansiona';

  @override
  String get scanInstructions => 'Punta la fotocamera sul codice a barre';

  @override
  String get manualBarcodeHint => 'Inserisci barcode manualmente';

  @override
  String get searchButton => 'Cerca';

  @override
  String get productNotFound =>
      'Prodotto non trovato.\nPuoi aggiungerlo su openfoodfacts.org';

  @override
  String get noInternetConnection => 'Nessuna connessione internet';

  @override
  String get apiTimeout => 'Timeout della richiesta';

  @override
  String get product => 'Prodotto';

  @override
  String get scoreExcellent => 'Eccellente per keto';

  @override
  String get scoreGood => 'Buono';

  @override
  String get scoreFair => 'Scarso';

  @override
  String get scoreBad => 'Da evitare';

  @override
  String get scoreNoData => 'Dati insufficienti';

  @override
  String get insufficientDataDescription => 'Dati nutrizionali non disponibili';

  @override
  String get netCarbs => 'Net Carbs';

  @override
  String get netCarbsPer100g => 'Net Carbs / 100g';

  @override
  String get carbohydrates => 'Carboidrati';

  @override
  String get fat => 'Grassi';

  @override
  String get proteins => 'Proteine';

  @override
  String get fiber => 'Fibre';

  @override
  String get sugars => 'Zuccheri';

  @override
  String get energyKcal => 'Energia';

  @override
  String energyValue(String value) {
    return 'Energia: $value kcal / 100g';
  }

  @override
  String get salt => 'Sale';

  @override
  String get per100g => 'per 100g';

  @override
  String get macrosPer100g => 'Macronutrienti per 100g';

  @override
  String get warningsTitle => 'Avvertenze';

  @override
  String warningBadSweetener(String sweetener) {
    return 'Contiene: $sweetener';
  }

  @override
  String errorGeneric(String message) {
    return 'Errore: $message';
  }

  @override
  String get scanAgain => 'Scansiona altro prodotto';

  @override
  String get homeSubtitle => 'Keto Barcode Scanner';

  @override
  String get homeScanButton => 'Scansiona';

  @override
  String get appVersion => 'v0.1';

  @override
  String get homeHistoryButton => 'Storico';

  @override
  String get historyTitle => 'Storico';

  @override
  String get historyEmpty => 'Nessuna scansione recente';

  @override
  String get historyEmptySubtitle => 'Scansiona un prodotto per iniziare';

  @override
  String get historyToday => 'Oggi';

  @override
  String get historyYesterday => 'Ieri';

  @override
  String get historyClear => 'Cancella storico';

  @override
  String get historyClearTitle => 'Cancella storico';

  @override
  String get historyClearConfirm =>
      'Vuoi eliminare tutte le scansioni recenti?';
}
