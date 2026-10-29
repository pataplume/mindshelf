# FR07-STD — rapport de vérification v1 (run R02)

Produit : FR07 « PASS/LAS Physique-Biophysique — fiche formules », variante FR07-STD (fr-FR, Clairance, risque IA faible, Whop et Etsy).
Vérificateur : agent VERIFICATEUR R02, sans participation à la production. Date : 2026-10-29.
Périmètre : `src/main.typ`, `donnees/{exemples,valeurs,sources,references,contenu,cartes}.csv`, `livraison/FR07-STD/FR07-STD-{a4,letter,nb,tablette}.pdf`. Hors périmètre (conditionneur) : `apercus/`, `video/`, `annonce/`, `donnees/extraits.csv`, `.apkg`.

## Verdict : **À corriger**

1 BLOQUANT, 8 MAJEURS, 11 MINEURS.

- Les 23 calculs sont justes (recalcul indépendant, 0 écart), les constantes et conversions sont conformes à CODATA 2022 et au SI, et les limites de radioprotection, les w_R et les doses d'imagerie ont les bonnes valeurs.
- Un nombre est faux à l'affichage dans les quatre PDF : `OA = −−0,3 m` (double signe moins).
- Le sous-titre promet une couverture (« les notions […] les plus courantes en PASS et LAS ») que les références ne justifient pas.
- Plusieurs références n'écrivent pas ce qui leur est attribué. Les licences OpenStax sont mal déclarées : CC BY-NC-SA 4.0 en réalité.

Contrôles réalisés :
- `scripts/controle_pdf.py FR07-STD` : tous les contrôles passent.
- Reconstruction dans une copie du dépôt (`scripts/build.py FR07-STD`) : texte identique aux quatre PDF livrés. Les PDF correspondent donc aux sources actuelles. Rien n'a été écrit dans `livraison/`.
- Rendu A4 et page 3 de la tablette inspectés à l'image.
- Recherches web le 2026-10-29 : préfaces OpenStax (CP 2e, Chemistry 2e, Biology 2e), OpenStax CP § 17.7 et § 12.7, fiche ODF Paris Cité, fiche d'UE Bourgogne Europe, fiche d'UE Angers, page Dunod.
- Légifrance n'a pas pu être consulté depuis cet environnement (erreur client).

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| B1 | BLOQUANT | 4 PDF, encadré « Lentille, myopie, presbytie » ; `main.typ`, fonction `v()` | Le PDF affiche `OA = −−0,3 m`. Le double signe moins peut se lire comme +0,3 m, et ce dans l'exemple même qui illustre la convention « objet réel OA < 0 ». Cause vérifiée : en Typst, `str(-0.3)` renvoie `−0.3` avec un U+2212. `nombre()` (charte) ne retire que le tiret ASCII (`trim("-")`), puis ajoute son propre signe. Toute entrée négative passée par `v()` est touchée, et `controle_pdf.py` ne le détecte pas. | Dans `v()`, normaliser le signe avant `nombre()`, par exemple `str(e.at(cle)).replace("\u{2212}", "-")`. Signaler le défaut au responsable de la charte : `nombre()` devrait aussi retirer U+2212, avec un rendu de non-régression sur les autres produits. Ajouter un contrôle « aucun `−−` » dans le PDF. |
| M1 | MAJEUR | Sous-titre (`main.typ` l. 116, écrit en dur) ; titre `PASS/LAS` (`data/produits.csv`) | « les notions de physique-biophysique les plus courantes en PASS et LAS » n'est pas justifié. (1) Paris Cité : intitulés et crédits seulement (Physique P1 4 ECTS, Biophysique P2 4 ECTS ; vérifié). (2) Grenoble et Rouen : intitulés seulement, d'après `references.csv`. (3) Bourgogne Europe et Angers : les fiches ne mentionnent ni PASS ni LAS (vérifié) ; à Angers, la partie biophysique se réduit à « Ondes et propagation des ondes », 8 h de CM. (4) Dunod : un seul manuel, dont le sommaire (vérifié) contient des chapitres absents de la fiche (acido-basique, oxydo-réduction, ECG, détection, imagerie isotopique). (5) Aucune source LAS. La fiche ne prétend pas suivre un « programme officiel », ce qui est correct. | Reformuler sans promesse de couverture, par exemple « Formules, exemples chiffrés, notes santé et pièges de physique-biophysique pour le PASS et la LAS (contenus variables selon les facultés) ». Placer le sous-titre dans une table de données plutôt qu'en dur. Vérifier que l'annonce ne reprend pas la promesse. |
| M2 | MAJEUR | `sources.csv`, lignes OPENSTAX_CP, OPENSTAX_CHEM, OPENSTAX_BIO | Licence déclarée « CC BY 4.0 ». Les préfaces OpenStax consultées le 2026-10-29 indiquent CC BY-NC-SA 4.0 pour College Physics 2e, Chemistry 2e et Biology 2e. Le produit est commercial. Je n'ai trouvé aucune reprise textuelle ni traduction serrée : les formules et les données factuelles ne sont pas protégées. FX11 reprend cependant le couple graisse/muscle et le résultat (1,4 %) de l'exemple 17.7(b). | Corriger la licence dans `sources.csv`. Noter en règle de production : OpenStax sert de référence factuelle, sans aucune reprise de texte, figure ou énoncé. Facultatif : changer le couple de tissus de FX11. |
| M3 | MAJEUR | `references.csv`, lignes Doppler (`Δf = 2f₀v cos θ/c`) | OPENSTAX_CP § 17.7 n'écrit ni la forme fermée `Δf = 2f₀v/c` ni le facteur `cos θ`. Il ne donne que les deux étapes `f_obs = f_s(v_w + v_b)/v_w` et `f_obs = f_s v_w/(v_w − v_b)` (vérifié). La formule affichée n'a donc pas de source qui l'écrit. Elle est juste sur le fond. | Ajouter une source d'échographie Doppler qui écrit `Δf = 2 f₀ v cos θ / c` (manuel de biophysique français ou ouvrage d'imagerie), avec sa localisation. |
| M4 | MAJEUR | `references.csv`, ligne Nernst (COSTANZO_PHYSIO) | La ligne attribue à Costanzo la forme « (61,5/z) log … mV à 37 °C ». Or sa propre localisation reconnaît que Costanzo écrit une autre valeur. C'est l'erreur du run précédent, seulement étiquetée A-VERIFIER. La valeur 61,5 mV est juste : recalcul 61,54 mV avec R, F CODATA 2022 et 310,15 K. | Scinder la ligne : équation de Nernst sous COSTANZO_PHYSIO, sans le nombre ; « 61,5 mV » sous une ligne « calcul » adossée à CODATA_2022 (déjà le cas dans `valeurs.csv`). |
| M5 | MAJEUR | `references.csv`, ligne osmolarité ; fiche « Solutions et échanges » | `i = 1 + α(p − 1)` est affiché, mais la source citée (Costanzo, « osmolarité = g × C ») ne l'écrit pas, comme la ligne l'admet. | Ajouter une source francophone qui écrit `i = 1 + α(p − 1)` (manuel PASS de biophysique, avec chapitre et page). |
| M6 | MAJEUR | `references.csv`, lignes BO_1RE_2019 et BO_TLE_2019 | Les deux conventions françaises de la fiche (relation de conjugaison en distances algébriques ; `ΔU = W + Q`) reposent sur des programmes de lycée. Leur formulation et leur URL sont A-VERIFIER. À ma connaissance, ces BO listent les notions sans écrire les formules : la localisation n'écrit probablement pas ce qui est affiché. | Citer un document qui écrit les formules : manuel de 1re ou de terminale, manuel PASS, ou le texte exact du BO s'il les contient, avec la page. |
| M7 | MAJEUR | `exemples.csv` FX21 (et FX20) ; `main.typ` | FX21 déclare `n = 3`, et c'est cette valeur que le PDF affiche (« Écran de 3 CDA »). La formule calcule pourtant `I0 / (2 * 2 * 2)` sans utiliser `n`. Si `n` change, le PDF afficherait « n CDA » avec 12,5 % sans échec de compilation : le contrôle de recalcul est contournable. FX20 code de même n = 4 en dur (`2*2*2*2`) ; seul `verifie("FX20 n", …, 4, 0)`, lui aussi en dur, le rattrape. | FX21 : `I0 / calc.pow(2, n)`. FX20 : ajouter `n` aux entrées, écrire `A0 / calc.pow(2, n)` et contrôler `FX20.n == FX19.resultat`, sans le 4 littéral. |
| M8 | MAJEUR | Piège « Mêmes lettres… » ; ensemble de la fiche | Seuls T, C et λ sont signalés. Restent non signalés : **R** (résistance hydraulique / constante des gaz, dans deux sections voisines), **Q** (débit / chaleur), **L** (longueur de Poiseuille / niveau sonore / chaleur latente), **Z** (impédance / numéro atomique), **γ** (grandissement / rapport gyromagnétique), **θ** (température en °C / angle Doppler), **h** (hauteur / constante de Planck), **n** (indice / quantité de matière / nombre de périodes), **i** (coefficient de van 't Hoff / angle d'incidence), **E** (champ / potentiel E_X / énergie / dose efficace). | Compléter le piège avec au moins R, Q, L, E et n, ou différencier par indices (R_h, Q_th, …), selon la place disponible. |
| m1 | MINEUR | `main.typ` | Textes et nombres écrits en dur : « 37 °C » (texte Nernst, l. 177 ; `verifie` l. 89-90, `37 +`) ; « patients : pas de limite, justification et optimisation » (l. 246) ; le sous-titre (l. 116). | Ajouter une valeur `P_THETA37 = 37 °C` et en dériver `P_T37` ; placer les libellés dans `valeurs.csv` ou une table de textes. |
| m2 | MINEUR | Encadrés FX05 et FX01 | « ω = 2 × 9/58,44 ≈ 308 mosmol/L » : l'expression vaut 0,308 et le facteur 1000 est implicite. « ρgh = 1000 × 9,81 × 1 Pa ≈ 74 mmHg » : l'unité est mal placée. | « ≈ 0,308 osmol/L = 308 mosmol/L » ; « ρgh = 9810 Pa ≈ 74 mmHg ». |
| m3 | MINEUR | Encadré FX03 | ρ, v, r et η affichés sans unités. | Ajouter kg/m³, m/s, m et Pa·s. |
| m4 | MINEUR | Encadré FX10 | f₀ n'est pas affiché (5 MHz implicite d'après FX09), et aucun `verifie` ne lie FX10.f à FX09.f. | Afficher f₀ ou ajouter `verifie("FX10 f", …)`. |
| m5 | MINEUR | Encadré optique (FX15, FX16) | L'unité δ est rendue en italique (variable mathématique), et l'espacement est incohérent : « −2 δ » contre « 3δ ». | `"δ"` droit avec espace insécable, comme `qu()`. |
| m6 | MINEUR | PDF tablette | Coupures de ligne à l'intérieur d'une unité ou d'une inégalité : « 42,58 MHz/ ⏎ T » (Constantes, p. 3), « OA < ⏎ 0 » (Pièges, p. 3). | Insécables (`MHz/T` en bloc, `OA~<~0`). |
| m7 | MINEUR | `donnees/contenu.csv` | « Fiche d'une page (…, version tablette …) » alors que la tablette fait 3 pages. Notions présentes dans le PDF mais absentes de la description : Snell-Descartes, réflexion totale, grandissement, accommodation, énergie du photon, Q = mcΔT et chaleur latente, pondérations T1/T2. Les comptages sont exacts (10 sections, 7 encadrés, 23 résultats, 8 notes, 11 pièges). | « Fiche d'une page (A4, US Letter, N&B) et version tablette de 3 pages » ; compléter les éléments 4 et 5. |
| m8 | MINEUR | `references.csv` (localisations) | OpenStax CP § 17.7 : les impédances sont dans le **tableau 17.5**, pas le 17.8 (vérifié ; les valeurs 429, 1,34 × 10⁶ et 1,70 × 10⁶ sont confirmées, de même que 1,4 % à l'exemple 17.7). Localisations restées vagues : Costanzo (pages de Laplace, PAM, Starling, σ), McRobbie (chapitres), CIPR 103 (sous-sections), Dunod (auteurs, année). | Corriger le numéro de tableau ; compléter pages et chapitres ; pour Dunod, auteurs, année et ISBN. |
| m9 | MINEUR | Tableau « Limites (France) » et « Imagerie » | Les valeurs sont justes (public 1 mSv/an ; travailleur 20 mSv sur 12 mois consécutifs ; patients sans limite ; w_R 1 / 2 / 20 ; doses Mettler 0,02 / 0,4 / 2 / 7 mSv). Les articles (CSP R1333-11, C. trav. R4451-6, CSP L1333-2) ne figurent toutefois pas sur le PDF. Les doses viennent d'un catalogue américain de 2008. | Ajouter les articles en abrégé dans la cellule et « ordres de grandeur » pour les doses ; une source française (IRSN/ASNR) peut compléter. |
| m10 | MINEUR | Fick, `references.csv` | Costanzo écrit `J = PA(C_A − C_B)` avec `P = KD/Δx`. La fiche omet le coefficient de partage K, ce que la ligne signale. | Mentionner « (coefficient de partage pris égal à 1) » dans la référence, ou citer un manuel qui écrit `J = D S ΔC/Δx`. |
| m11 | MINEUR | Tableau des défauts de l'œil | « Astigmatisme : cornée non sphérique » est imprécis : une cornée normale n'est pas parfaitement sphérique non plus. | « cornée de courbure inégale selon les méridiens (torique) : cylindrique ». |

Observations sans gravité :
- Rendu de ℱ et 𝒫 correct à l'image. `pdftotext` les extrait suivis du sélecteur de variante U+FE00, ce qui reste sans effet à l'écran.
- La virgule décimale est respectée, de même que `ΔU = W + Q` (avec le piège anglo-saxon), la relation de conjugaison algébrique et la vergence en δ.
- `cartes.csv` (hors encadré conditionneur) recopie en texte libre des valeurs de `valeurs.csv` (2000/3000, 61,5 mV, 1,86, 42,58, 63,9/127,7…). Elles concordent aujourd'hui, mais elles divergeront à la prochaine correction si elles ne sont pas générées depuis les tables.

## Points A-VERIFIER (avis)

| Point (`references.csv` / `sources.csv`) | Ce que j'ai pu vérifier | Bloque la publication ? |
|---|---|---|
| Bourgogne Europe : rattachement au PASS | Vérifié : la fiche d'UE ne mentionne ni PASS ni LAS (3,5 ECTS, 8 items). | Non, si le sous-titre est reformulé (M1). Sinon oui. |
| Angers : rattachement au PASS | Vérifié : non mentionné ; biophysique = 8 h CM d'ondes. | Idem. |
| Dunod : auteurs et année | La page éditeur ne les affiche pas (vérifié) ; 2e édition. | Non. À compléter par l'ISBN. |
| Costanzo : pages (Laplace, PAM, Starling, σ, π effective) | Non vérifié (ouvrage payant). Les formules sont justes sur le fond. Je n'ai pas pu confirmer que Costanzo écrit σ dans l'équation de Starling. | Non. |
| `i = 1 + α(p − 1)` | Non écrit par la source citée (constat M5). | Non sur le fond (formule juste) ; source à ajouter (MAJEUR). |
| Fick, K omis | Voir m10. | Non. |
| Nernst 61 contre 61,5 mV | 61,54 mV recalculé. | Non sur le fond ; ligne à scinder (M4). |
| Doppler, cos θ chez OpenStax | Vérifié : absent, comme la forme fermée (M3). | Non sur le fond ; source à ajouter (MAJEUR). |
| BO 1re et terminale : formulation exacte, URL | Non vérifié. Probablement des notions sans formule (M6). | Non sur le fond (conventions justes) ; source à ajouter (MAJEUR). |
| CIPR 103 : sous-sections ; McRobbie : chapitres | Non vérifié. Les grandeurs dosimétriques, les w_R et les formules IRM sont conformes à ma connaissance. | Non. |
| CSP L1333-2 : exclusion des patients de la limitation | Légifrance inaccessible ici. À ma connaissance, le 3° (principe de limitation) exclut l'exposition à des fins médicales ; R1333-11 (1 mSv/an) et R4451-6 (20 mSv sur 12 mois consécutifs) correspondent aux valeurs affichées. | Non, sous réserve d'un contrôle sur Légifrance par Tristan avant publication (texte réglementaire). |
| Mention « contenu vérifié et validé par le vendeur » | Elle ne sera vraie qu'après la levée des constats ci-dessus et la validation de Tristan. | Oui, tant que la validation n'a pas eu lieu. |

Non vérifié faute de temps ou d'accès : textes Légifrance, Mettler 2008 (tableaux 1 et 2, valeurs conformes à ma connaissance), pages MCCC de Grenoble et fiche de Rouen (je me fie à `references.csv`), Costanzo, McRobbie. Pour le N&B et le format Letter, je n'ai vérifié que les contrôles automatiques (aucun pixel coloré, aucun débordement), sans inspection à l'image.

## Script de recalcul

Exécution : `python3 -I recalcul_fr07.py /home/claude/mindshelf`. Résultat : 23/23 exemples recalculés sans écart, 23/23 valeurs arrondies présentes dans le texte du PDF A4, 22 constantes ou conversions à moins de 10⁻³ en relatif des valeurs exactes, w_R, doses et limites conformes ; « double signe moins : PRESENT (1) » ; FX21 `n` inutilisé ; FX20 `n` en dur. Code de sortie 0.

```python
#!/usr/bin/env python3
"""Recalcul indépendant FR07 (vérificateur R02). Lecture seule.
Usage : python3 -I recalcul_fr07.py /home/claude/mindshelf
Chaque résultat est recalculé par une formule réécrite ici (pas d'eval de la colonne `formule`),
puis comparé à resultat_attendu (tolérance de la ligne) et à l'affichage arrondi attendu dans le PDF A4."""
import csv, json, math, subprocess, sys
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

# 1. Exemples : formules réécrites indépendamment
indep = {
    "FX01": lambda e: e["rho"] * e["g"] * e["h"] / e["Pmm"],
    "FX02": lambda e: e["k"] ** -4,
    "FX03": lambda e: 2 * e["rho"] * e["v"] * e["r"] / e["eta"],
    "FX04": lambda e: e["D"] + (e["S"] - e["D"]) / 3,
    "FX05": lambda e: e["i"] * e["Cm"] / e["M"] * 1e3,
    "FX06": lambda e: e["i"] * (e["Cm"] / e["M"]) * 1e3 * e["R"] * e["T"] / 1e3,  # mol/m3 * R T = Pa -> kPa
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
    "FX20": lambda e: e["A0"] * 0.5 ** (E["FX19"]["t"] / E["FX19"]["T"]),  # n pris de FX19
    "FX21": lambda e: e["I0"] * 0.5 ** e["n"],  # n de la ligne (inutilisé par la formule du CSV)
    "FX22": lambda e: e["En"] / e["m"] * 1e3,
    "FX23": lambda e: e["wR"] * e["D"],
}
print("== Exemples")
for k, l in ex.items():
    ok(k, indep[k](E[k]), float(l["resultat_attendu"]), float(l["tolerance"]))

# 2. Affichage A4 : valeur arrondie attendue (virgule décimale) présente dans le texte du PDF
print("== Affichage (pdftotext A4)")
pdf = racine / "produits/FR07/livraison/FR07-STD/FR07-STD-a4.pdf"
txt = subprocess.run(["pdftotext", str(pdf), "-"], capture_output=True, text=True).stdout
norm = txt.replace("−", "-").replace(" ", " ").replace(" ", " ")
for k, l in ex.items():
    a = int(l["arrondi"]); r = round(float(l["resultat_attendu"]), a)
    s = (f"{r:.{a}f}").replace(".", ",")
    print(f"{'OK ' if s in norm else 'ABSENT'} {k} affiché « {s} »")
print("double signe moins :", "PRESENT (" + str(norm.count("--")) + ")" if "--" in norm else "aucun")

# 3. Constantes et conversions contre les valeurs exactes (CODATA 2022 / SI)
print("== Constantes")
h, c, e, NA, kB = 6.62607015e-34, 299792458, 1.602176634e-19, 6.02214076e23, 1.380649e-23
R, F = NA * kB, NA * e
eps0 = 8.8541878188e-12
exact = {"K_C": c, "K_H": h, "K_E": e, "K_NA": NA, "K_KB": kB, "K_R": R, "K_F": F,
         "K_K": 1 / (4 * math.pi * eps0), "K_EPS": eps0, "K_GP": 42.577478461, "K_GN": 9.80665,
         "K_HC": h * c / e * 1e9, "U_EV": e, "U_ATM": 101.325, "U_MMHG": 101325 / 760,
         "U_CMH2O": 98.0665, "U_CAL": 4.184, "U_ATM_MMHG": 760, "U_MMHG_CMH2O": (101325 / 760) / 98.0665,
         "P_NERNST37": math.log(10) * R * 310.15 / F * 1e3, "P_T37": 310.15,
         "P_M_NACL": 22.98976928 + 35.45}
for k, x in exact.items():
    rel = abs(V(k) - x) / abs(x)
    print(f"{'OK ' if rel < 1e-3 else 'ECART'} {k:13s} fiche={V(k):.6g} exact={x:.8g} écart rel={rel:.1e}")
    ecarts += rel >= 1e-3

# 4. Données d'imagerie, w_R, limites (valeurs de référence, pas de calcul)
print("== Repères")
attendu = {"W_PHOTON": 1, "W_PROTON": 2, "W_ALPHA": 20, "D_RXTHORAX": 0.02, "D_MAMMO": 0.4,
           "D_TDMCRANE": 2, "D_TDMTHORAX": 7, "L_PUBLIC": 1, "L_TRAVAILLEUR": 20}
for k, x in attendu.items():
    print(f"{'OK ' if V(k) == x else 'ECART'} {k} = {V(k):g}")
    ecarts += V(k) != x

# 5. Défauts de modèle de données (variables déclarées mais non utilisées par la formule)
print("== Modèle")
for k, l in ex.items():
    inutil = [v for v in E[k] if v not in l["formule"]]
    if inutil:
        print(f"ATTENTION {k} : entrée(s) {inutil} non utilisée(s) par la formule « {l['formule']} »")
print("ATTENTION FX20 : n = 4 écrit en dur (2*2*2*2), non relié à FX19 hors verifie()")
print("\nÉcarts de calcul :", ecarts)
sys.exit(1 if ecarts else 0)
```

Test de cause pour B1, compilé avec le module Python `typst` du pipeline : `str(-0.3)` donne `−0.3`, de points de code `2212,30,2e,33`, et `trim("-", at: start)` laisse `−0.3` inchangé.
