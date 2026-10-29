# FR09-STD : contre-vérification v2 (run R04)

- **Produit :** FR09 « PASS/LAS Biostatistiques — fiche formules », FR09-STD (fr-FR, Clairance, 1 page).
- **Vérificateur :** agent VÉRIFICATEUR. Je n'ai participé ni à la production ni à la correction. Date : 29.10.2026, environ 11:34-11:50 (périmètre partagé avec EN06).
- **Périmètre :** constats de `rapport-v1.md`, constats du conditionneur (`lots/CORR1`) et ce qui a changé depuis ; pas de seconde vérification complète.
- **Méthode :** diff mot à mot du texte du PDF A4 v1 (copie du vérificateur v1) et v2 ; relecture de `main.typ`, `references.csv`, `sources.csv`, `valeurs.csv`, `contenu.csv`, `textes.csv` ; rendu A4 à 200 dpi des zones Probabilités, Estimation et Épidémiologie ; `build.py FR09-STD` relancé dans une copie du dépôt (`/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verificateur-v2/depot`) : il réussit (contrôle de source compris), et le texte des 4 PDF reconstruits est identique aux PDF livrés ; `annonces.py FR09` relancé dans la copie : `whop.md` et `etsy/annonce.md` identiques aux fichiers livrés ; 4 sources relues en ligne ; recalcul par script adapté au nouveau format.
- **Aucune page OpenStax consultée.**

## Verdict : **OK avec réserves**

**0 BLOQUANT, 0 MAJEUR, 4 MINEURS** (dont 2 restes partiels de la v1). Le MAJEUR M1 est levé : 15 des 17 lignes OpenStax ont maintenant une source lisible, et la VPN par Bayes a sa ligne. Les 2 lignes qui ne citent qu'OpenStax portent sur des formules élémentaires, marquées `A-VERIFIER` (n1). Les calculs sont toujours justes : **0 écart sur 152 contrôles**.

## Constats v1 → v2

| # v1 | Constat v1 | État | Ce que j'ai vérifié |
|---|---|---|---|
| M1 | 17 lignes OpenStax, pas de ligne pour la VPN | **Levé (reste n1)** | 36 lignes. Sources lisibles ajoutées dans `sources.csv` : NIST/SEMATECH, Penn State STAT 200/414/500/800, MIT 9.07, Regina 251, Radiopaedia PPV et NPV, ASA, Hayes (MSU), StatPearls (NCBI) ; CDC conservé. OpenStax reste en simple bibliographie. **2 lignes** n'ont qu'`OPENSTAX_IS2` comme code (σ² de population ; Z = (X − μ)/σ), toutes deux `A-VERIFIER` : voir n1. 7 mentions `A-VERIFIER` au total, toutes sur des résultats élémentaires (complémentaire, σ/√n et TCL, −1 ≤ r ≤ 1, corrélation ≠ causalité, écart-type ≠ erreur standard, pages de Rennes). |
| m1 | Virgule décimale / séparateur | **Levé** | « ℬ(4 ; 0,1) », « Se = 0,9 ; Sp = 0,95 ; P = 0,02 », « IC ≈ [4,81 ; 5,59] », « [16,1 ; 23,9] » (espace fine avant « ; ») ; aucun « ; » collé à une décimale ni aucune virgule séparatrice entre décimales dans le PDF (script, partie E). |
| m2 | 68-95-99,7 sans « ≈ » | **Levé** | « ≈ 68 % ≈ 95 % ≈ 99,7 % », lus dans `valeurs.csv` (groupe EMP). |
| m3 | VPN par Bayes absente | **Levé** | Formule affichée VPN = Sp(1 − P) / (Sp(1 − P) + (1 − Se)P), ligne `RADIOPAEDIA_NPV` ; même résultat que le comptage (99,79 %). |
| m4 | p / p̂ ; σ/√n puis s/√n | **Levé** | « IC d'une proportion observée p̂, si np̂ et n(1 − p̂) > 5 : p̂ ± z√(p̂(1 − p̂)/n) », exemple en p̂ ; « σ/√n, estimée par s/√n ». |
| m5 | Valeurs en dur, `rel()`, contrôles manquants | **Levé** | « 95 % », « 5 % » (deux fois) et « ddl 1 » lus dans `valeurs.csv` (`confiance()`, `pct()`, `KHI1_95.ddl`) ; `rel()` devant tous les résultats ; nouveaux `verifie` : j = 1, c + d = a + b, N = a + b + c + d, BX13 > Z95, BX14 > KHI1_95, ddl 2 × 2, même α, conditions de l'IC et du khi-deux. |
| m6 | Seul E_a affiché | **Levé** | « E_b = 77,5, E_c = 22,5, E_d = 77,5 » (= scipy). |
| m7 | RR en cas-témoins | **Levé** | « le RR n'y est pas calculable » et « Même tableau, lu comme une cohorte » ; ligne CDC Lesson 3 Section 5. |
| m8 | P(B) > 0 | **Levé** | « Si P(B) > 0 : » devant P(A \| B). |
| m9 | Forme | **Levé pour (a), (b), (c)** | (a) P(A ∩ B) n'est plus coupé (formule en bloc) ; (b) « VP/(VP + FN) » sans espace ; (c) « (M) » retiré. (d) tablette et (e) police : non revus, non bloquants en v1. |
| m10 | Décomptes de `contenu.csv` non contrôlés | **Partiellement levé** | `main.typ` contrôle « 20 résultats » et « 3 tableaux de valeurs ». 9 sections, 7 encadrés, 2 tableaux 2 × 2, 9 pièges et 3 pages tablette restent sans contrôle. Ils sont exacts aujourd'hui : je les ai recomptés dans le PDF, et le piège ajouté sur le cas-témoins est intégré à un encadré, pas compté comme un 10ᵉ piège. Voir n3. |
| Cond. 1 | Barre de racine de l'IC d'une proportion sur la ligne du dessus | **Levé** | La formule est en bloc ; au rendu 200 dpi, le radical ne touche plus « place de z. ». |
| Cond. 2 | « vérifiez » / « comparez avec votre programme » | **Levé** | `contenu.csv`, `whop.md` et `etsy/annonce.md` disent « comparez avec votre programme » ; « vérifiez votre programme » n'apparaît plus nulle part. Le sous-titre du PDF (`textes.csv`) garde la phrase exacte de la règle 14, sans « comparez » : c'est conforme. |

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| n1 | MINEUR | `references.csv` (σ² de population ; Z = (X − μ)/σ) ; `sources.csv` (`OPENSTAX_IS2`) | Deux lignes n'ont qu'`OPENSTAX_IS2` comme code. Or `sources.csv` dit lui-même d'OpenStax « jamais seule source d'une valeur ». Les deux sont marquées `A-VERIFIER` ; ce sont des formules élémentaires et exactes. | Citer une page lisible (par ex. une leçon Penn State sur la variance de population et les scores z, à relire), ou laisser le code vide avec `A-VERIFIER`, comme pour les autres lignes sans source. |
| n2 | MINEUR | `references.csv`, ligne IC d'une proportion (`PSU_STAT500`) | La page § 5.3 relue n'écrit pas la formule p̂ ± z√(p̂(1 − p̂)/n). Elle donne l'erreur standard et la condition avec **p** (« If np and n(1-p) are greater than five »), alors que la fiche les écrit avec p̂. La localisation le dit honnêtement, mais la formule affichée n'a pas de localisation qui la soutienne directement (règle 12). La sous-page § 5.3.1, qui la contient probablement, m'a été refusée par l'outil (URL bloquée : https://online.stat.psu.edu/stat500/lesson/5/5.3/5.3.1). | Lire et citer § 5.3.1, ou une autre page qui écrit l'IC avec p̂ ; noter que la condition est vérifiée en pratique avec p̂. |
| n3 | MINEUR | `donnees/contenu.csv` l. 1 et 7 ; annonces | Reste de m10 : 5 décomptes sur 7 ne sont pas contrôlés au build, alors que les annonces les reprennent. | Étendre le contrôle de `main.typ` (pièges, encadrés, sections) ou le faire dans `annonces.py`. |
| n4 | MINEUR | PDF A4, titre de l'exemple « Même tableau, lu comme une cohorte » | La césure « co-horte » laisse « horte » seul sur la 2ᵉ ligne du titre. | Titre plus court (« Même tableau (cohorte) ») ou titre sans césure. |

Remarque, sans constat : la ligne CDC « RR non calculable en cas-témoins » cite « neither a risk ratio nor a rate ratio can be calculated ». Mon outil n'a pas retrouvé cette phrase telle quelle. Il a trouvé : « risks, rates, risk ratios or rate ratios cannot be calculated from the typical case-control study ». Le fond est identique ; il suffit de recopier la phrase exacte.

## Sources échantillonnées (lues le 29.10.2026)

| Code | Formule citée par la fiche | Ce que la page écrit | Concorde ? |
|---|---|---|---|
| `RADIOPAEDIA_NPV` | VPN = Sp(1 − P)/(Sp(1 − P) + (1 − Se)P) | « NPV = [(specificity) x (1 - p)] / [specificity x (1 - p) + (1 - sensitivity) x (p)] » ; « Last revised by Stefan Tigges on 4 Sep 2024 » | Oui (formule, auteur et date de `sources.csv`) |
| `PSU_STAT200` § 11.3 | χ² = Σ(O − E)²/E, E = T_l × T_c / N, ddl = (l − 1)(c − 1), E ≥ 5 | Les quatre éléments, dont « all expected values are at least 5 » | Oui |
| `CDC_PRINCIPLES` Lesson 3 § 5 | RR, OR = ad/bc, OR ≈ RR si maladie rare, RR non calculable en cas-témoins | « = ad ⁄ bc » ; « when the health outcome is uncommon, the odds ratio provides a reasonable approximation of the risk ratio » ; « risk ratios … cannot be calculated from the typical case-control study » | Oui (voir la remarque) |
| `PSU_STAT500` § 5.3 | IC d'une proportion, conditions > 5 | Condition « np and n(1-p) greater than five » et erreur standard √(p(1 − p)/n) ; pas de formule d'IC | Partiellement (n2) |

## Points A-VERIFIER restants

| # | Point | Avis | Bloque la publication ? |
|---|---|---|---|
| 1 | σ² de population, Z = (X − μ)/σ (OpenStax seul) | Formules élémentaires et exactes (n1). | Non |
| 2 | Complémentaire, σ/√n et TCL, −1 ≤ r ≤ 1, « corrélation ≠ causalité », « écart-type ≠ erreur standard » | Résultats élémentaires et exacts ; déjà non bloquants en v1. | Non |
| 3 | Pages du syllabus de Rennes (p. 4-5) | Inchangé depuis la v1. | Non |
| 4 | Mention « Rédaction assistée par IA ; contenu vérifié et validé par le vendeur » (pied de page et annonces) | Elle n'est vraie qu'après la validation de Tristan (règle 15). | **Oui**, tant que le produit n'est pas au statut VALIDE |

## Script de recalcul

C'est le script de la v1, adapté au nouveau format. La partie D cherche « [4,81 ; » (espace fine avant le point-virgule, normalisée) au lieu de « [4,81; » et « ≈ 68 % » au lieu de « 68 % » ; le texte est débarrassé des césures conditionnelles. Une partie E est ajoutée pour les contrôles propres à la v2. Copie : `/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verificateur-v2/recalc_fr09_v2.py`. Lancement : `python3 -I recalc_fr09_v2.py /home/claude/mindshelf` (Python 3, scipy, numpy). Résultat : **0 écart sur 152 contrôles**.

Extraits de la sortie :

```
OK    BX05 formule = 99.785638 ; attendu 99.785637 ; tolérance 0.0001
OK    BX05 indépendant = 99.785638 (attendu 99.785637)
OK    BX09 affiché « ≈ [4,81 ; »
OK    BX11 affiché « ≈ [16,1 ; »
OK    valeur usuelle « ≈ 68 % » présente
OK    aucun « ; » collé à une décimale (ancien format « [4,81; »)
OK    PDF A4 contient « 𝐸𝑏 = 77,5, 𝐸𝑐 = 22,5, 𝐸𝑑 = 77,5 »
OK    PDF A4 contient « le RR n’y est pas calculable »
0 écart(s)
```

```python
#!/usr/bin/env python3
"""FR09-STD : recalcul indépendant (vérificateur R04), version v2 (contre-vérification).

Usage : python3 -I recalc_fr09.py <racine du dépôt>
A. évalue chaque `formule` de exemples.csv (calc.pow -> pow) et la compare à resultat_attendu ;
B. recalcule chaque résultat par une autre voie (définitions, comptage, scipy) ;
C. recalcule valeurs.csv (z, khi-deux, règle 68-95-99,7) ;
D. cherche dans le texte du PDF A4 chaque nombre affiché (concordance), au format v2 « [4,81 ; 5,59] » ;
E. contrôles propres à la v2 (séparateurs, p̂, ≈, VPN par Bayes, effectifs attendus, P(B) > 0).
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
txt = txt.replace("\u00ad ", "").replace("\u00ad", "")  # v2 : césures conditionnelles
def fr(i):
    d = int(ex[i]["arrondi"]); v = round(float(ex[i]["resultat_attendu"]), d)
    s = f"{v:.{d}f}".replace(".", ",")
    rel = "=" if abs(round(calcule[i], d) - calcule[i]) < 1e-9 else "≈"
    return s, rel
attendus = {
    "BX01": "= {s} ;", "BX02": "= {s} ;", "BX03": "= {s}.", "BX04": "VPP {r} {s} %", "BX05": "VPN {r} {s} %",
    "BX06": "= {s}.", "BX07": "{r} {s}.", "BX08": "= {s}.", "BX09": "{r} [{s} ;", "BX10": "; {s}]",
    "BX11": "{r} [{s} ;", "BX12": "; {s}]", "BX13": "{r} {s} > 1,96", "BX14": "{r} {s} > 3,841",
    "BX15": "= {s} ;", "BX16": "RR = {s} ;", "BX17": "OR {r} {s}.", "BX18": "= {s} ;", "BX19": "= {s} ;", "BX20": "= {s}.",
}
for i, motif in attendus.items():
    s, r = fr(i)
    m = motif.format(s=s, r=r)
    note(m in txt, f"{i} affiché « {m} »")
for v in ("1,645", "1,96", "2,576", "3,841", "6,635", "5,991", "≈ 68 %", "≈ 95 %", "≈ 99,7 %", "> 5 :", "≥ 5."):
    note(v in txt, f"valeur usuelle « {v} » présente")

# ---------- E. contrôles propres à la v2 ----------
print("== E. contrôles v2")
brut = subprocess.run(["pdftotext", str(pdf), "-"], capture_output=True, text=True).stdout
note(not re.search(r"\d,\d+;", brut), "aucun « ; » collé à une décimale (ancien format « [4,81; »)")
note(not re.search(r"\d,\d+, \d", txt), "aucune virgule séparatrice entre deux décimales")
for m in ("Se = 0,9 ; Sp = 0,95 ; 𝑃 = 0,02", "ℬ︀(4 ; 0,1)", "Si 𝑃(𝐵) > 0", "estimée par 𝑠/√𝑛", "IC d’une proportion observée 𝑝̂",
          "𝐸𝑏 = 77,5, 𝐸𝑐 = 22,5, 𝐸𝑑 = 77,5", "le RR n’y est pas calculable", "lu comme une cohorte", "(ddl 1)",
          "significative à 5 %", "Intervalles de confiance à 95 %", "VPN = Sp(1 − 𝑃) + (1 − Se)𝑃"):
    note(m in txt, f"PDF A4 contient « {m} »")
note("Malades (M)" not in txt, "« (M) » retiré")
# effectifs attendus affichés = calcul scipy
note(abs(att[0][1] - 77.5) < 1e-9 and abs(att[1][0] - 22.5) < 1e-9 and abs(att[1][1] - 77.5) < 1e-9, f"E_b, E_c, E_d = {att[0][1]}, {att[1][0]}, {att[1][1]}")
# VPN par la formule de Bayes affichée = comptage
vpn_bayes = Sp * (1 - P) / (Sp * (1 - P) + (1 - Se) * P)
proche("BX05", 100 * vpn_bayes)

print(f"\n{len(ecarts)} écart(s)")
sys.exit(1 if ecarts else 0)
```
