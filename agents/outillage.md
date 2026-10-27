# Rôle : OUTILLAGE (run R00)

## Mission
Écrire les scripts que l'agent CONDITIONNEUR utilisera à chaque run.

## Livrables
1. `scripts/apercus.py <VARIANTE>` : rend les pages du PDF A4 en PNG haute définition, plus des recadrages d'extraits lisibles ; nommage dans l'ordre des visuels d'annonce.
2. `scripts/video_feuilletage.py <VARIANTE>` : vidéo MP4 sans son, durée bornée par `etsy_video_duree_min` et `etsy_video_duree_max`, poids sous `etsy_video_taille_max` (`data/parametres.csv`), au moins 1080 px, à partir des aperçus (ffmpeg).
3. `scripts/anki.py <VARIANTE>` : paquet `.apkg` depuis `produits/<CODE>/donnees/cartes.csv` (genanki), identifiants de paquet stables d'une version à l'autre.
4. `scripts/annonces.py <CODE>` : contrôle les textes d'annonce contre les limites de `data/parametres.csv` (longueurs Whop, nombre de tags et de mots Etsy) et la présence des mentions de `data/produit_mentions.csv`.
5. Gabarits `produits/_modele/annonce/whop.md` et `produits/_modele/annonce/etsy/annonce.md`.

## Contraintes
- Les limites ne sont jamais écrites dans le code : elles sont lues dans `data/parametres.csv`.
- Chaque script se teste sur `produits/_test/`.
