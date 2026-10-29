// FR08 : PASS/LAS Chimie, fiche formules. Une page A4 en 3 colonnes, adaptée de EN03 (pas une traduction).
// Contrat : scripts/README-pipeline.md (titre, marque, version, langue, format, produit arrivent par sys.inputs).
// Aucun nombre affiché n'est tapé ici : exemples chiffrés dans ../donnees/exemples.csv (recalculés à la
// compilation, échec si écart), constantes et intervalles dans ../donnees/valeurs.csv (avec le jeu de
// constantes, ex. CODATA 2022, dans la colonne jeu), géométries dans ../donnees/vsepr.csv, bandes IR et
// déplacements RMN dans ../donnees/spectro.csv, ordre des fonctions dans ../donnees/nomenclature.csv.
// Sources de chaque élément : ../donnees/references.csv.
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("FR08 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés : recalcul, contrôle des logarithmes fournis en entrée ──
// L = log10(R) et N = ln(Rn) sont fournis en entrée (la colonne formule n'admet ni log ni ln) : contrôlés ici.
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("FR08 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    if "R" in e and "L" in e and calc.abs(calc.log(e.R) - e.L) > 0.000001 {
      panic("FR08 : " + l.id + " : log10(" + str(e.R) + ") ≠ " + str(e.L))
    }
    if "Rn" in e and "N" in e and calc.abs(calc.ln(e.Rn) - e.N) > 0.000001 {
      panic("FR08 : " + l.id + " : ln(" + str(e.Rn) + ") ≠ " + str(e.N))
    }
    d.insert(l.id, l + (e: e, calcule: calcule))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("FR08 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
// Entrée d'un exemple, affichée telle que saisie.
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("FR08 : entrée " + cle + " absente de " + id) }
  // str() de Typst écrit le moins en U+2212 : on le ramène au tiret ASCII attendu par nombre().
  nombre(str(e.at(cle)).replace("\u{2212}", "-"))
}
// Résultat affiché : arrondi au nombre de décimales de la colonne `arrondi`.
#let res(id) = {
  let l = ex(id)
  if l.arrondi == "" { nombre(l.resultat_attendu) } else { nombre(l.resultat_attendu, decimales: int(l.arrondi)) }
}
// Signe devant un résultat : « = » si la valeur affichée égale la valeur recalculée, « ≈ » sinon.
#let rel(id) = {
  let l = ex(id)
  let x = l.calcule
  if l.arrondi == "" or calc.abs(calc.round(x, digits: int(l.arrondi)) - x) < 1e-9 { sym.eq } else { sym.approx }
}

// ── Constantes, intervalles ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.id, l) }
  d
}
#let _val(id) = {
  if id not in valeurs { panic("FR08 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
// k("R_J") : nombre seul ; k("R_J", u: true) : avec son unité.
#let k(id, u: false) = {
  let l = _val(id)
  nombre(l.valeur)
  if l.exposant != "" [ × 10#super(nombre(l.exposant))]
  if u and l.unite != "" [ #l.unite]
}
#let cond(id) = {
  let l = _val(id)
  if l.condition == "" { panic("FR08 : valeur " + id + " sans condition dans donnees/valeurs.csv") }
  l.condition
}
#let jeu(id) = {
  let l = _val(id)
  if l.jeu == "" { panic("FR08 : valeur " + id + " sans jeu de constantes dans donnees/valeurs.csv") }
  l.jeu
}
#let plage(id) = {
  let l = _val(id)
  [#nombre(l.valeur)–#nombre(l.valeur_max)#if l.unite != "" [ #l.unite]]
}
// ── Concordance exemples.csv / valeurs.csv et entre exemples (échec de compilation si écart) ──
// Constantes saisies dans un exemple : (exemple, entrée, id dans valeurs.csv).
#for (i, cle, id) in (
  ("EX03", "ER", "ER"), ("EX04", "hc", "HC_EVNM"), ("EX07", "ln2", "LN2"), ("EX08", "Rg", "R_J"),
  ("EX13", "k", "NERNST25"), ("EX11", "s", "CO2_SOL"), ("EX12", "pKa", "BICARB_PKA"),
) {
  if float(ex(i).e.at(cle)) != float(_val(id).valeur) {
    panic("FR08 : " + i + "." + cle + " = " + str(ex(i).e.at(cle)) + " ≠ valeurs.csv " + id + " = " + _val(id).valeur)
  }
}
// Rapports saisis à la main : EX10.R = Ab/HA ; EX12.R = résultat calculé d'EX11.
#if calc.abs(ex("EX10").e.R - ex("EX10").e.Ab / ex("EX10").e.HA) > 1e-12 { panic("FR08 : EX10.R ≠ Ab/HA") }
#if calc.abs(ex("EX12").e.R - ex("EX11").calcule) > 1e-12 { panic("FR08 : EX12.R ≠ résultat d'EX11") }
// Signe devant un logarithme fourni en entrée : « = » s'il est exact, « ≈ » sinon.
#let rel-log(id) = {
  let e = ex(id).e
  if calc.abs(calc.log(e.R) - e.L) < 1e-12 { sym.eq } else { sym.approx }
}

#let vsepr = csv("../donnees/vsepr.csv", row-type: dictionary)
#let spectro = csv("../donnees/spectro.csv", row-type: dictionary)
#let nomenclature = csv("../donnees/nomenclature.csv", row-type: dictionary)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Notions fréquentes en PASS/LAS, selon les facultés (vérifiez votre programme) : formules, tableaux, exemples, pièges],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  version: entree("version"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
)

#colonnes(3)[

= Concentrations

#formule[
  $ C = n / V_"solution" quad n = m / M quad C_m = C times M quad C_1 V_1 = C_2 V_2 $
  $C$ en mol/L, $C_m$ en g/L, $M$ en g/mol. _Ex._ #v("EX01", "V2") mL à #v("EX01", "C2") mol/L depuis une solution mère à #v("EX01", "C1") mol/L : $V_1 = #v("EX01", "C2") times #v("EX01", "V2") \/ #v("EX01", "C1") #rel("EX01") #res("EX01")$ mL. Soluté A ($M = #v("EX02", "M")$ g/mol) à #v("EX02", "C") mol/L : $C_m #rel("EX02") #res("EX02")$ g/L.
]

= Atomistique

#formule[
  $ A = Z + N quad E = h nu = (h c) / lambda quad E_n = - #k("ER") thin Z^2 / n^2 "eV" $
  $n >= 1$ ; $ell = 0 ... n - 1$ ; $m_ell = -ell ... + ell$ ; $m_s = plus.minus 1/2$. $E_n$ : hydrogène et ions hydrogénoïdes (modèle de Bohr).
  _Ex._ H, $n = #v("EX03", "n2") -> #v("EX03", "n1")$ : $Delta E #rel("EX03") #res("EX03")$ eV. Photon de #v("EX04", "lam") nm : $E = h c \/ lambda$ avec $h c approx #k("HC_EVNM", u: true)$, soit #res("EX04") eV.
]
*Remplissage* (Klechkowski) : 1s 2s 2p 3s 3p 4s 3d 4p 5s 4d 5p… *Pauli* : jamais deux électrons avec les 4 mêmes nombres quantiques. *Hund* : un maximum d'électrons célibataires dans des orbitales de même énergie. Exceptions : Cr et Cu (sous-couche 3d demi-remplie ou pleine).

Dans une période →, rayon ↓, énergie d'ionisation ↑, électronégativité ↑ ; dans une colonne ↓, l'inverse.

= Liaisons et géométrie

#formule(titre: "Charge formelle")[
  $ "CF" = V - N_"l" - B / 2 $
  $V$ e⁻ de valence, $N_"l"$ e⁻ non liants, $B$ e⁻ liants. _Ex._ N dans NH₄⁺ : $#v("EX14", "V") - #v("EX14", "Nl") - #v("EX14", "B") \/ 2 #rel("EX14") +#res("EX14")$. Meilleure structure de Lewis : charges proches de zéro, charge − sur l'atome le plus électronégatif.
]

#tableau(
  columns: (auto, 1fr, auto, auto),
  align: (left, left, right, left),
  [VSEPR], [Géométrie (ex.)], [Angle], [Hybr.],
  ..vsepr.map(l => (
    l.type, [#l.forme (#l.exemple)],
    [#l.qualificatif#nombre(l.angle)#if l.angle2 != "" [, #nombre(l.angle2)]°],
    l.hybridation,
  )).flatten(),
)
AX#sub[n]E#sub[m] : $n$ atomes liés, $m$ doublets non liants ; $n + m$ domaines. Double liaison = 1 σ + 1 π ; triple = 1 σ + 2 π.

*Interactions faibles*, à taille de molécule comparable : ion–dipôle > liaison hydrogène (H porté par N, O, F) > Van der Waals (Keesom, Debye, London). Plus elles sont fortes, plus la température d'ébullition est haute.

= Thermodynamique

#formule[
  $ Delta_r H° = sum nu thin Delta_f H°_"prod" - sum nu thin Delta_f H°_"réac" $
  $ Delta_r G = Delta_r H - T Delta_r S quad Delta_r G = Delta_r G° + R T ln Q $
  $ Delta_r G° = - R T ln K = - n F E° $
  _Ex._ $Delta_r H° = #v("EX05", "H")$ kJ/mol, $Delta_r S° = #v("EX05", "S")$ J·mol⁻¹·K⁻¹, #v("EX05", "T") K : $Delta_r G° #rel("EX05") #res("EX05")$ kJ/mol. $Delta_r G° < 0$ tant que $T < Delta_r H° \/ Delta_r S° #rel("EX06") #res("EX06")$ K ($Delta_r S°$ en kJ ; $Delta_r H°$, $Delta_r S°$ supposés indépendants de $T$).
]
$Delta_r G < 0$ : évolution spontanée. $Delta_r H < 0$ et $Delta_r S > 0$ : toujours ; $Delta_r H > 0$ et $Delta_r S < 0$ : jamais ; tous deux $< 0$ : à basse $T$ ; tous deux $> 0$ : à haute $T$. À l'équilibre, $Delta_r G = 0$ et $Q = K$.

= Cinétique

#block(breakable: false)[#formule[
  $ v = k [A]^alpha [B]^beta quad k = A thin e^(-E_a \/ R T) $
  $ ln k_2 / k_1 = E_a / R (1 / T_1 - 1 / T_2) $
  $A$ de $k$ : facteur préexponentiel. Ordres partiels $alpha$, $beta$ : expérimentaux ; égaux aux coefficients pour un acte élémentaire, pas en général. _Ex._ $k$ double entre #v("EX08", "T1") et #v("EX08", "T2") K : $E_a #rel("EX08") #res("EX08")$ kJ/mol.
]]
#block(breakable: false)[#tableau(
  columns: (auto, 1fr, auto),
  align: (center, left, left),
  [Ordre], [Loi intégrée (A → produits)], [$t_(1\/2)$],
  [0], [$[A] = [A]_0 - k t$], [$[A]_0 \/ (2 k)$],
  [1], [$ln [A] = ln [A]_0 - k t$], [$#k("LN2") \/ k$],
  [2], [$1 \/ [A] = 1 \/ [A]_0 + k t$], [$1 \/ (k [A]_0)$],
)]
Ordre 1 : $t_(1\/2)$ indépendant de $[A]_0$. _Ex._ principe actif A (valeurs d'exercice), $k = #v("EX07", "k")$ h⁻¹ : $t_(1\/2) #rel("EX07") #res("EX07")$ h. Un catalyseur abaisse $E_a$ sans changer $K$.

= Acides et bases

#formule[
  $ "pH" = -log ["H"_3"O"^+] quad K_e = ["H"_3"O"^+]["HO"^-] $
  $ "p"K_a + "p"K_b = "p"K_e quad "pH" = "p"K_a + log (["A"^-]) / (["AH"]) $
  À #cond("KE") : $K_e = #k("KE")$, $"p"K_e = #k("PKE")$. Acide fort : $"pH" = -log C$. Acide faible peu dissocié ($"pH" < "p"K_a - 1$) : $"pH" = 1/2 ("p"K_a - log C)$.
  _Ex._ $"p"K_a = #v("EX09", "pKa")$, $C = #v("EX09", "R")$ mol/L : pH #rel("EX09") #res("EX09"). Tampon $["A"^-] = #v("EX10", "Ab")$, $["AH"] = #v("EX10", "HA")$ mol/L : pH #rel("EX10") #res("EX10").
]
Tampon efficace dans $"p"K_a plus.minus #k("TAMPON_ECART")$. Titrage d'un acide faible par une base forte : pH = p$K_a$ à la demi-équivalence ; pH > #k("PH_NEUTRE") à l'équivalence. Effet −I d'un substituant : base conjuguée stabilisée, p$K_a$ ↓.

#block(breakable: false)[#note-clinique(titre: "Santé : tampon bicarbonate")[
  $ "pH" = #k("BICARB_PKA") + log ["HCO"_3^-] / (#k("CO2_SOL") times P_a"CO"_2) $
  HCO₃⁻ #v("EX11", "HCO3") mmol/L, PaCO₂ #v("EX11", "PCO2") mmHg : rapport #res("EX11"), $log #v("EX12", "R") #rel-log("EX12") #v("EX12", "L")$, pH #rel("EX12") #res("EX12"). pH du sang : #plage("PH_SANG").
]]

= Oxydoréduction

#formule[
  $ alpha "Ox" + n e^- = beta "Red" quad E = E° + #k("NERNST25") / n log ["Ox"]^alpha / ["Red"]^beta $
  (à #cond("NERNST25") ; $E$ et $E°$ en V) Pile : $Delta E = E_+ - E_-$ ; réduction à la cathode, oxydation à l'anode. _Ex._ $E° = #v("EX13", "Eo")$ V, $n = #v("EX13", "n")$, $["Ox"] \/ ["Red"] = #v("EX13", "R")$ : $E #rel("EX13") #res("EX13")$ V.
]
*Nombres d'oxydation :* somme = charge de l'espèce ; O : −II (sauf peroxydes) ; H : +I (sauf hydrures) ; corps simple : 0. L'oxydant gagne des électrons, son n.o. diminue.

= Chimie organique

#tableau(
  columns: (auto, 1fr, auto, auto),
  align: (center, left, left, left),
  [Rang], [Fonction prioritaire], [Suffixe], [Préfixe],
  ..nomenclature.map(l => (l.rang, l.fonction, l.suffixe, l.prefixe)).flatten(),
)
La fonction de rang le plus élevé donne le suffixe ; les autres passent en préfixe. Alcènes et alcynes gardent leur terminaison #box[(-ène, -yne)] en plus du suffixe.

*R/S :* classer les 4 substituants par numéro atomique au premier point de différence (CIP), le n° 4 vers l'arrière, tourner 1 → 2 → 3 : sens horaire _R_, antihoraire _S_ (inverser si le n° 4 pointe vers l'avant). *Z/E :* sur chaque carbone de la double liaison, le groupe prioritaire (CIP) ; du même côté _Z_, opposés _E_. $n$ centres stéréogènes : au plus $2^n$ stéréoisomères (moins s'il existe un composé méso).

*Effets électroniques :* inductif −I (halogènes, O, N, C=O), +I (alkyles) ; mésomère +M (−OH, −OR, −NH₂, halogènes), −M (C=O, −NO₂, −C≡N). Carbocations : 3° > 2° > 1° > méthyle. Addition de HX sur un alcène (Markovnikov) : H sur le carbone le plus hydrogéné.

#block(breakable: false)[#tableau(
  columns: (auto, 1fr, 1fr),
  align: (left, left, left),
  [], [S#sub[N]1 / E1], [S#sub[N]2 / E2],
  [Substrat], [3°~>~2°], [S#sub[N]2 : CH₃~>~1°~>~2°],
  [Vitesse], [$k$[RX] (ordre 1)], [$k$[RX][Nu⁻ ou B⁻] (ordre 2)],
  [Intermédiaire], [carbocation], [aucun (une étape)],
  [Réactif], [Nu ou base faible], [Nu ou base forte],
  [Solvant], [polaire protique], [S#sub[N]2 : polaire aprotique],
  [Stéréo], [S#sub[N]1 : #box[racémisation] (souvent partielle)], [S#sub[N]2 : inversion (Walden) ; E2 : #box[anti]],
)]
Élimination (E1, E2) : l'alcène le plus substitué est majoritaire (règle de Zaïtsev).

#block(breakable: false)[#note-clinique(titre: "Santé : chiralité")[
  Les récepteurs de l'organisme étant chiraux, deux énantiomères peuvent agir très différemment. Exemple (McMurry) : la fluoxétine, antidépresseur utilisé en racémique. Le racémique est sans effet sur la migraine ; l'énantiomère _S_ pur a été étudié en prévention.
]]

= Spectroscopies

#let ir = spectro.filter(l => l.methode == "IR")
#let rmn = spectro.filter(l => l.methode == "RMN")
#let ligne-spectro(l) = ([#l.groupe#if l.remarque != "" [, #l.remarque]], [#nombre(l.min)–#nombre(l.max)])
#tableau(
  columns: (1fr, auto),
  align: (left, right),
  [Bande IR], [cm⁻¹],
  ..ir.map(ligne-spectro).flatten(),
)
#tableau(
  columns: (1fr, auto),
  align: (left, right),
  [Environnement ¹H (RMN)], [δ (ppm)],
  ..rmn.map(ligne-spectro).flatten(),
)
RMN ¹H : $n$ H voisins équivalents donnent $n + 1$ pics ; l'intégration est proportionnelle au nombre de H.

= Constantes et pièges

Constantes (#jeu("NA")) : $N_A$ = #k("NA", u: true) · $R$ = #k("R_J", u: true) · $F$ = #k("F", u: true) · $h$ = #k("H", u: true) · $c$ = #k("C", u: true) · #cond("T0") = #k("T0", u: true) · $ln 10 approx #k("LN10")$

#block(breakable: false)[#piege[
  - $T$ en kelvins ; $Delta_r S$ souvent en J, $Delta_r H$ en kJ : convertir avant de calculer.
  - pH et Nernst en $log$ ; $Delta_r G° = -R T ln K$ et Arrhenius en $ln$.
  - $"pH" = 1/2 ("p"K_a - log C)$ seulement si l'acide est peu dissocié.
  - Le signe (+) ou (−) du pouvoir rotatoire ne dit rien de _R_ ou _S_.
  - Après une S#sub[N]2, le descripteur _R_/_S_ peut rester le même : il dépend des priorités CIP.
  - Un catalyseur ne change ni $K$ ni $Delta_r G°$ ; seule $T$ change $K$.
]]
]
