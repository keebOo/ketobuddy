# KetoBuddy — Milestone 01: Solo Scan

> Questo file descrive esclusivamente la prima milestone da implementare.
> Leggere prima `01-project-overview.md` per il contesto completo del progetto.

---

## Obiettivo della milestone

Realizzare e **pubblicare** la prima versione di produzione dell'app su App Store e Google Play. Il core è la scansione keto, senza account né pagamenti. Prima di pubblicare devono essere soddisfatti tutti i requisiti obbligatori degli store.

Feature core:
1. Home page con logo e bottone di accesso alla scansione
2. Scansione barcode → scheda prodotto con score keto (0–100)
3. Dati nutrizionali da Open Food Facts, gestione errori completa
4. Storico ultime scansioni in memoria locale (no account)

**Nessun account. Nessun pagamento. Nessun backend.**
Deve funzionare su Android, iOS e Desktop (per sviluppo/test).

---

## Cosa NON fare in questa milestone

- ❌ Nessun diario alimentare
- ❌ Nessun sistema di login / account
- ❌ Nessuna integrazione RevenueCat o pagamenti
- ❌ Nessun backend / Supabase
- ❌ Nessuna funzione "aggiungi al diario"
- ❌ Non bloccarsi a perfezionare l'algoritmo di scoring: usare la versione base descritta sotto

Le feature future devono però essere **architetturalmente previste**, non implementate. Struttura le cartelle e i modelli in modo che la Milestone 02+ possa essere aggiunta senza refactoring pesante.

---

## Stack per questa milestone

```yaml
# pubspec.yaml — dipendenze principali
dependencies:
  flutter_riverpod: ^3.3.1       # State management
  mobile_scanner: ^7.2.0         # Barcode scanning (usa ML Kit)
  dio: ^5.8.0                    # HTTP client per Open Food Facts API
  freezed_annotation: ^3.1.0     # Modelli immutabili
  json_annotation: ^4.11.0       # JSON serialization
  hive_flutter: ^1.1.0           # Storage locale (storico + preferenze)
  flutter_localizations: sdk: flutter
  intl: ^0.20.2

dev_dependencies:
  build_runner: ^2.4.14
  freezed: ^3.2.5
  json_serializable: ^6.9.3
  mocktail: ^1.0.4
  flutter_lints: ^5.0.0
  flutter_native_splash: ^2.4.3  # Splash screen nativa (Android + iOS)
  flutter_launcher_icons: ^0.x   # Da aggiungere — generazione icone store da sorgente 1024×1024
  in_app_review: ^2.x            # Da aggiungere — prompt valutazione store
```

---

## Struttura cartelle

```
lib/
├── core/
│   ├── config/
│   │   └── score_config_loader.dart     # Carica e parsa keto_score_config.json (incl. history.max_items)
│   ├── models/
│   │   ├── product.dart                 # Modello prodotto (freezed)
│   │   ├── nutrition_data.dart          # Dati nutrizionali (freezed + json_serializable)
│   │   ├── keto_score.dart              # Risultato scoring (freezed)
│   │   └── scan_record.dart            # Record storico (plain Dart, toJson/fromJson)
│   ├── services/
│   │   ├── open_food_facts_service.dart # Chiamate API OFF
│   │   └── scoring_service.dart        # Calcolo punteggio keto
│   ├── storage/
│   │   ├── history_repository.dart     # Persistenza storico su Hive (Box<String>)
│   │   └── prefs_repository.dart       # Preferenze app su Hive (es. onboarding_seen)
│   └── utils/
│       └── nutrition_helpers.dart      # Calcolo net carbs
├── features/
│   ├── home/
│   │   ├── home_page.dart              # Schermata iniziale (bottoni SCANSIONA + STORICO, trigger onboarding)
│   │   └── widgets/
│   │       └── onboarding_dialog.dart  # Dialog spiegazione score, al primo avvio e via pulsante "i"
│   ├── history/
│   │   ├── history_page.dart           # Lista scansioni raggruppate per data
│   │   └── history_provider.dart       # HistoryNotifier + ScanAndSaveService
│   ├── scan/
│   │   ├── scan_page.dart
│   │   └── scan_provider.dart          # Cerca in cache locale, poi API; salva in storico
│   ├── product_detail/
│   │   ├── product_detail_page.dart    # AppBar con pulsante "i" per onboarding
│   │   ├── widgets/
│   │   │   ├── score_gauge_widget.dart
│   │   │   ├── macro_bar_widget.dart
│   │   │   └── score_badge_widget.dart
│   │   └── product_detail_provider.dart
│   └── settings/                       # Predisposta per Milestone 02
├── l10n/
│   ├── app_it.arb                      # Stringhe IT
│   └── app_en.arb                      # Stringhe EN
└── main.dart

assets/
├── config/
│   └── keto_score_config.json           # Algoritmo di scoring
├── font/
│   └── DMSans.ttf                       # Variable font (tutti i pesi)
└── images/
    └── appicon.png                      # Sorgente icona (768×768)
```

---

## Il file `keto_score_config.json` — struttura

Questo file è il cuore dell'algoritmo. Non modificare i pesi direttamente nel codice Dart.

```json
{
  "version": "1.0.0",
  "description": "Configurazione algoritmo scoring keto - modificare qui i pesi senza toccare il codice",

  "net_carbs": {
    "description": "Net carbs = carbs_totali - fibre. Parametro principale.",
    "weight": 0.50,
    "thresholds_per_100g": {
      "excellent": { "max": 2.0,  "score": 100 },
      "good":      { "max": 5.0,  "score": 75  },
      "fair":      { "max": 10.0, "score": 45  },
      "poor":      { "max": 20.0, "score": 20  },
      "bad":       { "min": 20.0, "score": 0   }
    }
  },

  "fat_protein_ratio": {
    "description": "Keto ideale: 70-75% calorie da grassi, 20-25% da proteine. Ratio grassi/proteine > 1.5 è ottimale.",
    "weight": 0.25,
    "thresholds": {
      "excellent": { "min_ratio": 2.0,  "score": 100 },
      "good":      { "min_ratio": 1.5,  "score": 80  },
      "fair":      { "min_ratio": 1.0,  "score": 50  },
      "poor":      { "min_ratio": 0.5,  "score": 25  },
      "bad":       { "max_ratio": 0.5,  "score": 0   }
    }
  },

  "sugar_penalty": {
    "description": "Penalizzazione per zuccheri semplici presenti (per 100g).",
    "weight": 0.15,
    "thresholds_per_100g": {
      "none":   { "max": 0.5, "penalty": 0   },
      "low":    { "max": 2.0, "penalty": 10  },
      "medium": { "max": 5.0, "penalty": 25  },
      "high":   { "min": 5.0, "penalty": 50  }
    }
  },

  "sweetener_rules": {
    "description": "Alcuni dolcificanti alzano la glicemia e vanno penalizzati anche in keto.",
    "ok": ["erythritol", "stevia", "monk-fruit", "xylitol", "allulose"],
    "penalize": ["maltitol", "sorbitol", "sucralose", "aspartame", "glucose-syrup", "maltodextrin"],
    "penalty_if_bad_sweetener": 20
  },

  "fiber_bonus": {
    "description": "Le fibre abbassano i net carbs e sono premiate.",
    "bonus_per_gram_per_100g": 0.5,
    "max_bonus": 10
  },

  "missing_data_policy": {
    "description": "Cosa fare quando mancano dati critici.",
    "if_carbs_missing": "show_no_score",
    "if_fiber_missing": "assume_zero",
    "if_fat_missing": "skip_ratio_component",
    "if_protein_missing": "skip_ratio_component"
  },

  "history": {
    "description": "Configurazione storico scansioni locale.",
    "max_items": 25
  }
}
```

---

## Modelli dati principali

### `NutritionData`
```dart
// Tutti i campi sono nullable: Open Food Facts può non averli
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
}
```

### `KetoScore`
```dart
@freezed
class KetoScore with _$KetoScore {
  const factory KetoScore({
    required int score,           // 0–100
    required ScoreLabel label,    // excellent / good / fair / bad
    required double? netCarbs,    // calcolati, utili per display
    required bool hasEnoughData,  // false = dati insufficienti
    required List<String> warnings, // es. "contiene maltitolo"
  }) = _KetoScore;
}

enum ScoreLabel { excellent, good, fair, bad, noData }
```

---

## Flusso applicativo

```
[HomePage]
    │ tap "SCANSIONA"
    ▼
[ScanPage]
    │ barcode rilevato → camera stop
    ▼
[ScanProvider] ──► [OpenFoodFactsService.fetchProduct(barcode)]
    │                    │
    │                    ▼
    │              [Product + NutritionData]
    │                    │
    │                    └──► salva in storico locale (Hive, max configurabile)
    │
    ▼
[ProductDetailProvider] ──► [ScoringService.calculate(nutrition, config)]
    │                              │
    │                              └──► legge keto_score_config.json
    │
    ▼
[ProductDetailPage]
    ├── ScoreBadgeWidget     (colore + label)
    ├── ScoreGaugeWidget     (numero 0-100 con arco colorato)
    ├── MacroBarWidget       (barre carbs/grassi/proteine/net carbs)
    └── IngredientWarnings   (dolcificanti problematici evidenziati)
```

---

## Gestione errori da implementare

| Caso | Comportamento atteso |
|---|---|
| Prodotto non trovato nel DB OFF | Messaggio "Prodotto non trovato. Puoi aggiungerlo su openfoodfacts.org" |
| Dati nutrizionali mancanti (carbs null) | Score non mostrato, badge grigio "Dati insufficienti" |
| Nessuna connessione internet | Messaggio di errore con pulsante "Riprova" |
| Barcode non leggibile | La UI di `mobile_scanner` gestisce già il feedback visivo |
| Timeout API (>10 secondi) | Errore con messaggio e pulsante "Riprova" |

---

## UI — indicazioni di design

- **Scheda prodotto**: ispirarsi visivamente a Yuka (immagine prodotto in alto, score in evidenza, macro sotto)
- **Colori score**: usare i colori definiti in `01-project-overview.md` (verde scuro / verde chiaro / arancione / rosso)
- **Net carbs in evidenza**: mostrare sempre prominentemente i grammi di net carbs per 100g — è la metrica principale per un utente keto
- **Warning dolcificanti**: se il prodotto contiene dolcificanti da penalizzare, mostrarli esplicitamente con un'icona ⚠️
- **Desktop layout**: su schermi larghi, affiancare scanner (o input manuale barcode) e scheda prodotto

---

## Requisiti per la pubblicazione store

### 🔴 Obbligatori (bloccanti per la review)

| Item | Note |
|---|---|
| **Privacy Policy** | Pagina web pubblica (anche GitHub Pages). Deve dichiarare che l'app non raccoglie dati personali. Senza questa Apple e Google bloccano la review. |
| **Icone store complete** | Usare `flutter_launcher_icons` con sorgente 1024×1024. Genera automaticamente tutti i formati richiesti da iOS e Android. |
| **Splash screen** | Usare `flutter_native_splash`. Sfondo bianco con icona centrata, coerente con la home. |
| **Testo store** | Titolo, sottotitolo, descrizione breve e lunga in italiano e inglese. Le keyword nel titolo/sottotitolo impattano la discoverability. |
| **Screenshot store** | Apple: min 3, richiesti per iPhone 6.7" e iPad. Google: min 2. Girarli su simulatore Flutter. |

### 🟡 Importanti (non bloccanti, ma consigliati prima del lancio)

| Item | Note |
|---|---|
| **Onboarding al primo avvio** | Una schermata che spiega in 3 righe cos'è lo score keto e come interpretarlo. Necessaria per utenti non keto. Si mostra solo al primo lancio, poi non più. |
| **Feedback visivo durante scan** | Loading indicator visibile mentre l'API risponde. Già presente (`CircularProgressIndicator`) ma da verificare che sia ben visibile su tutti i device. |
| **Storico ultime scansioni** | Ultimi 10 prodotti scansionati in memoria locale (Hive, già dipendenza). Nessun account. Reset all'upgrade o su richiesta utente. |
| **Prompt valutazione app** | Dopo la 3ª scansione riuscita, mostrare il prompt nativo di review (`in_app_review`). Le prime recensioni sono fondamentali per la visibilità store. |

---

## Test da scrivere (obbligatori per questa milestone)

### Unit test — `ScoringService`

Testare almeno questi casi con prodotti campione reali:

| Prodotto | Atteso |
|---|---|
| Olio extravergine d'oliva (0g carbs) | Score > 90, label: excellent |
| Petto di pollo (0g carbs, alto protein) | Score buono ma non eccellente (ratio fat/prot basso) |
| Pane bianco (~50g carbs) | Score < 15, label: bad |
| Nutella (~57g carbs, zuccheri alti) | Score < 10, label: bad |
| Prodotto senza dati carbs | `hasEnoughData: false` |
| Prodotto con maltitolo | Warning presente in `KetoScore.warnings` |

---

## Comandi utili durante lo sviluppo

```bash
# Creazione progetto (già eseguito, org usata: com.ketobuddy)
flutter create ketobuddy --org com.ketobuddy --platforms ios,android,macos,windows,linux

# Generazione codice freezed/json
dart run build_runner build --delete-conflicting-outputs

# Run su desktop per sviluppo rapido
flutter run -d macos
flutter run -d linux
flutter run -d windows

# Test
flutter test
flutter test --coverage
```

---

## Checklist Milestone 01 — pronta per pubblicazione quando...

### Core app
- [x] Home page con logo, titolo, sottotitolo e bottone "SCANSIONA"
- [x] Font DM Sans applicato globalmente (variable font, tutti i pesi)
- [x] Scansione barcode funzionante su Android e iOS (e Desktop via input manuale)
- [x] Chiamata API Open Food Facts con gestione errori completa (404, timeout, no-internet, riprova)
- [x] `keto_score_config.json` caricato a runtime, non hardcoded
- [x] Score calcolato correttamente per tutti i casi test
- [x] Scheda prodotto: nome, immagine, score (0-100), label colorata, macro per 100g, net carbs, warning dolcificanti
- [x] Gestione graceful dei dati mancanti (badge "Dati insufficienti")
- [x] Tutte le stringhe UI in `app_it.arb` e `app_en.arb`, nessuna stringa hardcoded
- [x] Unit test `ScoringService` tutti verdi (6/6)
- [x] Nessun crash su prodotti con dati parziali

### Requisiti store obbligatori
- [x] App icon generata per Android/iOS/macOS (sorgente 768×768 via `sips`)
- [ ] App icon via `flutter_launcher_icons` da sorgente 1024×1024 (sostituisce generazione manuale)
- [x] Splash screen nativa con `flutter_native_splash` (sfondo bianco, icona centrata; nessuna SplashPage Flutter)
- [ ] Privacy Policy pubblicata su URL pubblico
- [ ] Testo store scritto: titolo, sottotitolo, descrizione breve e lunga (IT + EN)
- [ ] Screenshot store pronti: iPhone 6.7", iPad (min 3 per Apple, min 2 per Google)

### Nice-to-have prima del lancio
- [x] Onboarding al primo avvio (dialog scrollabile che spiega lo score keto; si mostra solo una volta, poi accessibile via pulsante "i" su home e scheda prodotto)
- [x] Storico scansioni in locale (Hive, max configurabile via `history.max_items` in config, default 25)
- [ ] Prompt valutazione app dopo la 3ª scansione riuscita (`in_app_review`, da aggiungere a pubspec)
