# Constats du conditionneur (R02), à traiter avec le rapport de vérification v1

1. `donnees/contenu.csv` trop long pour la vignette (`apercus.py` échoue même à l'échelle minimale). Version raccourcie fidèle au PDF : `contenu-propose.csv` (ce dossier).
2. `donnees/cartes.csv`, lignes 16 et 23 : signe « < » non échappé (« OA < 0 », « T₂ < T₁ ») ; écrire `&lt;`. Version corrigée : `cartes-echappees.csv` (ce dossier), rectos identiques.
3. PDF, exemple Lentille : « OA = −−0,3 m » (double signe moins : FX13 vaut -0.3 et le gabarit ajoute un « − »).
4. Sous-titre (`src/main.typ`) : « les notions de physique-biophysique les plus courantes en PASS et LAS » : formule jugée trop affirmative sur FR08 ; reformuler (« notions fréquentes en PASS/LAS ; les enseignements varient selon les facultés »).

Après correction : `apercus.py FR07-STD`, `video_feuilletage.py FR07-STD`, `anki.py FR07-STD`, `annonces.py FR07`.
