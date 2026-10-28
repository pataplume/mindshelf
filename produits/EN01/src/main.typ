// EN01 : Dosage Calculation & IV Drip Rates (marché EN, MindShelf). Fiche d'une page, risque IA FORT :
// méthode rédigée par l'agent, brouillon soumis à relecture métier (donnees/statut-methode.md), Whop uniquement.
// Contrat : titre, marque, version, langue, format et mentions arrivent par sys.inputs (scripts/README-pipeline.md).
// Aucun nombre n'est tapé ici : exemples (donnees/exemples.csv, recalculés ci-dessous, échec si écart),
// constantes (donnees/valeurs.csv), équivalents ménagers (donnees/menager.csv), notation (donnees/notation.csv).
// Règle d'arrondi : la colonne `arrondi` donne les décimales du résultat affiché ; si le calcul exact diffère,
// on affiche « exact ⇒ réglable ». Aucun zéro final : les nombres passent par str(), qui n'en garde pas.
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN01 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
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
      panic("EN01 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    if l.arrondi.trim() == "" { panic("EN01 : " + l.id + " : colonne arrondi vide") }
    d.insert(l.id, l + (e: e, x: attendu, n: int(l.arrondi)))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("EN01 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let brut(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("EN01 : entrée " + cle + " absente de " + id + " (entrees_json)") }
  e.at(cle)
}
// Entrée affichée (chaîne : nombre() conserve les chiffres, groupe les milliers, jamais de zéro final).
#let v(id, cle) = nombre(str(brut(id, cle)))
#let u(id) = ex(id).unite
// Résultat : « = 125 mL/h » si exact à la précision réglable, sinon « ≈ 41.67 ⇒ 42 gtt/min » (réglable en gras).
#let res(id, unite: auto) = {
  let l = ex(id)
  let un = if unite == auto { l.unite } else { unite }
  let r = calc.round(l.x, digits: l.n)
  if r == l.x { [#sym.eq #nombre(str(r))#sym.space.nobreak#un] } else {
    let montre = calc.round(l.x, digits: l.n + 2)
    let rel = if montre == l.x { "=" } else { sym.approx }
    [#rel #nombre(str(montre)) #sym.arrow.r.double *#nombre(str(r))#sym.space.nobreak#un*]
  }
}
#let x(id) = ex(id).x

// ── Constantes et tables ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.cle, l) }
  d
}
#let val-brut(cle) = {
  if cle not in valeurs { panic("EN01 : valeur " + cle + " absente de donnees/valeurs.csv") }
  float(valeurs.at(cle).valeur)
}
#let val(cle) = { let _ = val-brut(cle); nombre(valeurs.at(cle).valeur) }
#let valu(cle) = [#val(cle)#sym.space.nobreak#valeurs.at(cle).unite]
#let menager = csv("../donnees/menager.csv", row-type: dictionary)
#let notation = csv("../donnees/notation.csv", row-type: dictionary)

// ── Cohérence entre lignes et avec les constantes (échec de compilation si écart) ──
#let meme(a, b, quoi) = if calc.abs(float(a) - float(b)) > 0.000000001 {
  panic("EN01 : incohérence " + quoi + " : " + str(a) + " ≠ " + str(b))
}
#meme(brut("EX02A", "P"), brut("EX02B", "P"), "poids EX02")
#meme(brut("EX02A", "F"), val-brut("lb_kg"), "facteur lb→kg")
#meme(brut("EX02B", "G"), val-brut("lb_par_kg_cours"), "facteur 2.2")
#meme(brut("EX03A", "W"), brut("EX03B", "W"), "poids EX03")
#meme(brut("EX03C", "J"), val-brut("heures_par_jour"), "heures par jour")
#meme(brut("EX04A", "V"), brut("EX04B", "V"), "volume EX04")
#meme(brut("EX04A", "T"), brut("EX04B", "T"), "durée EX04")
#meme(brut("EX04B", "M"), val-brut("min_par_h"), "minutes par heure")
#meme(brut("EX05A", "V"), brut("EX05B", "V"), "volume EX05")
#meme(brut("EX05A", "R"), brut("EX05B", "R"), "débit EX05")
#meme(brut("EX05A", "R"), brut("EX05C", "R"), "débit EX05C")
#meme(brut("EX05C", "DF"), val-brut("gtt_micro"), "microgoutte")
#meme(brut("EX06A", "K"), val-brut("mosteller_k"), "constante de Mosteller")
#meme(calc.sqrt(x("EX06A")), brut("EX06B", "B"), "racine de la SC (EX06)")
#meme(brut("EX07A", "K"), val-brut("facteur_metrique"), "mg par g")
#meme(x("EX07A"), brut("EX07B", "C"), "concentration EX07")
#meme(brut("EX08A", "K"), val-brut("facteur_metrique"), "mcg par mg")
#meme(x("EX08A"), brut("EX08B", "C"), "concentration EX08")
#meme(x("EX09A"), brut("EX09C", "C"), "concentration EX09")
#meme(x("EX09B"), brut("EX09C", "N"), "unités/h EX09")
#meme(brut("C01", "C"), val-brut("pct_volume"), "100 mL du pourcentage")

// Heures décimales → « 16:30 » ; durée → « 7 h 30 min » (chiffres issus des données).
#let hm(h) = {
  let hh = int(calc.floor(h))
  let mm = int(calc.round((h - hh) * val-brut("min_par_h")))
  (hh, mm)
}
#let deux(n) = if n < 10 { "0" + str(n) } else { str(n) }
#let horloge(h) = { let (hh, mm) = hm(h); deux(hh) + ":" + deux(mm) }
#let duree(h) = { let (hh, mm) = hm(h); [#hh h #mm min] }

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Formulas, worked examples and common traps for nursing medication math and NCLEX review],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
  numerotation: true,
)

#colonnes(2)[

_Drugs A–F and their numbers: exercise values, not dosing guidance._

= Core methods

#formule(titre: "Three methods, one answer")[
  *Desired over have:* $V = D slash H times Q$. $D$ dose ordered, $H$ dose on hand, $Q$ volume (or tablets) holding $H$.
  *Ratio–proportion:* $H : Q = D : V$, then cross-multiply.
  *Dimensional analysis:* chain the order through conversion factors until only the wanted unit remains.
]

#exemple(titre: "Injection, three ways (Drug A)")[
  Drug A ordered #v("EX01", "D") mg; vial #v("EX01", "H") mg per #v("EX01", "Q") mL.\
  D/H × Q: #v("EX01", "D") ÷ #v("EX01", "H") × #v("EX01", "Q") #res("EX01")\
  Ratio #v("EX01", "H") : #v("EX01", "Q") = #v("EX01", "D") : $V$ and DA agree. Use a #valu("seringue_petite") syringe (#valu("seringue_petite_pas") marks).
]

#piege[Divide only once units match: g against mg is off by a factor of #val("facteur_metrique").]

= Unit conversions

#formule(titre: [The ×#val("facteur_metrique") ladder])[
  g → mg → mcg, L → mL: × #val("facteur_metrique") per step down, ÷ per step up.
  lb → kg: × #val("lb_kg") (exact; courses ÷ #val("lb_par_kg_cours")). in → cm: × #val("in_cm") (exact).
]

#tableau(
  columns: (auto, 1fr, auto),
  align: (left, right, right),
  [US measure], [NIST (exact, rounded)], [Label & course],
  ..menager.map(l => (
    [#l.mesure],
    [#sym.approx #nombre(str(calc.round(float(l.nist_ml), digits: int(l.decimales)))) mL],
    [#nombre(l.etiquette_ml) mL],
  )).flatten(),
)

#exemple(titre: "Child's weight")[
  #v("EX02A", "P") lb × #v("EX02A", "F") #res("EX02A") (recorded to #valu("poids_pas"))\;
  course shortcut #v("EX02B", "P") ÷ #v("EX02B", "G") #res("EX02B").
]

#note-clinique[Oral liquids: dose in mL with an oral syringe, never a kitchen spoon.]

#piege[Pounds typed as kg: the dose is about #val("lb_par_kg_cours") times too high.]

= Weight-based & safe dose

#formule[
  dose = mg/kg × kg; *per day* ÷ doses per day = *per dose*.
  Safe if low end × kg ≤ ordered daily total ≤ high end × kg.
]

#exemple(titre: "Safe-range check (Drug B)")[
  #v("EX03A", "L")–#v("EX03B", "U") mg/kg/day; #v("EX03A", "W") kg; ordered #v("EX03C", "O") mg every #v("EX03C", "I") h.
  Min #v("EX03A", "L") × #v("EX03A", "W") #res("EX03A")\; max #v("EX03B", "U") × #v("EX03B", "W") #res("EX03B").
  Ordered #v("EX03C", "O") × #v("EX03C", "J")/#v("EX03C", "I") #res("EX03C"): safe. Outside the range: hold, call the prescriber.
]

#piege[mg/kg/day is a #val("heures_par_jour") h total: compare per day or per dose, like with like.]

= IV infusion rates

#formule[
  *Pump:* rate (mL/h) = $V$ (mL) ÷ $T$ (h).
  *Gravity:* drip (gtt/min) = $V$ × DF ÷ ($T$ × #val("min_par_h")).
  DF (gtt/mL) is printed on the tubing: macrodrip #val("gtt_macro_a"), #val("gtt_macro_b") or #val("gtt_macro_c")\; microdrip #val("gtt_micro").
  *#val("gtt_micro")-drop shortcut:* with microdrip, gtt/min = mL/h.
  *End time* = start + $V$ ÷ rate.
]

#exemple(titre: "Same order, pump vs gravity")[
  #v("EX04A", "V") mL over #v("EX04A", "T") h. Pump: #v("EX04A", "V") ÷ #v("EX04A", "T") #res("EX04A").\
  Gravity, DF #v("EX04B", "DF"): #v("EX04B", "V") × #v("EX04B", "DF") ÷ (#v("EX04B", "T") × #v("EX04B", "M")) #res("EX04B").
]

#exemple(titre: "End time and microdrip")[
  #v("EX05A", "V") mL at #v("EX05A", "R") mL/h from #horloge(brut("EX05B", "S")):
  #v("EX05A", "V") ÷ #v("EX05A", "R") #res("EX05A") (#duree(x("EX05A"))) → ends #horloge(x("EX05B")).
  Microdrip: #v("EX05C", "R") × #v("EX05C", "DF") ÷ #v("EX05C", "M") #res("EX05C").
]

#piege[gtt/min needs minutes: hours alone give a rate #val("min_par_h") times too high.]

= Body surface area (Mosteller)

#formule[
  BSA (m²) = $sqrt("height (cm)" times "weight (kg)" "÷" #val("mosteller_k"))$
]

#exemple(titre: "BSA-based dose (Drug C)")[
  #v("EX06A", "H") cm, #v("EX06A", "W") kg: $sqrt(#v("EX06A", "H") times #v("EX06A", "W") "÷" #v("EX06A", "K")) = sqrt(#nombre(str(x("EX06A")))) = #v("EX06B", "B")$ m².
  Ordered #v("EX06B", "P") mg/m²: #v("EX06B", "B") × #v("EX06B", "P") #res("EX06B").
]

#piege[Mosteller's #val("mosteller_k") assumes cm and kg: convert in and lb first.]

= Reconstitution & strength

#formule[
  concentration = drug ÷ *final* volume on the label.
  % (w/v) = g per #valu("pct_volume"): #v("C01", "P")% = #v("C01", "P") × #v("C01", "K") ÷ #v("C01", "C") #res("C01").
  Ratio #v("C02", "G"):#v("C02", "V") = #v("C02", "G") g in #v("C02", "V") mL #res("C02").
]

#exemple(titre: "Powder vial (Drug D, fictional label)")[
  #v("EX07A", "G") g; label: add #v("EX07A", "A") mL to obtain #v("EX07A", "F") mL.
  #v("EX07A", "G") × #v("EX07A", "K") ÷ #v("EX07A", "F") #res("EX07A").
  Order #v("EX07B", "O") mg: #v("EX07B", "O") ÷ #v("EX07B", "C") #res("EX07B") (#valu("seringue_std") syringe, #valu("seringue_std_pas") marks).
]

#piege[Powder adds volume: use the final #v("EX07A", "F") mL, not the #v("EX07A", "A") mL of diluent.]

= Titration & drips

#formule[
  $C$ (mcg/mL) = mg in bag × #val("facteur_metrique") ÷ mL in bag.
  mL/h = mcg/kg/min × kg × #val("min_par_h") ÷ $C$.
  Reverse: mcg/kg/min = mL/h × $C$ ÷ (kg × #val("min_par_h")). Units: mL/h = (units/h) ÷ (units/mL).
]

#exemple(titre: "mcg/kg/min → mL/h (Drug E)")[
  #v("EX08A", "D") mg in #v("EX08A", "V") mL: #v("EX08A", "D") × #v("EX08A", "K") ÷ #v("EX08A", "V") #res("EX08A").
  #v("EX08B", "O") mcg/kg/min, #v("EX08B", "W") kg (as recorded): #v("EX08B", "O") × #v("EX08B", "W") × #v("EX08B", "M") ÷ #v("EX08B", "C") #res("EX08B").
]

#exemple(titre: "units/kg/h → mL/h (Drug F)")[
  #v("EX09A", "U") units in #v("EX09A", "V") mL #res("EX09A").
  #v("EX09B", "P") units/kg/h × #v("EX09B", "W") kg #res("EX09B")\;
  #v("EX09C", "N") ÷ #v("EX09C", "C") #res("EX09C").
]

#piege[Bag in mg, dose in mcg: × #val("facteur_metrique") first; per-minute doses need × #val("min_par_h").]

#note-clinique[ISMP high-alert (IV heparin, insulin): independent double check per policy.]

= Rounding & syringes

#encadre(titre: "Round once, at the end")[
  - Weight: record to #valu("poids_pas"), then use as recorded.
  - gtt/min: whole drops. mL/h: pump step (#valu("pompe_pas") here; some: whole mL/h).
  - Syringe: to its marks, #valu("seringue_petite_pas") (#valu("seringue_petite") size) or #valu("seringue_std_pas") (#valu("seringue_std") size).
]

#piege[Rounding a concentration or intermediate early shifts the final rate.]

= Safe notation

#tableau(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  [Never write], [Risk], [Write],
  ..notation.map(l => ([#l.ne_pas_ecrire], [#l.risque], [#l.ecrire])).flatten(),
)

#piege[A trailing zero or a missing leading zero makes a tenfold dose error.]

= Medication rights & orders

*Rights* (patient, drug, dose, route, time) need system safeguards, not just a checklist.
*Complete order:* patient name and ID, date/time, drug, dose with unit, route, frequency, weight if weight-based, signature.

#note-clinique[Unclear or incomplete order: clarify with the prescriber before giving.]
]
