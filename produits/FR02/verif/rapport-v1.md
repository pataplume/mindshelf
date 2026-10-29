# FR02 — Rapport de vérification v1 (run R05)

**Produit :** FR02 « Pack stage IFSI (constantes, échelles, transmissions, précautions) », variantes FR02-2009 et FR02-2026, v1.
**Vérificateur :** agent VERIFICATEUR R05, 29.10.2026, 14:33 à 14:50 (environ 17 min). N'a pas participé à la production.
**Périmètre :** `src/main.typ`, `donnees/*` (dont `cartes.csv`, `contenu.csv`, `statut-methode.md`), les 8 PDF de `livraison/`. Non jugés : `apercus/`, `video/`, `annonce/`, `donnees/extraits.csv`, `.apkg` (conditionneur en cours).

## Verdict : **À corriger**

**2 BLOQUANTS, 12 MAJEURS, 7 MINEURS.**

Ce qui tient :
- **Calculs :** les 5 sommes (EX01 à EX05) sont exactes.
- **Cotations :** aucune erreur de cotation. Glasgow Y 4–1, V 5–1, M 6–1, total 3–15 ; Braden 6 items, 1–4 et friction 1–3, total 6–23.
- **Douleur :** bornes et seuils conformes au document HAS IQSS 2023, relu.
- **AES :** conforme à l'affiche INRS AA 775, relue.
- **Concordance :** tous les nombres des 8 PDF concordent avec les données.
- **Variantes :** seule la ligne d'UE diffère.
- **Contrôles automatiques :** `controle_pdf.py` et `controle_source.py` passent.

Ce qui bloque :
- **B1, conduite devant une valeur anormale :** la note est ambiguë et peut retarder l'alerte.
- **B2, précautions Air et Gouttelettes :** la section repose sur le cadre SF2H 2013. Les recommandations SF2H de fin octobre 2024 l'ont remplacé par des précautions complémentaires respiratoires à trois niveaux.

La publication reste bloquée de toute façon : `data/revues.csv` ne contient aucune ligne FR02, et la relecture infirmière n'a pas eu lieu.

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| B1 | **BLOQUANT** | `main.typ` l. 131-133 (note « Valeur anormale ou inhabituelle »), `cartes.csv` (« Constante anormale ou inhabituelle : conduite »), `references.csv` (ligne A_VERIFIER « Conduite devant une valeur anormale ») | **Sécurité clinique.** La note impose une séquence : « Recontrôler…, comparer aux valeurs précédentes…, *puis* alerter ». L'exception (« le recontrôle ne retarde jamais l'alerte ») ne vaut que « devant un.e patient.e qui se dégrade ». Un.e patient.e mesuré.e pour la première fois (SpO₂ à 82 %, FC à 150, PAS à 80) n'a pas encore de « dégradation » visible : la fiche lui fait d'abord recontrôler la mesure et consulter le dossier, ce qui retarde l'alerte. La carte Anki dit autre chose (« ne retarde pas l'alerte », sans condition) : fiche et carte se contredisent. Aucune source. | Inverser l'ordre et retirer la condition, par exemple : « Valeur très anormale, signe de gravité ou patient.e qui paraît mal : alerter tout de suite, puis recontrôler. Valeur inhabituelle chez un.e patient.e stable : recontrôler (matériel, position, repos), comparer, puis signaler selon le protocole. En cas de doute, alerter. » Même texte sur la carte. Faire valider par la relectrice ; sans source lue, garder le statut A-VERIFIER. |
| B2 | **BLOQUANT** | `main.typ` l. 236-247 (section 7, lignes Air et Gouttelettes), `cartes.csv` (« Précautions Air : mesures »), `contenu.csv` l. 7, `references.csv` (SF2H_AIR_2013 et ligne A_VERIFIER Gouttelettes/Contact) | **Norme périmée.** La section suit SF2H 2013 (Air / Gouttelettes). La SF2H a diffusé fin octobre 2024 des « recommandations pour la prévention de la transmission par voie respiratoire ». R22 y définit des précautions complémentaires respiratoires à trois niveaux (simples, renforcées, maximales) et la dichotomie Air/Gouttelettes y est jugée « non adaptée ». Une FAQ SF2H n° 1 (11.06.2025) applique déjà ce cadre : FFP2 pour le.la soignant.e lors d'un geste aérosolisant, FFP2 pour le.la patient.e hors de sa chambre en niveau renforcé. La ligne « Gouttelettes : masque chirurgical pour le.la soignant.e » peut donc sous-protéger là où le niveau renforcé demande un FFP2. Les lignes Gouttelettes et Contact n'ont en outre aucune source lue. | Lire le texte complet SF2H 2024 (tableau 1 et matrices) et réécrire la section selon les trois niveaux, avec numéros de recommandation dans `references.csv`. À défaut, réduire la section à « suivre la signalétique et le protocole du service » en citant SF2H 2024, sans détailler Air/Gouttelettes. Mettre à jour `contenu.csv` l. 7 et la carte « Précautions Air ». Pour Contact, sourcer SF2H 2009 (précautions complémentaires contact). |
| M1 | MAJEUR | `glasgow.csv`, `references.csv` (ligne A_VERIFIER « Glasgow : libellés et points ») | Les points et les libellés sont **justes** : je les ai contrôlés contre la cotation de Teasdale et Jennett 1974, que je connais, et ils sont conformes. La fiche n'a pourtant toujours **aucune source lisible**. Mes deux tentatives ont échoué : glasgowcomascale.org (demande d'autorisation non accordée à temps) et la table NCBI PMC3614410 (captcha). | Ajouter une source lisible et datée (glasgowcomascale.org, SFAR/SFMU ou CHU français) et la lire. La relectrice confirme les libellés de son service. |
| M2 | MAJEUR | `main.typ` l. 153-173 (section Glasgow) | Rien n'est prévu pour une réponse **non évaluable** (patient.e intubé.e, aphasie, œdème des paupières). La table ne laisse que « 1 Aucune », d'où un score faussement bas, mal interprété ou transmis. | Ajouter une ligne : « Réponse impossible à tester : noter NT et la raison, ne pas coter 1 ». Ajouter la source de cette règle. |
| M3 | MAJEUR | `main.typ` l. 175-177 (note « Baisse du score ») | Note clinique sans référence. La consigne va dans le sens de la sécurité, mais aucune source ne la soutient. | La sourcer ou la faire valider par la relectrice ; garder « selon le protocole du service ». |
| M4 | MAJEUR | `constantes.csv` (FC, FR, SPO2, TEMP : `source_code` = A_VERIFIER), `valeurs.csv` (fc_*, fr_*, spo2_bas, t_*) | Référence manquante : aucune source, française ou autre, lue pour ces quatre repères. Mon avis : FC 60–100, FR 12–20 et SpO₂ ≥ 95 % sont les valeurs usuellement enseignées. Pour la température, 36,5–37,5 °C laisse une zone grise jusqu'à 38 °C (seuil usuel de la fièvre), à trancher. | Citer un document identifié (protocole de surveillance d'un CHU, ouvrage IFSI avec édition et page), puis faire valider par la relectrice. |
| M5 | MAJEUR | `constantes.csv` lignes PA et PAAMT, `main.typ` tableau des constantes | Dans le tableau, « HTA si ≥ 140/90 » tronque la définition HAS (« persistant dans le temps »), que la carte, elle, reprend correctement. Ce sont des seuils de diagnostic d'HTA, pas des repères de surveillance en stage. Le tableau ne donne surtout **aucun repère bas** : une PAS basse ne ressort pas comme anormale. | Écrire « HTA si ≥ 140/90 confirmée dans le temps (HAS) ». Ajouter un repère bas sourcé, ou au minimum « PA basse ou en chute : alerter selon le protocole ». |
| M6 | MAJEUR | `main.typ` l. 142-149 (tableau douleur), `cartes.csv` (cartes EVA/EN, EVS, Algoplus) | Les seuils sont exacts : HAS IQSS 2023 relu, « Le patient nécessite une prise en charge de la douleur si EVA ≥ 4/10 ou ≥ 40/100 », EVS ≥ 2, Algoplus ≥ 2. Mais « Prise en charge si ≥ 4 », lu seul, laisse entendre qu'en dessous rien n'est à faire. La phrase qui suit le tableau corrige en partie ; les cartes Anki n'ont pas cette nuance. | Écrire « Indicateur HAS : prise en charge requise à partir de 4/10 (EVS 2, Algoplus 2) ; en dessous, une douleur exprimée se signale et se réévalue aussi ». Même nuance sur les cartes. |
| M7 | MAJEUR | `main.typ` l. 232 (ligne « Masque, lunettes »), `references.csv` SF2H_PS_2017 | « Masque à usage médical (au minimum de type I…) et lunettes si risque de projection » : selon EN 14683, un masque de type I n'est pas résistant aux projections (c'est le type IIR). Le texte SF2H 2017 n'a pas été lu, seulement une présentation secondaire (CHU Amiens). Le « type I minimum » vise probablement le masque du.de la patient.e. A-VERIFIER. | Relire SF2H 2017 (R18 et la règle sur le masque du.de la patient.e qui tousse), puis remettre « type I » à sa place ou le retirer de la phrase sur les projections. |
| M8 | MAJEUR | `main.typ` l. 230 (ligne « Mains ») et l. 244 (ligne « Contact ») | Les exceptions à la friction hydro-alcoolique manquent : mains visiblement souillées ; *C. difficile* et gale (lavage puis friction, selon le protocole). « Hygiène des mains renforcée » ne dit pas quoi faire. Un.e étudiant.e qui applique la ligne « Mains » telle quelle n'utilise que la friction là où elle est inefficace. | Ajouter l'exception, avec sa source (SF2H 2017 ; SF2H 2009 contact) lue et localisée. |
| M9 | MAJEUR | `references.csv` (ligne A_VERIFIER Gouttelettes/Contact) | La ligne Contact n'a pas de source : tablier, hygiène des mains (Gouttelettes est traité en B2). | SF2H 2009, précautions complémentaires contact : lire et localiser. |
| M10 | MAJEUR | `main.typ` l. 194-199 et 208-210, `references.csv` (DAR : A_VERIFIER ; APHP_TRANSMISSIONS_47 partiel) | Les transmissions ciblées (cible, DAR) n'ont aucune source. Dans la traçabilité, « date, heure », « faits objectifs » et « jamais d'acte tracé à l'avance » n'en ont pas non plus : c'est une note clinique sans référence. | Sourcer : document de CHU ou ouvrage IFSI (auteur.e.s, édition, page) pour DAR ; HAS, CSP ou AP-HP localisés pour la traçabilité. |
| M11 | MAJEUR | `variantes.csv` (FR02-2026, `ligne_ue`), `references.csv` (SRC_IFSI_2026, ligne « Variante FR02-2026 ») | **La source ne soutient pas la phrase.** « Gestes évalués en stage ou en pratique simulée dans l'UE B.3 » s'appuie sur l'art. 23, 2°. Or l'art. 23 ne vise que les candidat.e.s de l'art. 22, en parcours adapté : médecins, sages-femmes, étudiant.e.s ayant validé la 2e année du 2e cycle de médecine, infirmier.e.s diplômé.e.s hors UE/EEE, auxiliaires médicaux de niveau 6. Les « 4 actes » de l'UE B.3 n'y sont pas énumérés : ils sont dans l'annexe III, non lue. Rien n'établit que constantes, échelles, transmissions et précautions soient ces gestes, ce qui promet une couverture non justifiée (règle 14). « (S1, S2) » vient de la délibération de l'UBE, celle d'une seule université. | Écrire par exemple « Référentiel 2026 (arrêté du 20 février 2026, entrant.e.s à partir de septembre 2026) : notions mobilisées notamment dans l'UE B.3 « Pratiques et interventions infirmières » (S1, S2 dans le programme publié par l'UBE) ». Corriger la localisation dans `references.csv` : l'art. 23 n'atteste que l'intitulé de l'UE B.3. Lire l'annexe III si possible. |
| M12 | MAJEUR | `main.typ` l. 135, 151, 247, 257-261 ; `references.csv` (lignes A_VERIFIER « Piège ») | Plusieurs consignes cliniques n'ont aucune source : « une cible prescrite passe avant le repère », « garder la même échelle » (« un score d'EVA et un score d'EN ne se comparent pas »), « la signalétique indique le type de précautions », et les ajouts AES « selon la procédure AES de l'établissement » et « en stage : le service et l'IFSI ». | Les faire valider par la relectrice ou les retirer ; sourcer ce qui peut l'être (procédure AES : circulaire ou INRS ; stage : règlement de l'IFSI). |
| m1 | MINEUR | `variantes.csv` (FR02-2009), `references.csv` SRC_IFSI_2009 | Dans la copie lue (hpsj.fr, récapitulatif des UE de S1 et S2), l'UE 2.10.S1 s'intitule « Infectiologie hygiène », sans virgule. Les intitulés de 3.1 (S1, S2), 4.1.S1 et 4.3.S2 sont conformes. Le texte officiel de l'annexe III (Légifrance ou BO) n'a pas été lu. | Aligner l'intitulé sur l'annexe III officielle et localiser la référence (BO santé, protection sociale, solidarité n° 2009/7). |
| m2 | MINEUR | `references.csv` HUG_ESCARRES_2017 | La source de Braden est suisse (HUG) ; aucune source française n'a été lue. Les cotations sont justes. | Ajouter une source française lue (HAS, conférence de consensus de 2001). |
| m3 | MINEUR | `references.csv` INRS_AA775 | L'année d'édition de l'affiche manque (règle 12). Le contenu est conforme : 5 min, Dakin ou Javel à 2,6 % diluée au 1/5e, polyvidone iodée ou alcool à 70°, rinçage d'au moins 5 min, avis dans l'heure, TPE idéalement dans les 4 h, démarches dans les 24 h. | Relever l'édition (catalogue INRS). |
| m4 | MINEUR | `main.typ` l. 205 (SAED, « puis reformuler la décision ») | Le résumé de la p. 13 du guide HAS reste A-VERIFIER : qui reformule, l'appelant ou l'appelé ? | Relire la p. 13 et préciser. |
| m5 | MINEUR | `main.typ` l. 257-258 | « Dans les 24 h : » suit la phrase précédente sur la même ligne (pas de retour à la ligne entre les deux lignes source) : les deux délais se lisent mal d'un coup d'œil. | Ajouter `\` ou un paragraphe entre les deux lignes. |
| m6 | MINEUR | `variantes.csv` (« Soins d'urgence », « l'UE ») | Apostrophes droites, alors que le reste du PDF a des apostrophes typographiques. | Remplacer par ’. |
| m7 | MINEUR | `contenu.csv` l. 7 ; `valeurs.csv` aes_avis_h | « 5 indications » est écrit en dur dans un champ de texte, alors que `cartes.csv` utilise `{v:oms_indications}`. `aes_avis_h` (1 h) existe mais n'est affiché nulle part : le Typst écrit « Dans l'heure » en toutes lettres. | Utiliser le marqueur dans `contenu.csv` si l'outil d'annonce le résout ; supprimer `aes_avis_h` ou l'utiliser. |

### Contrôles sans constat
- **Calculs :** EX01 à EX05 recalculés par le script ci-dessous ; aucun écart.
- **Cohérence des données :** `glasgow.csv`, `braden.csv`, `valeurs.csv` et `exemples.csv` sont cohérents entre eux. Les libellés de l'énoncé EX01 correspondent aux points de `glasgow.csv`.
- **Concordance :** 20 motifs chiffrés retrouvés dans chacun des 8 PDF.
- **Rien en dur dans le Typst :** aucun nombre tapé en dur (repères, cotations, délais et normes viennent des tables). Restent en toutes lettres des noms qui ne sont pas des valeurs : FFP2, type I, SpO₂, et « Dans l'heure » (m7).
- **Variantes :** différence de mots entre 2009 et 2026, dans les 4 formats, limitée à la ligne d'UE. Aucune UE d'un référentiel dans la variante de l'autre.
- **Forme :** `controle_pdf.py` passe pour FR02-2009 et FR02-2026. A4, Letter et N&B font 2 pages, tablette 3 (max. 4 en A4, 12 en tablette). Aucun débordement, aucune couleur en N&B, 3 mentions présentes. `controle_source.py` passe (règle 16).
  - Remarque : la page 2 de l'A4 est vide aux deux tiers. Ce n'est pas un défaut ; la place pourrait accueillir les corrections B2, M2 et M8.
- **Droits :** pas de reprise de manuel ni d'annales. Deux passages restent proches de leur source et c'est acceptable :
  - les 5 indications de l'OMS (liste officielle courte) ;
  - les produits et dilutions de l'affiche INRS (consigne technique, qu'il vaut mieux ne pas reformuler).
- **Statut :** `statut-methode.md` est exact. Il bloque la publication jusqu'à la relecture, dit que rien n'a été relu par un.e professionnel.le et explique le pied de page « contenu vérifié et validé par le vendeur ». Il devra ajouter B1, B2 et M2 aux points à relire.
- **`contenu.csv` :** exact aujourd'hui, à une réserve près : la l. 7 (« précautions Air, Gouttelettes et Contact ») changera avec B2.

## Points `A-VERIFIER` : avis du vérificateur

| Point | Avis |
|---|---|
| Date de l'arrêté 2026 | **Confirmée : arrêté du 20 février 2026** relatif au diplôme d'État d'infirmier, NOR ESRS2601184A, JORF du 25.02.2026, texte 53 (copie du JORF publiée par la FHF, lue). Art. 60, I : applicable aux entrant.e.s à partir de septembre 2026 ; les autres restent régi.e.s par l'arrêté du 31 juillet 2009. L'en-tête de la délibération CFVU de l'UBE porte « Arrêté du 2 février 2026 », mais le corps du même document parle de « décret et arrêté publiés du 20 février 2026 » : coquille de l'UBE. Légifrance n'a pas été consulté directement. |
| UE B.3 | L'intitulé « Pratiques et interventions infirmières » est confirmé par l'art. 23 et par l'UBE (UEB3, S1 avec 3 ECTS, S2 avec 2 ECTS). L'usage de l'art. 23 pour décrire l'évaluation de tou.te.s les étudiant.e.s est erroné (M11). |
| UE 2009 (2.10, 3.1, 4.1, 4.3) | Numéros et intitulés conformes à la copie hpsj.fr, à la virgule de 2.10 près (m1). Le rattachement est formulé « notamment » : acceptable. |
| Glasgow (libellés, points) | Points justes (aucune erreur de cotation). La source manque toujours (M1). Ajouter NT (M2). |
| Braden | Items, cotations et total 6–23 justes. Ne pas afficher de seuil chiffré, comme le fait la fiche (« seuil du protocole du service ») : les seuils publiés varient. Si la relectrice en veut un, prendre celui d'une source française lue. |
| Douleur | Seuils exacts (HAS IQSS 2023). Seule la formulation est à revoir (M6). |
| Constantes FC, FR, SpO₂, T | Plausibles mais sans source (M4) ; zone grise de température à trancher. |
| Conduite « recontrôler / alerter » | Telle qu'écrite, la conduite est ambiguë et doit être réécrite (B1). |
| Précautions standard | Champ, friction, « pas de gants sur peau saine » : conformes à ce que je connais de SF2H 2017, mais le texte SF2H n'a pas été lu (seulement une source secondaire). Masque de type I : probablement mal placé (M7). Exceptions à la friction absentes (M8). |
| Précautions Air, Gouttelettes, Contact | Cadre dépassé par SF2H 2024 (B2). Contact non sourcé (M9). |
| SAED | Les quatre temps et « adaptation française de SBAR » sont conformes au guide HAS de 2014. La reformulation reste à préciser (m4). |
| AES | Conforme à l'affiche INRS. Seule l'année d'édition manque (m3). |

## Sources consultées par le vérificateur (29.10.2026)
- HAS, Liste des échelles acceptées pour mesurer la douleur, IQSS 2023 : https://www.has-sante.fr/upload/docs/application/pdf/2023-03/iqss_2023_-_liste_des_echelles_acceptees_pour_mesurer_la_douleur.pdf (lu)
- Arrêté du 20 février 2026 relatif au diplôme d'État d'infirmier, copie FHF du JORF : https://www.fhf.fr/sites/default/files/2026-02/Arr%C3%AAt%C3%A9%20r%C3%A9ing%C3%A9nierie%20formation%20IDE.pdf (lu : art. 22, 23, 59, 60)
- UBE, délibération CFVU du 16.06.2026 : https://www.ube.fr/wp-content/uploads/2026/07/CA_07072026_delib11_commission_CFVU_16juin2026_reforme_diplome_infirmier.pdf (lu)
- HPSJ, Récapitulatif compétences et UE en S1 S2 : https://www.hpsj.fr/wp-content/uploads/2015/01/Recapitulatif_competences_et_UE_enS1_S2.pdf (lu)
- INRS, affiche AA 775 : https://inrs.fr/dam/inrs/CatalogueAffiche/TI-A-775.pdf (lu)
- CPias Hauts-de-France, L. Simon, « Précautions respiratoires SF2H 2024 », décembre 2024 : https://www.cpias.chu-lille.fr/wp-content/uploads/sites/15/2024/12/Precautions-respiratoires-SF2H-2024-Loic-SIMON.pdf (lu ; les tableaux sont des images, non lisibles)
- SF2H, FAQ n° 1 précautions respiratoires, 11.06.2025 : https://www.sf2h.net/k-stock/data/uploads/2025/06/faq_v1_precautions_respiratoiressf2hjuin2025.pdf (lu)
- Non accessibles : https://www.glasgowcomascale.org/what-is-gcs/ (autorisation non accordée) ; https://pmc.ncbi.nlm.nih.gov/articles/PMC3614410/table/T4 (captcha).
- OpenStax non consulté (règle 3).

## Script de recalcul

Copie de travail : `/tmp/claude-0/-home-claude/43e1f115-64ce-5045-a2bd-8b68e9e6ca64/scratchpad/verificateur-R05-FR02/scripts/recalcul_fr02.py`.

Usage :
1. Extraire le texte des PDF : `pdftotext <pdf> <dossier>/<variante>-<format>.txt`.
2. Lancer `python3 -I recalcul_fr02.py /home/claude/mindshelf/produits/FR02 <dossier>`.

Résultat du 29.10.2026 : « RESULTAT : tout concorde » (EX01 à EX05 exacts ; cotations Glasgow et Braden conformes ; valeurs douleur, AES, HTA et norme conformes aux sources ; concordance des 8 PDF).

```python
#!/usr/bin/env python3
"""Recalcul indépendant FR02 (vérificateur R05).
Usage : python3 -I recalcul_fr02.py /home/claude/mindshelf/produits/FR02 [dossier_textes_pdf]
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
       "pa_amt_pas": 135, "pa_amt_pad": 85, "oms_indications": 5, "masque_norme": 14683}
for k, v in ATT.items():
    (print if val[k] == v else err)(f"{'OK     ' if val[k]==v else ''}{k} = {val[k]} (source : {v})")
# Concordance PDF : chaque nombre attendu présent dans le texte de chaque variante et format
for var in ("FR02-2009", "FR02-2026"):
    for fmt in ("a4", "letter", "nb", "tablette"):
        t = open(Path(sys.argv[2]) / f"{var}-{fmt}.txt", encoding="utf-8").read() if len(sys.argv) > 2 else None
        if t is None: break
        t1 = re.sub(r"\s+", " ", t)
        for motif in ("60 à 100", "≥ 140/90", "≥ 135/85", "12 à 20", "≥ 95", "36,5 à 37,5", "≥ 4/10", "≥ 40/100", "≥ 2", "de 3 à 15",
                      "3 + 4 + 5 = 12", "Y3 V4 M5", "de 6 à 23", "au moins 5 min", "2,6 %", "1/5", "70°", "dans les 4 h", "24 h", "14683"):
            if motif not in t1: err(f"{var}-{fmt} : « {motif} » absent du PDF")
        print(f"OK     concordance {var}-{fmt}" if ok else f"--     concordance {var}-{fmt}")
print("RESULTAT :", "tout concorde" if ok else "écarts")
sys.exit(0 if ok else 1)
```
