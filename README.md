# MindShelf — atelier de production

Fiches et guides de révision santé, vendus sur Whop et Etsy : en anglais sous MindShelf, en français sous une marque à choisir (décision D01).

## Comment le dépôt est organisé

| Dossier | Contenu | Qui l'écrit |
|---|---|---|
| `data/` | Les tables CSV : **seule source de vérité** (catalogue, prix, runs, tâches, statuts, revues, publications, frais, décisions, paramètres) | Claude pendant les runs, toi pour les décisions |
| `docs/` | Vues lisibles générées depuis les tables (`PLAN-RUNS.md`, `CATALOGUE.md`, `BUDGET.md`) et règles (`conformite.md`, `validation.md`, `script-video-iphone.md`) | Généré / rédigé |
| `agents/` | La fiche de poste de chaque type d'agent | Rédigé |
| `runs/` | `RUNBOOK.md` (déroulé d'un run) et `journal/` (un compte rendu par run) | Claude |
| `produits/<CODE>/` | Sources Typst, données chiffrées, PDF livrés, aperçus, vidéo, Anki, annonces, rapports de vérification | Agents |
| `scripts/` | Contrôle des tables, génération des livrables et des vues, puis chaîne de fabrication (créée au run R00) | Claude |

Aucun chiffre, prix, durée ou date ne vit dans un texte : tout est dans `data/`. Les fichiers de `docs/` marqués « généré » se refont avec les scripts ci-dessous.

## Ce que tu fais, toi

1. **Lancer un run** : dans Claude, « Lance le prochain run » ou « Lance R05 ». La liste des runs lançables est en tête de `docs/PLAN-RUNS.md`.
2. **T'arrêter** : quand tu veux entre deux runs. En plein run, l'état est enregistré (commit) à la fin de chaque phase ; un run interrompu reprend aux tâches non terminées.
3. **Valider** : à la fin d'un run, tu reçois les PDF à relire. Tu suis `docs/validation.md`, puis tu réponds « EN02 validé » ou « EN02 : corrections … ».
4. **Trancher les décisions** ouvertes listées dans `docs/PLAN-RUNS.md`.
5. **Publier sur Etsy** à la main, à partir des paquets prêts dans `produits/<CODE>/annonce/etsy/`.
6. **Tourner les vidéos iPhone** si tu veux, avec le script propre à chaque produit.

## Commandes

```bash
python3 scripts/verifie_tables.py    # intégrité des tables (à lancer après toute modification)
python3 scripts/genere_livrables.py  # complète data/livrables.csv sans écraser les statuts
python3 scripts/vues.py              # régénère docs/PLAN-RUNS.md, CATALOGUE.md, BUDGET.md
```

## Pour commencer

Le plan d'action complet est dans `PLAN.md`.
