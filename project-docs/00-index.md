# KetoBuddy — Indice documenti

Leggi questo file per orientarti. Ogni documento ha uno scopo preciso: non duplicano informazioni.

---

## Documenti di progetto

| File | Contenuto |
|---|---|
| `01-project-overview.md` | Cos'è l'app, stack tecnico, architettura, decisioni già prese, regole di sviluppo |
| `02-business-logic.md` | Modello freemium, flussi utente, cosa è free/paid, regole di monetizzazione |
| `MILESTONE_01.md` | Specifiche implementative della milestone corrente (Scan, Storico, Onboarding) |

## Documento esterno rilevante

| File | Contenuto |
|---|---|
| `assets/config/keto_score_config.json` | Algoritmo di scoring keto: pesi, soglie, regole dolcificanti. Leggere se si lavora su scoring o si vuole capire come viene calcolato il punteggio. |

---

## Ordine di lettura consigliato

1. `01-project-overview.md` — contesto generale, sempre
2. `02-business-logic.md` — se la task riguarda flussi utente, feature flags, monetizzazione
3. `MILESTONE_01.md` — se si sta lavorando sulla milestone corrente
4. `assets/config/keto_score_config.json` — solo se la task riguarda lo scoring
