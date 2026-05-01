# KetoBuddy — Milestone 01: Solo Scan

> Questo file descrive esclusivamente la prima milestone da implementare.
> Leggere prima `01-project-overview.md` per il contesto completo del progetto.

---

## Obiettivo della milestone

Realizzare una app Flutter funzionante che permetta di:
1. Scansionare un codice a barre con la fotocamera
2. Recuperare i dati nutrizionali da Open Food Facts
3. Calcolare e mostrare un punteggio di compatibilità keto (0–100)
4. Visualizzare una scheda prodotto con macro e score

**Nessun account. Nessun salvataggio persistente. Nessun pagamento.**
Solo scan → risultato. Deve funzionare su Android, iOS e Desktop (per sviluppo/test).

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
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.x         # State management
  mobile_scanner: ^5.x           # Barcode scanning (usa ML Kit)
  dio: ^5.x                      # HTTP client per Open Food Facts API
  freezed_annotation: ^2.x       # Modelli immutabili
  json_annotation: ^4.x          # JSON serialization
  hive_flutter: ^1.x             # Storage locale (cache scansioni recenti)
  flutter_localizations:         # i18n predisposto
    sdk: flutter
  intl: ^0.x

dev_dependencies:
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  flutter_test:
    sdk: flutter
  mocktail: ^1.x                 # Mocking per unit test
```

---

## Struttura cartelle da creare

```
lib/
├── core/
│   ├── config/
│   │   └── score_config_loader.dart     # Carica e parsa keto_score_config.json
│   ├── models/
│   │   ├── product.dart                 # Modello prodotto (freezed)
│   │   ├── nutrition_data.dart          # Dati nutrizionali (freezed)
│   │   └── keto_score.dart             # Risultato scoring (freezed)
│   ├── services/
│   │   ├── open_food_facts_service.dart # Chiamate API OFF
│   │   └── scoring_service.dart        # Calcolo punteggio keto
│   └── utils/
│       └── nutrition_helpers.dart       # es. calcolo net carbs
├── features/
│   ├── scan/
│   │   ├── scan_page.dart
│   │   └── scan_provider.dart
│   ├── product_detail/
│   │   ├── product_detail_page.dart
│   │   ├── widgets/
│   │   │   ├── score_gauge_widget.dart  # Cerchio/gauge con punteggio
│   │   │   ├── macro_bar_widget.dart    # Barre macro (carbs/grassi/proteine)
│   │   │   └── score_badge_widget.dart  # Badge colorato Eccellente/Buono/...
│   │   └── product_detail_provider.dart
│   └── settings/                        # Cartella vuota per ora, predisposta
├── l10n/
│   └── app_it.arb                       # Stringhe UI in italiano
└── main.dart

assets/
└── config/
    └── keto_score_config.json           # Algoritmo di scoring
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

## Flusso applicativo Milestone 01

```
[ScanPage]
    │
    │ barcode string
    ▼
[ScanProvider] ──► [OpenFoodFactsService.fetchProduct(barcode)]
    │                    │
    │                    │ risposta JSON OFF
    │                    ▼
    │              [Product + NutritionData]
    │
    │ product
    ▼
[ProductDetailProvider] ──► [ScoringService.calculate(nutrition, config)]
    │                              │
    │                              │ legge keto_score_config.json
    │                              ▼
    │                        [KetoScore]
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

## Checklist Milestone 01 completata quando...

- [x] Scansione barcode funzionante su Android e iOS (e Desktop via input manuale)
- [x] Chiamata API Open Food Facts con gestione errori completa (404, timeout, no-internet, riprova)
- [x] `keto_score_config.json` caricato a runtime, non hardcoded
- [x] Score calcolato correttamente per tutti i casi test
- [x] Scheda prodotto mostra: nome, immagine, score (0-100), label colorata, macro per 100g, net carbs, warning dolcificanti
- [x] Gestione graceful dei dati mancanti (badge "Dati insufficienti")
- [x] Tutte le stringhe UI in file `.arb` — `app_it.arb` e `app_en.arb` completi, nessuna stringa hardcoded nei widget.
- [x] Unit test `ScoringService` tutti verdi (6/6)
- [x] Nessun crash su prodotti con dati parziali
