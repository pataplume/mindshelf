# Vérification EN01-STD : Dosage Calculation & IV Drip Rates (rapport v1)

- **Run :** R01, agent VÉRIFICATEUR (sans participation à la production), 28.10.2026
- **Objet :** `produits/EN01/` (src, donnees, livraison/EN01-STD : a4, letter, nb, tablette), risque IA **FORT**, relecture métier obligatoire, Whop seul
- **Méthode :** build dans une copie du dépôt (`python3 scripts/build.py EN01-STD` : 4 PDF fabriqués, tous les contrôles `controle_pdf` OK, texte des PDF identique à celui des PDF livrés) ; recalcul indépendant des 22 lignes de `exemples.csv` et des valeurs de `valeurs.csv` et `menager.csv` contre leurs définitions exactes (script ci-dessous) ; concordance des nombres du PDF A4 ; relecture du PDF A4 rendu à 110 dpi ; page 1 des 3 autres formats ; références `A-VERIFIER` contrôlées en ligne quand c'était possible.

## Verdict : **À corriger**

Tous les calculs sont justes et chaque résultat affiché est arrondi à une valeur réglable. La notation sûre est appliquée dans la fiche elle-même : aucun zéro final, un zéro initial partout, `mcg` partout et une virgule pour les milliers. La fiche présente pourtant **deux risques d'interprétation de dose**, classés BLOQUANTS selon la règle de sécurité clinique. Le premier : des valeurs d'exercice qui reproduisent des préparations et un protocole réels, sans être signalées comme fictives dans le PDF. Le second : un même nom de médicament qui désigne trois concentrations différentes. S'y ajoutent trois constats MAJEURS. Le PDF ne doit pas être publié avant ces corrections et la relecture infirmière.

| Gravité | Nombre |
|---|---|
| BLOQUANT | 2 |
| MAJEUR | 3 |
| MINEUR | 11 |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| B1 | BLOQUANT | PDF § 7, exemples « mcg/kg/min → mL/h (Drug X) » et « units/kg/h → mL/h (Drug W) » ; aussi § 1 (EX01) et § 5 (EX06) ; `exemples.csv` EX01, EX06, EX08, EX09 | Seuls deux exemples sur neuf portent la mention « fictional » dans le PDF (§ 3 et § 6). La mention « exercise values » n'existe que dans le CSV. Or EX08 reproduit une préparation réelle de dopamine (400 mg/250 mL = 1,600 mcg/mL, 5 mcg/kg/min) et EX09 reproduit le prémélange d'héparine (25,000 units/250 mL) avec la dose d'entretien du nomogramme au poids pour la maladie thromboembolique veineuse (18 units/kg/h). La note clinique placée juste en dessous nomme l'héparine : « Drug W » se lit donc comme l'héparine, et 18 units/kg/h comme *la* dose d'héparine. D'autres protocoles utilisent d'autres doses (en cardiologie, couramment 12 units/kg/h, plafonnées à 1,000 units/h ; 1,296 units/h dépasserait ce plafond). Une dose réelle se trouve ainsi présentée comme une norme, sans source ni avertissement. | Ajouter en tête de fiche, ou dans chaque titre d'exemple, « Drug names and numbers are fictional exercise values, not dosing guidance ». Puis, au choix de la relecture : (a) prendre pour EX08 et EX09 des valeurs qui ne correspondent à aucun protocole courant, et détacher la note héparine/insuline de l'exemple Drug W ; ou (b) nommer l'héparine et citer le protocole source (notice du prémélange, nomogramme) dans `references.csv`, en précisant que la dose dépend de l'indication et du protocole du service. |
| B2 | BLOQUANT | PDF § 1 (EX01), § 6 (EX07), § 7 (EX08) ; `exemples.csv` | « Drug X » désigne trois produits différents : un flacon injectable à 40 mg/mL, une poudre de 1 g reconstituée à 200 mg/mL, une perfusion à 1,600 mcg/mL dosée en mcg/kg/min. Même nom, trois concentrations : c'est précisément le schéma d'erreur (reprendre la concentration d'une autre préparation) que la fiche apprend à éviter. Le calcul est juste, mais la présentation est ambiguë. | Donner un nom distinct à chaque médicament d'exercice (Drug A à Drug F, par exemple), en gardant le même nom seulement là où l'enchaînement est voulu (EX07A → EX07B, EX08A → EX08B, EX09A → C). |
| M1 | MAJEUR | PDF § 8 (« Round once, at the end » et piège) ; § 2 (EX02A) | Règles d'arrondi contradictoires. L'encadré dit « Keep full precision in between; weight to 0.1 kg » et l'exemple EX02A arrondit le poids (19.958 ⇒ 20 kg) avant de s'en servir. Le piège voisin dit « Rounding the weight … early shifts the final rate ». Le lecteur ne sait pas s'il doit arrondir le poids. | Choisir une règle et l'écrire une fois. Par exemple : « Weight: record to 0.1 kg, then use that value; do not round concentrations or intermediate results ». Le piège porte alors sur la concentration seule. À confirmer par la relecture (statut-methode point 4). |
| M2 | MAJEUR | `references.csv`, 7 lignes `MANUEL_CALCUL_DOSES` | Ce n'est pas une référence : aucun ouvrage n'est choisi (« candidats : Morris … ; Pickar … »), sans édition ni pages. Ces lignes portent pourtant les trois méthodes, la conduite hors fourchette (« hold, call the prescriber »), les facteurs de goutte, la reconstitution, les règles d'arrondi et les graduations de seringues. | Fixer un manuel (titre, édition, chapitres et pages) avant validation, ou faire porter ces points par la relectrice et noter sa validation dans `data/revues.csv`. Les cinq points de sécurité encore ouverts de `statut-methode.md` reposent sur cette seule ligne : précision de pompe 0.1 mL/h, gouttes arrondies au plus proche, graduations de seringues, convention du poids, arrondi unique. Les faire trancher par la relectrice et reporter sa décision dans `valeurs.csv` (`pompe_pas`, `poids_pas`…), pas dans une note. |
| M3 | MAJEUR | Pied de page (mention `IA_REDACTION_ASSISTEE`) et absence de marque de brouillon | La méthode est rédigée par l'agent (`methode_auteur = AGENT`) et n'a pas été relue. Le PDF ne porte aucune marque de brouillon (choix assumé dans `statut-methode.md`), mais son pied de page affirme « content checked and approved by the seller ». Si le fichier circule avant la relecture, cette mention est inexacte (docs/conformite.md § 5 : aucune qualification affichée qui ne soit pas exacte et validée). | Bloquer le dépôt Whop tant que `data/revues.csv` ne contient pas la relecture métier. Ou bien produire jusque-là une version filigranée « DRAFT – pending professional review ». |
| m1 | MINEUR | `notation.csv` ligne 7 (« cc ») | La liste ISMP indique pour cc « Mistaken as u (units) » seulement. Le « or 00 » de la fiche ne figure pas dans la source. | « Read as u (units) ». |
| m2 | MINEUR | `references.csv` ISMP_ABBR | Citée comme « mise à jour 2021 » ; la liste diffusée actuellement porte © 2024. | Indiquer la version consultée (© 2024) et la date de consultation. |
| m3 | MINEUR | `references.csv` TJC_MM (2 lignes) et TJC_DNU | Avec Accreditation 360 (en vigueur au 1.1.2026), la Joint Commission a renuméroté tout le chapitre MM. D'après son webinaire d'octobre 2025, l'exigence « minimum required elements of a complete medication order » était MM.04.01.01 EP 2, et les prescriptions relèvent désormais de MM.14.01.01. IM.02.02.01 EP 3 (abréviations interdites) est supprimé, le principe étant repris en IM.13.01.01. | Remplacer la localisation par la numérotation 2026 après lecture du manuel, et garder l'ancienne entre parenthèses. A-VERIFIER toujours ouvert pour la liste exacte des EP. |
| m4 | MINEUR | `references.csv` USP_GN | La section 8.140 des General Notices s'intitule « Percentage Concentrations » (vérifié sur USP 35–NF 30), pas « Percentage Measurements ». Le numéro 8.140 est confirmé. | Corriger l'intitulé et préciser l'édition consultée. |
| m5 | MINEUR | `references.csv` NIST_SP811_2008 (ligne lb) | Le tableau B.8 donne « pound (avoirdupois) … 4.535 924 E-01 » (7 chiffres) et non 4.535 924 37 E-01. La valeur exacte 0.45359237 kg, juste, provient de la définition de 1959. | Citer la définition exacte (NIST Handbook 44, appendice C, ou l'avis du Federal Register de 1959) ou indiquer que B.8 l'arrondit. L'entrée « cup (U.S.) » est bien présente dans B.8 : ce point A-VERIFIER est levé. |
| m6 | MINEUR | PDF § 3, piège « mg/kg/day … divide by doses per day first » | L'exemple juste au-dessus fait l'inverse (dose unitaire × nombre de prises, puis comparaison au total journalier). Les deux méthodes sont valables, mais « first » laisse croire que celle de l'exemple est fausse. | « Compare like with like: per day with per day, or per dose with per dose ». |
| m7 | MINEUR | PDF § 2, en-tête du tableau « Exact (NIST) » | La colonne affiche des valeurs arrondies précédées de ≈. | « NIST (exact value, rounded) ». |
| m8 | MINEUR | PDF § 5 → haut de la colonne 2 (A4, Letter, N&B) | Le piège de Mosteller se retrouve seul en haut de la colonne 2, coupé de sa section, et commence par « 3,600 » sans contexte. | Forcer le piège avec sa section ou le faire commencer par « Mosteller: 3,600 assumes… ». |
| m9 | MINEUR | `src/main.typ` l. 220 | Le « 1 » de « Ratio 1:1,000 » est tapé en dur. | Utiliser `#v("C02", "G")`. |
| m10 | MINEUR | PDF § 6 | Le rapport 1:1000 est présenté sans préciser que les étiquettes US ne l'emploient plus pour les produits à un seul principe actif (USP <7>, depuis 2016 : 1 mg/mL). C'est utile à l'examen et sûr si on le date (statut-methode point 10). | Ajouter « (older labels; current US labels state mg/mL) » une fois la localisation USP <7> vérifiée. |
| m11 | MINEUR | `references.csv` FDA_OTC_DEVICES_2011 | Section exacte toujours non localisée (A-VERIFIER ouvert). La date (mai 2011) est juste. | Ajouter la section (Recommendations). |

### Références `A-VERIFIER` : état après vérification

| Ligne | État | Résultat |
|---|---|---|
| ISMP_HIGH_ALERT | **Levée** | Liste ISMP *High-Alert Medications in Acute Care Settings*, édition 2024 (PSNet, 14.01.2024) : « anticoagulants (e.g., warfarin, low molecular weight heparin, unfractionated heparin) » et « insulin, subcutaneous and IV ». La note clinique est conforme ; mettre l'année 2024. |
| ISMP_IDC | **Levée** | *ISMP Medication Safety Alert! Acute Care*, 6 juin 2019, vol. 24, p. 1-7. |
| ISMP_5R_2007 | **Levée** | *ISMP Medication Safety Alert! Acute Care*, 25 janvier 2007. |
| NCPDP_ORAL_2014 | **Levée** | Version 1.0, mars 2014 : le mL est l'unité standard des liquides oraux. |
| NIST_SP811_2008 (cup) | **Levée** | « cup (U.S.) … 2.365 882 E-04 m³ » présent dans B.8 (voir m5 pour la ligne lb). |
| USP_GN | Partiellement levée | 8.140 confirmé, intitulé à corriger (m4) ; édition à préciser. |
| TJC_MM | Ouverte | Numérotation à mettre à jour (m3) ; liste des EP non vérifiée. |
| FDA_OTC_DEVICES_2011 | Ouverte | Section (m11). |
| MANUEL_CALCUL_DOSES (7 lignes) | Ouverte | Aucun ouvrage fixé (M2). |

### Contrôles passés sans constat
- **Calculs :** 22 / 22 lignes recalculées à l'identique (écart max 3.3 × 10⁻¹¹), colonnes `arrondi` cohérentes, valeurs affichées conformes (0.875 ⇒ 0.88 mL ; 41.67 ⇒ 42 gtt/min ; 12.96 ⇒ 13 mL/h ; 19.958 ⇒ 20 kg).
- **Valeurs :** lb = 0.45359237 kg et in = 2.54 cm exacts ; équivalents ménagers exacts recalculés depuis gallon = 231 in³ (tsp 4.92892159375, tbsp 14.78676478125, fl oz 29.5735295625, cup 236.5882365 mL) ; valeurs d'étiquette 5/15/30/240 mL conformes à 21 CFR 101.9(b)(5)(viii).
- **Fond :** les trois méthodes, les formules de débit, de gouttes, de raccourci microgoutte, d'heure de fin, de Mosteller (√(cm × kg / 3600) ; Mosteller, NEJM 1987;317:1098), de % p/v, de rapport, de titration et d'unités/h sont justes. Le tableau de notation est conforme aux listes TJC et ISMP, sauf m1.
- **Concordance :** tous les nombres du PDF A4 proviennent des données, sauf les numéros de section, l'heure et la durée calculées (16:30, 7 h 30 min) et le « 1 » de m9.
- **Règle d'arrondi (EN01) :** chaque quantité réglable affichée (mL, mL/h, gtt/min) l'est à une valeur réglable selon `valeurs.csv`. Le choix de ces pas reste à valider (M4).
- **Droits :** pas de reprise textuelle repérée. Le tableau de notation reformule les libellés TJC et ISMP. Aucune question d'examen : les exemples sont construits.
- **Forme :** 4 formats générés ; mentions présentes (4) ; N&B sans couleur et pièges hachurés ; tablette sur 3 pages avec sommaire. Rien n'est coupé en page 1 de chaque format.
- **Variantes :** sans objet (STD seule).

## Script de recalcul

Script unique pour les trois produits (`recalcul.py`, lancé par `python3 -I recalcul.py <racine> EN01 <texte_pdf_a4.txt>`). Sortie pour EN01 à la suite.

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

### Sortie du script (EN01)

```text
== EN01 : exemples.csv
  OK  EX01   calc=0.875 attendu=0.875 écart=0.00e+00 tol=0 arrondi=2 affiché=0.88 / 0.88 mL
  OK  EX02A  calc=19.95806428 attendu=19.95806428 écart=3.55e-15 tol=1e-06 arrondi=1 affiché=20.0 / 20 kg
  OK  EX02B  calc=20 attendu=20 écart=0.00e+00 tol=1e-06 arrondi=1 affiché=20.0 / 20 kg
  OK  EX03A  calc=400 attendu=400 écart=0.00e+00 tol=0 arrondi=0 affiché=400 / 400 mg/day
  OK  EX03B  calc=800 attendu=800 écart=0.00e+00 tol=0 arrondi=0 affiché=800 / 800 mg/day
  OK  EX03C  calc=450 attendu=450 écart=0.00e+00 tol=0 arrondi=0 affiché=450 / 450 mg/day
  OK  EX04A  calc=125 attendu=125 écart=0.00e+00 tol=0 arrondi=1 affiché=125.0 / 125 mL/h
  OK  EX04B  calc=41.66666667 attendu=41.66666667 écart=3.33e-11 tol=1e-06 arrondi=0 affiché=42 / 42 gtt/min
  OK  EX05A  calc=7.5 attendu=7.5 écart=0.00e+00 tol=0 arrondi=2 affiché=7.50 / 7.5 h
  OK  EX05B  calc=16.5 attendu=16.5 écart=0.00e+00 tol=0 arrondi=2 affiché=16.50 / 16.5 h
  OK  EX05C  calc=100 attendu=100 écart=0.00e+00 tol=0 arrondi=0 affiché=100 / 100 gtt/min
  OK  EX06A  calc=2.25 attendu=2.25 écart=0.00e+00 tol=0 arrondi=2 affiché=2.25 / 2.25 m²
  OK  EX06B  calc=150 attendu=150 écart=0.00e+00 tol=0 arrondi=0 affiché=150 / 150 mg
  OK  EX07A  calc=200 attendu=200 écart=0.00e+00 tol=0 arrondi=0 affiché=200 / 200 mg/mL
  OK  EX07B  calc=1.5 attendu=1.5 écart=0.00e+00 tol=0 arrondi=1 affiché=1.5 / 1.5 mL
  OK  EX08A  calc=1600 attendu=1600 écart=0.00e+00 tol=0 arrondi=0 affiché=1600 / 1600 mcg/mL
  OK  EX08B  calc=15 attendu=15 écart=0.00e+00 tol=0 arrondi=1 affiché=15.0 / 15 mL/h
  OK  EX09A  calc=100 attendu=100 écart=0.00e+00 tol=0 arrondi=0 affiché=100 / 100 units/mL
  OK  EX09B  calc=1296 attendu=1296 écart=0.00e+00 tol=0 arrondi=0 affiché=1296 / 1296 units/h
  OK  EX09C  calc=12.96 attendu=12.96 écart=0.00e+00 tol=0 arrondi=1 affiché=13.0 / 13 mL/h
  OK  C01    calc=9 attendu=9 écart=0.00e+00 tol=1e-06 arrondi=0 affiché=9 / 9 mg/mL
  OK  C02    calc=1 attendu=1 écart=0.00e+00 tol=0 arrondi=0 affiché=1 / 1 mg/mL
== EN01 : valeurs de référence
  OK  lb_kg                        donnée=0.45359237 référence=0.45359237
  OK  in_cm                        donnée=2.54 référence=2.54
  OK  lb_par_kg_cours (≈ 1/0.45359237) donnée=2.2 référence=2.204622622
  OK  menager 1 tsp (exact)        donnée=4.92892159375 référence=4.928921594
       affiché ≈ 4.93 mL ; étiquette 5 mL
  OK  menager 1 tbsp (exact)       donnée=14.78676478125 référence=14.78676478
       affiché ≈ 14.79 mL ; étiquette 15 mL
  OK  menager 1 fl oz (exact)      donnée=29.5735295625 référence=29.57352956
       affiché ≈ 29.57 mL ; étiquette 30 mL
  OK  menager 1 cup (exact)        donnée=236.5882365 référence=236.5882365
       affiché ≈ 236.6 mL ; étiquette 240 mL
== EN01 : concordance du texte PDF A4
  4 nombres sans correspondance directe dans les données (à examiner à la main) :
             6  … 6 Reconstitution…
             7  … 7 Titration & dr…
             7  …9:00: 750 ÷ 100 = 7.5 h (7 h 30 min) → en…
            16  … Trap 16:30. Microdrip:…
== EN01 : 0 anomalie(s) détectée(s) par script
```
