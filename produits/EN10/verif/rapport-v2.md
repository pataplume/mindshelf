# EN10-STD « TEAS 7 Science Review Sheets » : rapport de vérification v2

Run R03, contre-vérification indépendante (je n'ai participé ni à la production ni à la correction), 29.10.2026. Périmètre : les constats de `verif/rapport-v1.md` et ce qui a changé depuis. Ce n'est pas une seconde vérification complète. Objets : `src/main.typ`, `donnees/*`, `annonce/*`, `livraison/EN10-STD/*.pdf` (fabriqués à 10:31).

## Verdict : **OK avec réserves**

Les 3 MAJEURS et 10 des 11 MINEURS de la v1 sont levés ; m3 l'est en partie. Je n'ai trouvé aucune régression de contenu. Il reste 0 BLOQUANT et 0 MAJEUR. Deux MINEURS nouveaux portent sur les données (`references.csv`), un troisième sur la mise en page.

- **Calculs :** les 39 exemples sont recalculés sans écart. 15 relations sont contrôlées (dont le plan ATI 44 + 6 = 50, désormais calculé depuis `plan.csv`) et les 39 résultats sont retrouvés dans le texte du PDF A4.
- **Build de contrôle :** `scripts/build.py EN10-STD` lancé dans une copie du dépôt. `controle_pdf.py` passe sur les 4 formats et le texte des 4 PDF rebâtis est identique à celui des PDF livrés.
- **Recherche du motif `#f(...);` (règle 16) :** aucune occurrence. Les deux `;` de la ligne de Punnett sont échappés (`\;`) et présents dans le texte des 4 PDF.

## Constats v1 : levé / non levé

| # v1 | Constat (résumé) | État | Preuve |
|---|---|---|---|
| M1 | O et AB présentés comme donneur et receveur universels sans le Rh | **Levé** | `groupes_sanguins.csv` : la colonne `recoit` est en ABO seul, sans « universal ». L'en-tête du PDF dit « Can receive red cells from (ABO only) ». Le paragraphe Rh ajoute : « Universal red-cell donor: O−; universal recipient: AB+. An Rh− person should receive Rh− red cells. » Il y a aussi un piège (« Universal red-cell donor is O−, universal recipient AB+: Rh counts as well as ABO ») et une carte Anki (« Donor: O− … Recipient: AB+ … »). Source : OPENSTAX_AP2E 18.6 (relue en v1). |
| M2 | Points-virgules avalés dans la ligne Aa × Aa | **Levé** | `main.typ` l. 281 : `#res("EX11")\;` aux deux endroits. Texte du PDF (A4, Letter, N&B, tablette) : « Genotypes AA : Aa : aa = 1 : 2 : 1; phenotypes dominant : recessive = 3 : 1; P(aa) = 0.5 × 0.5 = 25 % ». Aucune autre occurrence du motif. |
| M3 | Hépatite B, paludisme et grippe non soutenus par la source citée | **Levé** | Nouvelles sources, toutes relues par moi : CDC « How Flu Spreads » (17.09.2024, « spread mainly by droplets… ») ; CDC « Hepatitis B Prevention and Control » (31.01.2025, « primarily spread when blood, semen, or certain other body fluids… ») ; CDC « How Malaria Spreads » (12.03.2024, « Most people get malaria when bitten by an infective mosquito… »). L'exemple « Skin infections », sans source, a été retiré (« — »). La coqueluche et la tuberculose restent sur l'appendice A du HICPAC (relu en v1). |
| m1 | 22.5 au lieu de 22.3 | **Levé** | `references.csv` : 22.3 pour le contrôle de la ventilation ; 22.5 retiré. |
| m2 | Titres 27.1 et 27.2 de la 1re édition | **Levé** | Titres de la 2e édition. |
| m3 | Variables indépendante et dépendante sans source | **Partiellement levé** | Une source a été ajoutée (LabWrite, NCSU, « Variables »). Elle ne couvre ni les variables contrôlées ni les axes x et y, et la ligne le dit (`A-VERIFIER`). Ce sont des notions standard, sans enjeu de sécurité. |
| m4 | Source secondaire pour 50 / 6 / 60 min | **Levé** | ATI_EXAM_DETAILS (atitesting.com), avec l'URL et la date. |
| m5 | SCI_NOTEES, SCI_TOTAL et CODONS en double | **Levé** | Les trois clés sont supprimées de `valeurs.csv`. `main.typ` l. 81-82 calcule les questions notées comme la somme de `plan.csv` et le total comme notées + `SCI_PRETEST`. Le PDF affiche « 44 scored items plus 6 unscored pretest items (50 in all) in 60 min ». |
| m6 | Contenu en dur dans le Typst | **Levé** | Nouveaux CSV : `tonicite.csv`, `particules.csv`, `methode.csv`, `comparaisons.csv`. Le piège mitose / méiose est lu dans `comparaisons.csv`. « Largest sub-area » est calculé depuis `plan.csv`. |
| m7 | Pas d'espace insécable avant « % » ; erreur relative sans valeur absolue | **Levé** | « \|10.4 − 10\|/10 × 100 = 4 % » : le nombre et « % » restent sur la même ligne. |
| m8 | Pharynx et larynx | **Levé** | Deux lignes séparées dans `anatomie.csv`. |
| m9 | « Plant cells only » | **Levé** | « Plant cells (not animal cells) ». |
| m10 | Page 4 à moitié vide | **Levé** | `#colbreak()` : les 16 pièges sont dans la colonne droite de la p. 4 (rendu vérifié). |
| m11 | `contenu.csv` incomplet, « each recalculated » | **Levé** | Débit cardiaque et masse molaire / moles ajoutés ; « each worked step by step ». Annonces Whop et Etsy : 65 cartes (65 lignes dans `cartes.csv`), 16 pièges (16 puces dans le PDF), tablette de 9 pages (`pdfinfo`). |

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| n1 | MINEUR | `donnees/references.csv`, ligne 70 (« Numéros de chapitre et de section des trois manuels OpenStax ») | La ligne a 5 champs au lieu de 3 : la localisation contient des virgules hors guillemets (« …(29.10.2026), dont 22.5, 27.1 et 27.2 corrigées en v2 ; … »). Un lecteur CSV la coupe en trois morceaux. C'est une régression de la correction v2. Le build ne la détecte pas, car le Typst ne lit pas `references.csv`. | Mettre la localisation entre guillemets doubles. Ajouter éventuellement à `scripts/verifie_tables.py` un contrôle du nombre de champs pour `references.csv`. |
| n2 | MINEUR | `references.csv`, ligne « Indicateur tournesol » (CHEM2E 14.7) | La ligne garde « A-VERIFIER : la mention du tournesol dans cette section ». La v1 a pourtant confirmé cette mention (zone de virage, fig. 14.20) ; seul le sens des couleurs n'a pas été relu. | « Mention du tournesol confirmée par le vérificateur R03 ; sens des couleurs non relu dans la figure (A-VERIFIER) ». |
| n3 | MINEUR (forme, optionnel) | PDF A4 p. 1 | La phrase « Universal red-cell donor: O−; universal recipient: AB+ » ouvre la 2e colonne : le saut de colonne la sépare du tableau ABO (bas de la 1re colonne). Rien n'est coupé ni perdu, et la même information figure dans le piège et la carte. | Accepter, ou rendre le paragraphe Rh insécable. |

## A-VERIFIER restants : avis

| Point | Avis | Bloque la publication ? |
|---|---|---|
| Localisations OpenStax non sondées (A&P 2e ch. 4-7, 9, 10, 12, 13, 15, 17, 20, 21, 23, 26 ; Bio 2e et Chem 2e : voir la v1) | Notions de base, sans erreur à la relecture v1. Aucun nouveau sondage dans ce run (budget). | Non |
| Variables contrôlées et axes x / y (`methode.csv`) | Notions standard, non sourcées par une page lue. | Non (réserve) |
| Sens des couleurs du tournesol | Fait standard ; la mention dans 14.7 est confirmée (n2). | Non |
| CDC_EPI_2012 (Lesson 1, Section 10) non relu en ligne | Il sert à la typologie des modes de transmission, qui est cohérente avec les pages CDC relues. | Non |
| Mention « content checked and approved by the seller » | Elle n'est exacte qu'après la validation de Tristan (règle 15). | **Oui**, tant que Tristan n'a pas validé |

## Script de recalcul

Adapté du script v1. SCI_NOTEES et SCI_TOTAL sont maintenant calculés depuis `plan.csv`, comme dans `main.typ` (notées = somme de `questions`, total = notées + SCI_PRETEST). Le script vérifie aussi que SCI_NOTEES, SCI_TOTAL et CODONS ont bien disparu de `valeurs.csv`. Le contrôle CODONS = 4³ est remplacé par EX36 = 4³.

Exécution :
- Commande : `pdftotext -layout livraison/EN10-STD/EN10-STD-a4.pdf en10-a4.txt` puis `python3 -I recalcul_en10.py produits/EN10 en10-a4.txt`.
- Résultat : **RESULTAT GLOBAL : OK**. Les 39 exemples sont OK, les 15 relations et les 3 suppressions aussi, et les 39 résultats sont présents dans le PDF.
- Limite : la recherche de chaînes est faible pour les petits entiers, comme en v1.

```python
"""Recalcul indépendant EN10 v2 (vérificateur R03, adapté du script v1 : SCI_NOTEES et SCI_TOTAL calculés depuis plan.csv).
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
notees = sum(int(p["questions"]) for p in plan)          # v2 : SCI_NOTEES calculé depuis plan.csv (comme main.typ)
total = notees + num("SCI_PRETEST")                      # v2 : SCI_TOTAL = notées + prétest
for k in ("SCI_NOTEES", "SCI_TOTAL", "CODONS"):
    print(("OK  " if k not in v else "KO  ") + k + " absent de valeurs.csv (supprimé en v2, m5)")
    ok &= k not in v
checks = [
    ("ATI exam-details : Science 50 questions dont 6 non notées", (total, num("SCI_PRETEST")), (50.0, 6.0)),
    ("ATI content outline : 44 notées", notees, 44),
    ("ATI content outline : 18/9/8/9", [int(p["questions"]) for p in plan], [18, 9, 8, 9]),
    ("prétest proportionnel : 20 × 44/150 arrondi", round(20 * 44 / 150), num("SCI_PRETEST")),
    ("EX36 = 4^3 codons", pow(4, 3), ex["EX36"][0]),
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
