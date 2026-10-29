// Fiche test du pipeline (run R00) : exerce tous les composants de la charte, en anglais et en français.
// Ce n'est pas un produit : absente de data/produits.csv, jamais publiée.
// Source unique pour les 4 formats et les 2 langues ; tout vient de sys.inputs (contrat : scripts/README-pipeline.md)
// et de ../donnees/exemples.csv. Aucun nombre n'est tapé dans ce fichier : les valeurs affichées sont lues
// dans exemples.csv (entrees_json et resultat_attendu), et chaque résultat est recalculé ici depuis sa formule :
// un écart au-delà de la tolérance fait échouer la compilation.
// Arrondi du résultat affiché : colonnes `arrondi` (décimales) et `mode_arrondi` (code de /data/modes_arrondi.csv :
// au plus proche, par défaut, par excès). Si le résultat arrondi diffère du calcul exact : « exact ⇒ arrondi ».
// Build : python3 scripts/build.py --source produits/_test/src/main.typ --sortie-dir produits/_test/livraison/TEST-EN \
//           --inputs produits/_test/donnees/entrees-en.json      (idem avec entrees-fr.json et TEST-FR)
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("fiche test : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}
#let langue = entree("langue")
#let fr = langue == "fr"
#let t(en, fr-txt) = if fr { fr-txt } else { en }

// ── Données ──
// Modes d'arrondi : code (table) → méthode. Les codes ne sont écrits que dans /data/modes_arrondi.csv.
#let modes_arrondi = {
  let d = (:)
  for l in csv("/data/modes_arrondi.csv", row-type: dictionary) { d.insert(l.code, l.methode) }
  d
}
#let arrondir(x, decimales, code) = {
  if code not in modes_arrondi { panic("fiche test : mode d'arrondi « " + code + " » absent de data/modes_arrondi.csv") }
  let m = modes_arrondi.at(code)
  let f = calc.pow(10, decimales)
  if m == "plus_proche" { calc.round(x, digits: decimales) }
  else if m == "defaut" { calc.floor(x * f) / f }
  else if m == "exces" { calc.ceil(x * f) / f }
  else { panic("fiche test : méthode d'arrondi inconnue : " + m) }
}
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    let attendu = float(l.resultat_attendu)
    if calc.abs(calcule - attendu) > float(l.tolerance) {
      panic("fiche test : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    if l.arrondi.trim() == "" or l.mode_arrondi.trim() == "" {
      panic("fiche test : " + l.id + " : colonnes arrondi et mode_arrondi obligatoires")
    }
    let n = int(l.arrondi)
    d.insert(l.id, l + (e: e, x: attendu, n: n, r: arrondir(attendu, n, l.mode_arrondi.trim())))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("fiche test : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
// Entrée d'un exemple, en chaîne pour que nombre() conserve exactement ses chiffres.
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("fiche test : entrée " + cle + " absente de " + id + " (entrees_json)") }
  nombre(str(e.at(cle)))
}
#let res(id) = nombre(ex(id).resultat_attendu)
// Résultat affiché : exact, ou « exact ⇒ arrondi » quand l'arrondi le change (ex. gouttes entières).
#let aff(id) = {
  let l = ex(id)
  if l.r == l.x { nombre(l.resultat_attendu) } else [#nombre(l.resultat_attendu) ⇒ #nombre(l.r, decimales: l.n)]
}
// Unités : la table donne l'unité canonique ; le français écrit « gouttes/min » (vocabulaire IFSI).
#let unite(u) = if fr and u == "gtt/min" { "gouttes/min" } else { u }
#let u(id) = unite(ex(id).unite)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: t(
    [Pipeline test sheet: every charter component, numbers read from a CSV file],
    [Fiche test du pipeline : tous les composants de la charte, nombres lus dans un fichier CSV],
  ),
  marque: entree("marque"),
  langue: langue,
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), langue),
  version: entree("version"),
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

#formule(titre: t("Gravity drip rate", "Débit en gouttes par minute"))[
  #let debit = t("rate", "débit")
  $ debit = (V times "DF") / (T times M) $
  #t(
    [$V$ volume (mL), $"DF"$ drop factor (gtt/mL), $T$ duration (h), $M$ minutes per hour.],
    [$V$ volume (mL), $"DF"$ facteur de goutte (gouttes/mL), $T$ durée (h), $M$ minutes par heure.],
  )
]

#formule(titre: t("Hourly rate", "Débit horaire"))[
  $ #t("rate", "débit") "(mL/h)" = (V "(mL)") / (T "(h)") $
]

== #t("Worked examples", "Exemples corrigés")

#exemple(titre: t("Oral suspension", "Suspension buvable"))[
  #t(
    [Ordered #v("EX01", "D") mg; on hand #v("EX01", "H") mg per #v("EX01", "Q") mL.],
    [Prescription #v("EX01", "D") mg ; flacon à #v("EX01", "H") mg pour #v("EX01", "Q") mL.],
  )
  $ V = #v("EX01", "D") / #v("EX01", "H") times #v("EX01", "Q") = #res("EX01") "mL" $
]

#exemple(titre: t("Gravity infusion", "Perfusion par gravité"))[
  #t(
    [#v("EX02", "V") mL over #v("EX02", "T") h, drop factor #v("EX02", "DF") gtt/mL.],
    [#v("EX02", "V") mL en #v("EX02", "T") h, perfuseur à #v("EX02", "DF") gouttes/mL.],
  )
  $ (#v("EX02", "V") times #v("EX02", "DF")) / (#v("EX02", "T") times #v("EX02", "M"))
    = #aff("EX02") #u("EX02") $
]

#exemple(titre: t("Weight-based dose", "Dose au poids"))[
  #t(
    [Ordered #v("EX04", "P") mg/kg; weight #v("EX04", "W") kg.],
    [Prescription #v("EX04", "P") mg/kg ; poids #v("EX04", "W") kg.],
  )
  $ #v("EX04", "P") times #v("EX04", "W") = #res("EX04") "mg" $
]

#piege[
  #t(
    [Convert *before* you divide: mg and µg differ by a factor of #v("EX05", "K").],
    [Convertir *avant* de diviser : mg et µg diffèrent d'un facteur #v("EX05", "K").],
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
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  [#t[Case][Cas]], [#t[Formula][Formule]], [#t[Result][Résultat]],
  ..exemples.values().map(l => ([#l.id], [#raw(l.formule)], [#aff(l.id) #unite(l.unite)])).flatten(),
)

== #t("Number formatting", "Format des nombres")

- #t[Thousands:][Milliers :] #v("EX06", "C") µg = #res("EX06") mg
- #t[Decimals:][Décimales :] #v("EX05", "C") mg = #res("EX05") µg
  - #t[Second-level item, rounded with `decimales: 1`:][Élément de second niveau, arrondi avec `decimales: 1` :]
    #nombre(ex("EX03").resultat_attendu, decimales: 1) mL/h

#note-clinique[
  #t(
    [Independent double check for high-alert medications (insulin, heparin, concentrated potassium chloride IV).],
    [Double contrôle indépendant pour les médicaments à haut risque (insuline, héparine, chlorure de potassium concentré IV).],
  )
]

#encadre(titre: t("Method in 3 steps", "Méthode en 3 étapes"))[
  + #t[Write the formula with units.][Poser la formule avec les unités.]
  + #t[Convert to the same unit.][Convertir dans la même unité.]
  + #t[Check the order of magnitude.][Vérifier l'ordre de grandeur.]
]

=== #t("Level-3 heading", "Intertitre de niveau 3")

#t(
  [Body text in Fira Sans. A #link("https://www.bipm.org/en/publications/si-brochure")[external link] is underlined; *bold* is semi-bold.],
  [Texte courant en Fira Sans. Un #link("https://www.bipm.org/fr/publications/si-brochure")[lien externe] est souligné ; le *gras* est semi-gras.],
)
]

= #t("Three-column block", "Bloc en trois colonnes")

#colonnes(3)[
  #exemple(titre: t("Pump rate", "Débit de pompe"))[
    $ (#v("EX03", "V") "mL") / (#v("EX03", "T") "h") = #res("EX03") "mL/h" $
  ]

  #exemple(titre: t("mg to µg", "mg en µg"))[
    $ #v("EX05", "C") "mg" times #v("EX05", "K") = #res("EX05") "µg" $
  ]

  #exemple(titre: t("µg to mg", "µg en mg"))[
    $ (#v("EX06", "C") "µg") / #v("EX06", "K") = #res("EX06") "mg" $
  ]
]
