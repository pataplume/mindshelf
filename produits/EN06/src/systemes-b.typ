// EN06 lot B : systèmes cardiovasculaire (avec le sang), lymphatique et immunitaire, respiratoire,
// digestif, urinaire (avec équilibre hydro-électrolytique de base), reproducteur.
// Gabarit commun : commentaire en tête de systemes-a.typ. Nombres : clés B_ de ../donnees/valeurs.csv ;
// exemple calculé : ../donnees/exemples.csv (recalculé, relié aux valeurs par concorde()).
// Sources : ../donnees/references.csv.
#import "commun.typ": *

// ── Nombres calculés : recalcul et concordance avec valeurs.csv ──
#let ex-b = exemples("exemples.csv")
#let pp = ex-b.at("B_EX02")
#concorde(pp, "pas", "B_EX_PAS")
#concorde(pp, "pad", "B_EX_PAD")

// ════════════════════════════════════════════════════════════════════
= Cardiovascular System

#colonnes(2)[
#structures("b-cardiovasculaire.csv")

=== Physiology essentials
- *Route:* body → right atrium → right ventricle → lungs → left atrium → left ventricle → aorta → body. The pulmonary circuit picks up oxygen; the systemic circuit delivers it.
- *Cardiac cycle:* systole = contraction, diastole = relaxation; one cycle lasts about #k("B_CYCLE_S", u: true) at a normal heart rate. Heart sounds come from valves closing; abnormal sounds are murmurs.
- *Output:* a normal adult heart pumps about #k("B_CO_L", u: true) at rest.
- *Blood pressure:* systolic (ventricular contraction) over diastolic (relaxation). It rises with cardiac output, blood volume, peripheral resistance and viscosity.
- *Pulse pressure* = systolic − diastolic. Exercise values: #k("B_EX_PAS")/#k("B_EX_PAD") mm Hg gives #nombre(pp.resultat_attendu) mm Hg.
- *Venous return* relies on skeletal muscle action, breathing movements and venous smooth muscle, not on the push of the ventricles.

#note-clinique(titre: "Heart failure")[
When the heart pumps poorly, fluid builds up: in the lungs (crackles, shortness of breath on exertion or lying down) and in the liver, abdomen, feet and ankles (swelling). Failure can affect the left side, the right side or both.
Source: MedlinePlus, _Heart failure_ (consulted Oct. 29, 2026).
]

#piege[Arteries leave the heart, veins return to it, whatever their oxygen: *pulmonary arteries* carry low-oxygen blood and *pulmonary veins* oxygenated blood.]
#piege[*Tricuspid* on the right, *bicuspid (mitral)* on the left. The semilunar valves sit at the exits (pulmonary, aortic), not between chambers.]
#piege[The SA node sets the rhythm on its own; outside regulating factors only speed it up or slow it down.]
]

// ════════════════════════════════════════════════════════════════════
= Lymphatic & Immune Systems

#colonnes(2)[
#structures("b-lymphatique.csv")

=== Physiology essentials
- *Three jobs of the lymphatic system:* return excess interstitial fluid to the blood; absorb fats and fat-soluble vitamins; defend against microorganisms.
- *Innate immunity:* barriers that act first: skin, mucus, cough reflex, enzymes in tears and skin oils, stomach acid. Inflammation walls off the invader and draws phagocytes.
- *Acquired immunity:* builds up after exposure to a specific *antigen* (usually a protein on a cell, virus or microbe). Vaccines produce it without the infection.
- *Antibodies* bind one specific antigen and make it easier for immune cells to destroy.
- *Passive immunity:* ready-made antibodies, e.g., from mother to fetus across the placenta. Immediate but short: an infant's maternal antibodies disappear between #k("B_AC_MAT_MOIS_MIN") and #k("B_AC_MAT_MOIS_MAX", u: true).

#note-clinique(titre: "Life without a spleen")[
After the spleen is removed, infections become more likely. Immunizations such as pneumococcal, meningococcal, _Haemophilus influenzae_, flu and COVID-19 vaccines are given around the surgery.
Source: MedlinePlus, _Spleen removal_ (consulted Oct. 29, 2026).
]

#piege[*T* cells mature in the *thymus*. Antibodies come from *plasma cells* (activated B cells), not from T cells.]
#piege[Passive immunity is *fast but temporary*; vaccines give lasting *acquired* immunity.]
#piege[Lymph flows *one way*, from the tissues toward the blood. The right lymphatic duct drains only the upper right quadrant; the thoracic duct drains the rest.]
]

// ════════════════════════════════════════════════════════════════════
= Respiratory System

#colonnes(2)[
#structures("b-respiratoire.csv")

=== Physiology essentials
- *Pressure rule:* air flows from higher to lower pressure.
- *Inspiration (active):* the diaphragm contracts, chest volume rises, pressure in the alveoli falls below the atmosphere, air flows in.
- *Expiration at rest:* the diaphragm relaxes and elastic tissue recoils, chest volume falls, air flows out.
- *Rate:* an average adult takes #k("B_FR_MIN")–#k("B_FR_MAX", u: true) at rest.
- *Respiration* is the whole chain of O₂ and CO₂ exchange: ventilation, exchange in the alveoli, transport by the blood, exchange with the tissue cells.

#note-clinique(titre: "Collapsed lung (pneumothorax)")[
Air escapes from the lung into the space between the lung and the chest wall. The trapped air presses on the lung, which can no longer expand fully. Typical signs: sharp chest or shoulder pain made worse by a deep breath or a cough, and shortness of breath.
Source: MedlinePlus, _Collapsed lung (pneumothorax)_ (consulted Oct. 29, 2026).
]

#piege[*Larynx* (voice box, air only, guarded by the epiglottis) vs *pharynx* (throat, shared by air and food).]
#piege[Right lung *#k("B_LOBES_D")* lobes, left lung *#k("B_LOBES_G")*. The trachea splits at the fifth thoracic vertebra.]
#piege[Quiet expiration is passive. Only inspiration needs muscle contraction at rest.]
]

// ════════════════════════════════════════════════════════════════════
= Digestive System

#colonnes(2)[
#structures("b-digestif.csv")

=== Physiology essentials
- *Sequence:* ingestion → mechanical digestion (chewing, mixing) → chemical digestion (enzymes speed up hydrolysis) → absorption → elimination (defecation).
- *Peristalsis* moves food along the whole GI tract.
- *Carbohydrates:* salivary enzyme, then pancreatic amylase and intestinal enzymes. *Proteins:* stomach acid and enzymes, then pancreatic trypsin and peptidases. *Fats:* bile salts emulsify, pancreatic lipase digests.
- *Hormones:* gastrin regulates gastric activity; secretin and CCK, made in the small intestine, control pancreatic secretion.
- *Absorption:* the small intestine absorbs most nutrients; the large intestine takes back more water and electrolytes.

#note-clinique(titre: "Vitamin B₁₂ and intrinsic factor")[
Stomach acid and gastric protease free B₁₂ from food; it binds intrinsic factor from the parietal cells and is absorbed in the distal ileum. Pernicious anemia (autoimmune attack on parietal cells) and surgery that removes part of the stomach can cause deficiency.
Source: NIH Office of Dietary Supplements, _Vitamin B12, Fact Sheet for Health Professionals_ (consulted Oct. 29, 2026).
]

#piege[The *liver makes* bile; the *gallbladder only stores* it. Bile emulsifies fat; the enzyme that digests fat is *lipase*.]
#piege[Most absorption happens in the *small intestine*, not the stomach. The large intestine secretes *no digestive enzymes*.]
]

// ════════════════════════════════════════════════════════════════════
= Urinary System & Fluid Balance

#colonnes(2)[
#structures("b-urinaire.csv")

=== Physiology essentials
- *Main job:* keep the volume and composition of body fluids within normal limits: water excretion, electrolytes, blood pH. The kidneys also secrete erythropoietin (red cell production) and renin (blood pressure).
- *Urine formation:* the glomeruli filter about #k("B_FILTRE_QT", u: true) of blood; the tubules return most of it, so only #k("B_URINE_QT_MIN")–#k("B_URINE_QT_MAX", u: true) becomes urine.
- *ADH* (posterior pituitary): kidney tubules reabsorb *water*.
- *Aldosterone* (adrenal cortex): kidneys reabsorb *sodium and water* and release *potassium*; blood pressure rises.
- *Reference ranges (MedlinePlus):* Na⁺ #k("B_NA_MIN")–#k("B_NA_MAX", u: true), K⁺ #k("B_K_MIN")–#k("B_K_MAX", u: true). Ranges vary slightly among labs: use your program's.

#note-clinique(titre: "High potassium")[
Kidneys that do not work well may fail to remove enough potassium. High potassium decreases heart muscle activity: palpitations, a slow, weak or irregular pulse, and in severe cases cardiac arrest.
Source: MedlinePlus, _High potassium level_ and _Potassium blood test_ (consulted Oct. 29, 2026).
]

#piege[ADH saves *water only*. Aldosterone saves *sodium* (water follows) and gets rid of *potassium*.]
#piege[*Renin* comes from the kidney (juxtaglomerular apparatus); *aldosterone* from the adrenal cortex.]
]

// ════════════════════════════════════════════════════════════════════
= Reproductive System

#colonnes(2)[
#structures("b-reproducteur.csv")

=== Physiology essentials
- *Axis:* hypothalamus (GnRH) → anterior pituitary (FSH, LH) → testes or ovaries.
- *Meiosis:* one primary spermatocyte gives #k("B_SPERMATIDES") spermatids; one primary oocyte gives *one* fertilizable cell, and the polar bodies degenerate.
- *Ovarian cycle:* follicular phase → ovulation (a mid-cycle rise in LH releases the oocyte) → luteal phase. Without fertilization the corpus luteum works about #k("B_CORPS_JAUNE_J", u: true), then regresses.
- *Uterine cycle:* menstrual phase → proliferative phase (endometrium repaired) → secretory phase (glands and blood vessels grow).
- *Menopause:* the cycles stop; changing hormone levels cause its symptoms.

#note-clinique(titre: "Ectopic pregnancy")[
The most common site is the fallopian tube. Risks include tubal birth defects, a previous ectopic pregnancy, scarring from past infections or surgery, and sexually transmitted infections. Rupture causes bleeding and shock: an emergency.
Source: MedlinePlus, _Ectopic pregnancy_ (consulted Oct. 29, 2026).
]

#piege[Sperm are *made* in the seminiferous tubules but *mature* in the epididymis.]
#piege[Ovulation follows the mid-cycle rise in *LH*, not FSH. The corpus luteum secretes *progesterone* (and some estrogen).]
]
