# R00 : rapport de vérification

Vérificateur indépendant, sans participation à la production. Date : 27.10.2026. Budget : 25 min.
Tous les essais ont été faits hors du dépôt (`/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verif-r00/`) ou dans une copie du dépôt. Le seul fichier écrit dans le dépôt est ce rapport. Aucun commit.

## Verdict : OK avec réserves

Aucun BLOQUANT. La chaîne s'installe, fabrique et contrôle les 4 formats EN et FR. Les 6 calculs sont justes et chaque nombre du PDF A4 vient des données. Le contrôle N&B détecte bien une couleur injectée. L'enchaînement de l'outillage passe de bout en bout sur un faux EN02. `annonces.py` refuse une mention manquante ou altérée, ainsi qu'une annonce Etsy pour EN01.

Réserves : 4 MAJEURS et 10 MINEURS. Le plus important : **aucun contrôle ne vérifie que les mentions obligatoires figurent dans les PDF**. Un PDF sans déclaration IA ni mention de marque passe tous les contrôles.

| Étape | Résultat |
|---|---|
| 1. Installation | `bash scripts/installe.sh` : OK (typst 0.15.0, genanki 0.13.1, pypdf 6.17.0, pillow 12.3.0, poppler, ffmpeg, polices), en 1 s, relançable |
| 2. Fabrication | TEST-EN et TEST-FR en mode explicite vers le dossier temporaire : 4 PDF chacun, tous les contrôles OK (7 polices incorporées, métadonnées, 1 page en A4/Letter/N&B, 2 pages sur 3 admises en tablette, sommaire et signets). Texte identique aux PDF commités dans `produits/_test/livraison/` |
| 3. Calculs | 6/6 OK, écart nul en arithmétique exacte (Fraction). Concordance PDF A4 EN et FR : 56 nombres lus chacun, aucun hors données. Énoncés cohérents avec `entrees_json` |
| 4. Fond | Formules justes. Pas d'erreur factuelle. Voir M3, M4 et les mineurs m6 à m8 |
| 5. Charte | `modele.typ` : aucun hex, aucune couleur nommée, aucune police nommée, aucune longueur en pt/mm autre que `0pt`. N&B : un texte rouge injecté donne 126 pixels colorés, un filet bleu de 0,4 pt plus un gris chaud donnent 55 pixels, et le build échoue (code 1) dans les deux cas. Lecture à l'œil (A4 EN p. 1, tablette p. 1-2, N&B p. 1) : lisible, rien de coupé, sommaire et retour au sommaire présents. Débordement injecté (`box` de largeur 120 %) : détecté. Page en trop : détectée |
| 6. Outillage | Copie + faux EN02 : `build.py` → `apercus.py` (3 PNG) → `video_feuilletage.py` (10,00 s, 1440×1080, 0,55 Mo) → `anki.py` (3 notes, 3 cartes vérifiées dans le .apkg) → `annonces.py` : tout passe. Échecs attendus obtenus : mention MCAT retirée ; une lettre changée ; mention seulement dans un commentaire HTML ; mention déplacée dans les Labels ; visuel inexistant ; 12 tags ; tag avec virgule ; deux « & » dans le titre ; titre Whop de plus de 80 caractères ; label en double ; EN02 sans annonce Etsy ; **EN01 avec `etsy/annonce.md` : refusé**. `data/` reste identique après toute la chaîne (`diff -rq`) |
| 7. Tables et règles | `verifie_tables.py` : « Tables cohérentes ». Les seuils métier des 6 scripts passent par `reglage*()` (toutes les clés lues existent dans `parametres.csv`). Aucune écriture dans `data/` (grep et diff) |
| 8. Droits | Fira Sans, Fira Math et Fira Mono : `OFL.txt` (SIL OFL 1.1) présent dans chaque dossier ; seules ces polices sont incorporées dans les PDF de la charte et de la fiche test. Aucune image tierce. Les textes sont rédigés par l'équipe ; le seul lien externe pointe vers le BIPM |

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| M1 | MAJEUR | `scripts/controle_pdf.py`, `scripts/build.py` | Les mentions du produit ne sont pas contrôlées dans les PDF. Essai : EN02 dont `main.typ` ne passe pas `mentions:` → build OK sur tous les contrôles, et le pied ne contient que « MindShelf · v1 · 1 / 1 ». La déclaration IA, l'avertissement et la mention MCAT/NCLEX peuvent donc disparaître sans alerte, alors que `agents/verificateur.md` (Forme) les exige | Ajouter un contrôle « mentions » pour tous les formats : textes de `mentions_produit(produit, langue)` (clé `produit` et `langue` en mode explicite) recherchés dans `pdftotext` de chaque page, après normalisation des espaces, des retours à la ligne et des césures |
| M2 | MAJEUR | `scripts/gabarits/vignette_contenu.typ` | L'en-tête affirme que « toutes les valeurs arrivent par sys.inputs.donnees ». Pourtant, des valeurs de style y sont écrites en dur : `marge = haut * 0.07`, `leading: 0.5em`, tailles `haut / 30`, `/ 19`, `/ 28`, `tracking: 0.04em`, contour `0.6pt` et `transparentize(80%)`, rapport de colonnes `1.25fr`, espacements `0.035`, `0.045`, `0.026`, rayon de puce `0.008`. Cela contredit la règle « chaque valeur vit dans une table » | Passer ces valeurs en lignes `apercu_vignette_*` de `data/parametres.csv` (ou en renvois `charte:` vers des jetons), les transmettre dans le JSON et corriger le commentaire d'en-tête |
| M3 | MAJEUR | `produits/_test/src/main.typ` (exemple « Gravity infusion » et tableau), `exemples.csv` EX02 | Le résultat final d'un débit par gravité est affiché « 31.25 gtt/min / 31,25 gouttes/min », une valeur qu'on ne peut pas régler (on compte des gouttes entières). Le piège voisin dit « n'arrondir que le résultat final », mais ce résultat n'est pas arrondi ; la démo de la charte, elle, montre « 31,25 ⇒ 31 ». La fiche test sert de modèle à EN01 et FR01 (risque FORT, relecture métier) : dans un produit, ce serait un BLOQUANT au titre de la sécurité clinique | Ajouter une colonne `arrondi` (ou `resultat_affiche`) à `exemples.csv`, recalculée et contrôlée elle aussi, puis afficher « 31,25 ⇒ 31 gouttes/min » |
| M4 | MAJEUR | `produits/_test/donnees/references.csv`, note clinique | La note « double contrôle pour les médicaments à haut risque (insuline, héparine, potassium) » n'a aucune référence (règle du vérificateur : référence manquante = MAJEUR). « Potassium » est en outre imprécis : la liste ISMP vise le chlorure de potassium concentré injectable, pas le potassium oral | Ajouter la source (liste ISMP des médicaments à haut risque, ou équivalent HAS/ANSM pour le FR) et écrire « chlorure de potassium concentré (IV) » |
| m1 | MINEUR | `scripts/annonces.py` | Pour un produit sans droit à Etsy, seul `etsy/annonce.md` est refusé. Essai : EN01 avec `annonce/etsy/titre.md` passe (« conformes ») | Refuser l'existence du dossier `annonce/etsy/` entier quand `etsy_autorise` est faux |
| m2 | MINEUR | `charte/modele.typ` l. 487, 117-124 | `int(_v("graisse.gras")) - 400` écrit la graisse de base en dur alors que le jeton `graisse.normale` existe. Les icônes ont des proportions d'épaisseur en dur (`0.06 * s`, `1.25 * e`, `e * 0.62`) | Utiliser `_v("graisse.normale")` ; passer les épaisseurs d'icônes en jetons `icone.*` |
| m3 | MINEUR | `scripts/apercus.py` l. 135 et 161-164 | `ppp = 144` en dur. La vignette est compilée sans `ignore_system_fonts=True`, alors que `build.py` l'impose : le rendu dépend des polices installées sur la machine (36 fichiers Inter présents ici) | Paramètre `apercu_vignette_ppp` ; ajouter `ignore_system_fonts=True` et échouer si le dossier de polices manque, au lieu de passer `[]` en silence |
| m4 | MINEUR | `scripts/anki.py` l. 33-36 | CSS des cartes en dur (`padding: 0.2em 0.5em`, `border: 1px`, centrage) | Lignes `anki_*` dans `parametres.csv`, ou acceptation explicite comme gabarit technique |
| m5 | MINEUR | `produits/_outillage-test/prepare.py` l. 33, `livraison/test-a4.pdf`, `apercus/*.png` | Le banc d'essai compile sans `font_paths` ni `ignore_system_fonts`. Le PDF et les PNG commités contiennent Inter et New Computer Modern (polices système ou embarquées), pas la charte, sans fichier de licence dans le dépôt. Le résultat n'est pas reproductible d'une machine à l'autre | Compiler avec `font_paths=[charte/polices]` et `ignore_system_fonts=True`, puis régénérer |
| m6 | MINEUR | TEST-FR, EX02 | « Perfuseur à 15 gouttes/mL » : la convention enseignée en IFSI est le perfuseur standard à 20 gouttes/mL. Ce n'est pas faux, mais c'est atypique pour le public visé, et la démo de la charte utilise 20 | Pour FR01, prendre 20 gouttes/mL, avec sa référence |
| m7 | MINEUR | `exemples.csv` EX03 (énoncé non affiché) | « Pousse-seringue ou pompe : V = 500 mL » : un pousse-seringue ne contient pas 500 mL (seringues de 50 ou 60 mL) | « Pompe volumétrique : 500 mL en 4 h » |
| m8 | MINEUR | `main.typ`, formule « Hourly rate / Débit horaire » | `mL/h = V / T` met une unité à la place d'une grandeur | `débit (mL/h) = V (mL) / T (h)` |
| m9 | MINEUR | Pied de page (jeton `taille.pied` = 0.8em) | Mentions obligatoires à environ 6,4 pt en A4 et 6,2 pt en Letter : lisibles à l'écran, limites une fois imprimées en N&B | Vérifier sur une impression ; au besoin, 0.9em pour le pied |
| m10 | MINEUR | `scripts/README-outils.md` (« Dépendances : Aucune installation »), `scripts/installe.sh` | La doc contredit `installe.sh`, qui installe des versions figées. `installe.sh` vérifie que `ffmpeg` existe, pas qu'il dispose de l'encodeur `libx264`, dont dépend `video_feuilletage.py` | Renvoyer la doc vers `installe.sh` ; ajouter `ffmpeg -encoders \| grep libx264` |

Décompte : BLOQUANT 0, MAJEUR 4, MINEUR 10.

Points vérifiés sans constat :
- `build.py FR01-2026` échoue proprement (code 1) sur le nom de marque vide, avec renvoi à D01.
- Un PDF en échec de compilation est supprimé.
- Toutes les clés `reglage*()` des scripts existent dans `parametres.csv`.
- Les nombres de la démo de la charte sont justes (125 mL/h → 42 gouttes/min ; 500 mL/h → 167 ; 300 mL/h → 100, perfuseur à 20 gouttes/mL).
- Contrôle de la vidéo : durée, poids, codec h264/yuv420p, absence d'audio.

## Script de recalcul

Lancement : `python3 -I recalcul.py produits/_test/donnees/exemples.csv <TEST-EN-a4.pdf> <TEST-FR-a4.pdf>`

Il n'importe rien du dépôt. Les formules sont évaluées par un arbre AST restreint (`+ - * /`), en fractions exactes. Il contrôle aussi :
- la cohérence entre l'énoncé et `entrees_json` ;
- la concordance des nombres de la page 1 de chaque PDF A4 avec les données (séparateurs EN et FR, espace fine insécable).

Sortie obtenue :

```
OK  EX01  D / H * Q          = 2.5        attendu 2.5     mL       tol 0
OK  EX02  V * DF / (T * M)   = 31.25      attendu 31.25   gtt/min  tol 0
OK  EX03  V / T              = 125        attendu 125     mL/h     tol 0
OK  EX04  P * W              = 180        attendu 180     mg       tol 0
OK  EX05  C * K              = 500        attendu 500     µg       tol 0
OK  EX06  C / K              = 12.5       attendu 12.5    mg       tol 0
   TEST-EN-a4.pdf : 56 nombres lus : [0.5, 1.0, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 12.0, 12.5, 15.0, 31.25, 60.0, 125.0, 180.0, 250.0, 500.0, 1000.0, 12500.0]
OK  TEST-EN-a4.pdf : nombres hors données = []
   TEST-FR-a4.pdf : 56 nombres lus : (identique)
OK  TEST-FR-a4.pdf : nombres hors données = []
ÉCARTS : 0
```

```python
#!/usr/bin/env python3
"""Recalcul indépendant de produits/_test/donnees/exemples.csv + concordance des nombres du PDF A4.
Usage : python3 recalcul.py <exemples.csv> <pdf_a4_en> <pdf_a4_fr>
N'importe rien du dépôt : évaluation par un arbre AST restreint (+ - * / et parenthèses)."""
import ast, csv, json, re, subprocess, sys
from decimal import Decimal
from fractions import Fraction

OPS = {ast.Add: lambda a, b: a + b, ast.Sub: lambda a, b: a - b,
       ast.Mult: lambda a, b: a * b, ast.Div: lambda a, b: a / b}

def evalue(expr, env):
    def ev(n):
        if isinstance(n, ast.Expression): return ev(n.body)
        if isinstance(n, ast.BinOp) and type(n.op) in OPS: return OPS[type(n.op)](ev(n.left), ev(n.right))
        if isinstance(n, ast.Name):
            if n.id not in env: raise KeyError(f"variable {n.id} absente de entrees_json")
            return Fraction(Decimal(str(env[n.id])))
        if isinstance(n, ast.Constant) and isinstance(n.value, (int, float)): return Fraction(Decimal(str(n.value)))
        raise ValueError(f"nœud non admis : {ast.dump(n)}")
    return ev(ast.parse(expr, mode="eval"))

def recalcule(chemin):
    lignes, ecarts = list(csv.DictReader(open(chemin, encoding="utf-8"))), 0
    for l in lignes:
        env = json.loads(l["entrees_json"])
        calc = evalue(l["formule"], env)
        att, tol = Fraction(Decimal(l["resultat_attendu"])), Fraction(Decimal(l["tolerance"]))
        ok = abs(calc - att) <= tol
        # cohérence énoncé ↔ entrees_json : chaque « X = n » de l'énoncé doit valoir entrees_json[X]
        incoh = [f"{k}={v} (énoncé) ≠ {env[k]}" for k, v in re.findall(r"\b([A-Z]{1,2}) = ([\d.]+)", l["enonce"])
                 if k in env and Decimal(v) != Decimal(str(env[k]))]
        ecarts += (not ok) + len(incoh)
        print(f"{'OK ' if ok and not incoh else 'KO '} {l['id']}  {l['formule']:<18} = {float(calc):<10g} attendu {l['resultat_attendu']:<7} {l['unite']:<8} tol {l['tolerance']}  {'; '.join(incoh)}")
    return lignes, ecarts

def nombres_pdf(pdf, fr):
    txt = subprocess.run(["pdftotext", "-f", "1", "-l", "1", pdf, "-"], capture_output=True, text=True, check=True).stdout
    # retirer le pied de page (mentions) et les numéros de section/page
    txt = re.sub(r"(?m)^\s*\d(\.\d)*\s+[A-ZÉ][a-zé]", "", txt)   # numéros de titres « 1 Core formulas », « 2.1 Format … »
    sep_mil, sep_dec = (" | | ", ",") if fr else (",", ".")
    motif = rf"\d{{1,3}}(?:(?:{sep_mil})\d{{3}})+(?:{re.escape(sep_dec)}\d+)?|\d+(?:{re.escape(sep_dec)}\d+)?"
    vus = []
    for m in re.findall(motif, txt):
        s = re.sub(sep_mil, "", m) if not fr else re.sub(r"[   ]", "", m)
        s = s.replace(",", "") if not fr else s.replace(",", ".")
        vus.append(Decimal(s))
    return vus

def concordance(lignes, pdf, fr):
    attendus = set()
    for l in lignes:
        attendus.add(Decimal(l["resultat_attendu"]))
        attendus |= {Decimal(str(v)) for v in json.loads(l["entrees_json"]).values()}
        attendus |= {Decimal(d) for d in re.findall(r"\d+", l["id"])}       # EX01 … EX06 dans le tableau
    admis = {Decimal("125.0"), Decimal(1), Decimal(2), Decimal(3), Decimal(1) / 1}  # 125,0 (decimales: 1), « 1 / 1 », listes 1. 2. 3., « 3 étapes / 3 steps », v1
    inconnus = [n for n in nombres_pdf(pdf, fr) if n not in attendus and n not in admis]
    vus = nombres_pdf(pdf, fr)
    print(f"   {pdf.rsplit('/',1)[-1]} : {len(vus)} nombres lus : {sorted(set(map(float, vus)))}")
    print(f"{'OK ' if not inconnus else 'KO '} {pdf.rsplit('/',1)[-1]} : nombres hors données = {sorted(set(inconnus))}")
    return len(inconnus)

if __name__ == "__main__":
    lignes, e = recalcule(sys.argv[1])
    e += concordance(lignes, sys.argv[2], fr=False)
    e += concordance(lignes, sys.argv[3], fr=True)
    print("ÉCARTS :", e)
    sys.exit(1 if e else 0)
```
