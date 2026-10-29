# Structure d'un dossier produit

```
produits/<CODE>/
├── src/                     sources Typst (une seule source pour tous les formats)
│   ├── main.typ             point d'entrée ; lit la charte et les données
│   └── contenu/             sections du produit
├── donnees/
│   ├── exemples.csv         id, enonce, entrees_json, formule, resultat_attendu, unite, tolerance, arrondi[, mode_arrondi]
│   ├── valeurs.csv          constantes et réglages propres au produit (cle ou id, valeur…)
│   ├── references.csv       element, source_code, localisation (page, section, article)
│   ├── variantes.csv        correspondances propres à une variante (ex. numéros d'UE 2009 / 2026)
│   ├── cartes.csv           recto, verso, tags (export Anki ; nombres par marqueurs {v:…}, {x:…})
│   └── qcm.csv              guides seulement : id, question, a, b, c, d, bonne, explication, source_code
├── lots/<LOT>/              travail d'un agent quand la tâche est découpée en lots
├── livraison/<VARIANTE>/    PDF A4, Letter, N&B, tablette et .apkg livrés
├── verif/rapport-v<N>.md    rapports du vérificateur
├── apercus/                 PNG des pages, dans l'ordre des visuels d'annonce
├── video/                   feuilletage.mp4 et script-iphone.md
└── annonce/
    ├── whop.md              titre, accroche, description, labels
    └── etsy/                titre, 13 tags, description, ordre des visuels (si le produit va sur Etsy)
```

Chaque nombre affiché dans une fiche (exemple, norme, constante) provient d'un fichier de `donnees/`, jamais tapé directement dans le Typst.

## Nombres des cartes Anki

Dans `cartes.csv`, un nombre qui figure aussi dans la fiche s'écrit par un marqueur, remplacé par `scripts/anki.py` à la fabrication du paquet :

| Marqueur | Remplacé par |
|---|---|
| `{v:CLE}` | valeur de `donnees/valeurs.csv` (ligne `cle` ou `id` = CLE ; colonne `valeur`, sinon `mantisse` ; si `exposant` est rempli : « × 10<sup>n</sup> ») |
| `{x:ID}` | résultat affiché de l'exemple ID de `donnees/exemples.csv` : `resultat_attendu` arrondi à `arrondi` décimales selon `mode_arrondi` (sans colonne `arrondi` : tel qu'écrit) |
| `{xe:ID}` | résultat exact de l'exemple ID (`resultat_attendu` tel qu'écrit) |

Les nombres sont formatés selon la langue du produit (jetons `nombre.*` de la charte : séparateurs, milliers, signe moins). Un marqueur inconnu, une clé ou un exemple absents font échouer le script. Les cartes sans marqueur ne changent pas. Exemple : `Débit de EX02 ?,{x:EX02} gouttes/min,` donne « 31 gouttes/min » en français.

Le GUID d'une carte reste tiré du recto tel qu'écrit (marqueurs compris) : corriger une valeur dans `valeurs.csv` met la carte à jour dans Anki sans la dupliquer.

## Arrondi d'un résultat (gouttes, doses)

Le mode d'arrondi est un code numérique de `data/modes_arrondi.csv` (`1` = au plus proche, `2` = par défaut, `3` = par excès), jamais un texte dans `valeurs.csv` (une valeur texte casse les scripts de recalcul).

- Pour un exemple : colonnes `arrondi` (nombre de décimales du résultat affiché) et `mode_arrondi` (code) de `exemples.csv`. `mode_arrondi` vide ou absent : `arrondi_mode_defaut` de `data/parametres.csv`.
- Pour tout le produit : une ligne de `valeurs.csv` dont la clé commence par `mode_arrondi` (ex. `mode_arrondi_gouttes,1,,Débit par gravité réglé au plus proche`), lue par le Typst du produit.
- Le Typst lit la méthode dans la table (`csv("/data/modes_arrondi.csv")`, colonne `methode` : `plus_proche`, `defaut`, `exces`) : aucun code écrit en dur. Modèle : `arrondir()` et `aff()` dans `produits/_test/src/main.typ`, qui affichent « 31,25 ⇒ 31 gouttes/min » quand l'arrondi change le résultat.
- `scripts/verifie_tables.py` refuse un code inconnu (colonne `mode_arrondi`, clés `mode_arrondi*` de `valeurs.csv`) et un `arrondi` qui n'est pas un entier positif ou nul.
