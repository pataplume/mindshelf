# FR07-STD : contre-vérification v2 (run R02)

- **Produit :** FR07 « PASS/LAS Physique-Biophysique — fiche formules », variante FR07-STD (fr-FR, Clairance, Whop et Etsy).
- **Vérificateur :** agent VÉRIFICATEUR R02, sans participation à la production ni à la correction. Date : 29.10.2026.
- **Périmètre :** ce qui a changé depuis le rapport v1 et les constats v1, plus les constats du conditionneur (`lots/CORR1/constats-conditionneur.md`). Ce n'est pas une seconde vérification complète.
- **Méthode :**
  - Relecture de `src/main.typ`, `charte/modele.typ` (`nombre()`), `donnees/{exemples,valeurs,textes,contenu,sources,references,cartes}.csv`, `annonce/whop.md` et `annonce/etsy/annonce.md`.
  - PDF A4 : pdftotext, rendu PNG de la page 1 à 110 dpi. Texte des pages de la tablette. Aperçu `apercus/01-page-1.png` comparé à l'image au PDF actuel : ils sont identiques sur le fond (nouveau sous-titre, −0,3 m, piège complété).
  - `scripts/controle_pdf.py FR07-STD` : tous les contrôles passent sur les 4 formats.
  - Recalcul indépendant : script en fin de rapport.
  - Pas de rebuild : les PDF (08:33) sont postérieurs à la dernière modification du Typst et des données (08:31). Rien n'a été écrit hors de `verif/`.
  - Contrôles en ligne le 29.10.2026 des nouvelles sources : Radiopaedia « Doppler shift », cours Guechi (Sétif), SchoolMouv (conjugaison ; premier principe), OpenStax Chemistry 2e § 5.3.

## Verdict : **OK avec réserves**

Il ne reste aucun BLOQUANT ni aucun MAJEUR : le BLOQUANT et les 8 MAJEURS de la v1 sont levés.

Les réserves portent sur 9 MINEURS : 3 de la v1 encore ouverts (m8 en partie, m9, et la partie FX11 de M2, reprise en n3), plus 6 nouveaux (n1 à n6). S'y ajoutent les deux conditions de publication déjà posées en v1 :
- la validation par Tristan, qui rend vraie la mention « contenu vérifié et validé par le vendeur » ;
- un contrôle sur Légifrance de l'exclusion des patients à l'art. L1333-2 du CSP.

Je n'ai trouvé aucune régression dans les données, le Typst, les cartes ou les annonces. Les 23 exemples sont justes, et chaque nombre des cartes Anki figure dans le PDF A4.

## Constats v1 : levé ou non levé

| # v1 | Constat | État | Preuve (v2) |
|---|---|---|---|
| B1 | `OA = −−0,3 m` | **Levé** | Dans `charte/modele.typ`, `nombre()` convertit désormais U+2212 en `-` avant de lire le nombre. Le PDF A4 affiche « OA = −0,3 m » (texte et image). Aucun double signe moins dans les 4 PDF FR07, ni dans aucun PDF de `produits/*/livraison/` : la non-régression de la charte est vérifiée sur tous les produits livrés. Reste : `controle_pdf.py` ne teste toujours pas le double signe moins (n5). |
| M1 | Sous-titre qui promet une couverture | **Levé** | Le sous-titre est dans `textes.csv` (`SOUS_TITRE`), lu par `texte()` : « …notions fréquentes en PASS/LAS ; les enseignements varient selon les facultés », formule de la règle 14. `contenu.csv`, `whop.md` et `etsy/annonce.md` ne promettent aucune couverture et ajoutent « comparez avec votre programme ». |
| M2 | Licences OpenStax | **Levé** | Les 3 lignes OpenStax de `sources.csv` sont en CC BY-NC-SA 4.0, ce que confirme la page OpenStax Chemistry 2e consultée. Reste : le couple graisse/muscle de FX11 (n3). |
| M3 | Doppler `Δf = 2f₀v cos θ/c` sans source qui l'écrit | **Levé** | Radiopaedia, « Doppler shift », consulté. La page écrit « F = 2fo(v/c)cos(Q) », Q étant l'angle faisceau/flux, et précise « the Greek letter theta (θ) is also used ». Avis sur la source : voir la section A-VERIFIER. |
| M4 | Nernst 61,5 mV attribué à Costanzo | **Levé** | La ligne est scindée : l'équation sans le nombre sous COSTANZO_PHYSIO, et « 61,5 mV » comme calcul sous CODATA_2022. Recalcul : 61,54 mV. Le Typst contrôle P_THETA37 + U_KELVIN = P_T37 ainsi que Nernst à 37 °C. |
| M5 | `i = 1 + α(p − 1)` sans source | **Levé** | Cours Guechi (1re année de médecine, 2022/2023), consulté : p. 3, « Coefficient d'ionisation », i = 1 + (ν − 1)α, avec les cas i = 1 + α et i = 1 + 2α. La localisation de `references.csv` est exacte. |
| M6 | Conventions françaises adossées au BO | **Levé** | Les lignes BO ont disparu. ΔU = W + Q : OpenStax Chemistry 2e § 5.3, consulté (« ΔU = q + w » ; « w is positive if it is done on the system ») ; SchoolMouv Tle, consulté (« ΔU = W_total + Q_total », énergie reçue comptée positivement). Conjugaison : SchoolMouv Tle, consulté (1/OA' − 1/OA = 1/OF'), et transcription algébrique d'OpenStax CP § 25.6. Réserve sur SchoolMouv : n2. |
| M7 | FX20/FX21 : `n` inutilisé ou écrit en dur | **Levé** | FX20 calcule `A0 / calc.pow(2, n)` et `verifie("FX20 n", …)` compare n au résultat de FX19, sans littéral. FX21 calcule `I0 / calc.pow(2, n)`. Le script vérifie que chaque entrée sert dans sa formule. |
| M8 | Symboles réutilisés non signalés | **Levé** | Le piège « Mêmes lettres » cite T, C, λ, R, Q, L, E et n, et renvoie à Z, γ, θ, h et i. |
| m1 | Textes et nombres en dur | **Levé** | Ajouts : P_THETA37 et U_KELVIN dans `valeurs.csv`, LIMITE_PATIENTS et SOUS_TITRE dans `textes.csv`. Le Typst ne contient plus de « 37 ». |
| m2 | Unités mal placées (FX01, FX05) | **Levé** | PDF : « ρgh = 1000 × 9,81 × 1 = 9810 Pa ≈ 74 mmHg » ; « ≈ 0,308 osmol/L = 308 mosmol/L ». |
| m3 | Unités de FX03 | **Levé** | kg/m³, m/s, m et Pa·s sont affichés. |
| m4 | f₀ de FX10 | **Levé** | Le texte dit « Même f₀ » et `verifie("FX10 f", …)` contrôle l'égalité. |
| m5 | δ en italique, espacement | **Levé** | « −2 δ » et « 3 δ » sont en romain, avec insécable. |
| m6 | Coupures sur la tablette | **Levé** | Les unités et `OA < 0` sont dans des `box()`. Aucune ligne de la tablette ne finit par « MHz/ » ou « < ». |
| m7 | `contenu.csv` | **Levé** | Le texte dit « plus une version tablette de 3 pages » et les notions manquantes sont ajoutées. Les comptages sont exacts : 10 sections, 7 encadrés, 23 résultats, 8 notes, 11 pièges, 2 tableaux, 24 cartes. |
| m8 | Localisations | **Partiellement levé** | Le tableau 17.5 est corrigé. Restent A-VERIFIER : pages Costanzo, chapitres McRobbie, sous-sections CIPR 103, et pour le Dunod les auteurs, l'année et l'ISBN. |
| m9 | Articles réglementaires absents du PDF ; doses sans « ordres de grandeur » | **Non levé** | Cellules inchangées. MINEUR, sans effet sur la publication. |
| m10 | Fick : coefficient de partage K omis | **Levé** | La référence indique « coefficient de partage K pris égal à 1 ». |
| m11 | Astigmatisme | **Levé** | « courbure de la cornée inégale selon les méridiens : cylindrique ». |
| C1 (conditionneur) | `contenu.csv` trop long pour la vignette | **Levé** | `apercus/05-contenu.png` a été régénéré après la dernière modification de `contenu.csv` (08:32 contre 08:29). La version `contenu-propose.csv` n'a pas été reprise, mais la vignette passe. |
| C2 (conditionneur) | « < » non échappé dans les cartes | **Levé** | `donnees/cartes.csv` est identique à `lots/CORR1/cartes-echappees.csv` : 3 `&lt;` et aucun « < » nu. L'`.apkg` est postérieur. |
| C3 (conditionneur) | Double signe moins | **Levé** | Voir B1. |
| C4 (conditionneur) | Sous-titre | **Levé** | Voir M1. |

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| n1 | MINEUR | `references.csv`, ligne « Premier principe ΔU = W + Q … » | La ligne garde « A-VERIFIER : écriture exacte w = −PΔV dans § 5.3 ». Vérifié le 29.10.2026 : le § 5.3 écrit « PΔV = −w » (« The mathematical product PΔV represents work (w), namely, expansion or pressure-volume work »). C'est la même relation. | Remplacer l'A-VERIFIER par « écrit PΔV = −w (équivalent) ». |
| n2 | MINEUR | `sources.csv`, SCHOOLMOUV_CONJ et SCHOOLMOUV_THERMO | Les pages ne portent ni auteur ni date (seulement « © SchoolMouv 2026 »), alors que la règle 12 demande auteur.e.s, titre, édition et année. Le fond est juste et vérifié. ΔU = W + Q a déjà une source identifiée (OpenStax Chemistry 2e § 5.3, même convention) ; la conjugaison, une transcription documentée d'OpenStax CP § 25.6. SchoolMouv ne fait que compléter. | Acceptable en complément. Au prochain passage, remplacer par un manuel de terminale (auteur.e.s, année, page) ou un cours universitaire daté. |
| n3 | MINEUR | `exemples.csv` FX11 ; `references.csv` (« FX11 retrouve le résultat de l'exemple 17.7 ») | FX11 reprend le cas de l'exemple 17.7(b) d'OpenStax CP : graisse → muscle, mêmes Z, 1,4 %. Le texte n'est pas repris, mais la règle 3 exclut désormais toute reprise « d'exemple » d'un livre sous licence non commerciale. | Changer d'interface (par ex. muscle → os, ou sang → graisse ; les Z sont des données factuelles). Mettre à jour `valeurs.csv`, les `verifie()` et la référence. |
| n4 | MINEUR | `references.csv` et `sources.csv` : PROG_ANGERS_UE10 (mise à jour du 25.09.2024) ; PROG_UBE_BIOPHYS (« sans date ») | La règle 14 veut des programmes de l'année en cours ou de la précédente (2026-2027 ou 2025-2026). La fiche d'Angers est de 2024-2025 ; celle de Bourgogne Europe n'est pas datée. Les deux lignes servent de repères et ne promettent rien. | Remplacer par les fiches 2025-2026 ou 2026-2027, ou supprimer les deux lignes. La sélection reste soutenue par le manuel Dunod PASS et par les intitulés de Paris Cité, Grenoble et Rouen. |
| n5 | MINEUR (processus) | `scripts/controle_pdf.py` | Le contrôle « aucun double signe moins » recommandé en v1 n'a pas été ajouté. La correction de la charte suffit aujourd'hui (0 occurrence dans tous les PDF livrés), mais rien n'empêche une rechute. | Ajouter un test regex `[−-]\s?[−-]` sur le texte de chaque PDF. |
| n6 | MINEUR | `valeurs.csv`, P_THETA37 (source BIPM_SI_9) | La brochure SI ne donne pas « 37 °C, température de référence du corps humain ». Elle ne justifie que la conversion en kelvins. | Source : convention d'exercice, ou Costanzo (température corporelle). |

Observation sans gravité : les pages OpenStax consultées précisent que leurs livres ne peuvent pas servir à entraîner des modèles de langage sans autorisation écrite. MindShelf ne s'en sert que comme référence de vérification, ce qui reste compatible. Je le signale pour mémoire, à côté de la licence NC.

## A-VERIFIER restants : avis

| Point | Avis | Bloque la publication ? |
|---|---|---|
| Radiopaedia « Doppler shift » : aucune date affichée ; contributeurs nommés dans les déclarations | Formule vérifiée. Radiopaedia est une référence de radiologie revue par ses éditeurs et largement citée, ce qui suffit pour une formule universelle. La licence est CC BY-NC-SA 3.0, mais rien n'est repris. Un manuel daté d'échographie peut compléter. Pas besoin d'A-VERIFIER. | Non |
| Cours Guechi (Sétif, 2022/2023) : faculté étrangère | Auteur, titre, année et page sont identifiés, et la formule est vérifiée p. 3. Le document n'imprime pas le nom de l'établissement, connu seulement par l'URL de la faculté. La notation est celle des cours francophones de biophysique. Suffisant ; un manuel PASS français (chapitre et page) peut compléter. | Non |
| SchoolMouv (×2) : pages sans auteur ni date | Voir n2 : suffisantes en complément, pas comme source unique. | Non |
| OpenStax Chemistry 2e § 5.3 : w = −PΔV | Vérifié : le § 5.3 écrit « PΔV = −w » (n1). L'A-VERIFIER peut être retiré. | Non |
| Dunod (auteurs, année, ISBN) ; Costanzo (pages) ; McRobbie (chapitres) ; CIPR 103 (sous-sections) | Inchangés depuis la v1. Les valeurs sont justes sur le fond. | Non |
| CSP L1333-2 : exclusion des patients de la limitation | Inchangé ; Légifrance n'est pas accessible depuis cet environnement. | Non pour le fond, mais Tristan doit le contrôler sur Légifrance avant publication (texte réglementaire). |
| Mention « contenu vérifié et validé par le vendeur » | Elle n'est vraie qu'après la validation de Tristan. | **Oui**, jusqu'à cette validation (condition de processus). |

## Script de recalcul (`recalcul_fr07_v2.py`, lecture seule)

Exécution le 29.10.2026 : `python3 -I recalcul_fr07_v2.py /home/claude/mindshelf`. Code de sortie 0 : 111 contrôles OK, 0 écart.

- 23 exemples recalculés par une formule indépendante, et 23 par réévaluation de la colonne `formule` (`calc.pow` évalué comme `pow`).
- 23 valeurs arrondies présentes dans le PDF A4.
- 0 double signe moins dans les 4 PDF ; « −0,3 » présent.
- 24 constantes ou conversions à moins de 10⁻³ en relatif des valeurs exactes.
- 9 repères (w_R, doses, limites).
- Aucune entrée inutilisée ; les liens FX19 → FX20, FX09 → FX10, FX13 → FX14 et FX22 → FX23 sont cohérents.

```python
#!/usr/bin/env python3
"""Recalcul indépendant FR07, contre-vérification v2 (vérificateur R02). Lecture seule.
Usage : python3 -I recalcul_fr07_v2.py /home/claude/mindshelf
1. Chaque exemple est recalculé par une formule réécrite ici, puis la colonne `formule` est réévaluée
   (calc.pow(x, n) évalué comme pow(x, n), règle 9) ; les deux sont comparés à resultat_attendu.
2. Valeur arrondie attendue présente dans le texte du PDF A4 ; recherche du double signe moins
   dans les quatre PDF, sans normalisation préalable (U+2212 et tiret ASCII).
3. Constantes et conversions contre les valeurs exactes (CODATA 2022 / SI), repères de dose.
4. Modèle : entrées déclarées mais non utilisées par la formule ; liens FX19 → FX20, FX09 → FX10."""
import csv, json, math, re, subprocess, sys
from pathlib import Path

racine = Path(sys.argv[1] if len(sys.argv) > 1 else "/home/claude/mindshelf")
d = racine / "produits/FR07/donnees"
ex = {l["id"]: l for l in csv.DictReader(open(d / "exemples.csv", encoding="utf-8"))}
va = {l["id"]: l for l in csv.DictReader(open(d / "valeurs.csv", encoding="utf-8"))}
E = {k: json.loads(l["entrees_json"]) for k, l in ex.items()}
V = lambda i: float(va[i]["mantisse"]) * 10 ** int(va[i]["exposant"])
ecarts = 0

def ok(nom, calc, attendu, tol):
    global ecarts
    bon = abs(calc - attendu) <= tol
    ecarts += not bon
    print(f"{'OK ' if bon else 'ECART'} {nom:28s} calc={calc:.6g} attendu={attendu:.6g} tol={tol:g}")

class Calc:  # calc.pow(x, n) de Typst
    pow = staticmethod(pow)

indep = {
    "FX01": lambda e: e["rho"] * e["g"] * e["h"] / e["Pmm"],
    "FX02": lambda e: e["k"] ** -4,
    "FX03": lambda e: 2 * e["rho"] * e["v"] * e["r"] / e["eta"],
    "FX04": lambda e: e["D"] + (e["S"] - e["D"]) / 3,
    "FX05": lambda e: e["i"] * e["Cm"] / e["M"] * 1e3,
    "FX06": lambda e: e["i"] * (e["Cm"] / e["M"]) * 1e3 * e["R"] * e["T"] / 1e3,
    "FX07": lambda e: e["dt"] / e["Kc"],
    "FX08": lambda e: e["k"] / e["z"] * e["lg"],
    "FX09": lambda e: e["c"] / e["f"] * 1e3,
    "FX10": lambda e: 2 * e["f"] * e["v"] * e["cs"] / e["c"] / 1e3,
    "FX11": lambda e: ((e["Z2"] - e["Z1"]) / (e["Z1"] + e["Z2"])) ** 2 * 100,
    "FX12": lambda e: ((e["Z2"] - e["Z1"]) / (e["Z1"] + e["Z2"])) ** 2 * 100,
    "FX13": lambda e: 1 / (1 / e["fp"] + 1 / e["oa"]),
    "FX14": lambda e: e["oap"] / e["oa"],
    "FX15": lambda e: -1 / e["x"],
    "FX16": lambda e: 1 / e["d"] - 1 / e["pp"],
    "FX17": lambda e: e["g"] * e["B"],
    "FX18": lambda e: e["g"] * e["B"],
    "FX19": lambda e: e["t"] / e["T"],
    "FX20": lambda e: e["A0"] * 0.5 ** (E["FX19"]["t"] / E["FX19"]["T"]),  # n tiré de FX19, pas de FX20
    "FX21": lambda e: e["I0"] * 0.5 ** e["n"],
    "FX22": lambda e: e["En"] / e["m"] * 1e3,
    "FX23": lambda e: e["wR"] * e["D"],
}
print("== Exemples : formule indépendante, puis colonne `formule` réévaluée")
for k, l in ex.items():
    tol = float(l["tolerance"]); att = float(l["resultat_attendu"])
    ok(k + " indépendant", indep[k](E[k]), att, tol)
    f = l["formule"]
    if re.search(r"\*\*|[a-zA-Z_]+\(", f.replace("calc.pow(", "")):
        print(f"ECART {k} : fonction non admise dans la colonne formule : {f}"); ecarts += 1
    ok(k + " colonne formule", eval(f, {"__builtins__": {}, "calc": Calc}, dict(E[k])), att, tol)

print("== Affichage (pdftotext A4)")
liv = racine / "produits/FR07/livraison/FR07-STD"
txt = subprocess.run(["pdftotext", str(liv / "FR07-STD-a4.pdf"), "-"], capture_output=True, text=True).stdout
norm = txt.replace("−", "-").replace(" ", " ").replace(" ", " ")
for k, l in ex.items():
    a = int(l["arrondi"]); r = round(float(l["resultat_attendu"]), a)
    s = (f"{r:.{a}f}").replace(".", ",")
    present = s in norm
    ecarts += not present
    print(f"{'OK ' if present else 'ABSENT'} {k} affiché « {s} »")
for f in sorted(liv.glob("*.pdf")):
    t = subprocess.run(["pdftotext", str(f), "-"], capture_output=True, text=True).stdout
    n = len(re.findall("[−-]\\s?[−-]", t))
    ecarts += n > 0
    print(f"{'OK ' if n == 0 else 'ECART'} double signe moins dans {f.name} : {n}")
print("OK " if "−0,3" in txt else "ECART", "« −0,3 » (FX13, OA) présent avec un seul signe moins")

print("== Constantes")
h, c, e, NA, kB = 6.62607015e-34, 299792458, 1.602176634e-19, 6.02214076e23, 1.380649e-23
R, F = NA * kB, NA * e
eps0 = 8.8541878188e-12
exact = {"K_C": c, "K_H": h, "K_E": e, "K_NA": NA, "K_KB": kB, "K_R": R, "K_F": F,
         "K_K": 1 / (4 * math.pi * eps0), "K_EPS": eps0, "K_GP": 42.577478461, "K_GN": 9.80665,
         "K_HC": h * c / e * 1e9, "U_EV": e, "U_ATM": 101.325, "U_MMHG": 101325 / 760,
         "U_CMH2O": 98.0665, "U_CAL": 4.184, "U_ATM_MMHG": 760, "U_MMHG_CMH2O": (101325 / 760) / 98.0665,
         "P_NERNST37": math.log(10) * R * 310.15 / F * 1e3, "P_T37": 310.15, "P_THETA37": 37,
         "U_KELVIN": 273.15, "P_M_NACL": 22.98976928 + 35.45}
for k, x in exact.items():
    rel = abs(V(k) - x) / abs(x)
    print(f"{'OK ' if rel < 1e-3 else 'ECART'} {k:13s} fiche={V(k):.6g} exact={x:.8g} écart rel={rel:.1e}")
    ecarts += rel >= 1e-3

print("== Repères")
attendu = {"W_PHOTON": 1, "W_PROTON": 2, "W_ALPHA": 20, "D_RXTHORAX": 0.02, "D_MAMMO": 0.4,
           "D_TDMCRANE": 2, "D_TDMTHORAX": 7, "L_PUBLIC": 1, "L_TRAVAILLEUR": 20}
for k, x in attendu.items():
    print(f"{'OK ' if V(k) == x else 'ECART'} {k} = {V(k):g}")
    ecarts += V(k) != x

print("== Modèle")
for k, l in ex.items():
    inutil = [v for v in E[k] if not re.search(rf"\b{v}\b", l["formule"])]
    if inutil:
        print(f"ATTENTION {k} : entrée(s) {inutil} non utilisée(s) par « {l['formule']} »"); ecarts += 1
liens = [("FX20.n = FX19 (t/T)", E["FX20"]["n"], E["FX19"]["t"] / E["FX19"]["T"]),
         ("FX10.f = FX09.f", E["FX10"]["f"], E["FX09"]["f"]),
         ("FX14.oap = résultat FX13", E["FX14"]["oap"], float(ex["FX13"]["resultat_attendu"])),
         ("FX23.D = résultat FX22", E["FX23"]["D"], float(ex["FX22"]["resultat_attendu"]))]
for nom, a, b in liens:
    print(f"{'OK ' if abs(a - b) < 1e-9 else 'ECART'} {nom}"); ecarts += abs(a - b) >= 1e-9
print("\nÉcarts :", ecarts)
sys.exit(1 if ecarts else 0)
```
