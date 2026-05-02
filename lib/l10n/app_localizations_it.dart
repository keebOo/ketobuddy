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
  String get tooltipScoreInfo => 'Informazioni sul punteggio';

  @override
  String get tooltipShare => 'Condividi';

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

  @override
  String get onboardingTitle => 'Come viene calcolato il punteggio';

  @override
  String get onboardingLegendTitle => 'Fasce di punteggio';

  @override
  String get onboardingFactorsTitle => 'Cosa conta nel calcolo';

  @override
  String get onboardingFactor1Title => 'Net carbs · 50%';

  @override
  String get onboardingFactor1Body =>
      'Carboidrati totali meno le fibre. Il parametro principale in keto: più sono bassi, meglio è.';

  @override
  String get onboardingFactor2Title => 'Rapporto grassi / proteine · 25%';

  @override
  String get onboardingFactor2Body =>
      'In keto l\'ideale è ricavare più calorie dai grassi che dalle proteine. Un rapporto superiore a 1.5 è ottimale.';

  @override
  String get onboardingFactor3Title => 'Penalità zuccheri · 15%';

  @override
  String get onboardingFactor3Body =>
      'Zuccheri semplici e alcuni dolcificanti come maltitolo e sorbitolo vengono penalizzati e segnalati con un avviso.';

  @override
  String get onboardingExampleTitle => 'Perché le uova prendono 71 e non 100?';

  @override
  String get onboardingExampleBody =>
      'Le uova hanno pochissimi carboidrati — ottimo. Ma contengono più proteine che grassi (circa 13 g vs 10 g per 100 g): il rapporto grassi/proteine è 0.77, sotto la soglia ottimale di 1.5.\n\nIl punteggio non misura solo «ha pochi carbs?» ma quanto un alimento rispecchia i macro keto ideali. Le uova restano eccellenti in keto: il 71 riflette che non sono burro o olio, non che vadano evitate.';

  @override
  String get onboardingNoteTitle => 'Rispetto ad altre app di rating';

  @override
  String get onboardingNoteBody =>
      'Le app tradizionali tendono a penalizzare alimenti ricchi di grassi. KetoBuddy fa l\'opposto: i grassi buoni sono premiati, i carboidrati penalizzati.';

  @override
  String get onboardingClose => 'Capito';
}
