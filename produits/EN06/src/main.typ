// EN06 : Anatomy & Physiology — Body Systems Sheets (au plus 10 pages A4, toutes sections comprises).
// Contrat : scripts/README-pipeline.md (titre, marque, version, langue, format, produit arrivent par sys.inputs).
// Structure : introduction ci-dessous, puis lot A (systemes-a.typ) et lot B (systemes-b.typ).
// Fonctions partagées : commun.typ. Sources de chaque élément : ../donnees/references-a.csv (lot A),
// references-b.csv (lot B).
#import "/charte/modele.typ": *
#import "commun.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("EN06 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Structure–function tables, physiology essentials, clinical links and exam traps, system by system],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  version: entree("version"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
)

#colonnes(2)[

= How to Use These Sheets

Every body system follows the same four-part layout:

+ *Key structures → function:* a table that pairs each structure with what it does.
+ *Physiology essentials:* the mechanisms behind the table.
+ *Clinical link:* one condition that shows the physiology at work, with the source it comes from.
+ *Traps:* mix-ups that cost points on exams.

These sheets summarize core facts for review. They are not a full course and do not replace your textbook or your program's materials.

#heading(level: 2)[Levels of organization]
*Cells* (the smallest units that can live and reproduce) → *tissues* (groups of similar cells and the material between them) → *organs* (several tissues working together, e.g., the stomach) → *organ systems* (organs that share a complex job).

#heading(level: 2)[Directions and planes]
#structures("a-orientation.csv", entete: ([Term], [Meaning]))
]

#include "systemes-a.typ"
#include "systemes-b.typ"
