# Vérification FR08-STD : PASS/LAS Chimie — fiche formules (rapport v1)

- **Run :** R02, agent VÉRIFICATEUR (sans participation à la production), 29.10.2026
- **Objet :** variante FR08-STD (français de France, étudiant.e.s en PASS/LAS, risque IA FAIBLE, Whop et Etsy). Hors périmètre, parce que le conditionneur y travaille en même temps : `apercus/`, `video/`, `annonce/`, `donnees/extraits.csv`, `livraison/FR08-STD/FR08-STD.apkg`.
- **Méthode :**
  - Relecture de `src/main.typ` (258 lignes), des 8 CSV de `donnees/`, et du PDF A4 (pdftotext et rendu PNG à 110 dpi). Rendus PNG aussi pour le N&B (110 dpi) et la tablette (80 dpi, 3 pages).
  - `scripts/controle_pdf.py FR08-STD` : 33 contrôles OK.
  - Build `scripts/build.py FR08-STD` dans une copie du dépôt (scratchpad), pour ne rien écrire dans `livraison/`. Les 4 PDF compilent et leur texte est identique aux PDF livrés : la livraison correspond donc à la source actuelle.
  - Recalcul indépendant des 14 exemples depuis les grandeurs physiques (CODATA 2022 exactes), sans réutiliser la colonne `formule`. Script en fin de rapport.
  - Vérification en ligne le 29.10.2026 :
    - les 3 programmes cités (Montpellier, Toulouse III, Paris-Saclay) ;
    - OpenStax *Organic Chemistry* : tableau 12.1 (§ 12.7), tableau 13.3 (§ 13.4), annexe A (tableau A2) et § 5.12 (fluoxétine), ainsi que la licence du livre.
    - StatPearls NBK493167 n'a pas pu être consulté (vérification anti-robot de NCBI).

## Verdict : **À corriger** (correction légère : sous-titre et références ; aucun calcul ni aucune valeur à changer)

Il n'y a aucun BLOQUANT :
- les 14 calculs sont justes, ainsi que les logarithmes fournis en entrée et les signes `=` / `≈` produits par `rel()` ;
- les bornes IR et RMN ¹H sont celles de McMurry (tableaux 12.1 et 13.3) ;
- l'ordre de priorité des fonctions est celui du tableau A2 ;
- les conventions françaises sont respectées : virgule décimale, Δ<sub>r</sub>G, couple Ox/Red, Nernst sous la forme française, notation AX<sub>n</sub>E<sub>m</sub> ;
- aucun nombre n'est tapé en dur dans le Typst.

Un MAJEUR doit être levé avant publication. Le sous-titre annonce « les notions de chimie générale et organique les plus courantes en PASS et en LAS ». Or trois sections (VSEPR, SN/E, spectroscopies) ne reposent que sur **un seul** programme, celui de Paris-Saclay 2022-2023, vieux de 4 ans et hébergé hors du site de l'université. Le programme de Toulouse cité date de 2023/2024. La fiche ne prétend nulle part suivre un « programme officiel » : ce point est conforme.

| Bilan | Nombre |
|---|---|
| BLOQUANT | 0 |
| MAJEUR | 1 |
| MINEUR | 13 |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `src/main.typ` l. 97 (sous-titre) ; `references.csv`, lignes PROG_UM_2026, PROG_UT3_2023, PROG_UPSACLAY_2022 | Le choix des notions est fragile et le sous-titre surpromet. Programmes consultés en ligne : **(1) Montpellier**, programme 2026/2027 : p. 5 (UE1 : atomistique, thermodynamique, équilibres chimiques, chimie organique de base) et p. 8 (UE6 : cinétique chimique et stabilité des principes actifs, réactivité) **confirmées**. Ce programme ne cite ni VSEPR, ni IR/RMN, ni stéréochimie, ni nomenclature, ni SN1/SN2. **(2) Toulouse III** : année **2023/2024**. Pas de VSEPR, pas d'IR/RMN en chimie, pas de SN1/SN2. Le pH n'y figure qu'en physique (UE3). Effets électroniques, intermédiaires et cinétique ne figurent qu'en UE11, **spécifique Pharmacie**. **(3) Paris-Saclay** : **2022-2023**, PDF diffusé par l'académie de Versailles et non par l'université. C'est le seul des trois qui couvre VSEPR, IR/RMN, substitution/élimination et acide-base (pH, Nernst). En revanche, la cinétique est absente de sa section Chimie. Les sections Spectroscopies, tableau SN/E et VSEPR ne s'appuient donc que sur un programme ancien et de seconde main. « Les plus courantes » n'est pas démontré. | (a) Remplacer « les plus courantes en PASS et en LAS » par une formule exacte, par ex. « Notions de chimie générale et organique enseignées en PASS/LAS dans plusieurs facultés (le programme varie selon l'université : vérifiez le vôtre) ». (b) Remplacer les références Toulouse et Paris-Saclay par les programmes 2025/2026 ou 2026/2027 publiés sur le site de chaque université. Ajouter si possible une 4ᵉ faculté qui enseigne IR/RMN et SN/E en tronc commun. (c) Signaler au conditionneur que l'annonce ne doit pas promettre une couverture « du programme ». |
| m1 | MINEUR | `references.csv`, PROG_UT3_2023 | Localisation : dans le PDF consulté, l'UE1 (chimie) est **p. 3**, pas p. 4. L'UE11 commence p. 26, ce qui rend « p. 26-27 » plausible. | Corriger en « p. 3 ». |
| m2 | MINEUR | `main.typ` l. 176-177 et 184 | En mode math, les espèces chimiques sortent en italique : [*H*<sub>3</sub>*O*<sup>+</sup>], [*HO*<sup>−</sup>], [*A*<sup>−</sup>], [*AH*], [*HCO*<sub>3</sub><sup>−</sup>]. La typographie française et l'usage IUPAC veulent des symboles d'éléments en romain. Les lignes en texte, comme NH₄⁺ ou HCO₃⁻ l. 185, sont déjà droites. | Écrire `["H"_3"O"^+]`, `["HO"^-]`, `["HCO"_3^-]`, `["A"^-]`, `["AH"]` (ou utiliser `upright`). |
| m3 | MINEUR | `main.typ` l. 185 | « log 20 = 1,30103 » : le `=` est tapé en dur, alors que log₁₀ 20 = 1,301029996… Partout ailleurs, `rel()` affiche `≈` dès qu'une valeur est arrondie. | Afficher « log 20 ≈ 1,301 », ou appliquer à L la même logique que `rel()`. |
| m4 | MINEUR | `main.typ` l. 152 (EX06) | « T < Δ<sub>r</sub>H°/Δ<sub>r</sub>S° ≈ 463 K » : avec les unités affichées juste avant (kJ et J), ce quotient vaut 0,463. Le calcul correct suppose aussi Δ<sub>r</sub>H° et Δ<sub>r</sub>S° indépendants de T, ce qui n'est pas dit. Le piège n° 1 rappelle la conversion, mais l'exemple ne l'applique pas visiblement. | « T < Δ<sub>r</sub>H°/Δ<sub>r</sub>S° (Δ<sub>r</sub>S° en kJ·mol⁻¹·K⁻¹) ≈ 463 K, en supposant Δ<sub>r</sub>H° et Δ<sub>r</sub>S° indépendants de T ». |
| m5 | MINEUR | `main.typ` l. 159 et 167 | Dans le même encadré, « A » désigne à la fois le réactif ([A]) et le facteur préexponentiel (k = A e^(−Ea/RT)). De plus, « [A]₀/2k » peut se lire ([A]₀/2)·k. | Nommer le facteur (« A : facteur préexponentiel ») ou changer de lettre. Écrire « [A]₀/(2k) ». |
| m6 | MINEUR | `main.typ` l. 192 | « (25 °C, V.) » est peu lisible. | « (à 25 °C ; E et E° en V) ». |
| m7 | MINEUR | `main.typ` l. 219 (tableau SN/E) | « S<sub>N</sub>1 : racémisation ». McMurry (§ 11.4) décrit une racémisation le plus souvent partielle, avec un léger excès d'inversion. La réponse « racémisation » est celle des cours, mais elle est trop absolue. | « racémisation (souvent partielle) ». |
| m8 | MINEUR | `main.typ` l. 144 | La hiérarchie « ion–dipôle > liaison H > dipôle–dipôle > London » est une généralisation : London peut dominer pour de grosses molécules. Les cours français (et le programme de Toulouse) parlent d'interactions de Van der Waals (Keesom, Debye, London), vocabulaire absent ici. | « … > Van der Waals (Keesom, Debye, London), à taille de molécule comparable ». |
| m9 | MINEUR | `main.typ` l. 224 (note chiralité) ; droits | La citation de McMurry est **vérifiée mot pour mot** (§ 5.12 : « Racemic fluoxetine is an effective antidepressant but has no activity against migraine. The pure S enantiomer, however, works remarkably well in preventing migraine. »). Deux réserves. (1) La phrase de la fiche en est une traduction serrée. OpenStax *Organic Chemistry* est sous licence **CC BY-NC-SA 4.0 (non commerciale)**, alors que FR08 est vendue : seuls les faits (bornes, ordres) peuvent être repris, pas la formulation. (2) « s'est montré actif » est affirmatif pour une molécule jamais commercialisée dans cette indication. | Reformuler librement, par ex. « l'énantiomère S a été étudié en prévention de la migraine, contrairement au racémique ». Noter la licence NC dans `references.csv` pour OPENSTAX_OCHEM. |
| m10 | MINEUR | `exemples.csv` et `main.typ` l. 17-36 | Normalisation. Sept constantes figurent à la fois dans `exemples.csv` et dans `valeurs.csv` : ER, hc, ln2, Rg, k (0,059), s (0,03), pKa (6,1). Rien ne contrôle qu'elles restent égales. De même, R = [A⁻]/[HA] (EX10) et R = résultat d'EX11 (EX12) sont saisis à la main sans contrôle. Tout est cohérent aujourd'hui (script), mais un changement dans `valeurs.csv` créerait un écart silencieux entre la formule affichée et l'exemple. | Dans `main.typ`, faire échouer la compilation si `e.ER ≠ valeurs.ER`, etc., si `EX10.R ≠ Ab/HA` et si `EX12.R ≠ EX11.calcule`. Mieux : faire lire ces entrées dans `valeurs.csv`. |
| m11 | MINEUR | `cartes.csv` | Des valeurs sont tapées dans le texte des cartes : 13,6 ; ≈ 104,5° ; ≈ 107° ; 0,059 ; 6,1 ; 0,03 ; 7,35–7,45 ; 1670–1780. Elles doublonnent `valeurs.csv`, `vsepr.csv` et `spectro.csv`. Elles sont cohérentes aujourd'hui, mais aucun lien ne les tient. La carte Nernst ne définit pas α et β. Contenu des 28 cartes relu : aucune erreur de fond. | Générer ces nombres depuis les tables, ou ajouter un contrôle de concordance dans `anki.py`. Carte Nernst : préciser « pour α Ox + n e⁻ = β Red ». |
| m12 | MINEUR | PDF, mise en page | Sur l'A4, la Letter et le N&B, l'encadré Cinétique est coupé : sa première ligne est en bas de la colonne 1, la suite en haut de la colonne 2. Sur la tablette, trois encadrés sont coupés : Cinétique (p. 1 → 2), la note chiralité (p. 2 → 3) et le Piège (p. 2 → 3). Il y a aussi des césures disgracieuses dans le tableau SN/E (« an-ti », « racémisa-tion », « 1° >⏎2° ») et l. 204 (« (-ène, -⏎yne) »). Rien n'est coupé hors page : `controle_pdf` est OK et le N&B reste lisible. | `block(breakable: false)` sur l'encadré Cinétique et les notes ; trait d'union insécable (U+2011) dans « ‑ène, ‑yne » ; `hyphenate: false` dans le tableau SN/E. |
| m13 | MINEUR | `contenu.csv` l. 3 | Double parenthèse : « Exemples chiffrés courts (14 calculs) (dilution, … ». De plus, les 14 calculs s'affichent en 12 exemples : EX05 et EX06, puis EX11 et EX12, vont par paire. Le reste de `contenu.csv` décrit exactement le PDF : 10 sections, 6 tableaux, 2 notes santé, 6 pièges, une page A4. | « 12 exemples chiffrés courts (14 résultats) : dilution, modèle de Bohr, … ». |

## Points `A-VERIFIER` laissés par la production : avis

| Point (`references.csv`) | Avis | Bloque la publication ? |
|---|---|---|
| Notation AX<sub>n</sub>E<sub>m</sub> sans manuel français consulté | La notation de Gillespie est la notation standard des cours français. Le programme de Paris-Saclay cite bien « VSEPR (Gillespie) » (vérifié). | Non |
| Formes françaises de la nomenclature (suffixes, préfixes) transposées de l'anglais | L'ordre et les morphèmes sont **confirmés** dans McMurry, annexe A, tableau A2 (consulté). Fiche et tableau ne s'écartent que par l'omission des anhydrides, thioesters et halogénures d'acyle, qui est déclarée. Les formes françaises sont justes : acide …oïque, …oate de …yle, alcoxycarbonyl-, carbamoyl-, cyano-, oxo-, hydroxy-, amino-. Pour les aldéhydes, « formyl- » est aussi d'usage en français ; « oxo- » suit la source. Il faudrait citer une source française (cours universitaire ou traduction des recommandations IUPAC 2013). | Non (MINEUR documentaire) |
| Numéro de l'exemple d'OpenStax 14.3 (approximation de l'acide faible) | La dérivation [H₃O⁺]² ≈ K<sub>a</sub>C → pH = ½(pK<sub>a</sub> − log C) est standard et juste. La condition pH < pK<sub>a</sub> − 1 est correcte, et vérifiée pour EX09 (3,4 < 3,8 ; 4 % de dissociation). | Non |
| STATPEARLS_HYPOCARBIA (tampon bicarbonate), page non reconsultée | Je n'ai pas pu la consulter non plus (vérification anti-robot de NCBI). Les valeurs sont justes : pK<sub>a</sub> apparent 6,1 à 37 °C, 0,03 mmol·L⁻¹·mmHg⁻¹, 24/(0,03 × 40) = 20, pH 7,40. La référence n'a toutefois été vérifiée par personne depuis EN03. | Non, mais il faut la remplacer par une source consultable (manuel de physiologie, ou page StatPearls effectivement relue). |
| Mention de pied de page « contenu vérifié et validé par le vendeur » (`data/mentions.csv`, IA_REDACTION_ASSISTEE) | Elle n'est vraie qu'après la validation de Tristan ; `produits.csv` indique FR08 au statut A_VERIFIER. | **Oui**, jusqu'à la validation par le vendeur (condition de processus, pas un défaut du PDF). |

## Ce qui a été vérifié et est conforme

- **Calculs :** 14 lignes sur 14 sont justes. Écart formule/attendu nul. Les valeurs physiques exactes arrondies donnent le même affichage, y compris EX03 et EX04 avec 13,6057 eV et 1239,84 eV·nm. Logarithmes fournis : log₁₀ 0,01 = −2, log₁₀ 2 = 0,30103, log₁₀ 20 = 1,30103, log₁₀ 100 = 2, ln 2 = 0,693147. Tous sont à moins de 10⁻⁶, et le contrôle de `main.typ` (l. 27-32) est correct.
- **`rel()` :** les signes `=` (EX01, 02, 03, 09, 14) et `≈` (EX05, 06, 07, 08, 10, 12, 13) recalculés par le script sont identiques à ceux du PDF. EX04 (« soit ») et EX11 (« rapport ») n'utilisent pas `rel()` mais leurs valeurs sont exactes. La fonction compare l'arrondi de la valeur recalculée à cette valeur, ce qui est correct. Le seul `=` abusif est tapé en dur (m3).
- **Concordance :** tous les nombres du PDF A4 (exemples, constantes, tableaux VSEPR, IR, RMN, nomenclature, plage du pH sanguin) viennent des CSV via `v()`, `res()`, `k()`, `plage()`, `cond()`, `jeu()` et les tables. Les seuls chiffres du Typst sont structurels (ordres 0/1/2, ½ dans une formule, 2ⁿ, n + 1, rangs CIP).
- **Fond :**
  - Formules de concentration, atomistique, charge formelle, VSEPR (angles et hybridations), thermodynamique (tableau des signes, Δ<sub>r</sub>G° = −RT ln K = −nFE°), cinétique (lois intégrées, t<sub>1/2</sub>, Arrhenius à deux températures), acides et bases, Nernst (forme française, α Ox + n e⁻ = β Red), nombres d'oxydation, règles R/S, Z/E et 2ⁿ, effets électroniques, Markovnikov, Zaïtsev : tout est juste.
  - Constantes : CODATA 2022, arrondis justes. RT ln 10/F = 0,059159 V ; hc/e = 1239,84 eV·nm ; R∞hc = 13,6057 eV.
  - **Bornes IR** (tableau 12.1) et **RMN ¹H** (tableau 13.3) : identiques à la source consultée en ligne. Les regroupements déclarés (nitrile 2210–2260 et alcyne 2100–2260 ; trois lignes alkyle) sont exacts.
- **Forme :** `controle_pdf.py` OK sur les 4 formats (33 contrôles) : une page en A4, Letter et N&B ; 3 pages sur tablette, avec sommaire et 10 signets. Les deux mentions sont présentes. Le N&B ne contient aucun pixel coloré et reste lisible.

## Script de recalcul (`recalcul_fr08.py`, lecture seule)

Lancement depuis la racine du dépôt : `python3 -I recalcul_fr08.py produits/FR08/donnees`

```python
#!/usr/bin/env python3
"""Recalcul indépendant de FR08 (vérificateur R02). Lecture seule.
Recalcule chaque exemple à partir des grandeurs physiques (sans réutiliser la colonne formule),
contrôle les log10/ln fournis en entrée, le signe = / ≈ de rel(), l'affichage arrondi,
et la cohérence des constantes dupliquées entre exemples.csv et valeurs.csv."""
import csv, json, math, sys
from decimal import Decimal, ROUND_HALF_UP
D = sys.argv[1] if len(sys.argv) > 1 else "produits/FR08/donnees"
ex = {l["id"]: l for l in csv.DictReader(open(f"{D}/exemples.csv", encoding="utf-8"))}
val = {l["id"]: l for l in csv.DictReader(open(f"{D}/valeurs.csv", encoding="utf-8"))}
E = {k: json.loads(l["entrees_json"]) for k, l in ex.items()}
def rnd(x, d):  # arrondi « au plus proche, demi vers le haut » (calc.round de Typst)
    return float(Decimal(repr(x)).quantize(Decimal(1).scaleb(-d), rounding=ROUND_HALF_UP))
# 1. Valeurs de référence calculées depuis la physique, pas depuis la colonne formule
ref = {
 "EX01": 0.1 * 0.500 / 2 * 1000,                               # V1 en mL
 "EX02": 0.05 * 180,
 "EX03": 13.605693122990 * (1 - 1/4),                          # CODATA R∞hc
 "EX04": (6.62607015e-34 * 299792458 / 1.602176634e-19) * 1e9 / 620,
 "EX05": -92.2 - 298 * (-199e-3),
 "EX06": -92.2e3 / -199,
 "EX07": math.log(2) / 0.05,
 "EX08": 8.314462618 * math.log(2) / (1/298 - 1/308) / 1000,
 "EX09": 0.5 * (4.8 - math.log10(0.01)),
 "EX10": 4.8 + math.log10(0.2 / 0.1),
 "EX11": 24 / (0.03 * 40),
 "EX12": 6.1 + math.log10(24 / (0.03 * 40)),
 "EX13": 0.45 + (8.314462618 * 298.15 * math.log(10) / 96485.33212) / 2 * math.log10(100),
 "EX14": 5 - 0 - 8 / 2,
}
# 2. Formule de la colonne (réévaluée) et contrôles
ok = True
print(f"{'id':5} {'formule':>12} {'attendu':>12} {'physique':>12} {'affiché':>8} {'rel':>3}  remarque")
for k, l in ex.items():
    e = E[k]; f = eval(l["formule"], {"__builtins__": {}}, dict(e))
    att = float(l["resultat_attendu"]); tol = float(l["tolerance"]); d = int(l["arrondi"])
    aff = rnd(att, d); sign = "=" if abs(rnd(f, d) - f) < 1e-9 else "≈"
    rq = []
    if abs(f - att) > tol: rq.append("ÉCART formule/attendu"); ok = False
    if rnd(ref[k], d) != aff: rq.append(f"affichage ≠ valeur physique arrondie ({rnd(ref[k], d)})"); ok = False
    if "R" in e and "L" in e and abs(math.log10(e["R"]) - e["L"]) > 1e-6: rq.append("log10 faux"); ok = False
    if "Rn" in e and "N" in e and abs(math.log(e["Rn"]) - e["N"]) > 1e-6: rq.append("ln faux"); ok = False
    print(f"{k:5} {f:12.6f} {att:12.6f} {ref[k]:12.6f} {aff:8g} {sign:>3}  {'; '.join(rq) or 'OK'}")
# 3. Conditions de validité et cohérence interne
c = []
c.append(("EX09 : pH < pKa − 1", 0.5 * (4.8 + 2) < 4.8 - 1))
c.append(("EX10 : R = [A−]/[HA]", abs(E["EX10"]["Ab"] / E["EX10"]["HA"] - E["EX10"]["R"]) < 1e-12))
c.append(("EX10 : 0,1 ≤ R ≤ 10 (zone tampon)", 0.1 <= E["EX10"]["R"] <= 10))
c.append(("EX12 : R = résultat EX11", abs(E["EX12"]["R"] - 24 / (0.03 * 40)) < 1e-9))
c.append(("EX06 : ΔH < 0 et ΔS < 0 → spontané si T < T_inv", E["EX05"]["H"] < 0 and E["EX05"]["S"] < 0))
c.append(("EX05/EX06 mêmes entrées", E["EX05"]["H"] == E["EX06"]["H"] and E["EX05"]["S"] == E["EX06"]["S"]))
# 4. Constantes dupliquées exemples.csv / valeurs.csv (non contrôlées par main.typ)
dup = [("EX03","ER","ER"),("EX04","hc","HC_EVNM"),("EX07","ln2","LN2"),("EX08","Rg","R_J"),
       ("EX13","k","NERNST25"),("EX11","s","CO2_SOL"),("EX12","pKa","BICARB_PKA")]
for i, cle, v in dup:
    c.append((f"{i}.{cle} = valeurs.{v}", float(E[i][cle]) == float(val[v]["valeur"])))
# 5. Arrondis des constantes affichées
c.append(("NERNST25 0,059 = arrondi(RT ln10/F, 3)", rnd(8.314462618*298.15*math.log(10)/96485.33212, 3) == 0.059))
c.append(("HC_EVNM 1240 ≈ 1239,84", round(6.62607015e-34*299792458/1.602176634e-19*1e9) == 1240))
c.append(("ER 13,6 = arrondi(13,6057, 1)", rnd(13.605693122990, 1) == 13.6))
c.append(("LN10 2,303", rnd(math.log(10), 3) == 2.303))
c.append(("pH sang moyen 7,40 ≈ EX12", rnd(6.1 + math.log10(20), 2) == 7.40))
for n, r in c:
    print(("OK    " if r else "ÉCHEC ") + n); ok &= r
print("RÉSULTAT :", "tous les contrôles passent" if ok else "au moins un écart")
sys.exit(0 if ok else 1)
```

Sortie (29.10.2026) :

```
id         formule      attendu     physique  affiché rel  remarque
EX01     25.000000    25.000000    25.000000       25   =  OK
EX02      9.000000     9.000000     9.000000        9   =  OK
EX03     10.200000    10.200000    10.204270     10.2   =  OK
EX04      2.000000     2.000000     1.999745        2   =  OK
EX05    -32.898000   -32.898000   -32.898000    -32.9   ≈  OK
EX06    463.316583   463.316583   463.316583      463   ≈  OK
EX07     13.860000    13.860000    13.862944     13.9   ≈  OK
EX08     52.893505    52.893505    52.896462     52.9   ≈  OK
EX09      3.400000     3.400000     3.400000      3.4   =  OK
EX10      5.101030     5.101030     5.101030      5.1   ≈  OK
EX11     20.000000    20.000000    20.000000       20   =  OK
EX12      7.401030     7.401030     7.401030      7.4   ≈  OK
EX13      0.509000     0.509000     0.509159     0.51   ≈  OK
EX14      1.000000     1.000000     1.000000        1   =  OK
OK    EX09 : pH < pKa − 1
OK    EX10 : R = [A−]/[HA]
OK    EX10 : 0,1 ≤ R ≤ 10 (zone tampon)
OK    EX12 : R = résultat EX11
OK    EX06 : ΔH < 0 et ΔS < 0 → spontané si T < T_inv
OK    EX05/EX06 mêmes entrées
OK    EX03.ER = valeurs.ER
OK    EX04.hc = valeurs.HC_EVNM
OK    EX07.ln2 = valeurs.LN2
OK    EX08.Rg = valeurs.R_J
OK    EX13.k = valeurs.NERNST25
OK    EX11.s = valeurs.CO2_SOL
OK    EX12.pKa = valeurs.BICARB_PKA
OK    NERNST25 0,059 = arrondi(RT ln10/F, 3)
OK    HC_EVNM 1240 ≈ 1239,84
OK    ER 13,6 = arrondi(13,6057, 1)
OK    LN10 2,303
OK    pH sang moyen 7,40 ≈ EX12
RÉSULTAT : tous les contrôles passent
```

Note de lecture : la colonne « affiché » donne la valeur numérique arrondie. Le PDF l'écrit avec ses zéros et la virgule décimale : 2,0 eV ; 5,10 ; 7,40.
