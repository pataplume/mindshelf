// EN04 — SPI ultrasound physics, express review sheets, marché EN (US).
// Source unique pour les 4 formats ; tout vient de sys.inputs (contrat : scripts/README-pipeline.md)
// et de ../donnees/*.csv. Aucun nombre de donnée n'est tapé ici :
//   - exemples chiffrés : donnees/exemples.csv, chaque résultat recalculé depuis sa formule (échec si écart) ;
//   - valeurs de référence et limites : donnees/valeurs.csv ;
//   - domaines du plan de contenu SPI : donnees/domaines.csv ; relations « si X double » : donnees/relations.csv ;
//   - artefacts : donnees/artefacts.csv ; sources : donnees/sources.csv et donnees/references.csv.
// Les entiers propres à l'écriture d'une formule (2 de l'aller-retour, 4 de la zone proche, 10 des décibels…)
// restent dans les formules.
// Build : python3 scripts/build.py EN04-STD
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN04 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés (recalculés) ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("EN04 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("EN04 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
// Entrée d'un exemple, en chaîne pour que nombre() conserve exactement ses chiffres.
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("EN04 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)))
}
// Résultat affiché, arrondi au nombre de décimales de la colonne « arrondi ».
#let res(id) = nombre(float(ex(id).resultat_attendu), decimales: int(ex(id).arrondi))
// Signe : « = » si la valeur affichée est exacte, « ≈ » si elle est arrondie.
#let rel(id) = {
  let l = ex(id)
  let x = float(l.resultat_attendu)
  if calc.abs(calc.round(x, digits: int(l.arrondi)) - x) < 0.0000001 { $=$ } else { $approx$ }
}

// ── Valeurs de référence ──
#let valeurs-liste = csv("../donnees/valeurs.csv", row-type: dictionary)
#let valeurs = {
  let d = (:)
  for l in valeurs-liste { d.insert(l.id, l) }
  d
}
#let val(id) = {
  if id not in valeurs { panic("EN04 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
#let q(id) = {
  let l = val(id)
  if l.exposant == "0" { nombre(l.mantisse) } else { $#nombre(l.mantisse) times 10^#nombre(l.exposant)$ }
}
#let qu(id) = if val(id).unite == "" [#q(id)] else if val(id).unite == "%" [#q(id)%] else [#q(id)~#val(id).unite]

// Cohérence des données (échec de compilation si les tables se contredisent).
#let verifie(nom, calcule, attendu, tol) = if calc.abs(calcule - attendu) > tol {
  panic("EN04 : donnée incohérente " + nom + " : " + str(calcule) + " ≠ " + str(attendu))
}
#let c-ms = float(val("P_CTISSUE").mantisse)
#verifie("c mm/µs", c-ms / 1000, float(val("P_CTISSUE_MMUS").mantisse), 0)
#verifie("13 µs/cm", 2 / (c-ms / 10000), float(val("P_13US").mantisse), 0.02)
#verifie("c EX02", float(ex("EX02").e.c), float(val("P_CTISSUE_MMUS").mantisse), 0)
#verifie("c EX06", float(ex("EX06").e.c) * 10, float(val("P_CTISSUE_MMUS").mantisse), 0.0000001)
#verifie("c EX07", float(ex("EX07").e.c) / 100, c-ms, 0)
#verifie("c EX15", float(ex("EX15").e.c), c-ms, 0)
#verifie("a EX09", float(ex("EX09").e.a), float(val("P_ATT").mantisse), 0)
#verifie("Bernoulli K", float(ex("EX18").e.K), float(val("P_BERN_K").mantisse), 0)
#verifie("3 dB", float(ex("EX22").e.db), float(val("P_HALF_DB").mantisse), 0)
#verifie("HVL 3 dB", float(ex("EX10").e.h), float(val("P_HALF_DB").mantisse), 0)

#let domaines = csv("../donnees/domaines.csv", row-type: dictionary).sorted(key: l => int(l.ordre))
#let relations = csv("../donnees/relations.csv", row-type: dictionary).sorted(key: l => int(l.ordre))
#let artefacts = csv("../donnees/artefacts.csv", row-type: dictionary).sorted(key: l => int(l.ordre))

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Formulas, “if X doubles” rules, worked examples and exam traps for SPI exam review],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
)

#encadre(titre: "How these sheets map to the published SPI content outline")[
  #tableau(
    columns: (1fr, auto, 1.4fr),
    align: (left, right, left),
    [Outline domain], [Weight], [Sections here],
    ..domaines.map(l => ([#l.domaine], [#l.poids%], [#l.sections])).flatten(),
  )
  A condensed review aid for the physics side of each domain, not a complete course: patient care, ergonomics,
  3D/4D, contrast agents and infection control are not covered. Exam units: mm, µs, MHz, cm, dB, mW/cm².
]

#colonnes(3)[

= Sound & acoustic parameters

#formule[
  Ultrasound: above #qu("P_ULTRA"). Longitudinal mechanical wave; needs a medium.
  $ T = 1 / f #h(1.2em) lambda = c / f #h(1.2em) c = f lambda $
  $c_"soft tissue" = #qu("P_CTISSUE") = #qu("P_CTISSUE_MMUS")$.
  *Speed depends on the medium only*: stiffer (less compressible) is faster, denser is slower (same stiffness).
  Order: lung/air < fat < soft tissue < muscle < bone.
  Source sets $f$ and $T$; source *and* medium set $lambda$.
  Amplitude, power, intensity: set by the system; $I = P \/ A$, $I prop "amplitude"^2$.
]

#exemple(titre: "5 MHz in soft tissue")[
  $T = 1 \/ #v("EX01", "f") rel("EX01") #res("EX01") "µs"$;
  $lambda = #v("EX02", "c") \/ #v("EX02", "f") rel("EX02") #res("EX02") "mm"$.
  #v("EX27", "P") mW on #v("EX27", "A") cm²: $I = #res("EX27") "mW/cm"^2$.
]

#formule(titre: "Decibels")[
  $ "dB" = 10 log_10 (I_2 / I_1) $
  $+#qu("P_HALF_DB")$: intensity doubled; $-#qu("P_HALF_DB")$: halved; $+#qu("P_TEN_DB")$: ×10.
  Example: #v("EX22", "db") dB $=>$ ratio $10^(#v("EX22", "db") \/ 10) rel("EX22") #res("EX22")$.
]

= Pulsed ultrasound

#formule[
  $ "PD" = n T = n / f #h(1.2em) "SPL" = n lambda $
  $ "PRP" = (2 d) / c #h(1.2em) "PRF" = 1 / "PRP" #h(1.2em) "DF" = "PD" / "PRP" $
  Soft tissue: PRP $approx #qu("P_13US")$ of imaging depth.
  PD and SPL: set by source (cycles, $f$); SPL also by medium. PRP, PRF, DF: change with *depth*
  (sonographer). CW: DF = 100%; imaging DF is tiny.
]

#exemple(titre: "3-cycle pulse, 5 MHz, 10 cm depth")[
  PD $= #v("EX03", "n") \/ #v("EX03", "f") rel("EX03") #res("EX03") "µs"$; SPL $rel("EX04") #res("EX04") "mm"$.
  PRP $= 2 times #v("EX06", "d") \/ #v("EX06", "c") rel("EX06") #res("EX06") "µs"$;
  PRF max $rel("EX07") #res("EX07") "kHz"$; DF $rel("EX08") #res("EX08")%$.
]

= Intensities

#formule[
  SP = spatial peak (beam center), SA = spatial average; TP = temporal peak (pulse on),
  TA = temporal average (includes dead time), PA = pulse average.
  $ "BUF" = "SP" / "SA" >= 1 #h(1.2em) "DF" = "TA" / "TP" <= 1 $
  Highest: SPTP. Lowest: SATA. SPTA: the one tied to *tissue heating*.
  In CW, TA = TP.
]

= Attenuation

#formule[
  Absorption (main cause, energy to heat) + reflection + scattering.
  $ "loss (dB)" approx alpha times f times "path" #h(1em) alpha = #qu("P_ATT") $
  Pulse–echo path = 2 × depth. Half-value layer: $#qu("P_HALF_DB") \/ (alpha f)$.
  Attenuation: lowest in water, then blood, soft tissue, muscle, bone; highest in air/lung.
  Rayleigh scattering (red cells): $prop f^4$.
]

#exemple(titre: "Loss and half-value layer")[
  #v("EX09", "f") MHz, reflector at #v("EX09", "d") cm: $#v("EX09", "a") times #v("EX09", "f") times 2 times #v("EX09", "d") = #res("EX09") "dB"$.
  At #v("EX10", "f") MHz: HVL $= #v("EX10", "h") \/ (#v("EX10", "a") times #v("EX10", "f")) = #res("EX10") "cm"$.
]

= Impedance, reflection & refraction

#formule[
  $ Z = rho c #h(1em) ("rayls") $
  Normal incidence:
  $ "IRC" = ((Z_2 - Z_1) / (Z_2 + Z_1))^2 #h(1em) "ITC" = 1 - "IRC" $
  Reflection needs an impedance *difference*; equal $Z$: no echo.
  Refraction needs *oblique* incidence *and* different speeds:
  $ (sin theta_t) / (sin theta_i) = c_2 / c_1 $
  Specular: smooth surface larger than $lambda$, angle-dependent. Scattering: rough or smaller than $lambda$.
]

#exemple(titre: "Echo and bend")[
  $Z_1 = #v("EX11", "z1")$, $Z_2 = #v("EX11", "z2")$ MRayl (exercise values): IRC $rel("EX11") #res("EX11")%$.
  $sin theta_i = #v("EX12", "s")$, $c_1 = #v("EX12", "c1")$, $c_2 = #v("EX12", "c2") "m/s"$:
  $sin theta_t rel("EX12") #res("EX12")$, bent away from the normal ($c_2 > c_1$).
]

= Resolution

#formule[
  *Axial* (LARRD: longitudinal, axial, range, radial, depth):
  $ "axial" = "SPL" / 2 = (n lambda) / 2 $
  Better (smaller number): higher $f$, fewer cycles (backing). Fixed for a given pulse.
  *Lateral* (LATA) = beam width; best at the focus. Usually worse than axial.
  *Elevational* = slice thickness. *Temporal* = frame rate:
  $ "FR" = c / (2 d N F) $
  $N$ lines per frame, $F$ focal zones: deeper, more lines or more foci lower the frame rate.
]

#exemple(titre: "Axial and frame rate")[
  #v("EX05", "n") cycles at #v("EX05", "f") MHz: axial $= "SPL" \/ 2 rel("EX05") #res("EX05") "mm"$.
  #v("EX14", "d") cm, #v("EX14", "N") lines, #v("EX14", "F") focus: FR $rel("EX14") #res("EX14") "Hz"$.
]

= Transducers

#formule[
  Piezoelectric effect (PZT, lead zirconate titanate): voltage ↔ deformation, both ways.
  Heating above the Curie point depolarizes the element.
  Pulsed frequency: $f = c_"element" \/ (2 "thickness")$; thinner, faster element: higher $f$.
  CW frequency = drive voltage frequency.
  *Matching layer*: $lambda \/ 4$ thick, impedance between element and skin; gel removes air.
  *Backing* (damping): shorter pulse, better axial resolution, wider bandwidth, lower Q factor, lower sensitivity.
  Near zone length:
  $ "NZL" = D^2 / (4 lambda) = (D^2 f) / (4 c) $
  At the end of the near zone, beam width ≈ $D \/ 2$; at 2 NZL, ≈ $D$.
  Arrays: linear (rectangle), curvilinear (blunted sector), phased (sector; electronic steering and focusing),
  annular (focus in 2 planes, mechanical steering).
]

#exemple(titre: "Element and near zone")[
  Exercise values: $c = #v("EX26", "c") "mm/µs"$, $#v("EX26", "t") "mm"$ thick $=> f = #res("EX26") "MHz"$.
  $D = #v("EX13", "D") "mm"$ at #v("EX13", "f") MHz: NZL $rel("EX13") #res("EX13") "mm"$.
]

= Instrumentation & processing

#formule[
  Receiver order: amplification (gain), compensation (TGC), compression, demodulation, reject.
  *Gain* changes received echoes only; *output power* changes the transmitted beam and patient exposure.
  Image too dark: raise gain first (ALARA).
  Pre-processing (before storage, cannot be undone on a frozen image): TGC, write zoom, persistence.
  Post-processing: read zoom, contrast/gray map, measurements on frozen images.
  Dynamic range: ratio largest/smallest signal (dB); compression narrows it.
  Gray shades $= 2^"bits"$: #v("EX23", "b") bits $=> #res("EX23")$.
  Harmonic imaging: receives $2 f_0$; fewer side-lobe and reverberation artifacts.
  Spatial compounding: averaged frames from several angles; less speckle and shadowing.
]

= Doppler

#formule[
  $ Delta f = (2 f_0 v cos theta) / c $
  $cos 0° = 1$ (largest shift); $cos 90° = 0$ (no shift). Shift in the audible range.
  Pulsed wave (PW): range resolution, aliasing possible. Continuous wave (CW): no aliasing, no range resolution.
  Nyquist limit $= "PRF" \/ 2$. Aliasing when $Delta f > "PRF" \/ 2$.
  $ v_max = ("PRF" times c) / (4 f_0 cos theta) $
  Fix aliasing: raise scale (PRF), move the baseline, lower $f_0$, shallower gate, CW.
  Color Doppler: mean velocity, direction, can alias. Power Doppler: amplitude only, no direction,
  no aliasing, more sensitive to slow flow.
  Wall filter removes low-frequency clutter (vessel wall motion).
  Processing: spectral PW and CW use FFT; color uses autocorrelation.
  Color packet (ensemble) size up: more accurate velocities, lower frame rate; a wider color box also lowers the frame rate.
  Velocity error grows fast as the angle widens: keep the angle low and correct for it.
  Tissue Doppler: strong, slow echoes from the myocardium; wall filter minimal.
]

#exemple(titre: "Shift, Nyquist, aliasing")[
  $f_0 = #v("EX15", "f") "kHz"$, #v("EX15", "v") m/s, $cos theta = #v("EX15", "cs")$:
  $Delta f rel("EX15") #res("EX15") "kHz"$.
  PRF #v("EX16", "prf") kHz $=>$ Nyquist $= #res("EX16") "kHz"$:
  #res("EX15") kHz is below #res("EX16") kHz, so no aliasing. Highest velocity before aliasing
  ($f_0$ in Hz, $c$ in m/s): $v_max rel("EX17") #res("EX17") "m/s"$.
]

= Hemodynamics

#formule[
  $ Q = (Delta P) / R #h(1em) R = (8 eta L) / (pi r^4) #h(1em) Q = A v $
  Stenosis: velocity up, pressure down (Bernoulli); flow is conserved.
  Simplified Bernoulli: $Delta P approx #q("P_BERN_K") v^2$ (mmHg, m/s).
  Resistive index: $"RI" = ("PSV" - "EDV") \/ "PSV"$.
  Plug flow: flat profile, narrow spectrum. Laminar (parabolic): center fastest.
  Turbulence: spectral broadening, fills the window.
  High-resistance bed: triphasic waveform; low-resistance bed: forward flow in diastole.
]

#exemple(titre: "Gradient and RI")[
  $v = #v("EX18", "v") "m/s"$: $Delta P = #v("EX18", "K") times #v("EX18", "v")^2 = #res("EX18") "mmHg"$.
  PSV #v("EX19", "ps"), EDV #v("EX19", "ed") cm/s: RI $= #res("EX19")$.
]

]

= Artifacts

#tableau(
  columns: (auto, 1fr, 1fr),
  [Artifact], [Looks like], [Cause],
  ..artefacts.map(l => ([#l.nom], [#l.aspect], [#l.cause])).flatten(),
)

= If X doubles

#tableau(
  columns: (auto, 1fr),
  [If], [Then],
  ..relations.map(l => ([#l.si], [#l.alors])).flatten(),
)

#colonnes(3)[

#exemple(titre: "Speed error")[
  True depth #v("EX20", "d") cm in tissue at #v("EX20", "c") m/s (system assumes #v("EX20", "c0")):
  shown at $#v("EX20", "d") times #v("EX20", "c0") \/ #v("EX20", "c") rel("EX20") #res("EX20") "cm"$ (too deep: slower medium).
]

= Bioeffects & safety

#note-clinique(titre: "ALARA")[
  Use the lowest output and shortest scan time that give a diagnostic image; monitor TI and MI on screen (AIUM).
  - *Thermal*: absorption; TI ≈ estimated maximum temperature rise (°C) under modeled conditions.
    TIS soft tissue, TIB bone at the focus (fetal), TIC cranial bone at the surface.
  - *Mechanical* (cavitation): stable (bubbles oscillate) or transient/inertial (bubbles collapse). Gas bodies (lung, bowel, contrast) are most at risk.
  $ "MI" = p_r / sqrt(f) $
  $p_r$ derated peak rarefactional pressure (MPa), $f$ in MHz.
  US FDA Track 3 limits (non-ophthalmic): derated $I_"SPTA" <= #qu("L_ISPTA")$, MI $<= #qu("L_MI")$.
]

#exemple(titre: "MI")[
  $p_r = #v("EX21", "p") "MPa"$, $f = #v("EX21", "f") "MHz"$: MI $= #v("EX21", "p") \/ sqrt(#v("EX21", "f")) = #res("EX21")$.
]

= Quality assurance

#formule[
  Tissue-mimicking (gray-scale) phantom: axial and lateral resolution, depth (registration) accuracy,
  dead zone, sensitivity and penetration, contrast, cyst imaging.
  Doppler: flow phantom or moving-string phantom (velocity accuracy, gate location).
  Hydrophone: measures output (pressure, intensity).
  $ "Sens" = "TP" / ("TP" + "FN") #h(1em) "Spec" = "TN" / ("TN" + "FP") $
  PPV $= "TP" \/ ("TP" + "FP")$; NPV $= "TN" \/ ("TN" + "FN")$.
]

#exemple(titre: "Test accuracy")[
  TP #v("EX24", "tp"), FN #v("EX24", "fn"), TN #v("EX25", "tn"), FP #v("EX25", "fp"):
  sensitivity $= #res("EX24")%$, specificity $= #res("EX25")%$.
]

#piege[
  - Propagation speed is set by the medium, never by frequency or the sonographer.
  - Axial resolution: *smaller* number = *better*.
  - Lateral resolution is best at the focus, not at the face of the probe.
  - Deeper imaging: lower PRF, lower Nyquist limit, more aliasing.
  - Gain does not change patient exposure; output power does.
  - No refraction at normal incidence, even with different speeds.
  - Doppler at 90°: no shift, not "zero flow".
  - Power Doppler shows no direction and does not alias.
  - Pulse–echo attenuation counts the round trip (2 × depth).
  - Mirror image sits *deeper* than the true structure.
  - Shadowing: high attenuation; enhancement: low attenuation.
  - dB are logarithmic: +#qu("P_HALF_DB") doubles the intensity, it does not add a few percent.
]
]
