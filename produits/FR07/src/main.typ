// FR07 — fiche de formules de physique-biophysique PASS/LAS, marché FR (adaptation de EN02, pas une traduction).
// Source unique pour les 4 formats ; tout vient de sys.inputs (contrat : scripts/README-pipeline.md)
// et de ../donnees/*.csv. Aucun nombre de donnée n'est tapé ici :
//   - exemples chiffrés : donnees/exemples.csv, chaque résultat recalculé depuis sa formule (échec si écart) ;
//   - constantes, conversions, valeurs de référence : donnees/valeurs.csv ;
//   - libellés des sources affichés : donnees/sources.csv (colonne libelle_court) ;
//   - justification de chaque élément : donnees/references.csv.
// Les entiers propres à l'écriture d'une formule (1/2, 2, 8 de Poiseuille, 10 des décibels, 3 de la PAM…) restent dans les formules.
// Build : python3 scripts/build.py FR07-STD
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("FR07 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés (recalculés) ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("FR07 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("FR07 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
// Entrée d'un exemple, en chaîne pour que nombre() conserve exactement ses chiffres.
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("FR07 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)))
}
// Résultat affiché, arrondi au nombre de décimales de la colonne « arrondi ».
#let res(id) = nombre(float(ex(id).resultat_attendu), decimales: int(ex(id).arrondi))
// Signe : « = » si le résultat affiché est exact, « ≈ » s'il est arrondi.
#let rel(id) = {
  let r = float(ex(id).resultat_attendu)
  if calc.abs(r - calc.round(r, digits: int(ex(id).arrondi))) < 0.0000001 { $=$ } else { $approx$ }
}

// ── Valeurs de référence (constantes, conversions, doses) ──
#let valeurs-liste = csv("../donnees/valeurs.csv", row-type: dictionary)
#let valeurs = {
  let d = (:)
  for l in valeurs-liste { d.insert(l.id, l) }
  d
}
#let val(id) = {
  if id not in valeurs { panic("FR07 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
// Valeur seule (notation scientifique si l'exposant n'est pas nul).
#let q(id) = {
  let l = val(id)
  if l.exposant == "0" { nombre(l.mantisse) } else { $#nombre(l.mantisse) times 10^#nombre(l.exposant)$ }
}
// Valeur suivie de son unité (espace insécable ; devant %, la charte met l'espace fine).
#let qu(id) = if val(id).unite == "%" [#q(id) %] else [#q(id)~#val(id).unite]
#let nombre-valeur(id) = float(val(id).mantisse) * calc.pow(10.0, int(val(id).exposant))
#let facteur(id) = nombre-valeur(id)
#let groupe(g) = valeurs-liste.filter(l => l.groupe == g).sorted(key: l => int(l.ordre))

// ── Sources : libellé court affiché ──
#let sources = {
  let d = (:)
  for l in csv("../donnees/sources.csv", row-type: dictionary) { d.insert(l.code, l) }
  d
}
#let source(code) = {
  if code not in sources { panic("FR07 : source " + code + " absente de donnees/sources.csv") }
  sources.at(code).libelle_court
}

// Cohérence des tables entre elles (échec de compilation si elles se contredisent).
#let verifie(nom, calcule, attendu, tol) = if calc.abs(calcule - attendu) > tol {
  panic("FR07 : incohérence " + nom + " : " + str(calcule) + " ≠ " + str(attendu))
}
#verifie("atm/mmHg", nombre-valeur("U_ATM") * 1000 / nombre-valeur("U_MMHG"), nombre-valeur("U_ATM_MMHG"), 0.01)
#verifie("mmHg/cmH2O", nombre-valeur("U_MMHG") / nombre-valeur("U_CMH2O"), nombre-valeur("U_MMHG_CMH2O"), 0.005)
#verifie("37 °C", 37 + nombre-valeur("U_KELVIN"), nombre-valeur("P_T37"), 0)
#verifie("Nernst 37 °C", calc.ln(10) * nombre-valeur("K_R") * nombre-valeur("P_T37") / nombre-valeur("K_F") * 1000,
  nombre-valeur("P_NERNST37"), 0.05)
#verifie("hc", nombre-valeur("K_H") * nombre-valeur("K_C") / nombre-valeur("K_E") * 1000000000, nombre-valeur("K_HC"), 0.5)
#verifie("FX01 mmHg", ex("FX01").e.Pmm, nombre-valeur("U_MMHG"), 0)
#verifie("FX05 M", ex("FX05").e.M, nombre-valeur("P_M_NACL"), 0)
#verifie("FX06 M", ex("FX06").e.M, nombre-valeur("P_M_NACL"), 0)
#verifie("FX06 R", ex("FX06").e.R, nombre-valeur("K_R"), 0)
#verifie("FX06 T", ex("FX06").e.T, nombre-valeur("P_T37"), 0)
#verifie("FX07 Kc", ex("FX07").e.Kc, nombre-valeur("P_KC_EAU"), 0)
#verifie("FX08 Nernst", ex("FX08").e.k, nombre-valeur("P_NERNST37"), 0)
#verifie("FX09 c", ex("FX09").e.c, nombre-valeur("P_CTISSU"), 0)
#verifie("FX10 c", ex("FX10").e.c, nombre-valeur("P_CTISSU"), 0)
#verifie("FX11 Z1", ex("FX11").e.Z1, nombre-valeur("P_Z_GRAISSE"), 0.001)
#verifie("FX11 Z2", ex("FX11").e.Z2, nombre-valeur("P_Z_MUSCLE"), 0.001)
#verifie("FX12 Z1", ex("FX12").e.Z1, nombre-valeur("P_Z_AIR"), 0)
#verifie("FX12 Z2", ex("FX12").e.Z2, nombre-valeur("P_Z_MUSCLE"), 0.001)
#verifie("FX17 gamma", ex("FX17").e.g, nombre-valeur("K_GP"), 0)
#verifie("FX18 gamma", ex("FX18").e.g, nombre-valeur("K_GP"), 0)
#verifie("FX20 n", float(ex("FX19").resultat_attendu), 4, 0)
#verifie("FX22 → FX23", float(ex("FX22").resultat_attendu), float(ex("FX23").e.D), 0)
#verifie("FX23 wR", float(ex("FX23").e.wR), nombre-valeur("W_ALPHA"), 0)
#verifie("FX13 → FX14", float(ex("FX13").resultat_attendu), float(ex("FX14").e.oap), 0.000001)
#verifie("FX13 OA", float(ex("FX13").e.oa), float(ex("FX14").e.oa), 0)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Formules, exemples chiffrés, notes santé et pièges : les notions de physique-biophysique les plus courantes en PASS et LAS],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
)

#colonnes(3)[

= Unités et conversions

#formule[
  Unités de base SI : m, kg, s, A, K, mol, cd. Homogénéité : $[F] = "M·L·T"^(-2)$, $[P] = "M·L"^(-1)"·T"^(-2)$, $[E] = "M·L"^2"·T"^(-2)$.
  #let sep = [ ; ]
  #val("U_ATM").libelle = #qu("U_ATM") = #qu("U_ATM_MMHG")#sep#val("U_MMHG").libelle = #qu("U_MMHG") ≈ #qu("U_MMHG_CMH2O")#sep#val("U_CMH2O").libelle = #qu("U_CMH2O")#sep#val("U_BAR").libelle = #qu("U_BAR")#sep#val("U_L").libelle = #qu("U_L")#sep#val("U_EV").libelle = #qu("U_EV")#sep#val("U_CAL").libelle = #qu("U_CAL")#sep#val("U_KELVIN").libelle #q("U_KELVIN").
]

= Hémodynamique

#formule[
  Statique : $P = P_0 + rho g h$ ; la pression artérielle est une pression relative.
  $ Q = S v #h(1em) S_1 v_1 = S_2 v_2 #h(1em) P + 1/2 rho v^2 + rho g h = "cste" $
  $ Q = (pi r^4 Delta P) / (8 eta L) #h(1em) R = (8 eta L) / (pi r^4) #h(1em) Delta P = R Q $
  Série $R = R_1 + R_2$ ; parallèle $1 \/ R = 1 \/ R_1 + 1 \/ R_2$.
  Reynolds $"Re" = 2 rho v r \/ eta$ : laminaire si $"Re" < #q("P_RE_LAM")$, turbulent si $"Re" > #q("P_RE_TURB")$.
  Laplace (alvéole) : $P = 2 T_s \/ r$ ($T_s$ tension superficielle).
  $"PAM" approx "PAD" + ("PAS" - "PAD") \/ 3$.
]

#exemple(titre: "Perfusion, rayon, Reynolds")[
  Poche à #v("FX01", "h") m : $rho g h = #v("FX01", "rho") times #v("FX01", "g") times #v("FX01", "h") "Pa" #rel("FX01") #res("FX01") "mmHg"$.
  Rayon $times #v("FX02", "k")$ $=>$ $R times$ #res("FX02").
  $rho = #v("FX03", "rho")$, $v = #v("FX03", "v")$, $r = #v("FX03", "r")$, $eta = #v("FX03", "eta")$ : $"Re" #rel("FX03") #res("FX03")$, zone instable.
  PAS/PAD #v("FX04", "S")/#v("FX04", "D") mmHg $=>$ PAM #rel("FX04") #res("FX04") mmHg.
]

= Solutions et échanges

#formule[
  $C = n \/ V$ (mol/L) ; $C_m = m \/ V = C M$ (g/L).
  Osmolarité $omega = i C$ (osmol/L de solution) ; osmolalité : par kg d'eau.
  $i = 1 + alpha (p - 1)$ : $alpha$ coefficient de dissociation, $p$ particules par molécule (NaCl : $p = 2$ ; glucose : $i = 1$).
  $ pi = i C R T #h(1em) Delta theta = K_c omega_m $
  $pi$ en Pa avec $C$ en mol/m³ (en kPa avec $C$ en mol/L) ; $K_c = #qu("P_KC_EAU")$ (eau), $omega_m$ osmolalité.
  Starling : $J_v = K_f [(P_"cap" - P_"int") - sigma (pi_"cap" - pi_"int")]$, $sigma$ coefficient de réflexion.
  Diffusion (Fick) : $J = D_"diff" S Delta C \/ Delta x$ ; distance $x approx sqrt(2 D_"diff" t)$.
]

#exemple(titre: "Sérum physiologique, cryoscopie")[
  NaCl #v("FX05", "Cm") g/L, $M = #qu("P_M_NACL")$ : $omega = #v("FX05", "i") times #v("FX05", "Cm") \/ #v("FX05", "M") #rel("FX05") #res("FX05")$ mosmol/L ;
  à #q("P_T37") K : $pi #rel("FX06") #res("FX06") "kPa"$ (valeurs théoriques, solution idéale).
  $Delta theta = #v("FX07", "dt") "°C"$ $=>$ $omega_m #rel("FX07") #res("FX07") "osmol/kg"$.
]

= Bioélectricité

#formule[
  Coulomb $F = k q_1 q_2 \/ r^2$ ; champ $arrow(E) = arrow(F) \/ q$ ; champ uniforme $E = U \/ d$ ; énergie $W = q U$.
  Nernst (potentiel d'équilibre de l'ion X, valence $z$) :
  $ E_X = (R T) / (z cal(F)) ln C_"ext" / C_"int" = (#qu("P_NERNST37")) / z log C_"ext" / C_"int" $
  ($cal(F)$ : Faraday ; #qu("P_NERNST37") à 37 °C). Repos : membrane surtout perméable à K⁺, $E_m$ proche de $E_"K"$.
]

#exemple(titre: "Nernst du calcium")[
  $C_"ext" \/ C_"int" = 10^#v("FX08", "lg")$, $z = #v("FX08", "z")$ : $E_"Ca" = #v("FX08", "k") \/ #v("FX08", "z") times #v("FX08", "lg") #rel("FX08") #res("FX08") "mV"$ (valeurs d'exercice).
]

= Ondes et ultrasons

#formule[
  $c = lambda f$ ($c$ célérité de l'onde, $lambda$ longueur d'onde) ; $I = cal(P) \/ S$ ($cal(P)$ puissance).
  $ L = 10 log I / I_0 #h(1em) Z = rho c #h(1em) a = ((Z_2 - Z_1) / (Z_1 + Z_2))^2 $
  $I_0 = #qu("P_I0")$ ; $a$ : fraction d'intensité réfléchie à l'interface.
  Échographie : $c_"tissu" = #qu("P_CTISSU")$ ; Doppler $Delta f = 2 f_0 v cos theta \/ c$ ($v$ vitesse des hématies).
]

#exemple(titre: "Échographie")[
  À #nombre(ex("FX09").e.f / facteur("P_MEGA")) MHz : $lambda #rel("FX09") #res("FX09") "mm"$.
  $v = #v("FX10", "v") "m/s"$, $cos theta = #v("FX10", "cs")$ $=>$ $Delta f #rel("FX10") #res("FX10") "kHz"$.
  Graisse → muscle : $a #rel("FX11") #res("FX11") %$ ; air → muscle : $a #rel("FX12") #res("FX12") %$.
]

= Optique et vision

#formule[
  $n = c \/ v$ ; Snell-Descartes $n_1 sin i_1 = n_2 sin i_2$ ; réflexion totale si $sin i > n_2 \/ n_1$ ($n_1 > n_2$).
  Lentille mince, distances algébriques (sens de la lumière positif, objet réel : $overline("OA") < 0$) :
  $ 1 / overline("OA'") - 1 / overline("OA") = 1 / f' = C #h(1.5em) gamma = overline("A'B'") / overline("AB") = overline("OA'") / overline("OA") $
  Vergence $C$ en dioptries (δ), $f'$ en m ; lentilles accolées $C = C_1 + C_2$.
  Œil : PR (punctum remotum), PP (punctum proximum) ; accommodation $A_"acc" = 1 \/ d_"PP" - 1 \/ d_"PR"$ (δ, distances en m).
]

#tableau(
  columns: (auto, 1fr),
  [Défaut], [Cause : verre correcteur],
  [Myopie], [œil trop convergent, PR à distance finie : divergent],
  [Hypermétropie], [œil pas assez convergent : convergent],
  [Presbytie], [accommodation réduite avec l'âge : convergent (près)],
  [Astigmatisme], [cornée non sphérique : cylindrique],
)

#exemple(titre: "Lentille, myopie, presbytie")[
  $f' = #v("FX13", "fp") "m"$, $overline("OA") = #v("FX13", "oa") "m"$ $=>$ $overline("OA'") #rel("FX13") #res("FX13") "m"$, $gamma #rel("FX14") #res("FX14")$ (réelle, renversée).
  PR à #v("FX15", "x") m $=>$ $C = -1 \/ d_"PR" #rel("FX15") #res("FX15") δ$.
  PP à #v("FX16", "pp") m, lecture à #v("FX16", "d") m $=>$ addition $#rel("FX16") #res("FX16") δ$.
]

= Rayonnements ionisants

#formule[
  $N = N_0 e^(-lambda t) = N_0 (1/2)^(t \/ T_(1\/2))$ ; $lambda = ln 2 \/ T_(1\/2)$ : constante radioactive (pas une longueur d'onde).
  Activité $A = lambda N$ en Bq ; après $n$ périodes, $A = A_0 \/ 2^n$.
  α : $A_"nucl" - 4$, $Z - 2$ ; β⁻ : $Z + 1$ ; β⁺ et capture électronique : $Z - 1$ ; γ : $A_"nucl"$ et $Z$ inchangés.
  Photon : $E_"ph" = h f = h c \/ lambda_"onde"$, $h c = #qu("K_HC")$.
  Atténuation X, γ : $I = I_0 e^(-mu x)$ ; CDA $x_(1\/2) = ln 2 \/ mu$.
  Dose absorbée $D = E_"dép" \/ m$ (Gy = J/kg) ; dose équivalente $H = w_R D$ (Sv) ; dose efficace $E = sum w_T H_T$ (Sv, risque global).
]

#exemple(titre: "Décroissance, écran, dose")[
  #v("FX20", "A0") MBq, #v("FX19", "t") h, $T_(1\/2) = #v("FX19", "T") "h"$ : $n = #res("FX19")$ $=>$ #res("FX20") MBq.
  Écran de #v("FX21", "n") CDA : il reste #res("FX21") % du faisceau.
  #v("FX22", "En") J dans #v("FX22", "m") kg : $D #rel("FX22") #res("FX22") "mGy"$ ; en α : $H = #v("FX23", "wR") times #v("FX23", "D") #rel("FX23") #res("FX23") "mSv"$.
]

#tableau(
  columns: (auto, 1fr),
  [Repère], [Valeurs],
  [$w_R$], [#groupe("WR").map(l => [#l.libelle #q(l.id)]).join(" ; ")],
  [Imagerie (adulte)], [#groupe("DOSE").map(l => [#l.libelle #qu(l.id)]).join(" ; ")],
  [Limites (France)], [#groupe("LIMITE").map(l => [#l.libelle #qu(l.id)]).join(" ; ") ; patients : pas de limite, justification et optimisation],
)

= RMN et IRM

#formule[
  Larmor : $f_0 = (gamma_p \/ 2 pi) B_0$, $gamma_p \/ 2 pi = #qu("K_GP")$ (¹H).
  Relaxation : $M_z = M_0 (1 - e^(-t \/ T_1))$ ; $M_(x y) = M_0 e^(-t \/ T_2)$ ; $T_2 < T_1$.
  Pondération T1 : TR et TE courts ; pondération T2 : TR et TE longs.
]

#exemple(titre: "Fréquence de résonance")[
  $B_0 = #v("FX17", "B") "T"$ : $f_0 #rel("FX17") #res("FX17") "MHz"$ ; $B_0 = #v("FX18", "B") "T"$ : $f_0 #rel("FX18") #res("FX18") "MHz"$.
]

= Thermodynamique

#formule[
  $P V = n R T$ ($T$ en K) ; Dalton $P_i = x_i P_"tot"$ ; Henry $C = k_H P_"gaz"$.
  Premier principe (convention française, $W$ et $Q$ reçus par le système) : $Delta U = W + Q$ ; isobare $W = -P Delta V$.
  $Q = m c_"th" Delta T$ ($c_"th"$ capacité thermique massique) ; changement d'état $Q = m L$.
]

#note-clinique(titre: "Notes santé")[
  - Vasoconstriction : $R prop 1 \/ r^4$, un faible rétrécissement augmente fortement la résistance.
  - Brassard au niveau du cœur : bras levé, mesure trop basse (pression hydrostatique).
  - Surfactant : abaisse $T_s$ et stabilise les petites alvéoles (Laplace).
  - Solution hypotonique : les hématies gonflent jusqu'à l'hémolyse.
  - Gel d'échographie : supprime l'interface air–peau, presque totalement réfléchissante.
  - Haute fréquence : meilleure résolution, moindre profondeur explorée.
  - IRM : pas de rayonnement ionisant (ondes radiofréquences).
  - Radioprotection : justification, optimisation, limitation.
]

#piege[
  - Osmolarité (par L de solution) ≠ osmolalité (par kg d'eau) ; ne pas oublier $i$.
  - $pi$ ne compte que les particules qui ne traversent pas la membrane ($sigma$).
  - Rayon ÷ 2 : résistance × 16 ($r^4$), pas × 2.
  - Fluide plus rapide, pression *plus basse* (Bernoulli, fluide parfait).
  - Convention algébrique : objet réel $overline("OA") < 0$ ; $C$ en δ seulement avec $f'$ en m.
  - Deux sources identiques : +#qu("P_DB2"), pas un niveau doublé.
  - Après deux périodes il reste un quart, pas zéro.
  - Gy (énergie) ≠ Sv (risque) ; la dose efficace ne se mesure pas directement.
  - Manuels anglo-saxons : $Delta U = Q - W$ ($W$ fourni par le gaz), même physique.
  - Lois des gaz et Nernst : températures en kelvins.
  - Mêmes lettres, grandeurs différentes : $T$ (température) ≠ $T_s$, $T_(1\/2)$, $T_1$, $T_2$ ; $C$ (concentration ou vergence) ; $lambda$ (onde ou constante radioactive).
]

= Constantes

#formule[
  #groupe("CONST").map(l => [$#eval(l.symbole, mode: "math") = #q(l.id)$~#l.unite]).join(" ; ").
  Valeurs #source(val("K_C").source_code), arrondies ; $g_n$ conventionnelle ; $h c$ dérivé.
]
]
