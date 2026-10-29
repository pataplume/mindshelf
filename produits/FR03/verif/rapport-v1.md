# FR03 « Bilan biologique — normes françaises » (FR03-2009, FR03-2026) : rapport de vérification v1

Run R05, vérificateur indépendant, 29.10.2026, environ 20 min. Objet : `src/main.typ`, `donnees/*` (hors `extraits.csv`), `livraison/FR03-2009/*` et `livraison/FR03-2026/*` (v1). Les fichiers du conditionneur (`apercus/`, `video/`, `annonce/`, `extraits.csv`, `.apkg`) ne sont pas jugés. Copie de travail : sous-dossier `verificateur-FR03` du scratchpad.

## Verdict : **À corriger**

1 BLOQUANT, 4 MAJEURS, 11 MINEURS.

Ce qui est juste :
- **Calculs.** Les 3 lignes de `exemples.csv` sont exactes. Les 18 bornes en seconde unité ont été recalculées avec des masses molaires saisies à part. 16 concordent au chiffre affiché. Les 2 autres sont des équivalences arrondies par la source (clairance haute 138 → 140 mL/min, glucose haut 0,99 → 1,00 g/L), et la fiche le dit. Voir le script en fin de rapport.
- **Intervalles.** J'ai fait mon propre relevé du PDF CNG V8 (19.11.2009), lu via un outil de lecture web : le téléchargement direct est refusé par le proxy (403). Les 32 lignes `CNG_VBU_2009` de `examens.csv` concordent toutes : bornes, secondes unités, milieux et pages. La source écrit bien les deux formes pour l'hématocrite et l'HbA1c (fraction et %). Elle ne donne pas l'INR et n'écrit pas « à jeun » pour le glucose.
- **Cibles INR.** 2–3 et 3–4,5 concordent avec VIDAL Recos « AVK (traitement par) », mise à jour du 21.10.2025.
- **Seuils DFG.** 60, 90 et 3 mois concordent avec La Revue du Praticien (outil du 15.04.2022).
- **Concordance.** Chaque nombre du PDF vient des tables. Les renvois `{t:…}` et `{v:…}` de `cartes.csv` existent tous.
- **Contrôles techniques.** Recompilé dans une copie : le texte extrait est identique aux PDF livrés. `controle_pdf.py` passe sur les 8 PDF. Le N&B est lisible. Rien n'est coupé. En tablette, les en-têtes de groupe sont répétés et le groupe INR reste avec son en-tête. Les 3 mentions sont présentes.
- **Variantes.** Seule la ligne d'UE diffère : texte identique par ailleurs, contrôlé par `diff`. Aucune UE d'un référentiel n'apparaît dans l'autre variante.
- **Droits.** Je n'ai trouvé aucune phrase reprise. Le tableau est une sélection de valeurs factuelles, regroupée et libellée autrement.
- **Statut.** `statut-methode.md` bloque bien la publication et ne déclare rien « vérifié » à tort (règle 15).

**Date de l'arrêté : c'est le 20 février 2026.** La copie au JO diffusée par la FHF porte en titre « Arrêté du 20 février 2026 relatif au diplôme d'Etat d'infirmier », NOR ESRS2601184A, JORF du 25.02.2026, texte 53 sur 155, « Fait le 20 février 2026 ». La Banque des Territoires (02.03.2026) écrit de même « arrêté du 20 février 2026 » et « décret n° 2026-130 du 20 février 2026 ». Le « 2 février » du document UBE est une coquille de son titre : son introduction écrit elle-même « décret et arrêté publiés du 20 février 2026 ». Légifrance n'était pas lisible depuis ce poste.
- **FR01 n'est pas concernée.** Ses PDF et `references.csv` citent le 20 février, ce qui est juste.
- **Les PDF FR03 ne citent aucune date d'arrêté.** Seul `references.csv` FR03 est à mettre à jour (m10).

Ce qui bloque : la note « INR sous AVK » ne fait signaler que l'INR au-dessus de la cible. La source citée écrit pourtant qu'un INR trop bas expose à la thrombose (B1).

## Constats

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| B1 | BLOQUANT | `main.typ` l. 184-186 (note « INR sous AVK ») ; `cartes.csv` l. 14 (carte « INR sous AVK : qui fixe la cible ? ») | La note dit seulement « Au-dessus de la cible : risque de saignement (surdosage possible), à signaler selon le protocole ». Rien n'est dit de l'INR **en dessous** de la cible, et la carte Anki fait de même (« Au-dessus : risque de saignement, à signaler »). La source citée, VIDAL_AVK_2025 (section Prise en charge), écrit pourtant : « Un INR trop bas traduit un effet anticoagulant insuffisant, avec un risque de thrombose. » En ne citant que le dépassement, la note invite à ne pas signaler un INR sous la cible, par exemple 2,4 chez un.e patient.e porteur.se d'une prothèse mécanique mitrale (cible 3 à 4,5). C'est une phrase juste qui pousse à une mauvaise action, et elle porte sur une classe à haut risque. C'est aussi une régression par rapport à EN08 v2, dont cette fiche est adaptée : sa note dit « below 2.0: clot risk ». | Note : « La cible est fixée par le prescripteur selon l'indication : 2 à 3 le plus souvent, 3 à 4,5 pour certaines prothèses valvulaires mécaniques. En dessous de la cible : anticoagulation insuffisante, risque de thrombose. Au-dessus : surdosage, risque de saignement. Un INR hors de la cible prescrite est à signaler selon le protocole. » Les deux phrases sont dans VIDAL_AVK_2025 (citations ci-dessus) : à ajouter à sa ligne de `references.csv`. Même correction sur la carte Anki. La place existe : le tiers bas de la page A4 est vide. |
| M1 | MAJEUR | `examens.csv` K ; `main.typ` l. 180-182 (note « Kaliémie élevée et hémolyse ») ; `cartes.csv` l. 3-4 | La kaliémie 3,5–4,5 mmol/L (plasma) est fidèle à la source, et c'est un intervalle plasmatique réel : DocCheck Flexikon « Plasmakalium » (27.09.2023) donne 3,4–4,5 mmol/L sur plasma et précise que la coagulation libère du potassium, d'où des valeurs plus hautes sur sérum. Mais elle est nettement plus étroite que les seuils cliniques. VIDAL Actualités (« L'hyperkaliémie, une origine médicamenteuse fréquente », 10.05.2022) écrit « La kaliémie se situe normalement entre 3,5 et 5,5 mmol/L » et définit l'hyperkaliémie au-delà de 5,5 mmol/L. Beaucoup de comptes rendus impriment une borne haute autour de 5,0 (connaissance non sourcée dans ce run). Avec la note « Signaler d'abord une kaliémie élevée », l'étudiant.e lira 4,7 comme une hyperkaliémie. L'erreur va dans le sens d'un excès de signalement, pas d'un oubli : je ne la classe donc pas BLOQUANT. Elle reste une erreur d'interprétation probable en évaluation IFSI comme face à un compte rendu réel. | (1) Dans la note, définir « élevée » sans chiffre : « une kaliémie au-dessus de l'intervalle du compte rendu ». Cela ne demande aucune nouvelle source. (2) Ajouter sous le tableau, ou dans la ligne K : « intervalle plasmatique ; sur sérum et selon la technique, la borne haute imprimée est souvent plus haute », avec une source identifiée (manuel de biochimie clinique avec édition et page). La page DocCheck est une source d'appoint fragile. (3) Ne pas ajouter de seuil d'hyperkaliémie sans source française qui l'écrive et sans validation de la relectrice. |
| M2 | MAJEUR | `main.typ` l. 127 (encadré « Les valeurs usuelles varient… ») ; `donnees/contenu.csv` ; titre (`data/produits.csv`) | La source date de 2009, mais l'année n'est visible que dans la ligne Sources, en bas de page. L'encadré de tête dit « Celles-ci viennent d'un référentiel national publié (adulte) ». (1) « Celles-ci » renvoie grammaticalement aux valeurs **du compte rendu**, ce qui revient à affirmer que les laboratoires appliquent un référentiel national. C'est faux et contraire à l'idée de l'encadré. (2) Rien n'indique l'âge des valeurs à un.e acheteur.se en 2026. Avis sur l'âge : la source reste acceptable. C'est un document national, adulte, en unités SI, avec milieux, encore hébergé par le CNG (chemin `media/2023-04`). Je n'ai trouvé dans ce run aucun référentiel français plus récent du même type, gratuit et lisible ; les pistes CHU, SFBC et EDN n'ont rien donné de citable. Elle n'est acceptable que si sa date et sa nature (référence de concours) sont affichées. | Encadré : « Les valeurs de cette fiche viennent d'un référentiel national publié en 2009 (Conseil scientifique des concours de l'internat en pharmacie), pour réviser. » Il faut lire l'année depuis une table, par exemple une colonne `annee` de la source dans `references.csv` ou `valeurs.csv`, et non la taper en dur. Ajouter la même précision à `contenu.csv`. Pour Tristan : voir m11 (titre). |
| M3 | MAJEUR | `references.csv` : DEFINITION_SI, VIDAL_DFG_2022, REVPRAT_K_2026 | Trois appuis fragiles (règle 12). (1) DEFINITION_SI (1 min = 60 s, fraction × 100) ne désigne aucun document. Les valeurs sont justes, mais la règle 12 refuse une catégorie générique. (2) « CKD-EPI… recommandée par la HAS » n'est soutenu que par un article secondaire (VIDAL 2022) ; la recommandation HAS n'est pas lue. (3) Dans la note « Kaliémie élevée et hémolyse », l'ordre d'action « Signaler d'abord » n'a pas de source. C'est une note clinique en partie sans référence (fiche de poste, point 4). La source citée dit même l'inverse pour le médecin : « La première étape consiste à rechercher une hémolyse du prélèvement » (Rev Prat, mars 2026, médecine de ville). Je juge « signaler d'abord » juste pour le rôle infirmier, mais la fiche doit dire d'où vient cet ordre. | (1) Citer un document identifié, par exemple la brochure SI du BIPM (9e édition, 2019, tableau des unités hors SI acceptées : minute = 60 s ; **non lue dans ce run**, localisation à relever). (2) Lire et citer la HAS : « Évaluation du débit de filtration glomérulaire et du dosage de la créatininémie dans le diagnostic de la maladie rénale chronique chez l'adulte », texte court, décembre 2011, https://has-sante.fr/upload/docs/application/pdf/2012-04/texte_court_dfg_creatininemie.pdf (repérée, phrase de recommandation **non confirmée** par ma lecture). À défaut, écrire « (formule CKD-EPI chez l'adulte) » sans la HAS. (3) Garder « signaler d'abord » comme consigne à valider par la relectrice (déjà A-VERIFIER 7). Ajouter dans `references.csv` que l'ordre de la source concerne la démarche diagnostique du médecin. |
| M4 | MAJEUR | `donnees/contenu.csv` (source de l'annonce) | Le fichier ne décrit pas exactement le PDF. (1) l. 3 : « séparées des valeurs usuelles ». Les cibles INR sont dans le **même tableau**, sous la colonne « Valeurs usuelles », dans un groupe à part. (2) l. 2 : « bilan hépatique » laisse attendre les PAL, absentes (la source ne les donne pas) ; le tableau couvre ASAT, ALAT, GGT et bilirubine. (3) Ni la source ni son année ne sont mentionnées (voir M2). (4) l. 7 devra refléter B1 (au-dessus et en dessous de la cible). | l. 2 : « …bilan hépatique (ASAT, ALAT, GGT, bilirubine), protéines ; d'après un référentiel national de 2009 (CNG) ». l. 3 : « INR sous AVK : cibles fixées par le prescripteur selon l'indication, dans un groupe à part du tableau ». l. 7 : « INR sous AVK (hors cible, au-dessus ou en dessous : signaler) ». |
| m1 | MINEUR | `main.typ` l. 185 ; `examens.csv` INR_VALVE | « 3 à 4,5 pour certaines valves mécaniques ». Selon VIDAL, cette cible vaut aussi pour la valvulopathie mitrale avec dilatation de l'oreillette gauche, contraste spontané ou thrombus (sans prothèse). À l'inverse, une prothèse mécanique aortique sans facteur de risque est à 2–3. Formulation juste mais incomplète ; couverte par « fixée par le prescripteur ». | « pour certaines prothèses valvulaires mécaniques (mitrales notamment) et certaines valvulopathies mitrales ». Libellé de ligne à aligner. |
| m2 | MINEUR | `main.typ` l. 181 ; `cartes.csv` l. 4 | (1) « un contrôle au laboratoire, sans garrot » reprend le cadre de ville de la source (« réalisé au laboratoire »). En service, c'est un nouveau prélèvement. (2) « Il ne retarde pas le signalement » : le référent de « Il » est flou. | « …un nouveau prélèvement de contrôle, sans garrot, peut être prescrit. Ce contrôle ne retarde pas le signalement. » |
| m3 | MINEUR | `main.typ` l. 155 ; `valeurs.csv` dfg_normal | « Au-dessus de 90 » laisse 90 sans stade. La source écrit « > 90 » pour le stade 1 et « entre 60 et 89 » pour le stade 2 ; KDIGO et la HAS écrivent ≥ 90 (non relu dans ce run). | « 90 ou plus », avec une source qui l'écrit (KDIGO 2012, ou guide HAS du parcours MRC). Ou garder « > 90 » tel qu'écrit dans la source. |
| m4 | MINEUR | `examens.csv` GLY (A-VERIFIER 4) | La source n'écrit pas « à jeun ». Sans précision, une glycémie capillaire post-prandiale (cas courant en service) sera lue comme anormale. | Ajouter « à jeun » seulement avec une source qui l'écrit. Sinon, laisser la décision à la relectrice. |
| m5 | MINEUR | `examens.csv` ALB, PROT, HCO3, CRP | D'autres intervalles CNG sont plus étroits que beaucoup de comptes rendus actuels : albumine 38–48 g/L, protéines 65–80 g/L, bicarbonates 23–27 mmol/L. Ce constat vient de ma connaissance, **non sourcée dans ce run**. L'encadré de tête le couvre si M2 est corrigé. | Signaler à la relectrice ; pas de changement sans source. |
| m6 | MINEUR | `main.typ` l. 173 (exemple TCA) | « 1,50 (au-dessus de 1,20) » est juste. Mais un TCA allongé est recherché sous héparine non fractionnée : même logique de cible que l'INR. | Ajouter « hors traitement anticoagulant », avec une source, ou laisser ainsi (valeurs d'exercice). |
| m7 | MINEUR | `main.typ` l. 149, 154, 172 | Nombres tapés dans le Typst : « 1,73 m² » (encadré DFG), 10⁹ et 10¹² (note du tableau), « Deux calculs ». Ce sont des constantes d'unité et un compte, sans erreur. | Les lire depuis `valeurs.csv` (surface de référence, préfixes) et compter les exemples affichés. |
| m8 | MINEUR | `examens.csv` HBA1C (« l'Hb ») ; `variantes.csv` FR03-2026 (« l'offre », « l'Université ») ; `main.typ` | Apostrophes droites dans les données, typographiques ailleurs. Le pied (« l'avis d'un.e ») vient de `data/mentions.csv`, commun à tous les produits. Écriture inclusive : « patient.e » et « entrant.e.s » mais « le prescripteur ». | Apostrophe ’ dans les CSV. Signaler le pied à l'orchestrateur. « le.la prescripteur.rice », ou une tournure neutre (« la prescription »). |
| m9 | MINEUR | `references.csv` UBE_CFVU_2026 | Pages approximatives, chacune lue par extraction de texte. Ma lecture : UEB1 en S1 p. 4 et en S2 p. 15 ; UEB3 « Examens complémentaires » (« Différencier les types d'examens biologiques ») p. 9 ; « Réaliser un prélèvement veineux conforme… » p. 19. Celle du producteur : p. 5, 15-16, 10 et 20. La date du 16.06.2026 vient du nom du fichier ; je ne l'ai pas trouvée dans le texte. | Noter « pages ±1 (extraction de texte) » et « date de la CFVU d'après l'intitulé du fichier ». |
| m10 | MINEUR | `references.csv` UBE_CFVU_2026 et SRC_IFSI_2026 | A-VERIFIER « arrêté du 2 février 2026 » : levé (voir plus haut). | Remplacer par : « le titre du document UBE porte "Arrêté du 2 février 2026", coquille : son introduction et le JO (copie FHF, NOR ESRS2601184A, JORF 25.02.2026, texte 53) donnent le 20 février 2026 ». SRC_IFSI_2026 peut citer directement la copie FHF (lue). |
| m11 | MINEUR | Titre (`data/produits.csv`, pour Tristan) | « normes françaises » laisse croire à une norme officielle, alors que chaque laboratoire fixe ses intervalles. La fiche elle-même dit « valeurs usuelles ». | « Bilan biologique — valeurs usuelles françaises ». Décision de Tristan, car `data/` n'est pas modifiable par le producteur. |

## Points A-VERIFIER (`statut-methode.md`) : avis du vérificateur

| N° | Avis | Bloque la publication ? |
|---|---|---|
| 1. Relevé CNG 2009 | Les 32 lignes concordent avec mon relevé, qui passe lui aussi par une lecture web du PDF. La kaliémie 3,5–4,5 (Pl), le chlorure 95–105, les bicarbonates 23–27, l'albumine 38–48 et les protéines 65–80 sont bien ceux de la source. La relectrice peut s'en tenir à un sondage. | Non |
| 2. Âge de la source | Acceptable s'il est affiché (M2). Pas d'alternative française récente, gratuite et lisible trouvée dans ce run. Points d'écart avec les comptes rendus : M1 (K), m5. | Oui tant que M1 et M2 ne sont pas corrigés |
| 3. Équivalences arrondies | Confirmées : 2,30 mL/s × 60 = 138 (source : 140) ; 5,50 mmol/L × 0,18016 = 0,991 g/L (source : 1,00). Les 16 autres paires concordent. La mention « équivalence arrondie » suffit. Garder. | Non |
| 4. Glucose « à jeun » | Voir m4. | Non |
| 5. Examens absents | Absents de la source (Mg, PAL, Ca ionisé, troponine, D-dimères) ; la source donne le phosphate (p. 3), absent de la fiche. Choix éditorial cohérent. Voir M4 (« bilan hépatique »). | Non |
| 6. Cibles INR | 2–3 et 3–4,5 conformes à VIDAL. « Fixée par le prescripteur » : VIDAL ne l'écrit pas, mais les cibles varient selon l'indication, et la formulation est juste. L'oubli du risque sous la cible est **B1**. | **Oui (B1)** |
| 7. « Signaler d'abord » | Juste pour le rôle infirmier, mais l'ordre est inverse de celui de la source, qui décrit la démarche du médecin (M3). À valider par la relectrice ; formulation m2. | Non, si la relectrice valide |
| 8. « Selon le protocole » | Cohérent avec AVERT_CLINIQUE. Garder. | Non |
| 9. DFG estimé | Seuils conformes à la source. HAS non lue (M3), borne 90 (m3). | Non |
| 10. « Ne pas comparer un TP à une cible d'INR » | Règle de lecture évidente (TP en %, INR sans unité). Elle peut rester sans source si la relectrice la valide. | Non |
| 11. Ligne FR03-2009 | Numéros, intitulés et semestres conformes à FR01 (annexe III, vérifiée dans le run FR01). Le lien avec UE 4.4 est solide (contribution au diagnostic). Le lien avec UE 2.1 « Biologie fondamentale » ne repose que sur l'intitulé. « UE en lien » le couvre. | Non |
| 12. Ligne FR03-2026 | B.1 et B.3, contenus et semestres confirmés dans le document UBE (m9). La mention « selon l'offre… de l'Université de Bourgogne Europe » est juste et nécessaire tant que l'annexe III de l'arrêté n'est pas lue. Date de l'arrêté : **20 février 2026**, levé (m10). | Non |

Après correction, `statut-methode.md` doit être mis à jour : points 1, 3 et 12 confrontés par le vérificateur, et texte INR de B1 à soumettre à la relectrice. Il ne doit écrire « vérifié » pour aucun point que la relectrice n'a pas vu.

## Sources consultées par le vérificateur (29.10.2026)

- CNG, « Valeurs biologiques usuelles », V8 du 19.11.2009 : https://www.cng.sante.fr/sites/default/files/media/2023-04/Constantes_biologiques_adultes_2009.pdf (lecture web ; téléchargement direct 403).
- VIDAL Recos « AVK (traitement par) », mise à jour du 21.10.2025 : https://www.vidal.fr/recommandations/1511/avk_traitement_par/prise_en_charge/
- VIDAL Actualités, Hoppenot I., « L'hyperkaliémie, une origine médicamenteuse fréquente », 10.05.2022 : https://www.vidal.fr/actualites/29089-l-hyperkaliemie-une-origine-medicamenteuse-frequente.html
- La Revue du Praticien, « Hyperkaliémie modérée en ville : quelle cause évoquer ? », mars 2026 (partie publique) : https://www.larevuedupraticien.fr/exercice/hyperkaliemie-moderee-en-ville-quelle-cause-evoquer
- La Revue du Praticien Médecine générale, « Stades de la maladie rénale chronique », 15.04.2022 : https://www.larevuedupraticien.fr/outil/stades-de-la-maladie-renale-chronique
- DocCheck Flexikon, Antwerpes F., « Plasmakalium », 27.09.2023 : https://flexikon.doccheck.com/de/Plasmakalium
- Arrêté du 20 février 2026 relatif au diplôme d'État d'infirmier, copie JO (FHF) : https://www.fhf.fr/sites/default/files/2026-02/Arr%C3%AAt%C3%A9%20r%C3%A9ing%C3%A9nierie%20formation%20IDE.pdf
- Banque des Territoires, « Réforme de la formation infirmière : publication du décret sur l'universitarisation et de l'arrêté », 02.03.2026 : https://www.banquedesterritoires.fr/reforme-de-la-formation-infirmiere-publication-du-decret-sur-luniversitarisation-et-de-larrete
- Université de Bourgogne Europe, délibération CFVU (réforme du diplôme infirmier) : https://www.ube.fr/wp-content/uploads/2026/07/CA_07072026_delib11_commission_CFVU_16juin2026_reforme_diplome_infirmier.pdf
- Pas consulté : OpenStax (règle 3), Légifrance (non lisible).

## Script de recalcul

Exécuté avec `python3 -I recalc_fr03.py produits/FR03/donnees`.
- **Résultat :** 0 écart sur les 3 exemples, les 32 lignes CNG, les 2 cibles INR, les 6 valeurs et les renvois des cartes.
- **Équivalences arrondies par la source :** 2 (clairance haute, glucose haut).

```python
"""Recalcul indépendant FR03 (vérificateur R05). Usage : python3 -I recalc_fr03.py <dossier produits/FR03/donnees>"""
import csv, json, re, sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

D = Path(sys.argv[1])
lire = lambda f: list(csv.DictReader(open(D / f, encoding="utf-8")))
ecarts, signalements = [], []

def arr(x, n):  # arrondi au demi supérieur, en décimal
    return Decimal(repr(x)).quantize(Decimal(1).scaleb(-n), rounding=ROUND_HALF_UP)

def dec(s):  # nombre de décimales écrites dans la source
    return len(s.split(".")[1]) if "." in s else 0

# 1. exemples.csv : formule ré-évaluée (calc.pow -> pow), comparée au résultat attendu et à l'arrondi affiché
print("== exemples.csv")
for l in lire("exemples.csv"):
    e = json.loads(l["entrees_json"])
    f = l["formule"].replace("calc.pow", "pow")
    assert re.fullmatch(r"[A-Za-z0-9_ .+\-*/(),]+", f), f
    x = eval(f, {"__builtins__": {}, "pow": pow}, e)
    ok = abs(x - float(l["resultat_attendu"])) <= float(l["tolerance"])
    print(f"{'OK ' if ok else 'ÉCART'} {l['id']}  {f} = {x!r}  attendu {l['resultat_attendu']}  affiché {arr(x, int(l['arrondi']))}")
    if not ok:
        ecarts.append(l["id"])

# 2. examens.csv : « Autre écriture » recalculée depuis la valeur SI
#    Masses molaires recalculées ici depuis les masses atomiques abrégées CIAAW 2021 (saisies indépendamment)
AW = {"H": 1.008, "C": 12.011, "N": 14.007, "O": 15.999, "Ca": 40.078}
def masse(formule):
    return sum(AW[el] * (int(n) if n else 1) for el, n in re.findall(r"([A-Z][a-z]?)(\d*)", formule))
# facteur : SI -> autre unité
FACT = {
    "CA": masse("Ca"),                       # mmol/L -> mg/L
    "UREE": masse("CH4N2O") / 1000,          # mmol/L -> g/L
    "CREA_H": masse("C4H7N3O") / 1000,       # µmol/L -> mg/L
    "CREA_F": masse("C4H7N3O") / 1000,
    "CLAIR": 60,                             # mL/s -> mL/min
    "GLY": masse("C6H12O6") / 1000,          # mmol/L -> g/L
    "HBA1C": 100, "HT_H": 100, "HT_F": 100,  # fraction -> %
    "BILI": masse("C33H36N4O6") / 1000,      # µmol/L -> mg/L
}
print("\n== examens.csv : seconde unité (affiché | recalculé à la précision affichée | valeur exacte)")
ex = {l["cle"]: l for l in lire("examens.csv")}
for cle, f in FACT.items():
    l = ex[cle]
    for b in ("bas", "haut"):
        si, autre = l[b], l["autre_" + b]
        if not si:
            continue
        x = float(si) * f
        r = arr(x, dec(autre))
        drap = "" if r == Decimal(autre) else "  <-- équivalence arrondie par la source"
        if drap:
            signalements.append(f"{cle} {b} : {si} {l['unite']} -> {x:.4f}, affiché {autre} {l['autre_unite']}")
        print(f"{cle:7} {b:4} {si:>6} {l['unite']:7} -> affiché {autre:>5} {l['autre_unite']:6} | {r} | {x:.4f}{drap}")

# 3. examens.csv confronté au relevé du vérificateur (CNG, V8 19.11.2009, lecture web du PDF, 29.10.2026)
CNG = {"NA": ("135", "145", "p. 3"), "K": ("3.5", "4.5", "p. 3"), "CL": ("95", "105", "p. 3"),
       "HCO3": ("23", "27", "p. 3"), "CA": ("2.20", "2.60", "p. 3"), "UREE": ("2.5", "7.5", "p. 3"),
       "CREA_H": ("60", "115", "p. 3"), "CREA_F": ("45", "105", "p. 3"), "CLAIR": ("1.50", "2.30", "p. 3"),
       "GLY": ("3.90", "5.50", "p. 4"), "HBA1C": ("", "0.06", "p. 4"), "HB_H": ("130", "170", "p. 4 et 6"),
       "HB_F": ("120", "160", "p. 4 et 6"), "HT_H": ("0.42", "0.54", "p. 6"), "HT_F": ("0.37", "0.47", "p. 6"),
       "GR_H": ("4.5", "5.7", "p. 6"), "GR_F": ("4.2", "5.2", "p. 6"), "LEUCO": ("4.0", "10.0", "p. 6"),
       "PNN": ("2", "7.5", "p. 6"), "PLAQ": ("150", "450", "p. 6"), "TP": ("70", "130", "p. 6"),
       "TCA": ("0.80", "1.20", "p. 6"), "FIB": ("2", "4", "p. 6"), "CRP": ("", "5", "p. 5"),
       "ASAT": ("", "35", "p. 4"), "ALAT_H": ("", "45", "p. 4"), "ALAT_F": ("", "34", "p. 4"),
       "GGT_H": ("", "55", "p. 4"), "GGT_F": ("", "38", "p. 4"), "BILI": ("", "17", "p. 4"),
       "ALB": ("38", "48", "p. 5"), "PROT": ("65", "80", "p. 5")}
print("\n== examens.csv vs relevé CNG du vérificateur")
for cle, (b, h, p) in CNG.items():
    l = ex[cle]
    ok = (l["bas"], l["haut"], l["localisation"]) == (b, h, p) and l["source_code"] == "CNG_VBU_2009"
    print(f"{'OK ' if ok else 'ÉCART'} {cle:7} {l['bas']}–{l['haut']} {l['unite']} ({l['localisation']})")
    if not ok:
        ecarts.append("CNG " + cle)
print("Lignes CNG du CSV non relevées :", sorted(k for k, l in ex.items() if l["source_code"] == "CNG_VBU_2009" and k not in CNG) or "aucune")

# 4. Cibles INR confrontées à VIDAL Recos « AVK (traitement par) », 21.10.2025 (lu le 29.10.2026)
VIDAL = {"INR_AVK": ("2", "3"), "INR_VALVE": ("3", "4.5")}
for cle, (b, h) in VIDAL.items():
    ok = (ex[cle]["bas"], ex[cle]["haut"]) == (b, h)
    print(f"{'OK ' if ok else 'ÉCART'} {cle} {ex[cle]['bas']}–{ex[cle]['haut']} (VIDAL {b}–{h})")
    if not ok:
        ecarts.append(cle)

# 5. valeurs.csv : seuils MRC (Rev Prat 2022 : stade 2 60-89, stade 3 < 60, persistance > 3 mois)
v = {l["cle"]: float(l["valeur"]) for l in lire("valeurs.csv")}
for cle, att in {"dfg_seuil_mrc3": 60, "dfg_stade2_bas": 60, "dfg_normal": 90, "mrc_mois": 3, "s_par_min": 60, "pct": 100}.items():
    ok = v[cle] == att
    print(f"{'OK ' if ok else 'ÉCART'} valeurs.csv {cle} = {v[cle]} (attendu {att})")
    if not ok:
        ecarts.append(cle)

# 6. cartes.csv : chaque renvoi {t:examens:CLE:champ} et {v:cle} existe et n'est pas vide
print("\n== cartes.csv : renvois")
for c in lire("cartes.csv"):
    for kind, cle, champ in re.findall(r"\{(t|v):(?:examens:)?([A-Za-z0-9_]+)(?::([a-z_]+))?\}", c["verso"]):
        val = ex[cle][champ] if kind == "t" and cle in ex else (str(v.get(cle, "")) if kind == "v" else "")
        if val == "":
            ecarts.append(f"carte {c['recto'][:30]} : {cle}:{champ}")
            print("ÉCART renvoi vide/inconnu", cle, champ)
print("renvois contrôlés")

print("\nÉcarts :", ecarts or "aucun")
print("Équivalences arrondies par la source :", *signalements, sep="\n  ")
```

Sortie (extrait) :

```
OK  EX01  M / T = 1.5  attendu 1.5  affiché 1.50
OK  EX02  C * S = 90.0  attendu 90  affiché 90
OK  EX03  H * P = 42.0  attendu 42  affiché 42
CLAIR   haut   2.30 mL/s    -> affiché   140 mL/min | 138 | 138.0000  <-- équivalence arrondie par la source
GLY     haut   5.50 mmol/L  -> affiché  1.00 g/L    | 0.99 | 0.9909  <-- équivalence arrondie par la source
(16 autres paires : concordantes ; 32 lignes CNG : OK ; INR_AVK, INR_VALVE : OK ; valeurs.csv : OK)
Écarts : aucun
```
