# Script vidéo iPhone : FR02 Pack stage IFSI (constantes, échelles, transmissions, précautions)

Adapté de `docs/script-video-iphone.md` (matériel, réglages iPhone : voir le modèle). Durée cible : **12 s environ**, entre 5 et 15 s (`etsy_video_duree_min` / `etsy_video_duree_max`), sans son : la vidéo doit se comprendre muette.

**Tournage seulement après la relecture de l'infirmière** (`donnees/statut-methode.md`) : si la fiche change, réimprimer la version corrigée. FR02 a droit à Etsy (risque IA FAIBLE) : la vidéo va sur Whop et sur Etsy, en deuxième vidéo après `video/feuilletage.mp4`.

## À imprimer
- `livraison/FR02-2026/FR02-2026-a4.pdf`, pages 1 et 2, **en couleur**, **recto verso** sur une seule feuille A4 mat, à 100 % (pas « ajuster à la page »). La version 2026 est celle des aperçus et du feuilletage ; la version 2009 ne diffère que par la ligne d'UE en tête.
- Facultatif : l'iPad avec `livraison/FR02-2026/FR02-2026-tablette.pdf` ouvert, pour un plan de fin.

## Extrait filmé en gros plan
**L'encadré vert « Exemple — Calcul du score »** de la rubrique 3 « Score de Glasgow » (page 1, colonne de gauche, vers le bas de la page) : « Yeux à la demande (3), réponse confuse (4), localise la douleur (5) : 3 + 4 + 5 = 12, à noter Y3 V4 M5 ». Le geste relie le tableau de cotation, juste au-dessus, à l'exemple : les trois lignes cotées 3, 4 et 5, puis la somme.
Repli si la mise au point peine : au verso, l'encadré « Premiers soins, tout de suite (INRS) » de la rubrique 8 (page 2, en haut à gauche).

Ne pas surligner les repères de la rubrique 1 (FC, FR, SpO₂, température) ni les libellés du Glasgow tant qu'ils restent signalés à confirmer par la relectrice (`statut-methode.md`, points 1 et 2).

## Plan continu
| Temps | Plan | Geste |
|---|---|---|
| 0–2 s | Vue de dessus, le recto entier dans le cadre ; le titre et les rubriques 1 à 7 lisibles d'ensemble | Une main pose la fiche bien droite au centre |
| 2–5 s | Rapprochement lent vers le bas de la colonne de gauche, rubrique 3 « Score de Glasgow » | Approcher le téléphone, sans zoomer au doigt |
| 5–9 s | Gros plan : les lignes « 3 À la demande ou au bruit », « 4 Confuse », « 5 Localise la douleur », puis l'encadré « Exemple » | La pointe du surligneur descend sur les trois lignes, puis surligne « 3 + 4 + 5 = 12 » |
| 9–12 s | Léger recul, la feuille de nouveau entière | Retourner la feuille : le verso montre la rubrique 8 « Accident d'exposition au sang (AES) » |

Avant d'enregistrer : appui long sur la feuille pour verrouiller AE/AF, puis baisser un peu l'exposition (le papier blanc brûle vite ; les fonds pâles des encadrés et des lignes du tableau disparaissent vite).

## Après
1. App Photos › Modifier : couper le début et la fin (rester sous 15 s) ; couper le son.
2. Faire la prise deux ou trois fois et garder la plus nette : « 3 + 4 + 5 = 12 » et « Y3 V4 M5 » doivent se lire sur l'écran de l'iPhone.
3. Exporter sous `video/iphone.mp4`, puis l'ajouter en dernière ligne de la section « Visuels » de `annonce/etsy/annonce.md` et relancer `python3 scripts/annonces.py FR02`. Dépôt sur Whop et Etsy uniquement une fois la relecture faite.
4. Rien d'autre dans le champ que la fiche, la main, le surligneur et l'iPad.
