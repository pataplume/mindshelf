// EN08 : Lab Values Cheat Sheet (marché EN, MindShelf). Fiche d'une page, risque IA FAIBLE, relecture
// métier par une médecin stagiaire avant validation (donnees/statut-methode.md).
// Contrat : titre, marque, version, langue, format et mentions arrivent par sys.inputs (scripts/README-pipeline.md).
// Aucun nombre n'est tapé ici : intervalles (donnees/examens.csv), facteurs (donnees/facteurs.csv, chacun
// recalculé depuis sa ligne de donnees/exemples.csv), exemples de conversion (exemples.csv), seuils (valeurs.csv).
// Chaque valeur SI (ou US, si la source donne le SI) est recalculée ici depuis l'autre unité et le facteur
// affiché : la compilation échoue si l'écart dépasse un demi-dernier chiffre affiché.
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN08 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples et dérivation des facteurs : recalcul de chaque résultat ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    let attendu = float(l.resultat_attendu)
    if calc.abs(calcule - attendu) > float(l.tolerance) {
      panic("EN08 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    if l.arrondi.trim() == "" { panic("EN08 : " + l.id + " : colonne arrondi vide") }
    d.insert(l.id, l + (e: e, x: attendu, n: int(l.arrondi)))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("EN08 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("EN08 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)))
}
// Résultat affiché : « = 132.6 ⇒ 133 µmol/L » si l'arrondi change la valeur, sinon « = 10 mmol/L ».
#let res(id) = {
  let l = ex(id)
  let r = calc.round(l.x, digits: l.n)
  let montre = calc.round(l.x, digits: l.n + 2)
  if r == l.x { [= #nombre(str(r), decimales: l.n)#sym.space.nobreak#l.unite] } else {
    let rel = if montre == l.x { "=" } else { sym.approx }
    [#rel #nombre(str(montre)) #sym.arrow.r.double *#nombre(str(r), decimales: l.n)#sym.space.nobreak#l.unite*]
  }
}

// ── Facteurs : la valeur affichée est l'arrondi de la dérivation (exemples.csv), sinon échec ──
#let facteurs = {
  let d = (:)
  for l in csv("../donnees/facteurs.csv", row-type: dictionary) {
    let x = ex(l.exemple_id)
    let arrondi = calc.round(x.x, digits: x.n)
    if calc.abs(arrondi - float(l.facteur)) > 0.000000001 {
      panic("EN08 : facteur " + l.code + " = " + l.facteur + ", dérivation " + str(arrondi))
    }
    d.insert(l.code, l + (f: float(l.facteur), z: float(l.decalage)))
  }
  d
}
#let fac(code) = {
  if code not in facteurs { panic("EN08 : facteur " + code + " absent de donnees/facteurs.csv") }
  facteurs.at(code)
}

// ── Valeurs isolées ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.cle, l) }
  d
}
#let val(cle) = {
  if cle not in valeurs { panic("EN08 : valeur " + cle + " absente de donnees/valeurs.csv") }
  nombre(valeurs.at(cle).valeur)
}

// ── Examens : contrôle de chaque conversion affichée ──
#let groupes = csv("../donnees/groupes.csv", row-type: dictionary)
#let examens = csv("../donnees/examens.csv", row-type: dictionary)
#let exa(nom) = {
  let r = examens.filter(l => l.examen == nom)
  if r.len() != 1 { panic("EN08 : examen « " + nom + " » absent ou en double dans donnees/examens.csv") }
  r.first()
}
#let controle(l, us, si) = {
  if us == "" and si == "" { return }
  if us == "" or si == "" { panic("EN08 : " + l.examen + " : borne US ou SI manquante") }
  let f = fac(l.facteur_code)
  let (a, b, d) = if l.unite_source == "US" {
    (float(si), (float(us) - f.z) * f.f, int(l.decimales_si))
  } else if l.unite_source == "SI" {
    (float(us), float(si) / f.f + f.z, int(l.decimales_us))
  } else { panic("EN08 : " + l.examen + " : unite_source " + l.unite_source) }
  if calc.abs(a - b) > 0.5 * calc.pow(10.0, -d) + 0.000000001 {
    panic("EN08 : " + l.examen + " : " + str(a) + " affiché, " + str(b) + " recalculé")
  }
}
#for l in examens { controle(l, l.bas_us, l.bas_si); controle(l, l.haut_us, l.haut_si) }

#let plage(l, bas, haut, unite) = {
  let u = if unite == "" { [] } else { [#sym.space.nobreak#unite] }
  if l.borne == "intervalle" { [#nombre(bas)–#nombre(haut)#u] }
  else if l.borne == "max" { [< #nombre(haut)#u] }
  else if l.borne == "min" { [≥ #nombre(bas)#u] }
  else { panic("EN08 : borne inconnue " + l.borne) }
}
#let facteur-aff(code) = {
  let f = fac(code)
  if code == "IDENT" { [same] }
  else if f.z != 0 { [IFCC eq.] }
  else { [× #nombre(f.facteur)] }
}
// Le libellé de l'unité SI des fractions : « L/L » pour l'hématocrite, « fraction » pour SaO₂.
#let unite-si(l) = if l.facteur_code == "PCT" and l.groupe_code == "ABG" { "(fraction)" } else { l.unite_si }

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Adult reference intervals in US conventional and SI units, conversion factors, nursing cues and unit traps for NCLEX review],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
)

#piege(titre: "Reference intervals vary between laboratories")[
  Interpret a result against the interval printed on *your lab's report*. The values below are one published set, for adults, for study.
]

#colonnes(2)[

= Adult reference intervals

#tableau(
  columns: (1fr, auto, auto, auto),
  align: (left, right, right, right),
  [Test], [US conventional], [Factor], [SI],
  ..groupes.map(g => (
    table.cell(colspan: 4)[*#g.libelle*],
    ..examens.filter(l => l.groupe_code == g.code).map(l => (
      [#l.examen],
      plage(l, l.bas_us, l.haut_us, l.unite_us),
      facteur-aff(l.facteur_code),
      plage(l, l.bas_si, l.haut_si, unite-si(l)),
    )).flatten(),
  )).flatten(),
)

_SI = US × factor; the SI value is calculated from the US value, except ionized calcium (source in mmol/L). Blood gas values: room air._

= Convert US ↔ SI

#formule[
  *SI = US × factor*; US = SI ÷ factor.
  mg/dL → mmol/L: factor = 10 ÷ molar mass (g/mol).
  mEq/L → mmol/L: ÷ ion charge (Na⁺, K⁺, Cl⁻, HCO₃⁻: same number).
  mm Hg → kPa: × #nombre(fac("MMHG").facteur) (1 mm Hg ≈ #val("mmhg_pa") Pa).
  HbA1c: mmol/mol = (% − #nombre(fac("HBA1C").decalage)) × #nombre(fac("HBA1C").facteur) (IFCC eq.).
]

#exemple(titre: "Three conversions")[
  Glucose #v("CV1", "G") mg/dL × #v("CV1", "F") #res("CV1").\
  Creatinine #v("CV2", "C") mg/dL × #v("CV2", "F") #res("CV2").\
  Ionized Ca #v("CV3", "S") mmol/L ÷ #v("CV3", "F") #res("CV3").
]

= Unit traps

#piege(titre: "Same test, two numbers")[
  Glucose #nombre(exa("Glucose, fasting plasma").haut_us) mg/dL = #nombre(exa("Glucose, fasting plasma").haut_si) mmol/L. Read the unit before you compare a result with a range.
]

#piege(titre: "mEq is not always mmol")[
  Equal only for single-charge ions. Ca²⁺ and Mg²⁺: 1 mmol = #val("valence_ca") mEq.
]

#piege(titre: "BUN is not urea")[
  US labs report urea *nitrogen* (BUN); SI labs report urea. Urea has 2 N atoms: × #nombre(fac("BUN").facteur).
]

#piege(titre: "Total vs ionized calcium")[
  Low albumin lowers *total* calcium; ionized calcium (the active fraction) may be normal. Check which one the order and the report give.
]

#piege(titre: "Hemolyzed sample")[
  Red-cell breakdown in the tube releases potassium: a falsely high K⁺. Unexpected high K⁺: ask whether the sample was hemolyzed and a redraw is needed.
]

#piege(titre: "Hematocrit and SaO₂ in SI")[
  Written as fractions: #nombre(exa("Hematocrit, female").bas_us)% = #nombre(exa("Hematocrit, female").bas_si) L/L; #nombre(exa("SaO₂").bas_us)% = #nombre(exa("SaO₂").bas_si).
]

= Nursing cues

#note-clinique(titre: "INR and bleeding")[
  On warfarin, the usual INR target is #nombre(exa("INR target on warfarin").bas_us)–#nombre(exa("INR target on warfarin").haut_us). Above #val("inr_saignement"): higher bleeding risk. Report per protocol.
]

#note-clinique(titre: "Potassium and the heart")[
  K⁺ outside the interval, high or low, can disturb cardiac rhythm: report promptly; ECG monitoring per protocol.
]

#note-clinique(titre: "Digoxin level")[
  The interval shown is a general one; the right level depends on the patient and the indication. Follow the prescriber's target.
]

_Sources: ABIM Laboratory Test Reference Ranges (January 2026); MedlinePlus (INR, digoxin). Factors calculated from IUPAC atomic weights and SI definitions._
]
