# draft method — pending professional review

**Produit :** EN01-STD « Dosage Calculation & IV Drip Rates » (MindShelf, marché EN/US, NCLEX).
**Statut :** méthode rédigée par l'agent producteur (run R01, 28.10.2026), `methode_auteur = AGENT`, risque IA **FORT**. Correction v2 du 28.10.2026 après le rapport du vérificateur (`verif/rapport-v1.md`), puis correction v3 du même jour après la contre-vérification (`verif/rapport-v2.md`).
**Conséquences :** relecture métier obligatoire avant validation ; produit **Whop uniquement**, jamais sur Etsy (décision D04), y compris après relecture, tant que la méthode n'est pas réécrite ou reprise par Tristan.

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE INFIRMIÈRE.** Aucun dépôt Whop (ni envoi du PDF à qui que ce soit) tant que `data/revues.csv` ne contient pas une ligne de relecture métier validée pour EN01-STD. Raison (rapport v1, M3) : le pied de page du PDF affirme « content checked and approved by the seller », ce qui n'est exact qu'après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

Cette mention ne figure pas dans le PDF ; elle accompagne la source jusqu'à la relecture.

## Pour la relectrice

### Fichier et version à relire
- **Fichier :** `livraison/EN01-STD/EN01-STD-a4.pdf` (Letter, N&B et tablette ont le même contenu, seule la mise en page change). Construit le 28.10.2026 à 14:10, après la correction v3.
- **Version :** le pied de page affiche **v1**. C'est la version des entrées de compilation (`data/variantes.csv`, colonne `version` de EN01-STD), pas le numéro de correction (v3). Si l'orchestrateur passe la variante en v2 avant l'envoi (rapport v2, N8), relire le PDF reconstruit qui porte ce numéro. La ligne de `data/revues.csv` reprend la version imprimée en pied de page du PDF relu.

### Périmètre de la relecture (décision D08, Tristan)
- **Ce que la relectrice (infirmière, Suisse) relit :** les calculs, la sécurité clinique, les arrondis et la clarté.
- **Ce qui ne lui est pas demandé comme validation :** les conventions US de la fiche, c'est-à-dire l'horloge (24 h sur la fiche, 12 h AM/PM usuelle aux États-Unis), les pompes, les graduations des seringues, la Joint Commission et l'ISMP. Ces points reposent sur les sources citées dans `references.csv`.
- Elle peut les signaler si quelque chose lui paraît faux, sans être tenue de les vérifier.

### Où consigner les décisions
Chaque décision va dans un champ de table, jamais dans une note en texte.

| Décision | Champ | Valeur actuelle |
|---|---|---|
| Pas de la pompe (point 1) | `valeurs.csv`, clé `pompe_pas` | 0.1 mL/h |
| Arrondi des gouttes (point 2) | Aucun champ pour l'instant : la fiche arrondit au plus proche (`calc.round`, rapport v2, N9). Décision à porter dans la ligne de `data/revues.csv` ; si elle diffère du plus proche, l'orchestrateur crée la clé dans `valeurs.csv` et la fait lire par `main.typ`. | au plus proche |
| Graduations des seringues (point 3) | `valeurs.csv`, clés `seringue_petite_pas` et `seringue_std_pas` (capacités : `seringue_petite`, `seringue_std`) | 0.01 mL (1 mL), 0.1 mL (3 mL) |
| Convention de poids (point 4) | `valeurs.csv`, clé `poids_pas` | 0.1 kg, puis utilisé tel quel |
| Arrondi unique (point 5) | Colonne `arrondi` de `exemples.csv` (décimales de la seule valeur réglée ou prélevée) ; accord ou désaccord dans la ligne de `data/revues.csv` | intermédiaires jamais arrondis |

Validation : une ligne dans `data/revues.csv` (`variante_code` EN01-STD, `version` du pied de page relu, `etape_code` de relecture métier, `acteur`, `statut_code`, `date`, `rapport`), écrite par l'orchestrateur à partir du retour de la relectrice.

### Chapitres de Morris (8e édition)
Morris DC, *Calculate with Confidence*, 8th ed., Elsevier, 2022, ISBN 978-0-323-69695-1. Une 9e édition existe (ISBN 978-0-443-12732-8) : les renvois portent sur la 8e, et la relectrice note l'édition sur laquelle elle vérifie. Chapitres d'après la table des matières en ligne (rapport v2, N7) ; pages à relever livre en main.

| Point de la fiche | Chapitres |
|---|---|
| Trois méthodes (§ 1) | 13–15 |
| lb ↔ kg et poids (§ 2–3) | 7 et 24 |
| Fourchette sûre et conduite hors fourchette (§ 3) | 24 |
| Perfusions et facteurs de goutte (§ 4) | 20–21 |
| Reconstitution (§ 6) | 18, Unit Four « Oral and Parenteral Dosage Forms, Insulin and Pediatric Dosage Calculations » |
| Seringues (§ 8) | 17 |
| Arrondis (§ 8) | 2, 16–17 et 21 |

## Modifications v3 (après `verif/rapport-v2.md`)

| Constat v2 | Ce qui a changé | Où |
|---|---|---|
| N2 | Échos cliniques corrigés : Drug B, E et F ont de nouvelles valeurs (tableau ci-dessous et point 11). | `exemples.csv`, `references.csv` (EXERCICE) |
| N3 | Titre de l'encadré du § 8 : « Round only what you record, set or draw up » (était « Round once, at the end », que contredisait la puce sur le poids). | `src/main.typ` |
| N4 | Unités composées insécables dans les quatre formats : un gluon (U+2060) suit chaque « / » entre deux lettres (mg/day, mL/h, mcg/kg/min, mg/m²…). Contrôle : aucune ligne du texte des 4 PDF ne finit par « / ». | `src/main.typ` |
| N5 | « exercise values » dans le titre des exemples Drug C, D, E et F (la mention complète reste en tête de fiche). Le titre de Drug D perd « fictional label ». | `src/main.typ` |
| N6 | Encadré des règles d'arrondi non sécable : il ouvre la page 3 de la tablette, entier. | `src/main.typ` |
| N7 | Unit Four de Morris en intitulé complet, chapitres reportés, 9e édition signalée. | `references.csv` (7 lignes MORRIS_2022), ce fichier |
| N1 | Périmètre de la relecture écrit ci-dessus (décision D08). | ce fichier |
| N8, N9, N10 | Non traités ici : version de la variante (`data/`, orchestrateur), champ d'arrondi des gouttes (voir tableau des décisions), texte de vente (point 17). | — |

## Modifications v2

| Constat v1 | Ce qui a changé | Où |
|---|---|---|
| B1 | Toutes les valeurs des exemples médicamenteux remplacées par des valeurs d'exercice sans équivalent dans une préparation ou un protocole courant (voir tableau ci-dessous). Ligne en tête de fiche : « Drugs A–F and their numbers: exercise values, not dosing guidance. » La note héparine/insuline est détachée des exemples (déplacée en section 10, sans dose). | `exemples.csv`, `src/main.typ`, `references.csv` (EXERCICE, ISMP_HIGH_ALERT) |
| B2 | Un nom par préparation : Drug A (injection), B (fourchette au poids), C (dose à la surface), D (poudre reconstituée), E (perfusion en mcg/kg/min), F (perfusion en units/h). Le même nom n'est repris que dans un enchaînement voulu (EX07A → B, EX08A → B, EX09A → C). | `exemples.csv`, `src/main.typ` |
| M1 | Règle d'arrondi unique : le poids est consigné au dixième de kg puis utilisé tel quel ; concentrations et résultats intermédiaires ne sont jamais arrondis ; seule la valeur réglée ou prélevée est arrondie. EX08B utilise un poids consigné non rond (76.4 kg), EX09B garde l'intermédiaire exact (608 units/h). Piège : « Rounding a concentration or intermediate early shifts the final rate. » | `src/main.typ` § 2 et § 8, `valeurs.csv` (`poids_pas`), `cartes.csv`, `references.csv` |
| M2 | Source générique `MANUEL_CALCUL_DOSES` remplacée par `MORRIS_2022` (Morris DC, *Calculate with Confidence*, 8th ed., Elsevier, 2022, ISBN 978-0-323-69695-1), localisée par unité ; chapitres et pages restent à relever livre en main. | `references.csv` (7 lignes) |
| M3 | Rien dans le PDF ; blocage de publication écrit ci-dessus. | ce fichier |
| m1 | « cc » : risque « Read as u (units) » (le « 00 » ne figure pas dans la liste ISMP). | `notation.csv`, `cartes.csv` |
| m2, m3, m4, m5 | ISMP_ABBR © 2024 ; Joint Commission MM.14.01.01 (Accreditation 360, 1.1.2026 ; ancien MM.04.01.01) et IM.13.01.01 ; USP 8.140 « Percentage Concentrations » ; livre exacte par la définition de 1959 (NIST HB 44, App. C), B.8 l'arrondissant à 7 chiffres. | `references.csv` |
| m6 | Piège § 3 : « compare per day or per dose, like with like ». | `src/main.typ`, `cartes.csv` |
| m7 | En-tête du tableau ménager : « NIST (exact, rounded) ». | `src/main.typ` |
| m8 | Piège § 5 : commence par « Mosteller's 3,600 … ». En v2 (A4), l'exemple BSA et le piège ouvrent ensemble la colonne 2 ; le titre et la formule de la section restent en bas de la colonne 1. | `src/main.typ` |
| m9 | « Ratio 1:1,000 » : le « 1 » vient de `C02.G`. | `src/main.typ` |

Pour tenir sur une page : « need system safeguards, not just a checklist » est raccourci en « need system safeguards » (§ 10) ; les deux notes cliniques de fin sont fusionnées.

### Valeurs d'exercice (v1 → v2 → v3)

| Exemple | v1 | v2 | v3 (à relire) |
|---|---|---|---|
| EX01 (Drug A) | 35 mg ; 40 mg/mL ⇒ 0.88 mL | 28 mg ; 32 mg/mL ⇒ 0.875 ⇒ 0.88 mL | inchangé |
| EX03 (Drug B) | 20–40 mg/kg/jour ; 150 mg toutes les 8 h | 17–33 mg/kg/jour toutes les 8 h ; 165 mg ⇒ 495 mg/jour | 36–48 mg/kg/jour ; 20 kg ⇒ 720–960 mg/jour ; 210 mg toutes les 6 h ⇒ 840 mg/jour |
| EX06B (Drug C) | 100 mg/m² ⇒ 150 mg | 92 mg/m² ; 1.5 m² ⇒ 138 mg | inchangé |
| EX07 (Drug D) | 1 g + 4.6 mL ⇒ 5 mL ; 300 mg ⇒ 1.5 mL | 1.4 g + 6.2 mL ⇒ 7 mL (200 mg/mL) ; 320 mg ⇒ 1.6 mL | inchangé |
| EX08 (Drug E) | 400 mg/250 mL ; 5 mcg/kg/min ; 80 kg ⇒ 15 mL/h | 360 mg/300 mL ; 4.5 mcg/kg/min ; 76.4 kg ⇒ 17.2 mL/h | 330 mg/300 mL (1,100 mcg/mL) ; 4.5 mcg/kg/min ; 76.4 kg ⇒ 18.753 ⇒ 18.8 mL/h |
| EX09 (Drug F) | 25,000 units/250 mL ; 18 units/kg/h ; 72 kg ⇒ 13 mL/h | 30,000 units/400 mL ; 9.5 units/kg/h ; 64 kg ⇒ 8.1 mL/h | 48,000 units/200 mL (240 units/mL) ; 140 units/kg/h ; 64 kg ⇒ 8,960 units/h ⇒ 37.333 ⇒ 37.3 mL/h |

## Ce que la relecture doit confirmer

Les numéros de section renvoient à la fiche (correction v3).

### Arrondis et valeurs réglables (priorité sécurité)
1. **Précision de pompe** : mL/h au dixième (`valeurs.csv` `pompe_pas` = 0.1, colonne `arrondi` = 1) ; la fiche signale que certaines pompes ne prennent que le mL/h entier. À confirmer pour le public visé. Exemples : EX04A (125 mL/h), EX08B (18.753 ⇒ 18.8 mL/h), EX09C (37.333 ⇒ 37.3 mL/h). Reporter la décision dans `valeurs.csv` (`pompe_pas`), pas dans une note.
2. **Gouttes** : gtt/min arrondies à l'entier le plus proche (EX04B : 41.67 ⇒ 42). Confirmer « au plus proche » (et non par défaut).
3. **Seringues** : seringue de 1 mL graduée au 0.01 mL (EX01 : 0.875 ⇒ 0.88 mL) ; seringue de 3 mL au 0.1 mL (EX07B : 1.6 mL). Confirmer les graduations et la règle de cours.
4. **Poids (règle v2)** : consigné au dixième de kg, puis utilisé tel quel (EX02A : 19.958 ⇒ 20 kg consigné ; EX08B : 76.4 kg utilisé sans arrondi). Raccourci de cours ÷ 2.2 montré (EX02B). Confirmer la convention attendue à l'examen ; reporter la décision dans `valeurs.csv` (`poids_pas`).
5. **Arrondi unique (règle v2)** : concentrations et résultats intermédiaires jamais arrondis, seule la valeur réglée ou prélevée l'est. Vérifier qu'aucun manuel de référence (Morris 2022) n'impose un arrondi intermédiaire contraire.

### Méthodes
6. **Section 1** : les trois méthodes (D/H × Q, ratio–proportion, analyse dimensionnelle) en une ligne chacune. Vérifier la formulation de la règle de trois (H : Q = D : V).
7. **Section 3** : conduite hors fourchette « hold, call the prescriber ». Fourchette fictive de Drug B (36–48 mg/kg/jour, toutes les 6 h ; v3). Piège reformulé : comparer par jour ou par prise, à grandeur égale.
8. **Section 4** : facteurs de goutte 10, 15, 20 (macrogoutte) et 60 (microgoutte) ; raccourci microgoutte ; heure de fin en horloge de 24 h (09:00 → 16:30). Confirmer l'usage de l'horloge de 24 h dans les cours US (sinon afficher 9:00 AM → 4:30 PM).
9. **Section 5** : Mosteller avec cm et kg ; 150 cm, 54 kg ⇒ 1.5 m² ; Drug C 92 mg/m² fictif.
10. **Section 6** : étiquette fictive de Drug D (1.4 g + 6.2 mL ⇒ 7 mL, 200 mg/mL). Définitions : % p/v = g pour 100 mL ; 1:1000 = 1 mg/mL. Faut-il ajouter « (older labels; current US labels state mg/mL) », USP <7> ? Non affiché faute de localisation vérifiée (rapport v1, m10).
11. **Échos cliniques (règle 11)**. Trois échos relevés par le vérificateur (rapport v2, N2) ont été corrigés en v3 :
    - Drug E : 360 mg rappelait le prémélange d'amiodarone (Nexterone 360 mg/200 mL) et sa charge de 6 h. Nouvelle valeur 330 mg/300 mL (1,100 mcg/mL) : aucune préparation en 330 mg ni à 1.1 mg/mL connue pour une perfusion titrée (recherche web du 28.10.2026 sans résultat ; dopamine 800/1,600/3,200 et dobutamine 1,000/2,000/4,000 mcg/mL restent distinctes ; amiodarone 1.8 mg/mL). La dose de 4.5 mcg/kg/min, inchangée, reste dans l'ordre de grandeur des inotropes, sans protocole égal.
    - Drug F : 9.5 units/kg/h tombait dans la zone des débits d'héparine (environ 10 à 28 units/kg/h, adulte et pédiatrie). Nouvelle valeur 140 units/kg/h (48,000 units/200 mL, 240 units/mL) : hors de l'insuline IV (environ 0.02–0.2 units/kg/h, jusqu'à 10 units/kg/h en insuline à haute dose de toxicologie), de l'héparine y compris en ECMO néonatale (jusqu'à 50–70 units/kg/h environ), des facteurs de coagulation en perfusion continue (quelques units/kg/h) et de l'urokinase (4,400 units/kg/h). Recherche web du 28.10.2026 sans protocole à 140 units/kg/h. Valeur volontairement hors des ordres de grandeur cliniques : la relectrice dit si elle gêne la lecture.
    - Drug B : 17–33 mg/kg/jour toutes les 8 h rappelait l'ancienne fourchette de l'amoxicilline (20–40 mg/kg/jour toutes les 8 h). Nouvelle valeur 36–48 mg/kg/jour toutes les 6 h : égale à aucune fourchette pédiatrique connue (recherche web du 28.10.2026 sans résultat), mais comprise, comme toute fourchette de cet ordre, dans l'étendue de plusieurs antibiotiques oraux donnés toutes les 6 h (céfalexine 25–50, érythromycine 30–50 mg/kg/jour).
    Confirmer qu'aucune valeur de Drug A à F n'évoque un protocole réel connu des étudiant.e.s.
12. **Note clinique section 10** : héparine IV et insuline comme médicaments à haut risque (liste ISMP 2024), double contrôle indépendant « per policy », sans dose. Confirmer la formulation et la place (détachée des exemples).

### Notation, droits, prescriptions
13. **Section 9** : tableau de 9 lignes (6 de la liste « Do Not Use » de la Joint Commission, 3 de la liste ISMP © 2024). Vérifier les libellés de risque (reformulés), dont « cc : Read as u (units) ».
14. **Section 10** : cinq droits classiques (patient, médicament, dose, voie, moment) ; certains programmes en enseignent davantage. Éléments d'une prescription complète à confirmer contre MM.14.01.01 (manuel 2026).
15. **Notes cliniques** : liquides oraux en mL à la seringue orale (NCPDP, FDA) ; prescription floue à faire préciser (Joint Commission).
16. **Équivalents ménagers** : la colonne « Label & course » reprend les valeurs FDA d'étiquetage (5, 15, 30, 240 mL). Confirmer qu'elles coïncident avec celles de Morris 2022 (certains manuels donnent 1 cup = 250 mL).

### Avant publication (hors relecture)
17. Le texte de la fiche Whop existante (`brief-whop.md`) annonce « heparin units/h » : à remplacer par « units/kg/h ↔ mL/h » lors du dépôt, la fiche ne dosant plus aucun médicament réel.
18. La version affichée en pied de page vient de `data/variantes.csv` (v1) : à passer en v2 par l'orchestrateur si cette correction doit être versionnée.

## Lignes `A-VERIFIER` de `references.csv` (état v3)
- **MORRIS_2022** (7 lignes : méthodes, 2.2 lb/kg, fourchette sûre, facteurs de goutte, reconstitution, arrondis, seringues) : ouvrage, édition et unités vérifiés ; chapitres reportés en v3 (table des matières en ligne) ; pages et contenu à relever livre en main, édition notée par la relectrice (8e ou 9e).
- **EXERCICE** : valeurs Drug A à F, à confirmer par la relectrice (point 11).
- **NIST_SP811_2008 / lb** : valeur exacte par la définition de 1959 (NIST HB 44, App. C) ; édition de HB 44 à préciser. Entrée « cup (U.S.) » de B.8 : levée.
- **FDA_OTC_DEVICES_2011** : numéro et intitulé de la section des recommandations (m11, ouvert).
- **USP_GN** : 8.140 « Percentage Concentrations » confirmé sur USP 35–NF 30 ; intitulé dans l'édition en vigueur à confirmer.
- **TJC_MM** (2 lignes) : MM.14.01.01 (Accreditation 360, 1.1.2026) ; libellé et liste exacte des EP à lire dans le manuel 2026.
- **TJC_DNU** : localisation IM.13.01.01 à confirmer ; la liste « Do Not Use » elle-même n'est pas en cause.
- Levées en v2 (d'après le rapport v1) : ISMP_HIGH_ALERT (2024), ISMP_IDC (6.6.2019, vol. 24), ISMP_5R_2007 (25.1.2007), NCPDP_ORAL_2014 (v1.0, mars 2014).
