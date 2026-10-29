# EN06-STD : statut et méthode (v2, run R04, 29.10.2026)

**Publication bloquée** (Whop et Etsy) jusqu'à la relecture de la médecin stagiaire. Elle annote directement le PDF A4 (`livraison/EN06-STD/EN06-STD-a4.pdf`) ; l'orchestrateur reporte ses annotations dans les tables de `donnees/`, puis le produit est recompilé.

## Ce qui a été contrôlé, et comment
- Chaque élément de la fiche a une ligne dans `references.csv` (élément → `source_code`, `statut`, localisation). Chaque document est identifié une seule fois dans `sources.csv` (un code par page, date de consultation, date de revue de la page quand elle est connue).
- `statut = source` : la page citée a été lue et soutient la valeur affichée. `statut = A-VERIFIER` : aucune source lisible n'a pu être trouvée dans ce run ; la valeur ou la phrase est usuelle, mais **elle n'est pas vérifiée**.
- Les manuels OpenStax ne sont plus consultés ni cités (licence non commerciale, interdiction d'ingestion par l'IA). Aucune valeur de la fiche ne repose désormais sur eux.
- Les nombres affichés viennent de `valeurs.csv` ; les exemples calculés de `exemples.csv` sont recalculés à la compilation et par le script du vérificateur (0 écart).
- Sources non accessibles dans ce run (demande d'accès restée sans réponse) : NCI Dictionary of Cancer Terms (« dermis »), NIDCD (« Taste Disorders », « How Do We Hear? »), NINDS (« Brain Basics »).

## Points à confirmer par la relectrice
1. **Nœud sinusal (M5)** : la table cardiovasculaire et la carte Anki donnent la fréquence propre du nœud sinusal, 70–80/min sans influx nerveux (chiffre de SEER), et à côté la fréquence cardiaque normale de repos de l'adulte, 60–100/min (MedlinePlus, *Pulse*). D'autres sources donnent une fréquence intrinsèque plus élevée (environ 100/min). Garder le chiffre SEER, le retirer, ou le remplacer ?
2. **Glotte (m7)** : la ligne Larynx dit maintenant « voice box; the glottis is the opening between the vocal cords ». La seconde partie n'a pas de source lue : à confirmer.
3. **Fréquence respiratoire (m8)** : 12–15/min est la moyenne de SEER. L'intervalle de référence des signes vitaux enseigné aux étudiant.e.s infirmier.ère.s est souvent plus large (12–20). Faut-il l'ajouter ?
4. **Potentiel de repos (m9)** : « about −70 mV, set mainly by K⁺ leaking out, with the gradients kept up by the Na⁺/K⁺ pump (ATP) » ; seuil d'environ −55 mV. Sans source lisible : à confirmer.
5. **Couches de l'épiderme** : SEER donne cinq sous-couches et un épiderme plus épais aux paumes et aux plantes. En revanche, « 4 couches en peau fine, sans lucidum » et « épiderme sans vaisseaux » ne sont pas écrits sur la page.
6. **Glandes sudoripares (M6)** : la fiche dit « sweat glands lie deep, down to the subcutaneous layer », d'après MedlinePlus (*Aging changes in skin*, qui les place dans la couche sous-cutanée). La page SEER Melanoma n'est plus citée pour ce point. Les manuels les placent souvent dans le derme profond : quelle formulation garder ?
7. **Éléments sans source lisible (A-VERIFIER dans `references.csv`)** : fonctions des lobes cérébraux et aire de Broca ; rôle du cervelet ; neurotransmetteurs et origine des divisions du SNA ; voies de l'olfaction, tonotopie de la cochlée, vestibule, rétine (dont « 3 kinds of cones ») ; synthèse et activation de la vitamine D ; récepteurs cutanés ; mécanisme de la contraction musculaire et puce Energy (sans chiffre depuis la v2) ; ADH et ocytocine produites par l'hypothalamus, système porte, axe TRH → TSH et rétrocontrôle.
8. **Vaccins après splénectomie** : la note est reformulée et ne cite que des noms de vaccins, sans dose ni calendrier.

## Changements de la v2
- Retirés : 15 s de créatine phosphate, 95 % d'ATP aérobie (OpenStax seul) et les nerfs du goût (aucune source).
- LH : déclenche l'ovulation, fait produire la testostérone par les testicules et, à la puberté, signale aux ovaires de produire l'œstrogène (MedlinePlus ; la page ne parle de l'œstrogène qu'à la puberté).
- Les sources des notes cliniques sont écrites par `#source()` à partir de `sources.csv`. Convention unique : date de consultation.
- Le nombre de systèmes est `G_SYSTEMES` dans `valeurs.csv`. `main.typ` vérifie que `contenu.csv` annonce bien ce nombre : la vignette ne lit pas les marqueurs, donc le chiffre y est écrit, puis contrôlé.
