# Outils de conditionnement

Scripts utilisés par l'agent CONDITIONNEUR (`agents/conditionneur.md`). Chacun s'appelle avec un code (résolution des chemins par `data/variantes.csv` et `data/produits.csv`) ou, pour les tests, avec des chemins explicites. Toute erreur s'affiche en une phrase et donne le code de sortie 1.

Ordre d'un run : `apercus.py` → `video_feuilletage.py` → `anki.py` → rédaction des annonces → `annonces.py`.

## `apercus.py <VARIANTE>`
Rend chaque page de `livraison/<VARIANTE>/<VARIANTE>-a4.pdf` en PNG (`apercus/01-page-1.png`, …), puis les extraits de `donnees/extraits.csv` (`ordre,page,x_pct,y_pct,l_pct,h_pct,libelle`, en % de la page depuis le coin haut gauche ; sans ce fichier : haut et bas de la page 1), puis la vignette « ce qu'il y a dedans » si `donnees/contenu.csv` (`ordre,element`) existe. La vignette n'affiche que le titre du produit, la liste des éléments et la page 1 : n'y écrire que ce que contient le PDF. Une liste longue est réduite automatiquement (jusqu'à `apercu_vignette_echelle_min`) ; au-delà, le script échoue : raccourcir `contenu.csv`. Toutes les proportions de la vignette (marge, tailles, espacements, puces, cadre, résolution de travail) sont des réglages `apercu_vignette_*` de `data/parametres.csv` ; la vignette est compilée avec les seules polices de `charte/polices/` (échec si le dossier manque).
Direct : `--pdf f.pdf --sortie dossier/ [--extraits e.csv] [--contenu c.csv --langue en --titre "…"]`.

## `video_feuilletage.py <VARIANTE>`
Construit `video/feuilletage.mp4` à partir des aperçus (pages, au plus `video_pages_max`, puis extraits ; pas la vignette) : léger zoom, fondu par le fond, MP4 H.264 yuv420p sans audio. Vise le milieu de [`etsy_video_duree_min`, `etsy_video_duree_max`] ; ffprobe contrôle ensuite durée, poids, définition, codec et absence d'audio, et la vidéo est supprimée si un point échoue.
Direct : `--apercus dossier/ --sortie f.mp4`.

## `anki.py <VARIANTE>`
Écrit `livraison/<VARIANTE>/<VARIANTE>.apkg` depuis `donnees/cartes.csv` (`recto,verso,tags` ; tags séparés par des espaces ; HTML simple : b, i, u, sub, sup, br, listes, tableaux ; écrire `&lt;` pour un signe <). Paquet nommé d'après le titre du produit ; identifiants de paquet et de modèle tirés du code de variante, GUID tiré du recto : réimporter une nouvelle version met les cartes à jour au lieu de les dupliquer. Ne pas changer un recto sans raison : la carte serait vue comme nouvelle.

Nombres tirés des tables (aucun nombre tapé en dur qui pourrait diverger de la fiche) : `{v:CLE}` (valeur de `donnees/valeurs.csv`, colonne `valeur` ou `mantisse`, plus `× 10<sup>n</sup>` si `exposant` est rempli), `{x:ID}` (résultat affiché de `donnees/exemples.csv` : arrondi à `arrondi` décimales selon `mode_arrondi`, zéros finaux selon `anki_zeros_finaux`), `{xe:ID}` (résultat exact, tel qu'écrit). Formatage selon la langue (jetons `nombre.*` de la charte). Un marqueur inconnu (tout `{type:…}` d'un autre type), une clé ou un exemple absents : échec, avec la ligne fautive. Les tables ne sont lues qu'au premier marqueur : un `cartes.csv` sans marqueur donne le même paquet qu'avant. Le GUID reste tiré du recto source, marqueurs compris. Détails : `produits/_modele/README.md`.
Direct : `--cartes c.csv --sortie f.apkg --cle <VARIANTE> --nom "…" [--langue en] [--donnees dossier/]` (`--donnees` : dossier de `valeurs.csv` et `exemples.csv`, par défaut celui de `--cartes`).

## `annonces.py <CODE>`
Contrôle `annonce/whop.md` et, si le produit a droit à Etsy (`etsy_autorise`), `annonce/etsy/annonce.md` (sinon, le dossier `annonce/etsy/` entier ne doit pas exister) : sections attendues dans l'ordre, longueurs, nombre de tags, caractères admis par Etsy, visuels existants, et présence mot pour mot de chaque mention du produit dans la langue de son marché. Gabarits commentés : `produits/_modele/annonce/`.
Direct : `--dossier d/ --langue en --mentions A,B --etsy oui|non`.

## Réglages
- Limites métier : `data/parametres.csv`, lues par `tables.param` (via `outillage_commun.reglage`).
- `data/parametres.csv` : réglages techniques de ces outils (définitions, cadence, zoom, couleurs…) et limites Etsy relevées le 27.10.2026 (titre, images par annonce, caractères admis selon l'API Etsy v3). Une valeur `charte:<jeton>` renvoie à `data/charte_tokens.csv`.
- `data/modes_arrondi.csv` (`code,methode,libelle`) : modes d'arrondi, `1` au plus proche, `2` par défaut, `3` par excès. Les tables et les sources ne citent que le code ; les outils ne connaissent que la `methode`. Réglage `arrondi_mode_defaut` : mode appliqué quand `mode_arrondi` est vide. Convention complète : `produits/_modele/README.md`.
- `anki_tableau_trait`, `anki_cellule_marge` : CSS des tableaux dans les cartes ; `anki_zeros_finaux` : zéros finaux du marqueur `{x:ID}` (0 = retirés, règle ISMP).
- `data/libelles_outillage.csv` : textes affichés par les outils, par langue (rubrique de la vignette, noms des champs Anki).
- `scripts/gabarits/vignette_contenu.typ` : mise en page de la vignette ; polices chargées depuis `charte/polices/`.

## Banc d'essai
`python3 produits/_outillage-test/prepare.py` régénère un PDF factice de 2 pages (polices de la charte seules, comme `build.py`) et exerce les quatre scripts en mode direct (mentions et droit à Etsy empruntés à EN02). Il lance aussi des tests négatifs dans un dossier temporaire : double signe moins (`controle_pdf.doubles_moins` doit trouver « −−0,3 » et « --2 », et rien dans le texte correct), marqueurs `{x:…}` et `{xe:…}` remplacés depuis les tables de la fiche test, marqueurs inconnus ou clés absentes refusés par `anki.py`. Ce dossier n'est pas un produit et n'est jamais publié.

## Dépendances
`bash scripts/installe.sh` (voir `scripts/README-pipeline.md`) : installe les versions figées de typst, genanki, pypdf et Pillow, et vérifie pdftoppm (poppler), ffmpeg/ffprobe avec l'encodeur libx264 et les polices de la charte.
