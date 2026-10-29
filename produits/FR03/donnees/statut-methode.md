# Relecture médicale en attente

**Produit :** FR03 « Bilan biologique — valeurs usuelles françaises » (marque Clairance, marché FR, étudiant.e.s en IFSI), variantes **FR03-2009** et **FR03-2026**, 1 page.
**Statut :** rédigé par l'agent producteur (run R05, 29.10.2026), `methode_auteur = AGENT`, risque IA **FAIBLE** (Whop et Etsy). Adapté de EN08 v2 (pas une traduction). **v1 revue par le vérificateur indépendant** (`verif/rapport-v1.md` : À corriger, 1 bloquant, 4 majeurs, 11 mineurs), **puis corrigée (correction v2, même run)**. La correction v2 n'a pas encore été revue par le vérificateur. **Rien n'a encore été vu par la relectrice.**

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE MÉDICALE.** Aucun dépôt Whop ni Etsy, ni envoi du PDF à qui que ce soit, tant que `data/revues.csv` ne contient pas, pour chaque variante (FR03-2009 et FR03-2026), une ligne `etape_code = RELECTURE_METIER` de la médecin stagiaire (`data/produit_relecteurs.csv` : FR03 → MEDECIN_STAGIAIRE) avec `statut_code = A_VALIDER` (relecture faite, en attente de la VALIDATION par Tristan) ; `A_CORRIGER` si elle demande des corrections. Raison : le pied de page affirme « contenu vérifié et validé par le vendeur », exact seulement après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

## Pour la relectrice

### Ce qu'on lui envoie
- **Fichier à relire :** `livraison/FR03-2026/FR03-2026-a4.pdf`. FR03-2009 a exactement le même contenu ; seule la ligne d'UE en tête change (les deux lignes sont citées plus bas, à valider aussi).
- **Version :** correction v2 du contenu. Le pied de page affiche encore « v1 » : le numéro vient de `data/produits.csv` (hors du périmètre du producteur), à passer en v2 par l'orchestrateur avant l'envoi.

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
| Seuil d'hyperkaliémie | `donnees/valeurs.csv`, clé `k_hyperkaliemie` |
| Nom, date ou année d'une source (encadré de tête, ligne Sources) | `donnees/sources.csv` |
| Texte d'un piège, d'une note ou de l'encadré DFG | `src/main.typ`, et la ligne correspondante de `donnees/references.csv` |
| Ligne d'UE d'une variante | `donnees/variantes.csv` |
| Une carte Anki | `donnees/cartes.csv`, colonne `verso` (ne pas changer le `recto`) |

## Sources
- **Valeurs usuelles (32 lignes) :** Conseil scientifique des concours de l'internat en pharmacie, « Valeurs biologiques usuelles », V8 du 19.11.2009, diffusé par le CNG (`CNG_VBU_2009`). Liste nationale française, adulte, unités SI, avec le milieu de prélèvement et, pour certains examens, une seconde unité. Page de chaque ligne : `examens.csv`, colonne `localisation`. Relevé du producteur et relevé indépendant du vérificateur (tous deux par lecture web du PDF, téléchargement direct refusé par le proxy) : 32 lignes concordantes. **L'année (2009) et le nom de la source sont affichés dans l'encadré de tête** (lus dans `sources.csv`), avec « le compte rendu du laboratoire fait foi ».
- **Cibles INR sous AVK et risques hors cible :** VIDAL Recos « AVK (traitement par) », mise à jour du 21.10.2025 (synthèse ANSM, HAS, sociétés savantes) : tableau « Traitement préventif » et Conseils aux patients (« Un INR trop bas traduit un effet anticoagulant insuffisant, avec un risque de thrombose » ; « Un INR trop élevé traduit un surdosage, avec un risque hémorragique »).
- **Seuil d'hyperkaliémie :** VIDAL Actualités, Hoppenot I., « L'hyperkaliémie, une origine médicamenteuse fréquente », 10.05.2022 : « potassium plasmatique supérieur à 5,5 mmol/L » (ajout v2).
- **DFG estimé :** VIDAL, Flamant M., 20.10.2022 (créatininémie, CKD-EPI, mL/min/1,73 m²) ; La Revue du Praticien, stades de la maladie rénale chronique, 15.04.2022. « Recommandée par la HAS » est retiré de la fiche (texte HAS 2011 non lisible dans sa phrase de recommandation).
- **Définitions :** 1 min = 60 s et fraction × 100 sont présentées comme des définitions (`source_code = DEFINITION`), sans document cité.
- **Hémolyse et kaliémie :** La Revue du Praticien, « Hyperkaliémie modérée en ville », mars 2026 (partie publique).
- **Calculs :** 3 exemples dans `exemples.csv`, recalculés à chaque compilation et par le script du vérificateur (relancé sur la v2 : 0 écart).
- **Droits :** valeurs factuelles ; tableau propre (sélection, regroupement, colonnes et libellés reformulés), aucune phrase reprise.

## Points à confirmer (A-VERIFIER)

### Valeurs
1. **Relevé CNG 2009.** Confronté par le vérificateur (32 lignes concordantes, lecture web aussi). Un sondage sur le PDF original suffit, en particulier sur les valeurs plus étroites que beaucoup de comptes rendus actuels : **kaliémie 3,5–4,5 mmol/L**, chlorure 95–105, bicarbonates 23–27, albumine 38–48 g/L, protéines 65–80 g/L.
2. **Âge de la source (2009).** Désormais affiché en tête (« liste nationale de l'adulte publiée en 2009… ; le compte rendu du laboratoire fait foi ») et dans la note sous le tableau (« Valeurs de 2009, indicatives »). Garder cette source ainsi affichée, ou la remplacer par celle d'un laboratoire de CHU plus récente ? Le vérificateur n'a trouvé aucune source française récente du même type, gratuite et lisible.
3. **Équivalences arrondies de la source.** Confirmées par le vérificateur : 2,30 mL/s s'y écrit 140 mL/min (calcul : 138), 5,50 mmol/L de glucose y correspond à 1,00 g/L (calcul : 0,99 g/L). Les 16 autres paires concordent. La fiche le dit (« équivalence arrondie »). Garder ainsi ?
4. **Glucose « à jeun ».** La source écrit « Glucose » (plasma) sans « à jeun ». **Non ajouté en v2** : aucune source lisible et fiable trouvée qui écrive « à jeun » pour cet intervalle (les pages trouvées donnent 0,70–1,10 g/L, autre intervalle). Risque : une glycémie capillaire post-prandiale lue comme anormale. Ajouter « à jeun » (avec sa source) ?
5. **Absents de la source, donc absents de la fiche :** calcium ionisé, magnésium, phosphatases alcalines, INR sans traitement, D-dimères, troponine. Pour les ajouter, une source qui les écrit est nécessaire.

### Interprétation (périmètre de la médecin stagiaire)
6. **INR sous AVK (texte corrigé en v2, bloquant B1 du vérificateur : à relire en priorité).** Texte de la note : « La cible est fixée par le.la prescripteur.rice selon l'indication : 2 à 3 le plus souvent, 3 à 4,5 pour certaines atteintes valvulaires (prothèse mécanique mitrale notamment). **Au-dessus de la cible** : surdosage, risque hémorragique. **Au-dessous de la cible** : effet anticoagulant insuffisant, risque de thrombose. Dans les deux cas, signaler selon le protocole. » Même contenu sur la carte Anki « INR sous AVK : qui fixe la cible ? ». Les deux risques sont écrits par VIDAL Recos. « Fixée par le.la prescripteur.rice » est déduit (cibles différentes selon l'indication, « carnet de suivi mentionnant l'INR cible ») ; « certaines atteintes valvulaires » résume les trois lignes VIDAL à 3–4,5 (valvulopathie mitrale avec dilatation de l'oreillette gauche, contraste ou thrombus ; prothèse mécanique mitrale ; prothèse mécanique aortique avec autre facteur de risque ou de 1re génération). Les deux lignes restent dans un groupe à part du tableau, jamais présentées comme des valeurs usuelles.
7. **Kaliémie élevée et hémolyse (texte corrigé en v2).** Texte de la note : « Kaliémie élevée = au-dessus de l'intervalle du compte rendu du laboratoire. Par prudence, **la signaler d'abord**, selon le protocole du service. L'hyperkaliémie se définit par un potassium plasmatique > 5,5 mmol/L. Une hémolyse du prélèvement peut donner une fausse hyperkaliémie : un nouveau prélèvement de contrôle, sans garrot, peut être prescrit. Ce contrôle ne retarde pas le signalement. » Sourcés : seuil de 5,5 (VIDAL 2022), fausse hyperkaliémie par hémolyse et contrôle sans garrot (Rev Prat 2026, médecine de ville). **Non sourcé, présenté comme consigne de prudence :** « la signaler d'abord » et « ne retarde pas le signalement » (la source décrit la démarche du médecin, qui commence par rechercher l'hémolyse). À confirmer, reformuler ou retirer. Noter aussi l'écart entre l'intervalle CNG (3,5–4,5) et l'intervalle donné par VIDAL 2022 (« normalement entre 3,5 et 5,5 ») : la note définit « élevée » par le compte rendu pour cette raison.
8. **Consignes « selon le protocole ».** Deux occurrences (kaliémie, INR) : génériques, absentes des sources, cohérentes avec la mention AVERT_CLINIQUE. À valider ou retirer.
9. **DFG estimé.** « DFGe < 60 pendant plus de 3 mois : MRC de stade 3 ou plus » ; « DFGe ≥ 90 : DFG normal ou augmenté (stade 1 si marqueurs d'atteinte rénale) ». La source écrit « > 90 » pour le stade 1 et « entre 60 et 89 » pour le stade 2 : « ≥ 90 » place 90 dans un stade (KDIGO 2012 l'écrit ainsi, non lu dans ce run). « Recommandée par la HAS » a été retiré. À valider.
10. **Piège « TP, INR, TCA ».** « Ne pas comparer un TP à une cible d'INR » : règle de lecture, sans source. À valider ou retirer.

### Variantes
11. **FR03-2009 :** « UE 2.1 Biologie fondamentale (S1) et UE 4.4 Thérapeutiques et contribution au diagnostic médical (S2, S4, S5) ». Numéros, intitulés et semestres lus dans l'annexe III (copie AP-HP) ; le rattachement des valeurs biologiques à ces UE est un choix par intitulé (fiches pédagogiques non lues).
12. **FR03-2026 :** « UE B.1 Sciences biomédicales (S1, S2) et UE B.3 Pratiques et interventions infirmières (examens biologiques en S1, prélèvement veineux en S2) », d'après l'offre de formation de l'Université de Bourgogne Europe (CFVU du 16.06.2026), confirmée par le vérificateur (pages ±1) : d'où la mention « selon l'offre de formation publiée par l'Université de Bourgogne Europe ». L'annexe III de l'arrêté de 2026 n'a pas été consultée. Date de l'arrêté : **20 février 2026** (NOR ESRS2601184A, JORF du 25.02.2026, texte 53), confirmée par le vérificateur ; le « 2 février » du titre du document UBE est une coquille. Les PDF ne citent aucune date d'arrêté.

### Hors périmètre du producteur (pour l'orchestrateur et Tristan)
13. **Titre** : « normes françaises » devient « valeurs usuelles françaises » (proposition du vérificateur, m11), appliqué par défaut par l'orchestrateur ; à confirmer par Tristan.
14. **Pied commun** (`data/mentions.csv`) : apostrophe droite dans « l'avis d'un.e » (m8).
15. **Numéro de version** du pied : à passer en v2 (`data/produits.csv`).
16. **Rectos Anki** : apostrophes droites laissées telles quelles (le recto fixe l'identifiant de la carte) ; versos en apostrophes typographiques.
