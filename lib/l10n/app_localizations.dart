import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'KetoBuddy'**
  String get appTitle;

  /// No description provided for @error.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In it, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento...'**
  String get loading;

  /// No description provided for @scanPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Scansiona'**
  String get scanPageTitle;

  /// No description provided for @scanInstructions.
  ///
  /// In it, this message translates to:
  /// **'Punta la fotocamera sul codice a barre'**
  String get scanInstructions;

  /// No description provided for @manualBarcodeHint.
  ///
  /// In it, this message translates to:
  /// **'Inserisci barcode manualmente'**
  String get manualBarcodeHint;

  /// No description provided for @searchButton.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get searchButton;

  /// No description provided for @productNotFound.
  ///
  /// In it, this message translates to:
  /// **'Prodotto non trovato.\nPuoi aggiungerlo su openfoodfacts.org'**
  String get productNotFound;

  /// No description provided for @noInternetConnection.
  ///
  /// In it, this message translates to:
  /// **'Nessuna connessione internet'**
  String get noInternetConnection;

  /// No description provided for @apiTimeout.
  ///
  /// In it, this message translates to:
  /// **'Timeout della richiesta'**
  String get apiTimeout;

  /// No description provided for @product.
  ///
  /// In it, this message translates to:
  /// **'Prodotto'**
  String get product;

  /// No description provided for @scoreExcellent.
  ///
  /// In it, this message translates to:
  /// **'Eccellente per keto'**
  String get scoreExcellent;

  /// No description provided for @scoreGood.
  ///
  /// In it, this message translates to:
  /// **'Buono'**
  String get scoreGood;

  /// No description provided for @scoreFair.
  ///
  /// In it, this message translates to:
  /// **'Scarso'**
  String get scoreFair;

  /// No description provided for @scoreBad.
  ///
  /// In it, this message translates to:
  /// **'Da evitare'**
  String get scoreBad;

  /// No description provided for @scoreNoData.
  ///
  /// In it, this message translates to:
  /// **'Dati insufficienti'**
  String get scoreNoData;

  /// No description provided for @insufficientDataDescription.
  ///
  /// In it, this message translates to:
  /// **'Dati nutrizionali non disponibili'**
  String get insufficientDataDescription;

  /// No description provided for @netCarbs.
  ///
  /// In it, this message translates to:
  /// **'Net Carbs'**
  String get netCarbs;

  /// No description provided for @netCarbsPer100g.
  ///
  /// In it, this message translates to:
  /// **'Net Carbs / 100g'**
  String get netCarbsPer100g;

  /// No description provided for @carbohydrates.
  ///
  /// In it, this message translates to:
  /// **'Carboidrati'**
  String get carbohydrates;

  /// No description provided for @fat.
  ///
  /// In it, this message translates to:
  /// **'Grassi'**
  String get fat;

  /// No description provided for @proteins.
  ///
  /// In it, this message translates to:
  /// **'Proteine'**
  String get proteins;

  /// No description provided for @fiber.
  ///
  /// In it, this message translates to:
  /// **'Fibre'**
  String get fiber;

  /// No description provided for @sugars.
  ///
  /// In it, this message translates to:
  /// **'Zuccheri'**
  String get sugars;

  /// No description provided for @energyKcal.
  ///
  /// In it, this message translates to:
  /// **'Energia'**
  String get energyKcal;

  /// No description provided for @energyValue.
  ///
  /// In it, this message translates to:
  /// **'Energia: {value} kcal / 100g'**
  String energyValue(String value);

  /// No description provided for @salt.
  ///
  /// In it, this message translates to:
  /// **'Sale'**
  String get salt;

  /// No description provided for @per100g.
  ///
  /// In it, this message translates to:
  /// **'per 100g'**
  String get per100g;

  /// No description provided for @macrosPer100g.
  ///
  /// In it, this message translates to:
  /// **'Macronutrienti per 100g'**
  String get macrosPer100g;

  /// No description provided for @warningsTitle.
  ///
  /// In it, this message translates to:
  /// **'Avvertenze'**
  String get warningsTitle;

  /// No description provided for @warningBadSweetener.
  ///
  /// In it, this message translates to:
  /// **'Contiene: {sweetener}'**
  String warningBadSweetener(String sweetener);

  /// No description provided for @errorGeneric.
  ///
  /// In it, this message translates to:
  /// **'Errore: {message}'**
  String errorGeneric(String message);

  /// No description provided for @scanAgain.
  ///
  /// In it, this message translates to:
  /// **'Scansiona altro prodotto'**
  String get scanAgain;

  /// No description provided for @homeSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Keto Barcode Scanner'**
  String get homeSubtitle;

  /// No description provided for @homeScanButton.
  ///
  /// In it, this message translates to:
  /// **'Scansiona'**
  String get homeScanButton;

  /// No description provided for @appVersion.
  ///
  /// In it, this message translates to:
  /// **'v0.1'**
  String get appVersion;

  /// No description provided for @homeHistoryButton.
  ///
  /// In it, this message translates to:
  /// **'Storico'**
  String get homeHistoryButton;

  /// No description provided for @historyTitle.
  ///
  /// In it, this message translates to:
  /// **'Storico'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scansione recente'**
  String get historyEmpty;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In it, this message translates to:
  /// **'Scansiona un prodotto per iniziare'**
  String get historyEmptySubtitle;

  /// No description provided for @historyToday.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get historyToday;

  /// No description provided for @historyYesterday.
  ///
  /// In it, this message translates to:
  /// **'Ieri'**
  String get historyYesterday;

  /// No description provided for @historyClear.
  ///
  /// In it, this message translates to:
  /// **'Cancella storico'**
  String get historyClear;

  /// No description provided for @historyClearTitle.
  ///
  /// In it, this message translates to:
  /// **'Cancella storico'**
  String get historyClearTitle;

  /// No description provided for @historyClearConfirm.
  ///
  /// In it, this message translates to:
  /// **'Vuoi eliminare tutte le scansioni recenti?'**
  String get historyClearConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
