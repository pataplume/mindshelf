# Méthode en brouillon : relecture infirmière en attente

**Produit :** FR01 « Calculs de doses et débits — fiche méthode » (marque Clairance, marché FR, étudiant.e.s en IFSI), variantes **FR01-2009** (référentiel 2009) et **FR01-2026** (référentiel 2026).
**Statut :** méthode rédigée par l'agent producteur (run R02, 29.10.2026), `methode_auteur = AGENT`, risque IA **FORT**. Adaptée de EN01 v3 (règle d'arrondi unique, médicaments fictifs, unités insécables, encadré d'arrondi non sécable), sans traduction.
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
- Elle peut les signaler si quelque chose lui paraît faux, sans être tenue de les vérifier.

### Où consigner les décisions
Chaque décision va dans un champ de table, jamais dans une note en texte.

| Décision | Champ | Valeur actuelle |
|---|---|---|
| Pas de réglage du PSE et de la pompe (point 1) | `donnees/valeurs.csv`, clé `debit_pas` | 0,1 mL/h |
| Arrondi des gouttes (point 2) | Aucun champ pour l'instant : la fiche arrondit au plus proche (`calc.round`). Décision à porter dans la ligne de `data/revues.csv` ; si elle diffère, créer une clé dans `valeurs.csv` lue par `main.typ`. | au plus proche |
| Graduations des seringues (point 3) | `donnees/valeurs.csv`, clés `seringue_petite_pas` et `seringue_std_pas` (capacité : `seringue_petite`) | 0,01 mL (1 mL) ; 0,1 mL |
| Convention de poids (point 4) | `donnees/valeurs.csv`, clé `poids_pas` | noté tel que pesé (0,1 kg), puis utilisé tel quel |
| Arrondi unique (point 5) | Colonne `arrondi` de `donnees/exemples.csv` (décimales de la seule valeur réglée ou prélevée) | intermédiaires jamais arrondis |

Validation : une ligne par variante dans `data/revues.csv` (`variante_code`, `version` du pied de page relu, `etape_code` de relecture métier, `acteur`, `statut_code`, `date`, `rapport`), écrite par l'orchestrateur à partir du retour de la relectrice.

### Ouvrage de référence
Rispail D, Viaux A, *Guide du calcul de doses et de débits médicamenteux. Méthodologie, entraînement, évaluations*, 4e éd., Elsevier Masson, 2017, ISBN 978-2-294-75628-3. Une autre édition figure sur la boutique Elsevier (ISBN 978-2-294-74225-5) : la relectrice note l'édition consultée. Chapitres d'après la table des matières en ligne ; pages à relever livre en main.

| Point de la fiche | Partie et chapitre |
|---|---|
| Méthode, prescription (§ 1) | I, ch. 2 |
| Conversions, proportionnalité (§ 1–2) | III, fiches 2 et 6 |
| Reconstitution, dilution (§ 3–4) | I, ch. 3 |
| Fourchette au poids, conduite hors fourchette (§ 5) | I, ch. 1–2 |
| Débits, PSE, arrondis (§ 6–9) | I, ch. 4 ; III, fiche 1 |

### Valeurs d'exercice (règle 11)

| Exemple | Valeurs | Origine |
|---|---|---|
| EX01 (Produit A) | ampoule 64 mg/2 mL (32 mg/mL) ; 28 mg ⇒ 0,875 ⇒ 0,88 mL | EN01 v3 (Drug A, contrôlé) |
| EX03 (Produit C) | 1,2 % (12 mg/mL) ; 30 mg ⇒ 2,5 mL | nouvelle |
| EX04 (Produit E) | 1,4 g + 6,2 mL ⇒ 7 mL (200 mg/mL) ; 320 mg ⇒ 1,6 mL | EN01 v3 (Drug D, contrôlé) |
| EX05 (Produit B) | 36 à 48 mg/kg/j ; 20 kg ⇒ 720 à 960 mg/j ; 210 mg toutes les 6 h ⇒ 840 mg/j | EN01 v3 (Drug B, contrôlé) |
| EX09 (Produit D) | 135 mg complétés à 45 mL (3 mg/mL) ; 5,6 mg/h ⇒ 1,867 ⇒ 1,9 mL/h | nouvelle |
| EX10 (Produit F) | 55 mg/50 mL (1 100 µg/mL) ; 4,5 µg/kg/min ; 76,4 kg ⇒ 18,753 ⇒ 18,8 mL/h | concentration et dose de Drug E (EN01 v3), passées en seringue de PSE |

## Ce que la relecture doit confirmer

### Arrondis et valeurs réglables (priorité sécurité)
1. **Pas de réglage** : mL/h au dixième pour le PSE et la pompe (`debit_pas` = 0,1, colonne `arrondi` = 1) ; la fiche signale que certains appareils ne prennent que le mL/h entier. Exemples : EX06A (125 mL/h), EX09B (1,867 ⇒ 1,9 mL/h), EX10B (18,753 ⇒ 18,8 mL/h).
2. **Gouttes** : gouttes/min arrondies à l'entier le plus proche (EX06B : 41,67 ⇒ 42). Confirmer « au plus proche ».
3. **Seringues** : seringue de 1 mL graduée au 0,01 mL (EX01 : 0,875 ⇒ 0,88 mL) ; graduation de 0,1 mL pour EX03B (2,5 mL) et EX04B (1,6 mL), capacité non précisée sur la fiche. Confirmer.
4. **Poids** : noté tel que pesé au dixième de kg, puis utilisé tel quel (EX10B : 76,4 kg sans arrondi).
5. **Arrondi unique** : concentrations et intermédiaires jamais arrondis (EX09A → EX09B, EX10A → EX10B). Vérifier qu'aucun cours d'IFSI n'impose un arrondi intermédiaire contraire.

### Méthodes
6. **§ 1** : méthode en 4 étapes ; produit en croix écrit V = D × Q ÷ H.
7. **§ 5** : conduite hors fourchette « ne pas administrer, joindre le.la prescripteur.rice ».
8. **§ 6** : facteurs de gouttes 20 (perfuseur standard) et 60 (perfuseur pédiatrique à microgouttes) ; raccourcis « gouttes/min = mL/h » (60) et « gouttes/min = mL/h ÷ 3 » (20) ; terme « perfuseur pédiatrique » à confirmer.
9. **Échos cliniques (règle 11)** : confirmer qu'aucune valeur des Produits A à F n'évoque un protocole réel connu des étudiant.e.s. Contrôles faits :
   - Produits A, B, E, F : valeurs d'EN01 v3, contrôlées par le vérificateur R01 (rapport v2). Réserve héritée sur B : 36 à 48 mg/kg/j toutes les 6 h n'égale aucune fourchette connue, mais tombe dans l'étendue de plusieurs antibiotiques oraux donnés toutes les 6 h. F : 1 100 µg/mL ne correspond ni à la dopamine ni à la dobutamine (préparations courantes à 800, 1 600, 3 200 et 1 000, 2 000, 4 000 µg/mL ; en seringue de 50 mL, plusieurs mg/mL), ni à la noradrénaline (de l'ordre de la centaine de µg/mL) ; 4,5 µg/kg/min reste dans l'ordre de grandeur des inotropes, sans protocole égal.
   - Produit C (1,2 %, 12 mg/mL) : aucune spécialité courante à 1,2 % connue (lidocaïne 1 et 2 %). Recherche web du 29.10.2026 sans résultat.
   - Produit D (3 mg/mL en mg/h, 135 mg/45 mL, 5,6 mg/h) : aucune préparation de PSE courante à 3 mg/mL trouvée ; héparine et insuline se dosent en UI, l'amiodarone en PSE est plus concentrée, et la dopamine se dose en µg/kg/min. Recherche web du 29.10.2026 sans résultat.
10. **Note clinique § 10** : chlorure de potassium injectable et programmation des pompes et PSE cités d'après la liste des never events de l'ANSM (mise à jour 18.09.2025), sans dose et loin des exemples. Confirmer la formulation.

### Variantes
11. **2009** : UE 2.11 et UE 4.4 vérifiées dans l'annexe III de l'arrêté de 2009 (numéros, intitulés, semestres). **2026** : aucun numéro d'UE affiché, faute d'avoir pu lire l'annexe III de l'arrêté du 20 février 2026. À compléter par l'orchestrateur quand l'annexe est lue (`donnees/variantes.csv`, ligne FR01-2026, statut `A-VERIFIER`). Hors périmètre de la relectrice.

## Lignes `A-VERIFIER` de `references.csv`
- **RISPAIL_2017** (6 lignes) : ouvrage, édition et table des matières vérifiés en ligne ; pages et contenu à relever livre en main, édition notée par la relectrice.
- **ISO_8536_4, ISO_8536_5, ISO_7886_1** : édition et paragraphe, norme en main.
- **PH_EUR_GN** : numéro du paragraphe dans l'édition en vigueur.
- **HAS_ADM_2011** (2 lignes) : page exacte.
- **EXERCICE** : confirmation de la relectrice (point 9).
- **SRC_IFSI_2009** : rattachement des calculs de doses aux UE 2.11 et 4.4, à lire dans les fiches pédagogiques (numéros et intitulés vérifiés).
- **SRC_IFSI_2026** (2 lignes) : annexe III de l'arrêté du 20 février 2026, UE qui porte les calculs de doses.
- Vérifiées : BIPM_SI_9, ANSM_NEVER_EVENTS (page consultée le 29.10.2026).
