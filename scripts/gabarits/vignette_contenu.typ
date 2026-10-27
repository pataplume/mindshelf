// Vignette « ce qu'il y a dedans », compilée par scripts/apercus.py.
// Toutes les valeurs arrivent par sys.inputs.donnees (JSON) : dimensions, couleurs, police, textes.
// Les textes sont affichés tels quels (aucune interprétation du balisage).
#let d = json(bytes(sys.inputs.donnees))
#let fond = rgb(d.fond)
#let encre = rgb(d.texte)
#let accent = rgb(d.accent)
#let haut = d.hauteur_pt * 1pt
#let larg = d.largeur_pt * 1pt
#let marge = haut * 0.07

#set page(width: larg, height: haut, margin: marge, fill: fond)
#set text(font: d.police, fill: encre, size: haut / 30, lang: d.langue)
#set par(leading: 0.5em)

#let a_image = d.image != none

#let colonne_texte = align(left + horizon)[
  #if d.titre != "" [
    #block(below: haut * 0.035, text(size: haut / 19, weight: "bold", d.titre))
  ]
  #block(below: haut * 0.045, text(size: haut / 28, weight: "semibold", fill: accent, tracking: 0.04em, upper(d.rubrique)))
  #for e in d.elements {
    block(below: haut * 0.026, grid(
      columns: (haut * 0.04, 1fr),
      align: left + top,
      move(dy: haut * 0.011, circle(radius: haut * 0.008, fill: accent, stroke: none)),
      e,
    ))
  }
]

// Miniature de la page 1 : le cadre épouse l'image (rapport largeur/hauteur fourni par le script).
#let miniature = layout(taille => {
  let h_max = haut - 2 * marge
  let h_img = calc.min(h_max, taille.width / d.image_ratio)
  align(center + horizon, box(stroke: 0.6pt + encre.transparentize(80%), image(d.image, height: h_img)))
})

#if a_image {
  grid(
    columns: (1.25fr, 1fr),
    column-gutter: marge,
    rows: haut - 2 * marge,
    colonne_texte,
    miniature,
  )
} else {
  colonne_texte
}
