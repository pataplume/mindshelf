# EN04 — Rapport de vérification v1 (run R03)

Produit : EN04 « SPI Ultrasound Physics — Express Review Sheets », variante EN04-STD (EN-US, 2 pages A4/Letter, 5 pages tablette).
Vérificateur indépendant, 29.10.2026, 10:07–10:27 (environ 20 min). Fichiers jugés : `src/main.typ`, `donnees/*.csv` (sauf `extraits.csv`), les quatre PDF de `livraison/EN04-STD/`. Non jugés (conditionneur en cours) : `apercus/`, `video/`, `annonce/`, `donnees/extraits.csv`, `EN04-STD.apkg`.

## Verdict : **OK avec réserves**

- **Calculs** : les 27 exemples recalculés (formule de la donnée + formule physique réécrite à la main) : aucun écart. Contrôles croisés justes (13 µs/cm, v_max ↔ Nyquist, PRF max = 1/PRP, poids = 100 %).
- **Fond** : aucune erreur factuelle trouvée sur les points sensibles (1 540 m/s, 13 µs/cm, 0,5 dB/cm/MHz, SPTP > … > SATA, axiale = SPL/2, NZL = D²/4λ, équation Doppler, Nyquist = PRF/2, DF, IRC/ITC, Snell, tableau « If X doubles », 11 artefacts, Se/Sp/VPP/VPN, MI, limites FDA).
- **Réserves** : le sourçage n'est pas au niveau de la règle 12 (Kremkau sans localisation, FDA non consultée par le producteur). Il faut corriger `donnees/references.csv` et `donnees/sources.csv` **avant publication**. Le texte des PDF n'est pas en cause. Les mineurs peuvent passer dans un même lot de corrections.
- `scripts/controle_pdf.py EN04-STD` : tous les contrôles passent (4 formats : polices, métadonnées, pages, débordement, mentions, N&B sans couleur, tablette en paysage avec liens et signets).

Bilan : **0 BLOQUANT, 2 MAJEURS, 11 MINEURS.**

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `references.csv` (17 lignes `KREMKAU_11`), `valeurs.csv` (P_CTISSUE, P_CTISSUE_MMUS, P_ATT, P_13US, P_ULTRA, P_BERN_K), `sources.csv` | Presque tout le fond renvoie à Kremkau/Forsberg 11e, sans chapitre ni page (« A-VERIFIER : localisation »). `sources.csv` indique que le contenu du livre n'a pas été consulté. Cela enfreint la règle 12 (la localisation doit soutenir la valeur) et le point 3 de la fiche vérificateur (référence fragile). Les valeurs sont justes, mais rien dans les données ne le prouve. | Option A : relever chapitre et page dans le livre pour chaque ligne. Option B, préférable à court terme : ajouter des sources consultables qui écrivent les valeurs. Je cite ces pistes de mémoire, **je ne les ai pas consultées pendant ce run** : Hangiandreou NJ, *AAPM/RSNA physics tutorial for residents: B-mode US: basic concepts and new technology*, RadioGraphics 2003;23:1019-1033 (c, atténuation, résolutions, transducteurs) ; Boote EJ, *Doppler US techniques: concepts of blood flow detection and flow dynamics*, RadioGraphics 2003;23:1315-1327 (Doppler, Nyquist, aliasing) ; Feldman MK, Katyal S, Blackwood MS, *US artifacts*, RadioGraphics 2009;29:1179-1189 (artefacts) ; FDA 2023 et AIUM pour la sécurité. Le producteur doit les lire et relever la localisation de chaque valeur. Sinon, garder `A-VERIFIER`. |
| M2 | MAJEUR | `sources.csv` FDA_US_2023 ; `references.csv` ligne « Limites FDA » ; `valeurs.csv` L_ISPTA, L_MI | Source « non consultée », sans URL du document ni section. **Je l'ai consultée** : les valeurs de la fiche sont confirmées (voir A-VERIFIER 2). | `sources.csv` : URL `https://www.fda.gov/media/71100/download`, « Document issued on February 21, 2023 », consulté le 29.10.2026. `references.csv` : localisation « § 5.2.8 Track 3 recommendations, p. 28 ». Retirer `A-VERIFIER`. |
| m1 | MINEUR | PDF p. 2, Bioeffects & safety (`main.typ` l. 324) ; `valeurs.csv` | Le § 5.2.8 de la FDA dit : I_SPTA.3 ≤ 720 mW/cm² **et soit** MI ≤ 1,9 **soit** I_SPPA.3 ≤ 190 W/cm². La fiche présente MI ≤ 1,9 comme une limite unique. C'est la réponse attendue à l'examen, mais elle est incomplète par rapport à la source citée. | Ajouter `L_ISPPA` (190 W/cm², FDA_US_2023) et écrire : « derated I_SPTA ≤ 720 mW/cm² and MI ≤ 1.9 (or derated I_SPPA ≤ 190 W/cm²) ». |
| m2 | MINEUR | `contenu.csv` | Le CSV ne décrit pas exactement le PDF : la section « Instrumentation & processing » manque (chaîne de réception, gain/puissance, pré- et post-traitement, dynamique, niveaux de gris, harmonique, compounding). Le reste concorde : 11 artefacts, 8 lignes « If X doubles », 11 exemples encadrés, 27 résultats calculés, 12 pièges. | Ajouter une ligne : « Instrumentation: receiver functions, gain vs output power, pre/post-processing, dynamic range, harmonic imaging, spatial compounding ». |
| m3 | MINEUR | `main.typ` l. 192, 269, 312 | Trois affirmations qualitatives dépendent des données mais aucun `verifie()` ne les contrôle : « 1.62 kHz is below 2.5 kHz, so no aliasing », « bent away from the normal (c₂ > c₁) », « too deep: slower medium ». Elles sont vraies aujourd'hui, mais deviendraient fausses en silence si une entrée changeait. | Ajouter `verifie`/`panic` : EX15 < EX16 ; EX12.c2 > EX12.c1 ; EX20.c < EX20.c0. |
| m4 | MINEUR | PDF p. 1, exemple Doppler (EX15) | La fiche affiche « f₀ = 5,000 kHz ». Un.e étudiant.e attend « 5 MHz ». | Entrée `f` en MHz (5) et conversion dans la formule (`2 * f * 1000 * v * cs / c`), ou affichage d'une entrée dédiée en MHz. |
| m5 | MINEUR | PDF p. 2, exemple Speed error (`main.typ` l. 311) | « system assumes 1,540 » : l'unité manque. | « … assumes #v("EX20","c0") m/s ». |
| m6 | MINEUR | `valeurs.csv` P_13US / `references.csv` | P_13US est attribuée à `KREMKAU_11` dans `valeurs.csv`, et à `ANALYSE_MATH` dans `references.csv`. | Aligner sur une seule source (ANALYSE_MATH, recalculée à la compilation, ou une source localisée). |
| m7 | MINEUR | PDF p. 1, encadré « How these sheets map… » | La liste des exclusions (patient care, ergonomics, 3D/4D, contrast agents, infection control) est incomplète par rapport au plan : M-mode (3.P), panoramique (1.H), sondes 2D/3D et non imageantes (2.C-2.E), intégrité sonde/machine et documentation QA (5.B-5.D), cartes couleur (4.E) ne sont pas traités. La règle 14 reste respectée grâce à « not a complete course ». | Écrire « … are not covered, among others » ou compléter la liste. |
| m8 | MINEUR | PDF p. 1, Sound (`main.typ` l. 121) | « Amplitude, power, intensity: set by the system » est imprécis : ces grandeurs dépendent de la source et du réglage de puissance, puis diminuent pendant la propagation (atténuation). | « set by the source (output power); they decrease as sound travels ». |
| m9 | MINEUR | `artefacts.csv` ordre 4 ; `cartes.csv` « Shadowing vs enhancement » | La cause de l'ombre est « high attenuation: stone, bone, gas ». Pour le gaz, l'ombre vient surtout d'une réflexion forte. La colonne « aspect » le dit déjà (« attenuating or reflecting »). | « strong attenuation or reflection: stone, bone, gas ». |
| m10 | MINEUR | `cartes.csv` | Des nombres sont retapés à la main (0.31 mm, 30 dB, 36 mmHg, 1540 m/s, 13 µs) sans lien avec `exemples.csv`/`valeurs.csv` : ils peuvent diverger si les données changent. Ils concordent aujourd'hui. | Générer ces versos depuis les tables, ou les contrôler au build. |
| m11 | MINEUR | PDF A4 et Letter (forme) | Titres coupés : « Sound & acoustic para-meters » et « Instrumentation & pro-cessing » (A4). L'encadré ALARA est coupé entre deux colonnes (Letter). En A4 p. 2, la 3e colonne est presque vide et l'encadré des pièges est coupé entre les colonnes 2 et 3. Rien n'est tronqué, et la version N&B reste lisible. | Interdire la césure dans les titres (`hyphenate: false` sur les titres) et rendre les encadrés insécables s'ils sont courts. Optionnel. |

**Concordance PDF/données** : tous les nombres affichés que j'ai contrôlés (texte extrait et rendu des 4 formats) viennent des CSV via `v()`, `res()`, `q()` et `qu()`, et les arrondis respectent la colonne `arrondi` (130 µs, 7.7 kHz, 0.46 %, 0.39 %, 0.519, 29 mm, 60 Hz, 1.62 kHz, 0.77 m/s, 5.3 cm, ≈ 2). Rien de chiffré n'est en dur dans le Typst, à part des constantes de formule (2 de l'aller-retour, λ/4, D/2, cos 90° = 0, DF = 100 % en CW), ce qui est admis. Titre, marque et version arrivent par `sys.inputs`.

**Droits** : je n'ai repéré aucune phrase, aucun tableau ni aucune question qui ressemble à une reprise. Les formulations sont génériques et propres au résumé. LARRD et LATA sont des moyens mnémotechniques d'usage courant (courts, non protégeables). Limite : je n'ai pas pu confronter le texte à Kremkau, faute d'accès.

**Affiliation / couverture (règle 14)** : la mention MARQUE_SPI (« Not affiliated with or endorsed by ARDMS ») est présente sur chaque page des 4 formats. L'encadré dit « condensed review aid… not a complete course ». Le sous-titre et `contenu.csv` ne promettent pas de couvrir tout l'examen. Aucune affiliation n'est suggérée.

**Titre et contenu (note, sans jugement sur le prix de 9.99 USD)** : le titre « Express Review Sheets » colle au contenu : 2 pages A4/Letter très denses en 3 colonnes (5 pages tablette), soit un résumé et non un cours. Le pluriel « Sheets » correspond aux 2 pages. Le produit respecte `pages_max` = 4.

## Points A-VERIFIER

| # | Point | Ce que j'ai trouvé | Avis : bloque la publication ? |
|---|---|---|---|
| 1 | Plan SPI v24.1 (Inteleos, mai 2026) | Le PDF v24.1 a été lu via WebFetch (téléchargement direct par curl refusé par le proxy, 403). La version affichée est « Version: 24.1 ». Domaines et poids sont **inchangés** : Perform Ultrasound Examinations 23 %, Manage Ultrasound Transducers 7 %, Optimize Sonographic Images 26 %, Apply Doppler Concepts 34 %, Provide Clinical Safety & Quality Assurance 10 %. J'ai aussi vérifié le plan 2023-1 : la répartition « Sections here » est cohérente (sons, réflexion, artefacts et bioeffets en 1.C, 1.D, 1.F ; résolution, PRF et traitement en domaine 3 ; QA, sensibilité et spécificité en 5.E-5.F). | **Non**, une fois `sources.csv` et `references.csv` mis à jour pour citer la v24.1 (URL ci-dessus, consultée le 29.10.2026) et retirer l'A-VERIFIER. |
| 2 | Limites FDA (720 mW/cm², MI 1,9) | Guide « Marketing Clearance of Diagnostic Ultrasound Systems and Transducers », *document issued on February 21, 2023*, lu via WebFetch. **§ 5.2.8 « Track 3 recommendations », p. 28** : « the global maximum derated ISPTA should be ≤ 720 mW/cm², and either the global maximum MI should be ≤ 1.9 or the global maximum derated ISPPA should be ≤ 190 W/cm² ». Exception ophtalmique : TI ≤ 1, ISPTA.3 ≤ 50 mW/cm², MI ≤ 0,23. Les valeurs de la fiche sont exactes. | **Non** sur le fond. Mettre à jour les données (M2) avant publication. Le complément ISPPA (m1) est conseillé, mais non bloquant. |
| 3 | Localisations Kremkau (17 lignes) | Non consultable dans ce run. Ma confrontation se fonde sur les connaissances standard de physique de l'échographie, pas sur une source localisée. Elle n'a révélé aucune erreur. | **Oui, au sens de la règle 12** : publier avec des références « A-VERIFIER » pour l'essentiel du fond contredit la chaîne. Il faut soit localiser, soit ajouter des sources consultables (M1). Le risque d'erreur dans le contenu, lui, est faible. |
| 4 | Mention IA_REDACTION_ASSISTEE (« content checked and approved by the seller ») | La mention est imprimée sur chaque page. Elle ne devient vraie qu'après la relecture et la validation du vendeur (règle 15). | **Oui** tant que le vendeur n'a pas relu et validé la fiche. |

## Script de recalcul

Exécution : `python3 -I recalc_en04.py /home/claude/mindshelf/produits/EN04/donnees` → `RESULTAT GLOBAL : OK`. Les 27 lignes sont « OK » : formule de la donnée, formule physique indépendante et valeur affichée. Pour EX10, la formule physique utilise 10 × log10(2) = 3,0103 dB, ce qui donne 3,01 cm au lieu de 3 cm (convention « 3 dB »). L'affichage reste 3 cm, donc ce n'est pas un écart.

```python
#!/usr/bin/env python3
"""Recalcul indépendant des exemples EN04 (vérificateur R03).
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

Sortie (extrait) :

```
EX06    129.870130   129.870130   129.870130       130  OK
EX08      0.462000     0.462000     0.462000      0.46  OK
EX11      0.390625     0.390625     0.390625      0.39  OK
EX15      1.623377     1.623377     1.623377      1.62  OK
EX17      0.770000     0.770000     0.770000      0.77  OK
EX20      5.310345     5.310345     5.310345       5.3  OK
13 µs/cm : 2/0.154 = 12.987 µs/cm
Doppler à v_max EX17 : 2500.0 Hz ; Nyquist EX16 : 2500.0 Hz
Somme des poids des domaines : 100
Nb exemples : 27 | relations : 8 | artefacts : 11
RESULTAT GLOBAL : OK
```
