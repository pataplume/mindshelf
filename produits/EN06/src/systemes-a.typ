// EN06 lot A : systèmes tégumentaire, squelettique, musculaire, nerveux (avec sens spéciaux), endocrinien.
//
// GABARIT COMMUN D'UN SYSTÈME (à suivre aussi par le lot B dans systemes-b.typ) :
//   #import "commun.typ": *                      (en tête du fichier ; un #include n'hérite de rien)
//   = <Name> System                               titre de niveau 1, pleine largeur
//   #colonnes(2)[
//     #structures("<lot>-<systeme>.csv")          tableau « Key structure | Function » (CSV : structure,fonction ;
//                                                 marqueurs {v:CLE} admis, valeurs dans valeurs.csv)
//     === Physiology essentials                   intertitre de niveau 3 (hors sommaire), puis 4 à 6 puces
//     #note-clinique(titre: "<condition>")[…]     une seule « clinical link », courte, sans dose de médicament,
//                                                 terminée par « Source: <organisme>, <page> (<date>). »
//     #piege[…] ×2 ou 3                           pièges d'examen
//   ]
//   Environ une page A4 par système (moins si dense). Uniquement les composants de la charte.
//   Nombres : jamais tapés ici ; k("CLE") lit donnees/valeurs.csv (clés A_ pour ce lot, B_ pour le lot B) ;
//   un nombre calculé passe par donnees/exemples.csv (exemples() le recalcule, concorde() le relie
//   aux valeurs). Après un appel suivi de « ; », écrire \; (règle 16).
// Sources : ../donnees/references.csv.
#import "commun.typ": *

// ── Nombres calculés : recalcul et concordance avec valeurs.csv ──
#let ex-a = exemples("exemples.csv")
#let os = ex-a.at("A_EX01")
#concorde(os, "axial", "A_OS_AXIAL")
#concorde(os, "appendiculaire", "A_OS_APPEND")
#if os.calcule != float(val("A_OS_ADULTE").valeur) { panic("EN06 : A_EX01 ≠ A_OS_ADULTE") }
#let nerfs = ex-a.at("A_EX02")
#for (cle, id) in (("c", "A_NS_C"), ("t", "A_NS_T"), ("l", "A_NS_L"), ("s", "A_NS_S"), ("co", "A_NS_CO")) {
  concorde(nerfs, cle, id)
}
#if nerfs.calcule != float(val("A_NERFS_SPINAUX").valeur) { panic("EN06 : A_EX02 ≠ A_NERFS_SPINAUX") }

// ════════════════════════════════════════════════════════════════════
= Integumentary System

#colonnes(2)[
#structures("a-tegumentaire.csv")

=== Physiology essentials
- *Functions:* barrier against pathogens, injury, heat and light; temperature control; sensation; storage of water and fat; vitamin D; a front line for the immune system.
- *Renewal:* new cells form in the stratum basale and are pushed upward, flattening and dying until they reach the stratum corneum.
- *Pigment:* melanocytes in the basal layer make melanin, which helps protect the DNA of epidermal cells from UV damage.
- *Heat:* evaporating sweat carries heat away; dermal arterioles dilate to shed heat and constrict in the cold to keep it.
- *Vitamin D:* with UV light the epidermis turns a cholesterol derivative into vitamin D#sub[3]\; the liver and kidneys activate it, and it is needed to absorb calcium and phosphorus for bone.
- *Sensation:* Merkel cells and dermal receptors sense touch, temperature and pain; cells around hair follicles sense pressure.

#note-clinique(titre: "Pressure injuries")[
Pressure injuries (bedsores) form when a person stays in one position too long, most often where bone lies close to the skin: heels, hips, ankles, elbows, back. People who are bedridden, use a wheelchair or cannot shift on their own are most at risk. Prevention: keep skin clean and dry, change position about every #k("A_REPOSITIONNEMENT_H", u: true), use pressure-relieving cushions and surfaces.
Source: MedlinePlus, _Pressure Sores_ (updated Dec. 18, 2024).
]

#piege[The epidermis has *no blood vessels*. A scrape that bleeds has reached the dermis.]
#piege[Melanocytes sit in the *stratum basale* of the epidermis, not in the dermis.]
#piege[Deep to surface: basale → spinosum → granulosum → lucidum → corneum. Thin skin has only #k("A_COUCHES_FINE") layers (no lucidum), thick skin #k("A_COUCHES_EPAISSE"). Questions often list them surface first.]
]

// ════════════════════════════════════════════════════════════════════
= Skeletal System

#colonnes(2)[
#structures("a-squelettique.csv")

=== Physiology essentials
- *Functions:* support against gravity; protection of the brain, spinal cord, heart and lungs; levers for movement with the muscles; calcium storage and release; blood cell formation in red marrow.
- *Count:* #k("A_OS_AXIAL") axial + #k("A_OS_APPEND") appendicular = #nombre(os.resultat_attendu) bones in the adult skeleton.
- *Living tissue:* bone needs a blood supply, uses oxygen and nutrients, and remodels under mechanical stress; trabeculae realign when the direction of stress changes.
- *Calcium:* calcium is the most abundant mineral of the matrix. PTH raises blood Ca²⁺ and calcitonin lowers it (see Endocrine System).
- *Remodeling:* osteoblasts lay down bone and osteoclasts resorb it; the balance between them keeps bone mass stable.

#note-clinique(titre: "Osteoporosis")[
Bones weaken and break more easily. It is usually silent until a fracture, most often of the hip, a vertebra or the wrist. Risk rises with female sex (especially after menopause), age over 50, a slim build, family history, long-term use of some medicines such as corticosteroids, smoking, heavy drinking and inactivity. Prevention relies on calcium and vitamin D in the diet and regular physical activity.
Source: MedlinePlus, _Osteoporosis_ (updated Sept. 30, 2025).
]

#piege[*Osteoblasts* build, *osteoclasts* break down, *osteocytes* are the mature cells that stay in the matrix.]
#piege[The pectoral and pelvic *girdles* belong to the appendicular skeleton, not the axial one.]
#piege[Most adult joints are freely movable *synovial* joints; skull sutures are immovable (synarthroses).]
]

// ════════════════════════════════════════════════════════════════════
= Muscular System

#colonnes(2)[
#structures("a-musculaire.csv")

=== Physiology essentials
- *Functions:* movement of bones, organs and vessels; posture; stability of the joints the tendons cross (knee, shoulder); heat, with nearly #k("A_CHALEUR_MUSCLE")% of body heat coming from muscle contraction.
- *Excitation:* a fiber contracts only after a nerve impulse: ACh at the neuromuscular junction → action potential along the membrane and T-tubules → Ca²⁺ release.
- *Cross-bridge cycle:* Ca²⁺ on troponin uncovers actin → myosin heads attach and pull (power stroke) → ATP lets them let go and re-cock → the cycle repeats while Ca²⁺ and ATP last.
- *Relaxation:* ACh release stops, Ca²⁺ is pumped back into the sarcoplasmic reticulum, tropomyosin covers actin again.
- *Energy:* creatine phosphate covers about #k("A_CP_SECONDES", u: true) of work; glycolysis covers short intense bursts; aerobic respiration supplies about #k("A_AEROBIE_PCT")% of the ATP at rest or in moderate activity.

#note-clinique(titre: "Myasthenia gravis")[
An autoimmune disease: antibodies disrupt signal transmission at the neuromuscular junction, so muscles do not get the nerve signal. Weakness of voluntary muscles worsens with activity and improves with rest; drooping eyelids and double vision are often first. Watch chewing and swallowing, and breathing, since chest-wall weakness can impair it.
Source: MedlinePlus Medical Encyclopedia, _Myasthenia gravis_ (reviewed Apr. 16, 2025).
]

#piege[ATP is needed to *release* myosin from actin, not only for the power stroke. No ATP means locked cross-bridges (rigor mortis), not relaxation.]
#piege[During contraction the *sarcomere* shortens; actin and myosin filaments keep their length and slide.]
#piege[Striated does not mean voluntary: cardiac muscle is striated *and* involuntary.]
]

// ════════════════════════════════════════════════════════════════════
= Nervous System and Special Senses

#colonnes(2)[
#structures("a-nerveux.csv")

=== Physiology essentials
- *Three functions:* sensory input from receptors → integration in the brain → motor output to effectors (muscles and glands).
- *Resting potential:* about #k("A_RMP", u: true) inside a typical neuron, kept by the Na⁺/K⁺ pump, which uses ATP.
- *Action potential:* at threshold (about #k("A_SEUIL", u: true)) voltage-gated Na⁺ channels open and Na⁺ rushes in (depolarization); K⁺ then flows out (repolarization).
- *Autonomic transmitters:* preganglionic fibers of both divisions release ACh; most sympathetic postganglionic fibers release norepinephrine; parasympathetic postganglionic fibers release ACh.
- *Repair:* peripheral fibers have a neurilemma that helps them regenerate; CNS fibers lack it and do not regenerate.

#structures("a-sens-speciaux.csv", entete: ([Special sense], [Receptors and pathway]))

#note-clinique(titre: "Stroke")[
Blood flow to part of the brain is lost and brain cells start dying within minutes. About #k("A_AVC_ISCHEMIQUE_PCT")% of strokes are ischemic (a clot); the rest are hemorrhagic (a vessel bursts). Warning signs come on suddenly: numbness or weakness of the face, arm or leg, especially on one side; confusion or trouble speaking; vision loss; trouble walking or balancing; severe headache with no known cause. Call 911 right away: quick treatment can save a life and improve recovery.
Source: MedlinePlus, _Stroke_ (updated July 28, 2025).
]

#piege[The thalamus relays every sense to the cortex *except smell*.]
#piege[Dendrites carry impulses *toward* the cell body; the axon carries them *away*.]
#piege[#k("A_VERT_C") cervical vertebrae but #k("A_NS_C") pairs of cervical nerves: #k("A_NERFS_SPINAUX") spinal nerve pairs in all (#k("A_NS_C") C, #k("A_NS_T") T, #k("A_NS_L") L, #k("A_NS_S") S, #k("A_NS_CO") Co).]
]

// ════════════════════════════════════════════════════════════════════
= Endocrine System

#colonnes(2)[
#structures("a-endocrinien.csv", entete: ([Gland], [Hormones and actions]))

=== Physiology essentials
- *Ductless glands:* hormones go straight into the blood and reach the whole body, but act only on cells that carry a matching receptor.
- *Two chemical classes:* protein-based hormones (most of them) bind surface receptors and act fast; steroids (adrenal cortex, sex hormones) bind receptors inside the cell and act more slowly, through protein synthesis.
- *Control:* negative feedback for most hormones; hormonal stimuli (a tropic hormone from one gland makes another gland secrete); neural stimuli (e.g., sympathetic nerves and the adrenal medulla).
- *Feedback axis:* TRH (hypothalamus) → TSH (anterior pituitary) → thyroid hormones; high thyroid hormone levels lower TRH and TSH.
- *Iodine:* without enough iodine the thyroid cannot make T₄ and T₃ and may enlarge (goiter).

#note-clinique(titre: "Low blood sugar (hypoglycemia)")[
Blood glucose below #k("A_HYPO_MGDL", u: true) (#k("A_HYPO_MMOL", u: true)). In diabetes it can follow too much insulin in the blood, or exercise in people taking insulin or some other diabetes medicines. Signs: shaking, sweating, fast heartbeat, hunger, irritability, headache, blurred vision, unclear thinking; severe episodes cause seizures or loss of consciousness, and some people feel no warning at all. Treatment uses fast sugar (a sugary drink or food, or glucose tablets) per protocol; an episode that does not improve, or a person who becomes less alert, needs emergency care.
Source: MedlinePlus Medical Encyclopedia, _Low blood sugar_ (reviewed Jan. 25, 2026).
]

#piege[ADH and oxytocin are *made in the hypothalamus*; the posterior pituitary only stores and releases them.]
#piege[Ca²⁺: PTH *raises* it, calcitonin *lowers* it. Glucose: glucagon (alpha cells) and cortisol *raise* it, insulin (beta cells) *lowers* it.]
#piege[Steroid hormones act *inside* the cell (slower); protein hormones act on surface receptors (faster).]
]
