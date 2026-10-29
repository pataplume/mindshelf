# Chaîne de fabrication des PDF

Une source Typst par produit (`produits/<CODE>/src/main.typ`) donne les quatre PDF d'une variante : A4, US Letter, N&B, tablette. Le modèle de mise en page est décrit dans `charte/README.md`.

## Installation

```bash
bash scripts/installe.sh
```

Installe ou vérifie typst 0.15.0, genanki, pypdf et Pillow (versions figées dans le script), puis vérifie pdftoppm, pdffonts, pdftotext, ffmpeg, ffprobe et les polices de `charte/polices/`. Relançable sans effet de bord. Changer la version de typst oblige à refaire les rendus de référence (`charte/demo/`, `produits/_test/livraison/`).

## Fabriquer une variante

```bash
python3 scripts/build.py EN02-STD                    # les 4 formats
python3 scripts/build.py EN02-STD --formats a4,nb    # un sous-ensemble
```

1. Lit `data/variantes.csv` (produit, référentiel, version), `data/produits.csv` (titre, marché, `pages_max`), `data/marches.csv` (langue) et `data/marques.csv` (nom de la marque).
2. Contrôle les sources `.typ` du dossier `src/` (sous-dossiers compris) : un `;` collé après une expression intégrée au texte (`#res("EX11"); suite`) est avalé par Typst sans avertissement ; le build échoue avant de compiler, avec fichier, ligne, extrait et correction (`#res("EX11")\; suite`). Détails ci-dessous (`scripts/controle_source.py`).
3. Compile `produits/<CODE>/src/main.typ` pour chaque format (racine = dépôt, polices = `charte/polices` seules).
4. Écrit `produits/<CODE>/livraison/<VARIANTE>/<VARIANTE>-<format>.pdf`. L'outillage (`apercus.py`, `video_feuilletage.py`, `anki.py`) dépend de ce nommage.
5. Lance `controle_pdf.py` sur les PDF produits.

Le code de sortie vaut 1 à la première erreur. Un PDF dont la compilation échoue est supprimé : aucun ancien fichier ne reste à sa place.

### Mode explicite (tests, sources hors catalogue)

```bash
python3 scripts/build.py --source produits/_test/src/main.typ \
  --sortie-dir produits/_test/livraison/TEST-EN \
  --inputs produits/_test/donnees/entrees-en.json [cle=valeur …] [--pages-max N] [--formats …]
```

`--inputs` prend un fichier JSON `{clé: valeur}` et/ou des paires `clé=valeur` (les paires l'emportent). Toutes les clés du contrat sont exigées. `pages_max` peut figurer dans le JSON à la place de `--pages-max`. La source doit être sous la racine du dépôt.

## Contrat `sys.inputs`

Toutes les valeurs sont des chaînes. Chaque `main.typ` les lit par `sys.inputs.at("<clé>")`. Aucun nom de marque, titre ou code n'est écrit dans le Typst.

| Clé | Source (mode catalogue) | Exemple | Usage dans `main.typ` |
|---|---|---|---|
| `format` | option `--formats` | `a4`, `letter`, `nb`, `tablette` | `format:` de `fiche` |
| `variante` | `variantes.code` | `FR01-2026` | choix de contenu propre à la variante, si besoin |
| `produit` | `variantes.produit_code` | `FR01` | `mentions-produit(<produit>, <langue>)` |
| `referentiel` | `variantes.referentiel_code` | `IFSI_2026`, `AUCUN` | correspondances d'UE (`donnees/variantes.csv`) |
| `langue` | `marches.langue` | `en`, `fr` | `langue:` de `fiche` |
| `marque` | `marques.nom` (via `marches.marque_code`) | `MindShelf` | `marque:` de `fiche` (métadonnée Author) |
| `version` | `variantes.version` | `v1` | `version:` de `fiche` (pied de page) |
| `titre` | `produits.titre_travail` | `Physics Formula Sheet (College & Pre-Med)` | `titre:` de `fiche` (métadonnée Title, contrôlée) |

En-tête type d'un produit :

```typst
#import "/charte/modele.typ": *
#let entree(cle) = sys.inputs.at(cle)
#show: fiche.with(
  titre: entree("titre"), marque: entree("marque"), langue: entree("langue"),
  format: entree("format"), version: entree("version"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
)
```

**Pourquoi la version vit dans `variantes.csv`.** La version est celle de la variante livrée : les deux référentiels d'un produit IFSI peuvent évoluer séparément, et une correction validée par Tristan incrémente une ligne de table, pas un fichier dans le dossier produit. Elle reste lisible à côté des statuts et des revues (`revues.csv` a déjà une colonne `version`).

## Contrôle de la source (`scripts/controle_source.py`)

```bash
python3 scripts/controle_source.py produits/EN10/src/main.typ   # direct, sur un ou plusieurs .typ
```

La source est lue avec les modes de Typst (texte, code, maths), parenthèses et crochets imbriqués, chaînes, commentaires, blocs bruts et liens compris. Est signalé tout `;` collé juste après une expression intégrée au texte ou aux maths : `#f(…)`, `#f[…]`, `#x.y(…)`, `#x`, `#if … [ ] else [ ]`, y compris dans un bloc de contenu `[ … ]` écrit dans du code. Ne sont pas signalés : les instructions `#let`, `#set`, `#show`, `#import`, `#include`, `#return` (le `;` y termine l'instruction), le code entre `{ }` et `( )`, `\;`, un `;` précédé d'une espace, et un `;` qui sert à clore l'expression (suivi de `(`, `[`, `.x`, ou d'une lettre après un nom : `#sym.space.nobreak;h`). Longueur des extraits : réglage `controle_source_extrait_car`.

## Contrôles (`scripts/controle_pdf.py`)

```bash
python3 scripts/controle_pdf.py EN02-STD
python3 scripts/controle_pdf.py --pdf dossier/X-a4.pdf dossier/X-nb.pdf --titre "…" --marque MindShelf --pages-max 1
```

| Contrôle | Formats | Règle |
|---|---|---|
| fichier | tous | présent et lisible |
| polices | tous | toutes incorporées (`pdffonts`, colonne `emb`) |
| métadonnées | tous | Title = titre du produit, Author = marque |
| pages | tous | de 1 à `pages_max × controle_pages_facteur_<format>` (arrondi au-dessus) |
| pages blanches | tous | chaque page peint du contenu hors en-tête, pied de page et décor (contenu balisé `/Artifact` par Typst) |
| débordement | tous | aucun mot hors de la zone de texte latérale (`page.<format>.marge.x` de la charte, tolérance `controle_debordement_tolerance_pt`) ni hors de la page |
| double moins | tous | aucun double signe moins dans le texte extrait (`pdftotext`) : `−−`, `−-`, `-−`, ou `--` suivi d'un chiffre ; espaces admis entre les deux signes, pas de retour à la ligne |
| sans couleur | `nb` | rendu à `controle_nb_ppp` ppp ; un pixel est coloré si l'écart entre ses canaux R, V, B dépasse `controle_nb_ecart_max` ; au plus `controle_nb_pixels_max` pixels colorés |
| paysage, liens internes, signets | `tablette` | page plus large que haute ; liens du sommaire en page 1 et retour au sommaire sur chaque page suivante ; signets PDF présents |

## Fiche test

`produits/_test/` n'est pas un produit (absent de `data/produits.csv`). `src/main.typ` exerce tous les composants de la charte. La langue vient de l'entrée `langue` : une seule source donne la version anglaise (`TEST-EN`) et la version française (`TEST-FR`). Les nombres affichés sont lus dans `donnees/exemples.csv`, et chaque `resultat_attendu` y est recalculé depuis `formule` et `entrees_json`. Un écart au-delà de `tolerance` fait échouer la compilation. Le résultat affiché est arrondi selon les colonnes `arrondi` (décimales) et `mode_arrondi` (code de `data/modes_arrondi.csv`) : « 31,25 ⇒ 31 gouttes/min » quand l'arrondi change le résultat.

```bash
python3 scripts/build.py --source produits/_test/src/main.typ --sortie-dir produits/_test/livraison/TEST-EN --inputs produits/_test/donnees/entrees-en.json
python3 scripts/build.py --source produits/_test/src/main.typ --sortie-dir produits/_test/livraison/TEST-FR --inputs produits/_test/donnees/entrees-fr.json
```

## Erreurs fréquentes

| Message | Cause | Que faire |
|---|---|---|
| `N point(s)-virgule(s) avalé(s) dans la source Typst` | `;` collé après `#fonction(…)` dans le texte | écrire `\;` comme le propose la ligne `correction` (règle producteur 16) |
| `la marque MARQUE_FR n'a pas de nom … décision ouverte : D01` | nom de marque FR vide dans `data/marques.csv` | trancher D01, puis renseigner `marques.nom` |
| `colonne « pages_max » absente de data/produits.csv` (ou `version` dans `variantes.csv`) | colonne pas encore ajoutée | l'orchestrateur ajoute la colonne (voir le compte rendu R00) |
| `source Typst introuvable : produits/<CODE>/src/main.typ` | le produit n'a pas encore de source | production du produit |
| `[a4] compilation Typst en échec : … panicked with: charte : …` | jeton, mention, format ou langue inconnus | voir le message de la charte ; corriger la donnée dans `data/` |
| `avertissement(s) Typst (traités comme des erreurs) : unknown font family` | police hors de `charte/polices` | utiliser les polices de la charte ; ne jamais réactiver les polices système |
| `ÉCHEC nb sans couleur` | couleur écrite en dur dans la source (`rgb(…)`, `red`) | passer par les composants ou par `couleur("<rôle>")`, qui suit la palette N&B |
| `ÉCHEC … pages N (max M)` | contenu trop long pour le produit | resserrer le contenu, ou faire corriger `pages_max` dans la table |
| `ÉCHEC … débordement` | mot hors de la zone de texte (tableau trop large, `box` de largeur fixe) | colonnes en `1fr`, texte plus court |
| `réglage « controle_… » introuvable` | paramètre de contrôle absent de `data/parametres.csv` | l'orchestrateur ajoute les paramètres du compte rendu R00 |

`AVERTISSEMENTS_ADMIS` dans `build.py` peut lister des avertissements Typst à tolérer (motif et justification). Cette liste est vide aujourd'hui.
