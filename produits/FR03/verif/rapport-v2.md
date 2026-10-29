# FR03 « Bilan biologique — valeurs usuelles françaises » (FR03-2009, FR03-2026) : rapport de vérification v2

Run R05, vérificateur indépendant, 29.10.2026, environ 10 min. Il s'agit d'une contre-vérification ciblée : je contrôle les corrections de la v1 et ce qu'elles ont pu casser, sans refaire une vérification complète. J'ai lu `src/main.typ`, `donnees/*` (dont le nouveau `sources.csv`), `livraison/FR03-2009/*` et `livraison/FR03-2026/*`, ainsi que les deux annonces, sur l'exactitude des promesses seulement. Copie de travail : `verificateur-R05-FR03-v2` dans le scratchpad.

## Verdict : **À corriger** (correction ciblée)

1 MAJEUR nouveau, 0 BLOQUANT. Les autres constats restants sont mineurs ou attendent la relectrice.

- **Le bloquant B1 (INR) est levé.** J'ai relu les deux risques dans VIDAL.
- **Un MAJEUR nouveau, N1.** La v2 ajoute un seuil d'hyperkaliémie (> 5,5 mmol/L). La phrase est fidèle à VIDAL Actualités 2022, mais elle le présente comme la définition, alors qu'une autre source française récente écrit > 5 mmol/L. Sur la fiche, il crée aussi une zone de 4,5 à 5,5 mmol/L que rien n'explique.
- **La correction est petite** : une phrase de la note et une phrase d'une carte. Une fois faite, le verdict passe à « OK avec réserves », les réserves étant les points de la relectrice ci-dessous.

Ce qui est juste :
- **Recalcul : 0 écart.** J'ai relancé le script v1 sans le modifier, puis un complément v2, joint en fin de rapport. Le complément couvre :
  - les nouvelles valeurs ;
  - le nouveau type de renvoi `{t:sources:…}`, que le script v1 ne lisait pas ;
  - la concordance entre le PDF et les CSV : 34 lignes d'examens et 11 fragments (seuils, années, dates des sources).

  Les deux équivalences arrondies par la source sont inchangées (clairance haute 138 → 140 mL/min, glucose haut 0,99 → 1,00 g/L).
- **Build.** `python3 scripts/build.py FR03-2009` puis `FR03-2026` ont tourné dans une copie, et chacun a donné « 4 PDF fabriqués et contrôlés ». `controle_pdf.py` passe sur les 8 PDF.
  - **Pages.** A4, Letter et N&B tiennent sur 1 page, la tablette sur 2. Il reste un blanc d'environ 15 % en bas de l'A4.
  - **Texte.** Le texte extrait des 8 PDF recompilés est identique à celui des PDF livrés.
  - **N&B.** Lisible : rendu examiné.
- **Variantes.** Le `diff` du texte de FR03-2009 et de FR03-2026 a été fait sur les 4 formats. Il ne montre que les 2 lignes d'UE, et aucune UE d'un référentiel n'apparaît dans l'autre variante.
- **Sources relues le 29.10.2026 :**
  - **VIDAL Recos AVK** (mise à jour du 21.10.2025), section « Conseils aux patients » : « Un INR trop bas traduit un effet anticoagulant insuffisant, avec un risque de thrombose. » et « Un INR trop élevé traduit un surdosage, avec un risque hémorragique. » Les cibles sont 2 à 3, et 3 à 4,5 (cible 3,7) pour la prothèse mécanique mitrale, la valvulopathie mitrale avec dilatation de l'OG ou thrombus, et la prothèse mécanique aortique avec un autre facteur de risque ou de 1re génération. Conforme.
  - **VIDAL Actualités** (Hoppenot I., avec le Pr Baumelou, 10.05.2022), section « Comment est définie l'hyperkaliémie ? » : « L'hyperkaliémie est définie par un taux de potassium plasmatique supérieur à 5,5 mmol/L. » La citation est exacte. La même page écrit : « La kaliémie se situe normalement entre 3,5 et 5,5 mmol/L. »

## Suivi des constats v1

| # | État | Preuve |
|---|---|---|
| B1 INR | **Levé** | PDF A4, note « INR sous AVK » : « Au-dessus de la cible : surdosage, risque hémorragique. Au-dessous de la cible : effet anticoagulant insuffisant, risque de thrombose. Dans les deux cas, signaler selon le protocole. » Même contenu sur la carte (`cartes.csv` l. 14) et dans l'Anki livré. Les deux phrases sont dans VIDAL, relu. |
| M1 Kaliémie | **Partiellement levé** | (1) Fait : « Kaliémie élevée = au-dessus de l'intervalle du compte rendu du laboratoire » (note et carte l. 4). (2) Non fait : rien sur l'écart plasma / sérum. (3) Le seuil chiffré que la v1 déconseillait d'ajouter sans validation a été ajouté, avec une source : voir **N1**. |
| M2 Âge de la source | **Levé** | Encadré de tête : « …viennent d'une liste nationale de l'adulte publiée en 2009 (Conseil scientifique des concours de l'internat en pharmacie, « Valeurs biologiques usuelles », diffusé par le CNG) ». Note sous le tableau : « Valeurs de 2009, indicatives ». Les deux sont lues dans `sources.csv` (`annee`, `auteur`, `titre`, `complement`), et « Celles-ci », qui était ambigu, a disparu. |
| M3 Appuis fragiles | **Partiellement levé** | (1) La ligne `DEFINITION` dit honnêtement « Aucun document n'est cité ». C'est toujours une catégorie générique (règle 12), et le code `DEFINITION` n'a pas de ligne dans `sources.csv`. Je le rétrograde en MINEUR (m-r1), parce que 1 min = 60 s et ×100 sont des définitions sans enjeu. (2) Levé : « recommandée par la HAS » est retiré ; la fiche écrit « (formule CKD-EPI chez l'adulte) ». (3) Levé sur le fond : la référence explique maintenant que l'ordre de la source décrit la démarche du médecin, et « signaler d'abord » est présenté comme une consigne de prudence (« Par prudence »), marqué `A_VERIFIER`. C'est une note clinique sans référence : elle reste une réserve pour la relectrice (point 2 ci-dessous). |
| M4 `contenu.csv` | **Levé** | l. 2 : « bilan hépatique (ASAT, ALAT, GGT, bilirubine), albumine et protéines ; d'après la liste nationale… du CNG (version de 2009) ». l. 3 : « dans un groupe distinct du même tableau ». l. 7 : au-dessus et au-dessous. |
| m1 Atteintes valvulaires | Levé | « 3 à 4,5 pour certaines atteintes valvulaires (prothèse mécanique mitrale notamment) ». C'est un résumé fidèle des trois lignes VIDAL. |
| m2 Contrôle sans garrot | Levé | « un nouveau prélèvement de contrôle, sans garrot, peut être prescrit. Ce contrôle ne retarde pas le signalement. » |
| m3 DFGe ≥ 90 | **Partiellement levé** | Voir la section « Points demandés ». La fiche écrit « DFGe ≥ 90 », alors que la source citée (REVPRAT_MRC_2022) écrit « > 90 ». Aucune source lue ne soutient « ≥ ». |
| m4 Glycémie « à jeun » | Non levé, choix documenté | Le tableau écrit « Glucose, Pl, 3,90–5,50 mmol/L ». Voir la section « Points demandés ». |
| m5 Intervalles étroits | Levé (renvoi relectrice) | Point 1 de `statut-methode.md`, couvert par l'encadré de tête. |
| m6 TCA hors anticoagulant | Non levé | « 1,50 (au-dessus de 1,20) » n'a pas changé. Acceptable : ce sont des valeurs d'exercice, et rien n'est dit d'un patient sous héparine. |
| m7 Nombres en dur | **Non levé** | `main.typ` l. 173 « mL/min/1,73 m² », l. 168 « 10#super[9] » et « 10#super[12] », l. 191 « Deux calculs ». L'en-tête l. 6 affirme toujours « Aucun nombre n'est tapé ici ». La v2 ajoute des chiffres saisis à la main dans `contenu.csv` (« DFGe ≥ 90 », « 3 pièges », « 2 calculs », « 2 repères »), repris dans les annonces : ils ne suivront pas `valeurs.csv`. |
| m8 Typographie et inclusif | Partiellement levé | Inclusif : « le.la prescripteur.rice » partout. Apostrophes : corrigées dans `examens.csv` et `variantes.csv`, mais `cartes.csv` garde des apostrophes droites (rectos l. 2, 3, 4 : « l'adulte », « d'abord »), visibles dans l'Anki. Le pied commun (« l'avis d'un.e ») relève de l'orchestrateur. |
| m9 Pages UBE | Levé | `references.csv` UBE_CFVU_2026 : « Pages ±1 (extraction de texte) : producteur… ; vérificateur… », et « Date de la CFVU… d'après l'intitulé du fichier ». |
| m10 Date de l'arrêté | Levé | `references.csv` SRC_IFSI_2026 : 20 février 2026, NOR, JORF, copie FHF ; la coquille UBE est signalée. |
| m11 Titre | Levé dans la fiche, pas dans l'annonce Etsy | PDF, métadonnées et `data/produits.csv` l. 16 : « Bilan biologique — valeurs usuelles françaises ». Décision encore à confirmer par Tristan. L'annonce Etsy garde « normes » (N4). |

## Points demandés

**B1 (INR).** Levé. Les deux risques sont présents et fidèles à VIDAL, sur la fiche comme sur la carte. Une correction mineure : `references.csv` situe bien les deux phrases dans « Conseils aux patients », alors que la v1 écrivait « Prise en charge ».

**Seuil d'hyperkaliémie > 5,5 mmol/L.** La citation VIDAL 2022 est exacte. Le seuil pose pourtant problème : voir N1.
- **Les sources divergent.** La Revue du Praticien (Nobile C., « Hypo/hyperkaliémie : conduite à tenir en MG », publiée le 09.04.2024, mise à jour le 31.03.2026, accès partiel, lue le 29.10.2026) écrit « Définie par une kaliémie > 5 mmol/L ». La fiche, elle, écrit « L'hyperkaliémie **se définit** par… > 5,5 », comme s'il n'y avait qu'une définition. Elle s'appuie sur un entretien publié dans une actualité, c'est-à-dire une source secondaire.
- **La fiche crée un trou.** Le tableau affiche 3,5–4,5 (CNG) et la note > 5,5 (VIDAL). Entre 4,5 et 5,5, l'étudiant.e ne sait pas où se situe la valeur. La carte Anki « Kaliémie : valeurs usuelles » juxtapose les deux nombres sans transition.
- **Ce n'est pas BLOQUANT.** La consigne d'action vient en premier (« élevée = au-dessus de l'intervalle du compte rendu », puis « la signaler ») et couvre la zone de 5,0 à 5,5. L'erreur porte donc sur le libellé (« ce n'est pas une hyperkaliémie »), pas sur la conduite à tenir. Elle reste probable en évaluation IFSI si le cours enseigne > 5,0.

**DFGe ≥ 90 alors que la source écrit « > 90 ».** C'est acceptable sur le fond :
- c'est la convention KDIGO (G1 ≥ 90) ;
- elle seule place 90 dans un stade ;
- la compilation contrôle que `dfg_normal − 1 = dfg_stade2_haut` (89, « entre 60 et 89 » dans la source).

Au sens strict de la règle 12, en revanche, ce n'est pas conforme : la valeur affichée diffère de la source citée, et aucune source lue ne l'écrit. MINEUR (m-r2). Correction : citer KDIGO 2012 (Kidney Int Suppl 2013;3(1), tableau des catégories de DFG), ou le guide HAS du parcours de soins MRC. Je n'ai lu ni l'un ni l'autre dans ce run : la localisation reste à relever. À défaut, garder le point A-VERIFIER 9 pour la relectrice, ce qui est déjà fait.

**« Par prudence, la signaler d'abord ».** Le fond est acceptable : il va dans le sens de la sécurité, il est présenté comme une consigne de prudence et non comme une donnée sourcée, et le texte dit explicitement que la source décrit la démarche du médecin. Il reste une note clinique sans référence (fiche de poste, point 4), sans document infirmier lisible trouvé. **Il n'est pas publiable sans l'accord explicite de la relectrice.** C'est une réserve, pas un défaut à corriger par le producteur.

**Glycémie sans « à jeun ».** C'est acceptable avec une réserve ; ce n'est pas un défaut :
- la source n'écrit pas « à jeun », et l'ajouter sans source contredirait la règle 12 ;
- l'erreur possible va dans le sens d'un excès de signalement (une glycémie capillaire ou post-prandiale lue comme haute), pas d'un oubli ;
- l'encadré de tête renvoie au compte rendu ;
- le risque est consigné (A-VERIFIER 4).

MINEUR (m-r3), à trancher par la relectrice. Si elle veut une précision, la plus sûre ne demande aucun nouveau chiffre : « intervalle sur plasma veineux ; une glycémie capillaire ou après un repas ne se compare pas directement à cet intervalle ». Elle reste à valider ou à sourcer.

## Constats v2

| # | Gravité | Emplacement | Constat | Correction proposée |
|---|---|---|---|---|
| N1 | MAJEUR | `main.typ` l. 200 (note « Kaliémie élevée et hémolyse ») ; `cartes.csv` l. 3 (carte « Kaliémie : valeurs usuelles ») ; `valeurs.csv` `k_hyperkaliemie` | « L'hyperkaliémie se définit par un potassium plasmatique > 5,5 mmol/L » présente comme unique une définition qui varie selon les sources : > 5,5 chez VIDAL Actualités 2022, > 5 dans La Revue du Praticien MG mise à jour le 31.03.2026. Sur la fiche, la phrase crée une zone de 4,5 à 5,5 mmol/L sans explication, entre la borne CNG et ce seuil. Ce seuil a été ajouté sans la validation de la relectrice que demandait la v1 (M1, point 3). | Option A, recommandée : retirer la phrase et la mention de la carte. La consigne « élevée = au-dessus de l'intervalle du compte rendu » suffit, et c'était la recommandation v1. Option B : « Le seuil qui définit l'hyperkaliémie varie selon les sources (> 5 ou > 5,5 mmol/L) », avec les deux sources dans `references.csv` et `sources.csv`. Le seuil reste alors une table : deux lignes dans `valeurs.csv`, et le contrôle de compilation de la l. 119 est à adapter. Dans les deux cas, A-VERIFIER 7 doit mentionner la divergence. |
| N2 | MINEUR | Carte « Kaliémie : valeurs usuelles » (rendu Anki) | « (CNG, version **de** 19.11.2009) » : il faut « du ». Le renvoi `{t:sources:CNG_VBU_2009:date}` fonctionne. | « version du {t:sources:CNG_VBU_2009:date} ». |
| N3 | MINEUR | `annonce/whop.md`, paragraphe « Valeurs » | « valeurs usuelles du **référentiel du CNG** (2009) » : le CNG n'est que le diffuseur, et « référentiel » laisse de nouveau croire à une norme (ce que corrigeait m11). L'annonce Etsy le dit correctement (« liste nationale… du Conseil scientifique…, diffusée par le CNG »). | Reprendre la formule de l'annonce Etsy. |
| N4 | MINEUR | `annonce/etsy/annonce.md`, titre et tags | Titre : « Fiche bilan biologique IFSI : **normes** et valeurs usuelles de l'adulte ». Tags : « normes biologiques », « normes bilan sanguin », « valeurs normales ». Ces mots se justifient pour le référencement dans les tags, mais le titre contredit le changement « normes » → « valeurs usuelles ». | Décision de Tristan, avec m11 : garder « normes » dans les tags seulement, et retirer le mot du titre. |
| m-r1 | MINEUR | `valeurs.csv` `s_par_min`, `pct` (`source_code = DEFINITION`) | Ex-M3 (1) : catégorie générique, sans ligne dans `sources.csv`. | Citer la brochure SI du BIPM, 9e édition (2019), tableau des unités hors SI acceptées, et ajouter la ligne à `sources.csv`. |
| m-r2 | MINEUR | `valeurs.csv` `dfg_normal` ; fiche « DFGe ≥ 90 » | Ex-m3 : la valeur affichée (≥) diffère de la source citée (>). Règle 12. | Citer KDIGO 2012 ou la HAS (localisation à relever), ou attendre la décision de la relectrice (A-VERIFIER 9). |
| m-r3 | MINEUR | `examens.csv` GLY | Ex-m4 : pas de « à jeun ». | Décision de la relectrice (A-VERIFIER 4). |
| m-r4 | MINEUR | `main.typ` l. 6, 168, 173, 191 ; `contenu.csv` l. 4-7 | Ex-m7 : nombres saisis à la main ; l'en-tête du Typst affirme le contraire. | Lire 1,73, 10⁹ et 10¹² depuis `valeurs.csv`, compter les exemples et les pièges, et construire `contenu.csv` l. 4 depuis `dfg_normal` (ou ne pas y écrire de chiffre). |
| m-r5 | MINEUR | `cartes.csv` rectos | Ex-m8 : apostrophes droites restantes. | ’ partout. |

Rien n'est cassé ailleurs par la v2 :
- `sources.csv` est bien utilisé : en tête, dans la note sous le tableau, dans le pied et dans la carte K ;
- le contrôle `k_hyperkaliemie ≥ K.haut` est en place ;
- le pied cite 6 sources, toutes datées ;
- la page tient toujours sur une seule page.

## Points pour la médecin stagiaire relectrice

1. **INR sous AVK (ex-bloquant, à relire en priorité)** : texte de la note et de la carte, cité dans A-VERIFIER 6. Les deux risques et les cibles sont conformes à VIDAL. Deux formulations sont à valider : « fixée par le.la prescripteur.rice » et « certaines atteintes valvulaires (prothèse mécanique mitrale notamment) ».
2. **« Par prudence, la signaler d'abord » et « Ce contrôle ne retarde pas le signalement »** : aucune source ne l'écrit pour le rôle infirmier. À confirmer, reformuler ou retirer.
3. **Seuil d'hyperkaliémie (N1)** : retirer le seuil, ou indiquer qu'il varie (> 5 ou > 5,5 mmol/L) ? La phrase actuelle est à trancher, de même que la zone de 4,5 à 5,5 entre l'intervalle CNG et ce seuil.
4. **Kaliémie 3,5–4,5 mmol/L (plasma, CNG 2009)** : plus étroite que beaucoup de comptes rendus (VIDAL 2022 : « normalement entre 3,5 et 5,5 »). Faut-il garder cet intervalle tel quel, avec l'encadré « le compte rendu fait foi » ?
5. **Glucose sans « à jeun »** (m-r3) : ajouter une précision (veineux, à jeun, capillaire) ou laisser tel quel ?
6. **DFGe ≥ 90** (la source écrit « > 90 ») et « DFGe < 60 pendant plus de 3 mois : MRC de stade 3 ou plus » : à valider.
7. **Sondage du relevé CNG 2009 sur le PDF original**, en particulier : K 3,5–4,5, Cl 95–105, HCO₃⁻ 23–27, albumine 38–48 g/L, protéines 65–80 g/L. Deux relevés concordants existent, mais tous deux par lecture web.
8. **« Selon le protocole »** (2 occurrences) et « Ne pas comparer un TP à une cible d'INR » : consignes génériques à valider.
9. **Exemple TCA** « 1,50 (au-dessus de 1,20) » sans « hors traitement anticoagulant » : acceptable comme valeur d'exercice ?

Après la relecture, `statut-methode.md` doit indiquer que la v2 a été revue par le vérificateur (rapport-v2 : À corriger, N1). Il n'écrit « vérifié » pour aucun point tant que la relectrice ne l'a pas vu.

## Sources consultées par le vérificateur (29.10.2026)

- VIDAL Recos « AVK (traitement par) », mise à jour du 21.10.2025 : https://www.vidal.fr/recommandations/1511/avk_traitement_par/prise_en_charge/
- VIDAL Actualités, Hoppenot I., « L'hyperkaliémie, une origine médicamenteuse fréquente », 10.05.2022 : https://www.vidal.fr/actualites/29089-l-hyperkaliemie-une-origine-medicamenteuse-frequente.html
- La Revue du Praticien, Nobile C., « Hypo/hyperkaliémie : conduite à tenir en MG », 09.04.2024, mise à jour du 31.03.2026 (accès partiel) : https://www.larevuedupraticien.fr/article/hypohyperkaliemie-conduite-tenir-en-mg
- Pas relus : CNG 2009 (déjà confronté en v1), KDIGO 2012, HAS.

## Script de recalcul

1. Le script v1 (`rapport-v1.md`, fin) a été relancé sans modification : `python3 -I recalc_fr03_v1.py produits/FR03/donnees`, résultat « Écarts : aucun ». Les 2 équivalences arrondies par la source sont inchangées.
2. Le complément v2 a été lancé avec `pdftotext produits/FR03/livraison/FR03-2026/FR03-2026-a4.pdf a4.txt` puis `python3 -I recalc_fr03_v2_complement.py produits/FR03/donnees a4.txt`.

```python
"""Complément v2 au recalcul FR03 (vérificateur R05). À lancer après recalc_fr03_v1.py (inchangé).
Usage : python3 -I recalc_fr03_v2_complement.py <produits/FR03/donnees> <texte pdftotext (sans -layout) du PDF A4>"""
import csv, re, sys
from pathlib import Path

D, PDF = Path(sys.argv[1]), Path(sys.argv[2]).read_text(encoding="utf-8")
lire = lambda f: list(csv.DictReader(open(D / f, encoding="utf-8")))
ecarts = []
ex = {l["cle"]: l for l in lire("examens.csv")}
v = {l["cle"]: l for l in lire("valeurs.csv")}
src = {l["code"]: l for l in lire("sources.csv")}
fr = lambda s: s.replace(".", ",")
txt = re.sub(r"\s+", " ", PDF.replace("­ ", "").replace("­", ""))

# 1. Valeurs nouvelles de la v2, confrontées aux sources relues le 29.10.2026
ATT = {"k_hyperkaliemie": ("5.5", "VIDAL_K_2022"),   # VIDAL Actualités 10.05.2022 : « supérieur à 5,5 mmol/L »
       "dfg_stade2_haut": ("89", "REVPRAT_MRC_2022"), # Rev Prat MG 2022 : stade 2 « entre 60 et 89 »
       "dfg_normal": ("90", "REVPRAT_MRC_2022")}      # source : « > 90 » ; fiche : « ≥ 90 » (voir rapport)
for cle, (val, code) in ATT.items():
    ok = float(v[cle]["valeur"]) == float(val) and v[cle]["source_code"] == code
    print(f"{'OK ' if ok else 'ÉCART'} valeurs.csv {cle} = {v[cle]['valeur']} ({v[cle]['source_code']})")
    if not ok: ecarts.append(cle)
print("valeurs.csv : source_code sans ligne dans sources.csv :",
      sorted({l["source_code"] for l in v.values() if l["source_code"] not in src}) or "aucun")

# 2. Renvois des cartes, y compris le nouveau type {t:sources:CODE:champ} (non couvert par le script v1)
for c in lire("cartes.csv"):
    for table, cle, champ in re.findall(r"\{t:(\w+):(\w+):(\w+)\}", c["verso"]):
        t = {"examens": ex, "sources": src}.get(table, {})
        if cle not in t or not t[cle].get(champ):
            ecarts.append(f"renvoi {table}:{cle}:{champ}"); print("ÉCART renvoi", table, cle, champ)
    for cle in re.findall(r"\{v:(\w+)\}", c["verso"]):
        if cle not in v: ecarts.append("renvoi v:" + cle); print("ÉCART renvoi v", cle)
print("renvois des cartes (examens, sources, valeurs) contrôlés")

# 3. Concordance PDF ↔ CSV : chaque ligne du tableau, chaque valeur isolée, chaque année de source
for l in ex.values():
    u = (" " + l["unite"]) if l["unite"] else ""
    if l["borne"] == "intervalle":
        attendu = f"{fr(l['bas'])}–{fr(l['haut'])}{u}"
    else:
        attendu = f"< {fr(l['haut'])}{u}"
    ok = attendu in txt
    if l["autre_haut"]:
        au = (" " + l["autre_unite"]) if l["autre_unite"] not in ("%",) else " %"
        autre = (f"{fr(l['autre_bas'])}–{fr(l['autre_haut'])}" if l["autre_bas"] else f"< {fr(l['autre_haut'])}") + au
        ok = ok and (autre in txt or autre.replace(" %", "%").replace("< ", "<") in txt.replace(" ", ""))
    if not ok: ecarts.append("PDF " + l["cle"]); print("ÉCART PDF", l["cle"], attendu)
for frag in [f"> {fr(v['k_hyperkaliemie']['valeur'])} mmol/L", f"≥ {v['dfg_normal']['valeur']}",
             f"< {v['dfg_seuil_mrc3']['valeur']} pendant plus de {v['mrc_mois']['valeur']} mois",
             f"publiée en {src['CNG_VBU_2009']['annee']}", f"Valeurs de {src['CNG_VBU_2009']['annee']}"] + \
            [f"({s['date']})" for s in src.values()]:
    if frag not in txt: ecarts.append("PDF " + frag); print("ÉCART PDF fragment absent :", frag)
print("concordance PDF ↔ CSV contrôlée :", len(ex), "lignes d'examens,", 5 + len(src), "fragments")

# 4. Contrôle de cohérence ajouté par la v2 (aussi codé dans main.typ l. 119)
assert float(v["k_hyperkaliemie"]["valeur"]) >= float(ex["K"]["haut"])
print("\nÉcarts :", ecarts or "aucun")
```

Sortie :

```
OK  valeurs.csv k_hyperkaliemie = 5.5 (VIDAL_K_2022)
OK  valeurs.csv dfg_stade2_haut = 89 (REVPRAT_MRC_2022)
OK  valeurs.csv dfg_normal = 90 (REVPRAT_MRC_2022)
valeurs.csv : source_code sans ligne dans sources.csv : ['DEFINITION']
renvois des cartes (examens, sources, valeurs) contrôlés
concordance PDF ↔ CSV contrôlée : 34 lignes d'examens, 11 fragments

Écarts : aucun
```
