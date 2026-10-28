# Vérification EN03-STD : Chemistry Formula Sheet (College & Pre-Med) (rapport v1)

- **Run :** R01, agent VÉRIFICATEUR (sans participation à la production), 28.10.2026
- **Objet :** `produits/EN03/` (src, donnees, livraison/EN03-STD : a4, letter, nb, tablette), risque IA FAIBLE, Whop + Etsy, sans relecture métier
- **Méthode :** build dans une copie du dépôt (4 PDF, contrôles `controle_pdf` OK, texte identique aux PDF livrés) ; recalcul indépendant des 16 exemples, **y compris les logarithmes fournis en entrée (`L`)** ; contrôle de `valeurs.csv` contre CODATA 2022 et NIST SP 811 ; concordance du PDF A4 ; relecture du PDF A4 à 110 dpi ; page 1 des autres formats ; vérification en ligne des tableaux IR/RMN, VSEPR et inhibition contre les sources citées.

## Verdict : **À corriger**

Calculs, constantes et chimie générale sont justes : aucun BLOQUANT. Trois MAJEURS doivent être levés avant publication. La fiche ne livre pas ce que l'annonce Whop promet (nombre d'encadrés cliniques et de pièges, courbe de titrage). Deux tableaux ne sont pas couverts par leur source citée : les inhibitions incompétitive et mixte ne figurent pas dans Berg 5e, et les bornes IR/RMN diffèrent de McMurry.

| Gravité | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 3 |
| MINEUR | 6 |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | Fiche entière vs `donnees/brief-whop.md` (annonce Whop prod_8a0pATJq6gFX2) | L'annonce promet « 11 clinical "MED" boxes », « 9 common exam traps » et une « titration curve ». La fiche contient 4 notes cliniques (bicarbonate, potentiel de membrane, oxymétrie, gaz alvéolaire) plus un encadré d'exemples de chimie médicale, 6 pièges, et aucune courbe : le titrage tient en une phrase. Un acheteur ou une acheteuse qui compare reçoit moins que promis, d'où un risque de litige (docs/conformite.md § 6 : frais fixes par litige). Le « spontaneity table » est aussi un texte, non un tableau. | Soit compléter la fiche (pièges 7 à 9 ; petite courbe de titrage dessinée en code ; encadrés MED en notes courtes), soit réécrire l'annonce Whop pour qu'elle décrive exactement le PDF. La seconde option est plus sûre si la page doit rester d'une seule page A4. |
| M2 | MAJEUR | PDF, tableau des inhibiteurs (colonne 2) ; `references.csv` ligne BERG_BIOCHEM5 | Le contenu est juste, mais la source citée ne le couvre pas. Berg, Tymoczko, Stryer 5e, section 8.5 (NBK22530) traite des inhibitions compétitive et non compétitive. Elle **ne décrit pas l'inhibition incompétitive** et ne mentionne la mixte qu'en une phrase, sans effet sur Km ni Vmax. Deux lignes sur quatre n'ont donc pas de source. | Citer une source qui couvre les quatre types avec leurs effets : manuel de biochimie plus récent (chapitre et pages) ou recommandations IUBMB sur la terminologie de la cinétique enzymatique. |
| M3 | MAJEUR | `spectro.csv` (tableaux IR et ¹H RMN) ; `references.csv` lignes OPENSTAX_OCHEM | Bornes différentes de la source citée (OpenStax *Organic Chemistry*). IR : O–H alcool 3200–3600 dans la fiche, **3400–3650** dans la source (§ 12.8). RMN (Table 13.3) : aldéhyde 9.0–10.0 contre **9.7–10.0** ; COOH 10–12 contre **11.0–12.0** ; H–C–C=O 2.0–2.5 contre **2.0–2.4** ; alkyle 0.9–1.8 contre **0.7–1.8**. Ces bornes restent dans l'usage courant d'autres manuels (pas de valeur fausse), mais la référence ne les soutient pas. O–H acide et C≡N n'ont pas pu être confrontés (Table 12.1 non récupérée). | Aligner `spectro.csv` sur les tables 12.1 et 13.3 (localisation précise), ou citer la source réelle des bornes retenues. |
| m1 | MINEUR | PDF, résultats arrondis écrits avec « = » | n = 0.40621 affiché « = 0.406 mol » ; ΔG « = −32.9 » ; CaO₂ « = 20.0 » (19.998) ; t½ « = 6.9 h » (6.93) ; E « = −95 mV » (−94.96). Pour des valeurs arrondies, la convention est ≈ (EN01 et EN02 l'appliquent). | Faire afficher par `res()` « ≈ » quand la valeur arrondie diffère de `resultat_attendu`. |
| m2 | MINEUR | `references.csv`, ligne VSEPR | L'angle de NH₃ ne figure pas dans le texte de la section 7.6 d'OpenStax *Chemistry 2e* mais dans la figure 7.18 (106.8°, affiché ≈107° : juste). H₂O 104.5° est bien dans le texte. | Localiser NH₃ « figure 7.18 » et lever l'A-VERIFIER. |
| m3 | MINEUR | `references.csv` SMITHLINE_1976 | Article cité de seconde main (StatPearls), non consulté (A-VERIFIER ouvert). La formule 2 Na + glucose/18 + BUN/2.8 est juste. | Consulter le résumé ou l'article, ou citer StatPearls NBK567764 comme source directe. |
| m4 | MINEUR | `references.csv` OPENSTAX_OCHEM (pI) | Numéro de section toujours ouvert (page 26.3 non récupérée pendant la vérification). Le contenu est juste (glycine 2.34 / 9.60 → pI 5.97). | Vérifier « 26.3 » et lever l'A-VERIFIER. |
| m5 | MINEUR | `references.csv` PH2O (NIST_WEBBOOK) | 47 mmHg à 37 °C est juste (6.28 kPa = 47.1 mmHg). La divergence signalée avec StatPearls (« environ 45 ») reste à documenter. | Garder 47 ; supprimer la mention contradictoire ou l'expliquer. |
| m6 | MINEUR | `exemples.csv` EX06 | `R` est arrondi (0.028571) et `L` calculé sur ce R arrondi (−1.54407 ; exact −1.544068). L'écart est sans effet à l'affichage (−95 mV). | Donner R = 4 / 140 sans arrondi, ou L = −1.544068. |

### Contrôles passés sans constat
- **Calculs :** 16 / 16 lignes recalculées (écart max 3.2 × 10⁻⁶ dans la tolérance) ; logarithmes recalculés : log₁₀ 20 = 1.301030 (L = 1.30103), log₁₀ 0.028571 = −1.544075 (L = −1.54407), log₁₀ 10 = 1 ; arrondis affichés conformes à la colonne `arrondi`.
- **Constantes :** N_A, R (J et L·atm), F, h, c, V_m (22.41396954 L/mol, CODATA 2022), 1 atm = 101.325 kPa = 760 mmHg, 0 °C = 273.15 K, cal = 4.184 J, ln 10, ln 2, facteurs de Nernst à 25 °C (0.059159 V) et 37 °C (61.54 mV), diviseurs 18 et 2.8 recalculés depuis les masses atomiques. Tout est conforme à la précision affichée.
- **Fond :** formules d'unités, gaz, thermochimie (signes de spontanéité), cinétique, Michaelis–Menten et Lineweaver–Burk, équilibre, Ksp, acides-bases, tableau des troubles acido-basiques (primaire et compensation), propriétés colligatives (Kf 1.86, Kb 0.512), électrochimie (galvanique vs électrolytique), CIP R/S, SN1/SN2, Beer–Lambert, oxymétrie 660/940 nm, trou anionique (4–12), osmolalité (275–295), CaO₂, t½ = 0.693 Vd/CL, équation des gaz alvéolaires : tout est juste. Le tableau VSEPR est juste (SO₂ < 120°, NH₃ ≈ 107°, H₂O ≈ 104.5°).
- **Concordance :** tous les nombres du PDF A4 proviennent des données. Les seuls nombres hors données sont des notations (1 → 2 → 3, 3° > 2°, n + 1) et des exposants que pdftotext lit mal (10²³, 10⁸).
- **Droits :** les sources OpenStax sont sous CC BY 4.0. Aucune reprise textuelle repérée par sondage ; les tableaux IR/RMN ne recopient pas ceux d'OpenStax, puisque leurs bornes diffèrent (voir M3). Aucune question d'examen. Mention MCAT de non-affiliation présente.
- **Forme :** 4 formats, 3 mentions présentes, N&B sans couleur, tablette sur 3 pages avec sommaire (14 entrées). Rien n'est coupé en page 1 de chaque format. Corps très dense mais lisible à 100 %.

## Script de recalcul

Même script que pour EN01 et EN02 (`recalcul.py`, lancé par `python3 -I recalcul.py <racine> EN03 <texte_pdf_a4.txt>`). Sortie pour EN03 à la suite.

```python
#!/usr/bin/env python3
"""Vérificateur R01 : recalcul indépendant des exemples, contrôle des valeurs de référence et concordance PDF.

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
```

### Sortie du script (EN03)

```text
== EN03 : exemples.csv
  OK  EX01   calc=25 attendu=25 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=25 / 25 mL
  OK  EX02   calc=0.4062068405 attendu=0.40621 écart=3.16e-06 tol=1e-05 arrondi=3 affiché=0.406 / 0.406 mol
  OK  EX03   calc=-32.898 attendu=-32.898 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=-32.9 / -32.9 kJ/mol
  OK  EX04   calc=20 attendu=20 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=20 / 20 
  OK  EX05   calc=7.40103 attendu=7.40103 écart=8.88e-16 tol=1e-06 arrondi=2 affiché=7.40 / 7.4  ; log10(R=20)=1.301030 vs L=1.30103 (écart 4.3e-09)
  OK  EX06   calc=-94.960305 attendu=-94.960305 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=-95 / -95 mV ; log10(R=0.028571)=-1.544075 vs L=-1.54407 (écart 4.6e-06) ; log10(Kext/Kint)=-1.544068 ⇒ E exact=-94.9602
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
          1023  … 𝑁𝐴 = 6.022 × 1023 mol⁻¹ · 𝑅 = 8.…
           108  …× 10−34 J·s · 𝑐 = 3.00 × 108 m/s · 𝐾𝑤 (25 °…
== EN03 : 0 anomalie(s) détectée(s) par script
```
