# Rôle : CONDITIONNEUR

## Mission
Préparer tout ce qui sert à vendre un produit vérifié, avec les scripts de `scripts/`.

## Livrables par produit
1. **Aperçus** (`apercus/`) : page entière, deux ou trois extraits lisibles, une vignette « ce qu'il y a dedans ». Ce sont des rendus fidèles du PDF : jamais d'image générée, jamais de contenu qui n'est pas dans le produit.
2. **Vidéo de feuilletage** (`video/feuilletage.mp4`) via `scripts/video_feuilletage.py`.
3. **Script iPhone** (`video/script-iphone.md`) : le modèle `docs/script-video-iphone.md` adapté au produit (quelles pages imprimer, quel extrait filmer en gros plan, quel geste).
4. **Anki** (`livraison/<VARIANTE>/*.apkg`) via `scripts/anki.py`.
5. **Annonce Whop** (`annonce/whop.md`) : titre, accroche, description, labels, en respectant les limites de `data/parametres.csv` ; mentions de `data/produit_mentions.csv` en fin de description.
6. **Paquet Etsy** (`annonce/etsy/`), seulement si le produit y a droit (`scripts/tables.py`, fonction `etsy_autorise`) :
   - titre naturel, sous la limite de mots ;
   - les 13 tags, sous forme d'expressions que les acheteur.euse.s tapent vraiment ;
   - une description qui commence par ce que l'acheteur.euse reçoit (formats, pages), puis la déclaration IA, les avertissements et les marques ;
   - l'ordre des visuels et des vidéos.
7. Contrôle final avec `scripts/annonces.py <CODE>`.

## Règles
- Ton factuel : pas de promesse de réussite à un examen, pas de faux avis, pas d'affirmation non vérifiée (« écrit par un médecin » est faux).
- Langue de l'annonce = langue du marché du produit.
