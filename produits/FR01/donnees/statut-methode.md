# Méthode en brouillon : relecture infirmière en attente

**Produit :** FR01 « Calculs de doses et débits — fiche méthode » (marque Clairance, marché FR, étudiant.e.s en IFSI), variantes **FR01-2009** (référentiel 2009) et **FR01-2026** (référentiel 2026).
**Statut :** méthode rédigée par l'agent producteur (run R02, 29.10.2026), `methode_auteur = AGENT`, risque IA **FORT**. Adaptée de EN01 v3 (règle d'arrondi unique, médicaments fictifs, unités insécables, encadré d'arrondi non sécable), sans traduction. Correction v2 du 29.10.2026 après le rapport v1 du vérificateur R02 (`verif/rapport-v1.md`) : documents de contrôle corrigés (M1, M2), Produit C passé de 1,2 % à 6,8 %, seringue de 3 mL, facteur de gouttes « à lire sur l'emballage », ligne d'UE 2009 précisée.
**Conséquences :** relecture métier obligatoire avant validation ; produit **Whop uniquement**, jamais sur Etsy (décision D04), y compris après relecture, tant que la méthode n'est pas réécrite ou reprise par Tristan.

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE INFIRMIÈRE.** Aucun dépôt Whop (ni envoi du PDF à qui que ce soit) tant que `data/revues.csv` ne contient pas une ligne de relecture métier validée pour chaque variante (FR01-2009 et FR01-2026). Raison : le pied de page du PDF affirme « contenu vérifié et validé par le vendeur », ce qui n'est exact qu'après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

Cette mention ne figure pas dans le PDF ; elle accompagne la source jusqu'à la relecture.

## Pour la relectrice

### Fichiers et version à relire
- **Fichier :** `livraison/FR01-2009/FR01-2009-a4.pdf`. La variante 2026 (`livraison/FR01-2026/FR01-2026-a4.pdf`) a le même contenu ; seule la première ligne (rattachement aux UE) change. Letter, N&B et tablette ont le même contenu, seule la mise en page change.
- **Version :** le pied de page affiche **v1** (`data/variantes.csv`, colonne `version`). La ligne de `data/revues.csv` reprend la version imprimée en pied de page du PDF relu.

### Périmètre de la relecture (décision de Tristan, sur le modèle de D08)
- **Ce que la relectrice (infirmière, Suisse) relit :** les calculs, la sécurité clinique, les arrondis et la clarté.
- **Ce qui ne lui est pas demandé comme validation :** les conventions françaises (vocabulaire IFSI, normes NF EN ISO des perfuseurs et seringues, règle des 5 B de la HAS, never events de l'ANSM) et les intitulés d'UE des référentiels 2009 et 2026. Ces points reposent sur les sources citées dans `references.csv`.
- Précision : elle valide les **valeurs** utilisées (20 et 60 gouttes/mL, graduations et capacité des seringues, pas de réglage des appareils, points 1 à 3 et 8) ; la **citation** des normes qui les fixent repose sur les sources.
- Elle peut les signaler si quelque chose lui paraît faux, sans être tenue de les vérifier.

### Où consigner les décisions
Chaque décision va dans un champ de table, jamais dans une note en texte.

| Décision | Champ | Valeur actuelle |
|---|---|---|
| Pas de réglage du PSE et de la pompe (point 1) | `donnees/valeurs.csv`, clé `debit_pas` | 0,1 mL/h |
| Arrondi des gouttes (point 2) | Aucun champ pour l'instant : la fiche arrondit au plus proche (`calc.round`). Décision à porter dans la ligne de `data/revues.csv` ; si elle diffère, créer une clé dans `valeurs.csv` lue par `main.typ`. | au plus proche |
| Graduations et capacités des seringues (point 3) | `donnees/valeurs.csv`, clés `seringue_petite_pas`, `seringue_std_pas` (capacités : `seringue_petite`, `seringue_std`) | 0,01 mL (1 mL) ; 0,1 mL (3 mL) |
| Convention de poids (point 4) | `donnees/valeurs.csv`, clé `poids_pas` | noté tel que pesé (0,1 kg), puis utilisé tel quel |
| Arrondi unique (point 5) | Colonne `arrondi` de `donnees/exemples.csv` (décimales de la seule valeur réglée ou prélevée) | intermédiaires jamais arrondis |

Validation : une ligne par variante dans `data/revues.csv` (`variante_code`, `version` du pied de page relu, `etape_code` de relecture métier, `acteur`, `statut_code`, `date`, `rapport`), écrite par l'orchestrateur à partir du retour de la relectrice.

### Ouvrage de référence
Rispail D, Viaux A, *Guide du calcul de doses et de débits médicamenteux. Méthodologie, entraînement, évaluations*, 4e éd., Elsevier Masson, 2017, ISBN 978-2-294-75628-3 : les renvois ci-dessous portent sur cette édition. **Une 5e édition existe** : Rispail D, Viaux A, Horn F, Simon V, Elsevier Masson, 1.4.2024, ISBN 978-2-294-78300-5, au même plan (parties I à III, ch. 1 à 5, fiches 1 à 6, d'après sa table des matières en ligne). La relectrice note l'édition qu'elle a en main et y relève les pages.

| Point de la fiche | Partie et chapitre |
|---|---|
| Méthode, prescription (§ 1) | I, ch. 2 |
| Conversions, proportionnalité (§ 1–2) | III, fiches 2 et 6 |
| Reconstitution, dilution (§ 3–4) | I, ch. 3 |
| Fourchette au poids, conduite hors fourchette (§ 5) | I, ch. 1–2 |
| Débits, PSE, arrondis (§ 6–9) | I, ch. 4 ; III, fiche 1 |

### Valeurs d'exercice (règle 11)

| Exemple | Valeurs | Origine | Contrôle |
|---|---|---|---|
| EX01 (Produit A) | ampoule 64 mg/2 mL (32 mg/mL) ; 28 mg ⇒ 0,875 ⇒ 0,88 mL | EN01 v3 (Drug A) | contrôlé par le vérificateur R01 (EN01, rapport v2) |
| EX03 (Produit C) | 6,8 % (68 mg/mL) ; 170 mg ⇒ 2,5 mL (1,2 % et 30 mg en v1) | nouvelle | **à confirmer par la relectrice** |
| EX04 (Produit E) | 1,4 g + 6,2 mL ⇒ 7 mL (200 mg/mL) ; 320 mg ⇒ 1,6 mL | EN01 v3 (Drug D) | contrôlé par le vérificateur R01 (EN01, rapport v2) |
| EX05 (Produit B) | 36 à 48 mg/kg/j ; 20 kg ⇒ 720 à 960 mg/j ; 210 mg toutes les 6 h ⇒ 840 mg/j | EN01 v3 (Drug B) | **jamais vérifié** (EN01 rapport v2 : 17 à 33 mg/kg/j toutes les 8 h) : à confirmer par la relectrice |
| EX09 (Produit D) | 135 mg complétés à 45 mL (3 mg/mL) ; 5,6 mg/h ⇒ 1,867 ⇒ 1,9 mL/h | nouvelle | **à confirmer par la relectrice** |
| EX10 (Produit F) | 55 mg/50 mL (1100 µg/mL) ; 4,5 µg/kg/min ; 76,4 kg ⇒ 18,753 ⇒ 18,8 mL/h | EN01 v3 (Drug E), passé en seringue de PSE | dose et poids contrôlés en R01 ; concentration **jamais vérifiée** (EN01 rapport v2 : 1200 µg/mL) : à confirmer par la relectrice |

## Ce que la relecture doit confirmer

### Arrondis et valeurs réglables (priorité sécurité)
1. **Pas de réglage** : mL/h au dixième pour le PSE et la pompe (`debit_pas` = 0,1, colonne `arrondi` = 1) ; la fiche signale que certains appareils ne prennent que le mL/h entier. Exemples : EX06A (125 mL/h), EX09B (1,867 ⇒ 1,9 mL/h), EX10B (18,753 ⇒ 18,8 mL/h).
2. **Gouttes** : gouttes/min arrondies à l'entier le plus proche (EX06B : 41,67 ⇒ 42). Confirmer « au plus proche ».
3. **Seringues** : seringue de 1 mL graduée au 0,01 mL (EX01 : 0,875 ⇒ 0,88 mL) ; seringue de 3 mL graduée au 0,1 mL pour EX03B (2,5 mL) et EX04B (1,6 mL), capacité désormais affichée (2,5 mL ne tient pas dans une seringue de 2 mL, et une seringue de 5 mL est souvent graduée au 0,2 mL). Confirmer capacité et graduation.
4. **Poids** : noté tel que pesé au dixième de kg, puis utilisé tel quel (EX10B : 76,4 kg sans arrondi).
5. **Arrondi unique** : concentrations et intermédiaires jamais arrondis (EX09A → EX09B, EX10A → EX10B). Vérifier qu'aucun cours d'IFSI n'impose un arrondi intermédiaire contraire.

### Méthodes
6. **§ 1** : méthode en 4 étapes ; produit en croix écrit V = D × Q ÷ H.
7. **§ 5** : conduite hors fourchette « ne pas administrer, joindre le.la prescripteur.rice ».
8. **§ 6** : facteurs de gouttes 20 (perfuseur standard) et 60 (perfuseur pédiatrique à microgouttes), « à lire sur l'emballage du perfuseur » ; raccourcis « gouttes/min = mL/h » (60) et « gouttes/min = mL/h ÷ 3 » (20) ; terme « perfuseur pédiatrique » à confirmer.
9. **Échos cliniques (règle 11)** : confirmer qu'aucune valeur des Produits A à F n'évoque un protocole réel connu des étudiant.e.s. **Seuls A, E et la dose de F (4,5 µg/kg/min, 76,4 kg) ont été contrôlés** par le vérificateur R01 (EN01, rapport v2). Les valeurs de B et la concentration de F reprises d'EN01 v3 n'ont jamais été vérifiées : elles sont à confirmer au même titre que C et D. Échos relevés par le vérificateur R02 (rapport v1, m9), à trancher :
   - **Produit C** : en v1, 1,2 % (12 mg/mL), dans la zone de la lidocaïne (1 et 2 %), au cœur du never event ANSM n° 13 (surdosage de lidocaïne IV par confusion entre concentration et quantité totale). **Corrigé en v2** : 6,8 % (68 mg/mL), 170 mg ⇒ 2,5 mL, au-delà des concentrations courantes des anesthésiques locaux injectables ; aucune solution injectable courante à 6,8 % connue (connaissances générales, non sourcé). Confirmer.
   - **Produit D** (135 mg/45 mL, 3 mg/mL ; 5,6 mg/h au PSE) : la dose en mg/h au PSE tombe dans la zone des sédatifs et des opioïdes en PSE (never event n° 11, programmation des pompes et PSE). Aucune préparation courante à 3 mg/mL trouvée (recherche non concluante) ; héparine et insuline se dosent en UI. Valeur gardée : l'écho tient à l'unité mg/h, pas au chiffre.
   - **Produit F** (55 mg/50 mL, 1100 µg/mL ; 4,5 µg/kg/min) : ni dopamine ni dobutamine (préparations en seringue de 50 mL de plusieurs mg/mL), ni noradrénaline ; écho possible avec une préparation de **nitroprussiate** à 1 mg/mL (non vérifié). Valeur gardée : toute dose en µg/kg/min de cet ordre évoque un inotrope ou un vasodilatateur.
   - **Produit B** (36 à 48 mg/kg/j toutes les 6 h ; 20 kg ; 210 mg) : n'égale aucune fourchette connue (paracétamol, ibuprofène), mais tombe dans l'étendue de plusieurs antibiotiques donnés toutes les 6 h. Valeur gardée.
10. **Note clinique § 10** : chlorure de potassium injectable et programmation des pompes et PSE cités d'après la liste des never events de l'ANSM (mise à jour 18.09.2025), sans dose et loin des exemples. Confirmer la formulation.

### Variantes
11. **Lignes d'UE affichées** (hors périmètre de la relectrice) :
   - **2009** : « Référentiel 2009 (entré.e.s en formation avant septembre 2026) : UE 2.11 … (S1, S3, S5) et UE 4.4 … (S2, S4, S5) ». Numéros, intitulés et semestres vérifiés dans l'annexe III de l'arrêté du 31 juillet 2009 ; public d'après l'art. 60, I de l'arrêté du 20 février 2026 (`SRC_IFSI_2026`).
   - **2026** : les 4 PDF FR01-2026 affichent « calculs de doses travaillés notamment en UE B.3 « Pratiques et interventions infirmières » et UE B.4 « Démarche qualité et gestion des risques » ». Sources : arrêté du 20 février 2026, art. 23 (nomme l'UE B.3) et art. 60, I (entrant.e.s à compter de septembre 2026), copie FHF (`SRC_IFSI_2026`) ; délibération CFVU de l'Université de Bourgogne Europe du 16.06.2026 (B.3 en S1 et S2 avec les calculs de doses en S1 ; B.4 en S2) (`UBE_CFVU_2026`) ; offre de formation UBE (`UBE_ODF_2026`) ; titre Vuibert 2026 (`VUIBERT_2026`), seule source du rattachement de B.4, d'où « notamment ».
   - Reste **A-VERIFIER** : l'annexe III de l'arrêté du 20 février 2026 (référentiel de formation), non lue (`donnees/variantes.csv`, ligne FR01-2026). À compléter par l'orchestrateur quand l'annexe est lue.

## Lignes `A-VERIFIER` de `references.csv`
- **RISPAIL_2017** (6 lignes) : ouvrage, éditions (4e 2017, 5e 2024) et table des matières vérifiés en ligne ; pages et contenu à relever livre en main, édition notée par la relectrice.
- **ISO_8536_4, ISO_8536_5, ISO_7886_1** : édition et paragraphe, norme en main.
- **PH_EUR_GN** : numéro du paragraphe dans l'édition en vigueur.
- **HAS_ADM_2011** (1 ligne) : localisation de « prescription incomplète ou illisible » dans la partie 2. La ligne des 5 B est levée (partie 1, version de mai 2013, p. 12).
- **EXERCICE** : confirmation de la relectrice (point 9).
- **SRC_IFSI_2009** : rattachement des calculs de doses aux UE 2.11 et 4.4, à lire dans les fiches pédagogiques (numéros et intitulés vérifiés).
- **SRC_IFSI_2026** (2 lignes) : annexe III de l'arrêté du 20 février 2026 (B.3 établie par l'art. 23 et par `UBE_CFVU_2026` ; rattachement de B.4 par l'éditeur seul).
- Vérifiées : BIPM_SI_9, ANSM_NEVER_EVENTS (page consultée le 29.10.2026), HAS_ADM_2011 (5 B), SRC_IFSI_2026 (art. 23 et 60, copie FHF lue le 29.10.2026), UBE_CFVU_2026 (relevée par le vérificateur R02).
