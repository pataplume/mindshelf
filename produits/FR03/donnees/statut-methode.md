# Relecture médicale en attente

**Produit :** FR03 « Bilan biologique — normes françaises » (marque Clairance, marché FR, étudiant.e.s en IFSI), variantes **FR03-2009** et **FR03-2026**, 1 page.
**Statut :** rédigé par l'agent producteur (run R05, 29.10.2026), `methode_auteur = AGENT`, risque IA **FAIBLE** (Whop et Etsy). Adapté de EN08 v2 et de ses rapports de vérification (pas une traduction). **Rien n'a encore été revu ni par le vérificateur ni par la relectrice.**

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE MÉDICALE.** Aucun dépôt Whop ni Etsy, ni envoi du PDF à qui que ce soit, tant que `data/revues.csv` ne contient pas, pour chaque variante (FR03-2009 et FR03-2026), une ligne `etape_code = RELECTURE_METIER` de la médecin stagiaire (`data/produit_relecteurs.csv` : FR03 → MEDECIN_STAGIAIRE) avec `statut_code = A_VALIDER` (relecture faite, en attente de la VALIDATION par Tristan) ; `A_CORRIGER` si elle demande des corrections. Raison : le pied de page affirme « contenu vérifié et validé par le vendeur », exact seulement après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

## Pour la relectrice

### Ce qu'on lui envoie
- **Fichier à relire :** `livraison/FR03-2026/FR03-2026-a4.pdf`. FR03-2009 a exactement le même contenu ; seule la ligne d'UE en tête change (les deux lignes sont citées plus bas, à valider aussi).
- **Version :** v1 (pied de page).

### Comment elle travaille
Elle n'ouvre aucun CSV et ne lance aucun script. Elle annote le PDF (commentaires PDF, ou PDF imprimé, annoté puis photographié). Pour chaque annotation : la ligne visée (nom de l'examen ou titre de l'encadré), la décision (garder, corriger avec la nouvelle valeur ou formulation, retirer) et, si possible, la source de sa correction (document, édition, page).

### Ce que fait l'orchestrateur ensuite
Il reporte chaque décision dans le champ indiqué, relance `python3 scripts/build.py FR03-2009` et `FR03-2026` (la compilation échoue si une valeur reportée contredit une autre table), puis le conditionnement, et écrit les lignes de `data/revues.csv`.

| Décision de la relectrice | Champ à modifier |
|---|---|
| Une borne, un milieu, un libellé d'examen | `donnees/examens.csv` (`bas`, `haut`, `autre_bas`, `autre_haut`, `milieu`, `examen`), et `localisation` si la source change |
| Une ligne à retirer ou à ajouter | `donnees/examens.csv` (groupes : `donnees/groupes.csv`) |
| Cibles INR | `donnees/examens.csv`, lignes `INR_AVK` et `INR_VALVE` |
| Seuils du DFG estimé | `donnees/valeurs.csv`, clés `dfg_*` et `mrc_mois` |
| Texte d'un piège, d'une note ou de l'encadré DFG | `src/main.typ`, et la ligne correspondante de `donnees/references.csv` |
| Ligne d'UE d'une variante | `donnees/variantes.csv` |
| Une carte Anki | `donnees/cartes.csv`, colonne `verso` (ne pas changer le `recto`) |

## Sources
- **Valeurs usuelles (32 lignes) :** Conseil scientifique des concours de l'internat en pharmacie, « Valeurs biologiques usuelles », V8 du 19.11.2009, diffusé par le CNG (`CNG_VBU_2009`). Référentiel national français, adulte, unités SI, avec le milieu de prélèvement et, pour certains examens, une seconde unité. Page de chaque ligne : `examens.csv`, colonne `localisation`. Relevé fait par un outil de lecture web du PDF (le téléchargement direct est refusé par le proxy), avec un contrôle ponctuel mot pour mot de K, Cl, bicarbonates et HbA1c.
- **Cibles INR sous AVK :** VIDAL Recos « AVK (traitement par) », mise à jour du 21.10.2025 (synthèse ANSM, HAS, sociétés savantes).
- **DFG estimé :** VIDAL, Flamant M., 20.10.2022 (créatininémie, CKD-EPI, mL/min/1,73 m²) ; La Revue du Praticien, stades de la maladie rénale chronique, 15.04.2022.
- **Hémolyse et kaliémie :** La Revue du Praticien, « Hyperkaliémie modérée en ville », mars 2026 (partie publique).
- **Calculs :** 3 exemples dans `exemples.csv`, recalculés à chaque compilation et par un script indépendant ; 0 écart.
- **Droits :** valeurs factuelles ; tableau propre (sélection, regroupement, colonnes et libellés reformulés), aucune phrase reprise.

## Points à confirmer (A-VERIFIER)

### Valeurs
1. **Relevé CNG 2009.** Sonder quelques lignes sur le PDF original (pages dans `examens.csv`), en particulier celles qui diffèrent des valeurs souvent enseignées : **kaliémie 3,5–4,5 mmol/L** (beaucoup de laboratoires impriment une borne haute plus élevée), chlorure 95–105, bicarbonates 23–27, albumine 38–48 g/L, protéines 65–80 g/L.
2. **Âge de la source (2009).** Garder ce référentiel national, assumé par l'avertissement « les valeurs varient selon les laboratoires », ou le remplacer par le référentiel d'un laboratoire de CHU plus récent ?
3. **Équivalences arrondies de la source.** La colonne « Autre écriture » reprend les secondes unités de la source, qui sont arrondies : 2,30 mL/s s'y écrit 140 mL/min (calcul : 138), 5,50 mmol/L de glucose y correspond à 1,00 g/L (calcul : 0,99 g/L). Les autres paires concordent au chiffre affiché (script de recalcul). La fiche le dit (« équivalence arrondie »). Garder ainsi ?
4. **Glucose.** La source écrit « Glucose » (plasma) sans préciser « à jeun ». La fiche ne l'ajoute pas. Faut-il le préciser (avec une source) ?
5. **Absents de la source, donc absents de la fiche :** calcium ionisé, magnésium, phosphatases alcalines, INR sans traitement, D-dimères, troponine. Pour les ajouter, une source qui les écrit est nécessaire.

### Interprétation (périmètre de la médecin stagiaire)
6. **Cibles INR.** « Fixée par le prescripteur selon l'indication » : déduit des cibles différentes selon l'indication dans VIDAL Recos ; la page ne l'écrit pas mot pour mot. « 3 à 4,5 pour certaines valves mécaniques » résume les lignes « prothèse mécanique mitrale » et « aortique avec facteur de risque embolique ». Les deux lignes sont dans un groupe à part, titré « cible fixée par le prescripteur », jamais présentées comme des valeurs usuelles.
7. **Kaliémie élevée et hémolyse.** La note commence par « Signaler d'abord, selon le protocole du service » et finit par « Il ne retarde pas le signalement ». La fausse hyperkaliémie par hémolyse et le contrôle sans garrot sont sourcés (Rev Prat, médecine de ville) ; l'ordre « signaler d'abord » est une consigne de sécurité absente de la source (reprise de EN08 v2, rapport R03 B2). À valider.
8. **Consignes « selon le protocole ».** Deux occurrences (kaliémie, INR) : génériques, absentes des sources, cohérentes avec la mention AVERT_CLINIQUE. À valider ou retirer.
9. **DFG estimé.** « DFGe < 60 pendant plus de 3 mois : MRC de stade 3 ou plus » ; « au-dessus de 90 : DFG normal ou augmenté (stade 1 si marqueurs d'atteinte rénale) ». La recommandation HAS d'origine sur CKD-EPI n'a pas été lue (seulement citée par VIDAL).
10. **Piège « TP, INR, TCA ».** « Ne pas comparer un TP à une cible d'INR » : règle de lecture, sans source. À valider ou retirer.

### Variantes
11. **FR03-2009 :** « UE 2.1 Biologie fondamentale (S1) et UE 4.4 Thérapeutiques et contribution au diagnostic médical (S2, S4, S5) ». Numéros, intitulés et semestres lus dans l'annexe III (copie AP-HP) ; le rattachement des valeurs biologiques à ces UE est un choix par intitulé (fiches pédagogiques non lues).
12. **FR03-2026 :** « UE B.1 Sciences biomédicales (S1, S2) et UE B.3 Pratiques et interventions infirmières (examens biologiques en S1, prélèvement veineux en S2) », d'après l'offre de formation de l'Université de Bourgogne Europe (CFVU du 16.06.2026), la seule source lue : d'où la mention « selon l'offre de formation publiée par l'Université de Bourgogne Europe ». L'annexe III de l'arrêté de 2026 n'a pas été consultée. Le document UBE se réfère à un « arrêté du 2 février 2026 », alors que FR01 cite l'arrêté du 20 février 2026 (JORF du 25.02.2026) : date à confirmer.
