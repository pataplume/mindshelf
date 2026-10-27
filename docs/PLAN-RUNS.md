<!-- Fichier généré par scripts/vues.py à partir de data/. Ne pas éditer à la main. -->

# Plan des runs

- Runs : 22 · tâches : 132
- Durée estimée totale : 31 h 00 · restant : 29 h 50 (hors validation par Tristan)
- Validation estimée : 10 min par variante produite

**Lançables maintenant :** R03

## Décisions ouvertes

| Code | Sujet | Options | Bloque |
|---|---|---|---|
| D01 | Nom de la marque FR | 3 propositions livrées au run R00 | R02, R04, R05, R07, R08, R15, R18 |
| D02 | Boutique Etsy pour le marché FR | 2e boutique (2e frais d'ouverture) / annonces FR dans la boutique MindShelf | R21 |
| D03 | Relecteur.rice métier | Qui, et sous quel délai par produit (bloque la validation des produits à relecture métier, pas les runs) | — |
| D04 | Méthodes des produits à risque FORT écrites par Tristan | Oui (ouvre Etsy pour ces produits) / Non (Whop seul) | R01, R02, R06, R08, R15 |
| D06 | Produits Whop hors plan (Pre-Med pack, Betting, Futures) | Garder tels quels / passer à la charte / retirer | — |
| D07 | Sources des 3 fiches existantes (physique, chimie, dosage) | Fournir les sources ou les PDF actuels | R01 |

## Runs

### R00 — Fondations : charte, chaîne de fabrication, outils

≈ 1 h 10 · statut : Vérifié, en attente de relecture et validation

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 1 | Production | Charte graphique MindShelf | — | — | Charte MindShelf en tokens (data/charte_tokens.csv) + modèle Typst + version N&B + 3 propositions de nom FR | Vérifié, en attente de relecture et validation |
| 2 | Production | Chaîne de fabrication Typst | — | — | Chaîne Typst : build A4, Letter, N&B, tablette depuis une source unique ; fiche test | Vérifié, en attente de relecture et validation |
| 3 | Production | Outils de conditionnement | — | — | Scripts : aperçus PNG, vidéo de feuilletage, export Anki, gabarits d'annonces | Vérifié, en attente de relecture et validation |
| 4 | Vérification | Vérification indépendante | — | — | Contrôle de bout en bout sur la fiche test | Vérifié, en attente de relecture et validation |

### R01 — Fiches EN existantes passées à la charte

≈ 1 h 35 · statut : À faire · dépend de : R00 · décisions requises : D04, D07

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 5 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 6 | Production | Rédaction et mise en page d'un produit | EN02 Physics Formula Sheet (College & Pre-Med) | — | Porter la fiche physique à jour dans la charte, titre élargi College & Pre-Med | À faire |
| 7 | Production | Rédaction et mise en page d'un produit | EN03 Chemistry Formula Sheet (College & Pre-Med) | — | Porter la fiche chimie dans la charte | À faire |
| 8 | Production | Rédaction et mise en page d'un produit | EN01 Dosage Calculation & IV Drip Rates | — | Porter la fiche dosage & IV dans la charte | À faire |
| 9 | Vérification | Vérification indépendante | EN02 Physics Formula Sheet (College & Pre-Med) | — | Vérification indépendante | À faire |
| 10 | Vérification | Vérification indépendante | EN03 Chemistry Formula Sheet (College & Pre-Med) | — | Vérification indépendante | À faire |
| 11 | Vérification | Vérification indépendante | EN01 Dosage Calculation & IV Drip Rates | — | Vérification indépendante | À faire |
| 12 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN02 Physics Formula Sheet (College & Pre-Med) | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 13 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN03 Chemistry Formula Sheet (College & Pre-Med) | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 14 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN01 Dosage Calculation & IV Drip Rates | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R02 — Adaptations FR des fiches existantes

≈ 1 h 35 · statut : À faire · dépend de : R01 · décisions requises : D01, D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 15 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 16 | Production | Rédaction et mise en page d'un produit | FR07 PASS/LAS Physique-Biophysique — fiche formules | — | Adapter EN02 au tronc commun PASS/LAS (physique-biophysique), conventions françaises | À faire |
| 17 | Production | Rédaction et mise en page d'un produit | FR08 PASS/LAS Chimie — fiche formules | — | Adapter EN03 au tronc commun PASS/LAS (chimie) | À faire |
| 18 | Production | Rédaction et mise en page d'un produit | FR01 Calculs de doses et débits — fiche méthode | — | Fiche méthode calculs de doses et débits, variantes 2009 et 2026 | À faire |
| 19 | Vérification | Vérification indépendante | FR07 PASS/LAS Physique-Biophysique — fiche formules | — | Vérification indépendante | À faire |
| 20 | Vérification | Vérification indépendante | FR08 PASS/LAS Chimie — fiche formules | — | Vérification indépendante | À faire |
| 21 | Vérification | Vérification indépendante | FR01 Calculs de doses et débits — fiche méthode | — | Vérification indépendante | À faire |
| 22 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR07 PASS/LAS Physique-Biophysique — fiche formules | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 23 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR08 PASS/LAS Chimie — fiche formules | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 24 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR01 Calculs de doses et débits — fiche méthode | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R03 — Nouvelles fiches EN (SPI, labs, TEAS)

≈ 1 h 35 · statut : À faire · dépend de : R00

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 25 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 26 | Production | Rédaction et mise en page d'un produit | EN04 SPI Ultrasound Physics — Express Review Sheets | — | Fiches express physique de l'échographie (SPI) | À faire |
| 27 | Production | Rédaction et mise en page d'un produit | EN08 Lab Values Cheat Sheet | — | Fiche valeurs de laboratoire (unités US et SI) | À faire |
| 28 | Production | Rédaction et mise en page d'un produit | EN10 TEAS 7 Science Review Sheets | — | Fiches TEAS 7 Science | À faire |
| 132 | Production | Outils de conditionnement | — | — | Corrections reportées de R00 : M2 (style en dur de la vignette), M3/M4 (fiche test : arrondi, référence de la note clinique), 10 mineurs — voir runs/journal/R00-verification.md | À faire |
| 29 | Vérification | Vérification indépendante | EN04 SPI Ultrasound Physics — Express Review Sheets | — | Vérification indépendante | À faire |
| 30 | Vérification | Vérification indépendante | EN08 Lab Values Cheat Sheet | — | Vérification indépendante | À faire |
| 31 | Vérification | Vérification indépendante | EN10 TEAS 7 Science Review Sheets | — | Vérification indépendante | À faire |
| 32 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN04 SPI Ultrasound Physics — Express Review Sheets | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 33 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN08 Lab Values Cheat Sheet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 34 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN10 TEAS 7 Science Review Sheets | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R04 — Anatomie-physiologie EN + biostatistiques PASS

≈ 1 h 35 · statut : À faire · dépend de : R00 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 35 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 36 | Production | Rédaction et mise en page d'un produit | EN06 Anatomy & Physiology — 10 Systems Sheets | A | Systèmes 1 à 5 | À faire |
| 37 | Production | Rédaction et mise en page d'un produit | EN06 Anatomy & Physiology — 10 Systems Sheets | B | Systèmes 6 à 10 | À faire |
| 38 | Production | Rédaction et mise en page d'un produit | FR09 PASS/LAS Biostatistiques — fiche formules | — | Fiche formules biostatistiques PASS/LAS | À faire |
| 39 | Vérification | Vérification indépendante | EN06 Anatomy & Physiology — 10 Systems Sheets | — | Vérification indépendante | À faire |
| 40 | Vérification | Vérification indépendante | FR09 PASS/LAS Biostatistiques — fiche formules | — | Vérification indépendante | À faire |
| 41 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN06 Anatomy & Physiology — 10 Systems Sheets | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 42 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR09 PASS/LAS Biostatistiques — fiche formules | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R05 — Fiches IFSI à faible risque

≈ 1 h 35 · statut : À faire · dépend de : R00 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 43 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 44 | Production | Rédaction et mise en page d'un produit | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | — | Pack stage IFSI, variantes 2009 et 2026 | À faire |
| 45 | Production | Rédaction et mise en page d'un produit | FR03 Bilan biologique — normes françaises | — | Bilan biologique, normes françaises, variantes 2009 et 2026 | À faire |
| 46 | Vérification | Vérification indépendante | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | — | Vérification indépendante | À faire |
| 47 | Vérification | Vérification indépendante | FR03 Bilan biologique — normes françaises | — | Vérification indépendante | À faire |
| 48 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 49 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR03 Bilan biologique — normes françaises | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R06 — Fiches EN à risque fort (EKG, ABG)

≈ 1 h 35 · statut : À faire · dépend de : R00 · décisions requises : D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 50 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 51 | Production | Rédaction et mise en page d'un produit | EN05 EKG Rhythms Cheat Sheet | — | Fiche rythmes ECG (tracés dessinés en code) | À faire |
| 52 | Production | Rédaction et mise en page d'un produit | EN07 ABG Interpretation Cheat Sheet | — | Fiche interprétation des gaz du sang | À faire |
| 53 | Vérification | Vérification indépendante | EN05 EKG Rhythms Cheat Sheet | — | Vérification indépendante | À faire |
| 54 | Vérification | Vérification indépendante | EN07 ABG Interpretation Cheat Sheet | — | Vérification indépendante | À faire |
| 55 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN05 EKG Rhythms Cheat Sheet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 56 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN07 ABG Interpretation Cheat Sheet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R07 — Pharmacologie IFSI

≈ 1 h 35 · statut : À faire · dépend de : R00 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 57 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 58 | Production | Rédaction et mise en page d'un produit | FR04 Pharmacologie IFSI — 10 classes | A | Classes 1 à 5 (DCI et spécialités françaises, surveillance infirmière) | À faire |
| 59 | Production | Rédaction et mise en page d'un produit | FR04 Pharmacologie IFSI — 10 classes | B | Classes 6 à 10 | À faire |
| 60 | Vérification | Vérification indépendante | FR04 Pharmacologie IFSI — 10 classes | — | Vérification indépendante | À faire |
| 61 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR04 Pharmacologie IFSI — 10 classes | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R08 — Kits EN et FR

≈ 1 h 35 · statut : À faire · dépend de : R01, R02, R03, R05, R06, R07 · décisions requises : D01, D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 62 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 63 | Production | Assemblage des kits et des guides | EN09 Nursing Essentials Bundle (Dosage, EKG, ABG, Labs) | — | Assembler EN01, EN05, EN07, EN08 : couverture, sommaire, PDF unique | À faire |
| 64 | Production | Assemblage des kits et des guides | FR05 Kit IFSI (doses, stage, biologie, pharmacologie) | — | Assembler FR01 à FR04, variantes 2009 et 2026 | À faire |
| 65 | Vérification | Vérification indépendante | EN09 Nursing Essentials Bundle (Dosage, EKG, ABG, Labs) | — | Cohérence de l'assemblage avec les composants validés | À faire |
| 66 | Vérification | Vérification indépendante | FR05 Kit IFSI (doses, stage, biologie, pharmacologie) | — | Cohérence de l'assemblage avec les composants validés | À faire |
| 67 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN09 Nursing Essentials Bundle (Dosage, EKG, ABG, Labs) | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 68 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR05 Kit IFSI (doses, stage, biologie, pharmacologie) | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R09 — Guide SPI 1/3

≈ 1 h 15 · statut : À faire · dépend de : R03

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 69 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 70 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | PLAN | Plan détaillé du guide + chapitres 1-2 | À faire |
| 71 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | L1 | chapitres 3-4 | À faire |
| 72 | Production | Banque de questions d'un guide | EN11 SPI Ultrasound Physics — Complete Study Guide | Q1 | Banque de questions, partie 1 | À faire |
| 73 | Vérification | Vérification indépendante | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R10 — Guide SPI 2/3

≈ 1 h 15 · statut : À faire · dépend de : R09

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 74 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 75 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | L2 | chapitres 5-6 | À faire |
| 76 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | L3 | chapitres 7-8 | À faire |
| 77 | Production | Banque de questions d'un guide | EN11 SPI Ultrasound Physics — Complete Study Guide | Q2 | Banque de questions, partie 2 | À faire |
| 78 | Vérification | Vérification indépendante | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R11 — Guide SPI 3/3

≈ 1 h 35 · statut : À faire · dépend de : R10

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 79 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 80 | Production | Assemblage des kits et des guides | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 81 | Production | Banque de questions d'un guide | EN11 SPI Ultrasound Physics — Complete Study Guide | EXAM | Examen blanc et corrigé expliqué | À faire |
| 82 | Vérification | Vérification indépendante | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Vérification complète du guide assemblé | À faire |
| 83 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R12 — Guide TEAS 7 Science 1/3

≈ 1 h 15 · statut : À faire · dépend de : R03, R04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 84 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 85 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | PLAN | Plan détaillé du guide + anatomie-physiologie (1/2) | À faire |
| 86 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | L1 | anatomie-physiologie (2/2) | À faire |
| 87 | Production | Banque de questions d'un guide | EN12 TEAS 7 Science — Complete Study Guide | Q1 | Banque de questions, partie 1 | À faire |
| 88 | Vérification | Vérification indépendante | EN12 TEAS 7 Science — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R13 — Guide TEAS 7 Science 2/3

≈ 1 h 15 · statut : À faire · dépend de : R12

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 89 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 90 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | L2 | biologie et chimie | À faire |
| 91 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | L3 | physique et raisonnement scientifique | À faire |
| 92 | Production | Banque de questions d'un guide | EN12 TEAS 7 Science — Complete Study Guide | Q2 | Banque de questions, partie 2 | À faire |
| 93 | Vérification | Vérification indépendante | EN12 TEAS 7 Science — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R14 — Guide TEAS 7 Science 3/3

≈ 1 h 35 · statut : À faire · dépend de : R13

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 94 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 95 | Production | Assemblage des kits et des guides | EN12 TEAS 7 Science — Complete Study Guide | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 96 | Production | Banque de questions d'un guide | EN12 TEAS 7 Science — Complete Study Guide | EXAM | Examen blanc et corrigé expliqué | À faire |
| 97 | Vérification | Vérification indépendante | EN12 TEAS 7 Science — Complete Study Guide | — | Vérification complète du guide assemblé | À faire |
| 98 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN12 TEAS 7 Science — Complete Study Guide | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R15 — Cahier calculs de doses 1/3

≈ 1 h 15 · statut : À faire · dépend de : R02 · décisions requises : D01, D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 99 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 100 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | PLAN | Plan détaillé du guide + rappels et méthode | À faire |
| 101 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | L1 | exercices 1 à 35 | À faire |
| 102 | Production | Banque de questions d'un guide | FR06 Cahier calculs de doses — 100 exercices corrigés | Q1 | Banque de questions, partie 1 | À faire |
| 103 | Vérification | Vérification indépendante | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Vérification des chapitres et questions du run | À faire |

### R16 — Cahier calculs de doses 2/3

≈ 1 h 15 · statut : À faire · dépend de : R15

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 104 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 105 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | L2 | exercices 36 à 70 | À faire |
| 106 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | L3 | exercices 71 à 100 et situations cliniques | À faire |
| 107 | Production | Banque de questions d'un guide | FR06 Cahier calculs de doses — 100 exercices corrigés | Q2 | Banque de questions, partie 2 | À faire |
| 108 | Vérification | Vérification indépendante | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Vérification des chapitres et questions du run | À faire |

### R17 — Cahier calculs de doses 3/3

≈ 1 h 35 · statut : À faire · dépend de : R16

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 109 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 110 | Production | Assemblage des kits et des guides | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 111 | Production | Banque de questions d'un guide | FR06 Cahier calculs de doses — 100 exercices corrigés | EXAM | Examen blanc et corrigé expliqué | À faire |
| 112 | Vérification | Vérification indépendante | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Vérification complète du guide assemblé | À faire |
| 113 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R18 — Guide Physique-Biophysique PASS 1/3

≈ 1 h 15 · statut : À faire · dépend de : R02 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 114 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 115 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | PLAN | Plan détaillé du guide + états de la matière | À faire |
| 116 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | L1 | rayonnements | À faire |
| 117 | Production | Banque de questions d'un guide | FR10 Physique-Biophysique PASS/LAS — guide complet | Q1 | Banque de questions, partie 1 | À faire |
| 118 | Vérification | Vérification indépendante | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Vérification des chapitres et questions du run | À faire |

### R19 — Guide Physique-Biophysique PASS 2/3

≈ 1 h 15 · statut : À faire · dépend de : R18

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 119 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 120 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | L2 | circulation des fluides | À faire |
| 121 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | L3 | transports membranaires et électrophysiologie | À faire |
| 122 | Production | Banque de questions d'un guide | FR10 Physique-Biophysique PASS/LAS — guide complet | Q2 | Banque de questions, partie 2 | À faire |
| 123 | Vérification | Vérification indépendante | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Vérification des chapitres et questions du run | À faire |

### R20 — Guide Physique-Biophysique PASS 3/3

≈ 1 h 35 · statut : À faire · dépend de : R19

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 124 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 125 | Production | Assemblage des kits et des guides | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 126 | Production | Banque de questions d'un guide | FR10 Physique-Biophysique PASS/LAS — guide complet | EXAM | Examen blanc et corrigé expliqué | À faire |
| 127 | Vérification | Vérification indépendante | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Vérification complète du guide assemblé | À faire |
| 128 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R21 — Mise en vente Etsy et contrôle final

≈ 50 min · statut : À faire · dépend de : R08, R11, R14, R17, R20 · décisions requises : D02

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 129 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 131 | Vérification | Vérification indépendante | — | — | Contrôle de conformité final : mentions IA, marques, aperçus, risque FORT hors Etsy | À faire |
| 130 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | — | — | Paquets Etsy finaux, textes de boutique, calendrier de publication étalé | À faire |

