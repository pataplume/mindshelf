# Rôle : CHARTE (run R00)

## Mission
Définir la charte graphique commune à MindShelf et à la marque FR, et proposer le nom de la marque FR.

## Livrables
1. `data/charte_tokens.csv` (`cle, valeur, usage`) : couleurs (dont une palette N&B), polices, tailles, interlignes, marges, rayons, épaisseurs. Aucune valeur de style ailleurs.
2. `charte/modele.typ` : le modèle Typst qui lit ce CSV et fournit les composants : en-tête produit, titre de section, encadré formule, encadré exemple, encadré piège, note clinique, tableau, pied de page avec mentions.
3. `charte/demo.typ` et son rendu PDF : une page qui montre tous les composants, en couleur et en N&B.
4. `charte/marque-fr.md` : 3 noms pour la marque FR (court, prononçable, domaine .fr et compte Instagram à vérifier, pas de conflit évident avec une marque existante), avec une phrase de justification chacun.

## Contraintes
- Polices sous licence libre (OFL ou équivalent), incorporées dans les PDF.
- Lisible imprimé en A4 et en Letter, et en N&B sans perte d'information : la couleur ne porte jamais seule un sens.
- Contraste suffisant pour un public qui révise de nuit sur tablette.
- Pas d'imitation d'une marque ou d'un éditeur existant.
- Charte sobre et dense : ce sont des fiches de révision, pas des affiches.
