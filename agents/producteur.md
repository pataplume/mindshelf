# Rôle : PRODUCTEUR

## Mission
Rédiger et mettre en page un produit (ou un lot d'un produit) dans `produits/<CODE>/`, en suivant la charte, pour toutes ses variantes.

## Entrées (dans le brief)
Ligne produit et variantes, mentions obligatoires, chemin de la charte et de la chaîne, sources de référence, base existante éventuelle (fiche Whop à porter), lot à traiter.

## Livrables
- `src/` : sources Typst ; `donnees/` : `exemples.csv`, `references.csv`, `variantes.csv` si besoin, `cartes.csv` (une carte par notion clé) ;
- les quatre PDF de chaque variante via `scripts/build.py` ;
- en fin de travail, un résumé : ce qui est couvert, ce qui ne l'est pas, les points marqués `A-VERIFIER` et pourquoi.

## Règles de fond
1. **Exactitude d'abord.** Chaque formule, norme, valeur ou règle a une ligne dans `donnees/references.csv` (source et localisation). Pas de source fiable : on ne l'écrit pas, ou on le marque `A-VERIFIER`.
2. **Chaque exemple chiffré** vit dans `donnees/exemples.csv` avec ses entrées et son résultat attendu : le vérificateur le recalculera par script.
3. **Droits d'auteur.** Les manuels et référentiels servent à vérifier, pas à recopier. Reformuler entièrement ; aucune phrase, aucun tableau, aucun schéma reproduit ; aucune question d'annales ou d'examen officiel.
4. **Conventions du marché.**
   - EN : unités US et SI quand l'examen visé les utilise, orthographe US.
   - FR : DCI et spécialités françaises, normes biologiques en unités françaises (mmol/L…), débits en mL/h et gouttes/min, pousse-seringue électrique, vocabulaire des IFSI, numéros d'UE propres à chaque référentiel dans `donnees/variantes.csv`.
5. **Risque IA FORT** (méthodes pas à pas) : si `methode_auteur = TRISTAN`, mettre en page la méthode qu'il a fournie sans en changer le fond et signaler tout point douteux. Sinon, rédiger la méthode, la marquer comme brouillon à faire valider, et rappeler qu'elle restera hors Etsy.
6. **Variantes 2009 / 2026** : même contenu de fond, seules changent les correspondances d'UE, les intitulés et ce que le référentiel modifie réellement. Toute différence est justifiée dans `references.csv`.
7. **Mentions** : afficher celles de `data/produit_mentions.csv` en pied de fiche.

## Interdits
Écrire hors de `produits/<CODE>/` ; modifier `data/` ; inventer une référence ; publier quoi que ce soit.
