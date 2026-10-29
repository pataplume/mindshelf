// EN08 : Lab Values Cheat Sheet (marché EN, MindShelf). Fiche d'une page, risque IA FAIBLE, relecture
// métier par une médecin stagiaire avant validation (donnees/statut-methode.md).
// Contrat : titre, marque, version, langue, format et mentions arrivent par sys.inputs (scripts/README-pipeline.md).
// Aucun nombre n'est tapé ici : intervalles (donnees/examens.csv), facteurs (donnees/facteurs.csv, chacun
// recalculé depuis sa ligne de donnees/exemples.csv), exemples de conversion (exemples.csv), seuils (valeurs.csv).
// Chaque valeur SI (ou US, si la source donne le SI) est recalculée ici depuis l'autre unité : la valeur
// affichée doit être l'arrondi unique du calcul avec le facteur exact (dérivation de exemples.csv) et rester
// à moins d'un demi-dernier chiffre du calcul avec le facteur affiché ; sinon la compilation échoue.
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
  let fx = ex(f.exemple_id).x
  let (a, b, bx, d) = if l.unite_source == "US" {
    (float(si), (float(us) - f.z) * f.f, (float(us) - f.z) * fx, int(l.decimales_si))
  } else if l.unite_source == "SI" {
    (float(us), float(si) / f.f + f.z, float(si) / fx + f.z, int(l.decimales_us))
  } else { panic("EN08 : " + l.examen + " : unite_source " + l.unite_source) }
  if calc.abs(a - b) > 0.5 * calc.pow(10.0, -d) + 0.000000001 {
    panic("EN08 : " + l.examen + " : " + str(a) + " affiché, " + str(b) + " recalculé (facteur affiché)")
  }
  if calc.abs(a - calc.round(bx, digits: d)) > 0.000000001 {
    panic("EN08 : " + l.examen + " : " + str(a) + " affiché, " + str(bx) + " avec le facteur exact")
  }
}
#for l in examens { controle(l, l.bas_us, l.bas_si); controle(l, l.haut_us, l.haut_si) }

// Une même valeur écrite dans deux tables doit concorder (sinon échec).
#let concorde(a, b, quoi) = if calc.abs(float(a) - float(b)) > 0.000000001 {
  panic("EN08 : " + quoi + " : " + str(a) + " ≠ " + str(b))
}
#concorde(exa("INR on warfarin, common").bas_us, valeurs.at("inr_caillot").valeur, "INR cible basse vs inr_caillot")
#concorde(exa("INR on warfarin, common").haut_us, valeurs.at("inr_saignement").valeur, "INR cible haute vs inr_saignement")
#concorde(fac("HBA1C").decalage, valeurs.at("ngsp_ordonnee").valeur, "HBA1C décalage vs ngsp_ordonnee")
#concorde(ex("F_HBA1C").e.S, valeurs.at("ngsp_pente").valeur, "F_HBA1C pente vs ngsp_pente")

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
  sous-titre: [Adult reference intervals, lipid decision limits and drug therapy targets in US conventional and SI units, with conversion factors, traps and nursing cues for NCLEX review],
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

= Adult lab values

#tableau(
  columns: (1fr, auto, auto, auto),
  align: (left, right, right, right),
  [Test], [US conventional], [Factor], [SI],
  ..groupes.map(g => (
    // Sous-en-tête de groupe : répété en haut de page si le groupe est coupé, jamais seul en bas de page.
    table.header(level: 2, table.cell(colspan: 4)[*#g.libelle*]),
    ..examens.filter(l => l.groupe_code == g.code).map(l => (
      [#l.examen],
      plage(l, l.bas_us, l.haut_us, l.unite_us),
      facteur-aff(l.facteur_code),
      plage(l, l.bas_si, l.haut_si, unite-si(l)),
    )).flatten(),
  )).flatten(),
)

_Ranges vary by lab. SI = US × factor, calculated from the US value except ionized calcium (source in mmol/L). Blood gas: room air._

= Convert US ↔ SI

#formule[
  *SI = US × factor*; US = SI ÷ factor.
  mg/dL → mmol/L: factor = #v("F_GLU", "K") ÷ molar mass (g/mol).
  mEq/L → mmol/L: ÷ ion charge (Na⁺, K⁺, Cl⁻, HCO₃⁻: same number).
  mm Hg → kPa: × #nombre(fac("MMHG").facteur) (1 mm Hg ≈ #val("mmhg_pa") Pa).
  HbA1c: mmol/mol = (% − #val("ngsp_ordonnee")) ÷ #val("ngsp_pente") (NGSP).
]

#exemple(titre: "Worked conversions")[
  Glucose #v("CV1", "G") mg/dL × #v("CV1", "F") #res("CV1").\
  Creatinine #v("CV2", "C") mg/dL × #v("CV2", "F") #res("CV2").\
  Ionized Ca #nombre(str(ex("CV3").e.S), decimales: int(exa("Calcium, ionized").decimales_si)) mmol/L ÷ #v("CV3", "F") #res("CV3").
]

= Traps

#piege(titre: "Same test, two numbers")[
  Glucose #nombre(exa("Glucose, fasting plasma").haut_us) mg/dL = #nombre(exa("Glucose, fasting plasma").haut_si) mmol/L. Read the unit before you compare a result with a range.
]

#piege(titre: "mEq is not always mmol")[
  Equal only for single-charge ions. Ca²⁺: 1 mmol = #val("valence_ca") mEq; Mg²⁺: 1 mmol = #val("valence_mg") mEq.
]

#piege(titre: "BUN is not urea")[
  US labs report urea *nitrogen* (BUN); SI labs report urea. Urea has #v("F_BUN", "A") N atoms: × #nombre(fac("BUN").facteur).
]

#piege(titre: "Total vs ionized calcium")[
  About half of blood calcium is bound to proteins, mainly albumin: abnormal albumin changes *total* calcium, and an ionized (unbound) calcium test may be ordered.
]

#piege(titre: "High K⁺ and hemolysis")[
  Report a high K⁺ per protocol. Hemolysis (red-cell injury in the sample) can release potassium and falsely raise K⁺; a redraw may be requested.
]

#piege(titre: "Hematocrit and SaO₂ in SI")[
  Written as fractions: #nombre(exa("Hematocrit, female").bas_us)% = #nombre(exa("Hematocrit, female").bas_si) L/L; #nombre(exa("SaO₂").bas_us)% = #nombre(exa("SaO₂").bas_si).
]

= Nursing cues

#note-clinique(titre: "INR and bleeding")[
  On warfarin, the prescriber sets the INR target, which depends on the indication; #val("inr_caillot")–#val("inr_saignement") is common. Above #val("inr_saignement"): higher bleeding risk; below #val("inr_caillot"): clot risk. Report per protocol.
]

#note-clinique(titre: "Potassium and the heart")[
  Low K⁺ can cause an irregular heartbeat; high K⁺ decreases heart muscle activity. Either can be life-threatening: report promptly per protocol.
]

#note-clinique(titre: "Digoxin level")[
  A general range: the right level may vary with the situation. Follow the prescriber's target.
]

_Sources: ABIM Laboratory Test Reference Ranges (Jan. 2026); MedlinePlus; NGSP (HbA1c). Other factors calculated: IUPAC atomic weights, unit definitions, triglycerides as triolein._
]
