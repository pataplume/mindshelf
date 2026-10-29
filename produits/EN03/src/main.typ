// EN03 : Chemistry Formula Sheet (College & Pre-Med), une page A4 en 3 colonnes.
// Contrat : scripts/README-pipeline.md (titre, marque, version, langue, format, produit arrivent par sys.inputs).
// Aucun nombre affiché n'est tapé ici : exemples chiffrés dans ../donnees/exemples.csv (recalculés à la
// compilation, échec si écart), constantes, coefficients et intervalles dans ../donnees/valeurs.csv,
// géométries VSEPR dans ../donnees/vsepr.csv, bandes IR et déplacements RMN dans ../donnees/spectro.csv.
// Sources de chaque élément : ../donnees/references.csv.
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN03 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés : recalcul et contrôle des logarithmes fournis en entrée ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("EN03 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    // L = log10(R) est fourni en entrée (la colonne formule n'admet pas log) : on le contrôle ici.
    if "R" in e and "L" in e and calc.abs(calc.log(e.R) - e.L) > 0.0001 {
      panic("EN03 : " + l.id + " : log10(" + str(e.R) + ") ≠ " + str(e.L))
    }
    d.insert(l.id, l + (e: e))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("EN03 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("EN03 : entrée " + cle + " absente de " + id) }
  // str() de Typst écrit le moins en U+2212 : on le ramène au tiret ASCII attendu par nombre().
  nombre(str(e.at(cle)).replace("\u{2212}", "-"))
}
// Résultat affiché : arrondi au nombre de décimales de la colonne `arrondi`.
#let res(id) = {
  let l = ex(id)
  if l.arrondi == "" { nombre(l.resultat_attendu) } else { nombre(l.resultat_attendu, decimales: int(l.arrondi)) }
}

// Signe devant un résultat : « = » si la valeur affichée est exacte, « ≈ » si elle est arrondie.
#let rel(id) = {
  let l = ex(id)
  let x = float(l.resultat_attendu)
  if l.arrondi == "" or calc.abs(calc.round(x, digits: int(l.arrondi)) - x) < 1e-9 { sym.eq } else { sym.approx }
}

// ── Constantes, coefficients, intervalles ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.id, l) }
  d
}
#let _val(id) = {
  if id not in valeurs { panic("EN03 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
// k("R_J") : nombre seul ; k("R_J", u: true) : avec son unité.
#let k(id, u: false) = {
  let l = _val(id)
  nombre(l.valeur)
  if l.exposant != "" [ × 10#super(nombre(l.exposant))]
  if u and l.unite != "" [ #l.unite]
}
// Condition de validité d'une valeur (ex. « 25 °C »), lue dans la colonne condition.
#let cond(id) = {
  let l = _val(id)
  if l.condition == "" { panic("EN03 : valeur " + id + " sans condition dans donnees/valeurs.csv") }
  l.condition
}
#let plage(id) = {
  let l = _val(id)
  [#nombre(l.valeur)–#nombre(l.valeur_max) #l.unite]
}
#let vsepr = csv("../donnees/vsepr.csv", row-type: dictionary)
#let spectro = csv("../donnees/spectro.csv", row-type: dictionary)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [General and organic chemistry for college, pre-med and MCAT review, plus the clinical chemistry med school builds on],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  version: entree("version"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
)

#colonnes(3)[

= Units & Concentration

#formule[
  $ M = n / V_"soln" quad m = n_"solute" / m_"solvent (kg)" quad n = m / cal(M) $
  $ C_1 V_1 = C_2 V_2 quad "eq" = n times |z| quad "osmolarity" = i times M $
  $cal(M)$ molar mass; $i$ van 't Hoff factor; $z$ ion charge. _E.g._ #v("EX01", "V2") mL of #v("EX01", "C2") M from #v("EX01", "C1") M stock: $V_1 = #v("EX01", "C2") times #v("EX01", "V2") \/ #v("EX01", "C1") #rel("EX01") #res("EX01")$ mL.
]

= Atoms & Periodic Trends

#formule[
  $ A = Z + N quad E = h nu = (h c) / lambda quad c = lambda nu $
  $n >= 1$; $ell = 0 ... n - 1$; $m_ell = -ell ... + ell$; $m_s = plus.minus 1/2$.
]
Across a period →: radius ↓, ionization energy ↑, electronegativity ↑; down a group ↓: reversed.

= Bonding & Geometry

#formule(titre: "Formal charge")[
  $ "FC" = V - N - B / 2 $
  $V$ valence, $N$ nonbonding, $B$ bonding e⁻. Best: charges near zero, minus on the more electronegative atom.
]

#tableau(
  columns: (auto, auto, 1fr, auto, auto),
  align: (center, center, left, right, left),
  [Dom.], [LP], [Shape (e.g.)], [Angle], [Hybrid],
  ..vsepr.map(l => (
    l.domaines, l.paires_libres, [#l.forme (#l.exemple)],
    [#l.qualificatif#nombre(l.angle)#if l.angle2 != "" [, #nombre(l.angle2)]°],
    l.hybridation,
  )).flatten(),
)
*IMFs:* ion–dipole > H-bond (H on N, O, F) > dipole–dipole > London. Stronger IMFs: higher bp, lower vapor pressure.

= Gases

#formule[
  $ P V = n R T quad (P_1 V_1) / T_1 = (P_2 V_2) / T_2 $
  $ P_i = X_i P_"tot" quad r_1 / r_2 = sqrt(cal(M)_2 / cal(M)_1) $
  $T$ in kelvin. _E.g._ #v("EX02", "P") atm, #v("EX02", "V") L, #v("EX02", "T") K, $R$ = #v("EX02", "R"): $n = P V \/ R T #rel("EX02") #res("EX02")$ mol.
]

= Thermochemistry

#formule[
  $ q = m c Delta T quad Delta G = Delta H - T Delta S $
  $ Delta H_"rxn" = sum Delta H_f^"prod" - sum Delta H_f^"react" $
  $ Delta G° = -R T ln K = -n F E° $
  _E.g._ $Delta H = #v("EX03", "H")$ kJ/mol, $Delta S = #v("EX03", "S")$ kJ/(mol·K), #v("EX03", "T") K: $Delta G #rel("EX03") #res("EX03")$ kJ/mol.
]

Spontaneous ($Delta G < 0$): $Delta H < 0, Delta S > 0$ always; $Delta H > 0, Delta S < 0$ never; both negative at low $T$; both positive at high $T$.

= Kinetics & Enzymes

#formule[
  $ "rate" = k [A]^m [B]^n quad k = A e^(-E_a \/ R T) $
  First order: $ln [A] = ln [A]_0 - k t$; $t_(1\/2) = #k("LN2") \/ k$.
  $ v = (V_max [S]) / (K_m + [S]) quad 1 / v = K_m / V_max dot 1 / [S] + 1 / V_max $
  Orders come from experiment, not coefficients. _E.g._ $K_m = #v("EX13", "Km")$ mM, $[S] = #v("EX13", "S")$ mM, $V_max = #v("EX13", "Vmax")$: $v #rel("EX13") #res("EX13")$ µmol/min.
]

#block(breakable: false)[#tableau(
  columns: (auto, 1fr, auto, auto),
  align: (left, left, center, center),
  [Inhibitor], [Binds], [$K_m$], [$V_max$],
  [Competitive], [E (active site)], [↑], [=],
  [Noncompetitive], [E and ES equally], [=], [↓],
  [Uncompetitive], [ES only], [↓], [↓],
  [Mixed], [E or ES, unequally], [↑ / ↓], [↓],
)]

= Equilibrium & Solubility

#formule[
  $ K = ([C]^c [D]^d) / ([A]^a [B]^b) quad K_"sp" (M_x X_y) = [M]^x [X]^y $
  $Q < K$: shifts right; $Q > K$: shifts left; solid forms if $Q > K_"sp"$. Common ion: lower solubility. Solids and pure liquids stay out of $K$.
]

= Acids, Bases & Buffers

#formule[
  $ "pH" = -log [H_3 O^+] quad K_w = [H_3 O^+][O H^-] $
  $ "p"K_a + "p"K_b = "p"K_w quad "pH" = "p"K_a + log ([A^-]) / ([H A]) $
  Best buffer within $"p"K_a plus.minus #k("TAMPON_ECART")$. Weak acid titrated by strong base: half-equivalence $"pH" = "p"K_a$; equivalence pH > #k("PH_NEUTRE").
]

#tableau(
  columns: (1fr, auto, auto, auto),
  align: (left, center, center, center),
  [Disorder], [pH], [Primary], [Comp.],
  [Metabolic acidosis], [↓], [↓ HCO₃⁻], [↓ PaCO₂],
  [Metabolic alkalosis], [↑], [↑ HCO₃⁻], [↑ PaCO₂],
  [Respiratory acidosis], [↓], [↑ PaCO₂], [↑ HCO₃⁻],
  [Respiratory alkalosis], [↑], [↓ PaCO₂], [↓ HCO₃⁻],
)

#note-clinique(titre: "Bicarbonate buffer")[
  $ "pH" = #k("BICARB_PKA") + log [H C O_3^-] / (#k("CO2_SOL") times P_a"CO"_2) $
  HCO₃⁻ #v("EX04", "HCO3") mmol/L, PaCO₂ #v("EX04", "PCO2") mmHg: ratio #res("EX04"), $log #v("EX05", "R") = #v("EX05", "L")$, pH #res("EX05").
]

= Solutions & Colligatives

#formule[
  $ Delta T_f = i K_f m quad Delta T_b = i K_b m quad Pi = i M R T $
  Raoult: $P_"soln" = X_"solvent" P°_"solvent"$. Water: $K_f$ = #k("KF_EAU", u: true), $K_b$ = #k("KB_EAU", u: true). _E.g._ #v("EX12", "m") mol/kg NaCl: $Delta T_f = #v("EX12", "i") times #v("EX12", "Kf") times #v("EX12", "m") #rel("EX12") #res("EX12")$ °C.
]

= Electrochemistry

#formule[
  $ E°_"cell" = E°_"cathode" - E°_"anode" quad Delta G° = -n F E° $
  $ E = E° - (R T) / (n F) ln Q = E° - #k("NERNST25") / n log Q $
  (#cond("NERNST25"), V). _E.g._ $E° = #v("EX15", "E0")$ V, $n = #v("EX15", "n")$, $Q = #v("EX15", "R")$: $E #rel("EX15") #res("EX15")$ V.
]
Oxidation at the anode. *Galvanic:* $Delta G < 0$, $E_"cell" > 0$, anode (−). *Electrolytic:* all three reversed.

#note-clinique(titre: [Membrane potential (#cond("NERNST37"))])[
  $ E_"ion" = #k("NERNST37") / z log [X]_"out" / [X]_"in" "(mV)" $
  K⁺ #v("EX06", "Kext") mM out, #v("EX06", "Kint") mM in: $E = #v("EX06", "k") times (#v("EX06", "L")) #rel("EX06") #res("EX06")$ mV.
]

= Organic Essentials

*R/S:* rank by atomic number at the first difference (CIP), point the lowest priority away, trace 1 → 2 → 3: clockwise _R_, counterclockwise _S_ (reverse if it points toward you).

#block(breakable: false)[#tableau(
  columns: (auto, 1fr, 1fr),
  align: (left, left, left),
  [], [S#sub[N]1], [S#sub[N]2],
  [Substrate], [3° > 2°], [methyl > 1° > 2°],
  [Rate law], [$k$[RX]], [$k$[RX][Nu⁻]],
  [Nucleophile], [weak is fine], [strong],
  [Solvent], [polar protic], [polar aprotic],
  [Stereo], [racemization], [inversion],
)]

*Amino acid pI* (neutral side chain): $"pI" = ("p"K_(a 1) + "p"K_(a 2)) \/ 2$; net charge + below pI, − above. _E.g._ #v("EX16", "p1") and #v("EX16", "p2"): pI #rel("EX16") #res("EX16").

= Spectroscopy

#formule(titre: "Beer–Lambert")[
  $ A = -log T = epsilon l c $
  _E.g._ $A$ = #v("EX14", "A"), $epsilon$ = #v("EX14", "e") L/(mol·cm), $l$ = #v("EX14", "l") cm: $c$ #rel("EX14") #res("EX14") µM.
]
#note-clinique(titre: "Pulse oximetry")[HbO₂ and Hb absorb #k("OX_ROUGE", u: true) and #k("OX_IR", u: true) light differently; the absorbance ratio gives SpO₂.]

#let ir = spectro.filter(l => l.methode == "IR")
#let rmn = spectro.filter(l => l.methode == "NMR")
#let ligne-spectro(l) = ([#l.groupe#if l.remarque != "" [, #l.remarque]], [#nombre(l.min)–#nombre(l.max)])
#tableau(
  columns: (1fr, auto),
  align: (left, right),
  [IR band], [cm⁻¹],
  ..ir.map(ligne-spectro).flatten(),
)
#tableau(
  columns: (1fr, auto),
  align: (left, right),
  [¹H NMR environment], [δ (ppm)],
  ..rmn.map(ligne-spectro).flatten(),
)
¹H NMR: $n$ neighboring H give $n + 1$ peaks; the integral is proportional to the number of H.


= High-Yield Med Chem

#formule[
  Anion gap = Na⁺ − (Cl⁻ + HCO₃⁻)\
  Osm = #k("OSM_NA") Na⁺ + Glu/#k("OSM_GLU") + BUN/#k("OSM_BUN")\
  CaO₂ = #k("HB_CAP") × Hb × SaO₂ + #k("O2_SOL") × PaO₂\
  $t_(1\/2)$ = #k("LN2") × V#sub[d] / CL
]
Glu, BUN in mg/dL; Hb in g/dL. Reference: AG #plage("AG_REF"), osm #plage("OSM_REF")\; intervals vary by lab and method.

#exemple[
  - Na #v("EX07", "Na"), Cl #v("EX07", "Cl"), HCO₃⁻ #v("EX07", "HCO3"): AG #rel("EX07") #res("EX07") mEq/L (high).
  - Na #v("EX08", "Na"), glucose #v("EX08", "G"), BUN #v("EX08", "B"): Osm #rel("EX08") #res("EX08") mOsm/kg.
  - Hb #v("EX09", "Hb"), SaO₂ #v("EX09", "Sa"), PaO₂ #v("EX09", "Pa"): CaO₂ #rel("EX09") #res("EX09") mL/dL, only #res("EX10") dissolved.
  - V#sub[d] #v("EX11", "Vd") L, CL #v("EX11", "CL") L/h: $t_(1\/2)$ #rel("EX11") #res("EX11") h.
]

#note-clinique(titre: "Alveolar gas equation")[
  $ P_A O_2 = F_I O_2 (P_"atm" - P_(H_2 O)) - P_a"CO"_2 \/ "RQ" $
  Sea level #k("PATM", u: true)\; P#sub[H₂O] #k("PH2O", u: true) at #cond("PH2O")\; RQ ≈ #k("RQ").
]

= Constants & Traps

$N_A$ = #k("NA", u: true) · $R$ = #k("R_J", u: true) = #k("R_ATM", u: true) · $F$ = #k("F", u: true) · $h$ = #k("H", u: true) · $c$ = #k("C", u: true) · $K_w$ (#cond("KW")) = #k("KW") · #cond("ATM_MMHG") = #k("ATM_MMHG", u: true) = #k("ATM_KPA", u: true) · ideal gas at #cond("VM"): #k("VM", u: true) · #cond("T0") = #k("T0", u: true) · water $c$ = #k("CP_EAU", u: true)

#piege[
  - Use kelvin; match J and kJ in $Delta H$, $Delta S$.
  - $M$ per L of solution; $m$ per kg of solvent.
  - Colligative effects count particles ($i$).
  - Catalysts lower $E_a$; only $T$ changes $K$.
  - $Delta G° = -R T ln K$: with log, multiply by #k("LN10").
  - At equilibrium $Delta G = 0$ and $E_"cell" = 0$.
]
]
