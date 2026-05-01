# KetoBuddy — Business Logic

> Questo documento descrive le regole di business dell'applicazione: modello freemium, flussi utente, cosa è gratuito e cosa è a pagamento. Non descrive l'algoritmo di scoring (vedi `assets/config/keto_score_config.json`) né le specifiche tecniche (vedi `01-project-overview.md`).

---

## Proposta di valore

KetoBuddy offre un punteggio di compatibilità keto per qualsiasi prodotto alimentare scansionato, sostituendo il punteggio generico di app come Yuka con uno specifico per chi segue una dieta chetogenica. Il valore principale è la velocità: scan → risultato in pochi secondi, senza account.

---

## Modello freemium

### Tier gratuito (sempre disponibile)
- Scansione barcode illimitata
- Visualizzazione scheda prodotto con score keto (0–100)
- Macronutrienti per 100g (carbs, net carbs, grassi, proteine, fibre)
- Warning dolcificanti problematici
- Nessun account richiesto

### Tier a pagamento (Milestone 03+)
- Diario alimentare giornaliero
- Tracking carboidrati cumulativi con barra progressiva
- Export CSV del diario
- Prezzo indicativo: 2,99€/mese o 19,99€/anno
- Piattaforma: RevenueCat (astrae billing iOS e Android)

### Regola chiave
> La scansione e il punteggio sono e rimangono gratuiti. Il paywall riguarda esclusivamente le funzionalità di tracking nel tempo. Non introdurre mai limiti di scan nel tier free.

---

## Flussi utente principali

### Flusso base (Milestone 01)
```
Apri app → schermata scan
  → inquadra barcode
  → [loading] chiamata Open Food Facts
  → scheda prodotto: score, macro, warning
  → torna indietro → pronto per nuova scan
```

### Flusso errore
```
Scan → prodotto non trovato → messaggio + link openfoodfacts.org → torna a scan
Scan → nessuna rete → messaggio → riprova o annulla
```

### Flusso futuro con diario (Milestone 03)
```
Scheda prodotto → "Aggiungi al diario"
  → utente free: paywall RevenueCat
  → utente paid: aggiunto, aggiorna contatore giornaliero
```

---

## Feature flags

Le feature future devono essere gestite tramite flag di configurazione, non codice commentato. Il flag permette di abilitare/disabilitare funzionalità senza toccare la logica.

> **Stato attuale (M01):** i flag non sono ancora implementati nel codice. Vanno introdotti in Milestone 02 quando si inizia a costruire le prime feature condizionali.

| Feature | Flag previsto | Da implementare in |
|---|---|---|
| Diario alimentare | `diary_enabled` | Milestone 03 |
| Cloud sync | `cloud_sync_enabled` | Milestone 04 |
| Paywall | `paywall_enabled` | Milestone 03 |

Quando implementati, i flag vivranno in un file di configurazione app (non in `keto_score_config.json` che riguarda solo lo scoring).

---

## Privacy

- Nessun dato sanitario o nutrizionale viene inviato a server propri
- Nella Milestone 01 non esiste alcun invio di dati personali
- I dati nutrizionali transitano solo verso Open Food Facts (API pubblica, richiesta in lettura)
- Quando verrà introdotto l'account (Milestone 04), sarà richiesto consenso esplicito prima di qualsiasi sync

---

## Target utenti

- Primario: utenti italiani che seguono dieta keto standard o lazy keto
- Secondario: utenti low-carb, carnivore diet
- Contesto d'uso: supermercato, lettura etichette rapida
- Riferimento competitivo: Yuka (80M utenti, punteggio generico non adatto a keto)
