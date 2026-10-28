# Vérification EN02-STD : Physics Formula Sheet (College & Pre-Med) (rapport v1)

- **Run :** R01, agent VÉRIFICATEUR (sans participation à la production), 28.10.2026
- **Objet :** `produits/EN02/` (src, donnees, livraison/EN02-STD : a4, letter, nb, tablette), risque IA FAIBLE, Whop + Etsy, sans relecture métier
- **Méthode :** build dans une copie du dépôt (4 PDF, contrôles `controle_pdf` OK, texte identique aux PDF livrés) ; recalcul indépendant des 18 exemples ; contrôle des 42 lignes de `valeurs.csv` contre CODATA 2022, NIST SP 811 et les définitions exactes ; concordance du PDF A4 ; relecture du PDF A4 à 110 dpi ; page 1 des autres formats ; vérification en ligne de la vitesse du son dans les tissus (OpenStax).

## Verdict : **OK avec réserves**

Aucune erreur de calcul, de constante ni de physique. Les doses d'imagerie (Mettler 2008) et les facteurs w_R (CIPR 103) sont justes, de même que le seuil de sténose aortique sévère (v_max ≥ 4 m/s, EACVI/ASE 2017). Les réserves portent sur la forme, la précision de quelques notations et des localisations de références encore ouvertes.

| Gravité | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 0 |
| MINEUR | 9 |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| m1 | MINEUR | Fiche vs `brief-whop.md` | L'annonce promet « 10 clinical notes » ; la fiche en contient 9 (un encadré à 9 puces). Exemples (≥ 10 valeurs calculées) et pièges (12) sont conformes. | Ajouter une note ou corriger le chiffre dans l'annonce. |
| m2 | MINEUR | PDF, « Atomic & nuclear » | λ désigne sur la même ligne la longueur d'onde (E = hc/λ) et la constante de désintégration (A = λN ; λ = ln 2/T½). | Écrire la constante de désintégration avec une autre lettre ou préciser « λ (decay constant) ». |
| m3 | MINEUR | PDF « Poiseuille and IV bag » (« 41 % »), « Circuits » (« 63 % », « 37 % ») ; `src/main.typ` l. 152 | Espace avant % dans une fiche en anglais US. EN01 écrit « 0.9% ». | Supprimer l'espace dans le Typst, ou faire porter l'unité par le composant de nombre. |
| m4 | MINEUR | PDF « Parallel and defibrillator » | C affiché « 0.0001 F ». L'énoncé (exemples.csv) parle de 100 µF, la notation courante. | Afficher « 100 µF (0.0001 F) ». |
| m5 | MINEUR | PDF « Ultrasound » ; `src/main.typ` l. 261 | Le diviseur Hz → MHz (1000000) est tapé dans le Typst, et λ = 0.308 est affiché « = 0.31 mm » (valeur arrondie écrite avec =). | Mettre le facteur dans `valeurs.csv` ; afficher ≈ pour une valeur arrondie. |
| m6 | MINEUR | PDF « Light & optics » | Angle critique sin θ_c = n₂/n₁ sans la condition n₁ > n₂. | Ajouter « (n₁ > n₂) ». |
| m7 | MINEUR | PDF, tableau médical, lignes « Doses » et « Gy to Sv » | Les doses sont des doses **efficaces** (mSv), mais la fiche ne définit que la dose équivalente H = w_R D. Rien ne dit que la dose efficace pondère aussi par organe (w_T). | Ajouter « effective dose E = Σ w_T H_T (whole-body risk) », CIPR 103, chapitre 4 (grandeurs de dose). |
| m8 | MINEUR | `references.csv`, 6 lignes A-VERIFIER | Localisations encore ouvertes : Laplace (source manuel), anévrisme, COSTANZO_PHYSIO (édition et page), ESC_ASE_AS_2017 (numéro du tableau), US_STD_ATM_1976 (numéro du tableau), CRC_HANDBOOK (édition), et une référence de physiologie respiratoire pour « inspiration = Boyle ». Aucune valeur en cause. | Compléter les localisations. |
| m9 | MINEUR | Titre de section « Constants (CODATA 2022) » | « 2022 » est tapé en dur. hc = 1,240 eV·nm, g_n et R en L·atm sont des valeurs dérivées ou conventionnelles, pas des valeurs CODATA à proprement parler. | Titre « Constants » et source en note, ou mention « (CODATA 2022 and derived) ». |

### Références `A-VERIFIER` : état
- **Levée :** c_tissu = 1540 m/s figure bien dans OpenStax *College Physics 2e*, § 17.7 Ultrasound (texte et exemple 17.8). Le décalage Doppler y est décrit comme « double shift », ce qui justifie le facteur 2.
- **Ouvertes :** voir m8.

### Contrôles passés sans constat
- **Calculs :** 18 / 18 lignes recalculées (écarts ≤ 4.8 × 10⁻⁵, dans les tolérances), arrondis affichés conformes à la colonne `arrondi` (41 %, ×2.4, 74 mmHg, 0.31 mm, 1.6 kHz, 150 mmHg, 93 mmHg…).
- **Constantes et unités :** c, h, e, N_A, k_B, R, G, k, ε₀, µ₀, m_e, m_p (CODATA 2022) ; g_n 9.80665 ; hc/e = 1239.84 eV·nm (affiché 1240) ; 1 atm = 101.325 kPa = 760 mmHg ; 1 mmHg = 133.322 Pa = 1.3595 cmH₂O ; cmH₂O = 98.0665 Pa ; cal 4.184 J ; 10 log₁₀ 2 = 3.01 dB ; 1 − e⁻¹ = 63.2 % ; e⁻¹ = 36.8 %. Tout est conforme à la précision affichée.
- **Fond :** cinématique, dynamique, plan incliné, énergie, quantité de mouvement, circulaire, gravitation, fluides (Bernoulli, Poiseuille, Laplace), ondes, Doppler (signes), optique (tableau des signes lentilles et miroirs, dioptries), électricité, circuits (RC), thermodynamique (ΔU = Q − W par le gaz), désintégrations α, β⁻, β⁺, demi-vie, Gy et Sv : tout est juste. Le tableau médical l'est aussi : PAM, ΔP = 4v², PIO₂ = 0.21 × (760 − 47), doses Mettler 2008 (radio thorax 0.02 et 0.1 mSv, mammographie 0.4, scanners 2/7/8, fond naturel 3 mSv/an).
- **Concordance :** tous les nombres du PDF A4 proviennent des données. Les seuls nombres hors données sont des exposants mal lus par pdftotext, des coefficients de formules et les cas de m5 et m9.
- **Droits :** OpenStax *College Physics* est sous CC BY 4.0. Les énoncés sont reformulés en puces courtes et aucune reprise textuelle n'a été repérée par sondage ; le tableau des signes est reformulé. Aucune question d'examen. Mention MCAT de non-affiliation présente.
- **Forme :** 4 formats, 3 mentions présentes, N&B sans couleur, tablette sur 3 pages avec sommaire (15 entrées). Rien n'est coupé en page 1 de chaque format.

## Script de recalcul

Même script que pour EN01 et EN03 (`recalcul.py`, lancé par `python3 -I recalcul.py <racine> EN02 <texte_pdf_a4.txt>`). Sortie pour EN02 à la suite.

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
  16 nombres sans correspondance directe dans les données (à examiner à la main) :
            10  … 4,184 J; 1 eV = 1.602 × 10−19 J; T(K) = …
            32  …𝑖 = 𝑥𝑖 𝑃total ; mean 𝐾 = 32 𝑘𝐵 𝑇. …
          2022  … Constants (CODATA 2022) …
           108  … 𝑐 2.998 × 108 m/s 𝑘 …
           109  …/s 𝑘 8.988 × 109 N·m²/C² …
            10  … ℎ 6.626 × 10−34 J·s 𝜀0…
            10  … J·s 𝜀0 8.854 × 10−12 F/m Lapla…
            10  … 𝑒 1.602 × 10−19 C 𝜇0…
            10  … C 𝜇0 1.257 × 10−6 N/A² …
          1023  … 𝑁𝐴 6.022 × 1023 mol⁻¹ 𝑚𝑒 …
            10  …mol⁻¹ 𝑚𝑒 9.109 × 10−31 kg Exa…
            10  … 𝑘𝐵 1.381 × 10−23 J/K 𝑚𝑝…
            10  … J/K 𝑚𝑝 1.673 × 10−27 kg Radius…
            10  … 6.674 × 10−11 N·m²/ …
            10  … small alveoli 𝛽 = 10 log10 𝐼= …
            10  …her wall ten­ 𝐼0 = 1 × 10−12 W/m². Doppl…
== EN02 : 0 anomalie(s) détectée(s) par script
```
