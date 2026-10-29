// EN10 : TEAS 7 Science Review Sheets, au plus 6 pages A4 en 2 colonnes.
// Contrat : scripts/README-pipeline.md (titre, marque, version, langue, format, produit arrivent par sys.inputs).
// Aucun nombre affiché n'est tapé ici : exemples chiffrés dans ../donnees/exemples.csv (recalculés à la
// compilation, échec si écart), valeurs de référence dans ../donnees/valeurs.csv, répartition des questions
// dans ../donnees/plan.csv, tableaux de contenu dans les autres CSV de ../donnees/.
// Sources de chaque élément : ../donnees/references.csv.
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN10 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés : recalcul à la compilation ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("EN10 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e, calcule: float(calcule)))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("EN10 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
// Entrée d'un exemple, affichée telle que saisie.
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("EN10 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)).replace("\u{2212}", "-"))
}
// Résultat affiché, arrondi au nombre de décimales de la colonne `arrondi`.
#let res(id) = {
  let l = ex(id)
  if l.arrondi == "" { nombre(l.resultat_attendu) } else { nombre(l.resultat_attendu, decimales: int(l.arrondi)) }
}
// « = » si la valeur affichée est exacte, « ≈ » si elle est arrondie (test sur la valeur recalculée).
#let rel(id) = {
  let l = ex(id)
  if l.arrondi == "" or calc.abs(calc.round(l.calcule, digits: int(l.arrondi)) - l.calcule) < 1e-9 { sym.eq } else { sym.approx }
}

// ── Valeurs de référence ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.id, l) }
  d
}
#let _val(id) = {
  if id not in valeurs { panic("EN10 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
// k("OS_ADULTE") : nombre seul ; k("T_CORPS_C", u: true) : avec son unité.
#let k(id, u: false) = {
  let l = _val(id)
  nombre(l.valeur)
  if u and l.unite != "" [ #l.unite]
}
#let plage(id, u: false) = {
  let l = _val(id)
  [#nombre(l.valeur)–#nombre(l.valeur_max)#if u and l.unite != "" [ #l.unite]]
}
#let cond(id) = {
  let l = _val(id)
  if l.condition == "" { panic("EN10 : valeur " + id + " sans condition") }
  l.condition
}

// ── Tables de contenu ──
#let lire(f) = csv("../donnees/" + f, row-type: dictionary)
#let plan = lire("plan.csv")
#let anatomie = lire("anatomie.csv")
#let comparaisons = lire("comparaisons.csv")
// Questions notées : somme de plan.csv ; total = notées + prétest (valeurs.csv SCI_PRETEST).
#let sci-notees = plan.map(p => int(p.questions)).sum()
#let sci-total = sci-notees + int(_val("SCI_PRETEST").valeur)
// Sous-domaine qui compte le plus de questions notées (ordre de plan.csv).
#let plus-gros = plan.fold(plan.first(), (m, p) => if int(p.questions) > int(m.questions) { p } else { m }).ordre
#let questions(ordre) = {
  let l = plan.filter(p => p.ordre == ordre)
  if l.len() != 1 { panic("EN10 : domaine " + ordre + " absent de plan.csv") }
  nombre(l.first().questions)
}
#let systeme(nom) = {
  let lignes = anatomie.filter(l => l.systeme == nom)
  if lignes.len() == 0 { panic("EN10 : système « " + nom + " » absent de anatomie.csv") }
  tableau(
    columns: (auto, 1fr),
    entete: 0,
    ..lignes.map(l => ([*#l.structure*], l.role)).flatten(),
  )
}
#let critere(nom, c) = {
  let l = comparaisons.filter(l => l.tableau == nom and l.critere == c)
  if l.len() != 1 { panic("EN10 : critère « " + c + " » absent du tableau " + nom + " de comparaisons.csv") }
  l.first()
}
#let compare(nom, a, b) = tableau(
  columns: (auto, 1fr, 1fr),
  [], a, b,
  ..comparaisons.filter(l => l.tableau == nom).map(l => ([*#l.critere*], l.a, l.b)).flatten(),
)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Review of the four TEAS 7 Science sub-areas: anatomy & physiology, biology, chemistry, scientific reasoning],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  version: entree("version"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
)

#colonnes(2)[

= The Science Section at a Glance

#tableau(
  columns: (1fr, auto),
  align: (left, right),
  [Sub-area (ATI TEAS 7 content outline)], [Scored items],
  ..plan.map(l => ([*#l.domaine*: #l.contenu], nombre(l.questions))).flatten(),
)
#nombre(str(sci-notees)) scored items plus #k("SCI_PRETEST") unscored pretest items (#nombre(str(sci-total)) in all) in #k("SCI_MINUTES", u: true). Pretest items are mixed in with the scored ones and do not count, so give every question full effort. These sheets review core facts for each sub-area; they are not a complete course and contain no actual test questions.

= Human Anatomy & Physiology

#if plus-gros == "1" [Largest sub-area: ] #questions("1") scored items.

== Orientation

*Anatomical position:* standing upright, facing forward, arms at the sides, palms forward, feet parallel. *Supine* = lying face up; *prone* = face down. Left and right always mean the _patient's_ left and right.

#tableau(
  columns: (auto, auto, 1fr),
  [Term], [Opposite], [Meaning],
  ..lire("directions.csv").map(l => ([*#l.terme*], l.oppose, l.sens)).flatten(),
)
#tableau(
  columns: (1fr, 1fr),
  [Plane], [Divides the body into],
  ..lire("plans.csv").map(l => ([*#l.plan*], l.divise)).flatten(),
)
*Cavities:* dorsal = cranial (brain) + vertebral (spinal cord); ventral = thoracic (pleural cavities, pericardial cavity, mediastinum) + abdominopelvic, separated by the diaphragm.

*Levels of organization:* chemical → cell → tissue → organ → organ system → organism. Tissue types: epithelial, connective, muscle, nervous.

*Homeostasis:* negative feedback reverses a change (body temperature near #k("T_CORPS_C", u: true) / #k("T_CORPS_F", u: true), blood glucose, blood pH #plage("PH_SANG")); positive feedback amplifies it until an end point (oxytocin in labor, blood clotting).

== Cardiovascular System

#systeme("Cardiovascular")
#k("CAVITES_COEUR") chambers. Blood path: venae cavae → right atrium → tricuspid → right ventricle → pulmonary arteries → lungs → pulmonary veins → left atrium → mitral → left ventricle → aorta → body.

#formule(titre: "Cardiac output")[
  $ "CO" = "HR" times "SV" $
  _E.g._ HR #v("EX31", "HR")/min, SV #v("EX31", "SV") mL: CO $= #v("EX31", "HR") times #v("EX31", "SV")$ mL/min #rel("EX31") #res("EX31") L/min.
]

#tableau(
  columns: (auto, auto, auto, 1fr),
  [Type], [RBC antigens], [Plasma antibodies], [Can receive red cells from (ABO only)],
  ..lire("groupes_sanguins.csv").map(l => ([*#l.groupe*], l.antigenes, l.anticorps, l.recoit)).flatten(),
)
*Rh:* Rh-positive cells carry the D antigen. An Rh-negative person makes anti-D only after exposure (transfusion, pregnancy with an Rh-positive fetus), which can cause hemolytic disease of the newborn in a later pregnancy. *Universal red-cell donor:* O−; *universal recipient:* AB+. An Rh− person should receive Rh− red cells.

== Respiratory System

#systeme("Respiratory")
Right lung #k("LOBES_D", u: true), left lung #k("LOBES_G", u: true) (room for the heart). O₂ and CO₂ move by diffusion, from higher to lower partial pressure.

== Digestive System

#systeme("Digestive")
Order: mouth → pharynx → esophagus → stomach → small intestine → large intestine → rectum → anus. Liver, gallbladder and pancreas are accessory organs: food never passes through them.

== Nervous System

#systeme("Nervous")
PNS: #k("NERFS_CRANIENS", u: true) of cranial nerves, #k("NERFS_SPINAUX", u: true) of spinal nerves; afferent (sensory) toward the CNS, efferent (motor) away from it.

== Muscular & Skeletal Systems

#systeme("Musculoskeletal")
Adult skeleton: #k("OS_ADULTE", u: true). Axial = skull, vertebral column, rib cage; appendicular = limbs and their girdles. Vertebrae: #k("VERT_C") cervical, #k("VERT_T") thoracic, #k("VERT_L") lumbar, then sacrum and coccyx.

== Endocrine System

#systeme("Endocrine")
Most hormone levels are held steady by negative feedback (e.g., high T₄ suppresses TSH). *Endocrine* glands are ductless and release hormones into the blood; *exocrine* glands secrete through ducts (sweat, salivary, the enzyme-secreting part of the pancreas).

== Urinary System

#systeme("Urinary")

== Reproductive System

#systeme("Reproductive")

== Integumentary System

#systeme("Integumentary")

== Immune & Lymphatic Systems

#systeme("Immune & lymphatic")

= Biology

#questions("2") scored items.

== Cells & Organelles

#tableau(
  columns: (auto, 1fr),
  [Structure], [Function],
  ..lire("organites.csv").map(l => ([*#l.organite*], l.role)).flatten(),
)
*Prokaryotes* (bacteria, archaea): no nucleus, no membrane-bound organelles; DNA in a nucleoid; ribosomes present. *Eukaryotes* (animals, plants, fungi, protists): nucleus and organelles.

*Membrane transport.* Passive, no ATP, down the gradient: diffusion, facilitated diffusion, osmosis (water moves toward the higher solute concentration). Active, uses ATP, against the gradient: e.g., the Na⁺/K⁺ pump, endocytosis, exocytosis.

#tableau(
  columns: (auto, 1fr),
  [Cell placed in], [Result],
  ..lire("tonicite.csv").map(l => ([*#l.solution* solution], l.resultat)).flatten(),
)

#let equation(id) = {
  let l = lire("equations.csv").filter(e => e.id == id)
  if l.len() != 1 { panic("EN10 : équation " + id + " absente de equations.csv") }
  l.first().equation
}
#encadre(titre: "Cellular respiration and photosynthesis")[
  *Aerobic respiration:* #equation("RESPIRATION"). Glycolysis (cytoplasm, no O₂ needed) → citric acid (Krebs) cycle (mitochondrial matrix) → electron transport chain (inner mitochondrial membrane; O₂ is the final electron acceptor; makes most of the ATP). Without O₂, cells rely on fermentation (lactic acid in human muscle).

  *Photosynthesis* (chloroplasts): #equation("PHOTOSYNTHESE"). Its products are the reactants of respiration.
]

== Cell Division

*Cell cycle:* interphase (G₁ growth, S DNA replication, G₂ preparation) → mitosis: prophase, metaphase (chromosomes line up), anaphase (sister chromatids separate), telophase (PMAT) → cytokinesis.

#compare("division", [Mitosis], [Meiosis])
Humans: 2n = #k("CHROM_2N") (#k("CHROM_PAIRES", u: true)); a gamete has $n = #v("EX32", "n2") \/ #v("EX32", "d") = #res("EX32")$.

== DNA, RNA & Protein Synthesis

#compare("acides", [DNA], [RNA])
Base pairing: A–T and G–C in DNA; A–U in RNA. DNA replication is semiconservative (each new helix keeps one old strand).

#formule(titre: "Central dogma")[
  DNA → *transcription* (nucleus, RNA polymerase) → mRNA → *translation* (ribosome, tRNA brings amino acids) → protein
]
A *codon* is #k("CODON_BASES", u: true) of mRNA; the tRNA *anticodon* pairs with it. $#v("EX36", "b")^#v("EX36", "n") = #res("EX36")$ codons code for #k("AA", u: true) plus #k("CODONS_STOP") stop codons (UAA, UAG, UGA): the code is redundant. AUG = start (methionine). _E.g._ template DNA TAC CGT → mRNA AUG GCA → Met–Ala.

*Mutations:* substitution (point; may change one amino acid, none, or create a stop codon); insertion or deletion (shifts the reading frame: frameshift).

== Mendelian Genetics

*Allele:* version of a gene. *Genotype* (AA, Aa, aa) vs *phenotype* (observed trait). Homozygous = two identical alleles; heterozygous = two different. *Law of segregation:* allele pairs separate into gametes. *Independent assortment:* genes on different chromosomes sort independently.

// Gamètes des deux parents ; une case réunit un allèle de chaque parent, la majuscule (dominant) en premier.
#let punnett-p1 = ("A", "a")
#let punnett-p2 = ("A", "a")
#let punnett-case(g1, g2) = if g1 == lower(g1) and g2 != lower(g2) { g2 + g1 } else { g1 + g2 }
#exemple(titre: "Punnett square, " + punnett-p1.join() + " × " + punnett-p2.join())[
  #tableau(
    columns: (auto, 1fr, 1fr),
    align: center,
    [], ..punnett-p2.map(g => [*#g*]),
    ..punnett-p1.map(g1 => ([*#g1*], ..punnett-p2.map(g2 => [#punnett-case(g1, g2)]))).flatten(),
  )
  Genotypes AA : Aa : aa = #res("EX11") : #res("EX12") : #res("EX11")\; phenotypes dominant : recessive = #res("EX13") : #res("EX11")\; P(aa) $= #v("EX10", "pa1") times #v("EX10", "pa2")$ = #res("EX10")~%.
  - Test cross Aa × aa: P(aa) $= #v("EX14", "pa1") times #v("EX14", "pa2")$ = #res("EX14")~%.
  - Dihybrid AaBb × AaBb, out of #v("EX15", "n"): #res("EX15") : #res("EX16") : #res("EX16") : #res("EX17") (e.g., both dominant $= #v("EX15", "d1") times #v("EX15", "d2") times #v("EX15", "n") = #res("EX15")$).
]
*Non-Mendelian:* incomplete dominance (blend: red × white → pink); codominance (both expressed: blood type AB); multiple alleles (ABO); X-linked recessive traits (e.g., hemophilia) appear more often in males.

== Macromolecules & Enzymes

#tableau(
  columns: (auto, 1fr, 1fr),
  [Class], [Building block], [Examples / role],
  ..lire("macromolecules.csv").map(l => ([*#l.classe*], l.unite, [#l.exemples. #l.role])).flatten(),
)
Dehydration synthesis joins monomers (releases water); hydrolysis splits them (uses water). *Enzymes* are mostly proteins: they lower activation energy, fit specific substrates at the active site and are not used up; heat and extreme pH denature them.

== Microorganisms & Disease

#tableau(
  columns: (auto, 1fr, 1fr),
  [Group], [Structure], [Examples / treatment],
  ..lire("microbes.csv").map(l => ([*#l.groupe*], l.structure, l.exemples)).flatten(),
)
*Gram stain:* Gram-positive = thick peptidoglycan wall, stains purple; Gram-negative = thin wall plus outer membrane, stains pink.

*Pathogens* cause disease by invading tissue or releasing toxins; normal flora (e.g., gut bacteria) protect the host and help digestion. Hand hygiene breaks the chain of infection between reservoir and susceptible host.

#tableau(
  columns: (auto, 1fr, 0.7fr),
  [Transmission], [How], [Example],
  ..lire("transmission.csv").map(l => ([*#l.mode*], l.description, l.exemple)).flatten(),
)

= Chemistry

#questions("3") scored items.

== Atomic Structure & Periodic Table

#tableau(
  columns: (auto, auto, 1fr),
  [Particle], [Charge], [Location],
  ..lire("particules.csv").map(l => ([*#l.particule*], l.charge, eval(l.emplacement, mode: "markup"))).flatten(),
)
#formule[
  Mass number $A = Z + N$; *isotopes* = same $Z$, different $N$; *ion* = atom that gained (anion, −) or lost (cation, +) electrons.
  _E.g._ carbon-#v("EX25", "A"): $N = #v("EX25", "A") - #v("EX25", "Z") = #res("EX25")$; chlorine-#v("EX26", "A"): $N = #v("EX26", "A") - #v("EX26", "Z") = #res("EX26")$; Na⁺: #v("EX27", "p") protons − #v("EX27", "e") electrons = charge +#res("EX27").
]
*Periodic table:* rows (periods) = number of electron shells; columns (groups) = same valence electrons, similar properties. Metals on the left, nonmetals on the right, metalloids along the staircase; alkali metals (far-left column) are very reactive; noble gases (far-right column) are stable and unreactive. Electronegativity increases toward the upper right (fluorine highest); atomic radius increases toward the lower left.

== Chemical Bonds

#tableau(
  columns: (auto, 1fr, 0.6fr),
  [Bond], [How], [Example],
  ..lire("liaisons.csv").map(l => ([*#l.liaison*], l.mecanisme, l.exemple)).flatten(),
)

== Properties & States of Matter

*Solid:* fixed shape and volume. *Liquid:* fixed volume, takes the container's shape. *Gas:* neither; compressible.

#tableau(
  columns: (1fr, auto, auto, auto),
  [Phase change], [From], [To], [Heat],
  ..lire("phases.csv").map(l => ([*#l.changement*], l.de, l.vers, l.energie)).flatten(),
)
*Density* $= m \/ V$ (a physical property): #v("EX24", "m") g occupying #v("EX24", "V") mL $= #res("EX24")$ g/mL; a less dense object floats on a denser liquid.

*Physical change:* same substance (melting, dissolving, cutting). *Chemical change:* new substance (signs: gas, color change, precipitate, heat or light). Water melts at #k("EAU_FUSION", u: true) and boils at #k("EAU_EBULLITION", u: true) (#cond("EAU_EBULLITION")); ice floats because hydrogen bonding makes it less dense than liquid water; water has a high specific heat, cohesion and adhesion.

#formule(titre: "Gas laws (temperature in kelvins)")[
  $ P_1 V_1 = P_2 V_2 quad V_1 / T_1 = V_2 / T_2 quad P_1 / T_1 = P_2 / T_2 $
  Boyle (constant $T$): pressure up, volume down; this is how breathing moves air. Charles (constant $P$): heat a gas, it expands. Gay-Lussac (constant $V$): heat a gas, its pressure rises. _E.g._ #v("EX37", "V1") L at #v("EX37", "P1") atm squeezed to #v("EX37", "P2") atm: $V_2 = #v("EX37", "P1") times #v("EX37", "V1") \/ #v("EX37", "P2") = #res("EX37")$ L.
]

== Chemical Reactions

#tableau(
  columns: (auto, auto, 1fr),
  [Type], [Pattern], [Example],
  ..lire("reactions.csv").map(l => ([*#l.type*], l.schema, l.exemple)).flatten(),
)
#formule(titre: "Balancing: conservation of mass")[
  Change coefficients only, never subscripts. CH₄ + #v("EX28", "cO2") O₂ → CO₂ + #v("EX29", "cH2O") H₂O: O left $#v("EX28", "cO2") times #v("EX28", "o") = #res("EX28")$, O right $#v("EX29", "oCO2") + #v("EX29", "cH2O") = #res("EX29")$; H right $#v("EX30", "cH2O") times #v("EX30", "h") = #res("EX30")$, as in CH₄.
]
*Faster reactions:* higher temperature, higher concentration, more surface area, a catalyst (lowers activation energy, not consumed). *Exothermic* releases heat; *endothermic* absorbs it. *Le Chatelier:* a system at equilibrium shifts to offset a change in concentration, temperature or pressure.

== Solutions

Solute dissolves in solvent (water: the "universal solvent"); like dissolves like (polar with polar). Unsaturated → saturated → supersaturated. Most solids dissolve better when hot; gases dissolve better when cold and under pressure.

#formule(titre: "Concentration")[
  $ M = "mol solute" / "L solution" quad C_1 V_1 = C_2 V_2 quad "% (m/v)" = "g solute" / (#v("EX23", "c") "mL solution") $
  - NaCl molar mass $#v("EX21", "Na") + #v("EX21", "Cl") = #res("EX21")$ g/mol; #v("EX20", "m") g in #v("EX20", "V") L: $M = #v("EX20", "m") \/ (#v("EX20", "MM") times #v("EX20", "V")) = #res("EX20")$ M.
  - #v("EX22", "V2") mL of #v("EX22", "C2") M from #v("EX22", "C1") M stock: $V_1 = #v("EX22", "C2") times #v("EX22", "V2") \/ #v("EX22", "C1") = #res("EX22")$ mL, then add solvent to #v("EX22", "V2") mL.
  - #v("EX23", "V") mL of #v("EX23", "pct")~% (m/v) glucose holds $#v("EX23", "pct") times #v("EX23", "V") \/ #v("EX23", "c") = #res("EX23")$ g.
  - Moles $n = m \/ M$: H₂O $= #v("EX38", "nH") times #v("EX38", "H") + #v("EX38", "O") #rel("EX38") #res("EX38")$ g/mol; #v("EX39", "m") g of water $#rel("EX39") #res("EX39")$ mol.
]

== Acids & Bases

*Acid:* donates H⁺, pH < #k("PH_NEUTRE"), sour, turns blue litmus red. *Base:* accepts H⁺ (or releases OH⁻), pH > #k("PH_NEUTRE"), bitter, slippery, turns red litmus blue. Neutral = #k("PH_NEUTRE") (#cond("PH_NEUTRE")); scale #plage("PH_MIN").

#formule[
  $ "pH" = -log [H^+] quad "pH" + "pOH" = #k("PKW") quad (#cond("PKW")) $
  Each pH unit is a tenfold change: pH #v("EX18", "pHa") has $#v("EX18", "b")^(#v("EX18", "pHb") - #v("EX18", "pHa")) = #res("EX18")$ times the [H⁺] of pH #v("EX18", "pHb"). At pH #v("EX19", "pH"), pOH $= #v("EX19", "pKw") - #v("EX19", "pH") = #res("EX19")$.
]
Strong acids (HCl) ionize fully; weak acids (acetic, carbonic) only partly. *Buffers* resist pH change: the bicarbonate buffer keeps blood pH at #plage("PH_SANG").

= Scientific Reasoning

#questions("4") scored items.

== Scientific Method

Observation → question → *hypothesis* (testable, falsifiable prediction) → controlled experiment → data analysis → conclusion → repeat and communicate.

#tableau(
  columns: (auto, 1fr),
  [Term], [Meaning],
  ..lire("methode.csv").map(l => ([*#l.terme*], l.sens)).flatten(),
)
*Accuracy* = closeness to the true value; *precision* = closeness of repeated results to each other. More trials and larger samples make results more reliable. Correlation does not prove causation. An *observation* is what you sense or measure; an *inference* is a conclusion drawn from it. Inductive reasoning goes from specific cases to a general rule; deductive reasoning applies a general rule to a specific case.

#formule(titre: "Working with data")[
  - Mean of trials #v("EX34", "a"), #v("EX34", "b"), #v("EX34", "c"): $(#v("EX34", "a") + #v("EX34", "b") + #v("EX34", "c")) \/ #v("EX34", "n") = #res("EX34")$.
  - Slope: #v("EX33", "y1") cm on day #v("EX33", "x1"), #v("EX33", "y2") cm on day #v("EX33", "x2"): $(#v("EX33", "y2") - #v("EX33", "y1")) \/ (#v("EX33", "x2") - #v("EX33", "x1")) = #res("EX33")$ cm/day.
  - Percent error: measured #v("EX35", "m"), accepted #v("EX35", "a"): $abs(#v("EX35", "m") - #v("EX35", "a")) \/ #v("EX35", "a") times #v("EX35", "c") #rel("EX35") #res("EX35")$~%.
]
#encadre(titre: "Judging an investigation")[
  - Only one independent variable should change; everything else stays controlled.
  - Look for a control group, enough subjects and repeated trials.
  - A conclusion must stay within the data: no claims beyond the conditions tested.
  - A hypothesis is supported or not supported, never "proven".
  - Check graphs for title, labeled axes, units and scale before reading a trend.
]
*Graphs:* line = change over time or a continuous variable; bar = compare categories; pie = parts of a whole; scatter = relationship between two variables (positive, negative or none). Interpolation reads between data points; extrapolation goes beyond them (less reliable).

== Measurement & Units

*Tools:* balance (mass), graduated cylinder (volume: read the bottom of the meniscus at eye level), ruler or meter stick (length), thermometer (temperature), pipette (small volumes). *Mass* (kg, same everywhere) is not *weight* (a force that depends on gravity).

#tableau(
  columns: (1fr, auto, auto),
  align: (left, center, right),
  [Prefix], [Symbol], [× base unit],
  ..lire("prefixes.csv").map(l => ([*#l.prefixe*], l.symbole, if l.valeur_id == "" [—] else { k(l.valeur_id) })).flatten(),
)
1 in = #k("IN_CM", u: true) · 1 ft = #k("FT_IN", u: true) · 1 lb ≈ #k("LB_KG", u: true) · 1 kg ≈ #k("KG_LB", u: true) · 1 L = #k("L_ML", u: true) · 1 mL = #k("ML_CM3", u: true)

#formule(titre: "Conversions")[
  - #v("EX01", "L") L = #res("EX01") mL · #v("EX02", "mg") mg = #res("EX02") g · #v("EX03", "mg") mg = #res("EX03") µg · #v("EX04", "km") km = #res("EX04") m
  - #v("EX05", "lb") lb $times$ #v("EX05", "f") #rel("EX05") #res("EX05") kg
  - #v("EX06", "ft") ft #v("EX06", "inch") in $= (#v("EX06", "ft") times #v("EX06", "k") + #v("EX06", "inch"))$ in $times #v("EX06", "f") #rel("EX06") #res("EX06")$ cm
  - $°"C" = (°"F" - #k("F_OFFSET")) \/ #k("F_RATIO")$: #v("EX07", "F") °F #rel("EX07") #res("EX07") °C; $°"F" = #k("F_RATIO") times °"C" + #k("F_OFFSET")$: #v("EX08", "C") °C = #res("EX08") °F
  - $"K" = °"C" + #k("K_OFFSET")$: #v("EX09", "C") °C = #res("EX09") K
]
Moving to a smaller unit gives a bigger number (multiply); moving to a larger unit gives a smaller number (divide).

// Pièges en colonne droite de la dernière page (m10 du rapport v1 : colonne vide).
#colbreak()
= Common Traps

#piege[
  - Pulmonary arteries carry deoxygenated blood and pulmonary veins oxygenated blood: arteries are defined by direction (away from the heart), not by O₂.
  - Tendons join muscle to bone; ligaments join bone to bone.
  - Insulin lowers blood glucose; glucagon raises it. Calcitonin lowers blood Ca²⁺; PTH raises it.
  - Mitosis gives #lower(critere("division", "Daughter cells").a) (diploid); meiosis gives #lower(critere("division", "Daughter cells").b) (haploid).
  - RNA has uracil, not thymine; codons are read on mRNA.
  - Aa × Aa gives a #res("EX13") : #res("EX11") phenotype ratio but a #res("EX11") : #res("EX12") : #res("EX11") genotype ratio.
  - Antibiotics act on bacteria, not on viruses.
  - Lower pH = more acidic; one pH unit = tenfold change in [H⁺].
  - Balance with coefficients, never by changing subscripts.
  - The independent variable is changed; the dependent variable is measured.
  - Precise is not the same as accurate.
  - Supine is face up; prone is face down.
  - Universal red-cell donor is O−, universal recipient AB+: Rh counts as well as ABO.
  - ADH saves water; aldosterone saves sodium (water follows).
  - Food passes through the pharynx but never through the liver or pancreas.
  - Gas-law calculations need kelvins, not degrees Celsius.
]
]
