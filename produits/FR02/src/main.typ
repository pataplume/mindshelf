// FR02 : Pack stage IFSI (constantes, échelles, transmissions, précautions) — marché FR, marque Clairance.
// Risque IA FAIBLE, relecture infirmière avant validation (donnees/statut-methode.md). Jusqu'à 4 pages.
// Contrat : titre, marque, version, langue, format, variante, référentiel et mentions arrivent par sys.inputs.
// Aucun nombre n'est tapé ici : repères (donnees/constantes.csv, valeurs.csv), cotations (glasgow.csv, braden.csv),
// sommes recalculées (exemples.csv, échec si écart), ligne d'UE propre à la variante (variantes.csv).
// Aucune conduite thérapeutique, aucune dose : la conduite affichée est « alerter selon le protocole du service ».
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("FR02 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Valeurs ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) {
    if l.cle in d { panic("FR02 : clé " + l.cle + " en double dans donnees/valeurs.csv") }
    d.insert(l.cle, l)
  }
  d
}
#let val-brut(cle) = {
  if cle not in valeurs { panic("FR02 : valeur " + cle + " absente de donnees/valeurs.csv") }
  float(valeurs.at(cle).valeur)
}
#let val(cle) = { let _ = val-brut(cle); nombre(valeurs.at(cle).valeur) }
#let valu(cle) = [#val(cle)#sym.space.nobreak#valeurs.at(cle).unite]
// Code (norme) : chiffres lus dans la table, sans séparateur de milliers.
#let code(cle) = { let _ = val-brut(cle); valeurs.at(cle).valeur }

// Gabarit « {cle} » → nombre de valeurs.csv.
#let gabarit(t) = {
  let morceaux = ()
  let pos = 0
  for m in t.matches(regex("\{([a-z0-9_]+)\}")) {
    morceaux.push(t.slice(pos, m.start))
    morceaux.push(val(m.captures.first()))
    pos = m.end
  }
  morceaux.push(t.slice(pos))
  morceaux.join()
}

// ── Exemples : recalcul de chaque somme ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("FR02 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e, x: float(l.resultat_attendu)))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("FR02 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let ve(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("FR02 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)))
}
#let xe(id) = nombre(ex(id).resultat_attendu)

// ── Échelles : tables et contrôles de cohérence ──
#let glasgow = csv("../donnees/glasgow.csv", row-type: dictionary)
#let braden = csv("../donnees/braden.csv", row-type: dictionary)
#let meme(a, b, quoi) = if calc.abs(float(a) - float(b)) > 0.000000001 {
  panic("FR02 : incohérence " + quoi + " : " + str(a) + " ≠ " + str(b))
}
#let items-g = glasgow.map(l => l.item).dedup()
#let pts(item) = glasgow.filter(l => l.item == item).map(l => int(l.points))
#meme(items-g.map(i => calc.min(..pts(i))).sum(), val-brut("glasgow_min"), "Glasgow minimum")
#meme(items-g.map(i => calc.max(..pts(i))).sum(), val-brut("glasgow_max"), "Glasgow maximum")
#meme(ex("EX04").x, val-brut("glasgow_min"), "EX04 Glasgow minimum")
#meme(ex("EX05").x, val-brut("glasgow_max"), "EX05 Glasgow maximum")
#for (i, k) in items-g.zip(("Y", "V", "M")) {
  meme(calc.max(..pts(i)), ex("EX05").e.at(k), "EX05 " + k)
  meme(calc.max(..pts(i)), val-brut("glasgow_" + lower(k) + "_max"), "Glasgow " + k + " maximum")
  meme(calc.min(..pts(i)), val-brut("glasgow_item_min"), "Glasgow " + k + " minimum")
  if int(ex("EX01").e.at(k)) not in pts(i) { panic("FR02 : EX01 : " + k + " hors cotation") }
}
#meme(braden.len(), val-brut("braden_items"), "nombre d'items de Braden")
#meme(braden.map(l => int(l.min)).sum(), val-brut("braden_min"), "Braden minimum")
#meme(braden.map(l => int(l.max)).sum(), val-brut("braden_max"), "Braden maximum")
#meme(ex("EX02").x, val-brut("braden_min"), "EX02 Braden minimum")
#meme(ex("EX03").x, val-brut("braden_max"), "EX03 Braden maximum")

// ── Ligne propre à la variante (référentiel 2009 ou 2026) ──
#let ligne-variante(cle) = {
  let lignes = csv("../donnees/variantes.csv", row-type: dictionary).filter(l => l.variante == entree("variante") and l.cle == cle)
  if lignes.len() != 1 { panic("FR02 : " + str(lignes.len()) + " ligne(s) « " + cle + " » pour " + entree("variante") + " dans donnees/variantes.csv (1 attendue)") }
  let l = lignes.first()
  if l.referentiel != entree("referentiel") {
    panic("FR02 : " + entree("variante") + " : référentiel " + l.referentiel + " ≠ entrée " + entree("referentiel"))
  }
  l.valeur
}

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Repères de l'adulte pour le stage : constantes, échelles, transmissions, hygiène et AES],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
  numerotation: true,
)

#colonnes(2)[

_#ligne-variante("ligne_ue")._\
_Repères de l'adulte. Les valeurs, seuils et conduites du protocole de votre service priment._

= Constantes de l'adulte

#tableau(
  columns: (1fr, auto, auto),
  align: (left, right, left),
  [Paramètre], [Repère], [Unité],
  ..csv("../donnees/constantes.csv", row-type: dictionary).map(l => ([#l.parametre], [#gabarit(l.repere)], [#l.unite])).flatten(),
)

#note-clinique(titre: "Valeur anormale : consigne de prudence")[
  Valeur grave ou patient.e qui va mal : *alerter immédiatement* selon le protocole, puis recontrôler. Valeur anormale isolée chez un.e patient.e stable : recontrôler (matériel, position, repos) et comparer aux valeurs précédentes avant de signaler. En cas de doute, alerter.
]

#piege[Un chiffre « normal » ne rassure pas seul : la tendance (valeurs successives) et l'aspect du.de la patient.e comptent autant. Une cible prescrite pour ce.tte patient.e (SpO₂ notamment) passe avant le repère du tableau.]

= Échelles de la douleur

#tableau(
  columns: (auto, 1fr),
  align: (left, left),
  [Échelle], [Cotation et seuil de l'indicateur HAS],
  [EVA], [Auto-évaluation. Réglette de #val("echelle_zero") à #valu("eva_max_cm") (#val("echelle_zero") à #valu("eva_max_mm")). Prise en charge requise si ≥ #val("douleur_seuil")/#val("en_max") (≥ #val("douleur_seuil_100")/#val("eva_max_mm")).],
  [EN], [Auto-évaluation. Note de #val("echelle_zero") à #val("en_max") donnée par le.la patient.e. Même seuil que l'EVA.],
  [EVS], [Auto-évaluation (échelle verbale simple). De #val("echelle_zero") (absente) à #val("evs_max") (extrêmement intense) : absente, faible, modérée, intense, extrêmement intense. Prise en charge requise si ≥ #val("evs_seuil").],
  [Algoplus], [Hétéro-évaluation, personne âgée qui ne peut pas s'auto-évaluer. Score de #val("echelle_zero") à #val("algoplus_max"). Prise en charge requise si ≥ #val("algoplus_seuil").],
)

Sous ces seuils, la douleur reste évaluée, tracée et prise en compte ; la conduite est celle du protocole du service.

#piege[Choisir *une* échelle et la garder pour suivre l'évolution : un score d'EVA et un score d'EN ne se comparent pas d'une prise à l'autre. Tracer l'échelle utilisée avec le score.]

= Score de Glasgow

#tableau(
  columns: (auto, auto, 1fr),
  align: (left, right, left),
  [Item], [Points], [Meilleure réponse obtenue],
  ..items-g.map(i => {
    let ls = glasgow.filter(l => l.item == i)
    ls.enumerate().map(((k, l)) => (
      if k == 0 { (table.cell(rowspan: ls.len())[*#i*],) } else { () }
    ) + ([#nombre(l.points)], [#l.reponse])).flatten()
  }).flatten(),
)

#formule[
  Score = Y + V + M, de #val("glasgow_min") à #val("glasgow_max"). Noter le détail des trois items, pas seulement le total. Réponse non testable (patient.e intubé.e, paupières œdématiées) : noter NT et la raison, ne pas coter 1.
]

#exemple(titre: "Calcul du score")[
  Yeux à la demande (#ve("EX01", "Y")), réponse confuse (#ve("EX01", "V")), localise la douleur (#ve("EX01", "M")) : #ve("EX01", "Y") + #ve("EX01", "V") + #ve("EX01", "M") = #xe("EX01"), à noter Y#ve("EX01", "Y") V#ve("EX01", "V") M#ve("EX01", "M").
]

#note-clinique(titre: "Baisse du score")[
  Toute baisse par rapport à la cotation précédente s'alerte immédiatement, selon le protocole du service.
]

= Risque d'escarre : échelle de Braden

#tableau(
  columns: (1fr, auto),
  align: (left, right),
  [Item], [Cotation],
  ..braden.map(l => ([#l.item], [#nombre(l.min) à #nombre(l.max)])).flatten(),
)

#formule[
  Score total de #val("braden_min") à #val("braden_max") : *plus le score est bas, plus le risque est élevé*. Le seuil qui déclenche les mesures de prévention est celui du protocole du service.
]

= Transmissions

#encadre(titre: "Transmissions ciblées")[
  - *Cible* : ce qui pose problème ou change (symptôme, réaction, événement), en quelques mots.
  - *D, données* : faits observés et mesurés, propos du.de la patient.e.
  - *A, actions* : ce qui a été fait, et par qui.
  - *R, résultats* : effet observé, réévalué à l'heure dite.
]

#encadre(titre: "SAED (adaptation française de SBAR, HAS)")[
  - *S, situation* : qui j'appelle, pour quel.le patient.e, motif de l'appel, constantes.
  - *A, antécédents* : contexte, traitements, allergies, évolution récente.
  - *E, évaluation* : ce que j'en pense, ce qui m'inquiète.
  - *D, demande* : ce que j'attends, dans quel délai.
]

#note-clinique(titre: "Traçabilité")[
  Écrire ce qui est fait, quand il est fait : date, heure, identification de l'auteur.rice. Chaque administration est tracée sur le même support que la prescription. Faits objectifs, sans jugement ; jamais d'acte tracé à l'avance.
]

= Précautions standard

#formule(titre: "Champ (SF2H)")[
  Pour tout soin, en tout lieu, pour tout.e patient.e, quel que soit son statut infectieux.
]

#encadre(titre: [Les #val("oms_indications") indications de l'hygiène des mains (OMS)])[
  + Avant de toucher un.e patient.e.
  + Avant un geste aseptique.
  + Après un risque d'exposition à un liquide biologique.
  + Après avoir touché un.e patient.e.
  + Après avoir touché l'environnement du.de la patient.e.
]

#tableau(
  columns: (auto, 1fr),
  align: (left, left),
  [Mesure], [Repère],
  [Mains], [Friction hydro-alcoolique : technique de référence, gants ou non. Mains visiblement souillées : lavage à l'eau et au savon. _C. difficile_, gale : lavage au savon *puis* friction (friction seule inefficace).],
  [Gants], [Si risque de contact avec du sang, un liquide biologique, une muqueuse ou une peau lésée ; pas de gants pour un contact avec une peau saine.],
  [Masque, lunettes], [Risque de projection : masque et lunettes, type de masque selon le protocole. Patient.e qui tousse : masque à usage médical, au minimum de type I (norme EN #code("masque_norme")).],
  [Matériel], [Matériel de sécurité et à usage unique ; conduite AES connue de tous.],
)

= Précautions complémentaires

#formule(titre: "Respiratoires (SF2H 2024)")[
  La SF2H a remplacé en 2024 la distinction Air / Gouttelettes par trois niveaux de précautions complémentaires respiratoires : simples, renforcées, maximales. Le niveau et le type de masque (soignant.e, patient.e) suivent le protocole de l'établissement et l'équipe d'hygiène.
]

#tableau(
  columns: (auto, 1fr),
  align: (left, left),
  [Type], [Mesures (en plus des précautions standard)],
  [Contact], [Chambre seule ou regroupement, signalée. Tablier pour les soins directs. Hygiène des mains en sortant de la chambre.],
)

#piege[Les précautions sont prescrites et signalées : suivre la signalétique et le protocole du service, ne pas déduire le niveau du diagnostic supposé.]

= Accident d'exposition au sang (AES)

#encadre(titre: "Premiers soins, tout de suite (INRS)")[
  *Piqûre, coupure, peau lésée :* ne pas faire saigner ; nettoyer à l'eau et au savon, rincer ; désinfecter au moins #valu("aes_desinfection_min") (Dakin, ou eau de Javel à #val("javel_pct") % de chlore actif diluée au #val("javel_num")/#val("javel_dilution")#super[e] ; à défaut polyvidone iodée en solution dermique ou alcool à #val("alcool_degre")°).\
  *Projection sur une muqueuse (œil, bouche, nez) :* rincer abondamment au moins #valu("aes_rincage_min") au sérum physiologique ou à l'eau.
]

#note-clinique(titre: "Délais")[
  *Sous #valu("aes_avis_h") :* avis médical, selon la procédure AES de l'établissement, pour évaluer le risque infectieux ; un traitement post-exposition, s'il est indiqué, débute idéalement dans les #valu("aes_tpe_h").\
  *Dans les #valu("aes_declaration_h") :* informer sa hiérarchie (en stage : le service et l'IFSI), déclarer l'accident du travail, suivre les recommandations médicales, informer le.la médecin du travail.
]

#piege[Ne pas attendre la fin du soin ou du poste pour consulter : le délai compte à partir de l'accident.]

_Sources : HAS (HTA, douleur IQSS, SAED), MedlinePlus (FC, PA basse), Manuel MSD et CHUV (Glasgow), SF2H (précautions standard, contact, respiratoires 2024), CPias Hauts-de-France, OMS (hygiène des mains), INRS (AES), AP-HP (dossier de soins), HUG (Braden), arrêtés du diplôme d'État d'infirmier ; détail dans les références du produit._
]
