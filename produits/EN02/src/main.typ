// EN02 — fiche de formules de physique (premier cycle, pré-médecine), marché EN.
// Source unique pour les 4 formats ; tout vient de sys.inputs (contrat : scripts/README-pipeline.md)
// et de ../donnees/*.csv. Aucun nombre de donnée n'est tapé ici :
//   - exemples chiffrés : donnees/exemples.csv, chaque résultat recalculé depuis sa formule (échec si écart) ;
//   - constantes, conversions, valeurs de référence : donnees/valeurs.csv ;
//   - sources : donnees/references.csv.
// Les entiers propres à l'écriture d'une formule (1/2, 2π, 8 de Poiseuille, 10 des décibels…) restent dans les formules.
// Build : python3 scripts/build.py EN02-STD
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN02 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés (recalculés) ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("EN02 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("EN02 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
// Entrée d'un exemple, en chaîne pour que nombre() conserve exactement ses chiffres.
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("EN02 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)))
}
// Résultat affiché, arrondi au nombre de décimales de la colonne « arrondi ».
#let res(id) = nombre(float(ex(id).resultat_attendu), decimales: int(ex(id).arrondi))
#let u(id) = ex(id).unite

// ── Valeurs de référence (constantes, conversions, doses) ──
#let valeurs-liste = csv("../donnees/valeurs.csv", row-type: dictionary)
#let valeurs = {
  let d = (:)
  for l in valeurs-liste { d.insert(l.id, l) }
  d
}
#let val(id) = {
  if id not in valeurs { panic("EN02 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
// Valeur seule (notation scientifique si l'exposant n'est pas nul).
#let q(id) = {
  let l = val(id)
  if l.exposant == "0" { nombre(l.mantisse) } else { $#nombre(l.mantisse) times 10^#nombre(l.exposant)$ }
}
// Valeur suivie de son unité.
// Pas d'espace avant % (usage anglais US).
#let qu(id) = if val(id).unite == "%" [#q(id)%] else [#q(id)~#val(id).unite]
// Facteur d'un préfixe SI (valeurs.csv, groupe PREFIX) : mantisse × 10^exposant.
#let facteur(id) = float(val(id).mantisse) * calc.pow(10.0, int(val(id).exposant))
#let groupe(g) = valeurs-liste.filter(l => l.groupe == g).sorted(key: l => int(l.ordre))

// Cohérence des conversions dérivées (échec de compilation si la table se contredit).
#let verifie(nom, calcule, attendu, tol) = if calc.abs(calcule - attendu) > tol {
  panic("EN02 : conversion incohérente " + nom + " : " + str(calcule) + " ≠ " + str(attendu))
}
#verifie("atm/mmHg", float(val("U_ATM").mantisse) * 1000 / float(val("U_MMHG").mantisse),
  float(val("U_ATM_MMHG").mantisse), 0.01)
#verifie("mmHg/cmH2O", float(val("U_MMHG").mantisse) / float(val("U_CMH2O").mantisse),
  float(val("U_MMHG_CMH2O").mantisse), 0.005)
#verifie("kcal", float(val("U_CAL").mantisse) * 1000, float(val("U_KCAL").mantisse), 0.0001)
#verifie("R L.atm", float(val("K_R").mantisse) / float(val("U_ATM").mantisse),
  float(val("K_RL").mantisse), 0.00001)
#verifie("Bernoulli K", float(val("P_BERN_K").mantisse), float(ex("EX19").e.K), 0)
#verifie("c tissu", float(val("P_CTISSUE").mantisse), float(ex("EX07").e.c), 0)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Formulas, worked examples, clinical notes and exam traps for college physics, pre-med and MCAT review],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
)

#colonnes(3)[

= Units & conversions

#formule[
  #let sep = [; ]
  #val("U_ATM").libelle = #qu("U_ATM") = #qu("U_ATM_MMHG")#sep#val("U_MMHG").libelle = #qu("U_MMHG") ≈ #qu("U_MMHG_CMH2O")#sep
  #val("U_CMH2O").libelle = #qu("U_CMH2O")#sep#val("U_CAL").libelle = #qu("U_CAL")#sep#val("U_KCAL").libelle = #qu("U_KCAL")#sep
  #val("U_EV").libelle = #qu("U_EV")#sep#val("U_KELVIN").libelle #q("U_KELVIN").
  $1 "Pa" = 1 "N/m"^2$, $1 "J" = 1 "N·m"$, $1 "W" = 1 "J/s"$.
]

= Kinematics

#formule[
  $ v = v_0 + a t #h(1em) Delta x = v_0 t + 1/2 a t^2 #h(1em) v^2 = v_0^2 + 2 a Delta x $
  Projectile: $v_x$ constant, $a_y = -g$; the vertical motion alone sets the flight time.
]

= Forces & equilibrium

#formule[
  $sum arrow(F) = m arrow(a)$; weight $F_g = m g$; spring $F = -k x$; friction $f_s <= mu_s N$, $f_k = mu_k N$.
  Incline: $F_parallel = m g sin theta$, $N = m g cos theta$. Torque $tau = r F sin theta$.
  Equilibrium: $sum F = 0$ and $sum tau = 0$.
]

= Work & energy

#formule[
  $W = F d cos theta$; $K = 1/2 m v^2$; $U_g = m g h$; $U_s = 1/2 k x^2$;
  $W_"net" = Delta K$; $P = W \/ t = F v$. Without friction $K + U$ is conserved.
]

= Momentum

#formule[
  $p = m v$; impulse $J = F Delta t = Delta p$. Momentum is conserved in every isolated collision,
  kinetic energy only in elastic ones. Perfectly inelastic: $m_1 v_1 + m_2 v_2 = (m_1 + m_2) v_f$.
]

#exemple(titre: "Landing")[
  #v("EX02", "m") kg at #v("EX02", "v") m/s, $F = m v \/ Delta t$: stopped in #v("EX02", "t") s (knees bent)
  $=>$ #res("EX02") N; in #v("EX03", "t") s (knees locked) $=>$ #res("EX03") N.
]

= Circular motion & gravity

#formule[
  $ a_c = v^2 / r = omega^2 r #h(1.5em) F_c = (m v^2) / r $
  $ F = G (m_1 m_2) / r^2 #h(1.5em) g = (G M) / r^2 $
]

= Fluids & circulation

#formule[
  $rho = m \/ V$; $P = F \/ A$; $P = P_0 + rho g h$; buoyancy $F_B = rho_"fluid" V_"sub" g$.
  $ Q = A v #h(1em) A_1 v_1 = A_2 v_2 #h(1em) P + 1/2 rho v^2 + rho g h = "const" $
  $ Q = (pi r^4 Delta P) / (8 eta L) #h(1em) Delta P = Q R $
  Laplace: vessel $T = P r$; alveolus $P = 2 T \/ r$.
]

#exemple(titre: "Poiseuille and IV bag")[
  Radius × $k = #v("EX04", "k")$ $=>$ flow × $k^4 approx$ #res("EX04")% of baseline, resistance × $approx$ #res("EX05").
  Bag #v("EX06", "h") m above the cannula: $rho g h = #v("EX06", "rho") times #v("EX06", "g") times #v("EX06", "h") "Pa" approx #res("EX06") "mmHg"$.
]

= Waves & sound

#formule[
  $v = f lambda$; $T = 1 \/ f$; SHM $T = 2 pi sqrt(m \/ k)$, pendulum $T = 2 pi sqrt(L \/ g)$.
  $ beta = 10 log_10 I / I_0 #h(1em) I = P / (4 pi r^2) #h(1em) f' = f (v plus.minus v_o) / (v minus.plus v_s) $
  $I_0 = #qu("P_I0")$. Doppler: upper signs when source and observer approach.
]

= Light & optics

#formule[
  $n = c \/ v$; $n_1 sin theta_1 = n_2 sin theta_2$; critical angle $sin theta_c = n_2 \/ n_1$ ($n_1 > n_2$).
  $ 1 / f = 1 / d_o + 1 / d_i #h(1em) m = - d_i / d_o #h(1em) P = 1 / f $
  $P$ in diopters ($f$ in m). Mirror $f = R \/ 2$. Lenses in contact: $P = P_1 + P_2$.
]

#tableau(
  columns: (auto, 1fr, 1fr),
  [Sign], [+], [−],
  [$f$], [converging lens, concave mirror], [diverging lens, convex mirror],
  [$d_i$], [real (lens: far side; mirror: front)], [virtual],
  [$m$], [upright], [inverted],
)

#exemple(titre: "Lens and myopia")[
  $f = #v("EX09", "f") "m"$, $d_o = #v("EX09", "d") "m"$ $=>$ $d_i = #res("EX09") "m"$, $m = #res("EX10")$ (real, inverted).
  Far point #v("EX11", "x") m $=>$ lens $P = -1 \/ x = #res("EX11") "D"$.
]

= Electricity & magnetism

#formule[
  $ F = k (q_1 q_2) / r^2 #h(1em) E = (k q) / r^2 #h(1em) V = (k q) / r #h(1em) B = (mu_0 I) / (2 pi r) $
  $U = q V$; $Delta V = E d$; $F = q v B sin theta$; $F = I L B sin theta$ (right-hand rule).
]

= Circuits

#formule[
  $V = I R$; $R = rho L \/ A$; $P = I V = I^2 R = V^2 \/ R$. Series $R = R_1 + R_2$; parallel $1 \/ R = 1 \/ R_1 + 1 \/ R_2$.
  $C = Q \/ V$; $C = kappa epsilon_0 A \/ d$; $U = 1/2 C V^2$; capacitors combine the other way round.
  RC: $tau = R C$, #qu("P_RC63") charged after one $tau$ (#qu("P_RC37") left on discharge).
  Kirchhoff: $sum I_"in" = sum I_"out"$; $sum Delta V = 0$ around a loop.
]

#exemple(titre: "Parallel and defibrillator")[
  $#v("EX12", "R1") thin Omega parallel #v("EX12", "R2") thin Omega = #res("EX12") thin Omega$.
  $C = #nombre(ex("EX13").e.C / facteur("P_MICRO"), decimales: 0) thin mu"F"$ ($#v("EX13", "C") "F"$) at #v("EX13", "V") V: $U = 1/2 C V^2 = #res("EX13") "J"$.
]

= Thermodynamics & gases

#formule[
  $P V = n R T$; $P_1 V_1 \/ T_1 = P_2 V_2 \/ T_2$; $Delta U = Q - W$ ($W$ by the gas); $W = P Delta V$;
  $Q = m c Delta T$; $Q = m L$; Dalton $P_i = x_i P_"total"$; mean $K = 3/2 k_B T$.
]

= Atomic & nuclear

#formule[
  $E = h f = h c \/ lambda$; $K_max = h f - phi$; $E = Delta m c^2$.
  Activity $A = lambda N$, with $lambda = ln 2 \/ T_(1/2)$ the decay constant (not a wavelength).
  $ N = N_0 (1/2)^(t \/ T_(1/2)) $
  α: $A - 4$, $Z - 2$; β⁻: $Z + 1$; β⁺: $Z - 1$; γ: no change.
  Dose $D$ in Gy (J/kg); equivalent dose $H = w_R D$ in Sv.
]

#exemple(titre: "Photon and half-life")[
  $E = h c \/ lambda = #v("EX15", "hc") "eV·nm" \/ #v("EX15", "l") "nm" = #res("EX15") "eV"$.
  #v("EX17", "A0") MBq, #v("EX16", "t") h, $T_(1/2) = #v("EX16", "T") "h"$: $n = #res("EX16")$ $=>$ #res("EX17") MBq.
]

#note-clinique[
  - Elbow: third-class lever, so the biceps pulls far harder than the load.
  - Airbags and bent knees lengthen $Delta t$: same $Delta p$, lower force.
  - $R prop 1 \/ r^4$: slight vasoconstriction sharply raises resistance.
  - Cuff at heart level; a raised arm reads low.
  - Laplace: surfactant keeps small alveoli open; a dilated vessel has higher wall tension.
  - Ultrasound gel removes air; higher frequency: finer detail, less depth.
  - Myopia: diverging lens; hyperopia, presbyopia: converging.
  - Inspiration is Boyle's law: chest volume up, pressure down, air in.
  - Gy measures energy absorbed; Sv weighs biological risk.
]

#piege[
  - $N = m g$ only on a level surface with no other vertical force.
  - A force perpendicular to motion does no work (centripetal, magnetic).
  - No centrifugal force: net force points to the center.
  - Faster fluid, *lower* pressure (Bernoulli).
  - Blood pressure is a gauge pressure.
  - Two equal sound sources add #qu("P_DB2"), not double the level.
  - Diverging lens alone: always virtual, upright, smaller.
  - Capacitors in series add like resistors in parallel.
  - Gas laws need kelvin.
  - Photoelectric: intensity sets the number of electrons, frequency their energy.
  - Inelastic collision: momentum conserved, kinetic energy not.
  - After two half-lives a quarter remains, not zero.
]

= High-yield medical physics

#tableau(
  columns: (auto, 1fr),
  [Topic], [Relation and worked value],
  [MAP], [$"MAP" approx "DBP" + ("SBP" - "DBP") \/ 3$: #v("EX18", "S")/#v("EX18", "D") mmHg $=>$ #res("EX18") mmHg. $"MAP" - "CVP" approx "CO" times "SVR"$, $"CO" = "HR" times "SV"$],
  [Valve], [$Delta P approx #q("P_BERN_K") v^2$ (mmHg, m/s): $v = #v("EX19", "v") "m/s" => #res("EX19") "mmHg"$. Severe aortic stenosis: $v_max >= #qu("P_AS_VMAX")$],
  [Ultrasound], [$c_"tissue" = #qu("P_CTISSUE")$; at #nombre(ex("EX07").e.f / facteur("P_MEGA")) MHz, $lambda approx #res("EX07") "mm"$. Doppler $Delta f = 2 f_0 v cos theta \/ c$: $v = #v("EX08", "v") "m/s"$, $cos theta = #v("EX08", "cs") => #res("EX08") "kHz"$],
  [Inspired O₂], [$P_(I O_2) = F_(O_2) (P_"atm" - P_(H_2 O))$, $P_(H_2 O) = #qu("P_PH2O")$: $#v("EX14", "F") times (#v("EX14", "P") - #v("EX14", "W")) approx #res("EX14") "mmHg"$],
  [Doses], [Effective dose $sum w_T H_T$ (Sv; tissue-weighted, whole-body risk), adult: #groupe("DOSE").map(l => [#l.libelle #qu(l.id)]).join("; ")],
  [Gy to Sv], [$w_R$: #groupe("WR").map(l => [#l.libelle #q(l.id)]).join("; ")],
)

= Constants

#let cst = groupe("CONST")
#let moitie = calc.ceil(cst.len() / 2)
#let cellule(l) = if l == none { ([], []) } else { ([#eval(l.symbole, mode: "math")], [#q(l.id) #l.unite]) }
#tableau(
  columns: (auto, 1fr, auto, 1fr),
  entete: 0,
  ..range(moitie).map(i => cellule(cst.at(i)) + cellule(cst.at(i + moitie, default: none))).flatten(),
)
#text(size: 0.85em)[#val("K_C").source_code.replace("_", " ") values, rounded; $g_n$ conventional; $R$ in L·atm and $h c$ derived.]
]
