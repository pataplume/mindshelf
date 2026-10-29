# Vérification EN10-STD : TEAS 7 Science Review Sheets (rapport v1)

- **Run :** R03, agent VÉRIFICATEUR (sans participation à la production), 29.10.2026
- **Objet :** `produits/EN10/` (src, donnees, livraison/EN10-STD : a4, letter, nb, tablette), anglais US, candidat.e.s à l'ATI TEAS 7 (section Science), risque IA MOYEN, sans relecture métier, Whop + Etsy. Fichiers du conditionneur (`apercus/`, `video/`, `annonce/`, `donnees/extraits.csv`, `.apkg`) non jugés.
- **Méthode :** build dans une copie du dépôt (`scripts/build.py EN10-STD` : 4 PDF, `controle_pdf` OK, texte des 4 PDF identique aux PDF livrés) ; recalcul indépendant des 39 exemples et des relations entre `valeurs.csv` et `plan.csv` (script en fin de rapport) ; lecture intégrale du texte du PDF A4, rendu des pages à 70 et 110 dpi ; relecture du fond de tous les tableaux CSV et du Typst ; confrontation en ligne du plan ATI (content outline et page officielle « Exam details ») ; sondage de 12 localisations OpenStax et de l'appendice A HICPAC ; sondage droits sur OpenStax *Biology 2e* 1.1 et 4.3 et *A&P 2e* 18.6.

## Verdict : **À corriger**

Calculs justes (39/39), plan ATI confirmé à la source officielle, aucune erreur factuelle franche, aucune reprise d'OpenStax ni question d'examen. Trois MAJEURS à lever avant publication, tous rapides : le tableau ABO présente O et AB comme donneur et receveur universels sans le facteur Rh, contre la source citée ; la ligne du croisement Aa × Aa perd ses points-virgules à la compilation ; deux exemples de transmission ne sont pas soutenus par la source citée.

| Gravité | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 3 |
| MINEUR | 11 |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `groupes_sanguins.csv` (colonne `recoit`, lignes AB et O) ; PDF p. 1, tableau ABO | « AB … (universal recipient) » et « O only (universal donor of red cells) » sans Rh. La source citée (OpenStax *A&P 2e*, 18.6 Blood Typing, consultée) écrit : donneur universel = **O−**, receveur universel = **AB+**. Telle quelle, la phrase est fausse pour un.e donneur.euse O+ et un.e receveur.euse AB−. C'est une question classique du TEAS (O+ / O− / AB+ / AB−). Le paragraphe Rh qui suit ne le rattrape pas. | Garder le tableau en ABO pur (en-tête « Can receive red cells from (ABO only) »), retirer les mentions « universal » de la colonne et ajouter une ligne : « Universal red-cell donor: O−; universal recipient: AB+. An Rh− person should receive Rh− red cells. » Ajouter un piège « O− donor, AB+ recipient ». |
| M2 | MAJEUR | `src/main.typ` l. 270 (encadré « Punnett square, Aa × Aa ») ; les 4 PDF | En Typst, un `;` collé à `#res("EX11")` termine l'expression et disparaît. Le PDF affiche « Genotypes AA : Aa : aa = 1 : 2 : 1 phenotypes dominant : recessive = 3 : 1 P(aa) = 0.5 × 0.5 = 25 %. » La ligne se lit mal (« 3 : 1 P(aa) »), et c'est l'exemple phare de la génétique. Aucune autre occurrence dans le fichier (recherche faite). | Écrire `#res("EX11")\;` (ou `#res("EX11")#[;]`) aux deux endroits, ou passer les trois résultats en puces comme les lignes suivantes. Recompiler et relire la ligne. |
| M3 | MAJEUR | `transmission.csv` (colonne `exemple`) ; `references.csv` ligne CDC_HICPAC_2007 (A-VERIFIER) | Appendice A consulté (version en ligne cdc.gov) : coqueluche = Droplet ✓ ; tuberculose pulmonaire = Airborne ✓ ; grippe saisonnière : la version en ligne renvoie à un autre guide (la version PDF 2007 indiquait Droplet). **Hépatite B : « Standard » seulement**, rien sur le sang ni sur un véhicule. **Paludisme : « Standard », « not transmitted from person to person, except through transfusion rarely »** ; le moustique n'apparaît que dans le conseil DEET. Deux exemples sur cinq ne sont donc pas soutenus par la source citée. « Skin infections » (contact direct) n'a pas de source. Les faits sont exacts. | Pour l'hépatite B (sang) et le paludisme (moustique), citer une source qui l'écrit : pages maladies CDC (Hepatitis B ; Malaria, « About Malaria »), avec URL et date. Pour la grippe, citer le PDF 2007 (appendice A, édition d'origine) ou « Prevention Strategies for Seasonal Influenza in Healthcare Settings » (CDC). Donner une source à l'exemple « skin infections » ou le remplacer par un exemple sourcé. |
| m1 | MINEUR | `references.csv`, ligne appareil respiratoire | « Modifications in Respiratory Functions / régulation (22.5) » est faux. Vérifié : 22.5 = *Transport of Gases*, 22.6 = *Modifications in Respiratory Functions*. Les centres respiratoires relèvent de 22.3 *The Process of Breathing*, déjà cité. | Remplacer par « 22.3 (contrôle de la ventilation) » et retirer 22.5. |
| m2 | MINEUR | `references.csv`, ligne appareils reproducteurs | Titres de la 1re édition. Dans *A&P 2e* (vérifié) : 27.1 *Anatomy and Physiology of the Testicular Reproductive System* ; 27.2 *… of the Ovarian Reproductive System*. Les numéros sont justes. | Corriger les deux titres. |
| m3 | MINEUR | `references.csv`, ligne méthode scientifique (OPENSTAX_BIO2E 1.1) | Sondé : 1.1 couvre hypothèse, groupe témoin, induction et déduction, mais **ne nomme pas les variables indépendante et dépendante**. Elle ne met pas non plus en regard théorie et loi (la ligne renvoie bien à *Chemistry 2e* 1.1 pour ce point). | Ajouter une source qui définit les variables indépendante, dépendante et contrôlées (manuel ou guide identifié, avec localisation), ou marquer ce point A-VERIFIER. |
| m4 | MINEUR | `references.csv`, ligne WTC_TEAS_GUIDE (50 questions, 6 de prétest) | Source secondaire, et l'A-VERIFIER est encore ouvert. **Confirmé à la source officielle** : https://www.atitesting.com/teas/exam-details (consultée le 29.10.2026). Science : 50 questions, 6 non notées, 60 min ; total 170 questions, 209 min. Le content outline (copie McFatter consultée) confirme 44 notées, 18/9/8/9, et 20 non notées réparties proportionnellement (20 × 44/150 ≈ 6). | Remplacer WTC_TEAS_GUIDE par ATI « Exam details » (URL, date) et lever l'A-VERIFIER. |
| m5 | MINEUR | `valeurs.csv` SCI_NOTEES, SCI_TOTAL, CODONS ; `main.typ` | Valeurs dérivées stockées en double sans contrôle : SCI_NOTEES (44) = somme de `plan.csv` ; SCI_TOTAL (50) = SCI_NOTEES + SCI_PRETEST. Elles concordent aujourd'hui (script), mais une modification de `plan.csv` ne serait pas répercutée. CODONS (64) n'est utilisé nulle part et double EX36. | Calculer SCI_NOTEES et SCI_TOTAL dans le Typst depuis `plan.csv` et SCI_PRETEST (ou `panic` si la somme diffère) ; supprimer CODONS. |
| m6 | MINEUR | `src/main.typ` (contenu en dur) | Aucun nombre affiché n'est faux, mais une partie du contenu vit dans le Typst : tableaux tonicité, particules, termes de la méthode scientifique, grille de Punnett ; les « 1 » de la ligne d'équivalences d'unités ; « 100 mL solution » dans la formule % (m/v) alors que EX23 porte `c = 100` ; « Four tissue types » ; dans les pièges, « two … four » qui double `comparaisons.csv` ; « Largest sub-area », affirmé et non calculé depuis `plan.csv`. | Passer ces tableaux en CSV, lire le 100 dans EX23, calculer « largest » depuis `plan.csv`, et faire produire le piège mitose/méiose par les mêmes données que le tableau. |
| m7 | MINEUR | PDF A4 p. 3, « Working with data » ; `exemples.csv` EX35 | « … × 100 = 4 » puis « % » seul sur la ligne suivante : pas d'espace insécable entre nombre et unité (même risque pour « 25 % », « 50 % »). L'erreur relative est aussi définie sans valeur absolue. L'usage est \|mesure − acceptée\| / acceptée × 100 ; le résultat est le même ici. | Espace insécable (`~`) avant les unités ; écrire la formule avec la valeur absolue (ou dire « signed percent error »). |
| m8 | MINEUR | `anatomie.csv`, Respiratory, « Pharynx and larynx » | « Shared airway and food passage » s'applique au seul pharynx. Accolé à « Pharynx and larynx », il laisse croire que le larynx est aussi un passage alimentaire. | « Pharynx: shared air and food passage. Larynx: … » (deux lignes ou phrase explicite). |
| m9 | MINEUR | `organites.csv`, ligne « Plant cells only » | « Cell wall … » sous « Plant cells only » contredit le tableau des microbes (bactéries : paroi de peptidoglycane ; champignons : chitine), d'où une incohérence au sens de la règle 13. | « Plant cells (not animal cells) ». |
| m10 | MINEUR | PDF A4 et Letter p. 4 | Colonne droite vide : la page 4 est à moitié blanche. Ce n'est pas une erreur, mais la vignette perd en densité. | Rééquilibrer (pièges en colonne droite, ou un court encadré de valeurs déjà dans `valeurs.csv`) ; sinon accepter. |
| m11 | MINEUR | `contenu.csv` ligne 6 (et règle 15) | La liste des calculs omet le débit cardiaque et masse molaire / moles, qui figurent sur la fiche. « each recalculated from the data » décrit le procédé interne, n'apporte rien à l'acheteur.euse et se lit comme une affirmation de contrôle. Le reste de `contenu.csv` décrit exactement le PDF : 4 pages A4, 4 sous-domaines, 10 tableaux couvrant les 11 systèmes de l'outline, 15 pièges comptés. | Ajouter « cardiac output, molar mass and moles » ; remplacer par « each worked step by step ». |

## Points A-VERIFIER : avis

| Point | État après vérification | Bloque la publication ? |
|---|---|---|
| 6 questions de prétest en Science (WTC_TEAS_GUIDE) | Confirmé par ATI (page « Exam details » : 50 questions, 6 non notées, 60 min). | Non, une fois la source remplacée (m4). |
| Tournesol dans *Chemistry 2e* 14.7 | 14.7 mentionne bien le tournesol (zone de virage, fig. 14.20) et traite des indicateurs. Le sens des couleurs n'a pas été relu dans la figure. | Non. |
| Lignes de l'appendice A HICPAC | Coqueluche et tuberculose confirmées ; grippe, hépatite B et paludisme non soutenus tels quels (M3). | Non sur le fond (faits exacts), mais M3 doit être corrigé avant publication. |
| Localisations OpenStax écrites de mémoire | 12 sondées. Confirmées : *A&P 2e* ch. 1 (1.2, 1.5, 1.6), 18.6, ch. 19 (19.1, 19.2, 19.4), 22.1 à 22.4, ch. 25 (sections existantes), *Bio 2e* 1.1 et 4.3, *Chem 2e* 9.2 (Boyle, Charles, Amontons/Gay-Lussac) et 14.7. Fausses : 22.5 (m1), titres 27.1 et 27.2 (m2). Partielle : *Bio 2e* 1.1 pour les variables (m3). **Non sondées**, donc toujours A-VERIFIER : *A&P 2e* ch. 4 à 7, 9, 10, 12, 13, 15, 17, 20, 21, 23, 26 ; *Bio 2e* ch. 3, 5 à 8, 10 à 15, 21 à 24 ; *Chem 2e* ch. 1 à 7, 10 à 13. Les faits correspondants sont des notions de base, relus ici sans erreur. | Non, après m1 à m3 ; le reste peut être sondé plus tard. |
| Mention de pied « content checked and approved by the seller » (`mentions.csv` IA_REDACTION_ASSISTEE) | Elle n'est vraie qu'après la validation de Tristan (règle 15). | **Oui**, tant que Tristan n'a pas relu et validé la fiche. |

Non consultés (URL bloquées pendant la vérification) : CDC *Principles of Epidemiology*, Lesson 1 Section 10 (archive.cdc.gov), donc localisation CDC_EPI_2012 non contrôlée en ligne ; page « TEAS test sections » d'atitesting.com (la page « Exam details » l'a remplacée).

## Contrôles passés sans constat

- **Calculs :** 39 exemples recalculés, écart max. 2.8e-14. Arrondis et signes = / ≈ conformes. Liens entre exemples cohérents (EX20 utilise le résultat d'EX21, EX39 celui d'EX38, EX19 PKW, EX07 et EX08 réciproques). Chaque résultat affiché est présent dans le texte du PDF A4.
- **Concordance :** les nombres du PDF viennent tous de `exemples.csv`, `valeurs.csv` et `plan.csv` (lecture du Typst ; réserves m5, m6). Les PDF livrés sont identiques au build de contrôle.
- **Forme :** `controle_pdf.py EN10-STD` passe sur les 4 formats : polices incorporées, métadonnées, 4 pages (max. 6), tablette 9 pages avec liens et signets, N&B sans couleur, aucun débordement, 3 mentions présentes. pdfinfo signale « Suspects object is wrong type (boolean) » (avertissement poppler sur les métadonnées), sans effet sur les contrôles.
- **Plan ATI et couverture :** répartition 18 / 9 / 8 / 9 = 44 notées et 60 min confirmées par le content outline ATI. Les 11 systèmes de l'outline (S.1.2 à S.1.12) sont tous couverts. Les intitulés de `plan.csv` sont reformulés, sans reprise du texte ATI. Le PDF écrit « not a complete course and contain no actual test questions ». Pied de page : « TEAS is a registered trademark of ATI … Not affiliated with or endorsed by ATI ». Aucune promesse de couverture complète ni d'affiliation (règle 14).
- **Fond :** relecture intégrale sans erreur factuelle hors M1 : 11 systèmes, débit cardiaque, Rh, organites, transport et tonicité, mitose et méiose, ADN et ARN, code génétique (TAC CGT → AUG GCA → Met–Ala), rapports de Punnett 3:1, 1:2:1, 1:1 et 9:3:3:1, macromolécules, liaisons, changements d'état, lois des gaz, réactions équilibrées, solutions, pH et pOH, préfixes SI, conversions exactes NIST (2.54 ; 0.45359237), températures. Simplifications acceptables : lipides « glycerol + fatty acids » (vrai pour les triglycérides), « alkali metals (far-left column) » (sans l'exception de l'hydrogène).
- **Droits :** sondage sur *Bio 2e* 4.3 (six descriptions d'organites) et 1.1 (quatre phrases sur la méthode) : aucune phrase identique ou quasi identique. *A&P 2e* 18.6 n'a pas de tableau ABO en texte (seulement la figure 18.17) ; la structure antigènes / anticorps / compatibilité est générique. Les descriptions de `transmission.csv` suivent de près le CDC, texte du gouvernement fédéral américain, dans le domaine public. Aucune question d'examen.

## Script de recalcul

Lancé avec `python3 recalcul_en10.py /home/claude/mindshelf/produits/EN10 en10-a4.txt` (texte du PDF A4 extrait par `pdftotext -layout`) : **RESULTAT GLOBAL : OK** (39 exemples OK, 16 relations OK, 39 résultats retrouvés dans le PDF).

```python
"""Recalcul indépendant EN10 (vérificateur R03).
Usage : python3 recalcul_en10.py <dossier produits/EN10> [<texte pdftotext -layout du PDF A4>]
- recalcule chaque ligne de donnees/exemples.csv (calc.pow évalué comme pow) ;
- contrôle l'arrondi affiché et le signe = / ≈ ;
- contrôle les relations entre valeurs de valeurs.csv et plan.csv ;
- vérifie que chaque résultat affiché figure dans le texte du PDF.
"""
import csv, json, math, re, sys
from pathlib import Path

base = Path(sys.argv[1])
pdf_txt = Path(sys.argv[2]).read_text() if len(sys.argv) > 2 else None
d = base / "donnees"
ok = True

def lire(nom):
    with open(d / nom, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def affiche(x, dec):
    s = f"{x:,.{dec}f}" if dec is not None else f"{x:,}"
    return s

print("== Exemples")
ex = {}
for l in lire("exemples.csv"):
    e = json.loads(l["entrees_json"])
    formule = l["formule"]
    assert re.fullmatch(r"[A-Za-z0-9_+\-*/(). ,]*", formule.replace("calc.pow", "pow")), formule
    assert "**" not in formule
    val = eval(formule.replace("calc.pow", "pow"), {"__builtins__": {}, "pow": pow}, e)
    attendu, tol = float(l["resultat_attendu"]), float(l["tolerance"])
    ecart = abs(val - attendu)
    dec = int(l["arrondi"]) if l["arrondi"] != "" else None
    shown = round(attendu, dec) if dec is not None else f"{attendu:g}"
    signe = "=" if dec is None or abs(round(val, dec) - val) < 1e-9 else "≈"
    statut = "OK" if ecart <= tol else "ECART"
    if statut != "OK":
        ok = False
    ex[l["id"]] = (val, dec)
    print(f"{l['id']}  {formule:<28} = {val:<14.10g} attendu {attendu:<12g} écart {ecart:.2e}  affiché {signe} {shown}  {statut}")

print("== Relations entre données")
v = {l["id"]: l for l in lire("valeurs.csv")}
num = lambda k: float(v[k]["valeur"])
plan = lire("plan.csv")
checks = [
    ("somme plan.csv = SCI_NOTEES", sum(int(p["questions"]) for p in plan), num("SCI_NOTEES")),
    ("SCI_NOTEES + SCI_PRETEST = SCI_TOTAL", num("SCI_NOTEES") + num("SCI_PRETEST"), num("SCI_TOTAL")),
    ("ATI exam-details : Science 50 questions dont 6 non notées", (num("SCI_TOTAL"), num("SCI_PRETEST")), (50.0, 6.0)),
    ("ATI content outline : 18/9/8/9", [int(p["questions"]) for p in plan], [18, 9, 8, 9]),
    ("prétest proportionnel : 20 × 44/150 arrondi", round(20 * 44 / 150), num("SCI_PRETEST")),
    ("CODONS = 4^3 (= EX36)", pow(4, 3), num("CODONS")),
    ("CHROM_2N / 2 = CHROM_PAIRES (= EX32)", num("CHROM_2N") / 2, num("CHROM_PAIRES")),
    ("T_CORPS_F = 1.8 × T_CORPS_C + 32", round(1.8 * num("T_CORPS_C") + 32, 1), num("T_CORPS_F")),
    ("LB_KG = 0.45359237 arrondi 4 déc.", round(0.45359237, 4), num("LB_KG")),
    ("KG_LB = 1/0.45359237 arrondi 1 déc.", round(1 / 0.45359237, 1), num("KG_LB")),
    ("EX20.MM = résultat EX21", json.loads([l for l in lire("exemples.csv") if l["id"] == "EX20"][0]["entrees_json"])["MM"], ex["EX21"][0]),
    ("EX39.MM = résultat EX38", json.loads([l for l in lire("exemples.csv") if l["id"] == "EX39"][0]["entrees_json"])["MM"], ex["EX38"][0]),
    ("PKW − pH(EX19) cohérent", num("PKW") - 3, ex["EX19"][0]),
    ("préfixes 10^3, 10^-1, 10^-2, 10^-3, 10^-6", [num(k) for k in ("P_KILO", "P_DECI", "P_CENTI", "P_MILLI", "P_MICRO")], [1e3, 1e-1, 1e-2, 1e-3, 1e-6]),
    ("EX06 = 66 in × 2.54", (5 * 12 + 6) * 2.54, ex["EX06"][0]),
    ("EX07/EX08 réciproques : 37 °C ↔ 98.6 °F", round((98.6 - 32) / 1.8, 9), 37.0),
]
for nom, a, b in checks:
    if isinstance(a, list):
        bon = all(math.isclose(x, y, rel_tol=1e-12, abs_tol=1e-12) for x, y in zip(a, b)) and len(a) == len(b)
    elif isinstance(a, tuple):
        bon = a == b
    else:
        bon = math.isclose(float(a), float(b), rel_tol=1e-9, abs_tol=1e-9)
    ok &= bon
    print(f"{'OK ' if bon else 'KO '} {nom}: {a} / {b}")

if pdf_txt:
    print("== Présence des résultats affichés dans le PDF A4")
    t = pdf_txt.replace("−", "-")
    for k, (val, dec) in ex.items():
        s = affiche(round(val, dec) if dec is not None else val, dec)
        s = s.rstrip("0").rstrip(".") if dec is None else s
        trouve = s in t
        ok &= trouve
        print(f"{'OK ' if trouve else 'KO '} {k} « {s} »")
print("RESULTAT GLOBAL :", "OK" if ok else "ECARTS")
sys.exit(0 if ok else 1)
```

Limite du dernier bloc : la recherche par sous-chaîne est faible pour les petits entiers (1, 3, 4). Ces résultats ont aussi été contrôlés à la lecture du PDF.
