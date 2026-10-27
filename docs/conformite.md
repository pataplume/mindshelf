# Conformité

Sources citées : `data/sources.csv`. Seuils et limites : `data/parametres.csv`.

## 1. Etsy et l'IA (règles du 22 octobre 2026, `SRC_ETSY_IA`)

| Règle Etsy | Application ici |
|---|---|
| Déclarer dans la description tout produit créé avec l'aide de l'IA | Mention `IA_REDACTION_ASSISTEE` sur tous les produits (`data/produit_mentions.csv`) |
| Instructions fonctionnelles générées par IA interdites (guides qui disent comment accomplir une tâche) | Produits classés `FORT` dans `data/risques_ia.csv` : hors Etsy tant que la méthode n'est pas écrite par Tristan (`methode_auteur`) |
| Chaque article doit recevoir une intervention humaine individuelle ; génération de masse interdite | Validation produit par produit (`data/revues.csv`) ; publication Etsy manuelle par Tristan, plafonnée par semaine |
| Images fidèles ; les produits numériques montrent des aperçus ou extraits de ce que reçoit l'acheteur.euse (`SRC_ETSY_IMAGES`) | Aperçus = rendus des PDF livrés, jamais d'images générées |
| Retraits et fermeture de boutique possibles en cas de violations répétées | Preuves d'auteur conservées : historique Git, rapports de vérification, lignes de revue datées |

## 2. Vidéos d'annonce Etsy (`SRC_ETSY_VIDEO`)

Durée, poids et nombre par annonce : paramètres `etsy_video_*`. Le son est supprimé par Etsy : aucune information ne passe par la voix. Une vidéo de feuilletage générée par code, et éventuellement une vidéo iPhone (`docs/script-video-iphone.md`).

## 3. Droits d'auteur

- Référentiels, manuels et cours servent à **vérifier** le contenu, jamais à le recopier : aucune phrase, aucun tableau, aucun schéma reproduit.
- Aucune question d'annales, d'examen officiel (ARDMS, ATI, NCSBN, concours PASS/LAS, évaluations IFSI) ni de banque commerciale, même reformulée.
- Aucun logo, aucune couverture ni capture d'un ouvrage tiers dans les visuels ou les vidéos.

## 4. Marques déposées

MCAT, NCLEX, TEAS, ARDMS/SPI : nommées seulement pour dire à quel examen sert le produit, avec la mention de non-affiliation correspondante (`data/mentions.csv`). Jamais dans le nom de la boutique ni de la marque.

## 5. Contenu santé

- Avertissements `AVERT_REVISION` partout, `AVERT_CLINIQUE` sur tout produit clinique.
- Relecture métier obligatoire là où `relecture_metier = oui`.
- Aucune promesse de réussite, aucun faux avis, aucune qualification affichée qui ne soit pas exacte et validée par Tristan.

## 6. Whop

- Chaque litige coûte des frais fixes, gagné ou perdu (`data/frais_canaux.csv`, `SRC_WHOP_LITIGES`), et un taux de litiges élevé expose le compte.
- Les petits prix attirent le test de cartes volées : surveiller les paiements refusés ou bloqués après chaque mise en ligne. La fiche à 1,99 $ ciblée par ces tests est masquée (produit et variante) depuis le 27.10.2026 (`data/whop_existants.csv`).
