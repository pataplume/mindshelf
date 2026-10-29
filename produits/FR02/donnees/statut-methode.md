# Relecture infirmière en attente

**Produit :** FR02 « Pack stage IFSI (constantes, échelles, transmissions, précautions) » (marque Clairance, marché FR, étudiant.e.s en IFSI qui partent en stage), variantes **FR02-2009** (référentiel 2009) et **FR02-2026** (référentiel 2026).
**Statut :** rédigé par l'agent producteur (run R05, 29.10.2026), `methode_auteur = AGENT`, risque IA **FAIBLE** (Whop et Etsy possibles après relecture). Version **v1** (pied de page, `data/variantes.csv`).

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE INFIRMIÈRE.** Aucun dépôt Whop ou Etsy, ni envoi du PDF à qui que ce soit, tant que `data/revues.csv` ne contient pas, pour chaque variante (FR02-2009 et FR02-2026), une ligne `etape_code` de relecture métier avec un `statut_code` validé. Raison : le pied de page affirme « contenu vérifié et validé par le vendeur », ce qui n'est exact qu'après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

Rien dans ce produit n'a été relu par un.e professionnel.le de santé. « Lu » ci-dessous veut dire : source ouverte et lue par l'agent le 29.10.2026, pas validée.

## Pour la relectrice

### Fichier à relire
`livraison/FR02-2009/FR02-2009-a4.pdf` (2 pages). La variante 2026 a le même contenu : seule la première ligne (rattachement aux UE) change. Letter, N&B et tablette : même contenu, autre mise en page.

### Périmètre
- **Relu par la relectrice (infirmière) :** les valeurs, la sécurité des patient.e.s et des soignant.e.s, les conduites affichées et la clarté.
- **Pas demandé comme validation :** les intitulés et numéros d'UE des référentiels 2009 et 2026 (ils reposent sur les sources citées dans `references.csv`) et la citation exacte des textes HAS, SF2H, OMS et INRS. Elle peut signaler ce qui lui paraît faux.
- Aucune dose de médicament, aucune conduite thérapeutique : la seule conduite est « alerter selon le protocole du service ». Polyvidone iodée et Dakin sont cités sans dose, comme sur l'affiche INRS.

### Comment consigner ses décisions
Une décision = un code de ligne + une valeur, jamais une note en texte. Elle les donne au producteur (ou à l'orchestrateur), qui les reporte dans le champ indiqué et recompile (`python3 scripts/build.py FR02-2009` puis `FR02-2026`).

| Point | Champ |
|---|---|
| FC, FR, SpO₂, température de l'adulte | `donnees/valeurs.csv`, clés `fc_bas`, `fc_haut`, `fr_bas`, `fr_haut`, `spo2_bas`, `t_bas`, `t_haut` |
| Libellés et points du Glasgow | `donnees/glasgow.csv` (colonnes `points`, `reponse`) |
| Items et cotation de Braden | `donnees/braden.csv` (colonnes `item`, `min`, `max`) |
| Ligne d'UE d'une variante | `donnees/variantes.csv`, colonne `valeur` |

## Points à confirmer (`A-VERIFIER`)

Classés par priorité. Le détail des sources est dans `references.csv`.

1. **Constantes FC, FR, SpO₂, température** : aucune source française lue. Valeurs usuelles enseignées ; bornes de température selon le site de mesure. Seuls les seuils d'HTA (HAS 2016) sont lus.
2. **Glasgow, libellés et points** : seuls les trois critères et l'étendue 3 à 15 sont lus (CHUV). La cotation de chaque réponse vient de Teasdale et Jennett (1974), non lu ; une copie en ligne lue était incohérente et n'est pas retenue. Libellés à aligner sur ceux du service.
3. **Braden** : items et cotations lus (HUG, fiche de soins de juillet 2017) ; total 6 à 23 calculé. Aucun seuil chiffré affiché : le seuil est « celui du protocole du service ». La fiche HUG donne 15–18 faible, 13–14 modéré, ≤ 12 élevé : faut-il afficher un seuil (et lequel) ? Source française (HAS 2001) non lue.
4. **Consignes génériques sans source** : « recontrôler puis alerter ; le recontrôle ne retarde jamais l'alerte » (constantes) ; « toute baisse du Glasgow s'alerte immédiatement » ; « une cible prescrite (SpO₂) passe avant le repère » ; « garder la même échelle de douleur » ; « toute douleur exprimée se trace et se réévalue » ; « le type de précautions se lit sur la signalétique ». À valider ou retirer.
5. **Douleur** : les seuils (≥ 4/10, EVS ≥ 2, Algoplus ≥ 2) sont ceux de l'indicateur HAS IQSS 2023 (lu). La fiche dit « seuil de prise en charge (indicateur HAS) » et ajoute que toute douleur se trace et se réévalue : formulation à valider (éviter qu'une douleur à 3/10 soit ignorée).
6. **Précautions standard** : champ, friction hydro-alcoolique, « pas de gants sur peau saine », masque de type I lus (présentation du groupe SF2H, CHU Amiens 2017 ; le texte SF2H lui-même n'a pas pu être ouvert). **Non lus** : indication des gants (sang, liquide biologique, muqueuse, peau lésée), lunettes si risque de projection, masque pour le.la patient.e qui tousse.
7. **Précautions Gouttelettes et Contact** : non sourcées (la synthèse SF2H 2013 lue ne traite que de l'air). Précautions Air : lues (R2, R3, FFP2, fit check).
8. **Transmissions ciblées (cible, DAR)** : aucune source lue. SAED : lu (HAS 2014). Traçabilité : identification de l'auteur.rice et administration tracée sur le support de la prescription lus (AP-HP 2014) ; « date, heure », « faits objectifs », « jamais d'acte tracé à l'avance » non lus.
9. **AES** : premiers soins et délais lus sur l'affiche INRS AA 775 (année d'édition non relevée). Ajouts pour l'étudiant.e, non sourcés : « selon la procédure AES de l'établissement », « en stage : le service et l'IFSI ».
10. **Lignes d'UE** : 2009 (UE 2.10, 3.1, 4.1, 4.3) non relues dans l'annexe III ; 2026 (UE B.3, évaluée en stage ou en pratique simulée) reprise de FR01 (arrêté du 20 février 2026, art. 23 ; UBE), non relue dans ce run. Hors périmètre de la relectrice ; à vérifier par le vérificateur.

## Ce qui est contrôlé automatiquement
- Chaque somme (Glasgow 3 à 15, exemple à 12 ; Braden 6 à 23) est recalculée à la compilation (`main.typ`, échec si écart) et par un script indépendant du producteur.
- Cohérence entre `glasgow.csv`, `braden.csv`, `valeurs.csv` et `exemples.csv` contrôlée à la compilation.
- Ligne d'UE : une seule ligne par variante, et son référentiel doit correspondre à l'entrée `referentiel` (échec sinon).
- Les nombres des cartes Anki sont tirés de `valeurs.csv` et `exemples.csv` par marqueurs.
