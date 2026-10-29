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
| FC, FR, SpO₂, température, PA basse de l'adulte | `donnees/valeurs.csv`, clés `fc_bas`, `fc_haut`, `fr_bas`, `fr_haut`, `spo2_bas`, `t_bas`, `t_haut`, `pa_bas_pas`, `pa_bas_pad` |
| Libellés et points du Glasgow | `donnees/glasgow.csv` (colonnes `points`, `reponse`) |
| Items et cotation de Braden | `donnees/braden.csv` (colonnes `item`, `min`, `max`) |
| Ligne d'UE d'une variante | `donnees/variantes.csv`, colonne `valeur` |

## Correction v2 (29.10.2026, après le rapport de vérification v1)

Le contenu a été corrigé après le rapport `verif/rapport-v1.md` (2 bloquants, 12 majeurs, 7 mineurs). Le pied de page porte encore « v1 » : la version vient de `data/variantes.csv`, que le producteur ne modifie pas ; à passer en v2 par l'orchestrateur. Le produit doit repasser chez le vérificateur avant la relecture.

## Points à confirmer (`A-VERIFIER`)

Classés par priorité. Le détail des sources est dans `references.csv`.

1. **Conduite devant une valeur anormale (B1), consigne de prudence sans source** : « Valeur grave ou patient.e qui va mal : alerter immédiatement selon le protocole, puis recontrôler. Valeur anormale isolée chez un.e patient.e stable : recontrôler (matériel, position, repos) et comparer aux valeurs précédentes avant de signaler. En cas de doute, alerter. » Même texte sur la fiche et sur la carte Anki. Aucune source HAS, CHU ou IFSI lue. À valider ou reformuler.
2. **Précautions respiratoires (B2)** : le tableau Air / Gouttelettes (SF2H 2013) est retiré. La fiche dit seulement que la SF2H a remplacé en 2024 cette distinction par trois niveaux (simples, renforcées, maximales) et que le niveau et le type de masque suivent le protocole de l'établissement et l'équipe d'hygiène. Le texte SF2H 2024 lui-même n'a pas été lu (présentations CPias Hauts-de-France et FAQ SF2H lues). Aucun type de masque n'est affiché. « L'équipe d'hygiène » : ajout de prudence, à valider.
3. **Glasgow, réponse non testable (M2)** : « noter NT et la raison, ne pas coter 1 » (patient.e intubé.e, paupières œdématiées). Source non lue. Points lus dans le Manuel MSD (version professionnelle en français) ; libellés de la fiche reformulés, à aligner sur ceux du service.
4. **Constantes FR, SpO₂, température** : toujours sans source qui les soutienne. MedlinePlus (lu) donne FR 12 à 18/min et température 36,5 à 37,3 °C, la fiche affiche 12 à 20 et 36,5 à 37,5 : à trancher (champs `fr_haut`, `t_haut`). SpO₂ ≥ 95 % : non sourcé. FC 60 à 100 : MedlinePlus, lu.
5. **PA basse** : nouvelle ligne « < 90/60 ou en chute » (MedlinePlus, borne basse de l'intervalle usuel, lue). « Ou en chute » : consigne de prudence. À valider ou à remplacer par « selon la prescription ou le protocole ».
6. **Douleur (M6)** : « Sous ces seuils, la douleur reste évaluée, tracée et prise en compte » (fiche et 3 cartes) : consigne, non écrite dans le document HAS IQSS 2023 lu.
7. **Masque en cas de risque de projection (M7)** : la fiche écrit « masque et lunettes, type de masque selon le protocole ». Le type IIR (EN 14683, SF2H 2017) n'a pas pu être lu : à confirmer. Type I : affiché pour le.la patient.e qui tousse (présentation SF2H 2017, CHU Amiens, lue).
8. **Exceptions à la friction (M8)** : mains visiblement souillées, lavage à l'eau et au savon ; *C. difficile* et gale, lavage au savon puis friction. Source lue : quiz CPias Hauts-de-France, mai 2025. À valider.
9. **Précautions Contact (M9)** : chambre seule ou regroupement, signalée ; tablier pour les soins directs ; hygiène des mains en sortant de la chambre. Source secondaire lue (CHU de Saint-Étienne, 2011, d'après SF2H 2009) ; texte SF2H 2009 non lu.
10. **Consignes sans source (M3, M12)** : « toute baisse du Glasgow s'alerte immédiatement » ; « une cible prescrite (SpO₂) passe avant le repère » ; « garder la même échelle de douleur » ; « ne pas déduire le niveau du diagnostic supposé » ; AES « selon la procédure AES de l'établissement », « en stage : le service et l'IFSI ». À valider ou retirer.
11. **Transmissions (M10)** : transmissions ciblées (cible, DAR) sans source ; traçabilité « date, heure », « faits objectifs », « jamais d'acte tracé à l'avance » sans source (le reste : AP-HP 2014, lu). SAED : « reformuler la décision » retiré (p. 13 du guide HAS non relue).
12. **Braden** : items et cotations lus (HUG, 2017) ; aucune source française lue (HAS 2001 non accessible). Seuil : « celui du protocole du service ».
13. **AES** : affiche INRS AA 775 lue ; année d'édition non relevée.
14. **Lignes d'UE** (hors périmètre de la relectrice) : 2009, intitulés lus sur une copie (HPSJ), annexe III officielle non lue ; « Infectiologie hygiène » repris tel quel. 2026, arrêté du 20 février 2026 (NOR ESRS2601184A, JORF du 25.02.2026, texte 53) : « notions mobilisées notamment dans l'UE B.3 », rattachement éditorial ; annexe III non lue.

## Ce qui est contrôlé automatiquement
- Chaque somme (Glasgow 3 à 15, exemple à 12 ; Braden 6 à 23) est recalculée à la compilation (`main.typ`, échec si écart) et par un script indépendant du producteur.
- Cohérence entre `glasgow.csv`, `braden.csv`, `valeurs.csv` et `exemples.csv` contrôlée à la compilation.
- Ligne d'UE : une seule ligne par variante, et son référentiel doit correspondre à l'entrée `referentiel` (échec sinon).
- Les nombres des cartes Anki sont tirés de `valeurs.csv` et `exemples.csv` par marqueurs.
- Script de recalcul du vérificateur relancé sur les PDF v2 : 0 écart.
