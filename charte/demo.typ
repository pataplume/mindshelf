// Démonstration de la charte : tous les composants sur une page A4.
// Entrées : format (a4 | letter | nb | tablette), langue (en | fr), marque.
// Compilation : voir charte/README.md.
// Contenu illustratif : il montre la mise en page, ce n'est pas un produit.
#import "/charte/modele.typ": *

#let langue = sys.inputs.at("langue", default: "en")
#let fr = langue == "fr"
#let t(en, fr-txt) = if fr { fr-txt } else { en }

#show: fiche.with(
  titre: t("Dosage & IV Drip Rates", "Calculs de doses et débits"),
  sous-titre: t("Charter demo: every component on one sheet", "Démo de la charte : tous les composants sur une fiche"),
  marque: sys.inputs.at("marque", default: t("MindShelf", "Marque FR")),
  langue: langue,
  format: sys.inputs.at("format", default: "a4"),
  mentions: mentions-produit(t("EN01", "FR01"), langue),
  version: "v1",
  numerotation: true,
)

#colonnes(2)[

= #t("Core formulas", "Formules de base")

#formule(titre: t("Desired over have", "Dose prescrite sur dose disponible"))[
  $ V = D / H times Q $
  #t(
    [$D$ ordered dose, $H$ dose on hand, $Q$ volume containing $H$.],
    [$D$ dose prescrite, $H$ dose disponible, $Q$ volume qui contient $H$.],
  )
]

#formule(titre: t("Gravity drip rate", "Débit en gouttes"))[
  $ "gtt/min" = (V_"mL" times "DF"_"gtt/mL") / t_"min" $
]

#formule[
  $ "mL/h" = V_"mL" / t_"h" quad quad 1 "mg" = 1000 "µg" $
]

#exemple(titre: t("Oral suspension", "Suspension buvable"))[
  #t([Ordered 250 mg; on hand 500 mg per 5 mL.], [Prescription 250 mg ; flacon à 500 mg pour 5 mL.])
  $ V = 250 / 500 times 5 = #nombre(2.5) "mL" $
]

#exemple(titre: t("Gravity infusion", "Perfusion par gravité"))[
  #t([1000 mL over 8 h, drop factor 15 gtt/mL.], [1000 mL en 8 h, perfuseur à 15 gouttes/mL.])
  $ (1000 times 15) / 480 = #nombre(31.25) arrow.r.double 31 "gtt/min" $
]

#piege[
  #t(
    [Convert *before* you divide: mixing mg and µg multiplies the error by 1000.],
    [Convertir *avant* de diviser : mélanger mg et µg multiplie l'erreur par 1000.],
  )
]

#piege(titre: t("Rounding", "Arrondi"))[
  #t(
    [Round only the final result, never the intermediate steps.],
    [N'arrondir que le résultat final, jamais les étapes intermédiaires.],
  )
]

= #t("Reference values", "Valeurs de référence")

#tableau(
  columns: (1fr, auto, auto),
  t[Set][Perfuseur], t[Drop factor][Gouttes/mL], t[Typical use][Usage courant],
  t[Macro-drip][Standard], t[10–20 gtt/mL][20], t[Adults, large volumes][Adultes, grands volumes],
  t[Micro-drip][Précision], [60], t[Pediatrics, small volumes][Pédiatrie, petits volumes],
  t[Blood set][Transfusion], t[10–15 gtt/mL][15], t[Blood products][Produits sanguins],
)

== #t("Number formatting", "Format des nombres")

- #t[Helper `nombre()`:][Fonction `nombre()` :] #nombre(1234567.891, decimales: 2)#t[, ][ ; ]#nombre(-0.5)#t[, ][ ; ]#nombre("12500")#t[, ][ ; ]#nombre(4, decimales: 1)
- #t[Tabular figures keep columns aligned.][Chiffres tabulaires : colonnes alignées.]
  - #t[Second-level item.][Élément de second niveau.]

#note-clinique[
  #t(
    [Two independent checks for high-alert drugs (insulin, heparin, potassium).],
    [Double contrôle indépendant pour les médicaments à haut risque (insuline, héparine, potassium).],
  )
]

#encadre(titre: t("Method in 3 steps", "Méthode en 3 étapes"))[
  + #t[Write the formula with units.][Poser la formule avec les unités.]
  + #t[Convert to the same unit.][Convertir dans la même unité.]
  + #t[Check the order of magnitude.][Vérifier l'ordre de grandeur.]
]

=== #t("Level-3 heading", "Intertitre de niveau 3")

#t(
  [Body text in Fira Sans, set ragged-right for narrow columns. A #link("https://example.org")[external link] is underlined; *bold* is semi-bold.],
  [Texte courant en Fira Sans, aligné à gauche pour les colonnes étroites. Un #link("https://example.org")[lien externe] est souligné ; le *gras* est semi-gras.],
)
]

= #t("Three-column block", "Bloc en trois colonnes")

#colonnes(3)[
  #tableau(
    columns: (1fr, 1fr),
    t[Unit][Unité], t[Equals][Vaut],
    [1 g], [1000 mg],
    [1 mg], [1000 µg],
    [1 L], [1000 mL],
    [1 h], [60 min],
  )

  #exemple(titre: t("Weight-based dose", "Dose au poids"))[
    #t([Ordered 15 mg/kg; weight 12 kg.], [Prescription 15 mg/kg ; poids 12 kg.])
    $ 15 times 12 = 180 "mg" $
  ]

  #piege(titre: t("Zeros", "Zéros"))[
    #t(
      [No trailing zero (5.0 mg is misread as 50 mg); always a leading zero (0.5 mg, not .5 mg).],
      [Jamais de zéro final (5,0 mg lu 50 mg) ; toujours un zéro initial (0,5 mg et non ,5 mg).],
    )
  ]
]

= #t("Full-width table", "Tableau pleine largeur")

#tableau(
  columns: (auto, 1fr, auto, auto, 1fr),
  table.header(
    t[Volume][Volume], t[Duration][Durée], [mL/h], t[gtt/min (20)][gouttes/min (20)], t[Comment][Commentaire],
  ),
  [500 mL], [4 h], [125], [42], t[Rounded from 41.7][Arrondi de 41,7],
  [1000 mL], [8 h], [125], [42], t[Same hourly rate][Même débit horaire],
  [250 mL], [30 min], [500], [167], t[Check the pump limit][Vérifier la limite de la pompe],
  [100 mL], [20 min], [300], [100], t[Short infusion][Perfusion courte],
)
