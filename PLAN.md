# Plan d'action

## 1. Ce qu'on construit

Le catalogue complet est dans `docs/CATALOGUE.md` (généré depuis `data/produits.csv`, `variantes.csv`, `compositions.csv`).

- **Anglophone (MindShelf)** : les fiches existantes passées à la nouvelle charte, de nouvelles fiches (échographie SPI, valeurs de labo, TEAS 7, anatomie-physiologie, ECG, gaz du sang), un kit Nursing Essentials et deux guides complets (SPI, TEAS 7 Science).
- **Francophone (marque FR)** : fiches IFSI (calculs de doses, stage, biologie, pharmacologie) et leur kit, fiches PASS/LAS (physique-biophysique, chimie, biostatistiques) et deux guides complets (cahier de calculs de doses, physique-biophysique PASS).
- **Référentiel infirmier** : chaque produit IFSI existe en deux variantes, référentiel 2009 et référentiel 2026 (`data/variantes.csv`, `data/referentiels.csv`).
- **Formats livrés** pour chaque variante : PDF A4, PDF US Letter, PDF noir et blanc, PDF tablette, paquet Anki, aperçus, vidéo de feuilletage, script de tournage iPhone, annonce Whop et, si le produit y a droit, paquet d'annonce Etsy (`data/types_livrable.csv`).

## 2. Découpage en runs

Le détail est dans `docs/PLAN-RUNS.md` (généré depuis `data/runs.csv`, `run_taches.csv`, `run_dependances.csv`, `phases.csv`).

Un run regroupe quelques produits indépendants. Il ne sert pas à valider le marché avant d'investir : tous les runs s'enchaînent. Il sert à garder chaque bloc de travail court, reprenable et vérifiable, au lieu d'une session de plusieurs heures avec beaucoup d'agents et donc beaucoup de points de panne.

Un run se déroule en quatre phases, dont la durée cible est dans `data/phases.csv` :

| Phase | Ce qui se passe |
|---|---|
| Préparation | Claude publie sur Whop ce que tu as validé depuis le run précédent, vérifie les dépendances et les décisions bloquantes |
| Production | Des agents producteurs travaillent en parallèle, un produit ou un lot chacun (plafond dans `data/parametres.csv`) |
| Vérification | Un agent vérificateur, qui n'a pas vu la production, recalcule chaque exemple par script et contrôle chaque affirmation contre les sources |
| Conditionnement | Un agent produit aperçus, vidéo, Anki, annonces et script iPhone ; Claude met à jour les tables, commit, push et t'envoie les PDF à relire |

Ta validation se fait hors run, quand tu veux. Le déroulé exact côté Claude est dans `runs/RUNBOOK.md`.

## 3. Circuit de révision

Chaque variante passe par les étapes de `data/revue_etapes.csv`, enregistrées dans `data/revues.csv` :

1. **Vérification indépendante** (agent) : toujours. Un point bloquant renvoie le produit en correction.
2. **Relecture métier** (une personne du domaine santé) : pour les produits marqués `relecture_metier = oui`.
3. **Validation** (toi) : toujours, avec `docs/validation.md`. Rien n'est publié sans elle.

Les corrections demandées deviennent des tâches ajoutées au run suivant.

## 4. Livraison

- **Whop** : publication automatique par Claude au début du run qui suit ta validation (fichiers, prix de `data/produits.csv`, texte de l'annonce). Les fiches Whop existantes sont remplacées par leurs nouvelles versions (`data/whop_existants.csv`).
- **Etsy** : publication manuelle par toi, à partir des paquets prêts, à un rythme plafonné (`data/parametres.csv`). Un produit à risque IA fort ne va sur Etsy que si tu as écrit sa méthode toi-même (`data/risques_ia.csv`, décision D04).
- **Toi** : chaque fin de run, Claude t'envoie les PDF à relire. Tout est aussi dans le dépôt GitHub.

## 5. Conformité

Règles Etsy sur l'IA, droits d'auteur, marques déposées, avertissements médicaux : `docs/conformite.md`. Les mentions à afficher par produit sont dans `data/produit_mentions.csv`.

## 6. Budget

`docs/BUDGET.md`, calculé depuis `data/budget.csv`, `frais_canaux.csv` et `depenses.csv`, comparé au plafond de `data/parametres.csv`.

## 7. Décisions à prendre

Listées en tête de `docs/PLAN-RUNS.md` (table `data/decisions.csv`). Un run qui dépend d'une décision ouverte n'est pas lançable.

## 8. Hors périmètre pour l'instant

- Contenus TikTok et Instagram : prévus plus tard, dans des runs dédiés.
- Produits Whop hors plan (Pre-Med pack, Betting, Futures) : décision D06.
