# Vérification FR01 : Calculs de doses et débits — fiche méthode (rapport v1)

- **Run :** R02, agent VÉRIFICATEUR (sans participation à la production), 29.10.2026, 08:10–08:20
- **Objet :** `produits/FR01/` : `src/main.typ`, `donnees/*` (sauf `extraits.csv`), `livraison/FR01-2009/` et `livraison/FR01-2026/` (PDF a4, letter, nb, tablette). Marché FR, marque Clairance, étudiant.e.s en IFSI. Risque IA **FORT** : méthode rédigée par l'agent, relecture infirmière obligatoire, Whop seulement. Fichiers du conditionneur (`apercus/`, `video/`, `annonce/`, `extraits.csv`, `.apkg`) non jugés.
- **Méthode :** lecture des données, du Typst et du texte des 8 PDF livrés (pdftotext). Rendu PNG de l'A4 2026, de l'A4 N&B 2009 et des 3 pages de la tablette 2026. `python3 scripts/build.py FR01-2009` puis `FR01-2026` lancés dans une copie du dépôt (rien n'est écrit dans `livraison/`) : 8 PDF fabriqués, tous les contrôles `controle_pdf` OK, texte des 8 PDF reconstruits **identique** à celui des 8 PDF livrés. Script de recalcul indépendant en décimal exact (ci-dessous). Recherches web ciblées : arrêté du 20 février 2026, sources des UE 2026, liste ANSM des never events, guide HAS, éditions de Rispail et Viaux, préparations réelles.

## Verdict : **OK avec réserves**

Les 19 lignes de `exemples.csv` sont recalculées à l'identique. Chaque valeur réglée ou prélevée tombe sur un pas réel (0,88 mL au 0,01 ; 2,5 et 1,6 mL au 0,1 ; 125, 1,9 et 18,8 mL/h au 0,1 ; 42 et 25 gouttes/min entières). La règle d'arrondi est la même dans la fiche, les cartes, `valeurs.csv` et `references.csv`. Un nom désigne une seule préparation (Produits A à F), la mention « valeurs d'exercice, pas des recommandations posologiques » est en tête, et « valeurs d'exercice » figure dans le titre des 6 exemples médicamenteux. Le seul médicament réel cité (KCl injectable) est dans la note ANSM, sans dose. Les deux variantes ne diffèrent que par la ligne d'UE, et chacune ne cite que les UE de son référentiel.

**Aucun BLOQUANT dans le PDF.** Deux constats MAJEURS portent sur les documents de contrôle, pas sur le PDF :
1. `references.csv` et `statut-methode.md` affirment que les valeurs des Produits B et F ont été contrôlées par le vérificateur R01. C'est faux pour B et pour la concentration de F (M1).
2. `statut-methode.md` dit qu'aucun numéro d'UE n'est affiché en 2026. Le PDF affiche UE B.3 et B.4 (M2).

Ces deux points sont à corriger **avant l'envoi à la relectrice**. La publication reste bloquée jusqu'à sa relecture.

| Gravité | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 2 |
| MINEUR | 11 |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `references.csv`, ligne `EXERCICE` ; `statut-methode.md`, tableau « Valeurs d'exercice » et point 9 | Il est écrit que A, B, E et F « reprennent les valeurs d'EN01 v3 contrôlées par le vérificateur R01 (rapport v2) ». Or le rapport v2 d'EN01 a contrôlé les valeurs **v2** : Drug B à 17–33 mg/kg/j toutes les 8 h et Drug E à 360 mg/300 mL (1 200 µg/mL). Les valeurs v3 reprises ici (B à 36–48 mg/kg/j toutes les 6 h ; 1 100 µg/mL pour F) n'ont fait l'objet d'aucun rapport : `produits/EN01/verif/` ne contient que v1 et v2. Le rapport v2 n'a fait que *proposer* 330 mg/300 mL. A (32 mg/mL, 28 mg), E (1,4 g + 6,2 mL ⇒ 7 mL, 320 mg) et la dose de F (4,5 µg/kg/min, 76,4 kg) ont bien été contrôlés. La source citée ne soutient donc pas les valeurs de B et de F (règle 12). En plus, la mention « contrôlé » peut dispenser la relectrice d'examiner B et F. | Retirer « contrôlées par le vérificateur » pour B et F. Les présenter comme C et D : valeurs nouvelles, recherche web du 29.10.2026, à confirmer par la relectrice. Mettre à jour la colonne « Origine » du tableau de `statut-methode.md`. |
| M2 | MAJEUR | `statut-methode.md`, point 11, et liste des A-VERIFIER | « 2026 : aucun numéro d'UE affiché, faute d'avoir pu lire l'annexe III ». Faux : `variantes.csv` (modifié à 08:09, après `statut-methode.md` à 08:06) et les 4 PDF FR01-2026 affichent « UE B.3 « Pratiques et interventions infirmières » et UE B.4 « Démarche qualité et gestion des risques » ». Le document qui conditionne la publication décrit un PDF qui n'est pas celui livré. | Réécrire le point 11 : ce qui est affiché, sur quelles sources, et ce qui reste A-VERIFIER (annexe III). Ajouter les deux sources primaires trouvées (voir m10). |
| m1 | MINEUR | `references.csv`, 6 lignes `RISPAIL_2017` ; `statut-methode.md`, « Ouvrage de référence » | Une **5e édition** existe : Rispail D, Viaux A, Horn F, Simon V, *Guide du calcul de doses et de débits médicamenteux*, Elsevier Masson, 1.4.2024, ISBN 978-2-294-78300-5. Sa table des matières (parties I à III, ch. 1 à 5, fiches 1 à 6) reprend les chapitres cités (shop.elsevier.com, consulté le 29.10.2026). L'« autre édition » signalée (978-2-294-74225-5) n'est pas la plus récente. | Citer la 5e éd. (2024), ou garder la 4e en l'indiquant comme édition consultée. Demander à la relectrice de relever les pages dans l'édition qu'elle a en main. |
| m2 | MINEUR | `references.csv`, `HAS_ADM_2011` (5 B) | La version en ligne de la partie 1 « Comprendre » est datée de **mai 2013**. La règle des 5 B y figure p. 12, section « Au niveau international », avec renvoi aux « 5 Rights » (ISMP, 1999). La date « juillet 2011 » correspond à la première édition. | Localisation : « HAS, guide 2011, version mise à jour mai 2013, partie 1, p. 12 ». Le A-VERIFIER est levé pour cette ligne. |
| m3 | MINEUR | PDF § 6 (`main.typ` l. 205) | La fiche donne DF = 20 et 60 sans dire de lire le facteur sur l'emballage. La carte « Facteurs de gouttes » et `references.csv` (ISO_8536_5) le disent. Point de sécurité : un perfuseur à un autre facteur fausse le débit en gouttes. | Ajouter « lire le facteur sur l'emballage » à la ligne DF du § 6. |
| m4 | MINEUR | PDF § 3 (EX03B, 2,5 mL) et § 4 (EX04B) ; `valeurs.csv` `seringue_std_pas` | La seringue « graduée au 0,1 mL » n'a pas de capacité. Or 2,5 mL demande au moins 3 mL : une seringue de 2 mL ne suffit pas, et une seringue de 5 mL est couramment graduée au 0,2 mL, ce qui ne permet pas de lire 2,5. Le pas est juste, mais le choix de seringue est laissé implicite. Déjà au statut, point 3. | Créer une clé `seringue_std` (capacité, par exemple 3 mL) dans `valeurs.csv`, l'afficher (« seringue de 3 mL graduée au 0,1 mL ») et la faire valider par la relectrice. |
| m5 | MINEUR | `valeurs.csv` ; PDF § 9 « Gouttes/min : entières » | Le mode d'arrondi (au plus proche) n'existe que dans le code (`calc.round`) et dans l'exemple 41,67 ⇒ 42. Aucun champ ne recevra la décision de la relectrice (statut, point 2). C'est le constat N9 d'EN01, repris tel quel. | Ajouter une clé `gtt_arrondi` (ou `arrondi_mode`) lue par `main.typ`. Écrire « entières, au plus proche » si la relectrice le confirme. |
| m6 | MINEUR | PDF § 6 (« Pompe, PSE ») | Le sigle PSE est employé au § 6 et développé seulement au § 8. | Écrire « pousse-seringue électrique (PSE) » à la première occurrence. |
| m7 | MINEUR | `main.typ` l. 159 et 194 ; titres d'exemples ; EX10A | Typographie française irrégulière. Il manque l'espace avant « ; » dans « 75 mg; 0,4 mg » et « 720 mg/j; max » (échappement `\;`), alors que partout ailleurs on écrit « ; ». Les titres d'exemples ont une apostrophe droite (« d'exercice »), l'en-tête une apostrophe courbe. Enfin, le PDF écrit « 1100 µg/mL » alors que `references.csv` et le statut écrivent « 1 100 ». | Écrire `~;` (insécable) ou `#sym.space.nobreak;` ; employer l'apostrophe typographique dans les titres. Choisir une seule écriture des milliers, de préférence avec espace insécable (`nombre()`), et s'y tenir dans les données. |
| m8 | MINEUR | `statut-methode.md`, « Périmètre de la relecture » | Le statut dit que les « normes NF EN ISO des perfuseurs et seringues » ne sont pas demandées à la relectrice, mais ses points 3 et 8 lui demandent de confirmer les graduations et les facteurs de gouttes. Ce n'est pas contradictoire sur le fond, mais c'est ambigu. | Préciser : la relectrice valide les **valeurs** utilisées (20 et 60 gouttes/mL, graduations, pas des appareils) ; la **citation** des normes repose sur les sources. Le périmètre reste conforme à la décision de Tristan. |
| m9 | MINEUR | `statut-methode.md`, point 9 (échos, règle 11) | Aucune préparation n'est équivalente à une préparation réelle (voir « Sécurité clinique »), mais trois échos ne sont pas nommés pour la relectrice. **C** : 1,2 %, dans la zone de la lidocaïne (1 et 2 %), justement au cœur du never event ANSM n° 13 (surdosage de lidocaïne IV par confusion entre concentration et quantité totale). **D** : mg/h au PSE, dans la zone des sédatifs et des opioïdes en PSE (never event n° 11). **F** : 1 100 µg/mL dosé en µg/kg/min, proche d'une préparation de nitroprussiate à 1 mg/mL (non vérifié). | Nommer ces trois échos au point 9 pour que la relectrice tranche. Aucun changement de valeur n'est exigé. |
| m10 | MINEUR | `references.csv`, `SRC_IFSI_2026` ; `variantes.csv` FR01-2026 | Deux sources plus solides que celles citées existent. (1) Le corps de l'arrêté du 20 février 2026 (copie FHF, NOR ESRS2601184A, JORF du 25.02.2026, texte 53) nomme lui-même « l'UE B.3 « Pratiques et interventions infirmières » » à l'article 23, et l'article 60 I confirme « à compter de septembre 2026 ». (2) La délibération CFVU de l'Université de Bourgogne Europe du 16.06.2026 (réforme du diplôme infirmier, ube.fr) liste UEB3 (S1, S2) et UEB4 « Démarche qualité et gestion des risques » (S2) ; le contenu de B.3 en S1 cite « calculs de doses ». | Ajouter ces deux localisations. Avec elles, B.3 est établie par une source primaire. B.4 n'est rattachée aux calculs de doses que par l'éditeur (deux titres Vuibert), ce que « notamment » couvre. |
| m11 | MINEUR | PDF FR01-2009, ligne d'UE | La ligne 2026 précise le public (« entrant.e.s à partir de septembre 2026 »), la ligne 2009 non. Pour choisir la bonne variante, l'acheteur.se gagne à lire « étudiant.e.s entré.e.s en formation avant septembre 2026 » (arrêté de 2026, art. 60 I). | Ajouter cette précision dans `variantes.csv` (FR01-2009), sourcée par l'art. 60 I. |

### Contrôles passés sans constat
- **Calculs :** 19/19 lignes recalculées en décimal exact (écart max 3,3 × 10⁻¹¹, sous la tolérance). Formules limitées à `+ - * /` ; aucune notation exponentielle. Colonne `arrondi` cohérente.
- **Arrondis et pas réels :** 0,875 ⇒ 0,88 mL (seringue de 1 mL au 0,01 ; ISO 7886-1, A-VERIFIER) ; 2,5 et 1,6 mL au 0,1 ; 125, 1,867 ⇒ 1,9 et 18,753 ⇒ 18,8 mL/h au 0,1 ; 41,67 ⇒ 42 et 25 gouttes/min. Aucun intermédiaire arrondi : EX03A → B, EX04A → B, EX09A → B et EX10A → B reprennent la valeur exacte. Poids EX10B 76,4 kg au pas de 0,1 kg, non arrondi ensuite. L'arrondi du débit modifie la dose délivrée de +1,79 % (EX09B) et +0,25 % (EX10B). EX05 : 720 ≤ 840 ≤ 960 mg/j, conforme. EX08 : 6,25 h = 6 h 15 min, fin à 20 h 15. La règle d'arrondi est identique dans l'encadré § 9, le piège, la carte « Que faut-il arrondir ? », `valeurs.csv` et `references.csv`, sans contradiction (règle 13).
- **Concordance :** tous les nombres des PDF A4 2009 et 2026 proviennent des données, hors numéros de section, numéros et semestres d'UE, date de l'arrêté, heure et durée calculées. Les contrôles `meme()` du Typst bloquent la compilation en cas d'écart.
- **Fond :** produit en croix, échelle × 1000, % m/V = g pour 100 mL (Ph. Eur., A-VERIFIER sur le paragraphe), concentration sur le volume final, dose au poids par jour ou par prise, débits en mL/h et en gouttes/min, raccourcis (60 : gouttes/min = mL/h ; 20 : ÷ 3), heure de fin, PSE en mg/h et en µg/kg/min : tout est juste. La conduite hors fourchette (« ne pas administrer, joindre le.la prescripteur.rice ») est présente.
- **Never events ANSM :** page « Never events » vérifiée (publiée le 27.05.2024, mise à jour le 18.09.2025, désormais 16 événements). Le n° 2 porte sur le chlorure de potassium injectable, le n° 11 sur la programmation des pompes et seringues électriques. La note clinique est conforme.
- **Règle des 5 B :** conforme au guide HAS (voir m2 pour la localisation).
- **Variantes (règle 5) :** sur les 4 formats, le texte 2009 et le texte 2026 ne diffèrent que par la ligne d'UE ; le reste n'est qu'un reflux de mise en page. Aucune UE 2.11 ou 4.4 dans la variante 2026, aucune UE B.x dans la variante 2009. UE 2.11 « Pharmacologie et thérapeutiques » (S1, S3, S5) et UE 4.4 « Thérapeutiques et contribution au diagnostic médical » (S2, S4, S5) : conformes au référentiel de 2009. Un titre Vuibert (« S'entraîner aux calculs de doses et de débits — IFSI UE 4.4 et 2.11 ») confirme aussi ce rattachement. Le référentiel de chaque variante est contrôlé contre l'entrée de compilation (`main.typ` l. 75).
- **`contenu.csv` :** les 10 éléments décrivent exactement le PDF. Ligne d'UE, méthode en 4 étapes, conversions, concentrations et reconstitution, poids, débits, PSE, règle d'arrondi, 5 B et never events y sont. Il y a bien 9 encadrés « Exemple » et 6 pièges, et les Produits A à F. Le fichier peut servir à l'annonce. Si la ligne 2026 change (M2, m10), l'élément 1 reste exact.
- **Cartes :** les 17 cartes concordent avec la fiche. Une seule va plus loin (« lire l'emballage », voir m3).
- **Droits :** pas de reprise textuelle repérée ; exemples construits, aucune question d'examen.
- **Forme :** le build (copie du dépôt) passe tous les contrôles : polices, métadonnées, pages (1/1/1/3), débordement, 3 mentions, N&B sans couleur, tablette en paysage avec 12 liens et 10 signets. Rendus vérifiés : rien de coupé, l'encadré « Arrondis » de la tablette tient sur la p. 3, et les unités composées ne sont pas coupées (gluon après « / »).
- **Statut :** « PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE INFIRMIÈRE » est en tête. `data/revues.csv` ne contient aucune ligne FR01. Le périmètre de la relecture (calculs, sécurité, arrondis, clarté ; conventions françaises et UE adossées aux sources) est conforme à la décision de Tristan (voir m8 pour une précision). Les champs de décision sont désignés (sauf gouttes, m5). La version v1 et le fichier à relire sont indiqués.

### Sécurité clinique : Produits A à F face aux préparations courantes en France

| Produit | Valeurs | Comparaison | Avis |
|---|---|---|---|
| A | 64 mg/2 mL (32 mg/mL), 28 mg | Aucune ampoule courante à 32 mg/mL connue. | OK |
| B | 36–48 mg/kg/j toutes les 6 h, 20 kg, 210 mg | N'égale aucune fourchette connue (paracétamol 60 mg/kg/j en 4 prises ; ibuprofène 20–30 mg/kg/j). Reste dans l'étendue de plusieurs anti-infectieux. Non contrôlé en R01 (M1). | OK, à confirmer par la relectrice |
| C | 1,2 % (12 mg/mL), 30 mg | Aucune spécialité courante à 1,2 %. Écho lidocaïne 1–2 % et never event n° 13 (m9). | OK, écho à nommer |
| D | 135 mg/45 mL (3 mg/mL), 5,6 mg/h au PSE | Aucune préparation de PSE courante à 3 mg/mL trouvée (recherche non concluante). Zone de dose des sédatifs et opioïdes en mg/h (m9). La seringue dure environ 24 h (135 ÷ 5,6). | OK, écho à nommer |
| E | 1,4 g + 6,2 mL ⇒ 7 mL (200 mg/mL), 320 mg | Aucun flacon de 1,4 g courant ; contrôlé en R01. | OK |
| F | 55 mg/50 mL (1 100 µg/mL), 4,5 µg/kg/min | Ni dopamine ni dobutamine (préparations courantes en seringue de 50 mL : 4 à 5 mg/mL). Écho possible avec le nitroprussiate (non vérifié). Concentration non contrôlée en R01 (M1). | OK, à confirmer par la relectrice |

Aucune valeur ne reproduit une préparation et une posologie réelles à l'identique. Aucune dose d'héparine, d'insuline, d'amiodarone ou de KCl n'apparaît.

## Points `A-VERIFIER` : avis

| Point | Avis | Bloque la publication ? |
|---|---|---|
| Décisions de la relectrice sur les arrondis : `debit_pas` (point 1), gouttes au plus proche (2, voir m5), graduations et capacité des seringues (3, voir m4), poids (4), arrondi unique (5) | Sécurité de dose | **Oui** |
| `EXERCICE` : échos des Produits A à F (point 9), après correction de M1 et ajout de m9 | Règle 11 | **Oui** (confirmation de la relectrice) |
| Mention de pied de page « contenu vérifié et validé par le vendeur » | Exacte seulement après la relecture | **Oui** (blocage documentaire, l'orchestrateur le fait respecter) |
| `RISPAIL_2017` (6 lignes) : pages et contenu | Ces lignes portent la méthode, la conduite hors fourchette, la reconstitution, le PSE et les arrondis | **Oui**, tant que la relectrice n'a pas validé les points correspondants ; les pages se complètent ensuite sans bloquer |
| `SRC_IFSI_2026` : annexe III de l'arrêté du 20 février 2026 | B.3 est confirmée par l'art. 23 de l'arrêté et la CFVU de l'UBE (contenu « calculs de doses »). Code et intitulé de B.4 sont confirmés par l'UBE, son rattachement par l'éditeur seul, sous « notamment ». Ces sources suffisent pour afficher B.3 et B.4, **à condition** de les ajouter à `references.csv` (m10) et de corriger le statut (M2). Sinon, afficher un intitulé générique (« Référentiel 2026, entrant.e.s à partir de septembre 2026 ») sans numéro d'UE. | Non, sous ces conditions |
| `SRC_IFSI_2009` : fiches pédagogiques des UE 2.11 et 4.4 | Numéros, intitulés et semestres sont justes ; le rattachement est confirmé par deux éditeurs | Non |
| `ISO_8536_4`, `ISO_8536_5`, `ISO_7886_1` : édition et paragraphe | Valeurs universelles (20 et 60 gouttes/mL ; 1 mL au 0,01), validées en tant que valeurs par la relectrice. ISO 8536-5 vise les perfuseurs **à burette** : « microgouttes » sans burette n'est pas couvert par cette norme | Non |
| `PH_EUR_GN` : paragraphe 1.2, 11e édition | Définition standard | Non |
| `HAS_ADM_2011` : 5 B (levé, m2) ; partie 2, « prescription incomplète » (localisation) | Principe générique | Non |
| `ANSM_NEVER_EVENTS` | Vérifié (n° 2 et n° 11, mise à jour du 18.09.2025) | Levé |

### Ce que je n'ai pas pu vérifier
- Annexe III de l'arrêté du 20 février 2026 : la copie FHF du texte ne la contient pas, et je ne l'ai pas trouvée en ligne. La page formations.ube.fr citée par le producteur n'a pas été ouverte ; j'ai utilisé la délibération CFVU de l'UBE à la place.
- Le texte des normes NF EN ISO 8536-4, 8536-5 et 7886-1 (payantes) ; le paragraphe de la Ph. Eur.
- Les pages et le contenu de Rispail et Viaux (livre non accessible) ; je n'ai pas ouvert la page Elsevier qui associe l'ISBN 978-2-294-75628-3 à la 4e éd. 2017 (l'URL existe sur la boutique).
- La localisation, dans la partie 2 du guide HAS, de « prescription incomplète ou illisible ».
- Les préparations françaises de nitroprussiate, de midazolam et des autres médicaments administrés en mg/h au PSE : je me suis fondé sur des connaissances générales, sans recherche concluante.
- Les titres Chevillotte (Elsevier Masson) cités pour la variante 2009 : je ne les ai pas rouverts (deux titres Vuibert suffisent à confirmer).

## Script de recalcul

Lancé par `python3 -I recalcul_fr01.py /home/claude/mindshelf <FR01-2009-a4.txt> <FR01-2026-a4.txt>` (textes des PDF A4 livrés, `pdftotext` sans `-layout`). Arithmétique décimale exacte, arrondi au plus proche (demi-supérieur).

```python
#!/usr/bin/env python3
"""Vérificateur R02 : recalcul indépendant de FR01 (variantes 2009 et 2026).

Usage : python3 -I recalcul_fr01.py <racine_depot> <texte_a4_2009.txt> <texte_a4_2026.txt>
(textes obtenus par `pdftotext` sans -layout sur les PDF A4 livrés)

1. recalcule chaque ligne de donnees/exemples.csv en décimal exact (évaluateur limité à + - * / et parenthèses) ;
2. contrôle formule (pas de ** ni de fonction), entrées sans notation exponentielle, colonne arrondi ;
3. arrondi au plus proche (demi-supérieur) de la seule valeur réglée ou prélevée, et contrôle du pas réel
   (seringue 0,01 / 0,1 mL ; débit 0,1 mL/h ; gouttes entières) d'après donnees/valeurs.csv ;
4. enchaînements : la sortie exacte d'une étape est reprise telle quelle à l'étape suivante ;
5. règle 11 : un nom de produit = une seule préparation ;
6. concordance : chaque valeur affichée attendue figure dans le texte des deux PDF A4 ; chaque nombre du PDF
   provient des données ;
7. variantes : seule la ligne d'UE diffère entre les deux textes ; aucune UE d'un référentiel dans l'autre.
"""
import ast
import csv
import json
import re
import sys
from decimal import Decimal, ROUND_HALF_UP, getcontext
from pathlib import Path

getcontext().prec = 40
RACINE = Path(sys.argv[1])
T09 = Path(sys.argv[2]).read_text(encoding="utf-8")
T26 = Path(sys.argv[3]).read_text(encoding="utf-8")
D = RACINE / "produits" / "FR01" / "donnees"
constats = []


def evalue(formule, env):
    def ev(n):
        if isinstance(n, ast.Expression):
            return ev(n.body)
        if isinstance(n, ast.Constant) and isinstance(n.value, (int, float)):
            return Decimal(repr(n.value))
        if isinstance(n, ast.Name):
            return Decimal(repr(env[n.id]))
        if isinstance(n, ast.BinOp) and isinstance(n.op, (ast.Add, ast.Sub, ast.Mult, ast.Div)):
            a, b = ev(n.left), ev(n.right)
            return {ast.Add: a + b, ast.Sub: a - b, ast.Mult: a * b, ast.Div: a / b}[type(n.op)]
        raise ValueError(f"opération interdite : {ast.dump(n)}")
    return ev(ast.parse(formule, mode="eval"))


def arr(x, n):
    return x.quantize(Decimal(1).scaleb(-n), rounding=ROUND_HALF_UP)


def fr(x):
    """Écriture française sans zéro final : 0.875 -> 0,875 ; 125.0 -> 125."""
    s = format(x.normalize(), "f")
    return s.replace(".", ",")


val = {l["cle"]: Decimal(l["valeur"]) for l in csv.DictReader(open(D / "valeurs.csv", encoding="utf-8"))}
ex = {}
print("== 1-3. exemples.csv (décimal exact)")
for l in csv.DictReader(open(D / "exemples.csv", encoding="utf-8", newline="")):
    e = json.loads(l["entrees_json"])
    if re.search(r"[eE][+-]?\d", l["entrees_json"]):
        constats.append((l["id"], "notation exponentielle"))
    if re.search(r"\*\*|[A-Za-z_]+\(", l["formule"]):
        constats.append((l["id"], "formule hors + - * / ( )"))
    calc = evalue(l["formule"], e)
    att = Decimal(l["resultat_attendu"])
    tol = Decimal(l["tolerance"] or "0")
    ok = abs(calc - att) <= tol
    n = int(l["arrondi"])
    r = arr(calc, n)
    ex[l["id"]] = dict(l, e=e, calc=calc, r=r, n=n)
    print(f"{l['id']:6} {l['formule']:22} = {calc:.10f}  attendu {att}  écart {abs(calc-att):.1e}  "
          f"{'OK' if ok else 'ÉCART'}  ⇒ affiché {fr(r)} {l['unite']}")
    if not ok:
        constats.append((l["id"], f"écart {calc} vs {att}"))

# pas réels des valeurs réglées ou prélevées
pas = {
    "EX01": val["seringue_petite_pas"], "EX03B": val["seringue_std_pas"], "EX04B": val["seringue_std_pas"],
    "EX06A": val["debit_pas"], "EX09B": val["debit_pas"], "EX10B": val["debit_pas"],
    "EX06B": Decimal(1), "EX07": Decimal(1),
}
print("\n== 3. pas réglables")
for i, p in pas.items():
    r = ex[i]["r"]
    sur_pas = (r / p) == (r / p).to_integral_value()
    print(f"{i:6} {fr(r):>8} {ex[i]['unite']:12} pas {fr(p):5} {'OK' if sur_pas else 'HORS PAS'}")
    if not sur_pas:
        constats.append((i, f"{r} hors pas {p}"))
if ex["EX01"]["r"] > val["seringue_petite"]:
    constats.append(("EX01", "volume > seringue de 1 mL"))
if Decimal(repr(ex["EX09A"]["e"]["V"])) > val["seringue_pse"]:
    constats.append(("EX09A", "volume > seringue PSE"))

print("\n== 4. enchaînements (sortie exacte reprise telle quelle)")
for src, dst, cle in [("EX03A", "EX03B", "N"), ("EX04A", "EX04B", "N"), ("EX09A", "EX09B", "N"), ("EX10A", "EX10B", "N")]:
    reprise = Decimal(repr(ex[dst]["e"][cle]))
    okc = reprise == ex[src]["calc"]
    print(f"{src} -> {dst}.{cle} : {ex[src]['calc']} / {reprise} {'OK' if okc else 'ÉCART'}")
    if not okc:
        constats.append((dst, "intermédiaire repris arrondi"))
for a, b, k in [("EX05A", "EX05B", "W"), ("EX06A", "EX06B", "V"), ("EX06A", "EX06B", "T"), ("EX08A", "EX08B", "V"), ("EX08A", "EX08B", "R")]:
    if ex[a]["e"][k] != ex[b]["e"][k]:
        constats.append((b, f"{k} différent de {a}"))
lo, hi, presc = ex["EX05A"]["calc"], ex["EX05B"]["calc"], ex["EX05C"]["calc"]
print(f"EX05 : {lo} ≤ {presc} ≤ {hi} : {'conforme' if lo <= presc <= hi else 'HORS FOURCHETTE'}")
w = Decimal(repr(ex["EX10B"]["e"]["W"]))
print(f"Poids EX10B {w} au pas {val['poids_pas']} : {'OK' if (w / val['poids_pas']) % 1 == 0 else 'HORS PAS'}")
# heure de fin
h = ex["EX08B"]["calc"]
hh, mm = int(h), int((h - int(h)) * 60)
print(f"EX08 : durée {ex['EX08A']['calc']} h ; fin {hh} h {mm:02d}")
# dose réellement délivrée après arrondi du débit (ordre de grandeur de l'écart)
for i, dose in [("EX09B", "P"), ("EX10B", None)]:
    r, c = ex[i]["r"], ex[i]["calc"]
    print(f"{i} : écart de dose dû à l'arrondi du débit = {((r - c) / c * 100):+.2f} %")

print("\n== 5. règle 11 : un nom par préparation")
prep = {}
for i, l in ex.items():
    m = re.search(r"Produit ([A-F])", l["enonce"])
    if m:
        prep.setdefault(m.group(1), set()).add(i[:4])
for k, s in sorted(prep.items()):
    print(f"Produit {k} : {sorted(s)} {'OK' if len(s) == 1 else 'PLUSIEURS PRÉPARATIONS'}")
    if len(s) != 1:
        constats.append((f"Produit {k}", "plusieurs préparations"))
mention = "valeurs d’exercice, pas des recommanda"
for nom, t in (("2009", T09), ("2026", T26)):
    t1 = t.replace("'", "’").replace("­\n", "").replace("­", "")
    if "valeurs d’exercice, pas des recommandations posologiques" not in t1.replace("\n", " "):
        constats.append((nom, "mention en tête absente"))
    n_titres = len(re.findall(r"\(Produit [A-F], valeurs d.exercice\)", t))
    print(f"{nom} : mention en tête OK ; titres d'exemples avec « valeurs d'exercice » : {n_titres}")

print("\n== 6. concordance PDF ↔ données")
attendus = set()
for i, l in ex.items():
    for v in l["e"].values():
        attendus.add(fr(Decimal(repr(v))))
    attendus.add(fr(l["r"]))
    if l["r"] != l["calc"]:
        attendus.add(fr(arr(l["calc"], l["n"] + 2)))
for v in val.values():
    attendus.add(fr(v))
attendus |= {"14", "00", "20", "15", "6", "1", "2", "3", "4", "5", "7", "8", "9", "10", "3", "2009", "2026"}
for nom, t in (("2009", T09), ("2026", T26)):
    corps = t.split("Rédaction assistée")[0]
    corps = re.sub(r"\((S\d(, S\d)*)\)", "", corps)          # semestres de la ligne d'UE
    corps = re.sub(r"UE [0-9AB]\.?\d+(\.\d+)?", "", corps)   # numéros d'UE
    corps = re.sub(r"20 février 2026", "", corps)
    nombres = re.findall(r"\d+(?:,\d+)?", corps)
    hors = sorted({x for x in nombres if x not in attendus})
    print(f"{nom} : {len(nombres)} nombres, hors données : {hors or 'aucun'}")
    manquants = sorted({fr(l['r']) for l in ex.values()} - set(nombres))
    print(f"{nom} : valeurs affichées attendues absentes du PDF : {manquants or 'aucune'}")

print("\n== 7. variantes")
d09 = [x for x in T09.splitlines() if x not in T26.splitlines()]
d26 = [x for x in T26.splitlines() if x not in T09.splitlines()]
print("Lignes propres à 2009 :", d09)
print("Lignes propres à 2026 :", d26)
if re.search(r"UE [BC]\.\d", T09):
    constats.append(("2009", "UE du référentiel 2026"))
if re.search(r"UE [2-6]\.\d+", T26):
    constats.append(("2026", "UE du référentiel 2009"))

print("\n== Constats du script :", constats or "aucun")
```

### Sortie

```
== 1-3. exemples.csv (décimal exact)
EX01   D * Q / H              = 0.8750000000  attendu 0.875  écart 0.0e-2  OK  ⇒ affiché 0,88 mL
EX02A  G * K                  = 75.0000000000  attendu 75  écart 0.0e-2  OK  ⇒ affiché 75 mg
EX02B  M * K                  = 400.0000000000  attendu 400  écart 0.0e+0  OK  ⇒ affiché 400 µg
EX03A  P * K / C              = 12.0000000000  attendu 12  écart 0.0e+0  OK  ⇒ affiché 12 mg/mL
EX03B  O / N                  = 2.5000000000  attendu 2.5  écart 0.0e+0  OK  ⇒ affiché 2,5 mL
EX04A  G * K / F              = 200.0000000000  attendu 200  écart 0.0e+0  OK  ⇒ affiché 200 mg/mL
EX04B  O / N                  = 1.6000000000  attendu 1.6  écart 0.0e+0  OK  ⇒ affiché 1,6 mL
EX05A  L * W                  = 720.0000000000  attendu 720  écart 0.0e+1  OK  ⇒ affiché 720 mg/j
EX05B  U * W                  = 960.0000000000  attendu 960  écart 0.0e+1  OK  ⇒ affiché 960 mg/j
EX05C  O * J / I              = 840.0000000000  attendu 840  écart 0.0e+1  OK  ⇒ affiché 840 mg/j
EX06A  V / T                  = 125.0000000000  attendu 125  écart 0.0e+1  OK  ⇒ affiché 125 mL/h
EX06B  V * DF / (T * M)       = 41.6666666667  attendu 41.6666666667  écart 3.3e-11  OK  ⇒ affiché 42 gouttes/min
EX07   V * DF / (T * M)       = 25.0000000000  attendu 25  écart 0.0e+1  OK  ⇒ affiché 25 gouttes/min
EX08A  V / R                  = 6.2500000000  attendu 6.25  écart 0.0e-1  OK  ⇒ affiché 6,25 h
EX08B  S + V / R              = 20.2500000000  attendu 20.25  écart 0.0e-1  OK  ⇒ affiché 20,25 h
EX09A  Q / V                  = 3.0000000000  attendu 3  écart 0.0e+1  OK  ⇒ affiché 3 mg/mL
EX09B  P / N                  = 1.8666666667  attendu 1.8666666667  écart 3.3e-11  OK  ⇒ affiché 1,9 mL/h
EX10A  D * K / V              = 1100.0000000000  attendu 1100  écart 0.0e+1  OK  ⇒ affiché 1100 µg/mL
EX10B  O * W * M / N          = 18.7527272727  attendu 18.7527272727  écart 2.7e-11  OK  ⇒ affiché 18,8 mL/h

== 3. pas réglables
EX01       0,88 mL           pas 0,01  OK
EX03B       2,5 mL           pas 0,1   OK
EX04B       1,6 mL           pas 0,1   OK
EX06A       125 mL/h         pas 0,1   OK
EX09B       1,9 mL/h         pas 0,1   OK
EX10B      18,8 mL/h         pas 0,1   OK
EX06B        42 gouttes/min  pas 1     OK
EX07         25 gouttes/min  pas 1     OK

== 4. enchaînements (sortie exacte reprise telle quelle)
EX03A -> EX03B.N : 12.0 / 12 OK
EX04A -> EX04B.N : 200.0 / 200 OK
EX09A -> EX09B.N : 3 / 3 OK
EX10A -> EX10B.N : 1100 / 1100 OK
EX05 : 720 ≤ 840 ≤ 960 : conforme
Poids EX10B 76.4 au pas 0.1 : OK
EX08 : durée 6.25 h ; fin 20 h 15
EX09B : écart de dose dû à l'arrondi du débit = +1.79 %
EX10B : écart de dose dû à l'arrondi du débit = +0.25 %

== 5. règle 11 : un nom par préparation
Produit A : ['EX01'] OK
Produit B : ['EX05'] OK
Produit C : ['EX03'] OK
Produit D : ['EX09'] OK
Produit E : ['EX04'] OK
Produit F : ['EX10'] OK
2009 : mention en tête OK ; titres d'exemples avec « valeurs d'exercice » : 6
2026 : mention en tête OK ; titres d'exemples avec « valeurs d'exercice » : 6

== 6. concordance PDF ↔ données
2009 : 151 nombres, hors données : aucun
2009 : valeurs affichées attendues absentes du PDF : ['20,25']
2026 : 149 nombres, hors données : aucun
2026 : valeurs affichées attendues absentes du PDF : ['20,25']

== 7. variantes
Lignes propres à 2009 : ['Référentiel 2009 : UE 2.11 « Pharmacologie et thérapeutiques » (S1, S3, S5)', 'et UE 4.4 « Thérapeutiques et contribution au diagnostic médical » (S2,', 'S4, S5).']
Lignes propres à 2026 : ['Référentiel 2026 (arrêté du 20 février 2026, entrant.e.s à partir de sep\xad', 'tembre 2026) : calculs de doses travaillés notamment en UE B.3 « Pra\xad', 'tiques et interventions infirmières » et UE B.4 « Démarche qualité et ges\xad', 'tion des risques ».']

== Constats du script : aucun
```

20,25 h n'apparaît pas tel quel : c'est voulu, la fiche l'affiche en heure d'horloge (« fin à 20 h 15 »).

## Sources consultées (29.10.2026)
- Arrêté du 20 février 2026 relatif au diplôme d'État d'infirmier, copie FHF : https://www.fhf.fr/sites/default/files/2026-02/Arr%C3%AAt%C3%A9%20r%C3%A9ing%C3%A9nierie%20formation%20IDE.pdf (art. 23, 59, 60 ; annexe III absente)
- UBE, délibération CFVU du 16.06.2026, réforme du diplôme infirmier : https://www.ube.fr/wp-content/uploads/2026/07/CA_07072026_delib11_commission_CFVU_16juin2026_reforme_diplome_infirmier.pdf
- Vuibert, *Réussir tout le calcul de doses…*, 3e éd., 17.09.2026, ISBN 978-2-311-66553-6 : https://www.livres-medicaux.com/de/65190-reussir-tout-le-calcul-de-doses-en-30-fiches-de-revision-et-75-entrainements-nouveau-referentiel-i.html
- ANSM, « Never events » : https://ansm.sante.fr/documents/reference/never-events
- HAS, guide « Outils de sécurisation et d'auto-évaluation de l'administration des médicaments », partie 1 : https://has-sante.fr/upload/docs/application/pdf/2011-10/guide_outils_securisation_autoevaluation_administration_medicaments_partie1_comprendre.pdf
- Elsevier, Rispail et al., 5e éd. 2024 : https://shop.elsevier.com/books/guide-du-calcul-de-doses-et-de-debits-medicamenteux/rispail/978-2-294-78300-5
