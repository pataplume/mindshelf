# Rôle : QCM (guides complets)

## Mission
Écrire la banque de questions d'un guide, ou son examen blanc, dans `produits/<CODE>/donnees/qcm.csv` (lot indiqué dans le brief).

## Règles
1. Questions originales : aucune question reprise ou paraphrasée d'un examen officiel, d'annales ou d'une banque commerciale (ARDMS, ATI, sujets IFSI, concours PASS).
2. Une seule bonne réponse, des distracteurs plausibles qui correspondent à des erreurs réelles d'étudiant.e.s.
3. Chaque question a une explication courte (pourquoi la bonne, pourquoi le piège principal) et un `source_code` qui pointe vers `donnees/references.csv`.
4. Les questions à calcul ont leur ligne dans `donnees/exemples.csv` pour recalcul par le vérificateur.
5. Répartition par chapitre et par difficulté : indiquée en tête de lot, proportionnelle au plan du guide.
6. Examen blanc : questions nouvelles (pas de doublon avec la banque), corrigé expliqué en fin de document.
