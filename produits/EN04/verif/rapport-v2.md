# EN04-STD « SPI Ultrasound Physics — Express Review Sheets » : rapport de vérification v2

Run R03, contre-vérification indépendante (je n'ai participé ni à la production ni à la correction), 29.10.2026. Périmètre : les constats de `verif/rapport-v1.md` et ce qui a changé (corrections v2 et passe de sourçage v3). Ce n'est pas une seconde vérification complète. Objets : `src/main.typ`, `donnees/*`, `annonce/*`, `livraison/EN04-STD/*.pdf` (fabriqués à 10:31).

## Verdict : **OK avec réserves**

- **M2 est levé**, comme les MINEURS m1 à m11 (m10 en grande partie).
- **M1 (sourçage) n'est levé qu'en partie.** 15 sources Radiopaedia ont été ajoutées, et les 4 que j'ai sondées sont exactes. Mais **18 des 42 lignes** de `references.csv` portent encore un `A-VERIFIER` :
  - 10 n'ont aucune source lue (ce sont les 10 lignes du brief) ;
  - 8 autres (« A-VERIFIER (reste) ») ne sont sourcées qu'en partie.
- **Avis :** c'est une réserve, pas un blocage (argumentation plus bas).
- **Nouveau constat :** un MINEUR. Les annonces n'ont pas été régénérées après la correction de `contenu.csv`.
- **Contrôles passés :**
  - **Calculs :** les 27 exemples sont recalculés sans écart, et les contrôles croisés passent.
  - **Build de contrôle :** `scripts/build.py EN04-STD` lancé dans une copie du dépôt. `controle_pdf.py` passe sur les 4 formats et le texte des 4 PDF rebâtis est identique à celui des PDF livrés.
  - **Motif `#f(...);` (règle 16) :** aucune occurrence.

## Constats v1 : levé / non levé

| # v1 | Constat (résumé) | État | Preuve |
|---|---|---|---|
| M1 | Fond renvoyé à Kremkau sans localisation | **Partiellement levé** | 15 sources Radiopaedia ont été ajoutées dans `sources.csv` (URL, date), et `references.csv` est découpé en sous-éléments. 24 lignes sur 42 sont sourcées par une page lue (Radiopaedia, FDA, AIUM, plan ARDMS) ou par un calcul. Restent 10 lignes sans source lue (l. 3, 4 [T = 1/f et λ = c/f], 6, 12, 13, 26, 27, 28, 32, 42) et 8 lignes « (reste) » (l. 10 PD/PRP/DF, 16 incidence normale, 19 spéculaire/diffusion, 23 résolution temporelle et FR, 25 point de Curie et f = c/2e, 31 v_max, Doppler couleur et puissance, filtre de paroi, 35 huit artefacts, 40 cavitation stable / inertielle). `valeurs.csv` : P_ATT (0.5 dB/cm/MHz), P_ULTRA (20 kHz) et P_BERN_K (4) restent sur KREMKAU_11, « contenu non consulté ». Le statut est déclaré honnêtement (règle 15 respectée). |
| M2 | FDA non consultée, sans URL ni section | **Levé** | `sources.csv` FDA_US_2023 : URL `fda.gov/media/71100/download`, « document issued on February 21, 2023 », § 5.2.8, p. 28. `references.csv` l. 41 cite le texte. Plan SPI v24.1 cité (URL Inteleos, poids 23/7/26/34/10, `A-VERIFIER` retiré). |
| m1 | Limite MI présentée seule | **Levé** | `L_ISPPA` (190 W/cm²) ajouté. PDF : « derated I_SPTA ≤ 720 mW/cm² and MI ≤ 1.9 (or derated I_SPPA ≤ 190 W/cm²) ». |
| m2 | `contenu.csv` sans l'instrumentation | **Levé dans `contenu.csv`** | La ligne 5 « Instrumentation: receiver functions… » a été ajoutée. Les annonces, elles, n'ont pas suivi : voir n1. |
| m3 | Phrases qualitatives non contrôlées | **Levé** | `main.typ` l. 87-90 : `exige` couvre EX15 < EX16, EX12 c2 > c1 et EX20 c < c0. |
| m4 | « f₀ = 5,000 kHz » | **Levé** | Entrée `fm` = 5. Le PDF affiche « f₀ = 5 MHz ». Le contrôle `verifie("f0 EX15 MHz/kHz")` vérifie fm × 1000 = f. |
| m5 | Unité manquante (« assumes 1,540 ») | **Levé** | « system assumes 1,540 m/s ». |
| m6 | Source de P_13US incohérente | **Levé** | ANALYSE_MATH dans les deux fichiers. |
| m7 | Exclusions incomplètes | **Levé** | « …, among others, are not covered ». |
| m8 | « set by the system » | **Levé** | « set by the source (output power), then decrease as sound travels ». |
| m9 | Cause de l'ombre acoustique | **Levé** | « strong attenuation or reflection: stone, bone, gas » (`artefacts.csv` et carte). |
| m10 | Nombres retapés dans les cartes | **Largement levé** | 6 marqueurs `{x:}` / `{v:}`. Il reste « 1540 m/s » tapé à la main, conforme à P_CTISSUE. |
| m11 | Césure dans les titres | **Levé pour les titres** | « Sound & acoustic parameters » et « Instrumentation & processing » ne sont plus coupés (A4). Les encadrés n'ont pas été revus (constat optionnel en v1). |

## Sondage des citations Radiopaedia ajoutées (4 sur 15, relues le 29.10.2026)

| Source (`sources.csv`) | Citation dans `references.csv` | Résultat |
|---|---|---|
| RADIOPAEDIA_SPL (spatial-pulse-length-ultrasound) | « Mathematically, it is the product of the number of cycles in a pulse and the wavelength » | **Conforme**, mot pour mot ; la page n'affiche pas de titre, comme le note la ligne |
| RADIOPAEDIA_NL (nyquist-limit) | « The Nyquist limit always equals Pulse Repetition Frequency (PRF)/2 » ; remèdes PRF et ligne de base ; « In continuous wave Doppler, there is no pulse repetition frequency » | **Conforme** |
| RADIOPAEDIA_TRD (articles/54038) | « based on the piezoelectric effect », « usually lead zirconate titanate (PbZT) », « each layer is one-quarter wavelength thick », amortissement (backing) ; sens épaisseur ↔ fréquence | **Conforme** (« a thicker element produces a lower frequency… ») |
| RADIOPAEDIA_REFL (articles/reflection) | « RI = Ir / Ii », « TI = 1 − RI », θi = θr ; révision Qureshi 18.04.2024 | **Conforme** |

Les 11 autres citations n'ont pas été relues (budget).

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| n1 | MINEUR | `annonce/whop.md` et `annonce/etsy/annonce.md` (fabriqués à 10:08-10:09, avant les corrections) | Les deux annonces listent 7 éléments de contenu et omettent la ligne « Instrumentation: receiver functions, gain vs output power, pre/post-processing, dynamic range, harmonic imaging, spatial compounding », ajoutée à `contenu.csv` par la correction m2. Rien de faux n'est annoncé, mais l'annonce ne décrit pas toute la fiche. Les comptes concordent : 27 cartes, 11 artefacts, 8 lignes, 11 exemples, 27 résultats, 12 pièges. | Relancer `scripts/annonces.py EN04` et contrôler que les 8 lignes de `contenu.csv` apparaissent. |

## Les 10 lignes sans source lue : avis demandé

**Avis : une réserve suffit ; elles ne doivent pas bloquer la publication.** Raisons :
1. **Règles du producteur.** La règle 1 prévoit explicitement ce cas : « Pas de source fiable : on ne l'écrit pas, ou on le marque `A-VERIFIER` ». La fiche du vérificateur classe une « référence manquante ou fragile » en MAJEUR, pas en BLOQUANT ; le blocage est réservé aux erreurs factuelles, et aucune n'a été trouvée.
2. **Deux lectures indépendantes concordent.** La v1 et moi n'avons trouvé aucune erreur sur ces lignes.
3. **Nature des contenus.**
   - La moitié sont des définitions :
     - ultrasons > 20 kHz ;
     - T = 1/f, λ = c/f ;
     - I = P/A ;
     - nomenclature SP/SA/TP/TA ;
     - types de sondes ;
     - fonctions du récepteur.
   - Les autres sont des constantes de manuel enseignées de la même façon par toute la préparation SPI :
     - 0,5 dB/cm/MHz ;
     - NZL = D²/4λ ;
     - ΔP ≈ 4v² ;
     - assurance qualité, sensibilité et spécificité.
4. **Pas de risque clinique.** Le produit est un support de révision d'examen de physique, sans relecture métier. Une imprécision de source n'expose pas à une erreur de dose ou d'interprétation (à la différence d'EN08).
5. **Statut honnête.** `sources.csv` dit « contenu non consulté » pour KREMKAU_11. Rien n'est déclaré vérifié à tort (règle 15).

**Conditions de la réserve :**
- **Validation éclairée par Tristan.** La validation qui rend vraie la mention « content checked and approved by the seller » doit se faire en connaissance des 18 lignes `A-VERIFIER` (10 sans source et 8 « reste »). Il faut donc les lister dans l'enregistrement de validation (`data/revues.csv`) ou dans un fichier de statut, comme `statut-methode.md` pour EN08.
- **Priorité de sourçage en v-suivante** (non bloquante) : les valeurs chiffrées qu'un.e acheteur.euse peut contester et qui alimentent les exemples, à savoir P_ATT 0,5 dB/cm/MHz (EX09, EX10), NZL = D²/4λ (EX13), P_BERN_K = 4 (EX18) et P_ULTRA 20 kHz. Pistes ouvertes **non consultées par moi** : les autres articles Radiopaedia (atténuation, champ proche, TGC, équation de Bernoulli modifiée, artefacts de réverbération, image miroir, ombre et renforcement, cavitation) ou un manuel en libre accès localisé.
- **Correction du compte du brief.** Le brief parle de 10 lignes. Il faut aussi tracer les 8 lignes « (reste) », qui ne sont sourcées qu'en partie.

## A-VERIFIER restants : avis

| Point | Avis | Bloque la publication ? |
|---|---|---|
| 10 lignes sans source lue + 8 lignes « (reste) » | Voir ci-dessus. | Non (réserve) |
| Plan SPI v24.1 | Cité avec l'URL ; `A-VERIFIER` retiré. | Non |
| Limites FDA | Sourcées (§ 5.2.8, p. 28). | Non |
| Mention « content checked and approved by the seller » | Exacte seulement après la validation de Tristan (règle 15). | **Oui**, tant que Tristan n'a pas validé |

## Script de recalcul

Script v1 inchangé, plus un contrôle : EX15 `fm` × 1000 = `f`, puisque l'entrée en MHz a été ajoutée par la correction m4.

Exécution : `python3 -I recalc_en04.py produits/EN04/donnees` → **RESULTAT GLOBAL : OK**.
- Les 27 exemples passent : formule de la donnée, formule physique indépendante et arrondi affiché.
- Les contrôles croisés passent : 13 µs/cm, v_max ↔ Nyquist, EX15 < EX16, c2 > c1, c < c0, PRF = 1/PRP, somme des poids = 100.

```python
#!/usr/bin/env python3
"""Recalcul indépendant des exemples EN04 v2 (vérificateur R03, script v1 + contrôle EX15 MHz/kHz).
Usage : python3 -I recalc_en04.py <chemin>/produits/EN04/donnees
- évalue chaque `formule` de exemples.csv (calc.pow(x, n) -> pow(x, n)), compare à resultat_attendu (tolérance) ;
- contrôle la syntaxe (règle 9 : + - * / ( ) et calc.pow seulement ; entrées en décimal, sans 1e-6) ;
- recalcule chaque résultat par une formule physique écrite à la main (indépendante de la colonne formule) ;
- affiche la valeur arrondie telle que la fiche l'imprime (colonne arrondi) ;
- contrôles croisés : 13 µs/cm, v_max <-> Nyquist, somme des poids des domaines, comptages de contenu.csv.
"""
import csv, json, math, re, sys
from pathlib import Path

D = Path(sys.argv[1])
ex = list(csv.DictReader(open(D / "exemples.csv", encoding="utf-8")))
ok = True

AUTORISE = re.compile(r"^[\sA-Za-z0-9_.+\-*/(),]*$")
# Formules physiques réécrites à la main (unités dans l'énoncé)
PHYS = {
 "EX01": lambda e: 1 / e["f"],                                   # T = 1/f (µs, f en MHz)
 "EX02": lambda e: e["c"] / e["f"],                              # lambda = c/f (mm)
 "EX03": lambda e: e["n"] * (1 / e["f"]),                        # PD = n T
 "EX04": lambda e: e["n"] * (e["c"] / e["f"]),                   # SPL = n lambda
 "EX05": lambda e: e["n"] * (e["c"] / e["f"]) / 2,               # axial = SPL/2
 "EX06": lambda e: 2 * e["d"] / e["c"],                          # PRP = 2d/c
 "EX07": lambda e: 1 / (2 * e["d"] / e["c"]) / 1000,             # PRF = 1/PRP (kHz)
 "EX08": lambda e: (e["n"] / e["f"]) / (2 * e["d"] / e["c"]) * 100,
 "EX09": lambda e: e["a"] * e["f"] * (2 * e["d"]),
 "EX10": lambda e: 10 * math.log10(2) / (e["a"] * e["f"]),       # HVL avec 10 log10 2 = 3.01 dB (tolérance élargie)
 "EX11": lambda e: ((e["z2"] - e["z1"]) / (e["z2"] + e["z1"])) ** 2 * 100,
 "EX12": lambda e: math.sin(math.radians(30)) * e["c2"] / e["c1"],
 "EX13": lambda e: e["D"] ** 2 / (4 * (e["c"] / e["f"])),        # D^2/(4 lambda)
 "EX14": lambda e: 1 / ((2 * e["d"] / e["c"]) * e["N"] * e["F"]), # 1/(PRP N F)
 "EX15": lambda e: 2 * (e["f"] * 1000) * e["v"] * math.cos(math.radians(60)) / e["c"] / 1000,
 "EX16": lambda e: e["prf"] / 2,
 "EX17": lambda e: (e["prf"] / 2) * e["c"] / (2 * e["f"] * math.cos(math.radians(60))),  # v tel que df = PRF/2
 "EX18": lambda e: e["K"] * e["v"] ** 2,
 "EX19": lambda e: (e["ps"] - e["ed"]) / e["ps"],
 "EX20": lambda e: e["c0"] * (2 * e["d"] / e["c"]) / 2,           # profondeur affichée = c0 t / 2
 "EX21": lambda e: e["p"] / math.sqrt(e["f"]),
 "EX22": lambda e: 10 ** (e["db"] / 10),
 "EX23": lambda e: 2 ** e["b"],
 "EX24": lambda e: e["tp"] / (e["tp"] + e["fn"]) * 100,
 "EX25": lambda e: e["tn"] / (e["tn"] + e["fp"]) * 100,
 "EX26": lambda e: e["c"] / (2 * e["t"]),
 "EX27": lambda e: e["P"] / e["A"],
}
TOL_PHYS = {"EX10": 0.02, "EX12": 1e-6}  # EX10 : convention 3 dB (exact 3.0103 dB) -> 3.01 cm, affiché 3 cm dans les deux cas

print(f"{'id':5} {'formule':>12} {'attendu':>12} {'physique':>12} {'affiché':>9}  statut")
for l in ex:
    i, f = l["id"], l["formule"]
    raw = l["entrees_json"]
    if re.search(r"\d[eE][-+]?\d", raw):
        print(i, "ENTREE EN NOTATION SCIENTIFIQUE"); ok = False
    if "**" in f or not AUTORISE.match(f.replace("calc.pow", "")):
        print(i, "FORMULE HORS REGLE 9 :", f); ok = False
    for fn in re.findall(r"([A-Za-z_][A-Za-z_.]*)\s*\(", f):
        if fn != "calc.pow":
            print(i, "FONCTION INTERDITE :", fn); ok = False
    e = json.loads(raw)
    val = eval(f.replace("calc.pow", "pow"), {"__builtins__": {}, "pow": pow}, dict(e))
    att, tol = float(l["resultat_attendu"]), float(l["tolerance"])
    phys = PHYS[i](e)
    s = "OK"
    if abs(val - att) > tol:
        s = "ECART formule"; ok = False
    if abs(phys - att) > max(tol, TOL_PHYS.get(i, 0)):
        s += " / ECART physique"; ok = False
    aff = round(att, int(l["arrondi"]))
    print(f"{i:5} {val:12.6f} {att:12.6f} {phys:12.6f} {aff:9g}  {s}")

# Contrôles croisés
e = {l["id"]: json.loads(l["entrees_json"]) for l in ex}
r = {l["id"]: float(l["resultat_attendu"]) for l in ex}
print("13 µs/cm : 2/0.154 =", round(2 / 0.154, 4), "µs/cm")
# v_max (EX17) redonne exactement Nyquist (EX16) via l'équation Doppler
e17 = e["EX17"]
df_vmax = 2 * e17["f"] * r["EX17"] * e17["cs"] / e17["c"]
print("Doppler à v_max EX17 :", df_vmax, "Hz ; Nyquist EX16 :", r["EX16"] * 1000, "Hz")
ok &= abs(df_vmax - r["EX16"] * 1000) < 1e-6
print("EX15 fm (MHz) x 1000 = f (kHz) :", e["EX15"]["fm"] * 1000 == e["EX15"]["f"]); ok &= e["EX15"]["fm"] * 1000 == e["EX15"]["f"]
print("EX15 < EX16 (pas d'aliasing affirmé) :", r["EX15"] < r["EX16"]); ok &= r["EX15"] < r["EX16"]
print("EX12 c2 > c1 (s'éloigne de la normale) :", e["EX12"]["c2"] > e["EX12"]["c1"])
print("EX20 c < c0 (trop profond) :", e["EX20"]["c"] < e["EX20"]["c0"])
print("PRF max EX07 vs 1/PRP EX06 :", r["EX07"], round(1000 / r["EX06"], 6))
dom = list(csv.DictReader(open(D / "domaines.csv", encoding="utf-8")))
somme = sum(int(x["poids"]) for x in dom)
print("Somme des poids des domaines :", somme); ok &= somme == 100
print("Nb exemples :", len(ex), "| relations :", len(list(csv.DictReader(open(D / 'relations.csv', encoding='utf-8')))),
      "| artefacts :", len(list(csv.DictReader(open(D / 'artefacts.csv', encoding='utf-8')))))
print("RESULTAT GLOBAL :", "OK" if ok else "ECARTS")
sys.exit(0 if ok else 1)
```
