# draft method — pending professional review

**Produit :** EN01-STD « Dosage Calculation & IV Drip Rates » (MindShelf, marché EN/US, NCLEX).
**Statut :** méthode rédigée par l'agent producteur (run R01, 28.10.2026), `methode_auteur = AGENT`, risque IA **FORT**.
**Conséquences :** relecture métier obligatoire avant validation ; produit **Whop uniquement**, jamais sur Etsy (décision D04), y compris après relecture, tant que la méthode n'est pas réécrite ou reprise par Tristan.

Cette mention ne figure pas dans le PDF ; elle accompagne la source jusqu'à la relecture.

## Ce que la relecture doit confirmer

Les numéros renvoient aux sections de la fiche. Les lignes `A-VERIFIER` de `references.csv` sont listées à la fin.

### Arrondis et valeurs réglables (priorité sécurité)
1. **Précision de pompe** : la fiche arrondit les mL/h au dixième (`valeurs.csv` `pompe_pas` = 0.1, colonne `arrondi` = 1) et signale que certaines pompes ne prennent que le mL/h entier. À confirmer pour le public visé (pompes des terrains de stage US, convention des manuels NCLEX). Exemples concernés : EX04A (125 mL/h), EX08B (15 mL/h), EX09C (12.96 ⇒ 13 mL/h).
2. **Gouttes** : gtt/min arrondies à l'entier (EX04B : 41.67 ⇒ 42). Confirmer l'arrondi au plus proche (et non par défaut).
3. **Seringues** : volume < 1 mL au centième dans une seringue de 1 mL (EX01 : 0.875 ⇒ 0.88 mL) ; volume dans une seringue de 3 mL au dixième (EX07B : 1.5 mL). Confirmer les graduations (1 mL : 0.01 mL ; 3 mL : 0.1 mL) et la règle de cours.
4. **Poids** : kg au dixième (EX02A : 19.958 ⇒ 20 kg). La fiche montre aussi le raccourci de cours ÷ 2.2 (EX02B). Confirmer la convention attendue à l'examen (÷ 2.2, puis arrondi au dixième).
5. **« Round once, at the end »** : vérifier qu'aucun manuel de référence n'impose un arrondi intermédiaire (ex. concentration) contraire.

### Méthodes
6. **Section 1** : les trois méthodes (D/H × Q, ratio–proportion, analyse dimensionnelle) sont résumées en une ligne chacune. Vérifier que la formulation de la règle de trois (H : Q = D : V) est celle enseignée.
7. **Section 3** : la conduite « hors fourchette : suspendre, joindre le.la prescripteur.rice » (« hold, call the prescriber ») est-elle la formulation attendue ? Fourchette de Drug Y (20–40 mg/kg/jour, toutes les 8 h) fictive.
8. **Section 4** : facteurs de goutte 10, 15, 20 (macrogoutte) et 60 (microgoutte) ; raccourci microgoutte ; heure de fin en horloge de 24 h (09:00 → 16:30). Confirmer l'usage de l'horloge de 24 h dans les cours US (sinon afficher 9:00 AM → 4:30 PM).
9. **Section 5** : Mosteller avec cm et kg ; exemple 150 cm, 54 kg ⇒ 1.5 m² ; Drug Z 100 mg/m² fictif.
10. **Section 6** : étiquette fictive de Drug X (1 g + 4.6 mL ⇒ 5 mL, 200 mg/mL). Définitions : % p/v = g pour 100 mL ; 1:1000 = 1 mg/mL. Faut-il ajouter que les étiquettes US n'utilisent plus le rapport pour les produits à un seul principe actif (USP <7>) ? Non affiché faute de localisation vérifiée.
11. **Section 7** : Drug X 400 mg/250 mL (1,600 mcg/mL), 5 mcg/kg/min, 80 kg ⇒ 15 mL/h ; Drug W 25,000 units/250 mL, 18 units/kg/h, 72 kg ⇒ 12.96 ⇒ 13 mL/h. Ces valeurs ressemblent à des préparations et protocoles réels (dopamine, héparine) mais restent anonymisées en « Drug X/W » : décider s'il faut nommer l'héparine (il faudrait alors citer la notice du prémélange et le protocole source).
12. **Note clinique section 7** : héparine et insuline comme médicaments à haut risque (liste ISMP) et double contrôle « selon la politique de l'établissement ». Confirmer la formulation.

### Notation, droits, prescriptions
13. **Section 9** : tableau de 9 lignes (6 de la liste « Do Not Use » de la Joint Commission, 3 de la liste ISMP). Vérifier les libellés de risque (reformulés).
14. **Section 10** : cinq droits classiques (patient, médicament, dose, voie, moment) ; certains programmes en enseignent davantage (documentation, motif, réponse). Éléments d'une prescription complète à confirmer contre MM.04.01.01.
15. **Notes cliniques** : liquides oraux en mL à la seringue orale (NCPDP, FDA) ; prescription floue à faire préciser (Joint Commission).
16. **Équivalents ménagers** : la colonne « Label & course » reprend les valeurs de la FDA pour l'étiquetage nutritionnel (5, 15, 30, 240 mL). Confirmer qu'elles coïncident avec celles des manuels de calcul de doses (certains donnent 1 cup = 250 mL).

## Lignes `A-VERIFIER` de `references.csv`
- MANUEL_CALCUL_DOSES (méthodes, 2.2 lb/kg, fourchette sûre, facteurs de goutte, reconstitution, arrondis, seringues) : choisir un ouvrage de référence et noter édition et pages.
- NIST_SP811_2008 : présence de l'entrée « cup (U.S.) » dans l'annexe B.8.
- NCPDP_ORAL_2014 et FDA_OTC_DEVICES_2011 : version et section.
- USP_GN : numéro de section « Percentage measurements » et édition.
- ISMP_HIGH_ALERT : année de la version en vigueur ; ISMP_IDC et ISMP_5R_2007 : date et numéro.
- TJC_MM : liste exacte des éléments exigés (EP) de MM.04.01.01.
