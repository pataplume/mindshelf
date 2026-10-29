# EN06-STD : rapport de vérification v1 (run R04)

Produit : EN06 « Anatomy & Physiology — Body Systems Sheets », variante EN06-STD (en, MindShelf, v1), 6 pages A4 / Letter / N&B, 13 pages tablette, 11 systèmes.
Vérificateur : agent indépendant, n'a pas participé à la production. Date : 29.10.2026. Durée : environ 11 min.
Sources consultées pour le fond : SEER Training Modules, MedlinePlus, NIDDK (aucune page OpenStax ouverte, D10).

## Verdict : À corriger

**Aucun BLOQUANT**. **6 MAJEURS** à traiter avant la relecture métier, **9 MINEURS**.

- Calculs : les 3 exemples sont recalculés sans écart. Les concordances exemples ↔ `valeurs.csv` sont justes. Toutes les clés `k()` et `{v:}` existent, aucune n'est inutilisée. Chaque valeur de `valeurs.csv` apparaît dans le PDF A4.
- Forme : `controle_pdf.py` passe sur les 4 formats. Je n'ai trouvé aucun « ; » avalé : `build.py` passe dans une copie du dépôt et le texte des PDF reconstruits est identique à celui des PDF livrés. Aucun reste du type « Lot B à venir », TODO ou A-VERIFIER dans les PDF. Les 11 systèmes suivent le même gabarit : table, puis Physiology essentials, une note clinique et 2 ou 3 pièges. Le sommaire de la tablette a 14 entrées, avec des liens et des signets.
- Fond : j'ai confronté aux sources un large échantillon, en priorité les erreurs classiques. Valves et circulation pulmonaire, ordre de conduction, ADH et aldostérone, rénine, néphron, digestion enzymatique, glandes et hormones, 12 nerfs crâniens et 31 nerfs spinaux (8/12/5/5/1), couches de l'épiderme, 80 + 126 = 206 os, types de muscles, immunité innée, acquise et passive, Na⁺ et K⁺. Tout est **exact**. Une exception : la description de la LH, incomplète et trompeuse (M2). Il n'y a pas de section ABO/Rh, ce qui est cohérent avec `contenu.csv`.
- Sécurité clinique : les 11 notes cliniques sont courtes, sourcées et sans dose. J'ai relu sur la source les notes AVC, escarres, hypoglycémie, splénectomie, hyperkaliémie et grossesse extra-utérine : toutes concordent, et aucune conduite à tenir n'est trompeuse.

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `references.csv` l. 10, 11, 23, 29, 30, 31, 32, 37 (lot A) | **Des valeurs reposent encore sur OpenStax seul.** Le lot A cite `OPENSTAX_AP2E` comme seule source, avec des « sections lues le 29.10.2026 » (5.1, 5.3, 10.3, 12.4, 13.2, 14.1, 15.1, 17.3). Neuf valeurs affichées n'ont pas d'autre source : `A_COUCHES_FINE` (4), `A_COUCHES_EPAISSE` (5), `A_CP_SECONDES` (15 s), `A_AEROBIE_PCT` (95 %), `A_RMP` (−70 mV), `A_SEUIL` (−55 mV), `A_GOUTS` (5), `A_AUDITION_MIN`/`MAX` (20–20 000 Hz). C'est aussi le cas de plusieurs énoncés : fonctions des lobes, neurotransmetteurs du SNA, nerfs du goût, tonotopie de la cochlée, système porte, axe TRH → TSH, FSH et LH. Le lot B, lui, a écarté OpenStax (l. 94). Les valeurs me semblent justes, mais leur seule source n'est plus consultable (D10) : la référence est fragile. | Garder OpenStax comme bibliographie seulement et sourcer chaque ligne sur une source lisible : SEER (Nervous, Muscular, Special senses si disponibles), MedlinePlus (par ex. « Hearing loss » pour la plage d'audition), NCBI Bookshelf. Si aucune source lisible ne soutient une valeur, la retirer ou la marquer A-VERIFIER pour la relectrice. |
| M2 | MAJEUR | `a-endocrinien.csv`, ligne Anterior pituitary : « LH (gonadal androgens) » ; `references.csv` l. 37 | **La LH est décrite de façon incomplète et trompeuse.** La table limite la LH aux « androgènes gonadiques ». Elle omet l'ovulation et la formation du corps jaune, que la fiche affirme pourtant plus loin (Reproductive : « mid-cycle rise in LH releases the oocyte », piège LH/FSH). Une étudiant.e qui révise par la table se trompe à la question classique « quelle hormone déclenche l'ovulation ? ». La page Pituitary de SEER ne nomme ni la LH ni la FSH ; la seule source est OpenStax (cf. M1). | Remplacer par une formulation du type « LH (ovulation and corpus luteum; testosterone production in males) », sourcée par MedlinePlus « Luteinizing hormone (LH) blood test » (déjà citée l. 91). |
| M3 | MAJEUR | `systemes-a.typ` l. 71 (note Osteoporosis) | **« age over 50 » est un nombre tapé en dur dans le Typst.** Le seuil de 50 ans n'est pas non plus nommé dans `references.csv` l. 19. La valeur est juste : MedlinePlus dit « most common in people over age 50 ». | Créer `A_OSTEO_AGE` (50, years) dans `valeurs.csv`, l'afficher avec `#k()` et le mentionner dans la l. 19. |
| M4 | MAJEUR | `systemes-a.typ` l. 49, 72, 95, 120, 143 ; `systemes-b.typ` l. 30, 53, 76, 99, 121, 143 | **Les dates de source sont tapées en dur dans les 11 notes cliniques**, avec deux conventions selon le lot. Le lot A affiche la date de mise à jour ou de revue de la page (« updated Dec. 18, 2024 »), le lot B la date de consultation (« consulted Oct. 29, 2026 »). Les deux lots ne disent donc pas la même chose, et aucune de ces dates ne vit dans une table. Exemple : la page Spleen removal a été revue le 21.01.2025, Ectopic pregnancy le 17.03.2026. | Ajouter une table des sources de notes (id, organisme, titre, url, date_maj, date_consultation) et une fonction `#source(id)` qui écrit la ligne « Source: … ». Choisir une seule convention : de préférence la date de mise à jour ou de revue de la page, qui est la plus utile au lecteur et reste stable. |
| M5 | MAJEUR | `b-cardiovasculaire.csv`, ligne Conduction system : « SA node (pacemaker; 70–80 impulses/min on its own) » ; même texte dans `cartes.csv` | **Le rythme propre du nœud sinusal est discutable.** La valeur reprend fidèlement SEER (« Without any neural stimulation… 70 to 80 times per minute »). Mais le rythme intrinsèque d'un nœud sinusal dénervé est plus élevé (environ 100/min), et les étudiant.e.s infirmier.ère.s aux États-Unis apprennent 60–100/min pour le nœud sinusal (rythme sinusal normal). Le chiffre peut créer une confusion à l'examen et à la lecture d'un ECG. | Point A-VERIFIER pour la relectrice. Je propose de remplacer la parenthèse par « pacemaker; sets a normal resting rate », puis d'ajouter, s'il est sourcé (MedlinePlus), l'intervalle de fréquence cardiaque normale au repos. Sinon, garder 70–80 en écrivant « SEER figure ». |
| M6 | MAJEUR | `references.csv` l. 9 (glandes sudoripares) et l. 79 (Urethra) | **Deux références ne soutiennent pas la valeur affichée.** La page SEER Melanoma citée l. 9 place les glandes sudoripares « in the epidermis », alors que la fiche les met dans le derme, ce qui est anatomiquement juste. La ligne Urethra (l. 79) est marquée « page Urethra de SEER non lue ». Ce sont deux manquements à la règle 12. | Citer une source qui place les glandes sudoripares dans le derme (SEER Anatomy, module Integumentary, ou MedlinePlus) et lire la page Urethra de SEER (urinary/components). |
| m1 | MINEUR | `references.csv` l. 2 et 42, l. 5 et 44 ; l. 17, 28 ; `valeurs.csv` (descriptions de A_OS_ADULTE et A_NERFS_SPINAUX) ; commentaire de `main.typ` | **Assemblage non normalisé.** L'identification de SEER_AP figure deux fois, une par lot. MedlinePlus suit deux schémas : 5 codes séparés par des espaces dans une même cellule (lot A), un code générique `MEDLINEPLUS` (lot B). Le fichier `exemples-a.csv`, cité plusieurs fois, n'existe plus. Le commentaire de `main.typ` dit « references.csv (lot A), references.csv (lot B) ». | Une ligne d'identification par document, un seul code par cellule et un seul schéma pour MedlinePlus (un code par page). Remplacer `exemples-a.csv` par `exemples.csv`. |
| m2 | MINEUR | `cartes.csv` (« Five basic tastes ») ; `b-respiratoire.csv` et `systemes-b.typ` l. 80 (« fifth thoracic vertebra », écrit deux fois) ; `b-respiratoire.csv` (« nine cartilages ») ; `a-nerveux.csv` (« first lumbar vertebra ») ; `b-urinaire.csv` (« over a million ») ; `a-sens-speciaux.csv` (« three kinds of cones ») ; `contenu.csv` (« six systems ») ; `systemes-a.typ` l. 119 (« 911 ») | **Des nombres sont écrits en toutes lettres dans le texte.** « Five basic tastes » double `A_GOUTS`. La vertèbre de bifurcation de la trachée est écrite deux fois. | Passer par `{v:CLE}` ou `#k()` : `A_GOUTS` pour le recto de la carte, de nouvelles clés pour T5, 9 cartilages, L1, 1 million et 3 cônes. Pour « six » dans `contenu.csv`, voir m3. Le 911 est toléré comme numéro d'urgence, mais il peut aller dans `valeurs.csv`. |
| m3 | MINEUR | `contenu.csv` | **Le contenu est exact, mais la liste est découpée par lot.** Les éléments 2–3 (lot A) et 4–7 (lot B) se répètent : « Key structures → function tables » d'un côté, « structure–function tables » de l'autre ; « For each of these systems » puis « For each of these six systems ». Le nombre total de systèmes (11) n'apparaît pas. Pour l'annonce, cette liste se lit comme deux moitiés. | Une ligne commune pour le gabarit (« For each of the 11 systems: … »), une ligne par groupe de systèmes avec le même vocabulaire, et le nombre de systèmes tiré d'une table plutôt qu'écrit à la main. |
| m4 | MINEUR | Titres de niveau 1 | **Titres incohérents** : « Nervous System and Special Senses » (lot A) face à « Lymphatic & Immune Systems » et « Urinary System & Fluid Balance » (lot B). | Uniformiser sur « and » ou sur « & ». |
| m5 | MINEUR | `b-cardiovasculaire.csv` et `cartes.csv` (« {v:B_SANG_PCT} % ») ; apostrophes des CSV | **Typographie.** On trouve « 8 % » avec espace, alors que partout ailleurs le texte suit l'usage US (« 85% »). Les apostrophes sont droites dans les cellules CSV (limb's, Broca's, Adam's) et typographiques dans le texte Typst (program’s). | « 8% » ; apostrophes ’ dans les CSV. |
| m6 | MINEUR | `systemes-b.typ` l. 52 (Life without a spleen) | **Reprise quasi littérale de MedlinePlus Encyclopedia** (contenu A.D.A.M., usage non commercial) : « Immunizations, such as the pneumococcal, meningococcal, Haemophilus influenzae, flu, and COVID-19 vaccines ». De plus, « given around the surgery » n'est pas dans la source : la page les liste avant l'intervention, puis conseille d'en parler avec le médecin après (grippe, COVID-19). | Reformuler, par exemple : « Vaccines against pneumococcus, meningococcus, _H. influenzae_, influenza and COVID-19 are reviewed before the operation and afterward. » |
| m7 | MINEUR | `b-respiratoire.csv`, ligne Larynx : « Voice box (glottis) » | **Larynx et glotte assimilés.** C'est fidèle à SEER, mais la glotte est l'espace entre les cordes vocales, pas le larynx ; les examens jouent sur cette nuance. | « Voice box; the glottis is the opening between the vocal cords » (A-VERIFIER relectrice). |
| m8 | MINEUR | `systemes-b.typ` l. 71 (« 12–15 breaths/min ») | **Fréquence respiratoire.** La valeur correspond à SEER (« average adult… 12 to 15 »), mais l'intervalle de référence des signes vitaux enseigné aux infirmier.ère.s est plus large (12–20, ou 12–16 selon MedlinePlus « Vital signs »). Une étudiant.e risque de juger anormale une fréquence de 18/min. | Garder « average » et ajouter un intervalle de référence des signes vitaux sourcé, ou renvoyer aux normes du programme (A-VERIFIER relectrice). |
| m9 | MINEUR | `systemes-a.typ` l. 111 (« kept by the Na⁺/K⁺ pump ») | **Simplification.** Le potentiel de repos tient surtout à la fuite de K⁺ ; la pompe entretient les gradients. | « set mainly by K⁺ leak, with gradients kept up by the Na⁺/K⁺ pump (ATP) », sourcé hors OpenStax (cf. M1). |

## Points A-VERIFIER

| Point | Origine | Avis du vérificateur | Bloque la publication ? |
|---|---|---|---|
| Licence de SEER (refs l. 2, 42) | producteurs | Site du NCI, agence fédérale : son texte est en principe dans le domaine public américain (17 U.S.C. 105), mais certaines images peuvent venir de tiers. La fiche ne reprend ni texte ni image : c'est sans enjeu ici. | Non |
| Glandes sudoripares dans le derme (ref l. 9) | producteurs | La fiche a raison et la page SEER Melanoma se trompe. Il faut changer de source (M6). | Non, une fois la source remplacée |
| « Purkinje fibers » (ref l. 49) | producteurs | Terme standard, équivalent de « conduction myofibers ». Acceptable. | Non |
| « Passive » pour l'expiration de repos (ref l. 65) | producteurs | Physiologie standard, cohérente avec la description de SEER (relâchement et recul élastique). | Non |
| Urètre (ref l. 79) | producteurs | Fait trivial, mais la page n'a pas été lue (M6). | Non, une fois la page lue |
| Licence MedlinePlus Encyclopedia (ref l. 44) | producteurs | Le contenu A.D.A.M. est réservé à un usage non commercial : aucune phrase ne doit être reprise. Seule la note splénectomie pose problème (m6). | Non, après reformulation |
| Nœud sinusal 70–80/min « on its own » (M5) | vérificateur | Fidèle à SEER mais discutable, et en écart avec la norme clinique de 60–100/min. À trancher par la médecin stagiaire. | Non, à condition que la relectrice tranche avant validation |
| Fréquence respiratoire 12–15 (m8), glotte (m7), potentiel de repos (m9) | vérificateur | Précision pédagogique. | Non |
| Retour veineux « not on the push of the ventricles » (`systemes-b.typ` l. 26) | vérificateur | Fidèle à SEER (« not the direct result of ventricular contraction »). Le gradient de pression résiduel venu du cœur reste pourtant le moteur principal du retour veineux, aidé par les pompes musculaire et respiratoire. Je suggère « not directly by ventricular contraction », comme SEER. | Non |
| Valeurs qui dépendent d'OpenStax seul (M1) | vérificateur | Elles sont exactes à ma connaissance, mais leur source ne peut plus servir de vérification (D10). | Oui, au sens où elles doivent être resourcées avant la relecture métier. Ce n'est pas une erreur factuelle. |

## Vérifications de fond faites sur les sources (échantillon)

Les valeurs suivantes concordent avec la source lue ce jour.

- **SEER** : nœud sinusal 70–80/min et cycle de 0,8 s (Heart physiology) ; 12–15 respirations/min (Respiratory capacity) ; ovocyte fécondable 24–48 h et fécondation dans la trompe (Female tract) ; corps jaune environ 10 jours, progestérone et un peu d'œstrogènes, granulosa (Ovaries) ; stratum corneum de 10 à 30 couches, Langerhans dans la couche spinosum, mélanocytes et cellules de Merkel dans la couche basale ; cellules autour des follicules sensibles à la pression (Melanoma anatomy) ; T4 à 95 %, 4 parathyroïdes, PTH comme principal régulateur, calcitonine (Thyroid) ; 85 % de la chaleur corporelle, genou et épaule (Muscular) ; larynx à 9 cartilages, bifurcation de la trachée en T5 (Larynx) ; retour veineux, 4 facteurs de la pression artérielle, pression pulsée (Blood physiology).
- **MedlinePlus** : AVC ischémiques à 80 %, signes, appel du 911, mise à jour du 28.07.2025 (Stroke) ; changement de position toutes les 2 h, personnes à risque, mise à jour du 18.12.2024 (Pressure sores) ; plus de 50 ans, sites de fracture, prévention, mise à jour du 30.09.2025 (Osteoporosis) ; hypoglycémie sous 70 mg/dL (3,9 mmol/L), traitement sans dose en grammes, urgence si la personne est moins alerte, revue du 25.01.2026 ; hyperkaliémie (reins, palpitations, pouls, arrêt cardiaque) ; grossesse extra-utérine (trompe, facteurs de risque, rupture) ; liste des vaccins après splénectomie.
- **NIDDK** : 150 quarts de sang filtrés par jour, 1 à 2 quarts d'urine, environ un million de néphrons par rein.

## Reproduction

- Recompilation : `python3 scripts/build.py EN06-STD` dans une copie du dépôt (`/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/repo`). Les 4 PDF sont fabriqués et contrôlés, et leur texte est identique aux PDF livrés.
- Script de recalcul : ci-dessous. Une copie est dans `/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verif-en06/recalcul_en06.py`. Lancement : `python3 -I recalcul_en06.py /home/claude/mindshelf/produits/EN06`.

Sortie obtenue :

```
OK    A_EX01: axial + appendiculaire = 206 (attendu 206.0, tol 0.0, affiché 206 bones)
OK    A_EX02: c + t + l + s + co = 31 (attendu 31.0, tol 0.0, affiché 31 pairs)
OK    B_EX02: pas - pad = 40 (attendu 40.0, tol 1e-06, affiché 40 mm Hg)
OK    concordance A_EX01.axial = A_OS_AXIAL   (… 9 concordances OK)
OK    total A_EX01 = A_OS_ADULTE
OK    total A_EX02 = A_NERFS_SPINAUX
Clés inconnues : aucune
Clés de valeurs.csv inutilisées : aucune
Valeurs absentes du PDF A4 : aucune
ECARTS BLOQUANTS : 0
```

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
