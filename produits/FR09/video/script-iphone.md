# Script vidéo iPhone : FR09 PASS/LAS Biostatistiques — fiche formules

Adapté de `docs/script-video-iphone.md` (matériel, réglages iPhone et « Après » : voir le modèle). Durée cible : **10 s environ**, entre 5 et 15 s (`etsy_video_duree_min` / `etsy_video_duree_max`), sans son : Etsy le coupe.

## À imprimer
- `livraison/FR09-STD/FR09-STD-a4.pdf`, page 1 (la seule), **en couleur**, sur A4 mat, à 100 % (pas « ajuster à la page »).
- Facultatif : l'iPad avec `livraison/FR09-STD/FR09-STD-tablette.pdf` ouvert sur la page 1, pour le plan de fin.
- La fiche tient sur une seule face : ne pas la retourner (le verso est blanc).

## Extrait filmé en gros plan
**Section « Tests diagnostiques »**, colonne de gauche, un peu sous le milieu de la page : le tableau 2 × 2 (VP, FP, FN, VN), l'encadré des formules (Se, Sp, VPP, VPN, VPP par Bayes), puis l'encadré vert « EXEMPLE Maladie rare » juste en dessous (cadrage de l'aperçu `apercus/02-extrait-tests-diagnostiques.png`).
Repli : l'encadré vert « EXEMPLE Deux moyennes » et la section « Khi-deux » avec son tableau des seuils (colonne du milieu, sous le milieu de la page ; aperçu `apercus/03-extrait-deux-moyennes-et-khi-deux.png`).

## Plan continu
| Temps | Plan | Geste |
|---|---|---|
| 0–2 s | Vue de dessus, la page entière dans le cadre, titre lisible en haut | Une main pose la fiche bien droite au centre |
| 2–5 s | Rapprochement lent vers la colonne de gauche, section « Tests diagnostiques » | Approcher le téléphone, sans zoomer au doigt |
| 5–9 s | Gros plan : le tableau 2 × 2 et la fraction de la VPP, puis l'encadré vert de l'exemple | Le surligneur passe sur « VPP ≈ 27 % » dans l'exemple |
| 9–11 s | Léger recul, la page de nouveau entière | Faire glisser l'iPad (version tablette) dans le champ, ou simplement s'arrêter sur la page |

## Contrôles avant dépôt
- Le gros plan doit rester net : la fraction de la VPP (Se P au numérateur, (1 − Sp)(1 − P) au dénominateur) et les indices (H₀, z_α/2, Tₗ, T_c) se lisent sur l'écran de l'iPhone.
- Le bas de la page est blanc sous les colonnes : cadrer la page entière sans chercher à le remplir.
- Rien d'autre dans le champ que la fiche, la main, le surligneur et l'iPad.
- Exporter sous `video/iphone.mp4`, puis l'ajouter dans `annonce/etsy/annonce.md`, section « Visuels », en 7ᵉ position (deuxième vidéo, après `video/feuilletage.mp4`), et relancer `python3 scripts/annonces.py FR09`.
