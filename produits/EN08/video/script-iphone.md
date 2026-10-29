# Script vidéo iPhone : EN08 Lab Values Cheat Sheet

Adapté de `docs/script-video-iphone.md` (matériel, réglages iPhone et « Après » : voir le modèle). Durée cible : **10 s environ**, entre 5 et 15 s (`etsy_video_duree_min` / `etsy_video_duree_max`), sans son : Etsy le coupe.

**Quand tourner :** après la relecture de la médecin stagiaire et les éventuelles corrections du vérificateur (`donnees/statut-methode.md`), sur le PDF regénéré : une valeur filmée en gros plan doit être celle du PDF vendu.

## À imprimer
- `livraison/EN08-STD/EN08-STD-a4.pdf`, page 1 (la seule), **en couleur**, sur A4 mat, à 100 % (pas « ajuster à la page ») : le tableau est en petit corps, une réduction le rend illisible à l'image.
- Facultatif : l'iPad avec `livraison/EN08-STD/EN08-STD-tablette.pdf` ouvert sur la page 1, pour le plan de fin.
- La fiche tient sur une seule face : ne pas la retourner (le verso est blanc).

## Extrait filmé en gros plan
**Haut du tableau « Adult reference intervals »**, colonne de gauche, juste sous l'encadré rouge du haut : l'en-tête « Test / US conventional / Factor / SI » puis le groupe « Electrolytes » (sodium à phosphore), même cadrage que l'aperçu `apercus/02-extrait-electrolytes.png`.
Repli si la mise au point peine sur les exposants (Na⁺, K⁺) : l'encadré vert « Example — Three conversions », en haut de la colonne de droite, sous « Convert US ↔ SI » (corps plus grand).

## Plan continu
| Temps | Plan | Geste |
|---|---|---|
| 0–2 s | Vue de dessus, la page entière dans le cadre, titre et encadré rouge lisibles en haut | Une main pose la fiche bien droite au centre |
| 2–5 s | Rapprochement lent vers le haut de la colonne de gauche | Approcher le téléphone, sans zoomer au doigt |
| 5–9 s | Gros plan : en-tête du tableau et groupe « Electrolytes » | Le surligneur passe sur la ligne « Potassium (K⁺) », de « 3.5–5.0 mEq/L » à « 3.5–5.0 mmol/L » |
| 9–11 s | Léger recul, la page de nouveau entière | Faire glisser l'iPad (version tablette) dans le champ, ou simplement s'arrêter sur la page |

## Contrôles avant dépôt
- Le gros plan doit rester net : les colonnes US et SI de la ligne surlignée se lisent sur l'écran de l'iPhone.
- Rien d'autre dans le champ que la fiche, la main, le surligneur et l'iPad ; aucun document de patient.e ni résultat de laboratoire réel.
- Exporter sous `video/iphone.mp4`, puis l'ajouter dans `annonce/etsy/annonce.md`, section « Visuels », en 7ᵉ position (deuxième vidéo, après `video/feuilletage.mp4`), et relancer `python3 scripts/annonces.py EN08`.
