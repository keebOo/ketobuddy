# KetoBuddy — Project Overview

> Documento di contesto per agenti AI e sviluppatori. Leggere prima di toccare qualsiasi codice.

---

## Cos'è questo progetto

**KetoBuddy** è un'app mobile (iOS + Android) con versione desktop per sviluppo/testing, che permette di scansionare il codice a barre di prodotti alimentari e ricevere un punteggio di compatibilità con la **dieta chetogenica (keto)**, in sostituzione del punteggio generico di app come Yuka.

L'idea di base: un alimento ricco di grassi e proteine e povero di carboidrati — che Yuka penalizza — deve ottenere un punteggio alto su KetoBuddy. Il punteggio è pensato per chi segue una dieta keto e vuole fare scelte consapevoli al supermercato in pochi secondi.

I dati nutrizionali provengono dall'API pubblica e gratuita di **Open Food Facts** (lookup per barcode, nessuna API key richiesta).

---

## Stato attuale del progetto

- **Milestone 01 in corso** — core app completato, mancano i requisiti store per la pubblicazione.
- Core funzionante: scan → score → scheda prodotto, storico locale (Hive), gestione errori, i18n IT+EN, font DM Sans.
- App icon generata per Android/iOS/macOS. Splash screen, Privacy Policy e screenshot store ancora da fare.
- Testato su Android (Pixel 7). iOS non ancora verificato.
- Vedi `MILESTONE_01.md` checklist per lo stato dettagliato.

---

## Decisioni già prese (non riaprire senza motivo)

| Decisione | Scelta | Motivazione |
|---|---|---|
| Framework | **Flutter** | Unico codebase iOS/Android/Desktop/Web |
| Barcode scanner | **mobile_scanner** | Pacchetto più aggiornato e affidabile |
| Food API | **Open Food Facts REST API** | Gratuita, stabile, 4M+ prodotti, no auth |
| State management | **Riverpod** | Moderno, testabile, scalabile |
| Storage locale | **Hive** o **Drift** | Hive per semplicità MVP, Drift se servono query complesse |
| Pagamenti (futuro) | **RevenueCat** | Astrae billing iOS e Android |
| Backend sync (futuro) | **Supabase** | Open source, PostgreSQL, auth inclusa |
| Lingua UI | **Italiano** (con i18n predisposto) | Target iniziale mercato italiano |
| Font | **DM Sans** (variable font) | Leggibile, moderno, un solo file TTF copre tutti i pesi |

---

## Architettura del punteggio (punto critico del progetto)

Il punteggio keto **non deve essere hardcoded**. Esiste un file di configurazione dedicato (`keto_score_config.json`) che definisce pesi, soglie e regole di calcolo. Questo permette di ritarare l'algoritmo senza modificare il codice.

### Metriche considerate per il punteggio keto

1. **Net carbs** (carboidrati netti = carbs totali - fibre) → peso massimo, è il parametro principale in keto
2. **Rapporto grassi/proteine** → keto richiede grassi alti, proteine moderate (non eccessive)
3. **Presenza di zuccheri** → penalizzazione forte
4. **Tipo di dolcificanti** → alcuni ok (eritritolo, stevia), altri da penalizzare (maltitolo, sorbitolo, sciroppo di glucosio)
5. **Fibre** → premiate perché abbassano i net carbs
6. **Qualità dei grassi** → distinzione tra grassi saturi buoni (olio oliva, cocco, burro) e oli vegetali infiammatori (opzionale, dati spesso mancanti)

### Fasce di punteggio (stessa logica di Yuka)

| Punteggio | Colore | Label |
|---|---|---|
| 75–100 | 🟢 Verde scuro | Eccellente per keto |
| 50–74 | 🟡 Verde chiaro | Buono |
| 25–49 | 🟠 Arancione | Scarso |
| 0–24 | 🔴 Rosso | Da evitare |

---

## Struttura del progetto Flutter (da rispettare)

```
ketobuddy/
├── lib/
│   ├── core/
│   │   ├── config/           # keto_score_config.json loader
│   │   ├── models/           # Product, NutritionData, KetoScore
│   │   ├── services/         # OpenFoodFactsService, ScoringService
│   │   └── utils/
│   ├── features/
│   │   ├── home/             # Schermata iniziale (logo + bottoni scan + storico)
│   │   ├── history/          # Storico scansioni locale (lista + provider)
│   │   ├── scan/             # Barcode scanner UI + logic
│   │   ├── product_detail/   # Scheda prodotto con score
│   │   ├── settings/         # [FUTURO M02] Limiti giornalieri, preferenze (cartella predisposta)
│   │   └── diary/            # [FUTURO M03] Diario alimentare giornaliero (da creare)
│   └── main.dart
├── assets/
│   ├── config/
│   │   └── keto_score_config.json   # ← ALGORITMO QUI, non nel codice
│   └── images/
│       └── appicon.png              # Icona app usata nella home page
├── test/
└── pubspec.yaml
```

---

## Tipografia

Font: **DM Sans** — variable font, un solo file `assets/font/DMSans.ttf`, impostato come `fontFamily` globale nel tema.

| Peso | Flutter | Utilizzo |
|---|---|---|
| Light 300 | `FontWeight.w300` | Testi piccoli, label grigie, versione app |
| Regular 400 | `FontWeight.w400` | Corpo testo, sottotitoli, valori numerici |
| Medium 500 | `FontWeight.w500` | Label, bottoni, titoli secondari |
| SemiBold 600 | `FontWeight.w600` | Titolo app, nome prodotto, punteggio |

Colori testo ricorrenti: `#1A1A1A` (primario), `#6B7C6B` (sottotitoli/accento verde-grigio), `#CCCCCC` (testi disabilitati/versione).

---

## Roadmap ad alto livello

### Milestone 01 — Solo Scan (ATTUALE)
Scansione barcode → scheda prodotto con score keto + storico locale. Nessun account, nessun pagamento. Dettaglio in `MILESTONE_01.md`.

### Milestone 02 — Settings e personalizzazione
- Impostazione limiti giornalieri carboidrati (default: 20g net carbs)
- Scelta tipo keto: Standard / Lazy / Carnivore
- Indicatore visivo progressivo per la soglia giornaliera
- ~~Storico locale scansioni~~ → già implementato in M01

### Milestone 03 — Freemium e Diario
- Integrazione RevenueCat per subscription (es. 2,99€/mese)
- Diario alimentare giornaliero (tier a pagamento)
- Tracking carboidrati cumulativi con barra progressiva
- Export CSV

### Milestone 04 — Cloud Sync (opzionale)
- Autenticazione con Supabase
- Sync del diario multi-device
- Statistiche settimanali/mensili

---

## Regole di sviluppo da rispettare

1. **Nessun magic number nel codice.** Tutte le soglie nutrizionali e i pesi dell'algoritmo di scoring vivono in `keto_score_config.json`.
2. **Feature flags fin dall'inizio.** Le feature future (diary, cloud sync) devono avere un flag in config che le abilita/disabilita, non essere commentate nel codice.
3. **Gestire sempre i dati mancanti.** Open Food Facts può restituire prodotti con dati parziali (es. fibre non indicate). Mostrare "dati insufficienti" è sempre preferibile a uno score calcolato male. Non crashare mai su un campo null.
4. **i18n predisposto.** Usare `flutter_localizations` e `intl` fin dall'inizio, anche se per ora c'è solo l'italiano. Non scrivere mai stringhe UI hardcoded nel codice.
5. **Test sul scoring.** `ScoringService` deve avere unit test con prodotti campione noti, così si verifica subito se una modifica al config rompe il comportamento atteso.
6. **Architettura a strati.** UI non parla mai direttamente all'API. Il flusso è sempre: `UI → Provider (Riverpod) → Service → API/Storage`.
7. **Privacy by design.** Nessun dato nutrizionale/sanitario viene inviato a server di terze parti senza consenso esplicito. Nella Milestone 01 non c'è nessun invio di dati personali.

---

## API Open Food Facts — riferimento rapido

```
GET https://world.openfoodfacts.net/api/v2/product/{barcode}
```

Nessuna autenticazione. Risposta JSON con campo `product` contenente `nutriments`, `ingredients_text`, `product_name`, `image_url`, ecc.

Campi chiave per lo scoring keto:
- `nutriments.carbohydrates_100g`
- `nutriments.fiber_100g`
- `nutriments.sugars_100g`
- `nutriments.fat_100g`
- `nutriments.proteins_100g`
- `ingredients_tags` (per identificare dolcificanti specifici)

---

## Contesto di mercato

- App di riferimento: **Yuka** (80M utenti, punteggio generico, non supporta diete specifiche)
- Target: utenti keto, low-carb, carnivore diet
- Monetizzazione: freemium — scan gratuito, diario a pagamento
- Differenziatore: unico scoring dedicato keto con algoritmo trasparente e configurabile
