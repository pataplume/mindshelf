# Vérification EN03-STD : Chemistry Formula Sheet (College & Pre-Med) (rapport v2)

- **Run :** R01, agent VÉRIFICATEUR (contre-vérification v2, sans participation à la production ni à la correction), 28.10.2026
- **Objet :** levée des constats du rapport v1 ; régressions de la correction ; nouvelles références.
- **Méthode :** relecture des données (`exemples.csv`, `spectro.csv`, `references.csv`, `contenu.csv`), de `src/main.typ` (dont la nouvelle fonction `rel()`) et du PDF A4 livré (pdftotext et rendu PNG de la page 1 à 80 dpi) ; recalcul des 16 exemples avec le script v1 complété (signe `=` ou `≈` recalculé depuis la valeur exacte) ; build `scripts/build.py EN03-STD` lancé une fois dans une copie du dépôt, pour ne rien écrire hors de `verif/` : 4 PDF, 32 contrôles OK, texte identique aux 4 PDF livrés ; vérification en ligne d'OpenStax *Organic Chemistry* (tableaux 12.1 et 13.3, § 26.2) et de StatPearls NBK545242 et NBK567764.

## Verdict : **À corriger** (correction documentaire légère, le PDF n'a pas à changer)

Les calculs, les tableaux et la chimie sont justes, et la correction n'a introduit aucune régression. M2, M3 et les six mineurs sont levés. Deux points restent avant publication :
- **M1** (l'annonce promet plus que la fiche) n'est pas levé dans le produit : `brief-whop.md` est inchangé. Le journal R01 prévoit de réécrire l'annonce au conditionnement, ce qui reste une condition de publication.
- **N1, nouveau MAJEUR :** la référence de la formule d'osmolalité affirme que StatPearls NBK567764 donne l'expression 2 Na + glucose/18 + BUN/2.8. La page ne la donne pas.

| Gravité | Restants |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 2 (M1 reporté au conditionnement, N1) |
| MINEUR | 2 (N2, N3) |

## Constats v1 → état

| # v1 | Gravité v1 | État | Preuve |
|---|---|---|---|
| M1 | MAJEUR | **Non levé (reporté)** | `contenu.csv` décrit désormais le PDF réel : 4 notes cliniques, 6 pièges, 6 tableaux, 14 exemples (compte vérifié sur le PDF). `brief-whop.md` promet toujours « 11 clinical "MED" boxes », « 9 common exam traps » et une « titration curve ». Le journal R01 renvoie la réécriture de l'annonce au conditionnement. Tant que l'annonce publiée n'est pas réécrite d'après `contenu.csv`, le défaut demeure. |
| M2 | MAJEUR | **Levé** | `references.csv` l. 34 cite Lehninger 7e, ch. 6, § 6.3, tableau 6-9, plus StatPearls NBK545242, vérifié en ligne : Delaune KP, Alsayouri K, mise à jour du 12.09.2022. Le chapitre couvre trois lignes sur quatre : non compétitif (Vmax ↓, Km =), compétitif (Km ↑, Vmax =), incompétitif (Km ↓, Vmax ↓). Il nomme l'inhibition mixte sans en donner les effets : la ligne « Mixed » (↑/↓, ↓) ne repose donc que sur Lehninger, cité de seconde main mais conforme au contenu connu du tableau 6-9 (A-VERIFIER 1). Le tableau du PDF est juste. |
| M3 | MAJEUR | **Levé** | `spectro.csv` est aligné sur la source, vérifiée en ligne sur openstax.org. Tableau 12.1 « Characteristic IR Absorptions of Some Functional Groups » (§ 12.7) : alcool O–H 3400–3650, acide O–H 2500–3100, N–H 3300–3500, C≡N 2210–2260 et C≡C 2100–2260 (regroupés en 2100–2260), C=O 1670–1780. Tableau 13.3 « Correlation of ¹H Chemical Shifts with Environment » (§ 13.4) : alkyle 0.7–1.3, 1.2–1.6, 1.4–1.8 (regroupés en 0.7–1.8), méthylcétone 2.0–2.4, H–C–O 3.3–4.5, vinylique 4.5–6.5, aryle 6.5–8.0, aldéhyde 9.7–10.0, COOH 11.0–12.0. Les 12 bornes concordent avec le PDF (p. 1, encadrés « IR band » et « ¹H NMR »). |
| m1 | MINEUR | **Levé** | `rel()` affiche « ≈ » pour EX02, EX03, EX05, EX06, EX09, EX11 et EX15, et « = » pour les valeurs exactes. Le PDF montre « 𝑛 ≈ 0.406 mol », « Δ𝐺 ≈ −32.9 », « CaO₂ ≈ 20.0 », « 𝑡½ ≈ 6.9 h », « ≈ −95 mV » et « 𝐸 ≈ 1.07 ». Le script v2 recalcule le signe depuis la valeur exacte : 16 sur 16 concordent. |
| m2 | MINEUR | **Levé** | NH₃ localisé « figure 7.18 » (`references.csv` l. 22), A-VERIFIER retiré. |
| m3 | MINEUR | **Levé, mais remplacé par N1** | Smithline est désormais cité par l'intermédiaire de StatPearls NBK567764. La localisation affirme toutefois un contenu que la page n'a pas (voir N1). |
| m4 | MINEUR | **Levé par le vérificateur, données à mettre à jour** | `references.csv` l. 47 garde « A-VERIFIER : numéro de section ». Vérifié en ligne : la section est **26.2** (openstax.org/books/organic-chemistry/pages/26-2-amino-acids-and-the-henderson-hasselbalch-equation-isoelectric-points), et non 26.3 comme le v1 le suggérait. Il suffit de l'écrire et de retirer l'A-VERIFIER. |
| m5 | MINEUR | **Levé** | `references.csv` l. 60 retient 47 mmHg (NIST, 6.28 kPa) et explique l'arrondi « environ 45 » de StatPearls. |
| m6 | MINEUR | **Levé** | EX06 : R = 0.0285714, L = −1.544068, soit log₁₀(4/140) = −1.5440680 (écart 4.4 × 10⁻⁸ sur L ; écart de log₁₀ R à L 4.8 × 10⁻⁷). Résultat −94.960182 mV, recalculé à l'identique ; affiché « ≈ −95 mV ». |

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| N1 | MAJEUR | `references.csv` l. 53 (STATPEARLS_OSM) ; formule « Osm = 2 Na⁺ + Glu/18 + BUN/2.8 » du PDF, encadré High-Yield Med Chem | La localisation dit que l'introduction de NBK567764 donne la formule 2 Na + glucose/18 + BUN/2.8. J'ai lu la page deux fois en ligne : elle dit seulement que « the Smithline-Gardner formula is considered the most accurate », sans en écrire l'expression (ni « 18 » ni « 2.8 » dans le texte). La formule de la fiche est juste et l'intervalle 275–295 mOsm/kg est bien sur la page (l. 55 confirmée), mais l'expression n'a plus de source consultée. Réserve : la page pourrait afficher la formule en image, ce que ma lecture ne voit pas. | Ouvrir NBK567764 dans un navigateur. Si la formule n'y figure pas, citer une source qui l'écrit en texte : le résumé de Smithline N, Gardner KD Jr, JAMA 1976;236(14):1594-1597, ou un ouvrage de médecine de laboratoire (chapitre et page). Corriger la localisation dans tous les cas. Le PDF ne change pas. |
| N2 | MINEUR | PDF, « Amino acid pI » (« 2.34 and 9.6 ») et « Electrochemistry » (« 𝐸° = 1.1 V ») ; `exemples.csv` EX15, EX16 | Les entrées sont saisies avec un chiffre significatif de moins que l'usage : pKa₂ de la glycine 9.60 (McMurry, tableau 26.1), E° de la pile Daniell 1.10 V. Les résultats restent justes (5.97 ; 1.07 V), mais « 9.6 » à côté de « 2.34 » et « 5.97 » paraît incohérent. Constat antérieur à la correction, que le v1 n'avait pas relevé. | Saisir « 9.60 » et « 1.10 » sous forme de chaîne, ou porter le nombre de décimales d'affichage des entrées dans une colonne de `exemples.csv`. |
| N3 | MINEUR | `src/main.typ`, `rel()` | `rel()` compare l'arrondi à `resultat_attendu`, pas à la valeur recalculée. Le signe est aujourd'hui juste partout (16 sur 16 d'après le script v2). Une ligne dont `resultat_attendu` serait saisi déjà arrondi à `arrondi` décimales, alors que la formule donne davantage de décimales, afficherait pourtant « = » à tort. | Faire porter le test de `rel()` sur la valeur recalculée (`calcule`), déjà disponible dans `exemples`. |

Aucune régression trouvée par ailleurs. `v()` convertit bien U+2212 en tiret, d'où « (−1.544068) » correctement signé. Les tableaux IR et RMN ne débordent pas. Le build est conforme dans les 4 formats (mentions, N&B, tablette sur 3 pages avec 14 entrées de sommaire). Le rendu de la page 1 ne montre rien de coupé. Concordance : les seuls nombres du PDF A4 absents des données sont 10²³ et 10⁸, des exposants que pdftotext lit mal.

## A-VERIFIER restants et avis

| # | Emplacement | Objet | Avis |
|---|---|---|---|
| 1 | `references.csv` l. 34 | Lehninger 7e, § 6.3 et tableau 6-9, cités de seconde main (cours Gonzaga). C'est la seule source de la ligne « Mixed ». | **Ne bloque pas.** Le contenu (αKm/α′, Vmax/α′) correspond au tableau 6-9 tel que je le connais, et la ligne est juste. À consulter dans l'ouvrage quand il sera disponible. |
| 2 | `references.csv` l. 47 | Numéro de section du pI. | **Ne bloque pas.** C'est la section 26.2, vérifiée en ligne : il reste à l'écrire. |
| 3 | `references.csv` l. 53 (N1) | Expression de la formule d'osmolalité. | **Bloque**, au titre du MAJEUR : la localisation est inexacte en l'état. La correction se fait en quelques minutes et ne touche pas le PDF. |
| — | `brief-whop.md` (M1) | Annonce Whop. | **Bloque la mise en ligne** tant que l'annonce n'est pas réécrite d'après `contenu.csv`. Ne bloque pas le PDF. |

## Script de recalcul

Le script v1 (reproduit dans `rapport-v1.md`) est repris tel quel, complété d'une section 4 : signe « = » ou « ≈ » recalculé depuis la valeur exacte, et facteurs de préfixes pour EN02. Il se lance par `python3 -I recalcul_v2.py <racine> EN03 <texte_pdf_a4.txt>`.

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

### Sortie du script (EN03)

```text
== EN03 : exemples.csv
  OK  EX01   calc=25 attendu=25 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=25 / 25 mL
  OK  EX02   calc=0.4062068405 attendu=0.40621 écart=3.16e-06 tol=1e-05 arrondi=3 affiché=0.406 / 0.406 mol
  OK  EX03   calc=-32.898 attendu=-32.898 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=-32.9 / -32.9 kJ/mol
  OK  EX04   calc=20 attendu=20 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=20 / 20 
  OK  EX05   calc=7.40103 attendu=7.40103 écart=8.88e-16 tol=1e-06 arrondi=2 affiché=7.40 / 7.4  ; log10(R=20)=1.301030 vs L=1.30103 (écart 4.3e-09)
  OK  EX06   calc=-94.960182 attendu=-94.960182 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=-95 / -95 mV ; log10(R=0.0285714)=-1.544068 vs L=-1.544068 (écart 4.8e-07) ; log10(Kext/Kint)=-1.544068 ⇒ E exact=-94.9602
  OK  EX07   calc=26 attendu=26 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=26 / 26 mEq/L
  OK  EX08   calc=290 attendu=290 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=290 / 290 mOsm/kg
  OK  EX09   calc=19.998 attendu=19.998 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=20.0 / 20 mL O2/dL
  OK  EX10   calc=0.3 attendu=0.3 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=0.3 / 0.3 mL O2/dL
  OK  EX11   calc=6.93 attendu=6.93 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=6.9 / 6.9 h
  OK  EX12   calc=1.86 attendu=1.86 écart=0.00e+00 tol=1e-06 arrondi=2 affiché=1.86 / 1.86 °C
  OK  EX13   calc=75 attendu=75 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=75 / 75 µmol/min
  OK  EX14   calc=100 attendu=100 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=100 / 100 µM
  OK  EX15   calc=1.0704 attendu=1.0704 écart=0.00e+00 tol=1e-06 arrondi=2 affiché=1.07 / 1.07 V ; log10(R=10)=1.000000 vs L=1 (écart 0.0e+00)
  OK  EX16   calc=5.97 attendu=5.97 écart=0.00e+00 tol=1e-06 arrondi=2 affiché=5.97 / 5.97 
== EN03 : valeurs de référence
  OK  NA (mantisse)                donnée=6.022 référence=6.02214076
  OK  R_J                          donnée=8.314 référence=8.314462618
  OK  R_ATM                        donnée=0.08206 référence=0.08205736608
  OK  F                            donnée=96485 référence=96485.33212
  OK  H (mantisse)                 donnée=6.626 référence=6.62607015
  OK  C (mantisse, 3.00 × 10^8)    donnée=3.00 référence=2.99792458
  OK  ATM_KPA                      donnée=101.325 référence=101.325
  OK  ATM_MMHG                     donnée=760 référence=759.9998917
  OK  VM                           donnée=22.4 référence=22.41396954
  OK  T0                           donnée=273.15 référence=273.15
  OK  CAL                          donnée=4.184 référence=4.184
  OK  LN10                         donnée=2.303 référence=2.302585093
  OK  LN2                          donnée=0.693 référence=0.6931471806
  OK  NERNST25                     donnée=0.0592 référence=0.05915934969
  OK  NERNST37                     donnée=61.5 référence=61.54040686
  OK  OSM_GLU (M glucose/10)       donnée=18 référence=18.0156
  OK  OSM_BUN (2 N/10)             donnée=2.8 référence=2.8014
  OK  PH_NEUTRE                    donnée=7 référence=7
== EN03 : concordance du texte PDF A4
  2 nombres sans correspondance directe dans les données (à examiner à la main) :
          1023  …nts & Traps 𝑁𝐴 = 6.022 × 1023 mol⁻¹ · 𝑅 = 8.…
           108  …× 10−34 J·s · 𝑐 = 3.00 × 108 m/s · 𝐾𝑤 (25 °…
== EN03 : 0 anomalie(s) détectée(s) par script
== EN03 : contrôles v2
  OK  EX01   signe rel()== signe attendu (valeur exacte 25)==
  OK  EX02   signe rel()=≈ signe attendu (valeur exacte 0.4062068405)=≈
  OK  EX03   signe rel()=≈ signe attendu (valeur exacte -32.898)=≈
  OK  EX04   signe rel()== signe attendu (valeur exacte 20)==
  OK  EX05   signe rel()=≈ signe attendu (valeur exacte 7.40103)=≈
  OK  EX06   signe rel()=≈ signe attendu (valeur exacte -94.960182)=≈
  OK  EX07   signe rel()== signe attendu (valeur exacte 26)==
  OK  EX08   signe rel()== signe attendu (valeur exacte 290)==
  OK  EX09   signe rel()=≈ signe attendu (valeur exacte 19.998)=≈
  OK  EX10   signe rel()== signe attendu (valeur exacte 0.3)==
  OK  EX11   signe rel()=≈ signe attendu (valeur exacte 6.93)=≈
  OK  EX12   signe rel()== signe attendu (valeur exacte 1.86)==
  OK  EX13   signe rel()== signe attendu (valeur exacte 75)==
  OK  EX14   signe rel()== signe attendu (valeur exacte 100)==
  OK  EX15   signe rel()=≈ signe attendu (valeur exacte 1.0704)=≈
  OK  EX16   signe rel()== signe attendu (valeur exacte 5.97)==
== EN03 : 0 anomalie(s) au total après contrôles v2
```
