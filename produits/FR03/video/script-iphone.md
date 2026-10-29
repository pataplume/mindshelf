# Script vidéo iPhone : FR03 Bilan biologique — normes françaises

Adapté de `docs/script-video-iphone.md` (matériel, réglages iPhone : voir le modèle). Durée cible : **10 s environ**, entre 5 et 15 s (`etsy_video_duree_min` / `etsy_video_duree_max`), sans son : la vidéo doit se comprendre muette.

**Tournage seulement après la relecture de la médecin stagiaire** (`donnees/statut-methode.md`) : si la fiche change, réimprimer la version corrigée. FR03 a droit à Etsy (risque IA FAIBLE) : la vidéo va sur Whop et sur Etsy, en deuxième vidéo après `video/feuilletage.mp4`.

## À imprimer
- `livraison/FR03-2026/FR03-2026-a4.pdf`, page 1 (la seule), **en couleur**, sur A4 mat, à 100 % (pas « ajuster à la page »). La version 2026 est celle des aperçus et du feuilletage ; la version 2009 ne diffère que par la ligne d'UE en tête.
- Facultatif : l'iPad avec `livraison/FR03-2026/FR03-2026-tablette.pdf` ouvert sur la page 2 (groupe « INR sous AVK : cible fixée par le prescripteur » à gauche, « Repères infirmiers » à droite), pour le plan de fin.
- La fiche tient sur une seule face : ne pas la retourner (le verso est blanc).

## Extrait filmé en gros plan
**La ligne « Glucose »** du tableau « Valeurs usuelles de l'adulte » (colonne de gauche, un peu au-dessus du tiers supérieur de la page : 3,90–5,50 mmol/L, autre écriture 0,70–1,00 g/L), puis, à la même hauteur dans la colonne de droite, l'encadré rouge **« Piège — Même examen, deux unités »**. Le geste relie les deux : la même valeur écrite dans deux unités, puis le piège qui le dit.
Repli si la mise au point peine : l'encadré violet « Note clinique — INR sous AVK » (colonne de droite, un peu au-dessus des deux tiers de la page), qui dit que la cible est fixée par le prescripteur.

Ne pas surligner la ligne « Potassium » ni les autres valeurs signalées à confirmer par la relectrice (`statut-methode.md`, point 1) tant que la relecture n'est pas faite.

## Plan continu
| Temps | Plan | Geste |
|---|---|---|
| 0–2 s | Vue de dessus, la page entière dans le cadre ; le titre et l'encadré rouge du haut « Les valeurs usuelles varient selon les laboratoires » lisibles | Une main pose la fiche bien droite au centre |
| 2–5 s | Rapprochement lent vers le tableau de gauche, groupe « Glucose » | Approcher le téléphone, sans zoomer au doigt |
| 5–9 s | Gros plan : la ligne « Glucose » puis l'encadré « Même examen, deux unités » à droite | Le surligneur passe sur « 0,70–1,00 g/L », puis la pointe glisse vers l'encadré rouge |
| 9–11 s | Léger recul, la page de nouveau entière | Faire glisser l'iPad (version tablette, page 2) dans le champ, ou simplement s'arrêter sur la page |

Avant d'enregistrer : appui long sur la feuille pour verrouiller AE/AF, puis baisser un peu l'exposition (le papier blanc brûle vite ; les fonds pâles des encadrés et des lignes du tableau disparaissent vite).

## Après
1. App Photos › Modifier : couper le début et la fin (rester sous 15 s) ; couper le son.
2. Faire la prise deux ou trois fois et garder la plus nette : « 3,90–5,50 mmol/L » et « 0,70–1,00 g/L » doivent se lire sur l'écran de l'iPhone.
3. Exporter sous `video/iphone.mp4`, puis l'ajouter en 7e ligne de la section « Visuels » de `annonce/etsy/annonce.md` et relancer `python3 scripts/annonces.py FR03`. Dépôt sur Whop et Etsy uniquement une fois la relecture faite.
4. Rien d'autre dans le champ que la fiche, la main, le surligneur et l'iPad.
