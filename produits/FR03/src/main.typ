// FR03 : Bilan biologique — valeurs usuelles françaises (marché FR, marque Clairance). Fiche d'une page, risque IA FAIBLE,
// relecture métier par une médecin stagiaire avant validation (donnees/statut-methode.md). Adaptée de EN08 v2
// (pas une traduction) : valeurs usuelles françaises en unités SI, lues telles qu'écrites dans la source
// (donnees/examens.csv, colonne source_code), sans conversion US.
// Contrat : titre, marque, version, langue, format, variante, référentiel et mentions arrivent par sys.inputs.
// Aucune valeur clinique n'est tapée ici (seuls les nombres qui font partie d'une unité ou d'une définition d'unité le sont :
// mL/min/1,73 m², G/L = 10⁹/L, T/L = 10¹²/L) : intervalles (examens.csv), seuils DFG et kaliémie (valeurs.csv), sources et années
// (sources.csv), exemples recalculés
// (exemples.csv, échec si écart), ligne d'UE propre à la variante (variantes.csv).
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("FR03 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples : recalcul de chaque résultat ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    let attendu = float(l.resultat_attendu)
    if calc.abs(calcule - attendu) > float(l.tolerance) {
      panic("FR03 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    if l.arrondi.trim() == "" { panic("FR03 : " + l.id + " : colonne arrondi vide") }
    d.insert(l.id, l + (e: e, x: attendu, n: int(l.arrondi)))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("FR03 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let brut(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("FR03 : entrée " + cle + " absente de " + id + " (entrees_json)") }
  e.at(cle)
}
#let v(id, cle, decimales: none) = nombre(str(brut(id, cle)), decimales: decimales)
#let res(id) = {
  let l = ex(id)
  let u = if l.unite == "" { [] } else { [#sym.space.nobreak#l.unite] }
  [#nombre(str(l.x), decimales: l.n)#u]
}

// ── Valeurs isolées ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.cle, l) }
  d
}
#let val-brut(cle) = {
  if cle not in valeurs { panic("FR03 : valeur " + cle + " absente de donnees/valeurs.csv") }
  float(valeurs.at(cle).valeur)
}
#let val(cle) = { let _ = val-brut(cle); nombre(valeurs.at(cle).valeur) }

// ── Sources (donnees/sources.csv) : nom, date et année affichés en tête et en pied ──
#let sources = csv("../donnees/sources.csv", row-type: dictionary)
#let src(code) = {
  let r = sources.filter(l => l.code == code)
  if r.len() != 1 { panic("FR03 : source « " + code + " » absente ou en double dans donnees/sources.csv") }
  r.first()
}
#let pied-source(l) = {
  let morceaux = (l.auteur, "« " + l.titre + " »")
  if l.version != "" { morceaux.push(l.version) }
  if l.complement != "" { morceaux.push(l.complement) }
  morceaux.join(", ") + " (" + l.date + ")"
}

// ── Examens ──
#let groupes = csv("../donnees/groupes.csv", row-type: dictionary)
#let examens = csv("../donnees/examens.csv", row-type: dictionary)
#let exa(cle) = {
  let r = examens.filter(l => l.cle == cle)
  if r.len() != 1 { panic("FR03 : examen « " + cle + " » absent ou en double dans donnees/examens.csv") }
  r.first()
}
#for l in examens {
  if groupes.filter(g => g.code == l.groupe_code).len() != 1 { panic("FR03 : " + l.cle + " : groupe inconnu " + l.groupe_code) }
  if l.source_code == "" { panic("FR03 : " + l.cle + " : source_code vide") }
  let _ = src(l.source_code)
}
// Nombre « tel qu'écrit » : garde les zéros de la source (2,20 ; 0,80 ; 3,90).
#let ecrit(s) = {
  let p = s.split(".")
  if p.len() == 2 { nombre(s, decimales: p.at(1).len()) } else { nombre(s) }
}
#let plage(borne, bas, haut, unite) = {
  if bas == "" and haut == "" { return [] }
  let u = if unite == "" { [] } else { [#sym.space.nobreak#unite] }
  if borne == "intervalle" { [#ecrit(bas)–#ecrit(haut)#u] }
  else if borne == "max" { [< #ecrit(haut)#u] }
  else { panic("FR03 : borne inconnue " + borne) }
}

// ── Cohérence entre tables (échec de compilation si écart) ──
#let meme(a, b, quoi) = if calc.abs(float(a) - float(b)) > 0.000000001 {
  panic("FR03 : incohérence " + quoi + " : " + str(a) + " ≠ " + str(b))
}
#meme(brut("EX02", "C"), exa("CLAIR").bas, "EX02 vs clairance basse")
#meme(ex("EX02").x, exa("CLAIR").autre_bas, "EX02 vs clairance basse en mL/min")
#meme(brut("EX02", "S"), val-brut("s_par_min"), "secondes par minute")
// Clairance haute : la source écrit 2,30 mL/s et 140 mL/min (2,30 × 60 = 138) : équivalence arrondie, non contrôlée.
#meme(brut("EX03", "H"), exa("HT_H").bas, "EX03 vs hématocrite homme")
#meme(ex("EX03").x, exa("HT_H").autre_bas, "EX03 vs hématocrite homme en %")
#meme(brut("EX03", "P"), val-brut("pct"), "fraction → %")
#for c in ("HT_H", "HT_F") {
  meme(float(exa(c).bas) * val-brut("pct"), exa(c).autre_bas, c + " bas fraction → %")
  meme(float(exa(c).haut) * val-brut("pct"), exa(c).autre_haut, c + " haut fraction → %")
}
#meme(float(exa("HBA1C").haut) * val-brut("pct"), exa("HBA1C").autre_haut, "HbA1c fraction → %")
#meme(val-brut("dfg_seuil_mrc3"), val-brut("dfg_stade2_bas"), "seuil stade 3 = borne basse du stade 2")
#meme(val-brut("dfg_normal") - 1, val-brut("dfg_stade2_haut"), "stade 1 (≥) = borne haute du stade 2 + 1")

// ── Ligne propre à la variante (référentiel 2009 ou 2026) ──
#let ligne-variante(cle) = {
  let lignes = csv("../donnees/variantes.csv", row-type: dictionary).filter(l => l.variante == entree("variante") and l.cle == cle)
  if lignes.len() != 1 { panic("FR03 : " + str(lignes.len()) + " ligne(s) « " + cle + " » pour " + entree("variante") + " dans donnees/variantes.csv (1 attendue)") }
  let l = lignes.first()
  if l.referentiel != entree("referentiel") {
    panic("FR03 : " + entree("variante") + " : référentiel " + l.referentiel + " ≠ entrée " + entree("referentiel"))
  }
  l.valeur
}

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Valeurs usuelles de l'adulte en unités SI, cible INR sous AVK fixée par le.la prescripteur.rice, pièges d'unités et repères infirmiers, pour réviser en IFSI],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
)

_#ligne-variante("ligne_ue")_

#piege(titre: "Les valeurs usuelles varient selon les laboratoires")[
  #let s = src(exa("NA").source_code)
  Interpréter un résultat avec les valeurs imprimées sur *le compte rendu du laboratoire* : c'est lui qui fait foi. Les valeurs usuelles de cette fiche, pour réviser, viennent d'une liste nationale de l'adulte publiée en *#s.annee* (#s.auteur, « #s.titre », #s.complement).
]

#colonnes(2)[

= Valeurs usuelles de l'adulte

#tableau(
  columns: (1fr, auto, auto, auto),
  align: (left, left, right, right),
  [Examen], [Milieu], [Valeurs usuelles], [Autre écriture],
  ..groupes.map(g => (
    table.header(level: 2, table.cell(colspan: 4)[*#g.libelle*]),
    ..examens.filter(l => l.groupe_code == g.code).map(l => (
      [#l.examen],
      [#l.milieu],
      plage(l.borne, l.bas, l.haut, l.unite),
      plage(l.borne, l.autre_bas, l.autre_haut, l.autre_unite),
    )).flatten(),
  )).flatten(),
)

_Milieu : Pl plasma, Se sérum, Sg sang. « Autre écriture » : seconde unité donnée par la source (équivalence arrondie). G/L = 10#super[9]/L ; T/L = 10#super[12]/L. Valeurs de #src(exa("NA").source_code).annee, indicatives : elles varient selon le laboratoire._

= Fonction rénale : le DFG estimé

#formule[
  Le *DFG estimé* (DFGe) se calcule à partir de la créatininémie (formule CKD-EPI chez l'adulte) et s'exprime en mL/min/1,73 m².
  DFGe <~#val("dfg_seuil_mrc3") pendant plus de #val("mrc_mois") mois : maladie rénale chronique de stade 3 ou plus. DFGe ≥~#val("dfg_normal") : DFG normal ou augmenté (stade 1 si marqueurs d'atteinte rénale).
]

= Pièges d'unités

#piege(titre: "Même examen, deux unités")[
  La même glycémie s'écrit #plage("intervalle", exa("GLY").bas, exa("GLY").haut, exa("GLY").unite) ou #plage("intervalle", exa("GLY").autre_bas, exa("GLY").autre_haut, exa("GLY").autre_unite)\; la créatinine (homme) #plage("intervalle", exa("CREA_H").bas, exa("CREA_H").haut, exa("CREA_H").unite) ou #plage("intervalle", exa("CREA_H").autre_bas, exa("CREA_H").autre_haut, exa("CREA_H").autre_unite). Lire l'unité avant de comparer un résultat à une norme.
]

#piege(titre: "Fraction ou pourcentage")[
  Hématocrite #ecrit(exa("HT_H").bas) = #res("EX03")\; HbA1c < #ecrit(exa("HBA1C").haut) = < #ecrit(exa("HBA1C").autre_haut) %. Même valeur, deux écritures (× #val("pct")).
]

#piege(titre: "TP, INR, TCA : trois écritures")[
  TP en %, INR sans unité, TCA en *rapport* malade/témoin. Ne pas comparer un TP à une cible d'INR.
]

#exemple(titre: "Deux calculs")[
  TCA : #v("EX01", "M") s ÷ #v("EX01", "T") s = #res("EX01") (au-dessus de #ecrit(exa("TCA").haut)).\
  Clairance : #v("EX02", "C", decimales: 2) mL/s × #v("EX02", "S") = #res("EX02").\
  _Valeurs d'exercice (TCA), pas des résultats de patient.e._
]

= Repères infirmiers

#note-clinique(titre: "Kaliémie élevée et hémolyse")[
  Kaliémie élevée = au-dessus de l'intervalle du compte rendu du laboratoire. Par prudence, *la signaler d'abord*, selon le protocole du service. Une hémolyse du prélèvement peut donner une fausse hyperkaliémie : un nouveau prélèvement de contrôle, sans garrot, peut être prescrit. Ce contrôle ne retarde pas le signalement.
]

#note-clinique(titre: "INR sous AVK")[
  La cible est fixée par le.la prescripteur.rice selon l'indication : #ecrit(exa("INR_AVK").bas) à #ecrit(exa("INR_AVK").haut) le plus souvent, #ecrit(exa("INR_VALVE").bas) à #ecrit(exa("INR_VALVE").haut) pour certaines atteintes valvulaires (prothèse mécanique mitrale notamment).
  *Au-dessus de la cible* : surdosage, risque hémorragique. *Au-dessous de la cible* : effet anticoagulant insuffisant, risque de thrombose. Dans les deux cas, signaler selon le protocole.
]

_Sources : #(sources.filter(l => l.ordre_pied != "").sorted(key: l => int(l.ordre_pied)).map(pied-source).join(" ; "))._
]
