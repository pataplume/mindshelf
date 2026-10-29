<!-- Fichier généré par scripts/vues.py à partir de data/. Ne pas éditer à la main. -->

# Plan des runs

- Runs : 22 · tâches : 168
- Durée estimée totale : 21 h 50 · restant : 15 h 35 (hors validation par Tristan)
- Validation estimée : 10 min par variante produite

**Lançables maintenant :** R06, R07, R09, R12, R15, R18

## En attente de Tristan

| # | Type | Produit | Détail | Depuis |
|---|---|---|---|---|
| 1 | Valider une fiche (ou demander des corrections) | EN04 | Fiche SPI : valider en connaissant la réserve (18 lignes de references.csv sans source lue, valeurs standard ; voir produits/EN04/verif/rapport-v2.md) | 2026-10-29 |
| 2 | Valider une fiche (ou demander des corrections) | EN10 | Fiche TEAS 7 Science | 2026-10-29 |
| 3 | Valider une fiche (ou demander des corrections) | FR08 | Fiche chimie PASS/LAS (VSEPR et RMN gardées : D09) | 2026-10-29 |
| 4 | Déposer des fichiers sur Whop (l'envoi est bloqué depuis la session) | EN02 | Kit EN02-whop.zip : fichiers dans l'app Files « Physics Formula Sheet (PDF) », galerie ; puis dire « déposé » | 2026-10-29 |
| 5 | Déposer des fichiers sur Whop (l'envoi est bloqué depuis la session) | EN03 | Kit EN03-whop.zip (version du 29.10 10:26) : app Files « Chemistry Cheat Sheet (PDF) », partagée avec le Pre-Med & Nursing Pack ; galerie ; puis dire « déposé » | 2026-10-29 |
| 6 | Déposer des fichiers sur Whop (l'envoi est bloqué depuis la session) | FR07 | Kit FR07-whop.zip (version du 29.10 vers 11:20, après la correction FX11 graisse → foie) : ajouter une app Files au produit masqué prod_bVA9Q6H0Vxc3h, galerie ; puis dire « déposé » | 2026-10-29 |
| 7 | Faire relire une fiche par la personne du domaine | EN01 | PDF EN01-STD-a4 + section « Ce que la relecture doit confirmer » de produits/EN01/donnees/statut-methode.md | 2026-10-29 |
| 8 | Faire relire une fiche par la personne du domaine | FR01 | PDF FR01-2026-a4 + section « Ce que la relecture doit confirmer » de produits/FR01/donnees/statut-methode.md | 2026-10-29 |
| 9 | Faire relire une fiche par la personne du domaine | EN08 | PDF EN08-STD-a4 + produits/EN08/donnees/statut-methode.md (dont la question ABIM ou intervalles enseignés en soins infirmiers) | 2026-10-29 |
| 10 | Vérifier une information hors de la session | — | Nom Clairance : domaine .fr, compte Instagram, base des marques INPI | 2026-10-28 |
| 11 | Tourner une vidéo iPhone | — | Vidéos iPhone des fiches validées (video/script-iphone.md de chaque produit) | 2026-10-29 |
| 12 | Publier une annonce Etsy à la main | — | Annonces Etsy des fiches validées (annonce/etsy/annonce.md), rythme maximal dans parametres.csv (etsy_publications_par_semaine_max) | 2026-10-29 |
| 13 | Fournir une source non consultable depuis la session | EN04 | Facultatif : photos des pages de Kremkau (atténuation, intensités, champ proche, Bernoulli, 20 kHz) pour lever les réserves de sourçage | 2026-10-29 |
| 14 | Fournir une source non consultable depuis la session | FR07 | Facultatif : photo d'un manuel de terminale (relation de conjugaison, ΔU = W + Q) pour remplacer la source SchoolMouv | 2026-10-29 |
| 15 | Changer un réglage de compte | — | Facultatif : autoriser le domaine de stockage de Whop dans les réglages de Claude, pour que la session dépose elle-même fichiers et galeries | 2026-10-29 |
| 16 | Valider une fiche (ou demander des corrections) | — | Décision D10 (OpenStax) appliquée par défaut : confirmer ou changer | 2026-10-29 |
| 17 | Valider une fiche (ou demander des corrections) | FR07 | Changement après validation : exemple échographie « graisse → muscle 1,4 % » devient « graisse → foie 1,1 % » (l'ancien reprenait un exemple d'OpenStax) ; confirmer | 2026-10-29 |
| 18 | Valider une fiche (ou demander des corrections) | FR09 | Fiche biostatistiques PASS/LAS (OK avec réserves : 2 formules de base encore sourcées par OpenStax seul) | 2026-10-29 |
| 19 | Faire relire une fiche par la personne du domaine | EN06 | PDF EN06-STD-a4 (6 pages) + produits/EN06/donnees/statut-methode.md (8 points, dont nœud sinusal et glandes sudoripares) | 2026-10-29 |
| 20 | Valider une fiche (ou demander des corrections) | FR03 | Titre : « normes françaises » remplacé par « valeurs usuelles françaises » (chaque laboratoire fixe ses intervalles ; proposition du vérificateur), appliqué par défaut : confirmer ou changer | 2026-10-29 |

## Runs

### R00 — Fondations : charte, chaîne de fabrication, outils

≈ 50 min · statut : Validé par Tristan

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 1 | Production | Charte graphique MindShelf | — | — | Charte MindShelf en tokens (data/charte_tokens.csv) + modèle Typst + version N&B + 3 propositions de nom FR | Validé par Tristan |
| 2 | Production | Chaîne de fabrication Typst | — | — | Chaîne Typst : build A4, Letter, N&B, tablette depuis une source unique ; fiche test | Validé par Tristan |
| 3 | Production | Outils de conditionnement | — | — | Scripts : aperçus PNG, vidéo de feuilletage, export Anki, gabarits d'annonces | Validé par Tristan |
| 4 | Vérification | Vérification indépendante | — | — | Contrôle de bout en bout sur la fiche test | Validé par Tristan |

### R01 — Fiches EN existantes passées à la charte

≈ 1 h 05 · statut : Vérifié, en attente de relecture et validation · dépend de : R00 · décisions requises : D04, D07

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 5 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | Vérifié, en attente de relecture et validation |
| 6 | Production | Rédaction et mise en page d'un produit | EN02 Physics Formula Sheet (College & Pre-Med) | — | Porter la fiche physique à jour dans la charte, titre élargi College & Pre-Med | Vérifié, en attente de relecture et validation |
| 7 | Production | Rédaction et mise en page d'un produit | EN03 Chemistry Formula Sheet (College & Pre-Med) | — | Porter la fiche chimie dans la charte | Vérifié, en attente de relecture et validation |
| 8 | Production | Rédaction et mise en page d'un produit | EN01 Dosage Calculation & IV Drip Rates | — | Porter la fiche dosage & IV dans la charte | Vérifié, en attente de relecture et validation |
| 133 | Production | Rédaction et mise en page d'un produit | EN01 Dosage Calculation & IV Drip Rates | CORR1 | Correction v2 : 2 bloquants et 3 majeurs du rapport-v1 (médicaments fictifs, noms distincts, arrondi du poids, manuel de référence identifié, Joint Commission MM.14.01.01) + mineurs | Vérifié, en attente de relecture et validation |
| 134 | Production | Rédaction et mise en page d'un produit | EN03 Chemistry Formula Sheet (College & Pre-Med) | CORR1 | Correction v2 : majeurs M2-M3 du rapport-v1 (source des inhibiteurs, bornes IR/RMN alignées sur la source) + mineurs ; M1 traité par la réécriture de l'annonce | Vérifié, en attente de relecture et validation |
| 135 | Production | Rédaction et mise en page d'un produit | EN02 Physics Formula Sheet (College & Pre-Med) | CORR1 | Correction v2 : 9 mineurs du rapport-v1 | Vérifié, en attente de relecture et validation |
| 139 | Production | Rédaction et mise en page d'un produit | EN01 Dosage Calculation & IV Drip Rates | CORR2 | Correction v3 : échos cliniques Drug B/E/F, unités coupées, mention près des exemples, encadré tablette, dossier de relecture ; puis régénération des éléments de vente | Vérifié, en attente de relecture et validation |
| 9 | Vérification | Vérification indépendante | EN02 Physics Formula Sheet (College & Pre-Med) | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 10 | Vérification | Vérification indépendante | EN03 Chemistry Formula Sheet (College & Pre-Med) | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 11 | Vérification | Vérification indépendante | EN01 Dosage Calculation & IV Drip Rates | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 136 | Vérification | Vérification indépendante | EN01 Dosage Calculation & IV Drip Rates | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 137 | Vérification | Vérification indépendante | EN03 Chemistry Formula Sheet (College & Pre-Med) | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 138 | Vérification | Vérification indépendante | EN02 Physics Formula Sheet (College & Pre-Med) | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 12 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN02 Physics Formula Sheet (College & Pre-Med) | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 13 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN03 Chemistry Formula Sheet (College & Pre-Med) | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 14 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN01 Dosage Calculation & IV Drip Rates | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |

### R02 — Adaptations FR des fiches existantes

≈ 1 h 05 · statut : Vérifié, en attente de relecture et validation · dépend de : R01 · décisions requises : D01, D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 15 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | Vérifié, en attente de relecture et validation |
| 16 | Production | Rédaction et mise en page d'un produit | FR07 PASS/LAS Physique-Biophysique — fiche formules | — | Adapter EN02 au tronc commun PASS/LAS (physique-biophysique), conventions françaises | Vérifié, en attente de relecture et validation |
| 17 | Production | Rédaction et mise en page d'un produit | FR08 PASS/LAS Chimie — fiche formules | — | Adapter EN03 au tronc commun PASS/LAS (chimie) | Vérifié, en attente de relecture et validation |
| 18 | Production | Rédaction et mise en page d'un produit | FR01 Calculs de doses et débits — fiche méthode | — | Fiche méthode calculs de doses et débits, variantes 2009 et 2026 | Vérifié, en attente de relecture et validation |
| 140 | Production | Rédaction et mise en page d'un produit | FR08 PASS/LAS Chimie — fiche formules | CORR1 | Correction v2 : sous-titre trop affirmatif et programmes récents (M1), note fluoxétine trop proche d'OpenStax (licence NC), doublons de constantes, mineurs ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 141 | Production | Rédaction et mise en page d'un produit | FR01 Calculs de doses et débits — fiche méthode | CORR1 | Correction v2 : statut des contrôles (valeurs B et F non vérifiées), échos cliniques nommés, UE 2026 sourcées (art. 23, CFVU UBE), mineurs ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 142 | Production | Rédaction et mise en page d'un produit | FR07 PASS/LAS Physique-Biophysique — fiche formules | CORR1 | Correction v2 : double signe moins (charte corrigée), sous-titre, licences OpenStax, références qui n'écrivent pas la formule, exemples FX20/FX21, symboles réutilisés, constats du conditionneur ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 19 | Vérification | Vérification indépendante | FR07 PASS/LAS Physique-Biophysique — fiche formules | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 20 | Vérification | Vérification indépendante | FR08 PASS/LAS Chimie — fiche formules | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 21 | Vérification | Vérification indépendante | FR01 Calculs de doses et débits — fiche méthode | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 143 | Vérification | Vérification indépendante | FR07 PASS/LAS Physique-Biophysique — fiche formules | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 144 | Vérification | Vérification indépendante | FR08 PASS/LAS Chimie — fiche formules | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 22 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR07 PASS/LAS Physique-Biophysique — fiche formules | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 23 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR08 PASS/LAS Chimie — fiche formules | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 24 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR01 Calculs de doses et débits — fiche méthode | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |

### R03 — Nouvelles fiches EN (SPI, labs, TEAS)

≈ 1 h 05 · statut : Vérifié, en attente de relecture et validation · dépend de : R00

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 25 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | En cours |
| 148 | Préparation | Orchestrateur (session principale de Claude) | — | — | Mettre à jour le Pre-Med & Nursing Pack Whop (prod_YF5trr8bKPh7E) avec les fiches validées (D06) ; EN01 quand la relecture infirmière sera faite | En cours |
| 149 | Préparation | Orchestrateur (session principale de Claude) | — | — | Dépôt manuel par Tristan (l'envoi de fichiers vers Whop est bloqué depuis la session) : fichiers EN02, EN03 dans leurs apps Files, FR07 (produit créé masqué prod_bVA9Q6H0Vxc3h, prix 4.90 EUR), galeries ; puis textes Whop EN02/EN03 et visibilité FR07 par l'orchestrateur | En cours |
| 26 | Production | Rédaction et mise en page d'un produit | EN04 SPI Ultrasound Physics — Express Review Sheets | — | Fiches express physique de l'échographie (SPI) | Vérifié, en attente de relecture et validation |
| 27 | Production | Rédaction et mise en page d'un produit | EN08 Lab Values Cheat Sheet | — | Fiche valeurs de laboratoire (unités US et SI) | Vérifié, en attente de relecture et validation |
| 28 | Production | Rédaction et mise en page d'un produit | EN10 TEAS 7 Science Review Sheets | — | Fiches TEAS 7 Science | Vérifié, en attente de relecture et validation |
| 132 | Production | Outils de conditionnement | — | — | Corrections reportées de R00 : M2 (style en dur de la vignette), M3/M4 (fiche test : arrondi, référence de la note clinique), 10 mineurs — voir runs/journal/R00-verification.md  (la correction de nombre() pour le signe moins U+2212 est faite en R02) | Vérifié, en attente de relecture et validation |
| 145 | Production | Outils de conditionnement | — | — | Outillage issu de R02 : contrôle du double signe moins dans controle_pdf.py ; nombres de cartes.csv générés depuis les tables ; champ de table numérique pour le mode d'arrondi des gouttes (N9 EN01, m5 FR01) | Vérifié, en attente de relecture et validation |
| 150 | Production | Rédaction et mise en page d'un produit | EN04 SPI Ultrasound Physics — Express Review Sheets | CORR1 | Correction v2 : sources consultables à la place de Kremkau non localisé (M1), source FDA § 5.2.8 (M2), plan v24.1, mineurs ; puis éléments de vente ; v3 : sourçage Radiopaedia des lignes A-VERIFIER | Vérifié, en attente de relecture et validation |
| 151 | Production | Rédaction et mise en page d'un produit | EN08 Lab Values Cheat Sheet | CORR1 | Correction v2 : INR cible selon l'indication (B1), hémolyse sans retarder le signalement (B2), repères cliniques sourcés, HbA1c NGSP, digoxine, HDL, contenu.csv, mineurs ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 153 | Production | Rédaction et mise en page d'un produit | EN10 TEAS 7 Science Review Sheets | CORR1 | Correction v2 : ABO avec facteur Rh, points-virgules avalés, sources des modes de transmission, localisations OpenStax, mineurs ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 29 | Vérification | Vérification indépendante | EN04 SPI Ultrasound Physics — Express Review Sheets | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 30 | Vérification | Vérification indépendante | EN08 Lab Values Cheat Sheet | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 31 | Vérification | Vérification indépendante | EN10 TEAS 7 Science Review Sheets | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 154 | Vérification | Vérification indépendante | EN04 SPI Ultrasound Physics — Express Review Sheets | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 155 | Vérification | Vérification indépendante | EN08 Lab Values Cheat Sheet | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 156 | Vérification | Vérification indépendante | EN10 TEAS 7 Science Review Sheets | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 32 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN04 SPI Ultrasound Physics — Express Review Sheets | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 33 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN08 Lab Values Cheat Sheet | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 34 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN10 TEAS 7 Science Review Sheets | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |

### R04 — Anatomie-physiologie EN + biostatistiques PASS

≈ 1 h 05 · statut : Vérifié, en attente de relecture et validation · dépend de : R00 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 35 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | Vérifié, en attente de relecture et validation |
| 36 | Production | Rédaction et mise en page d'un produit | EN06 Anatomy & Physiology — Body Systems Sheets | A | Squelette de la fiche (main.typ) et systèmes du lot A : tégumentaire, squelettique, musculaire, nerveux (avec sens spéciaux), endocrinien | Vérifié, en attente de relecture et validation |
| 37 | Production | Rédaction et mise en page d'un produit | EN06 Anatomy & Physiology — Body Systems Sheets | B | Systèmes du lot B : cardiovasculaire, lymphatique et immunitaire, respiratoire, digestif, urinaire, reproducteur | Vérifié, en attente de relecture et validation |
| 38 | Production | Rédaction et mise en page d'un produit | FR09 PASS/LAS Biostatistiques — fiche formules | — | Fiche formules biostatistiques PASS/LAS | Vérifié, en attente de relecture et validation |
| 146 | Production | Rédaction et mise en page d'un produit | FR07 PASS/LAS Physique-Biophysique — fiche formules | CORR_R02 | Mineurs du rapport-v2 FR07 : exemple FX11 repris d'OpenStax (changer d'interface), fiches d'UE datées de l'année en cours, source de P_THETA37, localisations CIPR 103 / Costanzo / McRobbie, art. L1333-2 CSP | Vérifié, en attente de relecture et validation |
| 147 | Production | Rédaction et mise en page d'un produit | FR08 PASS/LAS Chimie — fiche formules | CORR_R02 | Mineurs du rapport-v2 FR08 : pages Rennes, sous-titre et réserve dans une table, unité de ΔrS°, césure, source consultable pour pKa 6,1 et 0,03 | Vérifié, en attente de relecture et validation |
| 152 | Production | Outils de conditionnement | — | — | Contrôle de source dans build.py : échouer si un « ; » suit directement un appel #fonction(...) dans le texte Typst (point-virgule avalé, trouvé dans EN03 et EN10) ; anki.py : marqueur générique pour toute table du produit (ex. plan.csv, examens.csv), constat EN08/EN10 | Vérifié, en attente de relecture et validation |
| 157 | Production | Assemblage des kits et des guides | EN06 Anatomy & Physiology — Body Systems Sheets | — | Assembler les lots A et B (main.typ, tables, cartes, références, contenu) et fabriquer EN06-STD (fait par l'orchestrateur : fusion des tables -a/-b en tables canoniques) | Vérifié, en attente de relecture et validation |
| 159 | Production | Rédaction et mise en page d'un produit | EN06 Anatomy & Physiology — Body Systems Sheets | CORR1 | Correction v2 : valeurs du lot A resourcées hors OpenStax (M1), LH et ovulation, dates des sources en table, nœud sinusal, références, mineurs, statut-methode pour la relectrice ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 160 | Production | Rédaction et mise en page d'un produit | FR09 PASS/LAS Biostatistiques — fiche formules | CORR1 | Correction v2 : références hors OpenStax (M1), VPN par Bayes, séparateurs décimaux, mineurs, barre de racine ; puis éléments de vente | Vérifié, en attente de relecture et validation |
| 39 | Vérification | Vérification indépendante | EN06 Anatomy & Physiology — Body Systems Sheets | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 40 | Vérification | Vérification indépendante | FR09 PASS/LAS Biostatistiques — fiche formules | — | Vérification indépendante | Vérifié, en attente de relecture et validation |
| 161 | Vérification | Vérification indépendante | EN06 Anatomy & Physiology — Body Systems Sheets | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 162 | Vérification | Vérification indépendante | FR09 PASS/LAS Biostatistiques — fiche formules | CORR1 | Contre-vérification des corrections v2 | Vérifié, en attente de relecture et validation |
| 41 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN06 Anatomy & Physiology — Body Systems Sheets | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 42 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR09 PASS/LAS Biostatistiques — fiche formules | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |

### R05 — Fiches IFSI à faible risque

≈ 1 h 05 · statut : En cours · dépend de : R00 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 43 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | Vérifié, en attente de relecture et validation |
| 44 | Production | Rédaction et mise en page d'un produit | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | — | Pack stage IFSI, variantes 2009 et 2026 | Produit, en attente de vérification |
| 45 | Production | Rédaction et mise en page d'un produit | FR03 Bilan biologique — valeurs usuelles françaises | — | Bilan biologique, normes françaises, variantes 2009 et 2026 | Produit, en attente de vérification |
| 158 | Production | Outils de conditionnement | — | — | anki.py : le marqueur {v:CLE} affiche « × 10⁰ » quand l'exposant vaut 0 (contourné dans EN04 et FR07) ; ne rien afficher pour un exposant nul ou vide (fait par l'orchestrateur au lancement de R05) | Vérifié, en attente de relecture et validation |
| 163 | Production | Rédaction et mise en page d'un produit | — | — | Si D10 est confirmée : resourcer hors OpenStax les valeurs des fiches déjà produites qui ne reposent que sur OpenStax (EN02, EN03, EN10, FR07, FR08 ; FR09 : σ² de population, Z = (X − μ)/σ), une ligne par valeur, sans changer le fond | Bloqué (décision ou entrée manquante) |
| 164 | Production | Rédaction et mise en page d'un produit | EN06 Anatomy & Physiology — Body Systems Sheets | CORR_R04 | Mineurs du rapport-v2 EN06 : phrase œstrogène/LH (puberté), code SEER_MELANOMA ; puis décisions de la relectrice | Vérifié, en attente de relecture et validation |
| 165 | Production | Rédaction et mise en page d'un produit | FR09 PASS/LAS Biostatistiques — fiche formules | CORR_R04 | Mineurs du rapport-v2 FR09 : source qui écrit l'IC avec p̂, contrôle des 7 décomptes de contenu.csv, césure « co-horte » | Vérifié, en attente de relecture et validation |
| 166 | Production | Rédaction et mise en page d'un produit | FR03 Bilan biologique — valeurs usuelles françaises | CORR1 | Correction v2 : INR au-dessus et au-dessous de la cible (B1), kaliémie « élevée » relative au compte rendu, année de la source affichée, références, contenu.csv, mineurs ; puis éléments de vente | Produit, en attente de vérification |
| 167 | Production | Rédaction et mise en page d'un produit | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | CORR1 | Correction v2 : alerter d'abord devant une valeur grave (B1), précautions respiratoires SF2H 2024 (B2), UE B.3 sans promesse d'évaluation, Glasgow sourcé avec NT, constantes, douleur sous 4, masque IIR, exceptions FHA, sources, mineurs ; puis éléments de vente | En cours |
| 46 | Vérification | Vérification indépendante | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | — | Vérification indépendante | Vérification : corrections bloquantes |
| 47 | Vérification | Vérification indépendante | FR03 Bilan biologique — valeurs usuelles françaises | — | Vérification indépendante | Vérification : corrections bloquantes |
| 48 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions) | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |
| 49 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR03 Bilan biologique — valeurs usuelles françaises | — | Aperçus, vidéo, Anki, annonces, script iPhone | Vérifié, en attente de relecture et validation |

### R06 — Fiches EN à risque fort (EKG, ABG)

≈ 1 h 05 · statut : À faire · dépend de : R00 · décisions requises : D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 50 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 51 | Production | Rédaction et mise en page d'un produit | EN05 EKG Rhythms Cheat Sheet | — | Fiche rythmes ECG (tracés dessinés en code) | À faire |
| 52 | Production | Rédaction et mise en page d'un produit | EN07 ABG Interpretation Cheat Sheet | — | Fiche interprétation des gaz du sang | À faire |
| 168 | Production | Outils de conditionnement | — | — | Typographie française dans la charte (langue fr) : espace fine insécable avant « ; ! ? » (absente dans FR03 : « g/L; la ») ; apostrophe typographique dans data/mentions.csv (« d'un.e » du pied FR, constat m8 FR03) et contrôle des apostrophes droites dans controle_pdf.py pour le français ; non-régression sur tous les PDF | À faire |
| 53 | Vérification | Vérification indépendante | EN05 EKG Rhythms Cheat Sheet | — | Vérification indépendante | À faire |
| 54 | Vérification | Vérification indépendante | EN07 ABG Interpretation Cheat Sheet | — | Vérification indépendante | À faire |
| 55 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN05 EKG Rhythms Cheat Sheet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |
| 56 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN07 ABG Interpretation Cheat Sheet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R07 — Pharmacologie IFSI

≈ 1 h 05 · statut : À faire · dépend de : R00 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 57 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 58 | Production | Rédaction et mise en page d'un produit | FR04 Pharmacologie IFSI — 10 classes | A | Classes 1 à 5 (DCI et spécialités françaises, surveillance infirmière) | À faire |
| 59 | Production | Rédaction et mise en page d'un produit | FR04 Pharmacologie IFSI — 10 classes | B | Classes 6 à 10 | À faire |
| 60 | Vérification | Vérification indépendante | FR04 Pharmacologie IFSI — 10 classes | — | Vérification indépendante | À faire |
| 61 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR04 Pharmacologie IFSI — 10 classes | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R08 — Kits EN et FR

≈ 1 h 05 · statut : À faire · dépend de : R01, R02, R03, R05, R06, R07 · décisions requises : D01, D04

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

≈ 55 min · statut : À faire · dépend de : R03

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 69 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 70 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | PLAN | Plan détaillé du guide + chapitres 1-2 | À faire |
| 71 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | L1 | chapitres 3-4 | À faire |
| 72 | Production | Banque de questions d'un guide | EN11 SPI Ultrasound Physics — Complete Study Guide | Q1 | Banque de questions, partie 1 | À faire |
| 73 | Vérification | Vérification indépendante | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R10 — Guide SPI 2/3

≈ 55 min · statut : À faire · dépend de : R09

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 74 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 75 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | L2 | chapitres 5-6 | À faire |
| 76 | Production | Rédaction et mise en page d'un produit | EN11 SPI Ultrasound Physics — Complete Study Guide | L3 | chapitres 7-8 | À faire |
| 77 | Production | Banque de questions d'un guide | EN11 SPI Ultrasound Physics — Complete Study Guide | Q2 | Banque de questions, partie 2 | À faire |
| 78 | Vérification | Vérification indépendante | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R11 — Guide SPI 3/3

≈ 1 h 05 · statut : À faire · dépend de : R10

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 79 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 80 | Production | Assemblage des kits et des guides | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 81 | Production | Banque de questions d'un guide | EN11 SPI Ultrasound Physics — Complete Study Guide | EXAM | Examen blanc et corrigé expliqué | À faire |
| 82 | Vérification | Vérification indépendante | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Vérification complète du guide assemblé | À faire |
| 83 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN11 SPI Ultrasound Physics — Complete Study Guide | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R12 — Guide TEAS 7 Science 1/3

≈ 55 min · statut : À faire · dépend de : R03, R04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 84 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 85 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | PLAN | Plan détaillé du guide + anatomie-physiologie (1/2) | À faire |
| 86 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | L1 | anatomie-physiologie (2/2) | À faire |
| 87 | Production | Banque de questions d'un guide | EN12 TEAS 7 Science — Complete Study Guide | Q1 | Banque de questions, partie 1 | À faire |
| 88 | Vérification | Vérification indépendante | EN12 TEAS 7 Science — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R13 — Guide TEAS 7 Science 2/3

≈ 55 min · statut : À faire · dépend de : R12

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 89 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 90 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | L2 | biologie et chimie | À faire |
| 91 | Production | Rédaction et mise en page d'un produit | EN12 TEAS 7 Science — Complete Study Guide | L3 | physique et raisonnement scientifique | À faire |
| 92 | Production | Banque de questions d'un guide | EN12 TEAS 7 Science — Complete Study Guide | Q2 | Banque de questions, partie 2 | À faire |
| 93 | Vérification | Vérification indépendante | EN12 TEAS 7 Science — Complete Study Guide | — | Vérification des chapitres et questions du run | À faire |

### R14 — Guide TEAS 7 Science 3/3

≈ 1 h 05 · statut : À faire · dépend de : R13

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 94 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 95 | Production | Assemblage des kits et des guides | EN12 TEAS 7 Science — Complete Study Guide | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 96 | Production | Banque de questions d'un guide | EN12 TEAS 7 Science — Complete Study Guide | EXAM | Examen blanc et corrigé expliqué | À faire |
| 97 | Vérification | Vérification indépendante | EN12 TEAS 7 Science — Complete Study Guide | — | Vérification complète du guide assemblé | À faire |
| 98 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | EN12 TEAS 7 Science — Complete Study Guide | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R15 — Cahier calculs de doses 1/3

≈ 55 min · statut : À faire · dépend de : R02 · décisions requises : D01, D04

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 99 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 100 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | PLAN | Plan détaillé du guide + rappels et méthode | À faire |
| 101 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | L1 | exercices 1 à 35 | À faire |
| 102 | Production | Banque de questions d'un guide | FR06 Cahier calculs de doses — 100 exercices corrigés | Q1 | Banque de questions, partie 1 | À faire |
| 103 | Vérification | Vérification indépendante | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Vérification des chapitres et questions du run | À faire |

### R16 — Cahier calculs de doses 2/3

≈ 55 min · statut : À faire · dépend de : R15

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 104 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 105 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | L2 | exercices 36 à 70 | À faire |
| 106 | Production | Rédaction et mise en page d'un produit | FR06 Cahier calculs de doses — 100 exercices corrigés | L3 | exercices 71 à 100 et situations cliniques | À faire |
| 107 | Production | Banque de questions d'un guide | FR06 Cahier calculs de doses — 100 exercices corrigés | Q2 | Banque de questions, partie 2 | À faire |
| 108 | Vérification | Vérification indépendante | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Vérification des chapitres et questions du run | À faire |

### R17 — Cahier calculs de doses 3/3

≈ 1 h 05 · statut : À faire · dépend de : R16

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 109 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 110 | Production | Assemblage des kits et des guides | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 111 | Production | Banque de questions d'un guide | FR06 Cahier calculs de doses — 100 exercices corrigés | EXAM | Examen blanc et corrigé expliqué | À faire |
| 112 | Vérification | Vérification indépendante | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Vérification complète du guide assemblé | À faire |
| 113 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR06 Cahier calculs de doses — 100 exercices corrigés | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R18 — Guide Physique-Biophysique PASS 1/3

≈ 55 min · statut : À faire · dépend de : R02 · décisions requises : D01

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 114 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 115 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | PLAN | Plan détaillé du guide + états de la matière | À faire |
| 116 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | L1 | rayonnements | À faire |
| 117 | Production | Banque de questions d'un guide | FR10 Physique-Biophysique PASS/LAS — guide complet | Q1 | Banque de questions, partie 1 | À faire |
| 118 | Vérification | Vérification indépendante | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Vérification des chapitres et questions du run | À faire |

### R19 — Guide Physique-Biophysique PASS 2/3

≈ 55 min · statut : À faire · dépend de : R18

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 119 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 120 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | L2 | circulation des fluides | À faire |
| 121 | Production | Rédaction et mise en page d'un produit | FR10 Physique-Biophysique PASS/LAS — guide complet | L3 | transports membranaires et électrophysiologie | À faire |
| 122 | Production | Banque de questions d'un guide | FR10 Physique-Biophysique PASS/LAS — guide complet | Q2 | Banque de questions, partie 2 | À faire |
| 123 | Vérification | Vérification indépendante | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Vérification des chapitres et questions du run | À faire |

### R20 — Guide Physique-Biophysique PASS 3/3

≈ 1 h 05 · statut : À faire · dépend de : R19

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 124 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 125 | Production | Assemblage des kits et des guides | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Assemblage final : sommaire, renvois, index, corrigés | À faire |
| 126 | Production | Banque de questions d'un guide | FR10 Physique-Biophysique PASS/LAS — guide complet | EXAM | Examen blanc et corrigé expliqué | À faire |
| 127 | Vérification | Vérification indépendante | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Vérification complète du guide assemblé | À faire |
| 128 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | FR10 Physique-Biophysique PASS/LAS — guide complet | — | Aperçus, vidéo, Anki, annonces, script iPhone | À faire |

### R21 — Mise en vente Etsy et contrôle final

≈ 40 min · statut : À faire · dépend de : R08, R11, R14, R17, R20 · décisions requises : D02

| # | Phase | Rôle | Produit | Lot | Tâche | Statut |
|---|---|---|---|---|---|---|
| 129 | Préparation | Orchestrateur (session principale de Claude) | — | — | Publier sur Whop les variantes VALIDE, vérifier dépendances et décisions bloquantes | À faire |
| 131 | Vérification | Vérification indépendante | — | — | Contrôle de conformité final : mentions IA, marques, aperçus, risque FORT hors Etsy | À faire |
| 130 | Conditionnement | Aperçus, vidéo, Anki, annonces, script iPhone | — | — | Paquets Etsy finaux, textes de boutique, calendrier de publication étalé | À faire |

