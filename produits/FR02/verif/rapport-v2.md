# FR02 — Rapport de contre-vérification v2 (run R05)

**Produit :** FR02 « Pack stage IFSI (constantes, échelles, transmissions, précautions) », marque Clairance, variantes FR02-2009 et FR02-2026, contenu corrigé après `rapport-v1.md` (le pied de page porte encore « v1 », voir N2).
**Vérificateur :** agent VERIFICATEUR R05, 29.10.2026, de 14:56 à 15:03 (environ 7 min). N'a pas participé à la production.
**Périmètre :** les corrections de la v1 et ce qu'elles ont pu casser. Fichiers lus : `src/main.typ`, `donnees/*` (dont `statut-methode.md`), les 8 PDF et les 2 `.apkg` de `livraison/`, `annonce/whop.md` et `annonce/etsy/annonce.md` (exactitude des promesses seulement). Ce n'est pas une nouvelle vérification complète.

## Verdict : **OK avec réserves**

**0 BLOQUANT. 3 MAJEURS à corriger avant l'envoi à la relectrice (C1 à C3), 6 MAJEURS qui attendent la décision de la relectrice, 6 MINEURS.**

- **Les deux bloquants v1 sont levés.** B1 : l'ordre « alerter d'abord » est sûr, et la fiche, la carte Anki et les deux `.apkg` ont le même texte. B2 : le tableau Air / Gouttelettes est retiré, aucun type de masque n'est donné comme suffisant sans source, et la phrase sur la SF2H 2024 est exacte.
- **Il reste trois corrections de données.** Ce sont des valeurs et des textes exacts, à appliquer sans nouvelle recherche :
  - C1 : FR et température alignées sur MedlinePlus (M4, non levé) ;
  - C2 : PA basse sans ambiguïté (N1, nouveau) ;
  - C3 : source NT du Glasgow (M2 résiduel).

  Ensuite, recompiler les deux variantes et relancer le script ci-dessous en mettant à jour les motifs indiqués. Une nouvelle vérification complète n'est pas nécessaire.
- **Le reste est l'objet même de la relecture infirmière.** Ce sont des consignes de prudence sans source, déjà listées dans `statut-methode.md`.
- **La publication reste bloquée.** `data/revues.csv` n'a pas de ligne FR02 et la relecture n'a pas eu lieu.

Contrôles automatiques :
- **Compilation :** `python3 scripts/build.py FR02-2009` puis `FR02-2026` passent, sur une copie du dépôt. `controle_source.py` et `controle_pdf.py` sont OK : A4, Letter et N&B font 2 pages, la tablette 3 pages en paysage (680 × 473 pt), 3 mentions, aucun débordement, aucune couleur en N&B.
- **Livraison :** le texte des PDF recompilés est identique à celui des PDF livrés, qui sont donc à jour des sources.
- **Variantes :** dans les 4 formats, une fois retirée la ligne d'UE, il n'y a aucune différence de mots entre 2009 et 2026. En Letter, l'ordre des blocs change à cause de la ligne d'UE, plus longue, qui décale la mise en page ; le contenu est identique.
- **Recalcul :** 0 écart.
  - EX01 à EX05 sont exacts.
  - Les cotations Glasgow et Braden sont conformes.
  - Valeurs et sources concordent : FC 60–100 et PA basse 90/60 (MedlinePlus), HTA (HAS), douleur, AES.
  - Les 23 motifs chiffrés sont présents dans les 8 PDF.
  - Aucun « FFP2 », « chirurgical », « Air : », « Gouttelettes : » ou « type IIR » ne subsiste.
  - Tous les marqueurs de `cartes.csv` se résolvent ; 17 notes par `.apkg`.

## 1. Suivi des constats v1

| # v1 | Statut v2 | Preuve |
|---|---|---|
| **B1** | **Levé** (reste au niveau MAJEUR comme consigne sans source, point R1) | `main.typ` l. 131-133 : « Valeur grave ou patient.e qui va mal : *alerter immédiatement* selon le protocole, puis recontrôler. Valeur anormale isolée chez un.e patient.e stable : recontrôler […] et comparer […] avant de signaler. En cas de doute, alerter. » L'ordre est sûr : on alerte d'abord, la condition « qui se dégrade » a disparu, et « en cas de doute, alerter » couvre la première mesure. `cartes.csv` l. 4 et les deux `.apkg` portent le même texte (seul le gras diffère). `contenu.csv` l. 2 : « alerter d'abord si gravité », cohérent. Présenter cette consigne sans source comme « consigne de prudence » est **acceptable avec réserve**, à trois conditions remplies : elle est A-VERIFIER dans `references.csv`, elle est le point 1 de `statut-methode.md`, et la publication est bloquée jusqu'à la relecture. |
| **B2** | **Levé** | Section 7 : un encadré « Respiratoires (SF2H 2024) » et un tableau qui ne garde que Contact. **Masques :** le seul type de masque affiché sur la fiche est « Patient.e qui tousse : masque à usage médical, **au minimum** de type I (norme EN 14683) ». C'est un plancher, pas un type présenté comme suffisant ; il est sourcé (SF2H 2017, présentation du CHU Amiens, diapos 3 et 6) et cohérent avec l'avis SF2H du 17.05.2020 (« masque à usage médical de type I ou de type II pour les patients »). Le risque de projection, le masque du.de la soignant.e et celui du.de la patient.e en précautions respiratoires renvoient au protocole. **Phrase SF2H 2024 exacte :** diffusion fin octobre 2024 (CPias Hauts-de-France, diapo 46), R22 « trois niveaux […] (simples, renforcées, maximales) » (diapo 36), « Dichotomie AIR/Gouttelettes non adaptée » (diapo 4). Ces trois points ont été lus par moi en v1. La carte Anki et `contenu.csv` l. 7 sont alignés. |
| M1 | **Levé** | `references.csv` MSD_GLASGOW : je l'ai relu le 29.10.2026 (Manuel MSD, version professionnelle en français). Points Y 4–1, V 5–1, M 6–1 conformes à `glasgow.csv`. Les libellés sont fidèlement reformulés (« Désorientée » → « Confuse », « Retrait lors du stimulus douloureux » → « Évitement (retrait) »). Le tableau MSD n'a pas de date de révision, seulement un copyright 2026. CHUV_GLASGOW couvre l'étendue de 3 à 15 et la consigne « noter le détail ». |
| M2 | **Partiellement levé** | La ligne NT est ajoutée (`main.typ` l. 168, carte Glasgow), mais sa source manque : le tableau MSD n'en parle pas, ce que j'ai vérifié. Voir **C3**. |
| M3 | Non levé, renvoyé à la relectrice | « Toute baisse […] s'alerte immédiatement » reste A-VERIFIER (`statut-methode.md`, point 10). Acceptable jusqu'à la relecture. |
| **M4** | **Non levé** | `constantes.csv` FR et TEMP : `A_VERIFIER`, avec des valeurs affichées de 12 à 20 et de 36,5 à 37,5. Or le producteur a lu MedlinePlus (`references.csv` l. 4), que j'ai relu : « Breathing: 12 to 18 breaths per minute » et « 97.7°F to 99.1°F (36.5°C to 37.3°C) ». La **règle 12** de `agents/producteur.md` dit : « Si la valeur diffère de la source citée, s'aligner sur la source ou en citer une autre qui la soutient. » Le producteur dispose d'une source identifiée et lue ; elle contredit les valeurs affichées, et il ne cite aucune autre source qui les soutienne. Garder 12–20 et 36,5–37,5 sous A-VERIFIER revient à afficher des valeurs que la seule source lue contredit. La règle 1 (« A-VERIFIER faute de source ») ne s'applique pas puisqu'une source existe. Les valeurs MedlinePlus sont en outre les plus prudentes : avec une fourchette normale plus étroite, l'anomalie est repérée plus tôt. Voir **C1**. SpO₂ : aucune source lue, donc A-VERIFIER légitime. |
| M5 | **Levé**, mais un défaut nouveau est apparu (N1) | « HTA si ≥ 140/90 persistante » est conforme à HAS 2016 (« persistant dans le temps »). Repère bas ajouté : « < 90/60 ou en chute », d'après MedlinePlus 002341 (« between 90/60 mmHg and 120/80 mmHg »), que j'ai relu. 90/60 est bien la borne basse de l'intervalle usuel. L'écriture « < 90/60 » est ambiguë : voir N1 et C2. |
| M6 | **Levé** | Tableau : « Prise en charge requise si ≥ 4/10 […] ». Sous le tableau : « Sous ces seuils, la douleur reste évaluée, tracée et prise en compte ; la conduite est celle du protocole du service. » Les 3 cartes douleur portent la même nuance. Les seuils sont conformes à HAS IQSS 2023. La phrase « sous ces seuils » est une consigne A-VERIFIER, déclarée comme telle (point 6). |
| M7 | **Levé**, avec réserve | Risque de projection : « masque et lunettes, type de masque selon le protocole » ; le type I n'apparaît plus que pour le.la patient.e qui tousse. C'est conforme à l'avis SF2H du 17.05.2020 : type II-R réservé aux activités à fort risque de projection, ou type II avec écran facial. Le texte SF2H 2017 lui-même n'est toujours pas lu (R4). |
| M8 | **Levé**, avec réserve | `main.typ` l. 230 : « Mains visiblement souillées : lavage à l'eau et au savon. _C. difficile_, gale : lavage au savon *puis* friction (friction seule inefficace). » La source est identifiée : quiz CPias Hauts-de-France, mai 2025, avec citations relevées. C'est une source pédagogique régionale, sans numéro de question ; une recommandation SF2H serait plus solide (R5). |
| M9 | Partiellement levé | Contact : la source est secondaire (CHU de Saint-Étienne, 2011, d'après SF2H 2009) et le texte SF2H 2009 n'a pas été lu (point 9). Acceptable pour la relecture. |
| M10 | Partiellement levé | Traçabilité : l'identification de l'auteur.rice et le support de la prescription viennent de l'AP-HP 2014, lu. DAR, « date, heure », « faits objectifs » et « jamais tracé à l'avance » restent sans source (point 11). |
| M11 | **Levé** | `variantes.csv` FR02-2026 : « Référentiel 2026 (arrêté du 20 février 2026, entrant.e.s à partir de septembre 2026) : notions mobilisées notamment dans l'UE B.3 « Pratiques et interventions infirmières » (S1, S2 dans le programme publié par l'UBE) ». C'est la formulation proposée en v1. `references.csv` l. 26 rectifie la portée de l'art. 23, et l. 27 attribue « S1, S2 » à l'UBE seule. Aucune promesse d'évaluation dans les annonces. |
| M12 | Partiellement levé | La signalétique est sourcée (R18 SF2H 2024, présentation inter-CPias 2025). Restent sans source : « cible prescrite », « même échelle », « ne pas déduire le niveau du diagnostic », « procédure AES de l'établissement » et « le service et l'IFSI » (point 10). |
| m1 | Levé | « Infectiologie hygiène », sans virgule, comme dans la copie HPSJ. L'annexe III officielle n'est toujours pas lue (point 14). |
| m2 | Non levé | Braden : aucune source française lue, HAS 2001 inaccessible (point 12). |
| m3 | Non levé | INRS AA 775 : année d'édition non relevée (point 13). |
| m4 | Levé (par retrait) | « Reformuler la décision » est retiré de la fiche. |
| m5 | Levé | « Dans les 24 h » commence une nouvelle ligne : p. 2 de l'A4, vérifiée sur le rendu. |
| m6 | Levé | `variantes.csv` : « Soins d'urgence » et « l'UE » ont des apostrophes typographiques. |
| m7 | Levé | `contenu.csv` l. 7 n'écrit plus « 5 » en dur. `aes_avis_h` est affiché (« Sous 1 h »). |

## 2. Constats restants et nouveaux

### À corriger avant l'envoi à la relectrice

| # | Gravité | Emplacement | Constat | Correction exacte |
|---|---|---|---|---|
| **C1** (M4) | **MAJEUR** | `valeurs.csv` `fr_haut`, `t_haut` et libellés `fr_*`, `t_*` ; `constantes.csv` lignes FR, TEMP ; `references.csv` l. 3 et l. 4 ; `statut-methode.md` point 4 | Les valeurs affichées ne sont pas soutenues par la source lue (règle 12). | **`valeurs.csv`** : `fr_haut` passe de 20 à **18** ; `t_haut` passe de 37.5 à **37.3**. Les libellés deviennent « FR de repos de l'adulte : borne basse (MedlinePlus) », « … borne haute (MedlinePlus) », « Température : borne basse (MedlinePlus) », « … borne haute (MedlinePlus) ». **`constantes.csv`** : FR et TEMP prennent `source_code` = `MEDLINEPLUS_VITAUX` et `statut` = `LU` ; SPO2 reste inchangé. **`references.csv` l. 3** : ajouter à `element` « ; FR de repos 12 à 18/min (valeurs.csv fr_bas, fr_haut ; constantes.csv FR) ; température 36,5 à 37,3 °C (valeurs.csv t_bas, t_haut ; constantes.csv TEMP) », et à `localisation` « ; breathing « 12 to 18 breaths per minute » ; body temperature « 97.7°F to 99.1°F (36.5°C to 37.3°C) », site de mesure non précisé ». **`references.csv` l. 4** : ne garder que « SpO₂ ≥ 95 % en air ambiant (valeurs.csv spo2_bas ; constantes.csv SPO2) », toujours `A_VERIFIER`. **`statut-methode.md` point 4** : « FR 12 à 18/min et température 36,5 à 37,3 °C (MedlinePlus, lu ; source non française) : la relectrice peut les remplacer par les valeurs d'une source française qu'elle cite (champs `fr_haut`, `t_haut`). SpO₂ ≥ 95 % : non sourcé. » La fiche affichera « 12 à 18 » et « 36,5 à 37,3 ». |
| **C2** (N1, nouveau) | **MAJEUR** | `constantes.csv` ligne PABAS ; `references.csv` l. 3 | **Ambiguïté d'interprétation** (règle 4 du vérificateur). Avec « < 90/60 », on ne sait pas si les deux composantes doivent être basses : une PA de 85/70 n'est « pas sous 90/60 » si on lit les deux bornes ensemble. Une PAS basse avec une PAD normale risque alors de ne pas être signalée. Par ailleurs, le statut `LU` couvre aussi « ou en chute », qui n'est pas dans la source citée. | **`constantes.csv` PABAS, colonne `repere`** : `PAS < {pa_bas_pas} ou PAD < {pa_bas_pad}, ou en chute`, affiché « PAS < 90 ou PAD < 60, ou en chute ». Si la colonne s'élargit trop, mettre `parametre` = « Pression artérielle basse (PAS ou PAD) » et `repere` = `< {pa_bas_pas} ou < {pa_bas_pad}, ou en chute`. **`references.csv` l. 3, `localisation`** : ajouter « « Ou » (une seule composante basse suffit) : lecture de prudence, A-VERIFIER (relectrice). « Ou en chute » : MedlinePlus, « Low blood pressure », article 007278, revu le 01.01.2025 : https://medlineplus.gov/ency/article/007278.htm (« A drop of as little as 20 mmHg can cause problems for some people », lu le 29.10.2026 ; soutien partiel, la conduite reste A-VERIFIER) ». **`statut-methode.md` point 5** : remplacer « < 90/60 ou en chute » par « PAS < 90 ou PAD < 60, ou en chute ». |
| **C3** (M2) | **MAJEUR** | `references.csv` l. 12 (NT) | La catégorie NT n'a pas de source identifiée (note clinique sans référence). | **`references.csv` l. 12** : `source_code` = `COOK_BJNN_2025` ; `localisation` = « Cook N, Trout R, Waterhouse C, Braine M, Barrett C, Brennan P, Teasdale G, et al., « The Glasgow Coma Scale: an international standard for education and practice with adults », British Journal of Neuroscience Nursing, 2025;21(Sup1c):S1-S36, doi 10.12968/bjnn.2025.21.sup1c.s1 (résumé lu le 29.10.2026 : « the introduction of a Not Testable (NT) category for each of the three sections », révision de 2014). « Ne pas coter 1 » et les exemples (intubation, paupières œdématiées) : texte intégral non lu, A-VERIFIER (relectrice) ». Le texte de la fiche reste inchangé. |

### Pour la relectrice (MAJEURS par la règle « note clinique sans référence », déjà listés dans `statut-methode.md`)

| # | Gravité | Point | Ce qu'elle tranche |
|---|---|---|---|
| R1 (B1) | MAJEUR | Conduite devant une valeur anormale (point 1) | Valider ou reformuler. L'ordre est sûr en l'état. |
| R2 (M3) | MAJEUR | « Toute baisse du Glasgow s'alerte immédiatement » | Valider ou retirer. |
| R3 (M10, M12) | MAJEUR | DAR, traçabilité (« date, heure », « faits objectifs », « jamais à l'avance »), « cible prescrite », « même échelle », « ne pas déduire le niveau », AES « procédure de l'établissement », « le service et l'IFSI » | Valider ou retirer chaque consigne. |
| R4 (M7) | MAJEUR | Précautions standard : texte SF2H 2017 non lu (source secondaire seulement) | Confirmer le type I pour le.la patient.e qui tousse et « type de masque selon le protocole » en cas de projection. |
| R5 (M8, M9) | MAJEUR | Exceptions à la friction (quiz CPias 2025) ; précautions Contact (source secondaire de 2011) | Confirmer. Point de pratique à trancher : préciser « lavage au savon, séchage, *puis* friction » (la friction se fait sur mains sèches). Non sourcé ici, je ne l'impose pas. |
| R6 (M6) | MAJEUR | « Sous ces seuils, la douleur reste évaluée, tracée et prise en compte » (fiche et 3 cartes) | Valider. |

### Mineurs

| # | Gravité | Emplacement | Constat | Correction exacte |
|---|---|---|---|---|
| m2 | MINEUR | `references.csv` HUG_ESCARRES_2017 | Braden : pas de source française. | Inchangé depuis la v1 (HAS 2001 à relire). |
| m3 | MINEUR | `references.csv` INRS_AA775 | Année d'édition de l'affiche absente. | Relever l'édition au catalogue INRS. |
| N2 | MINEUR | Pied de page (version issue de `data/variantes.csv`) | Le contenu est en v2, le pied de page affiche « v1 » : la relectrice et les rapports ne parlent pas de la même version. | L'orchestrateur passe FR02-2009 et FR02-2026 en `v2` dans `data/variantes.csv`, puis recompile. |
| N3 | MINEUR | `main.typ` l. 132 et `cartes.csv` l. 4 | « Valeur grave » est imprécis : c'est la situation qui est grave, pas la valeur. | Écrire « Valeur très anormale ou patient.e qui va mal » aux deux endroits, en gardant un texte identique. |
| N4 | MINEUR | `contenu.csv` l. 1 à 8 | Apostrophes mélangées (« d'HTA » droite, « d’abord » typographique), visibles si l'aperçu `06-contenu.png` reprend ce texte. | Remplacer toutes les `'` par `’` dans `contenu.csv`. |
| N5 | MINEUR | `annonce/whop.md`, commentaire d'en-tête | Le commentaire renvoie au « point 4 de statut-methode.md (consignes sans source) » ; c'est désormais le point 10. Le texte publié n'est pas concerné. | Remplacer « le point 4 » par « le point 10 ». |

### Annonces : exactitude des promesses
Les deux annonces sont **exactes** :
- **Volume :** 2 pages pour A4, Letter et N&B (N&B en A4, vérifié avec pdfinfo) ; 3 pages en paysage pour la tablette.
- **Contenu :** 8 rubriques, 4 pièges et 4 notes cliniques (comptés dans `main.typ`) ; 17 cartes par `.apkg`.
- **Variantes :** seule la ligne d'UE change entre les deux.
- **Sujets annoncés :** « repère bas » de PA, NT, exceptions à la friction, niveaux SF2H 2024.
- **Ce qui n'est pas annoncé :** aucune valeur de constante, aucune évaluation en UE B.3.
- **« Aucune dose » :** exact.

La mention « contenu vérifié et validé par le vendeur » ne devient vraie qu'après la relecture : publication bloquée (`statut-methode.md`).

## 3. Contrôles sans constat
- **`statut-methode.md`** : les 14 points sont exacts. Il affirme : « Script de recalcul du vérificateur relancé sur les PDF v2 : 0 écart. » Je le confirme (règle 15 respectée).
- **Droits** : pas de reprise nouvelle. La liste OMS et les produits INRS restent proches de leur source, comme en v1, et c'est acceptable.
- **Rien en dur dans le Typst** : les nouveaux nombres (PA basse, délai de 1 h) viennent de `valeurs.csv` par `{pa_bas_*}` et `#valu("aes_avis_h")`.
- **Rendu** : A4 2026, pages 1 et 2 relues à l'œil. Aucune coupure, l'encadré respiratoire est lisible, la page 2 est aux deux tiers vide.
- **Remarque technique** : pdftotext signale « Suspects object is wrong type (boolean) » sur tous les PDF. C'est une métadonnée Typst sans effet sur le contenu, pas un défaut.

## 4. Points pour l'infirmière relectrice (ordre de priorité)

1. **Valeur anormale** : « Valeur grave (ou « très anormale », N3) ou patient.e qui va mal : alerter immédiatement selon le protocole, puis recontrôler. Valeur anormale isolée chez un.e patient.e stable : recontrôler et comparer avant de signaler. En cas de doute, alerter. » Valider ou reformuler (même texte sur la carte).
2. **Repères de constantes** (après C1 et C2) :
   - FC de 60 à 100/min ;
   - FR de 12 à 18/min ;
   - température de 36,5 à 37,3 °C (MedlinePlus, source non française) ;
   - SpO₂ ≥ 95 % (non sourcé) ;
   - PA basse : PAS < 90 ou PAD < 60, ou en chute.

   Valider, ou donner la valeur et la source de son service pour chaque champ (`fr_bas`, `fr_haut`, `t_bas`, `t_haut`, `spo2_bas`, `pa_bas_pas`, `pa_bas_pad`).
3. **Précautions respiratoires** : la fiche ne donne aucun type de masque et renvoie au protocole de l'établissement et à l'équipe d'hygiène (SF2H 2024, 3 niveaux). Confirmer que ce renvoi suffit pour un.e étudiant.e.
4. **Glasgow** : NT, « ne pas coter 1 ». Libellés : les aligner sur ceux du service si besoin (points conformes au Manuel MSD).
5. **Précautions standard** :
   - masque au minimum de type I pour le.la patient.e qui tousse ;
   - « type selon le protocole » en cas de projection ;
   - exceptions à la friction, avec ou sans « séchage » avant la friction (R5) ;
   - précautions Contact.
6. **Douleur** : « sous ces seuils, la douleur reste évaluée, tracée et prise en compte ».
7. **Consignes sans source** : baisse du Glasgow, cible prescrite, même échelle, ne pas déduire le niveau de précautions, transmissions ciblées (DAR), traçabilité (date, heure, faits objectifs, jamais à l'avance), AES « procédure de l'établissement » et « le service et l'IFSI ». Valider ou retirer chacune.
8. **Braden** : seuil renvoyé au protocole du service (aucun seuil affiché) ; à confirmer.

## Sources consultées par le vérificateur (29.10.2026, v2)
- MedlinePlus, « Vital signs », 002341, revu le 01.01.2025 : https://medlineplus.gov/ency/article/002341.htm (lu : FR 12–18, FC 60–100, PA 90/60–120/80, T 36,5–37,3 °C)
- MedlinePlus, « Low blood pressure », 007278, revu le 01.01.2025 : https://medlineplus.gov/ency/article/007278.htm (lu : pas de seuil chiffré propre ; « A drop of as little as 20 mmHg can cause problems for some people »)
- Manuel MSD, édition professionnelle en français, « Échelle de coma de Glasgow » : https://www.merckmanuals.com/fr-ca/professional/multimedia/table/%C3%A9chelle-de-coma-de-glasgow-glasgow-coma-scale (lu : points conformes, pas de mention NT)
- Cook N et al., BJNN 2025;21(Sup1c):S1-S36, notice : https://salford-repository.worktribe.com/output/3994756/the-glasgow-coma-scale-an-international-standard-for-education-and-practice-with-adults (résumé lu : catégorie NT de la révision de 2014)
- SF2H, « Avis relatif à l'emploi des différents types de masques à usage médical en milieux de soins », version du 17.05.2020 : https://peps.sante.gouv.fr/actu/ncov/20_avis-sf2h_emploi-differents-masque-usage-medical.pdf (lu : type II-R réservé aux activités à fort risque de projection, ou type II avec écran ; type I ou II pour les patient.e.s)
- Sources v1 non relues (CPias 2024, FAQ SF2H 2025, HAS IQSS 2023, INRS, arrêté de 2026, UBE) : constats v1 repris.
- OpenStax non consulté (règle 3).

## Script de recalcul

Copie de travail : `/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verificateur-R05-FR02-v2/scripts/recalcul_fr02_v2.py`. C'est le script v1 avec trois ajouts :
- la FC et la PA basse confrontées à MedlinePlus ;
- les marqueurs des cartes ;
- de nouveaux motifs : présence de « < 90/60 », « Sous 1 h » et « ne pas coter 1 » ; absence de « FFP2 », « chirurgical », « Air : », « Gouttelettes : » et « type IIR ».

Usage :
1. `pdftotext <pdf> <dossier>/<variante>-<format>.txt`.
2. `python3 -I recalcul_fr02_v2.py /home/claude/mindshelf/produits/FR02 <dossier>`.

Résultat du 29.10.2026 sur les 8 PDF livrés : 63 contrôles OK, « RESULTAT : tout concorde ».

**Après C1 et C2**, mettre à jour les motifs du script :
- remplacer « 12 à 20 » par « 12 à 18 » ;
- remplacer « 36,5 à 37,5 » par « 36,5 à 37,3 » ;
- remplacer « < 90/60 » par « PAS < 90 ou PAD < 60 ».

Ajouter à `ATT` : `"fr_bas": 12, "fr_haut": 18, "t_bas": 36.5, "t_haut": 37.3`.

```python
#!/usr/bin/env python3
"""Recalcul indépendant FR02 (vérificateur R05, contre-vérification v2).
Usage : python3 -I recalcul_fr02.py /home/claude/mindshelf/produits/FR02
Évalue chaque formule de exemples.csv (seuls + - * / ( ) et calc.pow autorisés),
puis contrôle la cohérence glasgow.csv / braden.csv / valeurs.csv / exemples.csv
et la conformité des cotations à l'échelle de référence (Teasdale & Jennett 1974 ;
Bergstrom et al. 1987)."""
import ast, csv, json, re, sys
from pathlib import Path

d = Path(sys.argv[1]) / "donnees"
ok = True
def err(m):
    global ok; ok = False; print("ECART  ", m)

def evalue(formule, env):
    f = formule.replace("calc.pow", "pow")
    if re.search(r"\*\*|[^A-Za-z0-9_+\-*/(). ,]", f): raise ValueError("formule hors contrat : " + formule)
    arbre = ast.parse(f, mode="eval")
    for n in ast.walk(arbre):
        if isinstance(n, ast.Call) and not (isinstance(n.func, ast.Name) and n.func.id == "pow"):
            raise ValueError("fonction interdite : " + formule)
    return eval(compile(arbre, "<f>", "eval"), {"__builtins__": {}, "pow": pow}, env)

ex = {l["id"]: l for l in csv.DictReader(open(d / "exemples.csv", encoding="utf-8"))}
for i, l in ex.items():
    if re.search(r"\d[eE][-+]?\d", l["entrees_json"]): err(f"{i} : notation exponentielle")
    e = json.loads(l["entrees_json"]); r = evalue(l["formule"], e)
    att = float(l["resultat_attendu"]); tol = float(l["tolerance"])
    st = "OK" if abs(r - att) <= tol else "ECART"
    if st != "OK": err(f"{i} : {r} ≠ {att}")
    print(f"{st:6} {i} {l['formule']} = {r} (attendu {att}, tol {tol})")

val = {l["cle"]: float(l["valeur"]) for l in csv.DictReader(open(d / "valeurs.csv", encoding="utf-8"))}
g = list(csv.DictReader(open(d / "glasgow.csv", encoding="utf-8")))
REF_G = {"Yeux (Y)": {4,3,2,1}, "Verbal (V)": {5,4,3,2,1}, "Moteur (M)": {6,5,4,3,2,1}}
items = list(dict.fromkeys(l["item"] for l in g))
for it in items:
    pts = [int(l["points"]) for l in g if l["item"] == it]
    if set(pts) != REF_G.get(it, set()) or len(pts) != len(set(pts)): err(f"Glasgow {it} : {pts}")
    else: print(f"OK     Glasgow {it} : {sorted(pts, reverse=True)}")
mins = sum(min(int(l["points"]) for l in g if l["item"] == it) for it in items)
maxs = sum(max(int(l["points"]) for l in g if l["item"] == it) for it in items)
for k, v in (("glasgow_min", mins), ("glasgow_max", maxs)):
    (print if val[k] == v else err)(f"{'OK     ' if val[k]==v else ''}{k} = {val[k]} / recalculé {v}")
for k, it in zip("YVM", items):
    if val[f"glasgow_{k.lower()}_max"] != max(int(l["points"]) for l in g if l["item"] == it): err(f"glasgow_{k.lower()}_max")
    if json.loads(ex["EX01"]["entrees_json"])[k] not in [int(l["points"]) for l in g if l["item"] == it]: err(f"EX01 {k} hors cotation")
# EX01 : libellés de l'énoncé ↔ cotation de glasgow.csv
lib = {"à la demande": ("Yeux (Y)", "Y"), "confuse": ("Verbal (V)", "V"), "localise la douleur": ("Moteur (M)", "M")}
e1 = json.loads(ex["EX01"]["entrees_json"])
for mot, (it, k) in lib.items():
    p = [int(l["points"]) for l in g if l["item"] == it and mot.lower() in l["reponse"].lower()]
    (print if p == [e1[k]] else err)(f"{'OK     ' if p==[e1[k]] else ''}EX01 « {mot} » → {p} / entrée {k}={e1[k]}")

b = list(csv.DictReader(open(d / "braden.csv", encoding="utf-8")))
REF_B = {"Perception sensorielle": (1,4), "Humidité": (1,4), "Activité": (1,4), "Mobilité": (1,4), "Nutrition": (1,4), "Friction et cisaillement": (1,3)}
for l in b:
    if REF_B.get(l["item"]) != (int(l["min"]), int(l["max"])): err(f"Braden {l['item']}")
    else: print(f"OK     Braden {l['item']} {l['min']}–{l['max']}")
for k, v in (("braden_items", len(b)), ("braden_min", sum(int(l["min"]) for l in b)), ("braden_max", sum(int(l["max"]) for l in b))):
    (print if val[k] == v else err)(f"{'OK     ' if val[k]==v else ''}{k} = {val[k]} / recalculé {v}")
for i, k in (("EX02", "braden_min"), ("EX03", "braden_max"), ("EX04", "glasgow_min"), ("EX05", "glasgow_max")):
    (print if float(ex[i]["resultat_attendu"]) == val[k] else err)(f"{'OK     ' if float(ex[i]['resultat_attendu'])==val[k] else ''}{i} ↔ {k}")
# Douleur et AES : valeurs ↔ sources lues (HAS IQSS 2023, INRS AA 775)
ATT = {"eva_max_cm": 10, "eva_max_mm": 100, "en_max": 10, "douleur_seuil": 4, "douleur_seuil_100": 40, "evs_max": 4, "evs_seuil": 2,
       "algoplus_max": 5, "algoplus_seuil": 2, "aes_desinfection_min": 5, "aes_rincage_min": 5, "javel_pct": 2.6, "javel_dilution": 5,
       "javel_num": 1, "alcool_degre": 70, "aes_avis_h": 1, "aes_tpe_h": 4, "aes_declaration_h": 24, "pa_hta_pas": 140, "pa_hta_pad": 90,
       "pa_amt_pas": 135, "pa_amt_pad": 85, "oms_indications": 5, "masque_norme": 14683,
       "fc_bas": 60, "fc_haut": 100, "pa_bas_pas": 90, "pa_bas_pad": 60}  # v2 : FC et PA basse, MedlinePlus 002341
for k, v in ATT.items():
    (print if val[k] == v else err)(f"{'OK     ' if val[k]==v else ''}{k} = {val[k]} (source : {v})")
# v2 : chaque marqueur {v:cle} / {xe:ID} de cartes.csv existe
for l in csv.DictReader(open(d / "cartes.csv", encoding="utf-8")):
    for m in re.findall(r"\{(v|xe):([A-Za-z0-9_]+)\}", l["recto"] + l["verso"]):
        if (m[0] == "v" and m[1] not in val) or (m[0] == "xe" and m[1] not in ex): err(f"carte : marqueur {m} inconnu")
print("OK     marqueurs des cartes" if ok else "--     marqueurs des cartes")
# Concordance PDF (v2 : motifs ajoutés « < 90/60 », « Sous 1 h », « ne pas coter 1 » ; motifs interdits B2/M7) : chaque nombre attendu présent dans le texte de chaque variante et format
for var in ("FR02-2009", "FR02-2026"):
    for fmt in ("a4", "letter", "nb", "tablette"):
        t = open(Path(sys.argv[2]) / f"{var}-{fmt}.txt", encoding="utf-8").read() if len(sys.argv) > 2 else None
        if t is None: break
        t1 = re.sub(r"\s+", " ", t)
        for motif in ("FFP2", "chirurgical", "Gouttelettes :", "Air :", "type IIR"):  # v2 : B2/M7, aucun type de masque non sourcé
            if motif in t1: err(f"{var}-{fmt} : « {motif} » présent")
        for motif in ("60 à 100", "≥ 140/90", "≥ 135/85", "12 à 20", "≥ 95", "36,5 à 37,5", "≥ 4/10", "≥ 40/100", "≥ 2", "de 3 à 15",
                      "3 + 4 + 5 = 12", "Y3 V4 M5", "de 6 à 23", "au moins 5 min", "2,6 %", "1/5", "70°", "dans les 4 h", "24 h", "14683",
                      "< 90/60", "Sous 1 h", "ne pas coter 1"):
            if motif not in t1: err(f"{var}-{fmt} : « {motif} » absent du PDF")
        print(f"OK     concordance {var}-{fmt}" if ok else f"--     concordance {var}-{fmt}")
print("RESULTAT :", "tout concorde" if ok else "écarts")
sys.exit(0 if ok else 1)
```
