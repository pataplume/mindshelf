// Vignette « ce qu'il y a dedans », compilée par scripts/apercus.py.
// Toutes les valeurs arrivent par sys.inputs.donnees (JSON) : dimensions, couleurs, police, graisses, textes,
// et proportions de mise en page (réglages apercu_vignette_* de data/parametres.csv). Aucune valeur de style ici.
// Les textes sont affichés tels quels (aucune interprétation du balisage).
// Si la liste ne tient pas, le texte est réduit par pas jusqu'à d.echelle_min ; au-delà, la compilation échoue.
#let d = json(bytes(sys.inputs.donnees))
#let fond = rgb(d.fond)
#let encre = rgb(d.texte)
#let accent = rgb(d.accent)
#let haut = d.hauteur_pt * 1pt
#let larg = d.largeur_pt * 1pt
#let marge = haut * d.marge
#let utile = haut - 2 * marge

#set page(width: larg, height: haut, margin: marge, fill: fond)
#set text(font: d.police, fill: encre, lang: d.langue)
#set par(leading: d.interligne_em * 1em)

// Colonne de texte à l'échelle e (1 = taille nominale).
#let colonne(e) = {
  set text(size: e * haut / d.texte_diviseur)
  if d.titre != "" {
    block(below: e * haut * d.ecart_titre, text(size: e * haut / d.titre_diviseur, weight: d.graisse_titre, d.titre))
  }
  block(below: e * haut * d.ecart_rubrique,
    text(size: e * haut / d.rubrique_diviseur, weight: d.graisse_rubrique, fill: accent,
      tracking: d.rubrique_approche_em * 1em, upper(d.rubrique)))
  for el in d.elements {
    block(below: e * haut * d.ecart_element, grid(
      columns: (e * haut * d.puce_colonne, 1fr),
      align: left + top,
      move(dy: e * haut * d.puce_decalage, circle(radius: e * haut * d.puce_rayon, fill: accent, stroke: none)),
      el,
    ))
  }
}

// Plus grande échelle (par pas de d.echelle_pas) à laquelle la colonne tient dans la hauteur utile.
#let colonne_ajustee = layout(taille => {
  let n = calc.floor((1 - d.echelle_min) / d.echelle_pas + 1e-9)
  let echelles = range(n + 1).map(i => 1 - i * d.echelle_pas)
  let retenue = none
  for e in echelles {
    if retenue == none and measure(block(width: taille.width, colonne(e))).height <= utile {
      retenue = e
    }
  }
  if retenue == none {
    panic("liste trop longue pour la vignette, même réduite à l'échelle " + str(d.echelle_min)
      + " : raccourcir donnees/contenu.csv")
  }
  align(left + horizon, block(height: utile, align(horizon, colonne(retenue))))
})

// Miniature de la page 1 : le cadre épouse l'image (rapport largeur/hauteur fourni par le script).
#let miniature = layout(taille => {
  let h_img = calc.min(utile, taille.width / d.image_ratio)
  align(center + horizon, box(stroke: d.cadre_trait_pt * 1pt + encre.transparentize(d.cadre_transparence_pct * 1%),
    image(d.image, height: h_img)))
})

#if d.image != none {
  grid(columns: (d.colonne_texte_fr * 1fr, 1fr), column-gutter: marge, rows: utile, colonne_ajustee, miniature)
} else {
  colonne_ajustee
}
