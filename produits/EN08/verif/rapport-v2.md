# EN08-STD « Lab Values Cheat Sheet » : rapport de vérification v2

Run R03, contre-vérification indépendante (je n'ai participé ni à la production ni à la correction), 29.10.2026. Périmètre : les constats de `verif/rapport-v1.md` et ce qui a changé depuis. Ce n'est pas une seconde vérification complète. Objets : `src/main.typ`, `donnees/*`, `annonce/whop.md`, `annonce/etsy/annonce.md`, `livraison/EN08-STD/*.pdf` (fabriqués à 10:28).

## Verdict : **OK avec réserves**

Les 2 BLOQUANTS, les 7 MAJEURS et 10 des 11 MINEURS de la v1 sont levés ; m6 l'est en partie. Je n'ai trouvé aucune régression. Il reste 0 BLOQUANT et 0 MAJEUR, plus 2 MINEURS nouveaux.

- **Calculs :** les 21 lignes de `exemples.csv`, les 18 facteurs, les 9 masses molaires et les 74 bornes converties ont été recalculés sans écart. Les 5 bornes du m1 v1 sont désormais égales au calcul exact.
- **Sources cliniques :** j'ai relu moi-même les pages MedlinePlus 003484, 001179 et 003486 ; chaque citation de `references.csv` y figure mot pour mot (détail plus bas). La 003477 avait été lue en v1.
- **Build de contrôle :** `scripts/build.py EN08-STD` lancé dans une copie du dépôt. `controle_pdf.py` passe sur les 4 formats et le texte des 4 PDF rebâtis est identique à celui des PDF livrés.
- **Recherche du motif `#f(...);` (règle 16) :** aucune occurrence.
- **La publication reste bloquée, comme prévu :** la relecture médicale n'a pas eu lieu (`statut-methode.md`). Cette réserve ne vient pas de moi. Le pied de page affiche encore « v1 » (n1).

## Constats v1 : levé / non levé

| # v1 | Constat (résumé) | État | Preuve (données, Typst, PDF A4) |
|---|---|---|---|
| B1 | INR sous warfarine présenté comme une plage fixe | **Levé** | Ligne « INR on warfarin, common » déplacée dans le groupe `DRUG` « Drug therapy (target set by the prescriber) » (`groupes.csv`, `examens.csv` l. 40). Note : « the prescriber sets the INR target, which depends on the indication; 2.0–3.0 is common. Above 3.0: higher bleeding risk; below 2.0: clot risk. » Seuils lus dans `valeurs.csv` (`inr_caillot`, `inr_saignement`). `main.typ` l. 113-114 fait échouer la compilation s'ils divergent de la ligne du tableau. La carte Anki suit la même formulation. Source : MEDLINEPLUS_PT (« Depending on why you are taking the blood thinner… », « Ask your provider… »). En tablette, l'en-tête du groupe est sur la même page que la ligne. |
| B2 | Hémolyse avant le signalement du K⁺ élevé | **Levé** | Piège « High K⁺ and hemolysis » : « Report a high K⁺ per protocol. Hemolysis (red-cell injury in the sample) can release potassium and falsely raise K⁺; a redraw may be requested. » Le signalement vient en premier. La partie hémolyse est sourcée (MedlinePlus 003484, relu : « injury to the red blood cells may cause potassium to be released. This may cause a falsely high result. »). « Per protocol » et « a redraw may be requested » restent `A_VERIFIER`, pour la relectrice (voir n2). |
| M1 | Note « Potassium and the heart » sans source | **Levé** | 003484 relu : « High levels cause decreased heart muscle activity. Either situation can lead to life-threatening heart problems. » 001179 relu (review 10/1/2025) : « Slow, weak, or irregular pulse », « Palpitations… », « changes in your ECG ». « ECG monitoring per protocol » a été retiré. |
| M2 | Piège calcium total / ionisé sans source | **Levé** | 003486 relu (review 5/19/2025) : « You may need to have a separate ionized calcium test if you have factors that increase or decrease total calcium levels. These may include abnormal blood levels of albumin… ». « May be normal » a été retiré. |
| M3 | HbA1c : équation non relue dans sa source | **Levé** | La fiche affiche « mmol/mol = (% − 2.152) ÷ 0.09148 (NGSP) », lu dans `valeurs.csv`. Facteur 10.9314 = arrondi de 1 ÷ 0.09148, avec un contrôle de concordance à la compilation. 20 et 38 mmol/mol recalculés. |
| M4 | mEq, U = 1 µmol/min et triglycérides sans document source | **Levé avec réserve** | La fiche présente désormais ces trois points comme des calculs ou des définitions (« Other factors calculated: IUPAC atomic weights, unit definitions, triglycerides as triolein »). Le facteur TG vaut 0.01129, calculé depuis la trioléine. Il reste deux `A-VERIFIER` (définitions sans ouvrage ; table IUPAC non relue), non bloquants. |
| M5 | Ligne digoxine lue comme un intervalle de normalité | **Levé** | La ligne est dans le groupe « target set by the prescriber ». Note : « the right level may vary with the situation. Follow the prescriber's target. » Le mot « indication » a été retiré. |
| M6 | Sens des seuils HDL | **Levé** | « HDL, female: low if < 50 mg/dL », « HDL, male: low if < 40 ». |
| M7 | `contenu.csv` et annonces confondent intervalles, seuils et cibles | **Levé** | `contenu.csv` l. 1 : « Adult reference intervals, lipid decision limits and drug therapy targets (INR on warfarin, digoxin) ». Les annonces Whop et Etsy séparent les intervalles (ABIM), les seuils lipidiques et les cibles fixées par le.la prescripteur.rice ; Etsy écrit « usual INR target on warfarin, general digoxin range » et « no critical values ». Les comptes concordent avec le PDF : 40 lignes en 9 groupes, 6 pièges (4 d'unités), 3 notes, 3 exemples, 20 cartes. |
| m1 | 5 bornes SI différentes du calcul exact | **Levé** | Facteurs à 0.24951, 0.02586 et 0.01129 ; bornes à 2.55, 5.17, 1.29, 1.03 et 1.69. La compilation contrôle désormais les deux facteurs (affiché et exact). |
| m2 | Qualificatif des triglycérides | **Levé** | « Triglycerides, normal ». |
| m3 | Tablette : en-tête de groupe perdu ; avertissement en p. 1 seulement | **Levé** | En tablette p. 2, « Lipids (decision limits) » et « Drug therapy… » sont présents (`table.header(level: 2)`). « Ranges vary by lab » figure sous le tableau. |
| m4 | Titre « Unit traps » | **Levé** | « Traps ». |
| m5 | Ligne des sources incomplète | **Levé** | « Sources: ABIM… ; MedlinePlus; NGSP (HbA1c). Other factors calculated… ». |
| m6 | Nombres des cartes tapés à la main | **Partiellement levé** | Les facteurs, les seuils INR et les paramètres NGSP passent par des marqueurs `{x:…}` / `{v:…}`. Les intervalles restent tapés : j'ai comparé chaque nombre des 20 versos aux tables, ils concordent tous. Non bloquant. |
| m7 | « 1.1 » au lieu de « 1.10 » | **Levé** | « Ionized Ca 1.10 mmol/L ÷ 0.24951 ≈ 4.4086 ⇒ 4.41 mg/dL ». |
| m8 | Nombres en dur, `valence_mg` inutilisée | **Levé** | « 10 ÷ » vient de `F_GLU.K`, « 2 N » de `F_BUN.A`, Mg²⁺ de `valence_mg` ; « Three conversions » a été retiré. |
| m9 | `statut-methode.md` | **Levé** | Codes `RELECTURE_METIER` / `A_VALIDER` / `A_CORRIGER` nommés ; la relectrice annote le PDF et l'orchestrateur reporte (table des champs) ; rien n'est déclaré « vérifié » à tort (règle 15). |
| m10 | Pages ABIM | **Levé** | Reportées dans `references.csv`. |
| m11 | Consignes « per protocol » sans source | **Non levé (transmis)** | Marquées `A_VERIFIER`, à trancher par la relectrice. C'est voulu, et cohérent avec la mention « Does not replace your facility's protocols… ». |

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| n1 | MINEUR | Pied de page des 4 PDF (« MindShelf · v1 ») ; `data/variantes.csv` | Les PDF au contenu v2 affichent « v1 ». `statut-methode.md` le signale et en confie la correction à l'orchestrateur, mais la relectrice risque de recevoir un PDF « v1 » qui n'est pas celui de la v1. | Passer la version à v2 dans `data/variantes.csv` et refabriquer avant l'envoi. La ligne de `data/revues.csv` doit citer la version effectivement relue. |
| n2 | MINEUR (pour la relectrice) | `main.typ` l. 204-206, piège « High K⁺ and hemolysis » | L'ordre est bon, mais rien ne dit que la demande d'un nouveau prélèvement ne retarde pas le signalement. Formulation suggérée en v1 : « a hemolysis flag or a redraw does not delay the report ». | Soumettre à la relectrice dans le même point que m11 : « …; a redraw may be requested, without delaying the report ». Pas de changement sans son avis. |

## A-VERIFIER restants : avis

| Point (`statut-methode.md`) | Avis du vérificateur | Bloque la publication ? |
|---|---|---|
| 1. Intervalles ABIM | Concordance confirmée en v1 ; inchangés (script, bloc 7). | Non |
| 2. Digoxine | Corrigé (M5). | Non |
| 3. HbA1c | Équation NGSP, 20–38 recalculé. | Non |
| 4. TG × 0.01129 | Calcul juste et présenté comme tel. | Non |
| 5. µkat/L | Choix éditorial. | Non |
| 6. SaO₂ ≥ 95 % | Conforme ABIM (v1). | Non |
| 7. Masses atomiques | Les valeurs indépendantes redonnent les 9 masses ; table IUPAC non relue. | Non |
| 8. Ca total / ionisé | Sourcé, citations vérifiées par moi (003477, 003486). | Non |
| 9. Hémolyse | Fait sourcé ; « redraw » et « per protocol » à valider (n2). | Non pour le vérificateur ; la relectrice tranche |
| 10. K⁺ et rythme | Sourcé, citations vérifiées par moi (003484, 001179). | Non |
| 11. « Per protocol » | Voir m11. | Non |
| 12. Libellés | Clairs. | Non |
| 13. ABIM ou intervalles enseignés en soins infirmiers | Question ouverte, inchangée, non sourcée. | Non |
| Relecture médicale (`RELECTURE_METIER`) | Pas encore faite. Elle conditionne la mention « content checked and approved by the seller ». | **Oui**, par construction |

## Sources relues par le vérificateur v2 (29.10.2026)

| Source | Ce que j'y ai lu |
|---|---|
| MedlinePlus 003484 « Potassium test », review 5/19/2025 | Les phrases citées sur l'hémolyse, le K⁺ bas et le K⁺ haut (« decreased heart muscle activity ») et « life-threatening » |
| MedlinePlus 003486 « Calcium - ionized », review 5/19/2025 | La phrase sur le dosage séparé si l'albumine est anormale ; intervalle 1.20–1.40 mmol/L, différent de celui de l'ABIM, comme le note `statut-methode.md` |
| MedlinePlus 001179 « High potassium level », review 10/1/2025 | Pouls lent, faible ou irrégulier ; palpitations ; « changes in your ECG » |

## Script de recalcul

Repris du rapport v1. Les libellés ont été mis à jour (« HDL, female: low if », « Triglycerides, normal », « INR on warfarin, common ») et la ligne HbA1c compare désormais (% − 2.152) × 10.9314 à l'équation maîtresse.

Exécution : `python3 -I recalc_en08.py produits/EN08/donnees`.
- 21 exemples, 18 facteurs et 9 masses molaires : OK.
- 74 bornes : affichage = facteur affiché = facteur exact.
- 40 intervalles : conformes aux sources.
- `Écarts : 0`.

```python
"""Recalcul indépendant EN08 v2 (vérificateur R03, repris de rapport-v1). Usage : python3 -I recalc_en08.py <dossier produits/EN08/donnees>"""
import csv, json, re, sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

D = Path(sys.argv[1])
lire = lambda f: list(csv.DictReader(open(D / f, encoding="utf-8")))
ecarts = []

def arr(x, n):  # arrondi au demi supérieur ; x float (repr) ou Decimal (calcul exact en décimal)
    x = x if isinstance(x, Decimal) else Decimal(repr(x))
    return x.quantize(Decimal(1).scaleb(-n), rounding=ROUND_HALF_UP)

# 1. Masses molaires depuis la table abrégée IUPAC/CIAAW 2021 (valeurs saisies ici indépendamment)
AW = {"H": 1.0080, "C": 12.011, "N": 14.007, "O": 15.999, "Mg": 24.305, "P": 30.974, "Ca": 40.078}
def masse(formule):
    return sum(AW[e] * (int(n) if n else 1) for e, n in re.findall(r"([A-Z][a-z]?)(\d*)", formule))
FORMULES = {"F_GLU": "C6H12O6", "F_CREA": "C4H7N3O", "F_BILI": "C33H36N4O6", "F_CHOL": "C27H46O",
            "F_TG": "C57H104O6", "F_DIG": "C41H64O14", "F_CA": "Ca", "F_MG": "Mg", "F_P": "P"}

# 2. exemples.csv : formule ré-évaluée, résultat attendu, masse molaire
ex = {}
for l in lire("exemples.csv"):
    e = json.loads(l["entrees_json"])
    f = l["formule"].replace("calc.pow", "pow")
    assert re.fullmatch(r"[A-Za-z0-9_ .+\-*/(),]+", f), f
    x = eval(f, {"__builtins__": {}, "pow": pow}, e)
    ok = abs(x - float(l["resultat_attendu"])) <= float(l["tolerance"])
    ex[l["id"]] = (x, int(l["arrondi"]))
    m = ""
    if l["id"] in FORMULES:
        mm = masse(FORMULES[l["id"]])
        m = f"  M recalculée {mm:.3f} (CSV {e['M']})" + ("" if abs(mm - e["M"]) < 0.0015 else "  <-- ÉCART")
        if abs(mm - e["M"]) >= 0.0015: ecarts.append(l["id"] + " masse")
    if l["id"] == "F_BUN":
        m = f"  10/(2*14.007) = {10/(2*AW['N']):.6f}"
    print(f"{'OK ' if ok else 'ÉCART'} {l['id']:8} {f:14} = {x:.9f} (attendu {l['resultat_attendu']}){m}")
    if not ok: ecarts.append(l["id"])

# 3. facteurs.csv : facteur affiché = arrondi de la dérivation
fac = {}
for l in lire("facteurs.csv"):
    x, n = ex[l["exemple_id"]]
    ok = arr(x, n) == Decimal(l["facteur"]).quantize(Decimal(1).scaleb(-n))
    fac[l["code"]] = (Decimal(l["facteur"]), Decimal(l["decalage"]), x)
    print(f"{'OK ' if ok else 'ÉCART'} facteur {l['code']:6} affiché {l['facteur']:>8}  dérivation {x:.6f} -> {arr(x, n)}")
    if not ok: ecarts.append("facteur " + l["code"])

# 4. examens.csv : autre unité recalculée (a) avec le facteur arrondi affiché, (b) avec le facteur exact
print("\nExamen | borne | affiché | (a) facteur affiché | (b) facteur exact")
for l in lire("examens.csv"):
    f, z, fx = fac[l["facteur_code"]]
    for b in ("bas", "haut"):
        us, si = l[b + "_us"], l[b + "_si"]
        if not us:
            continue
        if l["unite_source"] == "US":
            n = int(l["decimales_si"]); aff = Decimal(si)
            a = arr((Decimal(us) - z) * f, n); bx = arr((float(us) - float(z)) * fx, n)
        else:
            n = int(l["decimales_us"]); aff = Decimal(us)
            a = arr(Decimal(si) / f + z, n); bx = arr(float(si) / fx + float(z), n)
        drap = "" if aff == a == bx else ("  <-- diffère du calcul exact" if aff == a else "  <-- ÉCART AFFICHAGE")
        if drap: ecarts.append(f"{l['examen']} {b}: {drap.strip()}")
        print(f"{l['examen'][:30]:30} | {b:4} | {aff} | {a} | {bx}{drap}")

# 5. HbA1c : équation affichée vs équation maîtresse NGSP (NGSP = 0.09148 × IFCC + 2.152)
for p in (4.0, 5.6, 5.7, 6.5):
    print(f"HbA1c {p} % : (p-2.152)*10.9314 = {(p-2.152)*10.9314:.3f} ; (p-2.152)/0.09148 = {(p-2.152)/0.09148:.3f}")

# 6. Exemples affichés : arrondi
for i in ("CV1", "CV2", "CV3"):
    x, n = ex[i]; print(f"{i}: {x:.6f} -> {arr(x, n)}")
print("Contrôle CV1 avec facteur exact :", 180 / masse("C6H12O6") * 10, " CV3 exact :", 1.10 * masse("Ca") / 10)

# 7. Bornes US confrontées au texte de l'ABIM (janvier 2026), relevé du vérificateur (lecture web du PDF, pages)
ABIM = {"Sodium (Na⁺)": ("136", "145"), "Potassium (K⁺)": ("3.5", "5.0"), "Chloride (Cl⁻)": ("98", "106"),
        "Bicarbonate (HCO₃⁻), serum": ("23", "28"), "Total CO₂, serum": ("23", "30"),
        "Calcium, total": ("8.6", "10.2"), "Magnesium": ("1.6", "2.6"), "Phosphorus (as P)": ("3.0", "4.5"),
        "Glucose, fasting plasma": ("70", "99"), "Hemoglobin A1c": ("4.0", "5.6"),
        "BUN (urea nitrogen) → urea": ("8", "20"), "Creatinine, female": ("0.50", "1.10"),
        "Creatinine, male": ("0.70", "1.30"), "Hemoglobin, female": ("12", "16"), "Hemoglobin, male": ("14", "18"),
        "Hematocrit, female": ("37", "47"), "Hematocrit, male": ("42", "50"), "WBC (leukocytes)": ("4000", "11000"),
        "Platelets": ("150000", "450000"), "PT (prothrombin time)": ("11", "13"), "aPTT": ("25", "35"),
        "pH": ("7.38", "7.44"), "PaCO₂": ("38", "42"), "PaO₂": ("75", "100"), "HCO₃⁻": ("23", "26"),
        "SaO₂": ("95", ""), "Albumin": ("3.5", "5.5"), "Total protein": ("5.5", "9.0"),
        "Bilirubin, total": ("0.3", "1.0"), "ALT and AST (each)": ("10", "40"),
        "Alkaline phosphatase": ("30", "120"), "Total cholesterol, desirable": ("", "200"),
        "LDL cholesterol, optimal": ("", "100"), "HDL, female: low if": ("", "50"), "HDL, male: low if": ("", "40"),
        "Triglycerides, normal": ("", "150"),
        # SI à la source : Ca ionisé 1.16–1.31 mmol/L ; MedlinePlus : INR 0.8–1.1, cible 2.0–3.0, digoxine 0.5–1.9
        "INR, no anticoagulant": ("0.8", "1.1"), "INR on warfarin, common": ("2.0", "3.0"),
        "Digoxin, general range": ("0.5", "1.9")}
print()
for l in lire("examens.csv"):
    if l["examen"] == "Calcium, ionized":
        ok = (l["bas_si"], l["haut_si"]) == ("1.16", "1.31")
    else:
        ok = (l["bas_us"], l["haut_us"]) == ABIM.get(l["examen"], (None, None))
    print(f"{'OK ' if ok else 'ÉCART'} source {l['examen']}")
    if not ok: ecarts.append("source " + l["examen"])

print("\nÉcarts :", len(ecarts)); [print(" -", e) for e in ecarts]
```

Extrait de la sortie :

```
OK  F_HBA1C  K / S          = 10.931351115 (attendu 10.931351115)
OK  CV3      S / F          = 4.408640936 (attendu 4.408640936)
OK  facteur CA     affiché  0.24951  dérivation 0.249513 -> 0.24951
OK  facteur CHOL   affiché  0.02586  dérivation 0.025862 -> 0.02586
OK  facteur TG     affiché  0.01129  dérivation 0.011294 -> 0.01129
OK  facteur HBA1C  affiché  10.9314  dérivation 10.931351 -> 10.9314
Calcium, total                 | bas  | 2.15 | 2.15 | 2.15
Calcium, total                 | haut | 2.55 | 2.55 | 2.55
Total cholesterol, desirable   | haut | 5.17 | 5.17 | 5.17
HDL, female: low if            | haut | 1.29 | 1.29 | 1.29
HDL, male: low if              | haut | 1.03 | 1.03 | 1.03
Triglycerides, normal          | haut | 1.69 | 1.69 | 1.69
HbA1c 4.0 % : (p-2.152)*10.9314 = 20.201 ; (p-2.152)/0.09148 = 20.201
HbA1c 5.6 % : (p-2.152)*10.9314 = 37.691 ; (p-2.152)/0.09148 = 37.691
CV1: 9.990000 -> 10.0
CV2: 132.600000 -> 133
CV3: 4.408641 -> 4.41
Écarts : 0
```
