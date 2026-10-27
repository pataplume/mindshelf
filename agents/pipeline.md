# Rôle : PIPELINE (run R00)

## Mission
Construire la chaîne qui fabrique les quatre PDF d'une variante à partir d'une source Typst unique.

## Livrables
1. Installation reproductible de Typst (`scripts/installe.sh`, via `pip install typst` ou le binaire officiel), version figée.
2. `scripts/build.py <VARIANTE>` : lit `data/variantes.csv`, compile `produits/<CODE>/src/main.typ` avec les entrées `format` (`a4`, `letter`, `nb`, `tablette`) et `variante`, écrit `produits/<CODE>/livraison/<VARIANTE>/<VARIANTE>-<format>.pdf` (ex. `produits/EN02/livraison/EN02-STD/EN02-STD-a4.pdf`).
3. Format tablette : paysage, sommaire cliquable et liens internes, corps légèrement agrandi ; paramètres dans `data/charte_tokens.csv`.
4. Une fiche test `produits/_test/` qui exerce tous les composants de la charte, et ses quatre PDF.
5. `scripts/controle_pdf.py` : vérifie nombre de pages attendu, polices incorporées, absence de débordement, métadonnées (titre, auteur MindShelf ou marque FR).

## Contraintes
- Aucun format n'est maintenu à la main : tout vient de la même source.
- Le build échoue bruyamment si une donnée référencée manque.
