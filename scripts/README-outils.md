# Outils de conditionnement

Scripts utilisés par l'agent CONDITIONNEUR (`agents/conditionneur.md`). Chacun s'appelle avec un code (résolution des chemins par `data/variantes.csv` et `data/produits.csv`) ou, pour les tests, avec des chemins explicites. Toute erreur s'affiche en une phrase et donne le code de sortie 1.

Ordre d'un run : `apercus.py` → `video_feuilletage.py` → `anki.py` → rédaction des annonces → `annonces.py`.

## `apercus.py <VARIANTE>`
Rend chaque page de `livraison/<VARIANTE>/<VARIANTE>-a4.pdf` en PNG (`apercus/01-page-1.png`, …), puis les extraits de `donnees/extraits.csv` (`ordre,page,x_pct,y_pct,l_pct,h_pct,libelle`, en % de la page depuis le coin haut gauche ; sans ce fichier : haut et bas de la page 1), puis la vignette « ce qu'il y a dedans » si `donnees/contenu.csv` (`ordre,element`) existe. La vignette n'affiche que le titre du produit, la liste des éléments et la page 1 : n'y écrire que ce que contient le PDF. Une liste longue est réduite automatiquement (jusqu'à `apercu_vignette_echelle_min`) ; au-delà, le script échoue : raccourcir `contenu.csv`.
Direct : `--pdf f.pdf --sortie dossier/ [--extraits e.csv] [--contenu c.csv --langue en --titre "…"]`.

## `video_feuilletage.py <VARIANTE>`
Construit `video/feuilletage.mp4` à partir des aperçus (pages, au plus `video_pages_max`, puis extraits ; pas la vignette) : léger zoom, fondu par le fond, MP4 H.264 yuv420p sans audio. Vise le milieu de [`etsy_video_duree_min`, `etsy_video_duree_max`] ; ffprobe contrôle ensuite durée, poids, définition, codec et absence d'audio, et la vidéo est supprimée si un point échoue.
Direct : `--apercus dossier/ --sortie f.mp4`.

## `anki.py <VARIANTE>`
Écrit `livraison/<VARIANTE>/<VARIANTE>.apkg` depuis `donnees/cartes.csv` (`recto,verso,tags` ; tags séparés par des espaces ; HTML simple : b, i, u, sub, sup, br, listes, tableaux ; écrire `&lt;` pour un signe <). Paquet nommé d'après le titre du produit ; identifiants de paquet et de modèle tirés du code de variante, GUID tiré du recto : réimporter une nouvelle version met les cartes à jour au lieu de les dupliquer. Ne pas changer un recto sans raison : la carte serait vue comme nouvelle.
Direct : `--cartes c.csv --sortie f.apkg --cle <VARIANTE> --nom "…" [--langue en]`.

## `annonces.py <CODE>`
Contrôle `annonce/whop.md` et, si le produit a droit à Etsy (`etsy_autorise`), `annonce/etsy/annonce.md` (qui ne doit pas exister sinon) : sections attendues dans l'ordre, longueurs, nombre de tags, caractères admis par Etsy, visuels existants, et présence mot pour mot de chaque mention du produit dans la langue de son marché. Gabarits commentés : `produits/_modele/annonce/`.
Direct : `--dossier d/ --langue en --mentions A,B --etsy oui|non`.

## Réglages
- Limites métier : `data/parametres.csv`, lues par `tables.param` (via `outillage_commun.reglage`).
- `data/parametres.csv` : réglages techniques de ces outils (définitions, cadence, zoom, couleurs…) et limites Etsy relevées le 27.10.2026 (titre, images par annonce, caractères admis selon l'API Etsy v3). Une valeur `charte:<jeton>` renvoie à `data/charte_tokens.csv`.
- `data/libelles_outillage.csv` : textes affichés par les outils, par langue (rubrique de la vignette, noms des champs Anki).
- `scripts/gabarits/vignette_contenu.typ` : mise en page de la vignette ; polices chargées depuis `charte/polices/`.

## Banc d'essai
`python3 produits/_outillage-test/prepare.py` régénère un PDF factice de 2 pages et exerce les quatre scripts en mode direct (mentions et droit à Etsy empruntés à EN02). Ce dossier n'est pas un produit et n'est jamais publié.

## Dépendances
Aucune installation : pdftoppm (poppler), ffmpeg/ffprobe (libx264), Python avec Pillow, pypdf, genanki et typst, déjà présents.
