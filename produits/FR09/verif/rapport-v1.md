# FR09-STD : vérification v1 (run R04)

- **Produit :** FR09 « PASS/LAS Biostatistiques — fiche formules », variante FR09-STD (fr-FR, Clairance, Whop et Etsy, risque IA FAIBLE, 1 page).
- **Vérificateur :** agent VÉRIFICATEUR R04. Je n'ai participé ni à la production ni à la correction. Date : 29.10.2026, de 11:08 à 11:21.
- **Périmètre :** `src/main.typ`, `donnees/{exemples,valeurs,textes,contenu,references,sources,cartes}.csv`, les 4 PDF de `livraison/FR09-STD/`. Hors périmètre (travail simultané du conditionneur) : `apercus/`, `video/`, `annonce/`, `donnees/extraits.csv`, `FR09-STD.apkg`.
- **Méthode :**
  - Relecture complète de la source Typst et des tables.
  - PDF A4 : pdftotext et rendu PNG à 150 dpi, lu en 6 tuiles. Tablette : rendu des 3 pages. N&B : contrôle automatique.
  - `scripts/controle_pdf.py FR09-STD` : tous les contrôles passent sur les 4 formats (métadonnées, 1 page, 3 pages tablette, mentions, N&B sans couleur, 9 signets).
  - Rebuild dans une copie du dépôt (`scripts/build.py FR09-STD`, contrôle de source compris) : il réussit. Le texte des 4 PDF reconstruits est identique à celui des PDF livrés.
  - Recalcul indépendant par script (en fin de rapport) : formules du CSV, recalcul par une autre voie (définitions, comptage, scipy), valeurs usuelles et concordance avec le PDF A4.
  - Fond confronté à des sources lisibles autres qu'OpenStax (décision D10), toutes lues en ligne le 29.10.2026 : NIST/SEMATECH e-Handbook, CDC Principles of Epidemiology, Penn State (STAT 200, 414, 500, 800), MIT OCW 9.07, University of Regina, Radiopaedia, déclaration de l'ASA sur les p-values, Montana State University. Les trois programmes cités ont été relus.
  - **Je n'ai consulté aucune page OpenStax.**

## Verdict : **À corriger** (correction documentaire ; aucun calcul ni aucune formule faux)

| Bilan | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 1 (M1 : références) |
| MINEUR | 10 |

- **Calculs :** les 20 résultats sont justes. Chacun est recalculé de deux façons : par la formule du CSV et par une voie indépendante (comptage sur une population fictive pour VPP et VPN, `scipy.stats` pour les lois, le khi-deux et les quantiles). Les 9 valeurs usuelles sont justes : z, khi-deux, et la règle 68-95-99,7 aux arrondis près. Chaque nombre affiché dans le PDF correspond aux données.
- **Fond :** aucune erreur ni simplification trompeuse sur les points demandés. Je les ai tous relus : variance en n − 1, Bayes et VPP par la prévalence, Se, Sp, VPP et VPN, binomiale, Poisson et son approximation, normale, erreur standard, IC (z ou t, conditions de la proportion), α, β, puissance et p, khi-deux (E, ddl, seuils), r et régression, incidence, prévalence, RR et OR.
- **Pourquoi le MAJEUR M1 :** sur 28 lignes de `references.csv`, 17 s'appuient sur OpenStax Introductory Statistics. Depuis D10, cette source ne peut plus être relue ni contrôlée par les agents, et sa licence est non commerciale. Sept de ces lignes sont en plus marquées `A-VERIFIER` par le producteur. La formule de la VPN par Bayes, qui sert à calculer un résultat affiché (BX05), n'a aucune ligne de référence. J'ai trouvé une source lisible pour presque chaque point (tableau en M1) : la correction consiste surtout à reporter ces sources dans `references.csv`.
- **Règle 14 :** respectée. Le sous-titre et `contenu.csv` ne promettent aucune couverture. Les trois programmes sont ceux de 2025-2026 ou 2026-2027 et sont publiés par les universités. Pour les tests diagnostiques et l'épidémiologie, le rattachement par intitulé générique est acceptable (voir A-VERIFIER n° 10).
- **`contenu.csv` :** il décrit exactement le PDF. J'ai compté chaque élément : 9 sections, tablette de 3 pages, 7 encadrés d'exemples, 20 résultats, 3 tableaux de valeurs, 2 tableaux 2 × 2, 1 tableau des types d'étude, 9 pièges. Le contenu des sections correspond aussi.

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `donnees/references.csv` (17 lignes `OPENSTAX_IS2`, dont 7 `A-VERIFIER`) ; aucune ligne pour la VPN par Bayes (BX05) | **Le fond ne repose, pour l'essentiel, que sur OpenStax.** C'est une source non commerciale (CC BY-NC-SA) que les agents ne peuvent plus consulter (D10), et je n'ai donc pas pu contrôler ses localisations. Le producteur a marqué `A-VERIFIER` : Bayes et VPP « déduits », r = cov/(sₓ s_y) « non lu tel quel », médiane et mode, la fin de la définition de p, la lecture en z de deux moyennes, et deux pièges. **La VPN par Bayes n'a aucune ligne.** Ces lignes OpenStax portent « consulté le 29.10.2026 », le jour même de D10 (`producteur.md` et `decisions.csv` modifiés à 11:02:31, `references.csv` à 11:06:57). Je ne peux pas savoir si la lecture a eu lieu avant D10. Enfin, la règle 3 de `producteur.md` liste quatre livres OpenStax mais pas Introductory Statistics 2e. | Ajouter dans `sources.csv` et `references.csv` les sources ci-dessous, lues le 29.10.2026, et retirer les marques `A-VERIFIER` qu'elles lèvent. Garder OpenStax comme simple bibliographie, ou le retirer. **Orchestrateur :** ajouter « Introductory Statistics 2e » à la liste de la règle 3. |
| m1 | MINEUR | `main.typ` l. 120, 154, 168, 189-190 | Virgule décimale et virgule séparatrice se confondent. On lit « ℬ(4, 0,1) », « Se 0,9, Sp 0,95, P = 0,02 » et « Série 2, 4, 4, 5, 10 ». Dans les intervalles, « [4,81; 5,59] » s'écrit sans espace avant le point-virgule. | « ℬ(4 ; 0,1) » ; « Se = 0,9 ; Sp = 0,95 ; P = 0,02 » ; « [4,81 ; 5,59] ». Pour la série, « 2 ; 4 ; 4 ; 5 ; 10 » est facultatif (ce sont des entiers). |
| m2 | MINEUR | `main.typ` l. 173-178 (tableau « Normale ») ; `valeurs.csv` R1-R3 | La fiche affiche « 68 % 95 % 99,7 % » sans « ≈ », alors qu'elle met « ≈ » devant toutes les autres valeurs arrondies. Les valeurs exactes sont 68,27 %, 95,45 % et 99,73 %. Un peu plus bas, le tableau des z donne 95 % à 1,96 : l'étudiant.e peut y voir une contradiction (règle 13). | Afficher « ≈ 68 % », « ≈ 95 % », « ≈ 99,7 % ». On peut ajouter, en option : « 95 % exactement à ± 1,96 σ ». |
| m3 | MINEUR | `main.typ` l. 145-151 et 154 | L'exemple donne « VPN ≈ 99,8 % », mais l'encadré ne fournit la forme de Bayes que pour la VPP. L'étudiant.e ne peut pas refaire ce calcul avec la fiche. | Ajouter VPN = Sp (1 − P) / (Sp (1 − P) + (1 − Se) P). Source : Radiopaedia « Negative predictive value » (voir M1). |
| m4 | MINEUR | `main.typ` l. 183-185 et 190 | Les notations de l'estimation ne sont pas cohérentes. (a) L'IC d'une proportion s'écrit « p ± z√(p(1 − p)/n) » : la proportion observée y porte le même nom que le paramètre inconnu, alors que la fiche distingue bien x̄ de μ. (b) L'erreur standard est donnée en σ/√n, et l'IC utilise s/√n sans transition. | (a) Écrire p̂ (ou f) dans la formule, les conditions et l'exemple. (b) Ajouter « estimée par s/√n ». |
| m5 | MINEUR | `main.typ` l. 188, 211, 270 ; l. 121, 168, 170, 236, 269, 270 ; l. 74-98 | Certaines données sont encore tapées dans le Typst. « Intervalles de confiance à 95 % », « significative à 5 % » (deux fois) et « (ddl 1) » devraient venir de `valeurs.csv` (Z95.alpha, KHI1_95.alpha et .ddl). Le signe « = » est écrit en dur devant 10 résultats, au lieu de `rel()`. Ils sont exacts aujourd'hui, mais deviendraient faux si les données changeaient. Il manque aussi trois contrôles : BX06 omet l'exposant j (cela suppose j = 1) ; BX14 réutilise ea pour la case c et eb pour la case d (juste seulement parce que les deux lignes totalisent 100) ; N = a + b + c + d n'est pas contrôlé. | Lire 95 %, 5 % et ddl dans `valeurs.csv` et utiliser `rel()` partout. Ajouter dans `main.typ` les contrôles `verifie` : j = 1 (ou afficher p^j), c + d = a + b, N = a + b + c + d. |
| m6 | MINEUR | `main.typ` l. 268-271 | L'exemple du khi-deux n'affiche que E_a. L'étudiant.e ne peut pas refaire χ² ≈ 6,45. | Afficher les 4 effectifs attendus (22,5 ; 77,5 ; 22,5 ; 77,5), lus dans BX14.ea et BX14.eb. |
| m7 | MINEUR | `main.typ` l. 264-271 et l. 273-283 | L'exemple « Même tableau » calcule RR et OR sur le même tableau sans dire de quel schéma d'étude il s'agit. Or l'erreur classique est de calculer un RR en cas-témoins. | Ajouter un piège : « Cas-témoins : RR non calculable, seul l'OR l'est. » Ou préciser l'exemple : « (lu comme une cohorte) ». |
| m8 | MINEUR | `main.typ` l. 129-130 | Dans P(A \| B) = P(A ∩ B)/P(B) et « soit P(A \| B) = P(A) », la condition P(B) > 0 n'est pas écrite. | Ajouter « (P(B) > 0) ». |
| m9 | MINEUR | PDF A4 et tablette | Forme. (a) A4 : la formule « P(A ∩ B) » est coupée en fin de ligne (« ∩ / B) », l. 128). (b) Une espace parasite apparaît dans « VP /(VP + FN) » et les trois autres rapports (l. 146-147). (c) La mention « (M) » de « Malades (M) » ne sert à rien (l. 140). (d) Tablette : l'encadré « Estimation » est coupé entre les pages 1 et 2, et l'encadré « Piège » laisse 2 puces seules en page 3. (e) La police de repli NewCMMath-Book est incorporée. C'est aussi le cas de FR07 ; elle sert probablement pour ℬ, 𝒫 et 𝒩, dont le rendu est correct. | (a) Insécable ou reformulation. (b) `"VP"/("VP" + "FN")` sans espace. (c) Retirer « (M) ». (d) Empêcher la coupure des encadrés en tablette, ou l'accepter : rien n'est perdu. (e) À signaler à la charte, pas au producteur. |
| m10 | MINEUR | `donnees/contenu.csv` ligne 7 (et ligne 1) | Les décomptes (9 sections, 7 encadrés, 20 résultats, 3 tableaux, 2 tableaux 2 × 2, 9 pièges, 3 pages) sont exacts, mais écrits en texte sans aucun contrôle. Ils dériveront à la prochaine modification, et l'annonce les reprendra. | Les tirer des tables, ou ajouter un contrôle au build. |

### M1 : sources lisibles proposées (toutes lues le 29.10.2026, références factuelles, aucune reprise de texte)

| Élément de la fiche | Source lisible | Ce qu'elle écrit |
|---|---|---|
| Moyenne ; médiane (n pair : moyenne des deux valeurs centrales) ; mode | NIST/SEMATECH e-Handbook, § 1.3.5.1 *Measures of Location* | Les trois définitions, cas N pair compris. **Lève l'A-VERIFIER.** |
| s² = Σ(x − x̄)²/(n − 1), s = √s² | NIST/SEMATECH, § 1.3.5.6 *Measures of Scale* | Les deux formules, avec le dénominateur N − 1. |
| Bayes avec les probabilités totales | Math/Stat 251, University of Regina, automne 2015, polycopié *summary 6* (M. Kozdron, d'après l'URL ; le nom n'est pas imprimé dans le document) | Probabilités totales et règle de Bayes pour une partition B₁…B_k. La fiche en est le cas k = 2 (A, Ā). **Lève l'A-VERIFIER.** |
| VPP = Se P / (Se P + (1 − Sp)(1 − P)) ; VPN = Sp (1 − P) / (Sp (1 − P) + (1 − Se) P) | Radiopaedia, articles « Positive predictive value » et « Negative predictive value » | Les deux formules telles quelles, P étant la probabilité prétest. L'outil de lecture ne m'a donné ni auteur ni date : les recopier depuis la page (règle 12). **Lève l'A-VERIFIER et comble l'absence de la VPN.** |
| Binomiale : P(X = x), moyenne np, écart-type √(np(1 − p)) | NIST/SEMATECH, § 1.3.6.6.18 *Binomial Distribution* | Tout, la variance s'obtenant comme carré de l'écart-type. |
| Poisson : P(X = x) = e^(−λ) λ^x / x!, moyenne λ, écart-type √λ | NIST/SEMATECH, § 1.3.6.6.19 *Poisson Distribution* | Tout, sauf l'approximation de la binomiale. |
| Approximation de ℬ(n, p) par 𝒫(np) si n grand et p petit | Penn State STAT 414, § 12.4 *Approximating the Binomial Distribution* | λ = np, avec des seuils indicatifs (n ≥ 20 et p ≤ 0,05, ou n ≥ 100 et p ≤ 0,10). |
| Règle 68-95-99,7 | Hayes C., Montana State University, diapositives L1.3, n° 10 ; recalcul scipy dans ce rapport | « 68 % / 95 % / 99.7 % within one / two / three standard deviations ». |
| IC d'une moyenne, t de Student à n − 1 ddl | NIST/SEMATECH, § 1.3.5.2 *Confidence Limits for the Mean* | Ȳ ± t(1 − α/2, N − 1) s/√N. NIST utilise t quel que soit N. La version « z si n grand » est la convention des cours de PASS : acceptable. |
| IC d'une proportion, conditions n p et n(1 − p) > 5 | Penn State STAT 500, § 5.3 *Inference for the Population Proportion* | « If np and n(1-p) are greater than five », au sens strict comme dans la fiche. L'erreur standard √(p(1 − p)/n) y figure. |
| Deux moyennes indépendantes : (x̄₁ − x̄₂)/√(s₁²/n₁ + s₂²/n₂) | NIST/SEMATECH, § 1.3.5.3 *Two-Sample t-Test for Equal Means* | La même statistique, pour des variances inégales. La lecture en z pour de grands échantillons s'en déduit (t tend vers la normale). **A-VERIFIER levé pour la formule.** |
| α, β, puissance 1 − β | Penn State STAT 800, § 5.4.1 *Errors* ; Vrbik I., STAT 205, UBC Okanagan, « Type I/II Errors and Power » | Les trois définitions. |
| Définition de p ; « p n'est pas la probabilité que H₀ soit vraie » | Wasserstein R.L., Lazar N.A., « The ASA's statement on p-values », *The American Statistician* 70(2):129-133, 2016 (lue dans sa reproduction sur la page de J. Utts, UC Irvine) | La définition informelle (« probability under a specified statistical model that a statistical summary of the data would be equal to or more extreme… ») et le principe 2 (« P-values do not measure the probability that the studied hypothesis is true »). **Lève les deux A-VERIFIER.** |
| Khi-deux : E = total ligne × total colonne / N, ddl = (l − 1)(c − 1), chaque E ≥ 5 | Penn State STAT 200, § 11.3 *Chi-Square Test of Independence* | Les trois éléments et le seuil de 5. |
| r = cov(x, y)/(sₓ s_y) ; b = r s_y/sₓ ; a = ȳ − b x̄ | MIT OpenCourseWare 9.07 *Statistics for Brain and Cognitive Science*, printemps 2004, cours « Correlation & Regression, III », diapositive « Review » | Les trois formules. **Lève l'A-VERIFIER.** |
| Incidence cumulée, taux d'incidence, prévalence, dépendance à l'incidence et à la durée | CDC, Principles of Epidemiology, Lesson 3, Section 2 (déjà cité) | Je l'ai relu : **confirmé.** |
| RR, OR = ad/bc, OR ≈ RR si la maladie est rare | CDC, Lesson 3, Section 5 (déjà cité) | Je l'ai relu : **confirmé.** Les taux a/(a + b) et c/(c + d) y sont donnés séparément. |
| z = 1,645 ; 1,96 ; 2,576 et seuils χ² 3,841 ; 6,635 ; 5,991 | NIST (déjà cité) | Je n'ai pas relu la page, mais j'ai recalculé chaque valeur avec scipy : **justes** au millième. |

Restent sans source lisible hors OpenStax (je ne les ai pas relus) : les règles de base des probabilités (complémentaire, addition, multiplication, indépendance, incompatibilité), l'erreur standard σ/√n et le théorème central limite, « −1 ≤ r ≤ 1 » et « r² = part expliquée », le piège « corrélation ≠ causalité », « ne pas rejeter H₀ ne prouve pas H₀ » (Penn State STAT 800 le suggère sans l'écrire), et les types d'étude (CDC Lesson 1, Section 7, déjà cité). Ce sont des résultats élémentaires et exacts dans la fiche. Une source de plus serait une bonne pratique, mais ils ne bloquent pas.

## Points `A-VERIFIER` : avis

| # | Point | Avis | Bloque la publication ? |
|---|---|---|---|
| 1 | Médiane et mode (`references.csv`) | Levé par NIST § 1.3.5.1. | Non, une fois la référence ajoutée (M1) |
| 2 | Bayes et VPP « déduits » | Levé par Regina Math/Stat 251 et Radiopaedia (VPP et VPN). | Non, une fois les références ajoutées (M1) |
| 3 | Fin de la définition de p | Levé par la déclaration de l'ASA (2016). La formulation de la fiche est juste. | Non, une fois la référence ajoutée |
| 4 | Lecture en z pour deux moyennes (grands échantillons) | Formule confirmée par NIST § 1.3.5.3. La lecture en z est une convention de cours, exacte en approximation. | Non |
| 5 | r = cov/(sₓ s_y) | Levé par MIT OCW 9.07. Je l'ai aussi vérifié numériquement sur des données synthétiques. | Non, une fois la référence ajoutée |
| 6 | Pièges « corrélation ≠ causalité » et « p ≠ P(H₀ vraie) » | Le second est levé par le principe 2 de l'ASA. Le premier reste sans source lue : c'est un rappel méthodologique exact. | Non |
| 7 | Pages du syllabus de Rennes (p. 4-5) | L'outil de lecture donne aussi p. 4-5. Il ne distingue pas page imprimée et page PDF. Je n'ai pas pu trancher. | Non |
| 8 | Contenu des programmes cités | Je les ai relus. **Montpellier** 2026/2027, UE8, p. 9-10 : « comparaison de pourcentages, de moyennes et de variances », « Les indicateurs de Santé et de risque », « Théorème central limite », « unilatéral ou bilatéral » sont confirmés ; aucun terme diagnostique ni khi-deux. **Rennes** 2025-2026, UE Bio-statistiques, S1, 5 ECTS : « Théorème de Bayes », « (Poisson, Bernouilli, Binomiale) » (l'orthographe « Bernouilli » est celle du document), « (normale, Student) », « Test du Khi2 : test d'indépendance, test d'homogénéité », « Corrélation et régression linéaire », « Introduction à l'épidémiologie » sont confirmés. **Bordeaux** 2025-2026, UE 5 : « Savoir mesurer la performance d'un examen ou d'une procédure », « dépistage », « Savoir évaluer l'existence d'un facteur de risque », « Types de mesures /indicateurs », « Schémas d'étude » et « Corrélation, Régression linéaire » sont confirmés, tous en **p. 25**. `references.csv` écrit « p. 24-25 » : la précision « p. 25 » est facultative. | Non |
| 9 | Mention `IA_REDACTION_ASSISTEE` : « contenu vérifié et validé par le vendeur » (pied de page) | Cette phrase ne sera vraie qu'après la validation de Tristan. Le produit est `A_VERIFIER` dans `produits.csv` (règle 15). Ce n'est pas un défaut du producteur. | **Oui**, tant que Tristan n'a pas validé (statut VALIDE) |
| 10 | Règle 14 : tests diagnostiques et épidémiologie fondés sur des intitulés génériques | **Acceptable.** Bordeaux fixe un objectif explicite de mesure de la performance d'un examen, avec le dépistage, ce qui correspond à Se, Sp, VPP et VPN ; Rennes nomme Bayes. Pour l'épidémiologie, les trois facultés l'enseignent sous des intitulés qui recouvrent incidence, prévalence, RR et OR (« indicateurs de santé et de risque », « facteur de risque », « schémas d'étude », « Introduction à l'épidémiologie »). La fiche ne promet rien de plus que « notions fréquentes… les enseignements varient selon les facultés », et `references.csv` documente honnêtement ce rattachement. Seul point faible : aucune des trois ne **nomme** Se, Sp, VPP, VPN, RR ou OR. Ajouter une 4ᵉ faculté qui les nomme renforcerait le dossier sans être nécessaire. | Non |

## Autres contrôles

- **Règle 9 :** les 20 formules n'utilisent que `+ - * /`, des parenthèses et `calc.pow`. `entrees_json` est en décimal. Les arrondis sont cohérents. Aucune quantité « à régler » : la règle d'arrondi administrable ne s'applique pas.
- **Règle 15 :** la fiche et `contenu.csv` n'écrivent jamais « vérifié » ni « contrôlé », sauf la mention commune (A-VERIFIER n° 9). `references.csv` écrit « consulté », ce qui est correct.
- **Règle 16 :** les `\;` de la l. 189-190 sont corrects. Le contrôle de source du build passe.
- **Règle 12 :** chaque `source_code` désigne un document identifié. Seules les localisations OpenStax n'ont pas pu être contrôlées (M1).
- **Droits :** les phrases sont reformulées et brèves. Aucun tableau n'est repris (z et khi-deux sont des faits numériques). Les exemples sont inventés : série 2, 4, 4, 5, 10, échelle 100/15 générique, tableau 30/70/15/85. Je n'ai relevé aucun passage suspect. Je n'ai pas pu comparer directement avec OpenStax (D10).
- **Concordance :** les 20 résultats et les 11 valeurs usuelles ont été retrouvés dans le texte du PDF A4, avec le bon signe (= ou ≈) (script, partie D). Le Typst vérifie déjà à la compilation la plupart des liens entre exemples ; il manque les contrôles listés en m5.
- **`cartes.csv` :** les formules sont conformes à la fiche. Le paquet Anki n'est pas jugé ici.

## Script de recalcul

Lancé avec `python3 -I recalc_fr09.py /home/claude/mindshelf` (Python 3, scipy 1.18.1, numpy). Résultat : **0 écart** sur 135 contrôles (A : 60 ; B : 35 ; C : 9 ; D : 31).

Extraits de la sortie :

```
BX04 indépendant = 26.865672 (attendu 26.865672)      # comptage sur 1 000 000 personnes
BX05 indépendant = 99.785638 (attendu 99.785637)
BX07 indépendant = 0.27067057 (attendu 0.27067)       # e^-2 exact : même affichage 0,271
BX09 avec z exact 1.959964 : 4.80801, même arrondi à 2 décimales
BX13 z = 2.5607 > 1,96 ; p bilatéral = 0.0104 < 0,05
BX14 effectifs attendus [[22.5, 77.5], [22.5, 77.5]] tous ≥ 5
BX14 χ² = 6.4516 : significatif à 5 % (p = 0.0111), pas à 1 %
Z95 z(1 - α/2) = 1.95996 ; table 1.96
KHI1_95 χ²(1 - α ; ddl 1) = 3.84146 ; table 3.841
R2 ±2σ : 95.450 % ; table 95 % (arrondi, pas exact)
0 écart(s)
```

```python
#!/usr/bin/env python3
"""FR09-STD : recalcul indépendant (vérificateur R04).

Usage : python3 -I recalc_fr09.py <racine du dépôt>
A. évalue chaque `formule` de exemples.csv (calc.pow -> pow) et la compare à resultat_attendu ;
B. recalcule chaque résultat par une autre voie (définitions, comptage, scipy) ;
C. recalcule valeurs.csv (z, khi-deux, règle 68-95-99,7) ;
D. cherche dans le texte du PDF A4 chaque nombre affiché (concordance).
"""
import csv, json, math, re, statistics, subprocess, sys
from pathlib import Path
from scipy import stats

racine = Path(sys.argv[1])
dossier = racine / "produits/FR09"
ex = {l["id"]: l for l in csv.DictReader(open(dossier / "donnees/exemples.csv", encoding="utf-8"))}
va = {l["id"]: l for l in csv.DictReader(open(dossier / "donnees/valeurs.csv", encoding="utf-8"))}
ecarts = []

def note(ok, msg):
    print(("OK    " if ok else "ECART ") + msg)
    if not ok:
        ecarts.append(msg)

# ---------- A. formules du CSV ----------
print("== A. formules de exemples.csv (calc.pow évalué comme pow)")
autorise = re.compile(r"^(calc\.pow|[A-Za-z_][A-Za-z0-9_]*|[0-9.]+|[-+*/(), ])+$")
calcule = {}
for i, l in ex.items():
    f = l["formule"]
    note(bool(autorise.match(f)) and "**" not in f, f"{i} formule limitée à + - * / ( ) calc.pow : {f}")
    note(not re.search(r"\d[eE][-+]?\d", l["entrees_json"]), f"{i} entrees_json sans notation 1e-6")
    e = json.loads(l["entrees_json"])
    x = eval(f.replace("calc.pow", "pow"), {"__builtins__": {}, "pow": pow}, dict(e))
    calcule[i] = x
    att, tol = float(l["resultat_attendu"]), float(l["tolerance"])
    note(abs(x - att) <= tol, f"{i} formule = {x:.8g} ; attendu {att} ; tolérance {tol}")

# ---------- B. recalcul par une autre voie ----------
print("== B. recalcul indépendant")
def proche(i, x, tol=None):
    t = float(ex[i]["tolerance"]) if tol is None else tol
    note(abs(x - float(ex[i]["resultat_attendu"])) <= t, f"{i} indépendant = {x:.8g} (attendu {ex[i]['resultat_attendu']})")

serie = [2, 4, 4, 5, 10]
proche("BX01", statistics.mean(serie))
proche("BX02", statistics.variance(serie))            # dénominateur n - 1
proche("BX03", statistics.stdev(serie))
note(statistics.median(serie) == 4 and statistics.mode(serie) == 4, "BX01 médiane 4 = mode 4 < moyenne 5")
note(statistics.pvariance(serie) != statistics.variance(serie), f"BX02 variance de population {statistics.pvariance(serie)} ≠ 9 (piège n - 1 bien illustré)")

# Tests diagnostiques : comptage sur une population fictive de 1 000 000
N, P, Se, Sp = 1_000_000, 0.02, 0.90, 0.95
M = N * P; NM = N - M
VP, FN, VN = Se * M, (1 - Se) * M, Sp * NM
FP = NM - VN
proche("BX04", 100 * VP / (VP + FP))
proche("BX05", 100 * VN / (VN + FN))
note(VP / (VP + FP) < 0.5, f"BX04 « un test positif reste le plus souvent un faux positif » : FP/(VP+FP) = {FP/(VP+FP):.3f}")

proche("BX06", stats.binom.pmf(1, 4, 0.1))
note(math.comb(4, 1) == 4, "BX06 C(4,1) = 4")
proche("BX07", stats.poisson.pmf(2, 2), tol=0.000001)  # vraie valeur 0.2706706
note(abs(math.exp(-2) - 0.135335) < 0.0000005, f"BX07 e^-2 = {math.exp(-2):.7f} ≈ 0.135335 (6 décimales)")
note(round(stats.poisson.pmf(2, 2), 3) == round(float(ex['BX07']['resultat_attendu']), 3), "BX07 affiché à 3 décimales identique avec e^-2 exact")
proche("BX08", (130 - 100) / 15)

z975 = stats.norm.ppf(0.975)
for i, signe in (("BX09", -1), ("BX10", +1)):
    proche(i, 5.2 + signe * 1.96 * 2 / math.sqrt(100))
    exact = 5.2 + signe * z975 * 2 / 10
    note(round(exact, 2) == round(calcule[i], 2), f"{i} avec z exact {z975:.6f} : {exact:.5f}, même arrondi à 2 décimales")
pc, n = 0.2, 400
note(n * pc > 5 and n * (1 - pc) > 5, f"BX11 conditions n p = {n*pc:g} et n(1 - p) = {n*(1-pc):g} > 5")
for i, signe in (("BX11", -1), ("BX12", +1)):
    proche(i, 100 * (pc + signe * 1.96 * math.sqrt(pc * (1 - pc) / n)))

z = (12 - 11) / math.sqrt(9 / 100 + 6.25 / 100)
proche("BX13", z)
p2 = 2 * stats.norm.sf(z)
note(z > 1.96 and p2 < 0.05, f"BX13 z = {z:.4f} > 1,96 ; p bilatéral = {p2:.4f} < 0,05")

tab = [[30, 70], [15, 85]]
chi2, p, ddl, att = stats.chi2_contingency(tab, correction=False)
proche("BX14", chi2)
note(ddl == 1, f"BX14 ddl = {ddl}")
note(att.min() >= 5, f"BX14 effectifs attendus {att.tolist()} tous ≥ 5")
note(3.841 < chi2 < 6.635, f"BX14 χ² = {chi2:.4f} : significatif à 5 % (p = {p:.4f}), pas à 1 %")
proche("BX15", att[0][0])
note(sum(tab[0]) == 100 and tab[0][0] + tab[1][0] == 45 and sum(map(sum, tab)) == 200, "BX15 totaux : ligne 100, colonne 45, N 200")
a, b, c, d = 30, 70, 15, 85
proche("BX16", (a / (a + b)) / (c / (c + d)))
proche("BX17", (a * d) / (b * c))

# Régression : jeu de données synthétique ayant r = 0,8, sx = 2, sy = 5, mx = 10, my = 30
import numpy as np
rng = np.random.default_rng(1)
u = rng.standard_normal(500); w = rng.standard_normal(500)
u = (u - u.mean()) / u.std(ddof=1)
w = w - u * (w @ u) / (u @ u); w = (w - w.mean()) / w.std(ddof=1)
x = 10 + 2 * u
y = 30 + 5 * (0.8 * u + 0.6 * w)
r = np.corrcoef(x, y)[0, 1]
cov = np.cov(x, y, ddof=1)[0, 1]
note(abs(r - cov / (x.std(ddof=1) * y.std(ddof=1))) < 1e-12, f"r = cov/(sx sy) sur données synthétiques : r = {r:.6f}")
pente, ordonnee = np.polyfit(x, y, 1)
proche("BX18", pente, tol=1e-9)
proche("BX19", ordonnee, tol=1e-9)
proche("BX20", r * r, tol=1e-9)

# ---------- C. valeurs usuelles ----------
print("== C. valeurs.csv")
for i in ("Z90", "Z95", "Z99"):
    al = float(va[i]["alpha"])
    zz = stats.norm.ppf(1 - al / 2)
    note(abs(zz - float(va[i]["valeur"])) < 0.0006, f"{i} z(1 - α/2) = {zz:.5f} ; table {va[i]['valeur']}")
for i in ("KHI1_95", "KHI1_99", "KHI2_95"):
    q = stats.chi2.ppf(1 - float(va[i]["alpha"]), int(va[i]["ddl"]))
    note(abs(q - float(va[i]["valeur"])) < 0.0006, f"{i} χ²(1 - α ; ddl {va[i]['ddl']}) = {q:.5f} ; table {va[i]['valeur']}")
for i in ("R1", "R2", "R3"):
    k = int(va[i]["k_sigma"])
    part = 100 * (stats.norm.cdf(k) - stats.norm.cdf(-k))
    dec = len(va[i]["valeur"].split(".")[1]) if "." in va[i]["valeur"] else 0
    note(round(part, dec) == float(va[i]["valeur"]), f"{i} ±{k}σ : {part:.3f} % ; table {va[i]['valeur']} % (arrondi, pas exact)")

# ---------- D. concordance avec le PDF A4 ----------
print("== D. concordance PDF A4")
pdf = dossier / "livraison/FR09-STD/FR09-STD-a4.pdf"
txt = subprocess.run(["pdftotext", str(pdf), "-"], capture_output=True, text=True).stdout
txt = re.sub(r"[   \s]+", " ", txt)
def fr(i):
    d = int(ex[i]["arrondi"]); v = round(float(ex[i]["resultat_attendu"]), d)
    s = f"{v:.{d}f}".replace(".", ",")
    rel = "=" if abs(round(calcule[i], d) - calcule[i]) < 1e-9 else "≈"
    return s, rel
attendus = {
    "BX01": "= {s} ;", "BX02": "= {s} ;", "BX03": "= {s}.", "BX04": "VPP {r} {s} %", "BX05": "VPN {r} {s} %",
    "BX06": "= {s}.", "BX07": "{r} {s}.", "BX08": "= {s}.", "BX09": "{r} [{s};", "BX10": "; {s}]",
    "BX11": "{r} [{s};", "BX12": "; {s}]", "BX13": "{r} {s} > 1,96", "BX14": "{r} {s} > 3,841",
    "BX15": "= {s} ;", "BX16": "RR = {s} ;", "BX17": "OR {r} {s}.", "BX18": "= {s} ;", "BX19": "= {s} ;", "BX20": "= {s}.",
}
for i, motif in attendus.items():
    s, r = fr(i)
    m = motif.format(s=s, r=r)
    note(m in txt, f"{i} affiché « {m} »")
for v in ("1,645", "1,96", "2,576", "3,841", "6,635", "5,991", "68 %", "95 %", "99,7 %", "> 5.", "≥ 5."):
    note(v in txt, f"valeur usuelle « {v} » présente")

print(f"\n{len(ecarts)} écart(s)")
sys.exit(1 if ecarts else 0)
```
