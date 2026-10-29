# Runbook — déroulé d'un run (côté Claude, rôle ORCHESTRATEUR)

## 0. Avant de commencer

1. `git pull`, puis `python3 scripts/verifie_tables.py` et `python3 scripts/vues.py`.
2. Choisir le run : celui que Tristan a nommé, sinon le premier de la liste « Lançables maintenant » de `docs/PLAN-RUNS.md`.
3. Si une décision bloquante est ouverte (`data/decisions.csv`), ou une entrée manque (fichiers sources, nom de marque), s'arrêter et le dire à Tristan en une phrase.
4. Passer le run à `EN_COURS` dans `data/runs.csv`. Toute tâche restée `EN_COURS` d'un run interrompu repasse à `A_FAIRE`.

## 1. Préparation

Pour chaque variante au statut `VALIDE` sans ligne `PUBLIE` sur `WHOP` dans `data/publications.csv` :

- créer ou mettre à jour le produit Whop (outil MCP Whop) : titre, accroche et description depuis `produits/<CODE>/annonce/whop.md`, prix depuis `data/produits.csv`, visuels depuis `produits/<CODE>/apercus/`, fichiers depuis `produits/<CODE>/livraison/<VARIANTE>/` ;
- si la variante remplace un produit de `data/whop_existants.csv`, mettre à jour ce produit plutôt que d'en créer un nouveau ;
- écrire la ligne dans `data/publications.csv`, passer la variante et le produit à `PUBLIE`.

Ne jamais publier une variante qui n'est pas `VALIDE`. Ne jamais publier sur Etsy.

## 2. Production

1. Lire les tâches `PRODUCTION` du run dans `data/run_taches.csv`.
2. Lancer en parallèle un agent par tâche (outil Agent, en arrière-plan), dans la limite de `run_agents_production_max`. Le brief de chaque agent contient :
   - le texte intégral de sa fiche de poste (`agents/<role>.md`) ;
   - la ligne de tâche, la ligne produit, ses variantes, ses mentions, ses composants si c'est un kit ;
   - le chemin de la charte et de la chaîne de fabrication ;
   - le dossier où il a le droit d'écrire : `produits/<CODE>/` (sous-dossier `lots/<LOT>/` si la tâche a un lot).
3. À leur retour : tâches à `A_VERIFIER`, `git commit -m "<RUN> production"`.

## 3. Vérification

1. Lancer **un** agent `VERIFICATEUR` neuf, sans lui transmettre les échanges des producteurs : seulement sa fiche de poste, les fichiers produits et les sources.
2. Pour chaque produit, il écrit `produits/<CODE>/verif/rapport-v<N>.md` et classe chaque constat en `BLOQUANT`, `MAJEUR` ou `MINEUR`.
3. Pas de `BLOQUANT` : tâche à `A_VALIDER`, ligne `VERIF_AUTO` dans `data/revues.csv`.
4. `BLOQUANT` : tâche à `A_CORRIGER`. Si le temps du run le permet, relancer une fois le producteur avec le rapport ; sinon ajouter une tâche de correction au run suivant (nouvelle ligne dans `data/run_taches.csv`).
5. `git commit -m "<RUN> vérification"`.

## 4. Conditionnement

1. Lancer un agent `CONDITIONNEUR` pour les produits sans `BLOQUANT`.
2. Mettre à jour `data/livrables.csv` (`python3 scripts/genere_livrables.py`, puis statuts et chemins).
3. `git commit -m "<RUN> conditionnement"`.

## 5. Clôture

1. Statuts : tâches terminées, produits à `A_VALIDER`, run à `A_VALIDER`.
2. `python3 scripts/verifie_tables.py`, `python3 scripts/vues.py`, `git push`.
3. Écrire `runs/journal/<RUN>.md` : produits livrés, constats de vérification, corrections reportées, durée réelle par phase.
4. Envoyer à Tristan, en un seul message : ce qui est prêt à valider, les PDF A4 à relire, les points MAJEURS à regarder en priorité, les produits qui demandent une relecture métier.
5. Si la durée réelle s'écarte nettement des cibles, proposer d'ajuster `data/phases.csv` ou `run_agents_production_max`.

## 6. Après la validation de Tristan

- « <CODE> validé » : lignes `RELECTURE_METIER` (si requise et faite) et `VALIDATION` dans `data/revues.csv`, variantes et produit à `VALIDE`. Publication Whop à la préparation du run suivant, ou tout de suite s'il le demande.
- « <CODE> : corrections … » : produit à `A_CORRIGER`, tâche de correction ajoutée au run suivant avec ses remarques.
- Publication Etsy faite par Tristan : il donne l'URL, Claude écrit la ligne dans `data/publications.csv`.

## Règles permanentes

- Toute action attendue de Tristan (validation, relecture, dépôt, source, réglage) est une ligne de `data/actions_tristan.csv` ; elle passe à `VALIDE` quand c'est fait. La vue `docs/PLAN-RUNS.md` les liste.

- Les tables se modifient par script ou édition ciblée, toujours suivies de `verifie_tables.py`.
- Un agent n'écrit que dans le dossier de son produit ; seul l'orchestrateur touche à `data/`.
- Aucun chiffre ne s'écrit en dur dans un texte : il vit dans une table ou un fichier de données du produit.
- Si l'outil Agent, Whop ou GitHub est indisponible, s'arrêter proprement après le dernier commit et le dire.
