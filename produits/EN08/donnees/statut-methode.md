# Relecture médicale en attente

**Produit :** EN08-STD « Lab Values Cheat Sheet » (MindShelf, marché EN/US, étudiant.e.s infirmier.ère.s, NCLEX), référentiel AUCUN, 1 page.
**Statut :** rédigé par l'agent producteur (run R03, 29.10.2026), `methode_auteur = AGENT`, risque IA **FAIBLE** (Whop et Etsy). Vérification indépendante v1 : « À corriger » (`verif/rapport-v1.md`, 2 bloquants, 7 majeurs, 11 mineurs). Correction v2 faite par le producteur le même jour (liste plus bas). **La v2 n'a été revue ni par le vérificateur ni par la relectrice.**

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE MÉDICALE.** Aucun dépôt Whop ni Etsy (ni envoi du PDF à qui que ce soit) tant que `data/revues.csv` ne contient pas, pour EN08-STD, une ligne `etape_code = RELECTURE_METIER` de la médecin stagiaire (`data/produit_relecteurs.csv` : EN08 → MEDECIN_STAGIAIRE) avec `statut_code = A_VALIDER` (relecture faite, en attente de l'étape VALIDATION par Tristan). Si elle demande des corrections : `statut_code = A_CORRIGER`. Raison : le pied de page affirme « content checked and approved by the seller », exact seulement après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

## Pour la relectrice

### Ce qu'on lui envoie
- **Fichier à relire :** `livraison/EN08-STD/EN08-STD-a4.pdf` (Letter, N&B et tablette : même contenu, autre mise en page).
- **Version :** le pied de page affiche encore **v1**, car le producteur ne modifie pas `data/variantes.csv`. À passer en **v2** par l'orchestrateur avant l'envoi, puis refabriquer. La ligne de `data/revues.csv` reprend la version du PDF relu.

### Comment elle travaille
Elle n'ouvre aucun fichier CSV et ne lance aucun script. Elle annote le PDF (commentaires PDF, ou PDF imprimé, annoté puis photographié). Pour chaque annotation, elle indique :
- la ligne visée (nom de l'examen, ou titre de l'encadré) ;
- la décision : garder, corriger (nouvelle valeur ou nouvelle formulation), retirer ;
- si possible, la source de sa correction (document, édition, page).

### Ce que fait l'orchestrateur ensuite
Il reporte chaque décision dans le champ correspondant (tableau ci-dessous), relance `python3 scripts/build.py EN08-STD` (la compilation échoue si US et SI ne concordent plus), puis `apercus.py`, `video_feuilletage.py` et `anki.py` sur EN08-STD, et enfin `annonces.py EN08`. Il écrit ensuite la ligne de `data/revues.csv`.

| Décision de la relectrice | Champ à modifier |
|---|---|
| Une borne d'intervalle | `donnees/examens.csv`, colonnes `bas_us` / `haut_us` (ou `bas_si` / `haut_si` pour le Ca ionisé, seule ligne dont la source est en SI), plus l'autre unité recalculée avec le facteur exact puis arrondie une fois |
| Un libellé d'examen | `donnees/examens.csv`, colonne `examen` (et le même libellé dans `src/main.typ` s'il y est cité, la compilation échoue sinon) |
| Un facteur de conversion | `donnees/exemples.csv`, ligne `F_<code>`, et `donnees/facteurs.csv`, colonne `facteur` |
| Une ligne à retirer ou à ajouter | `donnees/examens.csv` (groupes dans `donnees/groupes.csv`) |
| Les seuils INR (cible courante, risque hémorragique, risque de caillot) | `donnees/valeurs.csv`, clés `inr_caillot` et `inr_saignement` (doivent rester égales aux bornes de la ligne « INR on warfarin, common », contrôle à la compilation) |
| Le texte d'un encadré (piège, note clinique) | `src/main.typ`, et la ligne correspondante de `donnees/references.csv` |
| Une carte Anki | `donnees/cartes.csv`, colonne `verso` (ne pas changer le `recto`) |

## Sources
- **Intervalles de référence et seuils lipidiques :** ABIM Laboratory Test Reference Ranges, January 2026 (`ABIM_2026`), en unités US sauf le Ca ionisé (mmol/L). Pages indicatives dans `references.csv`.
- **INR (sans anticoagulant, cible courante sous warfarine) et digoxine :** MedlinePlus 003652 et 003568.
- **Pièges et notes ajoutés en v2 :** MedlinePlus 003484 (potassium : hémolyse, rythme cardiaque), 001179 (hyperkaliémie), 003477 et 003486 (calcium total et ionisé).
- **HbA1c :** équation maîtresse du NGSP (page « IFCC Standardization of HbA1c »).
- **Autres facteurs :** calculés depuis les masses atomiques IUPAC (table abrégée 2021) et des définitions d'unités (mEq = mmol × charge ; 1 U = 1 µmol/min) ; triglycérides calculés comme trioléine. La fiche les présente comme des calculs, pas comme des valeurs publiées.
- **Valeurs SI :** calculées depuis la valeur US avec le facteur exact, puis arrondies une seule fois ; facteurs affichés avec assez de chiffres pour que « SI = US × facteur affiché » redonne la même valeur (contrôlé à la compilation).
- **Droits :** les intervalles sont des données factuelles ; le tableau n'est pas celui de l'ABIM (sélection, regroupement, colonnes SI et facteur ajoutées, libellés reformulés).

## Points à confirmer (A-VERIFIER)

### Valeurs
1. **Intervalles ABIM.** Le vérificateur a relu les 37 intervalles de façon indépendante : ils concordent avec le texte de l'ABIM. Lui aussi a lu le PDF par extraction de texte web (téléchargement refusé par le proxy). Un sondage de quelques lignes dans le PDF suffit.
2. **Digoxine 0.5–1.9 ng/mL.** C'est l'intervalle « général » de MedlinePlus. En v2, la ligne est classée dans le groupe « Drug therapy (target set by the prescriber) », et la note reprend « may vary with the situation ». Garder, préciser ou retirer ?
3. **HbA1c en mmol/mol.** En v2, l'équation est celle du NGSP : mmol/mol = (% − 2.152) ÷ 0.09148. L'intervalle affiché reste 20–38 mmol/mol.
4. **Triglycérides × 0.01129.** Facteur calculé en assimilant les triglycérides à la trioléine et présenté comme un calcul. Si elle préfère le facteur publié usuel (0.0113), il faut citer un tableau de conversion identifié.
5. **Enzymes en µkat/L (÷ 60).** Beaucoup de laboratoires SI gardent l'U/L. Garder la colonne µkat/L ou écrire « U/L » des deux côtés ? (Choix éditorial.)
6. **SaO₂ ≥ 95 %.** Conforme à l'ABIM p. 2 selon le vérificateur. Garder ?
7. **Masses atomiques.** Les valeurs indépendantes du vérificateur redonnent les 9 masses molaires. La table IUPAC n'a pas été relue dans ce run.

### Interprétation (périmètre de la médecin stagiaire)
8. **Piège « Total vs ionized calcium ».** Sourcé en v2 (MedlinePlus 003477 et 003486). La mention « ionized calcium may be normal », non sourcée, a été retirée. À noter : MedlinePlus 003486 donne pour le Ca ionisé 1.20–1.40 mmol/L, contre 1.16–1.31 pour l'ABIM. C'est un exemple de la variation entre sources ; la fiche garde l'ABIM.
9. **Piège « High K⁺ and hemolysis ».** Il commence maintenant par « Report a high K⁺ per protocol ». Le K⁺ faussement élevé en cas d'hémolyse est sourcé (MedlinePlus 003484). « A redraw may be requested » est une consigne de pratique, absente de la source : à valider ou à retirer.
10. **Note « Potassium and the heart ».** Sourcée en v2 (MedlinePlus 003484 pour le K⁺ bas et haut, 001179 en seconde source pour le K⁺ haut). La mention « ECG monitoring per protocol » a été retirée.
11. **Consignes « per protocol ».** Trois occurrences : note INR, note potassium, piège hémolyse. Ce sont des consignes génériques absentes des sources : à valider ou à retirer.
12. **Clarté des libellés.** « HDL, female: low if < 50 », « INR on warfarin, common » sous l'en-tête « Drug therapy (target set by the prescriber) », titre « Traps » (et non plus « Unit traps »), « BUN (urea nitrogen) → urea », « IFCC eq. » dans la colonne des facteurs.

### Question ouverte : à trancher par la relectrice et Tristan
13. **Intervalles de l'ABIM ou intervalles enseignés en soins infirmiers ?** Les intervalles de l'ABIM (board de médecine interne) sont, pour certains examens, plus étroits que ceux souvent enseignés en soins infirmiers ; le vérificateur cite notamment les gaz du sang. Ce constat vient de sa connaissance et n'est **pas sourcé** dans ce run. Le sous-titre dit « for NCLEX review ». Deux options :
   - garder l'ABIM, en s'appuyant sur l'avertissement « Reference intervals vary between laboratories » ;
   - ajouter « compare with the ranges your program teaches » ;
   - ou changer de source pour les intervalles concernés (source à trouver).

## Corrections v2 (rapport-v1)
- **B1 :** INR sous warfarine. La ligne s'intitule « INR on warfarin, common » dans le groupe « Drug therapy (target set by the prescriber) ». La note dit que le.la prescripteur.rice fixe la cible selon l'indication et que 2.0–3.0 est courant ; elle cite les deux risques (au-dessus de 3.0, en dessous de 2.0). Même chose sur la carte Anki.
- **B2 :** hémolyse. Le signalement vient en premier, le texte est sourcé.
- **M1, M2 :** potassium et calcium sourcés.
- **M3 :** équation du NGSP.
- **M4 :** facteurs présentés comme définitions ou calculs.
- **M5 :** digoxine.
- **M6 :** sens des seuils HDL.
- **M7 :** `contenu.csv` et annonces distinguent les intervalles de référence, les seuils de décision et les cibles thérapeutiques.
- **m1 :** 5 bornes SI recalculées avec le facteur exact (2.55, 5.17, 1.29, 1.03, 1.69), facteurs affichés 0.24951, 0.02586, 0.01129.
- **m2 :** « Triglycerides, normal ».
- **m3 :** en-têtes de groupe en sous-en-têtes répétés à la coupure ; « Ranges vary by lab » ajouté sous le tableau.
- **m4 :** titre « Traps ».
- **m5 :** ligne des sources complétée.
- **m6 :** marqueurs dans `cartes.csv`.
- **m7 :** « 1.10 ».
- **m8 :** nombres lus dans les tables, `valence_mg` utilisé.
- **m9 :** ce fichier.
- **m10 :** pages ABIM.

## Non couvert (choix ou faute de source)
- Lithium (taux thérapeutique) : source non obtenue.
- Valeurs critiques : aucune source consultée ne les écrit de façon générale (elles sont propres à chaque laboratoire).
- Formule du calcium corrigé par l'albumine, trou anionique, lactate, intervalles pédiatriques et de grossesse, urines.

## Pages web non obtenues
- PDF ABIM en téléchargement direct (proxy 403) ; lu par un outil de lecture web.
- IUPAC Gold Book, terme « enzyme unit » (accès non accordé pendant la correction v2).
- Pendant la v1 : Merck Manual Professional « Normal Laboratory Values » ; MedlinePlus Lab Tests « Prothrombin Time Test and INR » et « Potassium Blood Test » ; testing.com « Lithium » ; PMC10197277 ; PMC2390954 (captcha).
