# EN06-STD : contre-vérification v2 (run R04)

Produit : EN06 « Anatomy & Physiology — Body Systems Sheets », EN06-STD (en-US, MindShelf), 6 pages A4 / Letter / N&B, 13 pages tablette.
Vérificateur : agent VÉRIFICATEUR, n'a participé ni à la production ni à la correction. Date : 29.10.2026, environ 11:34-11:48 (périmètre partagé avec FR09). Périmètre : constats de `rapport-v1.md` et ce qui a changé depuis ; pas de seconde vérification complète.
Aucune page OpenStax consultée.

## Verdict : OK avec réserves

**0 BLOQUANT, 0 MAJEUR restant, 2 MINEURS nouveaux.** Les 6 MAJEURS et les 9 MINEURS de la v1 sont levés ou, pour les points de fond qui relèvent de la relectrice, transformés en `A-VERIFIER` explicites et listés dans `donnees/statut-methode.md`. La publication reste bloquée (voir « Points A-VERIFIER »).

Méthode : diff mot à mot du texte du PDF A4 v1 (copie du vérificateur v1) et v2 ; relecture des tables modifiées (`references.csv`, `sources.csv`, `valeurs.csv`, `contenu.csv`, CSV des systèmes, `cartes.csv`) et du Typst ; `controle_pdf.py` (4 formats : tout passe) ; `build.py EN06-STD` relancé dans une copie du dépôt (`/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verificateur-v2/depot`) : il réussit et le texte des 4 PDF reconstruits est identique aux PDF livrés ; rendu A4 des pages 1, 2, 4 et 5 relu (rien de coupé) ; `annonces.py EN06` relancé dans la copie : `whop.md` et `etsy/annonce.md` identiques aux fichiers livrés ; 4 sources nouvelles relues en ligne.

## Constats v1 → v2

| # v1 | Constat v1 | État | Ce que j'ai vérifié |
|---|---|---|---|
| M1 | Valeurs sourcées par OpenStax seul | **Levé** | Aucun `source_code` OpenStax dans `references.csv` ni dans `sources.csv` ; OpenStax n'apparaît plus que dans des commentaires. 15 s et 95 % retirés (PDF : « for the first seconds », « most of the ATP »), nerfs du goût retirés. 5 saveurs (MedlinePlus *Taste - impaired*) et 20–20 000 Hz (MedlinePlus *Audiometry*) ont une source lisible. Restent sans source et marqués `A-VERIFIER` pour la relectrice (8 lignes) : 4 couches en peau fine, −70 mV et −55 mV, 3 types de cônes, lobes, SNA, contraction, vitamine D, axe hypothalamo-hypophysaire. C'est conforme à la règle 1. |
| M2 | LH incomplète et trompeuse | **Levé** | Table : « LH (mid-cycle surge triggers ovulation; makes the ovaries produce estrogen and the testes testosterone) » ; FSH : « egg development, sperm production ». Sources `MEDLINEPLUS_LH` et `MEDLINEPLUS_LH_TEST` (relue : ovulation et testostérone confirmées ; pour l'œstrogène, voir n1). |
| M3 | « age over 50 » en dur | **Levé** | `#k("A_OSTEO_AGE")`, `A_OSTEO_AGE,50,years` dans `valeurs.csv`, cité l. 19 de `references.csv`. |
| M4 | Dates de source en dur, deux conventions | **Levé** | `sources.csv` (un document par ligne, `date_consultation`, `date_revue_page`) ; `#source()` dans `commun.typ` écrit les 11 lignes « Source: … (consulted Oct. 29, 2026). » ; plus aucune date dans les `.typ`. Convention retenue : date de consultation (la v1 préférait la date de revue, mais elle est conservée dans la table : choix acceptable). |
| M5 | Nœud sinusal 70–80/min | **Levé (à trancher par la relectrice)** | Table et carte : « intrinsic rate 70–80/min per SEER, without nerve input; normal adult resting heart rate 60–100/min », valeurs `B_SA_*` et `B_FC_REPOS_*`. MedlinePlus *Pulse* relu : « 60 to 100 beats per minute », revue du 1.1.2025 (= `sources.csv`). Point 1 de `statut-methode.md`. |
| M6 | Glandes sudoripares et urètre | **Levé** | Nouvelle formulation « Sweat glands lie deep, down to the subcutaneous layer, and open on the surface through pores », source `MEDLINEPLUS_SKIN_AGING` relue : « The inner layer under the dermis (the subcutaneous layer) contains sweat glands » (revue 15.07.2024, = table). SEER Melanoma n'est plus cité pour ce point. Urètre : page SEER *Urethra* relue (« conveys urine… to the outside », « transports both urine and semen »). |
| m1 | `references.csv` non normalisé | **Levé** | 97 lignes ; un seul code par cellule, chaque code existe dans `sources.csv`, aucun code inutilisé, une ligne d'identification par document (MedlinePlus : un code par page). `exemples-a.csv` n'est plus cité. |
| m2 | Nombres en toutes lettres | **Levé** | `{v:A_GOUTS}`, `{v:B_TRACHEE_T}`, `{v:B_LARYNX_CARTILAGES}`, `{v:A_MOELLE_L}`, `{v:B_NEPHRONS_MILLION}`, `{v:A_CONES}`. « Call 911 » reste dans le texte (toléré en v1). |
| m3 | `contenu.csv` découpé par lot | **Levé** | Ligne commune « For each of the 11 body systems… » ; `G_SYSTEMES = 11` dans `valeurs.csv`, contrôlé par `main.typ`. |
| m4 | Titres « & » / « and » | **Levé** | « Lymphatic and Immune Systems », « Urinary System and Fluid Balance ». |
| m5 | « 8 % », apostrophes droites | **Levé** | « 8% », « limb’s », « Broca’s », « Adam’s ». |
| m6 | Note splénectomie quasi littérale | **Levé** | Reformulée : vaccination revue avant l'opération puis avec l'équipe soignante ; noms de vaccins seulement, sans dose. |
| m7 | Larynx = glotte | **Levé (A-VERIFIER relectrice)** | « Voice box; the glottis is the opening between the vocal cords ». |
| m8 | 12–15 respirations/min | **Non modifié, transmis** | Inchangé ; point 3 de `statut-methode.md` pour la relectrice. Acceptable. |
| m9 | Potentiel de repos | **Levé (A-VERIFIER relectrice)** | « set mainly by K⁺ leaking out, with the gradients kept up by the Na⁺/K⁺ pump (ATP) ». |
| — | Retour veineux | **Levé** | « not directly on ventricular contraction ». |

`statut-methode.md` (règle 15) : aucun « vérifié » faux. Il distingue `source` (page lue) et `A-VERIFIER` (« n'est pas vérifiée »), annonce la publication bloquée et liste 8 points pour la relectrice. Le « 0 écart » qu'il annonce est confirmé par mon recalcul.

## Nouveaux constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| n1 | MINEUR | `references.csv` l. 42 (`MEDLINEPLUS_LH_TEST`) | La page *LH Levels Test* relue lie l'œstrogène à la puberté : « In girls, LH helps signal the ovaries to make the hormone estrogen ». La table l'écrit de façon générale (« makes the ovaries produce estrogen »). C'est physiologiquement juste, mais la localisation ne le soutient qu'indirectement. | Préciser la localisation (phrase sur les filles) ou citer une page qui le dit pour la femme adulte ; à défaut, laisser la relectrice confirmer. |
| n2 | MINEUR | `references.csv` l. 9 | La ligne `A-VERIFIER` (épiderme sans vaisseaux, lucidum, 4 couches) garde le code `SEER_MELANOMA`, alors que les 7 autres lignes `A-VERIFIER` ont un code vide. | Vider le code, ou ajouter une colonne qui distingue la partie sourcée de la partie à vérifier. |

## Sources nouvelles relues (échantillon, 29.10.2026)

| Code | Ce que la page écrit | Concorde ? |
|---|---|---|
| `MEDLINEPLUS_PULSE` | « Children 10 years and older, and adults (including seniors): 60 to 100 beats per minute » ; Review Date 1/1/2025 | Oui (valeurs et date de revue) |
| `MEDLINEPLUS_LH_TEST` | « triggers the release of an egg from the ovary » ; « In men, LH causes the testicles to make the hormone testosterone » ; mise à jour 5.12.2023 | Oui (œstrogène : voir n1) |
| `MEDLINEPLUS_SKIN_AGING` | Couche sous-cutanée « contains sweat glands » ; Review Date 7/15/2024 | Oui |
| `SEER_AP` (page *Urethra*) | Conduit l'urine de la vessie vers l'extérieur ; chez l'homme, urine et sperme | Oui |

## Points A-VERIFIER restants

| Point | Avis | Bloque la publication ? |
|---|---|---|
| 8 points de `statut-methode.md` (nœud sinusal, glotte, fréquence respiratoire, potentiel de repos, couches de l'épiderme, glandes sudoripares, éléments sans source lisible, vaccins) | Faits usuels, exacts à ma connaissance. Ils sont bien signalés, et c'est le rôle de la médecin stagiaire de les trancher. | **Oui, jusqu'à la relecture de la médecin stagiaire** (déjà prévu par `statut-methode.md`) |
| Mention « content checked and approved by the seller » (pied de page, `whop.md`, `etsy/annonce.md`) | N'est vraie qu'après la relecture et la validation de Tristan (règle 15). | **Oui**, tant que le produit n'est pas validé |
| Licence SEER (`sources.csv`) | Sans enjeu : aucun texte ni image repris. | Non |
| Sources non accessibles (NCI Dictionary, NIDCD, NINDS) | Ne servent à aucune valeur affichée. | Non |

## Recalcul

Le script de la v1 est réutilisé **sans modification** (formules d'`exemples.csv`, concordances avec `valeurs.csv`, clés `k()` et `{v:}`, présence de chaque valeur dans le PDF A4). Copie : `/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verificateur-v2/recalcul_en06.py`. Lancement : `python3 -I recalcul_en06.py /home/claude/mindshelf/produits/EN06`.

```
OK    A_EX01: axial + appendiculaire = 206 (attendu 206.0, tol 0.0, affiché 206 bones)
OK    A_EX02: c + t + l + s + co = 31 (attendu 31.0, tol 0.0, affiché 31 pairs)
OK    B_EX02: pas - pad = 40 (attendu 40.0, tol 1e-06, affiché 40 mm Hg)
OK    concordance … (9 concordances OK), total A_EX01 = A_OS_ADULTE, total A_EX02 = A_NERFS_SPINAUX
Clés inconnues : aucune
Clés de valeurs.csv inutilisées : aucune
Valeurs absentes du PDF A4 : aucune
ECARTS BLOQUANTS : 0
```

Annonces : 6 pages, 13 pages tablette, 11 systèmes, 11 notes cliniques, 30 pièges (comptés dans le PDF A4) et 69 cartes (`cartes.csv`) : chiffres exacts. Aucune promesse de couverture de programme.

```python
#!/usr/bin/env python3
"""Recalcul et concordance EN06 (vérificateur R04).

Usage : python3 -I recalcul_en06.py /home/claude/mindshelf/produits/EN06
1. Recalcule chaque ligne de donnees/exemples.csv (formule évaluée avec + - * / et calc.pow -> pow).
2. Vérifie les concordances codées dans systemes-a.typ / systemes-b.typ (entrées d'exemple = valeurs.csv).
3. Vérifie que chaque clé k("…") des .typ et {v:…} des CSV existe dans valeurs.csv, liste les clés inutilisées.
4. Vérifie que chaque nombre de valeurs.csv apparaît dans le texte extrait du PDF A4 (pdftotext).
"""
import ast
import csv
import json
import re
import subprocess
import sys
from pathlib import Path

racine = Path(sys.argv[1])
don = racine / "donnees"
src = racine / "src"
ecarts = 0

# --- 1. Recalcul des exemples ---------------------------------------------------------
AUTORISES = (ast.Expression, ast.BinOp, ast.UnaryOp, ast.Add, ast.Sub, ast.Mult, ast.Div, ast.USub, ast.UAdd,
             ast.Constant, ast.Name, ast.Load, ast.Call, ast.Attribute)


def evalue(formule, entrees):
    f = formule.replace("calc.pow", "pow")
    arbre = ast.parse(f, mode="eval")
    for n in ast.walk(arbre):
        if not isinstance(n, AUTORISES):
            raise ValueError(f"opérateur interdit dans {formule!r} : {type(n).__name__}")
        if isinstance(n, ast.Call) and not (isinstance(n.func, ast.Name) and n.func.id == "pow"):
            raise ValueError(f"fonction interdite dans {formule!r}")
    return eval(compile(arbre, "<formule>", "eval"), {"__builtins__": {}, "pow": pow}, dict(entrees))


exemples = {}
with open(don / "exemples.csv", newline="", encoding="utf-8") as fh:
    for l in csv.DictReader(fh):
        if re.search(r"\d[eE][-+]?\d", l["entrees_json"]):
            print(f"ECART {l['id']} : notation scientifique dans entrees_json"); ecarts += 1
        e = json.loads(l["entrees_json"])
        r = evalue(l["formule"], e)
        att, tol = float(l["resultat_attendu"]), float(l["tolerance"])
        ok = abs(r - att) <= tol
        affiche = round(r, int(l["arrondi"] or 0))
        print(f"{'OK   ' if ok else 'ECART'} {l['id']}: {l['formule']} = {r} (attendu {att}, tol {tol}, affiché {affiche} {l['unite']})")
        ecarts += not ok
        exemples[l["id"]] = e

# --- 2. Concordances -----------------------------------------------------------------
with open(don / "valeurs.csv", newline="", encoding="utf-8") as fh:
    valeurs = {l["id"]: l for l in csv.DictReader(fh)}
CONC = [("A_EX01", "axial", "A_OS_AXIAL"), ("A_EX01", "appendiculaire", "A_OS_APPEND"),
        ("A_EX02", "c", "A_NS_C"), ("A_EX02", "t", "A_NS_T"), ("A_EX02", "l", "A_NS_L"),
        ("A_EX02", "s", "A_NS_S"), ("A_EX02", "co", "A_NS_CO"),
        ("B_EX02", "pas", "B_EX_PAS"), ("B_EX02", "pad", "B_EX_PAD")]
for ex, cle, vid in CONC:
    ok = float(exemples[ex][cle]) == float(valeurs[vid]["valeur"])
    print(f"{'OK   ' if ok else 'ECART'} concordance {ex}.{cle} = {vid}")
    ecarts += not ok
for ex, vid in (("A_EX01", "A_OS_ADULTE"), ("A_EX02", "A_NERFS_SPINAUX")):
    with open(don / "exemples.csv", newline="", encoding="utf-8") as fh:
        att = {l["id"]: float(l["resultat_attendu"]) for l in csv.DictReader(fh)}[ex]
    ok = att == float(valeurs[vid]["valeur"])
    print(f"{'OK   ' if ok else 'ECART'} total {ex} = {vid}")
    ecarts += not ok

# --- 3. Clés utilisées / inconnues / inutilisées -------------------------------------------
utilisees = set()
for f in src.glob("*.typ"):
    utilisees |= set(re.findall(r'k\("([A-Za-z0-9_]+)"', f.read_text(encoding="utf-8")))
    utilisees |= set(re.findall(r'val\("([A-Za-z0-9_]+)"\)', f.read_text(encoding="utf-8")))
    utilisees |= set(re.findall(r'"([A-Z]_[A-Z0-9_]+)"\)', f.read_text(encoding="utf-8")))
for f in don.glob("*.csv"):
    if f.name in ("valeurs.csv", "references.csv"):
        continue
    utilisees |= set(re.findall(r"\{v:([A-Za-z0-9_]+)\}", f.read_text(encoding="utf-8")))
inconnues = sorted(k for k in utilisees if k not in valeurs and re.match(r"[AB]_", k) and not k.startswith(("A_EX", "B_EX0")))
print("Clés inconnues :", inconnues or "aucune"); ecarts += len(inconnues)
print("Clés de valeurs.csv inutilisées :", sorted(set(valeurs) - utilisees) or "aucune")

# --- 4. Présence des valeurs dans le PDF A4 ------------------------------------------------
pdf = racine / "livraison" / "EN06-STD" / "EN06-STD-a4.pdf"
texte = subprocess.run(["pdftotext", "-layout", str(pdf), "-"], capture_output=True, text=True).stdout
texte_n = texte.replace("−", "-").replace(" ", "").replace(" ", "")


def formats(v):
    x = float(v)
    s = {v}
    if x == int(x):
        s.add(f"{int(x):,}")
    return s


absentes = [vid for vid, l in valeurs.items() if not any(re.search(r"(?<![\d.])" + re.escape(f) + r"(?![\d])", texte_n) for f in formats(l["valeur"]))]
print("Valeurs absentes du PDF A4 :", absentes or "aucune")
print("ECARTS BLOQUANTS :", ecarts)
sys.exit(1 if ecarts else 0)
```
