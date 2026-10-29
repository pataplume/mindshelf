# EN08-STD « Lab Values Cheat Sheet » : rapport de vérification v1

Run R03, vérificateur indépendant, 29.10.2026. Objet : `src/main.typ`, `donnees/*` (hors `extraits.csv`), `livraison/EN08-STD/EN08-STD-{a4,letter,nb,tablette}.pdf` (v1). Fichiers du conditionneur non jugés.

## Verdict : **À corriger**

2 BLOQUANTS, 7 MAJEURS, 11 MINEURS.

Ce qui est juste :
- **Calculs.** Toutes les lignes de `exemples.csv` (18 dérivations de facteurs et 3 conversions), les 9 masses molaires et les 18 facteurs affichés ont été recalculés sans écart (script en fin de rapport).
- **Conversions SI.** Les 79 bornes converties sont exactes avec le facteur affiché. Cinq d'entre elles diffèrent du calcul exact au dernier chiffre (voir m1).
- **Intervalles.** Les 40 intervalles concordent avec leurs sources : ABIM janvier 2026 (lu par moi via un outil de lecture web du PDF, avec les pages, voir A-VERIFIER 1) et MedlinePlus 003652 et 003568 (lus).
- **Contrôles techniques.** `scripts/controle_pdf.py EN08-STD` passe sur les quatre formats. Le N&B est lisible et rien n'est coupé.
- **Statut et publication.** `statut-methode.md` respecte la règle 15 et bloque bien la publication.

Ce qui bloque : deux repères cliniques peuvent faire mal interpréter un résultat.
- **INR.** La cible est affichée comme fixe, alors que la source dit qu'elle dépend de l'indication.
- **Hémolyse.** La formulation peut faire différer le signalement d'une vraie hyperkaliémie.

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| B1 | BLOQUANT | `examens.csv` l. 23 « INR target on warfarin » (tableau, groupe Coagulation) ; `main.typ` l. 199-201 (note « INR and bleeding ») ; `cartes.csv` carte « INR target on warfarin… » | Le tableau donne « INR target on warfarin 2.0–3.0 » comme une plage fixe, sans qualificatif. La note dit seulement « the usual INR target ». Or MedlinePlus 003652 (section « What Abnormal Results Mean ») écrit que la cible voulue peut être différente selon la raison du traitement, et ajoute « Ask your provider what result is right for you ». Un INR à 3.2 chez un.e patient.e dont la plage prescrite est plus haute serait lu « au-dessus de la cible ». L'inverse est aussi possible. C'est une erreur d'interprétation qui peut conduire à une décision de dose (règle 4). En tablette, la ligne (p. 1) et la note (p. 2) sont sur deux pages. | Libellé de ligne : « INR target on warfarin, usual (set per patient) ». Note : « The usual target is 2.0–3.0, but it depends on the indication: compare with the range ordered for this patient. Above 3.0: higher bleeding risk; below 2.0: higher clot risk. » Ces deux phrases sont dans MEDLINEPLUS_PT, à ajouter à la ligne de `references.csv`. Même correction sur la carte Anki. Seuil 2.0 éventuel : une clé `inr_caillot` dans `valeurs.csv`. |
| B2 | BLOQUANT | `main.typ` l. 189-191 (piège « Hemolyzed sample ») ; `references.csv` (source `A_VERIFIER`) | (1) Le piège n'a aucune source. (2) Il dit : « Unexpected high K⁺: ask whether the sample was hemolyzed and a redraw is needed. » Lu seul, il fait de la remise en cause de l'échantillon la première réaction face à un K⁺ élevé. Cela peut retarder le signalement d'une vraie hyperkaliémie, et contredit l'ordre d'action de la note « Potassium and the heart » (« report promptly »). Formulation ambiguë sur un risque vital (règle 4). | « A hemolyzed sample can give a falsely high K⁺. A high K⁺ is still reported promptly per protocol; a hemolysis flag or a redraw does not delay the report. » Source candidate (lue) : MedlinePlus Medical Encyclopedia, « Potassium test », article 003484, review date 5/19/2025 : « injury to the red blood cells may cause potassium to be released. This may cause a falsely high result. » La partie « still reported promptly » est une consigne de pratique : à valider par la relectrice ou à couvrir par AVERT_CLINIQUE. |
| M1 | MAJEUR | `main.typ` l. 203-205 (note « Potassium and the heart ») ; `references.csv` (`A_VERIFIER`) | Note clinique sans référence (règle 4). | Source candidate (lue) : MedlinePlus 003484, qui couvre l'hypokaliémie : « Low levels of potassium can lead to an irregular heartbeat or other electrical malfunction of the heart ». Le versant hyperkaliémie demande une seconde source (par exemple MedlinePlus « High potassium level », 001179, **non lue**). « ECG monitoring per protocol » : consigne générique, à valider par la relectrice. |
| M2 | MAJEUR | `main.typ` l. 185-187 (piège « Total vs ionized calcium ») ; `references.csv` (`A_VERIFIER`) | Repère d'interprétation sans référence. | Source partielle (lue) : MedlinePlus « Calcium blood test », 003477, review date 11/6/2025 : « About one half of the calcium in the blood is attached to proteins, mainly albumin ». La page cite aussi l'albumine basse comme cause de calcium bas. Elle **n'écrit pas** que le Ca ionisé peut rester normal : il faut une seconde source (par exemple MedlinePlus « Calcium - ionized », 003486, non lue). À défaut, retirer « may be normal ». |
| M3 | MAJEUR | `facteurs.csv` HBA1C, `exemples.csv` F_HBA1C, `main.typ` l. 162 ; `references.csv` HANAS_2010 (« source non consultée ») | Référence fragile : l'équation n'a pas été relue dans sa source. La page NGSP (https://www.ngsp.org/ifcc.asp, lue) donne l'équation maîtresse **NGSP = 0.09148 × IFCC + 2.152**. La fiche affiche (% − 2.15) × 10.929, une forme arrondie (1 ÷ 0.09148 = 10.931). Les résultats sont identiques : 4.0 % donne 20.2 (20) et 5.6 % donne 37.7 (38). Les valeurs affichées sont donc justes. | Citer la page NGSP. Soit afficher IFCC = (% − 2.152) ÷ 0.09148, soit garder la forme arrondie avec une source qui l'écrit telle quelle. Mettre à jour `exemples.csv` et `facteurs.csv` en conséquence. |
| M4 | MAJEUR | `references.csv` : DEFINITION_EQUIVALENT (mEq/mmol), unité enzymatique U = 1 µmol/min (NC-IUB 1979 « non consultée »), triglycérides « convention » trioléine | Trois règles affichées sans document source identifié (règle 12 : une définition générique n'est pas une source). Les valeurs sont justes : 1/60 = 0.01667, Ca²⁺ et Mg²⁺ valent 2 mEq par mmol, et 0.0113 est le facteur conventionnel usuel des triglycérides. | Citer un document identifié pour chacune : un manuel de chimie clinique avec auteur.e.s, édition, page ; la recommandation IUB pour l'unité enzymatique ; un tableau de conversion SI publié qui écrit 0.0113 pour les triglycérides. |
| M5 | MAJEUR | `examens.csv` l. 40 « Digoxin, general range » (tableau) | MedlinePlus 003568 dit « In general… 0.5 to 1.9 ng/mL. But the right level for some people may vary depending on the situation ». La note de la fiche reprend bien ce qualificatif. La ligne du tableau, elle, n'y renvoie pas, alors que le tableau est intitulé « Adult reference intervals ». Lue seule, elle passe pour un intervalle de normalité. « Indication » (note, l. 208) ne figure pas dans la source (« situation »). Je ne la classe pas BLOQUANT car le qualificatif sourcé existe sur la même page. | Libellé : « Digoxin, general range (target set by prescriber) » ou un renvoi vers « Nursing cues ». Dans la note : « depends on the patient's situation ». |
| M6 | MAJEUR | `examens.csv` l. 37-38 « HDL, low (female/male) » | Dans le groupe « Lipids (decision limits) », toutes les lignes s'écrivent « < X ». Pour quatre d'entre elles, une valeur en dessous est favorable ; pour le HDL, elle est défavorable. « HDL, low (female) < 50 » peut se lire « le HDL doit être < 50 ». En tablette, p. 2, ces lignes perdent en plus l'en-tête « decision limits » (m3). | « HDL: low if < 50 mg/dL (female) » (ABIM p. 4 : « Low Female: <50 mg/dL; male: <40 mg/dL »). Le champ `examen` porte le libellé ; ajouter si besoin une colonne `sens` (valeur favorable au-dessus ou en dessous) plutôt que du texte. |
| M7 | MAJEUR | `donnees/contenu.csv` (source de l'annonce) | Le fichier ne décrit pas exactement le PDF : (1) l. 1 : « Adult reference intervals », alors que le tableau contient aussi des seuils de décision (lipides), une cible thérapeutique (INR sous warfarine) et un taux de médicament (digoxine) ; une annonce qui présente une cible thérapeutique comme un intervalle de référence reproduit B1. (2) l. 5 : « 6 unit traps », or hémolyse et Ca/albumine ne sont pas des pièges d'unité. (3) l. 3 : « calculated from molar mass or unit definitions » ne couvre ni l'équation HbA1c (empirique) ni la convention des triglycérides. (4) « common tests » est une promesse de couverture vague (règle 14). | (1) « Adult reference intervals, lipid decision limits, the usual INR target on warfarin and a general digoxin range ». (2) « 6 traps (units, sample, calcium) ». (3) « …from molar mass, unit definitions or the IFCC–NGSP equation ». (4) Retirer « common » ou lister les groupes. |
| m1 | MINEUR | `examens.csv` : Ca total haut, cholestérol total, HDL F, HDL H, triglycérides | Le facteur arrondi à 3 chiffres significatifs, puis réutilisé, donne 5 bornes SI différentes du calcul exact au 2e décimal : 2.54 (exact 2.545 → 2.55), 5.18 (5.17), 1.30 (1.29), 1.04 (1.03), 1.70 (1.69). HDL F (1.295) et TG (1.695) tombent pile sur le demi. L'écart est sans effet de classement à la résolution des comptes rendus (vérifié au cas par cas). La règle est écrite et cohérente avec « SI = US × factor ». | Afficher les facteurs à 4 chiffres significatifs (0.02586, 0.01129, 0.24951), ou garder 0.0259 et 0.0113 en citant le tableau conventionnel qui les donne (M4). |
| m2 | MINEUR | `examens.csv` l. 39 « Triglycerides, fasting » | Qualificatif absent. L'ABIM (p. 10) écrit « Normal <150 » et « Optimal <100 ». | « Triglycerides, fasting, normal ». |
| m3 | MINEUR | PDF tablette p. 2 | L'en-tête « Lipids (decision limits) » reste en p. 1 ; LDL, HDL et TG continuent en p. 2 sans lui. L'avertissement « Reference intervals vary between laboratories » n'est qu'en p. 1. Dans les autres formats, il est en tête, pleine largeur, lisible : je le juge assez visible. | Répéter l'en-tête de groupe à la coupure, ou empêcher la coupure d'un groupe. Ajouter « Ranges vary by lab » à la note sous le tableau (l. 153). |
| m4 | MINEUR | `main.typ` l. 171 « Unit traps » | Ca/albumine et hémolyse ne sont pas des pièges d'unité. | Titre « Traps », ou déplacer l'hémolyse dans « Nursing cues ». |
| m5 | MINEUR | `main.typ` l. 211 (ligne Sources) | « Factors calculated from IUPAC atomic weights and SI definitions » : l'équation HbA1c (NGSP/IFCC) et la convention des triglycérides n'y entrent pas. Les sources ajoutées pour B2, M1 et M2 seront à nommer. | Compléter la ligne. |
| m6 | MINEUR | `donnees/cartes.csv` | Les nombres des cartes sont tapés à la main, en double de `examens.csv`, `facteurs.csv` et `valeurs.csv`, avec un risque de dérive. Je les ai tous comparés : ils concordent aujourd'hui. B1 doit y être reporté. | Générer les versos depuis les tables, ou au moins ajouter un contrôle de concordance. |
| m7 | MINEUR | PDF, exemple 3 | « Ionized Ca 1.1 mmol/L » : la donnée est 1.10 et le Ca ionisé se rend à 2 décimales. `nombre()` supprime le zéro final. | Afficher 1.10 : décimales à porter dans `exemples.csv` ou passées à `v()`. |
| m8 | MINEUR | `main.typ` l. 159, 165, 178, 182 | Nombres tapés dans le Typst : « 10 ÷ molar mass » (K de `exemples.csv`), « Three conversions », « Urea has 2 N atoms » (A de F_BUN). Mg²⁺ s'affiche avec la clé `valence_ca` ; `valence_mg` n'est pas utilisée. Toutes les valeurs sont justes. | Les lire depuis les tables, et utiliser `val("valence_mg")` pour le Mg. |
| m9 | MINEUR | `donnees/statut-methode.md` | Le fichier est clair, la publication est bien bloquée et rien n'est déclaré « vérifié » à tort. Trois points restent à améliorer. (1) Il demande à la relectrice de modifier des CSV puis de « relancer le générateur » sans le nommer (`scripts/build.py`) : c'est peu réaliste pour une médecin stagiaire. (2) La ligne attendue dans `data/revues.csv` ne précise ni `etape_code` (RELECTURE_METIER) ni le `statut_code` attendu. (3) Après ce rapport, les points 1, 3 et 7 doivent être mis à jour : le vérificateur les a confrontés, voir ci-dessous. | (1) Faire consigner ses décisions par ligne et code (examen, champ, valeur), le producteur les reporte. (2) Nommer les deux codes. (3) Mettre à jour sans écrire « vérifié » pour ce que la relectrice n'a pas vu. |
| m10 | MINEUR | `references.csv` ABIM_2026 | Pages non relevées. | Pages indicatives (lecture web du PDF) : ALT, AST, PAL et aPTT p. 1 ; GDS p. 2 ; bicarbonate, CO₂, Ca total, Ca ionisé, BUN et bilirubine p. 3 ; chlorure et lipides p. 4 ; créatinine p. 5 ; glucose, HbA1c, Hb et Ht p. 6 ; leucocytes p. 7 ; Mg, P, K, plaquettes, TP, albumine et protéines p. 8 ; Na p. 9 ; triglycérides p. 10. À reporter. |
| m11 | MINEUR | `main.typ` l. 200, 204 | « Report per protocol » et « ECG monitoring per protocol » sont des consignes génériques absentes des sources (A-VERIFIER 11 du producteur). | Les garder, cohérentes avec AVERT_CLINIQUE, si la relectrice les valide. Sinon, les retirer. |

## Points A-VERIFIER du producteur : avis du vérificateur

| N° (`statut-methode.md`) | Avis | Bloque la publication ? |
|---|---|---|
| 1. Valeurs ABIM | Les 37 intervalles ABIM concordent avec ma lecture indépendante. Elle aussi passe par une extraction de texte du PDF, car le proxy refuse le téléchargement (403). Page de titre : « January 2026 » ; dernière page : « Revised - January 2026 ». Pages en m10. | Non. La relectrice peut s'en tenir à un sondage de quelques lignes. |
| 2. Digoxine 0.5–1.9 | Conforme à MedlinePlus (review 4/28/2026). Cette page ne donne ni cible pour l'insuffisance cardiaque, ni moment du prélèvement, ni lien avec le potassium. Garder, avec la correction M5. Un ajout sur l'heure du prélèvement ou le K⁺ demanderait une autre source. | Oui tant que M5 n'est pas corrigé ; non ensuite. |
| 3. HbA1c mmol/mol | 20–38 juste avec les deux équations (M3). | Non pour la relectrice ; M3 est à corriger par le producteur. |
| 4. Triglycérides × 0.0113 | Facteur juste et conventionnel ; source à citer (M4). | Non. |
| 5. µkat/L | Conversions justes (÷ 60). Garder la colonne est défendable ; c'est un choix éditorial pour la relectrice. | Non. |
| 6. SaO₂ ≥ 95 % | Conforme à l'ABIM p. 2 (« Oxygen saturation ≥95% », air ambiant). Garder. | Non. |
| 7. Masses atomiques | Mes valeurs indépendantes (table abrégée 2021 : H 1.0080, C 12.011, N 14.007, O 15.999, Mg 24.305, P 30.974, Ca 40.078) redonnent les 9 masses molaires. Je ne les ai pas relues dans la table IUPAC pendant ce run. Les facteurs arrondis n'y sont pas sensibles. | Non. |
| 8. Ca total vs ionisé | Voir M2 (source partielle trouvée). | Oui tant que la source manque. |
| 9. Hémolyse | Voir B2 (source trouvée, formulation à changer). | **Oui.** |
| 10. K⁺ et rythme | Voir M1 (moitié sourcée). | Oui tant que la source manque. |
| 11. « Report per protocol » | Voir m11. | Non. |
| 12. Clarté des libellés | « BUN (urea nitrogen) → urea » et « IFCC eq. » sont compréhensibles, l'équation étant juste au-dessus. | Non. |
| Ajout du vérificateur | Les intervalles ABIM sont ceux d'un board de médecine interne. Certains sont plus étroits que ceux souvent enseignés en soins infirmiers (GDS notamment). Ce constat vient de ma connaissance, **non sourcée dans ce run**. Le sous-titre dit « for NCLEX review ». À trancher par la relectrice et Tristan : garder l'ABIM, en assumant l'avertissement « intervals vary », ou ajouter « compare with the ranges your program teaches ». | Non. |

## Script de recalcul

Exécuté avec `python3 -I recalc_en08.py produits/EN08/donnees`.
- **Résultat :** 0 écart sur les dérivations, les masses molaires, les facteurs, les conversions affichées et les bornes sources.
- **Signalement :** 5 bornes diffèrent du calcul exact (m1).

```python
"""Recalcul indépendant EN08 (vérificateur R03). Usage : python3 -I recalc_en08.py <dossier produits/EN08/donnees>"""
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
    print(f"HbA1c {p} % : (p-2.15)*10.929 = {(p-2.15)*10.929:.2f} ; (p-2.152)/0.09148 = {(p-2.152)/0.09148:.2f}")

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
        "LDL cholesterol, optimal": ("", "100"), "HDL, low (female)": ("", "50"), "HDL, low (male)": ("", "40"),
        "Triglycerides, fasting": ("", "150"),
        # SI à la source : Ca ionisé 1.16–1.31 mmol/L ; MedlinePlus : INR 0.8–1.1, cible 2.0–3.0, digoxine 0.5–1.9
        "INR, no anticoagulant": ("0.8", "1.1"), "INR target on warfarin": ("2.0", "3.0"),
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

### Sortie (extrait)

```
OK  F_GLU    K / M          = 0.055507449 (attendu 0.055507449)  M recalculée 180.156 (CSV 180.156)
OK  F_BUN    K / (A * N)    = 0.356964375 (attendu 0.356964375)  10/(2*14.007) = 0.356964
OK  F_DIG    K / M          = 1.280493348 (attendu 1.280493348)  M recalculée 780.949 (CSV 780.949)
… (21/21 lignes de exemples.csv OK, 18/18 facteurs OK, 9/9 masses molaires OK)
Calcium, total                 | haut | 2.54 | 2.54 | 2.55  <-- diffère du calcul exact
Total cholesterol, desirable   | haut | 5.18 | 5.18 | 5.17  <-- diffère du calcul exact
HDL, low (female)              | haut | 1.30 | 1.30 | 1.29  <-- diffère du calcul exact
HDL, low (male)                | haut | 1.04 | 1.04 | 1.03  <-- diffère du calcul exact
Triglycerides, fasting         | haut | 1.70 | 1.70 | 1.69  <-- diffère du calcul exact
HbA1c 4.0 % : (p-2.15)*10.929 = 20.22 ; (p-2.152)/0.09148 = 20.20
HbA1c 5.6 % : (p-2.15)*10.929 = 37.71 ; (p-2.152)/0.09148 = 37.69
CV1: 9.990000 -> 10.0   CV2: 132.600000 -> 133   CV3: 4.408818 -> 4.41
… (40/40 intervalles conformes à la source)
Écarts : 5 (tous de type m1, aucun écart d'affichage)
```

## Sources consultées par le vérificateur (29.10.2026)

| Source | Accès | Ce que j'y ai lu |
|---|---|---|
| ABIM Laboratory Test Reference Ranges, January 2026 | Extraction de texte par outil web ; téléchargement direct refusé (proxy 403) | Valeurs et pages |
| MedlinePlus 003652 « Prothrombin time (PT) », review 2/3/2025 | Lu | INR 0.8–1.1 ; cible habituelle 2.0–3.0 ; la cible peut différer selon l'indication ; au-dessus de 3.0, risque de saignement ; en dessous de 2.0, risque de caillot |
| MedlinePlus 003568 « Digoxin test », review 4/28/2026 | Lu | Intervalle général 0.5–1.9 ng/mL ; le bon niveau varie selon la situation ; rien sur l'heure du prélèvement ni sur le K⁺ |
| MedlinePlus 003484 « Potassium test », review 5/19/2025 | Lu | Hémolyse et résultat faussement élevé ; K⁺ bas et troubles du rythme |
| MedlinePlus 003477 « Calcium blood test », review 11/6/2025 | Lu | Liaison du calcium à l'albumine ; l'albumine basse comme cause de calcium bas |
| NGSP « IFCC Standardization of HbA1c » (ngsp.org/ifcc.asp) | Lu | Équation maîtresse NGSP = 0.09148 × IFCC + 2.152 |
