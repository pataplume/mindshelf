# Vérification EN02-STD : Physics Formula Sheet (College & Pre-Med) (rapport v2)

- **Run :** R01, agent VÉRIFICATEUR (contre-vérification v2, sans participation à la production ni à la correction), 28.10.2026
- **Objet :** levée des 9 mineurs du rapport v1 ; régressions de la correction (facteurs de préfixes, `qu()` et %) ; nouvelles références.
- **Méthode :** relecture de `valeurs.csv`, `contenu.csv`, `references.csv` et de `src/main.typ`, puis du PDF A4 livré (pdftotext et rendu PNG de la page 1 à 80 dpi). Les 18 exemples sont recalculés avec le script v1, complété par les facteurs de préfixes et le signe attendu, `=` ou `≈`. Le build `scripts/build.py EN02-STD` a été lancé une fois dans une copie du dépôt, pour ne rien écrire hors de `verif/` : 4 PDF produits, 32 contrôles OK, texte identique aux 4 PDF livrés. En ligne, j'ai vérifié Baumgartner 2017 (PDF asecho.org) et OpenStax *College Physics 2e* § 11.8.

## Verdict : **OK avec réserves**

Les 9 mineurs v1 sont levés dans la fiche, sauf m1 (annonce, reporté au conditionnement) et une partie de m8 (localisations). La correction n'introduit aucune régression : préfixes justes, « 41% », « 63% », « 37% » sans espace, « 100 µF (0.0001 F) », « 5 MHz », « λ ≈ 0.31 mm ». Aucun BLOQUANT ni MAJEUR.

| Gravité | Restants |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 0 |
| MINEUR | 4 (m1 reporté, m8 partiel, N1, N2) |

## Constats v1 → état

| # v1 | État | Preuve |
|---|---|---|
| m1 | **Non levé (reporté)** | `contenu.csv` décrit le PDF réel : 9 notes cliniques, 12 pièges et 14 exemples, pour 18 résultats. `brief-whop.md` annonce toujours « 10 worked examples, 10 clinical notes ». La réécriture de l'annonce est renvoyée au conditionnement (journal R01). |
| m2 | **Levé** | PDF : « 𝐴 = 𝜆𝑁, with 𝜆 = ln 2/𝑇½ the decay constant (not a wavelength) ». |
| m3 | **Levé** | `qu()` n'insère pas d'espace devant % (`main.typ` l. 63), ni `#res("EX04")%` (l. 155). PDF : « ≈ 41% of baseline », « 63% charged », « 37% left ». |
| m4 | **Levé** | `main.typ` l. 206 : `ex("EX13").e.C / facteur("P_MICRO")`, arrondi à 0 décimale. PDF : « 𝐶 = 100 µF (0.0001 F) ». Le recalcul donne 100.00000000000001, affiché 100. |
| m5 | **Levé** | Le facteur Hz → MHz est lu dans `valeurs.csv` (P_MEGA = 1 × 10⁶), plus rien n'est tapé en dur. PDF : « at 5 MHz, 𝜆 ≈ 0.31 mm ». |
| m6 | **Levé** | PDF : « sin 𝜃𝑐 = 𝑛₂/𝑛₁ (𝑛₁ > 𝑛₂) ». |
| m7 | **Levé** | PDF, ligne « Doses » : « Effective dose ∑ 𝑤𝑇 𝐻𝑇 (Sv; tissue-weighted, whole-body risk) ». `references.csv` l. 81 cite CIPR 103, ch. 4, § 4.3. Le tableau des w_T reste à localiser : d'après ce que je sais de l'ouvrage (non consulté ici), c'est le tableau 3, § 4.3.5. |
| m8 | **Partiellement levé** | **Levé :** le seuil de sténose aortique, vérifié en ligne. Baumgartner et al. 2017 (JASE 30(4):372–392), tableau 3 « Recommendations for grading of AS severity » : sévère si v_max ≥ 4.0 m/s ; Bernoulli simplifié à la section « Mean Pressure Gradient ». La localisation de `references.csv` l. 76 est exacte. **Ouverts :** Laplace (source manuel, voir N1), anévrisme, COSTANZO_PHYSIO (édition et page), US_STD_ATM_1976 (tableau), CRC_HANDBOOK (édition), physiologie respiratoire pour « inspiration = Boyle ». |
| m9 | **Levé** | La section s'intitule « Constants ». Note : « CODATA 2022 values, rounded; 𝑔𝑛 conventional; 𝑅 in L·atm and ℎ𝑐 derived ». Voir N2 pour la façon dont « CODATA 2022 » est produit. |

Préfixes SI (`references.csv` l. 82) : BIPM, SI 9e éd., section 3, tableau 7 (préfixes SI). C'est exact, de même que le tableau 4 (unités dérivées à noms spéciaux, dont le degré Celsius) cité l. 15.

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| N1 | MINEUR | `references.csv` l. 37 (Laplace) | J'ai vérifié en ligne ce que signale le correcteur. OpenStax *College Physics 2e* § 11.8 ne donne que P = 4γ/r (bulle à deux surfaces). Les alvéoles et le surfactant n'y sont traités que qualitativement, et ni P = 2T/r ni 2γ/r n'y figurent. La formule de la fiche est juste (une seule interface liquide–air ; équilibre d'une demi-sphère), mais elle repose sur une démonstration étiquetée « ANALYSE_DIMENSIONNELLE ». C'est en réalité un équilibre des forces, pas une analyse dimensionnelle. | Citer un manuel de physiologie qui écrit P = 2T/r pour l'alvéole, par exemple Costanzo, *Physiology*, chapitre Respiratory Physiology, tension de surface et loi de Laplace (édition et page à relever ; cela lève aussi l'A-VERIFIER COSTANZO). Renommer le code de source en « équilibre mécanique ». |
| N2 | MINEUR | `src/main.typ` l. 281 | « CODATA 2022 » est affiché en transformant l'identifiant `source_code` de K_C (`replace("_", " ")`). Rien n'est tapé en dur, mais le texte affiché dépend du nom interne d'une clé : la renommer (par exemple CODATA2022) casserait la note sans alerte. | Ajouter un libellé court d'affichage dans la table des sources et l'utiliser ici. |

Régressions recherchées sans résultat : `facteur()` est juste pour µ et M (contrôle par script). `qu()` traite % sans espace et les autres unités avec une espace insécable (« 0.02 mSv », « 1,540 m/s »). Les signes `≈` et `=` sont justes pour les 18 résultats. La flèche « ⇒ » sert pour EX02, EX03, EX08 et EX18, le « ≈ » pour les valeurs arrondies, le « = » pour les valeurs exactes. Le build est conforme dans les 4 formats (mentions, N&B, tablette sur 3 pages avec 15 entrées de sommaire), et le rendu de la page 1 ne montre rien de coupé. Concordance : les nombres du PDF A4 absents des données sont des exposants mal lus par pdftotext, les coefficients 10 (décibels) et 3/2, « 100 » (µF, calculé depuis les données) et « 2022 » (voir N2).

## A-VERIFIER restants et avis

| # | Emplacement | Objet | Avis |
|---|---|---|---|
| 1 | l. 37 | Laplace : source manuel | Ne bloque pas : formule juste et démontrée. Voir N1. |
| 2 | l. 38 | Anévrisme (note clinique) | Ne bloque pas : énoncé qualitatif juste. |
| 3 | l. 65 | Physiologie respiratoire pour « inspiration = Boyle » | Ne bloque pas. |
| 4 | l. 74 | Costanzo : édition et page | Ne bloque pas. |
| 5 | l. 78 | U.S. Standard Atmosphere 1976 : numéro du tableau | Ne bloque pas : 0.21 est juste (20.946 %). |
| 6 | l. 79 | CRC Handbook : édition et valeur à 37 °C | Ne bloque pas : 47 mmHg est juste (6.28 kPa). |
| 7 | l. 81 | CIPR 103 : tableau des w_T | Ne bloque pas : vraisemblablement le tableau 3 (§ 4.3.5), à confirmer dans l'ouvrage. |
| — | `brief-whop.md` (m1) | Annonce | Bloque la mise en ligne de l'annonce tant qu'elle n'est pas réécrite d'après `contenu.csv`. Le PDF n'est pas en cause. |

## Script de recalcul

Le script v1 (reproduit dans `rapport-v1.md`) est repris tel quel, complété d'une section 4 : signe attendu recalculé depuis la valeur exacte et facteurs de préfixes. Il se lance par `python3 -I recalcul_v2.py <racine> EN02 <texte_pdf_a4.txt>`. Pour EN02, la colonne « signe rel() » donne le signe déduit de `resultat_attendu`. EN02 n'a pas de fonction `rel()` : le signe affiché dans le PDF a été comparé à la main.

```python
#!/usr/bin/env python3
"""Vérificateur R01 (v2) : recalcul indépendant des exemples, contrôle des valeurs de référence et concordance PDF.

Usage : python3 -I recalcul.py <racine_depot> <CODE> [<texte_pdf_a4.txt>]
- recalcule chaque ligne de donnees/exemples.csv depuis `formule` et `entrees_json` (évaluateur restreint à + - * / et parenthèses) ;
- recalcule les logarithmes fournis en entrée (`L` = log10(`R`)) ;
- vérifie la colonne `arrondi` (entier >= 0) et la valeur affichée (arrondi demi-supérieur décimal) ;
- compare les constantes et tables de données à des valeurs de référence (CODATA 2022, NIST SP 811, définitions exactes) ;
- concordance : chaque nombre du texte du PDF A4 doit se retrouver dans les données (entrées, résultats, valeurs arrondies).
"""
import ast
import csv
import json
import math
import re
import sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

RACINE, CODE = Path(sys.argv[1]), sys.argv[2]
TXT = Path(sys.argv[3]) if len(sys.argv) > 3 else None
D = RACINE / "produits" / CODE / "donnees"
constats = []


def evalue(formule, env):
    """Évaluateur sûr : nombres, noms, + - * /, moins unaire, parenthèses."""
    arbre = ast.parse(formule, mode="eval")

    def ev(n):
        if isinstance(n, ast.Expression):
            return ev(n.body)
        if isinstance(n, ast.Constant) and isinstance(n.value, (int, float)):
            return float(n.value)
        if isinstance(n, ast.Name):
            return float(env[n.id])
        if isinstance(n, ast.UnaryOp) and isinstance(n.op, ast.USub):
            return -ev(n.operand)
        if isinstance(n, ast.BinOp) and isinstance(n.op, (ast.Add, ast.Sub, ast.Mult, ast.Div)):
            a, b = ev(n.left), ev(n.right)
            return {ast.Add: a + b, ast.Sub: a - b, ast.Mult: a * b, ast.Div: a / b}[type(n.op)]
        raise ValueError(f"opération interdite dans la formule : {ast.dump(n)}")
    return ev(arbre)


def arrondi(x, n):
    return float(Decimal(repr(x)).quantize(Decimal(1).scaleb(-n), rounding=ROUND_HALF_UP))


def affiche(x, n):
    """Chaîne sans zéro final (convention EN01) et avec n décimales (convention EN02/EN03)."""
    r = arrondi(x, n)
    return (f"{r:.{n}f}", repr(r).rstrip("0").rstrip(".") if "." in repr(r) else repr(r))


# ── 1. Exemples ─────────────────────────────────────────────────────────────────
nombres_donnees = set()
print(f"== {CODE} : exemples.csv")
with open(D / "exemples.csv", newline="", encoding="utf-8") as f:
    for l in csv.DictReader(f):
        e = json.loads(l["entrees_json"])
        for k_, v_ in e.items():
            if re.search(r"[eE]", json.dumps(v_)):
                constats.append((l["id"], f"entrée {k_} en notation exponentielle"))
        if re.search(r"\*\*|[a-z_]+\(", l["formule"]):
            constats.append((l["id"], "formule hors + - * / ( )"))
        calc = evalue(l["formule"], e)
        attendu = float(l["resultat_attendu"])
        tol = float(l["tolerance"] or 0)
        ecart = abs(calc - attendu)
        ok = ecart <= tol + 1e-12
        # logarithme précalculé (EN03) : L doit valoir log10(R) ; R doit valoir le rapport annoncé
        notes = []
        if "L" in e:
            if "R" in e:
                lr = math.log10(e["R"])
                notes.append(f"log10(R={e['R']})={lr:.6f} vs L={e['L']} (écart {abs(lr-e['L']):.1e})")
                if abs(lr - e["L"]) > 5e-6:
                    constats.append((l["id"], f"L={e['L']} ≠ log10(R)={lr:.6f}"))
            if "Kext" in e and "Kint" in e:
                vrai = math.log10(e["Kext"] / e["Kint"])
                notes.append(f"log10(Kext/Kint)={vrai:.6f} ⇒ E exact={e['k']*vrai/e['z']:.4f}")
                if abs(e["R"] - e["Kext"] / e["Kint"]) > 1e-5:
                    constats.append((l["id"], "R ≠ Kext/Kint"))
        if l["arrondi"].strip() == "" or int(l["arrondi"]) < 0:
            constats.append((l["id"], "colonne arrondi vide ou invalide"))
            n = None
        else:
            n = int(l["arrondi"])
        aff = affiche(calc, n) if n is not None else ("?", "?")
        print(f"  {'OK ' if ok else 'ÉCART'} {l['id']:6} calc={calc:.10g} attendu={attendu:.10g} écart={ecart:.2e} tol={tol:g} "
              f"arrondi={n} affiché={aff[0]} / {aff[1]} {l['unite']}" + (" ; " + " ; ".join(notes) if notes else ""))
        if not ok:
            constats.append((l["id"], f"écart {ecart} > tolérance {tol}"))
        for v_ in e.values():
            nombres_donnees.add(float(v_))
        nombres_donnees.update({calc, attendu, arrondi(calc, n or 0)})
        for k in range(0, 6):
            nombres_donnees.add(arrondi(calc, k))

# ── 2. Valeurs de référence ──────────────────────────────────────────────────────
REF = {
    # CODATA 2022 / SI 2019 (exactes ou recommandées)
    "c": 299792458, "h": 6.62607015e-34, "e": 1.602176634e-19, "NA": 6.02214076e23, "kB": 1.380649e-23,
    "R": 8.314462618, "G": 6.67430e-11, "k": 8.9875517862e9, "eps0": 8.8541878188e-12, "mu0": 1.25663706127e-6,
    "me": 9.1093837139e-31, "mp": 1.67262192595e-27, "gn": 9.80665, "F": 96485.33212, "Vm": 22.41396954,
    # NIST SP 811 / définitions
    "atm_kPa": 101.325, "mmHg_Pa": 133.322387415, "cmH2O_Pa": 98.0665, "cal": 4.184, "lb": 0.45359237, "in": 2.54,
}
REF["R_atm"] = REF["R"] / 101.325
REF["hc_eVnm"] = REF["h"] * REF["c"] / REF["e"] * 1e9
REF["nernst25_V"] = REF["R"] * 298.15 / REF["F"] * math.log(10)
REF["nernst37_mV"] = REF["R"] * 310.15 / REF["F"] * math.log(10) * 1000
REF["mmHg_cmH2O"] = REF["mmHg_Pa"] / REF["cmH2O_Pa"]
fl_oz = 231 * 2.54 ** 3 / 128          # mL (gallon US = 231 in³)
REF.update({"tsp": fl_oz / 6, "tbsp": fl_oz / 2, "floz": fl_oz, "cup": fl_oz * 8})


def compare(nom, affiche_, ref, chiffres=None, rel=None):
    a = float(affiche_)
    if rel is None:  # tolérance = demi-unité du dernier chiffre affiché
        s = str(affiche_)
        dec = len(s.split(".")[1]) if "." in s else 0
        rel = 0.5 * 10 ** (-dec) / abs(a) if a else 0
    ok = abs(a - ref) / abs(ref) <= rel * 1.0001 + 1e-15
    print(f"  {'OK ' if ok else 'FAUX'} {nom:28} donnée={affiche_} référence={ref:.10g}")
    if not ok:
        constats.append((nom, f"valeur {affiche_} incompatible avec la référence {ref:.10g}"))


def lire(nom):
    with open(D / nom, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


print(f"== {CODE} : valeurs de référence")
if CODE == "EN01":
    v = {l["cle"]: l["valeur"] for l in lire("valeurs.csv")}
    compare("lb_kg", v["lb_kg"], REF["lb"])
    compare("in_cm", v["in_cm"], REF["in"])
    compare("lb_par_kg_cours (≈ 1/0.45359237)", v["lb_par_kg_cours"], 1 / REF["lb"])
    for l in lire("menager.csv"):
        cle = {"1 tsp": "tsp", "1 tbsp": "tbsp", "1 fl oz": "floz", "1 cup": "cup"}[l["mesure"]]
        compare(f"menager {l['mesure']} (exact)", l["nist_ml"], REF[cle], rel=1e-12)
        print(f"       affiché ≈ {arrondi(float(l['nist_ml']), int(l['decimales']))} mL ; étiquette {l['etiquette_ml']} mL")
        nombres_donnees.update({float(l["nist_ml"]), arrondi(float(l["nist_ml"]), int(l["decimales"])), float(l["etiquette_ml"])})
    for x in v.values():
        nombres_donnees.add(float(x))
    for l in lire("notation.csv"):
        for t in re.findall(r"\d[\d.,]*", l["ne_pas_ecrire"] + " " + l["ecrire"] + " " + l["risque"]):
            nombres_donnees.add(float(t.replace(",", "")))
elif CODE == "EN02":
    v = {l["id"]: l for l in lire("valeurs.csv")}
    val = lambda i: float(v[i]["mantisse"]) * 10 ** int(v[i]["exposant"])
    for i, r in [("K_C", "c"), ("K_H", "h"), ("K_E", "e"), ("K_NA", "NA"), ("K_KB", "kB"), ("K_R", "R"), ("K_RL", "R_atm"),
                 ("K_G", "G"), ("K_K", "k"), ("K_EPS", "eps0"), ("K_MU", "mu0"), ("K_ME", "me"), ("K_MP", "mp"),
                 ("K_GN", "gn"), ("K_HC", "hc_eVnm"), ("U_ATM", "atm_kPa"), ("U_MMHG", "mmHg_Pa"), ("U_CMH2O", "cmH2O_Pa"),
                 ("U_MMHG_CMH2O", "mmHg_cmH2O"), ("U_CAL", "cal"), ("U_EV", "e")]:
        m = v[i]["mantisse"]
        compare(i, m, REF[r] / 10 ** int(v[i]["exposant"]) if i != "K_HC" else REF[r],
                rel=None if i != "K_HC" else 0.5 / 1240)
    compare("U_ATM_MMHG", v["U_ATM_MMHG"]["mantisse"], 101325 / REF["mmHg_Pa"])
    compare("U_KCAL", v["U_KCAL"]["mantisse"], 4184)
    compare("U_KELVIN", v["U_KELVIN"]["mantisse"], 273.15)
    compare("P_DB2 (10 log10 2)", v["P_DB2"]["mantisse"], 10 * math.log10(2))
    compare("P_RC63 (1 − 1/e, %)", v["P_RC63"]["mantisse"], 100 * (1 - math.exp(-1)))
    compare("P_RC37 (1/e, %)", v["P_RC37"]["mantisse"], 100 * math.exp(-1))
    for l in v.values():
        nombres_donnees.add(float(l["mantisse"]))
        nombres_donnees.add(float(l["exposant"]))
elif CODE == "EN03":
    v = {l["id"]: l for l in lire("valeurs.csv")}
    g = lambda i: v[i]["valeur"]
    compare("NA (mantisse)", g("NA"), REF["NA"] / 1e23)
    compare("R_J", g("R_J"), REF["R"])
    compare("R_ATM", g("R_ATM"), REF["R_atm"])
    compare("F", g("F"), REF["F"])
    compare("H (mantisse)", g("H"), REF["h"] / 1e-34)
    compare("C (mantisse, 3.00 × 10^8)", g("C"), REF["c"] / 1e8)
    compare("ATM_KPA", g("ATM_KPA"), REF["atm_kPa"])
    compare("ATM_MMHG", g("ATM_MMHG"), 101325 / REF["mmHg_Pa"])
    compare("VM", g("VM"), REF["Vm"])
    compare("T0", g("T0"), 273.15)
    compare("CAL", g("CAL"), REF["cal"])
    compare("LN10", g("LN10"), math.log(10))
    compare("LN2", g("LN2"), math.log(2))
    compare("NERNST25", g("NERNST25"), REF["nernst25_V"])
    compare("NERNST37", g("NERNST37"), REF["nernst37_mV"])
    compare("OSM_GLU (M glucose/10)", g("OSM_GLU"), (6 * 12.011 + 12 * 1.008 + 6 * 15.999) / 10)
    compare("OSM_BUN (2 N/10)", g("OSM_BUN"), 2 * 14.007 / 10)
    compare("PH_NEUTRE", g("PH_NEUTRE"), 7.0)
    for l in v.values():
        for c in ("valeur", "valeur_max", "exposant"):
            if l[c]:
                nombres_donnees.add(float(l[c]))
        for t in re.findall(r"\d+(?:\.\d+)?", l["condition"]):
            nombres_donnees.add(float(t))
    for fic in ("vsepr.csv", "spectro.csv"):
        for l in lire(fic):
            for x in l.values():
                for t in re.findall(r"\d+(?:\.\d+)?", x or ""):
                    nombres_donnees.add(float(t))

# ── 3. Concordance PDF ↔ données ─────────────────────────────────────────────────
if TXT:
    print(f"== {CODE} : concordance du texte PDF A4")
    texte = TXT.read_text(encoding="utf-8")
    # On retire le pied de page (mentions) et la pagination.
    texte = texte.split("Written with AI assistance")[0]
    hors = []
    for m in re.finditer(r"(?<![\w.])[−-]?\d{1,3}(?:,\d{3})+(?:\.\d+)?|(?<![\w.])[−-]?\d+(?:\.\d+)?", texte):
        tok = m.group(0)
        x = abs(float(tok.replace(",", "").replace("−", "-")))
        if x in nombres_donnees or -x in nombres_donnees or any(abs(abs(y) - x) < 1e-9 for y in nombres_donnees):
            continue
        ctx = texte[max(0, m.start() - 25): m.end() + 15].replace("\n", " ")
        hors.append((tok, re.sub(r"\s+", " ", ctx)))
    print(f"  {len(hors)} nombres sans correspondance directe dans les données (à examiner à la main) :")
    for tok, ctx in hors:
        print(f"    {tok:>10}  …{ctx}…")

print(f"== {CODE} : {len(constats)} anomalie(s) détectée(s) par script")
for c in constats:
    print("  -", *c)

# ── 4. Ajouts v2 : signe « = » / « ≈ » (EN03, rel()) et facteurs de préfixes (EN02) ──
print(f"== {CODE} : contrôles v2")
with open(D / "exemples.csv", newline="", encoding="utf-8") as f:
    lignes = list(csv.DictReader(f))
for l in lignes:
    e = json.loads(l["entrees_json"])
    calc = evalue(l["formule"], e)
    n = int(l["arrondi"])
    att = float(l["resultat_attendu"])
    # rel() de main.typ : compare l'arrondi à resultat_attendu ; on refait le test sur la valeur exacte recalculée.
    signe_typst = "=" if abs(round(att, n) - att) < 1e-9 else "≈"
    signe_exact = "=" if abs(arrondi(calc, n) - calc) < 1e-9 else "≈"
    print(f"  {'OK ' if signe_typst == signe_exact else 'ÉCART'} {l['id']:6} signe rel()={signe_typst} signe attendu (valeur exacte {calc:.10g})={signe_exact}")
    if signe_typst != signe_exact:
        constats.append((l["id"], f"rel() affiche {signe_typst} alors que la valeur exacte appelle {signe_exact}"))
if CODE == "EN02":
    v = {l["id"]: l for l in lire("valeurs.csv")}
    fac = lambda i: float(v[i]["mantisse"]) * 10 ** int(v[i]["exposant"])
    ex = {l["id"]: json.loads(l["entrees_json"]) for l in lignes}
    for nom, x, attendu in [("P_MICRO (BIPM : 1e-6)", fac("P_MICRO"), 1e-6), ("P_MEGA (BIPM : 1e6)", fac("P_MEGA"), 1e6)]:
        ok = abs(x - attendu) / attendu < 1e-12
        print(f"  {'OK ' if ok else 'FAUX'} {nom:28} = {x:g}")
        if not ok:
            constats.append((nom, "facteur de préfixe faux"))
    c_uF = ex["EX13"]["C"] / fac("P_MICRO")
    f_MHz = ex["EX07"]["f"] / fac("P_MEGA")
    print(f"  EX13 : C = {ex['EX13']['C']} F / µ = {c_uF!r} µF → affiché (0 décimale) {arrondi(c_uF, 0):g} µF")
    print(f"  EX07 : f = {ex['EX07']['f']} Hz / M = {f_MHz!r} MHz → affiché {f_MHz:g} MHz")
    if arrondi(c_uF, 0) != 100 or f_MHz != 5:
        constats.append(("préfixes", "valeur convertie inattendue"))
print(f"== {CODE} : {len(constats)} anomalie(s) au total après contrôles v2")
```

### Sortie du script (EN02)

```text
== EN02 : exemples.csv
  OK  EX02   calc=700 attendu=700 écart=0.00e+00 tol=0.0001 arrondi=0 affiché=700 / 700 N
  OK  EX03   calc=7000 attendu=7000 écart=0.00e+00 tol=0.0001 arrondi=0 affiché=7000 / 7000 N
  OK  EX04   calc=40.96 attendu=40.96 écart=1.42e-14 tol=0.0001 arrondi=0 affiché=41 / 41 %
  OK  EX05   calc=2.44140625 attendu=2.4414 écart=6.25e-06 tol=0.0001 arrondi=1 affiché=2.4 / 2.4 ×
  OK  EX06   calc=73.50624803 attendu=73.5062 écart=4.80e-05 tol=0.001 arrondi=0 affiché=74 / 74 mmHg
  OK  EX07   calc=0.308 attendu=0.308 écart=0.00e+00 tol=1e-06 arrondi=2 affiché=0.31 / 0.31 mm
  OK  EX08   calc=1.623376623 attendu=1.62338 écart=3.38e-06 tol=1e-05 arrondi=1 affiché=1.6 / 1.6 kHz
  OK  EX09   calc=0.15 attendu=0.15 écart=2.78e-17 tol=1e-06 arrondi=2 affiché=0.15 / 0.15 m
  OK  EX10   calc=-0.5 attendu=-0.5 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=-0.5 / -0.5 
  OK  EX11   calc=-2 attendu=-2 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=-2 / -2 D
  OK  EX12   calc=2 attendu=2 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=2 / 2 Ω
  OK  EX13   calc=200 attendu=200 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=200 / 200 J
  OK  EX14   calc=149.73 attendu=149.73 écart=0.00e+00 tol=0.0001 arrondi=0 affiché=150 / 150 mmHg
  OK  EX15   calc=2.48 attendu=2.48 écart=0.00e+00 tol=1e-06 arrondi=2 affiché=2.48 / 2.48 eV
  OK  EX16   calc=4 attendu=4 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=4 / 4 
  OK  EX17   calc=50 attendu=50 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=50 / 50 MBq
  OK  EX18   calc=93.33333333 attendu=93.3333 écart=3.33e-05 tol=0.0001 arrondi=0 affiché=93 / 93 mmHg
  OK  EX19   calc=64 attendu=64 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=64 / 64 mmHg
== EN02 : valeurs de référence
  OK  K_C                          donnée=2.998 référence=2.99792458
  OK  K_H                          donnée=6.626 référence=6.62607015
  OK  K_E                          donnée=1.602 référence=1.602176634
  OK  K_NA                         donnée=6.022 référence=6.02214076
  OK  K_KB                         donnée=1.381 référence=1.380649
  OK  K_R                          donnée=8.314 référence=8.314462618
  OK  K_RL                         donnée=0.08206 référence=0.08205736608
  OK  K_G                          donnée=6.674 référence=6.6743
  OK  K_K                          donnée=8.988 référence=8.987551786
  OK  K_EPS                        donnée=8.854 référence=8.854187819
  OK  K_MU                         donnée=1.257 référence=1.256637061
  OK  K_ME                         donnée=9.109 référence=9.109383714
  OK  K_MP                         donnée=1.673 référence=1.672621926
  OK  K_GN                         donnée=9.807 référence=9.80665
  OK  K_HC                         donnée=1240 référence=1239.841984
  OK  U_ATM                        donnée=101.325 référence=101.325
  OK  U_MMHG                       donnée=133.322 référence=133.3223874
  OK  U_CMH2O                      donnée=98.0665 référence=98.0665
  OK  U_MMHG_CMH2O                 donnée=1.36 référence=1.35951
  OK  U_CAL                        donnée=4.184 référence=4.184
  OK  U_EV                         donnée=1.602 référence=1.602176634
  OK  U_ATM_MMHG                   donnée=760 référence=759.9998917
  OK  U_KCAL                       donnée=4184 référence=4184
  OK  U_KELVIN                     donnée=273.15 référence=273.15
  OK  P_DB2 (10 log10 2)           donnée=3 référence=3.010299957
  OK  P_RC63 (1 − 1/e, %)          donnée=63 référence=63.21205588
  OK  P_RC37 (1/e, %)              donnée=37 référence=36.78794412
== EN02 : concordance du texte PDF A4
  17 nombres sans correspondance directe dans les données (à examiner à la main) :
            10  … 4,184 J; 1 eV = 1.602 × 10−19 J; T(K) = T…
            10  …= 2𝜋√𝐿/𝑔. 𝑣 ± 𝑣𝑜 𝐼 𝑃 𝛽 = 10 log10 𝐼= 𝑓′ = …
            10  …𝐼0 𝑣 ∓ 𝑣𝑠 4𝜋𝑟 2 𝐼0 = 1 × 10−12 W/m². Doppl…
           100  …or 6 Ω ∥ 3 Ω = 2 Ω. 𝐶 = 100 𝜇F (0.0001 F) …
            32  …𝑖 = 𝑥𝑖 𝑃total ; mean 𝐾 = 32 𝑘𝐵 𝑇. Atomic …
           108  …ℎ 𝑒 𝑁𝐴 𝑘𝐵 𝑅 𝑅 𝐺 2.998 × 108 m/s 6.626 × 10…
            10  … 2.998 × 108 m/s 6.626 × 10−34 J·s 1.602 ×…
            10  ….626 × 10−34 J·s 1.602 × 10−19 C 6.022 × 1…
          1023  … 1.602 × 10−19 C 6.022 × 1023 mol⁻¹ 1.381 × …
            10  …022 × 1023 mol⁻¹ 1.381 × 10−23 J/K 8.314 J…
            10  …6 L·atm/ (mol·K) 6.674 × 10−11 N·m²/ kg² …
           109  …1 N·m²/ kg² 𝑔𝑛 8.988 × 109 N·m²/C² 8.854 …
            10  …88 × 109 N·m²/C² 8.854 × 10−12 F/m 1.257 ×…
            10  ….854 × 10−12 F/m 1.257 × 10−6 N/A² 9.109 ×…
            10  ….257 × 10−6 N/A² 9.109 × 10−31 kg 1.673 × …
            10  …9.109 × 10−31 kg 1.673 × 10−27 kg 9.807 m/…
          2022  …m 𝑘 𝜀0 𝜇0 𝑚𝑒 𝑚𝑝 CODATA 2022 values, rounde…
== EN02 : 0 anomalie(s) détectée(s) par script
== EN02 : contrôles v2
  OK  EX02   signe rel()== signe attendu (valeur exacte 700)==
  OK  EX03   signe rel()== signe attendu (valeur exacte 7000)==
  OK  EX04   signe rel()=≈ signe attendu (valeur exacte 40.96)=≈
  OK  EX05   signe rel()=≈ signe attendu (valeur exacte 2.44140625)=≈
  OK  EX06   signe rel()=≈ signe attendu (valeur exacte 73.50624803)=≈
  OK  EX07   signe rel()=≈ signe attendu (valeur exacte 0.308)=≈
  OK  EX08   signe rel()=≈ signe attendu (valeur exacte 1.623376623)=≈
  OK  EX09   signe rel()== signe attendu (valeur exacte 0.15)==
  OK  EX10   signe rel()== signe attendu (valeur exacte -0.5)==
  OK  EX11   signe rel()== signe attendu (valeur exacte -2)==
  OK  EX12   signe rel()== signe attendu (valeur exacte 2)==
  OK  EX13   signe rel()== signe attendu (valeur exacte 200)==
  OK  EX14   signe rel()=≈ signe attendu (valeur exacte 149.73)=≈
  OK  EX15   signe rel()== signe attendu (valeur exacte 2.48)==
  OK  EX16   signe rel()== signe attendu (valeur exacte 4)==
  OK  EX17   signe rel()== signe attendu (valeur exacte 50)==
  OK  EX18   signe rel()=≈ signe attendu (valeur exacte 93.33333333)=≈
  OK  EX19   signe rel()== signe attendu (valeur exacte 64)==
  OK  P_MICRO (BIPM : 1e-6)        = 1e-06
  OK  P_MEGA (BIPM : 1e6)          = 1e+06
  EX13 : C = 0.0001 F / µ = 100.00000000000001 µF → affiché (0 décimale) 100 µF
  EX07 : f = 5000000 Hz / M = 5.0 MHz → affiché 5 MHz
== EN02 : 0 anomalie(s) au total après contrôles v2
```
