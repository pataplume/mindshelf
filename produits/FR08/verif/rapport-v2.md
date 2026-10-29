# FR08-STD : contre-vérification v2 (run R02)

- **Produit :** FR08 « PASS/LAS Chimie — fiche formules », variante FR08-STD (fr-FR, Clairance, Whop et Etsy).
- **Vérificateur :** agent VÉRIFICATEUR R02, sans participation à la production ni à la correction. Date : 29.10.2026.
- **Périmètre :** ce qui a changé depuis le rapport v1 et les constats v1. Ce n'est pas une seconde vérification complète. Les annonces, hors périmètre en v1, sont relues ici pour les promesses et les chiffres.
- **Méthode :**
  - Relecture de `src/main.typ`, `donnees/{references,contenu,cartes}.csv`, `annonce/whop.md` et `annonce/etsy/annonce.md`. `exemples.csv` et `valeurs.csv` n'ont pas changé depuis la v1 (08:03 et 08:00).
  - PDF A4 : pdftotext et rendu PNG de la page 1 à 110 dpi. Texte des 3 pages de la tablette.
  - `scripts/controle_pdf.py FR08-STD` : tous les contrôles passent sur les 4 formats.
  - Recalcul indépendant : script en fin de rapport.
  - Pas de rebuild : les PDF (08:26:33) sont postérieurs à `main.typ` et aux données (08:26:26) ; aperçus, vidéo et `.apkg` sont postérieurs aux PDF.
  - Contrôles en ligne le 29.10.2026 : syllabus PASS 2025-2026 de Rennes et livret PASS 2025-2026 de Bordeaux. Montpellier n'a pas été reconsulté : il avait été vérifié en v1.

## Verdict : **À corriger** (correction légère et documentaire ; aucun calcul ni aucune valeur à changer)

Il n'y a aucun BLOQUANT : les 14 calculs sont justes, aucune régression n'est apparue, et les 13 mineurs de la v1 sont levés.

Le MAJEUR M1 de la v1 n'est que **partiellement levé**. Le sous-titre est conforme à la règle 14, et les programmes cités sont ceux de 2025-2026 ou 2026-2027. Mais en remplaçant Paris-Saclay (seul programme qui citait VSEPR et IR/RMN) par Rennes et Bordeaux, deux tableaux de la fiche ne reposent plus sur **aucun** programme cité : VSEPR et RMN ¹H (constat N1). C'est un MAJEUR (référence manquante pour le choix des notions) à lever avant publication.

| Bilan v2 | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 1 (N1, reliquat de M1) |
| MINEUR | 5 nouveaux |

## Constats v1 : levé ou non levé

| # v1 | Constat | État | Preuve (v2) |
|---|---|---|---|
| M1 | Sous-titre qui surpromet ; programmes anciens ou de seconde main | **Partiellement levé** | Sous-titre (PDF) : « Notions fréquentes en PASS/LAS (les enseignements varient selon les facultés) : formules, tableaux, exemples, pièges ». `contenu.csv`, `whop.md` et `etsy/annonce.md` reprennent la même réserve et ajoutent « vérifiez votre programme ». Toulouse 2023/2024 et Paris-Saclay 2022-2023 ont disparu partout. Montpellier 2026/2027, Rennes 2025-2026 et Bordeaux 2025-2026 sont publiés par les universités. **Rennes, consulté :** année 2025-2026 confirmée. Les intitulés cités sont confirmés (S1 : « Les atomes », « Les molécules : squelette carboné, fonctions, nomenclature », « Stéréoisomérie », équilibres acido-basiques et d'oxydoréduction ; spécialité Pharmacie S2 : « Carbone et hybridation », « Effets électroniques », « Spectrophotométrie UV-visible et Infra-rouge », « Réactions de substitution », « Réactions d'élimination », « Acides-bases + oxydoréduction »). Pages : voir N2. **Bordeaux, consulté :** année 2025-2026 confirmée. P. 34 UE 14, p. 48 UE 16 (« Cinétique chimique », « Les alcènes / Les alcynes », « Les dérivés halogénés / organomagnésiens ») et p. 29 UE 8 (pH, tampons) confirmées. **Reste :** N1. |
| m1 | Page du programme de Toulouse | **Levé** (sans objet) | La référence Toulouse est supprimée. |
| m2 | Espèces chimiques en italique | **Levé** | `"H"_3"O"^+`, `"HO"^-`, `"A"^-`, `"AH"` et `"HCO"_3^-` sont en romain dans le PDF. |
| m3 | « log 20 = 1,30103 » | **Levé** | `rel-log()` donne « log 20 ≈ 1,30103 » (PDF). |
| m4 | T < ΔrH°/ΔrS° sans conversion ni hypothèse | **Levé** (nuance N4) | « (Δr S° en kJ ; Δr H°, Δr S° indépendants de T) ». |
| m5 | « A » ambigu ; [A]₀/2k | **Levé** | « A : facteur préexponentiel » ; « [A]₀/(2k) ». |
| m6 | « (25 °C, V.) » | **Levé** | « (à 25 °C ; E et E° en V) », condition lue dans `valeurs.csv`. |
| m7 | « racémisation » absolu | **Levé** | « racémisation (souvent partielle) », adossé à McMurry § 11.4. |
| m8 | Hiérarchie des interactions | **Levé** | « à taille de molécule comparable : ion–dipôle > liaison hydrogène > Van der Waals (Keesom, Debye, London) », avec une ligne IUPAC Gold Book ajoutée. |
| m9 | Note chiralité trop proche de McMurry ; licence NC | **Levé** | Nouvelle formulation : « Les récepteurs de l'organisme étant chiraux… le racémique est sans effet sur la migraine, l'énantiomère S pur a été étudié en prévention ». Ce sont des faits reformulés, sans traduction serrée, et sans l'affirmatif « works remarkably well ». La licence CC BY-NC-SA 4.0 est notée dans `references.csv` (lignes 49 et 52). |
| m10 | Constantes dupliquées sans contrôle | **Levé** | `main.typ` l. 93-103 fait échouer la compilation si une des 7 constantes diffère de `valeurs.csv`, si EX10.R ≠ Ab/HA ou si EX12.R ≠ résultat d'EX11. |
| m11 | Cartes : nombres en texte ; α, β non définis | **Levé** | La carte Nernst indique « Pour α Ox + n e⁻ = β Red ». Tous les nombres des 28 cartes figurent dans le PDF A4 (contrôle par script). Ils restent en texte libre (observation v1). |
| m12 | Encadrés coupés ; césures | **Levé** (nuance N5) | `block(breakable: false)` est posé. Sur la tablette, Cinétique tient en entier p. 2, la note chiralité et le Piège en entier p. 3 ; rien n'est coupé en A4, Letter ni N&B (contrôle_pdf OK). « (-ène, -yne) », « racémisation » et « anti » sont en `box`. |
| m13 | `contenu.csv` | **Levé** | « 12 exemples chiffrés courts (14 résultats) : … ». Comptages exacts : 10 sections, 6 tableaux, 2 notes santé, 6 pièges, 28 cartes. Les annonces donnent les mêmes chiffres. |

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| N1 | MAJEUR | `references.csv`, lignes « Choix des notions » (PROG_UM_2026, PROG_URENNES_2025, PROG_UBX_2025) ; tableaux VSEPR et RMN ¹H du PDF | **Aucun des trois programmes cités ne nomme la VSEPR ni la spectroscopie RMN ¹H.** Les lignes de `references.csv` le disent elles-mêmes (« Ni VSEPR, ni RMN… ») ; la ligne 20 ajoute « aucun programme 2025-2026 ou 2026-2027 consulté ne cite la VSEPR ». Je l'ai confirmé sur Rennes et Bordeaux. La RMN n'y apparaît qu'en biophysique (« Les radiofréquences et leur utilisation en RMN », Rennes p. 14, Bordeaux p. 31), sans déplacements chimiques. L'IR et SN/E ne sont soutenus que par la spécialité Pharmacie de Rennes, et implicitement par « Les dérivés halogénés » à Bordeaux. Ces deux tableaux (sur six) reposaient en v1 sur le seul programme de Paris-Saclay, désormais retiré. Le sous-titre « notions fréquentes » (formule de la règle 14) couvre donc deux tableaux qu'aucune source citée ne présente comme enseignés en PASS/LAS (règles 1 et 14). | Au choix. (a) Citer un programme 2025-2026 ou 2026-2027 publié par une université, qui nomme la VSEPR (souvent sous « liaison chimique ») et la RMN ¹H, avec la page. (b) Sinon, signaler ces deux tableaux sur la fiche, dans `contenu.csv` et dans les annonces comme dépendant de la faculté (par ex. « selon les facultés ; souvent en spécialité Pharmacie » pour IR/RMN). (c) Ou retirer le tableau RMN ¹H. Aucune valeur n'est en cause : les bornes et les angles sont justes (v1). |
| N2 | MINEUR | `references.csv`, PROG_URENNES_2025 | Le document consulté place l'UE Chimie-Biochimie S1 à la p. 8 et la chimie de la spécialité Pharmacie à la p. 20 ; la référence indique p. 7 et p. 19 (« pages imprimées »). L'écart peut venir de la numérotation PDF ou imprimée, que mon outil ne permet pas de trancher. La p. 36 (mineure Physique-Chimie) n'a pas été contrôlée. | Relire les numéros imprimés et préciser « p. imprimée / p. PDF ». |
| N3 | MINEUR | `src/main.typ` l. 116 | Le sous-titre est tapé en dur dans le Typst, alors que FR07 le lit dans `textes.csv`. La même réserve est saisie à la main en 4 endroits (Typst, `contenu.csv`, `whop.md`, `etsy/annonce.md`), avec 4 formulations différentes qui divergeront à la prochaine correction. | Ajouter `donnees/textes.csv` (SOUS_TITRE, RESERVE_PROGRAMME) et lire le sous-titre comme FR07 ; faire générer la réserve des annonces depuis cette table. |
| N4 | MINEUR | PDF, Thermodynamique (EX06) | « (Δr S° en kJ ; …) » : l'unité est incomplète (Δr S° s'exprime en J·mol⁻¹·K⁻¹ ou en kJ·mol⁻¹·K⁻¹). | « (Δr S° converti en kJ·mol⁻¹·K⁻¹ ; …) ». |
| N5 | MINEUR | PDF, tableau SN/E (A4, Letter, N&B) | Il reste une césure « (souvent par-tielle) » ; `hyphenate: false`, proposé en v1, n'a pas été appliqué au tableau. | `set text(hyphenate: false)` dans ce tableau. |

## A-VERIFIER restants : avis

| Point (`references.csv`) | Avis | Bloque la publication ? |
|---|---|---|
| Choix des notions VSEPR et RMN ¹H : aucun programme cité (N1) | Ce n'est pas un A-VERIFIER marqué, mais une référence manquante. | **Oui**, au sens de la règle 14, tant que (a), (b) ou (c) de N1 n'est pas appliqué. La correction est légère. |
| Notation AXnEm (Gillespie) sans manuel français | Notation standard des cours français, juste. Elle doit gagner une source en même temps que N1(a). | Non |
| Formes françaises de la nomenclature | Inchangé depuis la v1 : justes ; source française souhaitable. | Non |
| Éponymes Keesom et Debye (ligne 23) | Usage standard des cours français ; l'IUPAC décrit les trois composantes. | Non |
| Numéro de l'exemple d'OpenStax Chemistry 2e § 14.3 | Inchangé ; dérivation juste. | Non |
| STATPEARLS_HYPOCARBIA (pKa 6,1 ; 0,03) | Toujours non relu, malgré trois remplaçants essayés par le producteur. Les valeurs sont justes (recalcul : pH 7,40). Remplaçants à essayer : Costanzo, *Physiology*, chapitre acide-base, ou Guyton & Hall, chapitre sur la régulation acido-basique. Les deux écrivent, à ma connaissance, pH = 6,1 + log(HCO₃⁻/(0,03 × PCO₂)) ; à vérifier sur l'ouvrage. | Non, mais remplacer avant la prochaine version. |
| Mention « contenu vérifié et validé par le vendeur » | Elle n'est vraie qu'après la validation de Tristan. | **Oui**, jusqu'à cette validation (condition de processus). |

## Script de recalcul (`recalcul_fr08_v2.py`, lecture seule)

Exécution le 29.10.2026 : `python3 -I recalcul_fr08_v2.py /home/claude/mindshelf`. Code de sortie 0.

- 14 exemples recalculés depuis les grandeurs physiques (CODATA 2022), sans réutiliser la colonne `formule`, puis la colonne réévaluée (`calc.pow` admis).
- Logarithmes fournis, signe `=` / `≈` et cohérence des constantes dupliquées.
- Présence de chaque valeur affichée dans le texte du PDF A4.

```python
#!/usr/bin/env python3
"""Recalcul indépendant FR08, contre-vérification v2 (vérificateur R02). Lecture seule.
Usage : python3 -I recalcul_fr08_v2.py /home/claude/mindshelf
Reprend le script v1 (valeurs physiques recalculées sans la colonne formule, logarithmes fournis,
signe = / ≈, constantes dupliquées) ; ajoute calc.pow (règle 9) et la présence de chaque valeur
affichée dans le texte du PDF A4."""
import csv, json, math, subprocess, sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
racine = Path(sys.argv[1] if len(sys.argv) > 1 else "/home/claude/mindshelf")
D = racine / "produits/FR08/donnees"
ex = {l["id"]: l for l in csv.DictReader(open(D / "exemples.csv", encoding="utf-8"))}
val = {l["id"]: l for l in csv.DictReader(open(D / "valeurs.csv", encoding="utf-8"))}
E = {k: json.loads(l["entrees_json"]) for k, l in ex.items()}
def rnd(x, d):  # arrondi demi vers le haut (calc.round de Typst)
    return float(Decimal(repr(x)).quantize(Decimal(1).scaleb(-d), rounding=ROUND_HALF_UP))
class Calc: pow = staticmethod(pow)
ref = {
 "EX01": 0.1 * 0.500 / 2 * 1000, "EX02": 0.05 * 180,
 "EX03": 13.605693122990 * (1 - 1/4),
 "EX04": (6.62607015e-34 * 299792458 / 1.602176634e-19) * 1e9 / 620,
 "EX05": -92.2 - 298 * (-199e-3), "EX06": -92.2e3 / -199,
 "EX07": math.log(2) / 0.05,
 "EX08": 8.314462618 * math.log(2) / (1/298 - 1/308) / 1000,
 "EX09": 0.5 * (4.8 - math.log10(0.01)), "EX10": 4.8 + math.log10(0.2 / 0.1),
 "EX11": 24 / (0.03 * 40), "EX12": 6.1 + math.log10(24 / (0.03 * 40)),
 "EX13": 0.45 + (8.314462618 * 298.15 * math.log(10) / 96485.33212) / 2 * math.log10(100),
 "EX14": 5 - 0 - 8 / 2,
}
txt = subprocess.run(["pdftotext", str(racine / "produits/FR08/livraison/FR08-STD/FR08-STD-a4.pdf"), "-"],
                     capture_output=True, text=True).stdout.replace("−", "-").replace(" ", " ").replace(" ", " ")
ok = True
print(f"{'id':5} {'formule':>12} {'attendu':>12} {'physique':>12} {'affiché':>8} {'rel':>3}  remarque")
for k, l in ex.items():
    e = E[k]; f = eval(l["formule"], {"__builtins__": {}, "calc": Calc}, dict(e))
    att = float(l["resultat_attendu"]); tol = float(l["tolerance"]); d = int(l["arrondi"])
    aff = rnd(att, d); sign = "=" if abs(rnd(f, d) - f) < 1e-9 else "≈"
    s = f"{aff:.{d}f}".replace(".", ","); rq = []
    if abs(f - att) > tol: rq.append("ÉCART formule/attendu"); ok = False
    if rnd(ref[k], d) != aff: rq.append(f"affichage ≠ valeur physique arrondie ({rnd(ref[k], d)})"); ok = False
    if "R" in e and "L" in e and abs(math.log10(e["R"]) - e["L"]) > 1e-6: rq.append("log10 faux"); ok = False
    if "Rn" in e and "N" in e and abs(math.log(e["Rn"]) - e["N"]) > 1e-6: rq.append("ln faux"); ok = False
    if s not in txt: rq.append(f"« {s} » absent du PDF A4"); ok = False
    print(f"{k:5} {f:12.6f} {att:12.6f} {ref[k]:12.6f} {s:>8} {sign:>3}  {'; '.join(rq) or 'OK'}")
c = [("EX09 : pH < pKa − 1", 0.5 * (4.8 + 2) < 4.8 - 1),
     ("EX10 : R = [A−]/[HA]", abs(E["EX10"]["Ab"] / E["EX10"]["HA"] - E["EX10"]["R"]) < 1e-12),
     ("EX12 : R = résultat EX11", abs(E["EX12"]["R"] - 24 / (0.03 * 40)) < 1e-9),
     ("EX05/EX06 mêmes entrées", E["EX05"]["H"] == E["EX06"]["H"] and E["EX05"]["S"] == E["EX06"]["S"]),
     ("PDF : « log 20 ≈ » (et non « = »)", "log 20 ≈" in txt),
     ("PDF : aucun double signe moins", "--" not in txt.replace(" ", ""))]
for i, cle, v in [("EX03","ER","ER"),("EX04","hc","HC_EVNM"),("EX07","ln2","LN2"),("EX08","Rg","R_J"),
                  ("EX13","k","NERNST25"),("EX11","s","CO2_SOL"),("EX12","pKa","BICARB_PKA")]:
    c.append((f"{i}.{cle} = valeurs.{v}", float(E[i][cle]) == float(val[v]["valeur"])))
c += [("NERNST25 0,059", rnd(8.314462618*298.15*math.log(10)/96485.33212, 3) == 0.059),
      ("HC_EVNM 1240", round(6.62607015e-34*299792458/1.602176634e-19*1e9) == 1240),
      ("ER 13,6", rnd(13.605693122990, 1) == 13.6), ("LN10 2,303", rnd(math.log(10), 3) == 2.303)]
for n, r in c:
    print(("OK    " if r else "ÉCHEC ") + n); ok &= r
print("RÉSULTAT :", "tous les contrôles passent" if ok else "au moins un écart")
sys.exit(0 if ok else 1)
```

Sortie :

```
id         formule      attendu     physique  affiché rel  remarque
EX01     25.000000    25.000000    25.000000       25   =  OK
EX02      9.000000     9.000000     9.000000        9   =  OK
EX03     10.200000    10.200000    10.204270     10,2   =  OK
EX04      2.000000     2.000000     1.999745      2,0   =  OK
EX05    -32.898000   -32.898000   -32.898000    -32,9   ≈  OK
EX06    463.316583   463.316583   463.316583      463   ≈  OK
EX07     13.860000    13.860000    13.862944     13,9   ≈  OK
EX08     52.893505    52.893505    52.896462     52,9   ≈  OK
EX09      3.400000     3.400000     3.400000      3,4   =  OK
EX10      5.101030     5.101030     5.101030     5,10   ≈  OK
EX11     20.000000    20.000000    20.000000       20   =  OK
EX12      7.401030     7.401030     7.401030     7,40   ≈  OK
EX13      0.509000     0.509000     0.509159     0,51   ≈  OK
EX14      1.000000     1.000000     1.000000        1   =  OK
OK    EX09 : pH < pKa − 1
OK    EX10 : R = [A−]/[HA]
OK    EX12 : R = résultat EX11
OK    EX05/EX06 mêmes entrées
OK    PDF : « log 20 ≈ » (et non « = »)
OK    PDF : aucun double signe moins
OK    EX03.ER = valeurs.ER
OK    EX04.hc = valeurs.HC_EVNM
OK    EX07.ln2 = valeurs.LN2
OK    EX08.Rg = valeurs.R_J
OK    EX13.k = valeurs.NERNST25
OK    EX11.s = valeurs.CO2_SOL
OK    EX12.pKa = valeurs.BICARB_PKA
OK    NERNST25 0,059
OK    HC_EVNM 1240
OK    ER 13,6
OK    LN10 2,303
RÉSULTAT : tous les contrôles passent
```
