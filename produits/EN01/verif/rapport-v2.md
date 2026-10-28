# Vérification EN01-STD : Dosage Calculation & IV Drip Rates (rapport v2, contre-vérification)

- **Run :** R01, agent VÉRIFICATEUR (sans participation à la production ni à la correction), 28.10.2026, 13:57–14:05
- **Objet :** correction v2 de `produits/EN01/` (données, `src/main.typ`, `livraison/EN01-STD/`, `donnees/statut-methode.md`). Risque IA **FORT**, relecture infirmière obligatoire, Whop uniquement.
- **Périmètre (budget 15 min) :** levée des constats v1, sécurité clinique (règle 11, arrondis), recalcul, références modifiées, statut de la méthode, build. Pas de seconde vérification complète du reste.
- **Méthode :** lecture des données et du Typst ; texte du PDF A4 livré (pdftotext) et rendu PNG à 110 dpi ; rendu N&B et tablette ; `python3 scripts/build.py EN01-STD` lancé dans une copie du dépôt (pour n'écrire que dans `verif/`), puis comparaison du texte des 4 PDF reconstruits avec celui des 4 PDF livrés : **identiques** ; script de recalcul v2 (ci-dessous) ; recherches web ciblées (préparations réelles, Morris, Joint Commission).

## Verdict : **OK avec réserves**

Les deux BLOQUANTS et les trois MAJEURS de la v1 sont levés dans les données, dans le Typst et dans le PDF A4. Les 22 lignes sont recalculées à l'identique. Chaque valeur réglée ou prélevée tombe sur son pas. Chaque nom Drug A à F désigne une seule préparation. La règle d'arrondi est la même dans la fiche, les cartes Anki, `valeurs.csv` et `references.csv`. Le build passe tous les contrôles.

Il ne reste aucun BLOQUANT dans le produit. Les réserves portent sur trois points :
1. **La relecture infirmière.** Elle reste obligatoire avant toute publication. Le profil prévu (infirmière suisse) ne couvre pas les conventions US de la fiche (N1, MAJEUR, constat de processus).
2. **Neuf constats MINEURS de forme ou de citation.** Il faut corriger avant le dépôt la coupure des unités (N4), l'encadré coupé de la tablette (N6) et la mention trop éloignée des exemples (N5).
3. **Un écho clinique résiduel.** Les 360 mg de Drug E rappellent l'amiodarone (N2). Ce n'est pas une préparation équivalente, mais la relectrice doit trancher.

| Gravité | Constats v1 restés ouverts | Nouveaux constats |
|---|---|---|
| BLOQUANT | 0 | 0 |
| MAJEUR | 0 | 1 (N1, processus de relecture) |
| MINEUR | 2 (m10, m11, ouverts volontairement : A-VERIFIER) | 9 (N2 à N10) |

## Constats v1 : levés ou non

| # v1 | Gravité v1 | État | Vérification v2 (données / Typst / PDF A4) |
|---|---|---|---|
| B1 | BLOQUANT | **Levé** | `exemples.csv` : nouvelles valeurs pour Drug A à F. `main.typ` l. 121 et PDF A4 en tête : « Drugs A–F and their numbers: exercise values, not dosing guidance. » La note héparine/insuline est passée au § 10 (l. 280), sans dose, loin de Drug F (trois sections plus bas), sourcée `ISMP_HIGH_ALERT` 2024. Aucune concentration ni dose ne reproduit une préparation standard ou un protocole courant (voir « Sécurité clinique »). Restent un écho (N2) et une mention unique trop éloignée des exemples (N5). |
| B2 | BLOQUANT | **Levé** | Un nom par préparation : A (EX01), B (EX03), C (EX06B), D (EX07), E (EX08), F (EX09). Les noms ne sont repris que dans les enchaînements voulus, avec la même préparation (contrôles `meme()` l. 91–95 du Typst et § 3–4 du script). Aucun « Drug X » ni « Drug W » dans les sources, le PDF, les cartes ou le paquet Anki. |
| M1 | MAJEUR | **Levé** (réserve N3) | Règle unique : poids consigné à `poids_pas` = 0.1 kg puis utilisé tel quel, concentrations et intermédiaires non arrondis, seule la valeur réglée ou prélevée est arrondie. Elle est appliquée dans l'énoncé EX02A, en EX08B (76.4 kg) et en EX09B (608 units/h non arrondi), dans l'encadré et le piège du § 8, dans la carte « When do you round? » et dans `references.csv`. Aucune contradiction. Seul le titre de l'encadré reste maladroit (N3). |
| M2 | MAJEUR | **Levé** (chapitres et pages A-VERIFIER) | Les 7 lignes citent `MORRIS_2022`. Titre, 8e édition, Elsevier, ISBN 978-0-323-69695-1 et découpage en unités sont confirmés sur la page Elsevier (parution 30.09/11.11.2021). Deux corrections de citation : l'intitulé de l'Unit Four est tronqué, et une 9e édition existe (N7). |
| M3 | MAJEUR | **Levé** (blocage documentaire) | `statut-methode.md` porte en tête « PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE INFIRMIÈRE ». `data/revues.csv` ne contient que la ligne VERIF_AUTO A_CORRIGER, et `data/publications.csv` aucune ligne EN01. Le blocage reste purement documentaire : l'orchestrateur doit le faire respecter. |
| m1 | MINEUR | Levé | `notation.csv` l. 7, PDF § 9 et carte : « Read as u (units) ». |
| m2 | MINEUR | Levé | ISMP_ABBR © 2024, date de consultation indiquée. |
| m3 | MINEUR | Levé dans le fichier, **non vérifiable** | MM.14.01.01 et IM.13.01.01 (Accreditation 360) sont reportés, avec l'ancienne numérotation. Aucune source en ligne trouvée pour les confirmer (manuel payant) : A-VERIFIER. |
| m4 | MINEUR | Levé | « Percentage Concentrations », 8.140. L'édition en vigueur reste A-VERIFIER. |
| m5 | MINEUR | Levé | La valeur exacte est rattachée à la définition de 1959 (NIST HB 44, App. C), et la ligne précise que B.8 l'arrondit. L'édition de HB 44 reste A-VERIFIER. |
| m6 | MINEUR | Levé | Piège § 3 : « compare per day or per dose, like with like ». |
| m7 | MINEUR | Levé | En-tête : « NIST (exact, rounded) ». |
| m8 | MINEUR | Levé en substance | Le piège commence par « Mosteller's 3,600 » et suit l'exemple BSA. La section reste à cheval sur deux colonnes en A4, Letter et N&B (titre et formule en bas de la colonne 1). Acceptable. |
| m9 | MINEUR | Levé | `#v("C02", "G")` (l. 222). |
| m10 | MINEUR | Non levé, volontairement | USP <7> non localisé (statut point 10). A-VERIFIER, non bloquant. |
| m11 | MINEUR | Non levé | Section FDA 2011 toujours absente. A-VERIFIER, non bloquant. |

## Sécurité clinique

### Préparations Drug A à F face aux préparations et protocoles réels

| Préparation | Valeurs v2 | Comparaison | Avis |
|---|---|---|---|
| Drug A | 32 mg/mL, 28 mg | Aucune forme injectable courante à 32 mg/mL connue (le 32 mg de la méthylprednisolone est un comprimé). | OK |
| Drug B | 17–33 mg/kg/jour toutes les 8 h, 20 kg | Proche sans être égal à l'ancienne fourchette de l'amoxicilline (20–40 mg/kg/jour toutes les 8 h), qui était la valeur v1. | OK, à confirmer par la relectrice (point 11) |
| Drug C | 92 mg/m² | Aucune posologie standard égale (oxaliplatine 85, daunorubicine 90, épirubicine 90/100 mg/m²). | OK |
| Drug D | 1.4 g + 6.2 mL ⇒ 7 mL (200 mg/mL) | Pas de flacon de 1.4 g courant ; reconstitutions réelles différentes (ceftriaxone 1 g/3.6 mL, cefazoline 1 g/2.5 mL). | OK |
| Drug E | 360 mg/300 mL (1,200 mcg/mL), 4.5 mcg/kg/min | Pas d'équivalent dopamine (800/1,600/3,200 mcg/mL) ni dobutamine (1,000/2,000/4,000). **Écho :** 360 mg est la quantité du prémélange d'amiodarone Nexterone (360 mg/200 mL, 1.8 mg/mL) et la charge de 6 h classique. La concentration et l'unité de dose diffèrent. | N2 (MINEUR) |
| Drug F | 30,000 units/400 mL (75 units/mL), 9.5 units/kg/h | Pas d'équivalent héparine (25,000/250, 25,000/500, 100 ou 50 units/mL ; 12 ou 18 units/kg/h). 9.5 units/kg/h se situe toutefois dans la zone des débits d'héparine : rien de vérifié pour les protocoles « basse intensité » à environ 10 units/kg/h (recherche non concluante). Sans rapport avec l'insuline (environ 0.1 units/kg/h). | OK, à confirmer par la relectrice (point 11) |

La règle 11 est respectée : chaque préparation a un nom distinct, la mention figure dans la fiche (son emplacement fait l'objet de N5), et le seul médicament réel cité (héparine IV, insuline) apparaît dans une note sourcée, sans dose.

### Enchaînements et arrondi unique
- EX07A → EX07B, EX08A → EX08B, EX09A → EX09C et EX09B → EX09C : chaque fois, la sortie exacte de l'étape précédente est reprise telle quelle (script § 3). EX02B → EX03 : 20 kg consigné.
- Tous les poids d'entrée sont au pas de 0.1 kg (20, 54, 76.4, 64). Aucun n'est arrondi une seconde fois.
- Valeurs réglées ou prélevées : 0.88 mL (pas 0.01), 1.6 mL (pas 0.1), 125, 17.2 et 8.1 mL/h (pas 0.1), 42 et 100 gtt/min (entier). Aucune valeur intermédiaire n'est arrondie, ni dans la fiche ni dans les données.

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| N1 | MAJEUR (processus) | `data/produit_relecteurs.csv` (EN01 → INFIRMIERE_CH) ; `statut-methode.md` | La relectrice prévue est une infirmière exerçant en Suisse. Plusieurs points à trancher relèvent de la pratique et de l'examen US (NCLEX) : horloge 12 h ou 24 h (point 8), précision des pompes du public US (1), graduations des seringues US (3), convention de poids attendue à l'examen (4), cinq droits enseignés (14), équivalents ménagers « course » (16), TJC et ISMP (13–15). Sans ressource US, sa validation ne couvrira pas ces points, et le pied de page « checked and approved » resterait en partie inexact. | Adjoindre un.e relecteur.rice formé.e à la pratique US (RN ou enseignant.e NCLEX). Ou bien écrire dans `statut-methode.md` ce que la relectrice suisse valide (calculs, sécurité, arrondis) et ce qui reste adossé aux sources US, chapitre et page relevés. |
| N2 | MINEUR | EX08A (Drug E), PDF § 7 | 360 mg reproduit la quantité d'un prémélange réel d'amiodarone (360 mg/200 mL) et la dose de charge de 6 h. Concentration et unité différentes : il n'y a pas de préparation équivalente, mais `statut-methode.md` affirme qu'aucune valeur n'évoque un protocole réel. | Choisir une quantité sans écho (par exemple 330 mg/300 mL = 1,100 mcg/mL ⇒ 18.752 ⇒ 18.8 mL/h) ou poser la question nommément à la relectrice (point 11). |
| N3 | MINEUR | PDF § 8, titre de l'encadré (`main.typ` l. 256) | Le titre « Round once, at the end » contredit la première puce, qui arrondit le poids dès le départ (EX02A : 19.958 ⇒ 20 kg). La conduite reste claire, la puce étant explicite. | « Round only what you record, set or draw up ». |
| N4 | MINEUR | PDF A4 § 3 (« 495 mg/ ⏎ day ») ; tablette § 5 (« mg/ ⏎ m² »), § 7 (« mcg/kg/ ⏎ min », « mL/ ⏎ h ») | Des unités de dose composées sont coupées en fin de ligne après « / ». La lecture de l'unité ralentit, ce qui va contre l'esprit du § 9. Non détecté par `controle_pdf`. | Rendre les unités insécables : `box`, ou U+2060 après « / », dans `res()`, `v()` et les formules. |
| N5 | MINEUR | A4 colonne 2 ; tablette p. 2–3 | La mention « exercise values, not dosing guidance » n'apparaît qu'une fois, en tête de la page 1. Les exemples Drug E et F (colonne 2 de l'A4) et C à F (tablette, p. 2) en sont loin. Une capture d'écran de ces exemples la perd. La règle 11 demande la mention « près des exemples ». | Ajouter « exercise values » au titre des exemples Drug E et Drug F, ou en en-tête courant de la tablette. |
| N6 | MINEUR | Tablette p. 2 → 3 | L'encadré « Round once, at the end » est coupé : titre et puce « Weight » en bas de la p. 2, gouttes, pompe et seringues en haut de la p. 3. Le piège du § 3 ouvre seul la p. 2. Ce sont les règles d'arrondi qui sont scindées. | Rendre l'encadré non sécable (`breakable: false`) et garder chaque piège avec sa section. |
| N7 | MINEUR | `references.csv`, 7 lignes `MORRIS_2022` | L'intitulé de l'Unit Four est tronqué : le vrai titre est « Oral and Parenteral Dosage Forms, Insulin and Pediatric Dosage Calculations ». Celui de l'Unit Five se termine par « … and Pediatric Dosage Calculations ». Une 9e édition existe (ISBN 978-0-443-12732-8). La table des matières en ligne donne les chapitres. | Corriger les intitulés et ajouter les chapitres : 13–15 (méthodes), 7 et 24 (lb/kg, poids), 24 (fourchette sûre), 20–21 (perfusions, facteurs de goutte), 18 (reconstitution), 17 (seringues), 2 et 16–17, 21 (arrondis). Faire noter par la relectrice l'édition sur laquelle elle vérifie. |
| N8 | MINEUR | Pied de page « v1 » (`data/variantes.csv`) | Le PDF corrigé porte le même numéro de version que celui du rapport v1 (Drug X et W, valeurs réelles). `revues.csv` ne permettra pas de distinguer la version relue. | Passer EN01-STD en v2 avant l'envoi à la relectrice (statut point 18). |
| N9 | MINEUR | `valeurs.csv` ; statut point 2 | Le mode d'arrondi (au plus proche, à partir de .5) est implicite dans le code (`calc.round`). Aucun champ ne reçoit la décision de la relectrice sur les gouttes, alors que `pompe_pas` et `poids_pas` existent. | Ajouter une clé `arrondi_mode` (ou `gtt_arrondi`) lue par `main.typ`, et y renvoyer au point 2. |
| N10 | MINEUR (rappel) | `donnees/brief-whop.md` | Le texte de vente annonce « heparin units/h » : c'est inexact depuis la v2. Déjà listé (statut point 17). | À corriger avant le dépôt, comme condition de publication. |

## A-VERIFIER restants

| Point | Avis | Bloque la publication ? |
|---|---|---|
| Décisions de relecture sur les arrondis : `pompe_pas` (point 1), gouttes au plus proche (2, voir N9), graduations des seringues (3), convention du poids (4), arrondi unique (5) | Sécurité de dose | **Oui** |
| Point 11 : aucune valeur Drug A à F n'évoque un protocole réel, en nommant 360 mg (amiodarone, N2), 9.5 units/kg/h (zone héparine) et 17–33 mg/kg/jour toutes les 8 h (proche de l'amoxicilline) | Règle 11 | **Oui** (confirmation de la relectrice) |
| `MORRIS_2022` : chapitres et pages (7 lignes) | Ces lignes portent les méthodes, la conduite hors fourchette, les facteurs de goutte, les seringues et les arrondis | **Oui**, tant que la relectrice n'a pas validé les points correspondants. Les pages peuvent ensuite être complétées sans bloquer. |
| Couverture US de la relecture (N1) | Sans elle, la mention « checked and approved » ne vaut que pour une partie de la fiche | **Oui** (au minimum, périmètre écrit) |
| `TJC_MM` : libellé de MM.14.01.01 et liste des EP (2 lignes) | Le contenu (éléments d'une prescription complète) est générique et juste ; seule la localisation est en cause | Non |
| `TJC_DNU` : IM.13.01.01 | La liste « Do Not Use » est publique et stable | Non |
| `USP_GN` : intitulé 8.140 dans l'édition en vigueur | Citation | Non |
| `NIST_SP811_2008` : édition de HB 44 | La valeur est exacte par définition | Non |
| `FDA_OTC_DEVICES_2011` : section (m11) | La note est déjà portée par NCPDP 2014 | Non |
| m10 : USP <7>, 1:1000 sur les étiquettes US | Ajout facultatif | Non |
| Points 8 (horloge 24 h) et 16 (cup 240 ou 250 mL) | Conventions de cours, sans risque de dose | Non |

### Ce que je n'ai pas pu vérifier
- Joint Commission MM.14.01.01 et IM.13.01.01 (Accreditation 360) : rien en ligne, manuel payant. Je n'ai pas pu confirmer la renumérotation reprise du rapport v1.
- Morris : je n'ai vérifié ni les pages ni le contenu des chapitres (livre non accessible). Seuls l'édition, l'ISBN, les titres d'unités et la table des chapitres sont confirmés.
- Je n'ai pas re-vérifié en v2 l'ISMP « cc » (vérifié en v1) ni l'intitulé USP 8.140 dans l'édition en vigueur.
- Édition de NIST HB 44 : non vérifiée. La valeur 0.45359237 kg est exacte par la définition de 1959.
- Protocoles d'héparine « basse intensité » autour de 10 units/kg/h : recherche non concluante.

## `statut-methode.md` : ce qui manque pour la relectrice

Le fichier dit clairement que la publication est bloquée jusqu'à la relecture infirmière, qu'aucun PDF ne doit circuler d'ici là, et il liste 16 points à relire, plus 2 points avant publication. Il manque :
1. **Le périmètre de la relectrice** face aux conventions US (N1).
2. **La forme de la validation :** quelle ligne écrire dans `data/revues.csv` (étape, acteur, statut, version), et où reporter chaque décision. Le fichier le dit pour les points 1 et 4, pas pour 2, 3 et 5 (voir N9).
3. **Les chapitres de Morris** déjà connus (N7), pour lui épargner la recherche, et l'édition sur laquelle elle vérifie.
4. **Les échos cliniques nommés** au point 11 (360 mg et amiodarone ; 9.5 units/kg/h et héparine ; 17–33 mg/kg/jour toutes les 8 h et amoxicilline). Le fichier affirme aujourd'hui qu'aucune valeur n'en évoque.
5. **Le fichier exact à relire et sa version** (N8). Le PDF livré à 13:55 est identique, au texte près, à celui que j'ai reconstruit.
6. Les constats N3 à N6, s'ils sont corrigés avant la relecture, pour qu'elle relise la version finale.

## Build

`python3 scripts/build.py EN01-STD`, lancé dans une copie du dépôt : 4 PDF fabriqués en 2 s. Tous les contrôles sont OK : polices, métadonnées, pages (1 / 1 / 1 / 3), pages blanches, débordement, 4 mentions, N&B sans couleur, tablette en paysage avec 12 liens et 10 signets. Le texte des 4 PDF reconstruits est identique à celui des 4 PDF livrés. Le paquet Anki ne contient aucune trace des anciennes valeurs (aucune occurrence de heparin, dopamine, Drug X ni 1,600).

## Script de recalcul (v2)

Lancé par `python3 -I recalcul_en01_v2.py /home/claude/mindshelf <texte_pdf_a4.txt>` (texte obtenu par `pdftotext` sans `-layout`). L'arithmétique est décimale exacte. Le script contrôle en plus les pas réglables, les enchaînements, le pas de consignation des poids et la règle 11.

```python
#!/usr/bin/env python3
"""Vérificateur R01, contre-vérification v2 d'EN01-STD.
Usage : python3 -I recalcul_en01_v2.py <racine_depot> <texte_pdf_a4.txt>
1. Recalcul indépendant de chaque ligne de donnees/exemples.csv (évaluateur restreint + - * / ( )).
2. Valeur affichée = arrondi demi-supérieur décimal à `arrondi` décimales ; contrôle que chaque valeur
   réglée/prélevée tombe sur le pas réglable de valeurs.csv (pompe_pas, seringue_*_pas, gtt entières).
3. Enchaînements : la sortie de A est l'entrée (non arrondie) de B ; poids utilisés tels que consignés (pas 0.1 kg).
4. Règle 11 : un nom « Drug X » par préparation ; un nom réutilisé seulement dans un enchaînement EXnnA→B→C
   avec la même concentration.
5. Concordance : chaque nombre du texte A4 se retrouve dans les données.
"""
import ast, csv, json, re, sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

RACINE, TXT = Path(sys.argv[1]), Path(sys.argv[2])
D = RACINE / "produits" / "EN01" / "donnees"
anomalies = []

def evalue(f, env):
    def ev(n):
        if isinstance(n, ast.Expression): return ev(n.body)
        if isinstance(n, ast.Constant) and isinstance(n.value, (int, float)): return Decimal(repr(n.value))
        if isinstance(n, ast.Name): return Decimal(repr(env[n.id]))
        if isinstance(n, ast.UnaryOp) and isinstance(n.op, ast.USub): return -ev(n.operand)
        if isinstance(n, ast.BinOp) and type(n.op) in (ast.Add, ast.Sub, ast.Mult, ast.Div):
            a, b = ev(n.left), ev(n.right)
            return {ast.Add: a + b, ast.Sub: a - b, ast.Mult: a * b, ast.Div: a / b}[type(n.op)]
        raise ValueError("opération interdite : " + ast.dump(n))
    return ev(ast.parse(f, mode="eval"))

def arr(x, n): return Decimal(x).quantize(Decimal(1).scaleb(-n), rounding=ROUND_HALF_UP)
def sans_zero(d): s = format(d, "f"); return s.rstrip("0").rstrip(".") if "." in s else s

lire = lambda nom: list(csv.DictReader(open(D / nom, newline="", encoding="utf-8")))
V = {l["cle"]: Decimal(l["valeur"]) for l in lire("valeurs.csv")}
EX = {l["id"]: l for l in lire("exemples.csv")}
nombres = set(); res = {}

print("== 1-2. Recalcul et arrondi")
for i, l in EX.items():
    e = json.loads(l["entrees_json"])
    c = evalue(l["formule"], e)
    att, tol = Decimal(l["resultat_attendu"]), Decimal(l["tolerance"] or "0")
    ecart = abs(c - att); ok = ecart <= tol + Decimal("1e-12")
    n = int(l["arrondi"]); r = arr(c, n); res[i] = (c, r, e, l)
    print(f"  {'OK ' if ok else 'ÉCART'} {i:6} calc={c:.10g} attendu={att} écart={ecart:.1e} tol={tol} → affiché {sans_zero(r)} {l['unite']}")
    if not ok: anomalies.append((i, f"écart {ecart} > tolérance {tol}"))
    for x in e.values(): nombres.add(Decimal(repr(x)))
    nombres.update({c, att, r}); nombres.update(arr(c, k) for k in range(6))

print("== 2b. Valeurs réglées / prélevées sur un pas réglable")
pas = {"mL/h": V["pompe_pas"], "gtt/min": Decimal(1), "kg": V["poids_pas"]}
seringue = {"EX01": V["seringue_petite_pas"], "EX07B": V["seringue_std_pas"]}
for i, (c, r, e, l) in res.items():
    p = seringue.get(i) or pas.get(l["unite"])
    if p is None: continue
    sur_pas = (r / p) == (r / p).to_integral_value()
    dec_ok = Decimal(1).scaleb(-int(l["arrondi"])) == p
    print(f"  {'OK ' if sur_pas and dec_ok else 'FAUX'} {i:6} {sans_zero(r)} {l['unite']} pas {sans_zero(p)} (arrondi={l['arrondi']})")
    if not (sur_pas and dec_ok): anomalies.append((i, f"pas {p} / arrondi {l['arrondi']} incohérents"))

print("== 3. Enchaînements (sortie non arrondie réutilisée telle quelle)")
liens = [("EX07A", "EX07B", "C"), ("EX08A", "EX08B", "C"), ("EX09A", "EX09C", "C"), ("EX09B", "EX09C", "N"),
         ("EX02B", "EX03A", "W")]
for a, b, k in liens:
    va, vb = res[a][0], Decimal(repr(res[b][2][k]))
    ok = abs(va - vb) < Decimal("1e-9")
    print(f"  {'OK ' if ok else 'FAUX'} {a} → {b}.{k} : {va:.10g} vs {vb}")
    if not ok: anomalies.append((b, f"{k} ≠ résultat de {a}"))
for i, k in [("EX03A", "W"), ("EX03B", "W"), ("EX06A", "W"), ("EX08B", "W"), ("EX09B", "W")]:
    w = Decimal(repr(res[i][2][k])); ok = (w / V["poids_pas"]) == (w / V["poids_pas"]).to_integral_value()
    print(f"  {'OK ' if ok else 'FAUX'} poids {i}.{k} = {w} kg au pas {V['poids_pas']}")
    if not ok: anomalies.append((i, "poids hors pas de consignation"))

print("== 4. Règle 11 : un nom par préparation")
prep = {}
for i, l in EX.items():
    m = re.search(r"Drug ([A-Z])\b", l["enonce"])
    if not m: continue
    nom, chaine = m.group(1), re.match(r"(EX\d+)", i).group(1)
    prep.setdefault(nom, set()).add(chaine)
for nom, ch in sorted(prep.items()):
    ok = len(ch) == 1
    print(f"  {'OK ' if ok else 'FAUX'} Drug {nom} : exemples {sorted(ch)}")
    if not ok: anomalies.append((f"Drug {nom}", f"nom partagé entre {sorted(ch)}"))
for nom in ("Drug X", "Drug W", "heparin", "Heparin", "insulin", "dopamine"):
    for i, l in EX.items():
        if re.search(rf"\b{nom}\b", l["enonce"]): anomalies.append((i, f"nom {nom} dans un exemple"))

print("== 5. Concordance texte A4 ↔ données")
for l in lire("valeurs.csv"): nombres.add(Decimal(l["valeur"]))
for l in lire("menager.csv"):
    nombres.update({Decimal(l["nist_ml"]), Decimal(l["etiquette_ml"]), arr(Decimal(l["nist_ml"]), int(l["decimales"]))})
for l in lire("notation.csv"):
    for t in re.findall(r"\d[\d.,]*", l["ne_pas_ecrire"] + " " + l["risque"] + " " + l["ecrire"]):
        nombres.add(Decimal(t.replace(",", "")))
txt = TXT.read_text(encoding="utf-8").split("Written with AI assistance")[0]
hors = []
for m in re.finditer(r"(?<![\w.])\d{1,3}(?:,\d{3})+(?:\.\d+)?|(?<![\w.])\d+(?:\.\d+)?", txt):
    x = Decimal(m.group(0).replace(",", ""))
    if any(abs(x - y) < Decimal("1e-9") for y in nombres): continue
    hors.append((m.group(0), re.sub(r"\s+", " ", txt[max(0, m.start()-25):m.end()+15])))
print(f"  {len(hors)} nombre(s) sans correspondance directe (à examiner à la main) :")
for t, c in hors: print(f"    {t:>8}  …{c}…")

print(f"== {len(anomalies)} anomalie(s)")
for a in anomalies: print("  -", *a)
```

### Sortie du script (EN01, v2)

```text
== 1-2. Recalcul et arrondi
  OK  EX01   calc=0.875 attendu=0.875 écart=0.0e-2 tol=0 → affiché 0.88 mL
  OK  EX02A  calc=19.95806428 attendu=19.95806428 écart=0.0e-7 tol=0.000001 → affiché 20 kg
  OK  EX02B  calc=2e+1 attendu=20 écart=0.0e+1 tol=0.000001 → affiché 20 kg
  OK  EX03A  calc=340 attendu=340 écart=0.0e+1 tol=0 → affiché 340 mg/day
  OK  EX03B  calc=660 attendu=660 écart=0.0e+1 tol=0 → affiché 660 mg/day
  OK  EX03C  calc=495 attendu=495 écart=0.0e+1 tol=0 → affiché 495 mg/day
  OK  EX04A  calc=125 attendu=125 écart=0.0e+1 tol=0 → affiché 125 mL/h
  OK  EX04B  calc=41.66666667 attendu=41.6666666667 écart=3.3e-11 tol=0.000001 → affiché 42 gtt/min
  OK  EX05A  calc=7.5 attendu=7.5 écart=0.0e+0 tol=0 → affiché 7.5 h
  OK  EX05B  calc=16.5 attendu=16.5 écart=0.0e+0 tol=0 → affiché 16.5 h
  OK  EX05C  calc=100 attendu=100 écart=0.0e+1 tol=0 → affiché 100 gtt/min
  OK  EX06A  calc=2.25 attendu=2.25 écart=0.0e-1 tol=0 → affiché 2.25 m²
  OK  EX06B  calc=138.0 attendu=138 écart=0.0e+0 tol=0.000001 → affiché 138 mg
  OK  EX07A  calc=200.0 attendu=200 écart=0.0e+0 tol=0.000001 → affiché 200 mg/mL
  OK  EX07B  calc=1.6 attendu=1.6 écart=0.0e+0 tol=0.000001 → affiché 1.6 mL
  OK  EX08A  calc=1200 attendu=1200 écart=0.0e+1 tol=0 → affiché 1200 mcg/mL
  OK  EX08B  calc=17.19 attendu=17.19 écart=0.0e-1 tol=0.000001 → affiché 17.2 mL/h
  OK  EX09A  calc=75 attendu=75 écart=0.0e+1 tol=0 → affiché 75 units/mL
  OK  EX09B  calc=608.0 attendu=608 écart=0.0e+0 tol=0.000001 → affiché 608 units/h
  OK  EX09C  calc=8.106666667 attendu=8.1066666667 écart=3.3e-11 tol=0.000001 → affiché 8.1 mL/h
  OK  C01    calc=9.0 attendu=9 écart=0.0e+0 tol=0.000001 → affiché 9 mg/mL
  OK  C02    calc=1 attendu=1 écart=0.0e+1 tol=0 → affiché 1 mg/mL
== 2b. Valeurs réglées / prélevées sur un pas réglable
  OK  EX01   0.88 mL pas 0.01 (arrondi=2)
  OK  EX02A  20 kg pas 0.1 (arrondi=1)
  OK  EX02B  20 kg pas 0.1 (arrondi=1)
  OK  EX04A  125 mL/h pas 0.1 (arrondi=1)
  OK  EX04B  42 gtt/min pas 1 (arrondi=0)
  OK  EX05C  100 gtt/min pas 1 (arrondi=0)
  OK  EX07B  1.6 mL pas 0.1 (arrondi=1)
  OK  EX08B  17.2 mL/h pas 0.1 (arrondi=1)
  OK  EX09C  8.1 mL/h pas 0.1 (arrondi=1)
== 3. Enchaînements (sortie non arrondie réutilisée telle quelle)
  OK  EX07A → EX07B.C : 200.0 vs 200
  OK  EX08A → EX08B.C : 1200 vs 1200
  OK  EX09A → EX09C.C : 75 vs 75
  OK  EX09B → EX09C.N : 608.0 vs 608
  OK  EX02B → EX03A.W : 2e+1 vs 20
  OK  poids EX03A.W = 20 kg au pas 0.1
  OK  poids EX03B.W = 20 kg au pas 0.1
  OK  poids EX06A.W = 54 kg au pas 0.1
  OK  poids EX08B.W = 76.4 kg au pas 0.1
  OK  poids EX09B.W = 64 kg au pas 0.1
== 4. Règle 11 : un nom par préparation
  OK  Drug A : exemples ['EX01']
  OK  Drug B : exemples ['EX03']
  OK  Drug C : exemples ['EX06']
  OK  Drug D : exemples ['EX07']
  OK  Drug E : exemples ['EX08']
  OK  Drug F : exemples ['EX09']
== 5. Concordance texte A4 ↔ données
  2 nombre(s) sans correspondance directe (à examiner à la main) :
           6  …onvert in and lb first. 6 Reconstitution…
          16  ….5 h (7 h 30 min) → ends 16:30. Microdrip:…
== 0 anomalie(s)
```

Les deux nombres sans correspondance directe sont le numéro de section « 6 » et l’heure « 16 » de 16:30, calculée par `horloge()` à partir de EX05B (16.5 h). Aucun nombre n’est tapé en dur dans le Typst.
