// Charte MindShelf / marque FR — modèle Typst commun.
// Toutes les valeurs de style sont lues dans /data/charte_tokens.csv :
// ce fichier ne contient que de la logique. Documentation : charte/README.md.

// ───────────────────────── Jetons ─────────────────────────

#let _jetons = {
  let d = (:)
  for r in csv("/data/charte_tokens.csv", row-type: dictionary) {
    d.insert(r.cle, r.valeur)
  }
  d
}

/// Valeur brute (texte) d'un jeton. Échoue bruyamment si la clé manque.
#let jeton(cle) = {
  if cle not in _jetons {
    panic("charte : jeton absent de data/charte_tokens.csv : " + cle)
  }
  _jetons.at(cle)
}

// Jeton interprété comme valeur Typst (longueur, ratio, angle, nombre, booléen).
#let _v(cle) = eval(jeton(cle))

// Jeton caractère : accepte « U+202F » ou le caractère lui-même.
#let _car(cle) = {
  let v = jeton(cle)
  if v.starts-with("U+") { str.from-unicode(eval("0x" + v.slice(2))) } else { v }
}

// Liste séparée par « | ».
#let _liste(cle) = jeton(cle).split("|").map(s => s.trim())

#let _formats = ("a4", "letter", "nb", "tablette")
#let _gabarits = ("fiche", "guide")
#let _langues = ("en", "fr")

// Configuration courante, posée par `fiche` en tête de document.
#let _etat = state("ms-charte", (format: "a4", gabarit: "fiche", langue: "en"))

// Couleur d'un rôle pour un format donné (palette N&B si format « nb »).
#let _couleur(nom, format) = rgb(jeton(
  (if format == "nb" { "couleur-nb." } else { "couleur." }) + nom,
))

/// Couleur d'un rôle de la palette pour le format en cours.
/// À appeler dans un `context` (ex. dessins, schémas).
#let couleur(nom) = _couleur(nom, _etat.get().format)

// Libellé dans la langue du texte courant.
#let _libelle(nom) = jeton(
  "libelle." + nom + "." + (if text.lang == "fr" { "fr" } else { "en" }),
)

// ───────────────────────── Nombres ─────────────────────────

/// Formate un nombre selon la langue courante (séparateurs décimal et
/// milliers, signe moins typographique). `decimales` : none = tel quel,
/// entier = arrondi avec zéros conservés. À utiliser pour tout nombre lu
/// dans un CSV de données.
#let nombre(valeur, decimales: none) = context {
  let lg = if text.lang == "fr" { "fr" } else { "en" }
  let x = if type(valeur) == str { float(valeur.trim().replace(",", ".")) } else { valeur }
  let negatif = x < 0
  let a = calc.abs(x)
  let s = if decimales == none { str(a) } else { str(calc.round(a, digits: decimales)) }
  let parties = s.split(".")
  let ent = parties.at(0)
  let dec = if parties.len() > 1 { parties.at(1) } else { "" }
  if decimales != none and dec.len() < decimales {
    dec = dec + "0" * (decimales - dec.len())
  }
  if ent.len() >= int(jeton("nombre." + lg + ".groupe-min")) {
    let sep = _car("nombre." + lg + ".milliers")
    let groupes = ()
    let reste = ent
    while reste.len() > 3 {
      groupes.insert(0, reste.slice(reste.len() - 3))
      reste = reste.slice(0, reste.len() - 3)
    }
    groupes.insert(0, reste)
    ent = groupes.join(sep)
  }
  let texte = ent + (if dec != "" { _car("nombre." + lg + ".decimale") + dec } else { "" })
  if negatif { texte = _car("nombre.moins") + texte }
  texte
}

// ───────────────────────── Pictogrammes ─────────────────────────

// Icônes d'encadré dessinées en code : la forme porte le sens (cercle coché,
// triangle « ! », carré « + »), la couleur ne fait que la doubler.
#let _icone(forme, fond, trait) = {
  let s = _v("icone.taille")
  let e = _v("icone.trait") * s
  let st = (paint: trait, thickness: e, cap: "round", join: "round")
  box(width: s, height: s, baseline: _v("icone.ligne-de-base"), {
    if forme == "coche" {
      place(circle(radius: s / 2, fill: fond))
      place(curve(
        stroke: st,
        curve.move((0.27 * s, 0.53 * s)),
        curve.line((0.44 * s, 0.69 * s)),
        curve.line((0.74 * s, 0.33 * s)),
      ))
    } else if forme == "alerte" {
      place(polygon(fill: fond, stroke: (paint: fond, thickness: 0.06 * s, join: "round"),
        (0.5 * s, 0.03 * s), (0.99 * s, 0.95 * s), (0.01 * s, 0.95 * s)))
      place(line(start: (0.5 * s, 0.36 * s), end: (0.5 * s, 0.63 * s), stroke: st))
      place(dx: 0.5 * s - e * 0.62, dy: 0.78 * s - e * 0.62, circle(radius: e * 0.62, fill: trait))
    } else if forme == "croix" {
      place(rect(width: s, height: s, radius: _v("rayon.icone"), fill: fond))
      place(line(start: (0.5 * s, 0.24 * s), end: (0.5 * s, 0.76 * s), stroke: st + (thickness: 1.25 * e)))
      place(line(start: (0.24 * s, 0.5 * s), end: (0.76 * s, 0.5 * s), stroke: st + (thickness: 1.25 * e)))
    }
  })
}

// Pictogramme de marque : trois livres sur une étagère, le troisième penché.
#let _picto(format) = {
  let h = _v("logo.hauteur")
  let w = _v("logo.barre.largeur")
  let g = _v("logo.barre.ecart")
  let hs = _liste("logo.barre.hauteurs").map(float)
  let ang = _v("logo.inclinaison")
  let socle = _v("logo.socle")
  let c1 = _couleur("marque", format)
  let c2 = _couleur("marque-accent", format)
  // Le livre penché s'appuie sur le coin du deuxième.
  let ecart3 = hs.at(1) * h * calc.tan(ang) + g
  let largeur = 2 * w + g + ecart3 + w
  box(width: largeur + w * 0.4, height: h + socle, baseline: socle, {
    place(bottom + left, dy: -socle, rect(width: w, height: hs.at(0) * h, fill: c1))
    place(bottom + left, dx: w + g, dy: -socle, rect(width: w, height: hs.at(1) * h, fill: c1))
    place(bottom + left, dx: 2 * w + g + ecart3, dy: -socle,
      rotate(-ang, origin: bottom + left, reflow: false, rect(width: w, height: hs.at(2) * h, fill: c2)))
    place(bottom + left, rect(width: largeur + w * 0.4, height: socle, fill: c1))
  })
}

/// Logo-type : pictogramme + nom de marque. À appeler dans un `context`
/// ou dans un document qui utilise `fiche`.
#let logo(marque) = context {
  let f = _etat.get().format
  set text(size: _v("taille.logo"), weight: _v("graisse.logo"), fill: _couleur("marque", f),
    tracking: _v("logo.interlettre"))
  box(_picto(f))
  h(_v("logo.ecart-nom"))
  marque
}

// ───────────────────────── Encadrés ─────────────────────────

// Barre gauche pleine ou hachurée (le motif reste lisible en N&B).
#let _barre(motif, c) = {
  if motif == "hachure" {
    let pas = _v("hachure.pas")
    let ep = _v("hachure.trait")
    let paint = tiling(size: (pas, pas), {
      place(line(start: (0%, 100%), end: (100%, 0%), stroke: ep + c))
      place(line(start: (-50%, 50%), end: (50%, -50%), stroke: ep + c))
      place(line(start: (50%, 150%), end: (150%, 50%), stroke: ep + c))
    })
    (paint: paint, thickness: _v("trait.barre-motif"))
  } else {
    (paint: c, thickness: _v("trait.barre"))
  }
}

// Ligne d'en-tête d'encadré : icône, libellé en petites capitales, titre.
#let _ligne-libelle(icone, libelle, titre, c-texte) = {
  set text(size: _v("taille.libelle"))
  set par(leading: _v("interligne.tableau"))
  let lib = if libelle == none { none } else {
    let feats = if _v("libelle.petites-capitales") { ("smcp", "c2sc") } else { () }
    text(weight: _v("graisse.libelle"), fill: c-texte, tracking: _v("libelle.interlettre"),
      features: feats, libelle)
  }
  block(sticky: true, below: _v("boite.ecart-libelle"), {
    if icone != none { icone; h(_v("boite.ecart-icone")) }
    lib
    if titre != none {
      if lib != none { h(_v("boite.ecart-titre")) }
      text(weight: _v("graisse.titre"), fill: c-texte, titre)
    }
  })
}

// Encadré à barre gauche commun à formule, exemple, piège et note clinique.
#let _boite(role, forme, cle-libelle, titre, corps) = context {
  let f = _etat.get().format
  let c-trait = _couleur(role + ".trait", f)
  let barre = _barre(jeton("motif." + role), c-trait)
  let icone = if forme == none { none } else { _icone(forme, c-trait, _couleur("sur-fonce", f)) }
  let libelle = if cle-libelle == none { none } else { _libelle(cle-libelle) }
  block(
    width: 100%,
    breakable: true,
    fill: _couleur(role + ".fond", f),
    stroke: (left: barre),
    radius: (right: _v("rayon.boite")),
    inset: (
      left: _v("boite.marge.x") + barre.thickness / 2,
      right: _v("boite.marge.x"),
      y: _v("boite.marge.y"),
    ),
    {
      if icone != none or libelle != none or titre != none {
        _ligne-libelle(icone, libelle, titre, _couleur(role + ".texte", f))
      }
      corps
    },
  )
}

/// Encadré formule. Les équations y sont centrées, chiffres tabulaires.
#let formule(titre: none, corps) = _boite("formule", none, none, titre, {
  set text(number-width: jeton("chiffres.formule"))
  show math.equation.where(block: true): set block(
    above: _v("formule.espace-equation"), below: _v("formule.espace-equation"))
  corps
})

/// Encadré exemple chiffré (icône : cercle coché).
#let exemple(titre: none, corps) = _boite("exemple", "coche", "exemple", titre, corps)

/// Encadré piège (icône : triangle « ! », barre hachurée).
#let piege(titre: none, corps) = _boite("piege", "alerte", "piege", titre, corps)

/// Note clinique (icône : carré « + »).
#let note-clinique(titre: none, corps) = _boite("note", "croix", "note-clinique", titre, corps)

/// Encadré générique à bandeau de titre.
#let encadre(titre: none, corps) = context {
  let f = _etat.get().format
  let mx = _v("boite.marge.x")
  let my = _v("boite.marge.y")
  block(
    width: 100%,
    breakable: true,
    stroke: _v("trait.encadre") + _couleur("encadre.trait", f),
    radius: _v("rayon.encadre"),
    fill: _couleur("encadre.fond", f),
    clip: true,
    {
      if titre != none {
        block(width: 100%, sticky: true, fill: _couleur("encadre.entete", f),
          inset: (x: mx, y: my * 0.75), above: 0pt, below: 0pt,
          text(size: _v("taille.libelle"), weight: _v("graisse.titre"),
            fill: _couleur("encadre.texte", f), titre))
      }
      block(width: 100%, inset: (x: mx, y: my), above: 0pt, below: 0pt, corps)
    },
  )
}

// ───────────────────────── Tableau ─────────────────────────

/// Tableau dense : en-tête teinté répété, lignes alternées, texte condensé,
/// chiffres tabulaires. `entete` : nombre de lignes d'en-tête prises dans
/// les cellules (ignoré si un `table.header` est fourni).
#let tableau(columns: auto, entete: 1, ..args) = context {
  let f = _etat.get().format
  let cellules = args.pos()
  let nommes = args.named()
  let ncol = if type(columns) == int { columns } else if type(columns) == array { columns.len() } else { 1 }
  let a-entete = (cellules.len() > 0 and type(cellules.first()) == content
    and cellules.first().func() == table.header)
  let nent = if a-entete {
    calc.ceil(cellules.first().children.len() / ncol)
  } else if entete > 0 and cellules.len() >= ncol * entete {
    cellules = (table.header(..cellules.slice(0, ncol * entete)),) + cellules.slice(ncol * entete)
    entete
  } else { 0 }
  let c-ent = _couleur("tableau.entete-fond", f)
  let c-zebre = _couleur("tableau.zebre", f)
  let c-trait = _couleur("tableau.entete-trait", f)
  let filet = _v("trait.filet") + _couleur("filet", f)
  set text(size: _v("taille.tableau"), stretch: _v("tableau.etirement"),
    number-width: jeton("chiffres.tableau"))
  set par(leading: _v("interligne.tableau"), justify: false)
  show table.cell: it => if it.y < nent {
    set text(weight: _v("graisse.titre"))
    it
  } else { it }
  table(
    columns: columns,
    inset: (x: _v("tableau.marge.x"), y: _v("tableau.marge.y")),
    align: left + horizon,
    fill: (x, y) => if y < nent { c-ent } else if calc.odd(y - nent) { c-zebre } else { none },
    stroke: (x, y) => if nent > 0 and y == nent - 1 {
      (bottom: _v("trait.tableau-entete") + c-trait)
    } else { none },
    ..nommes,
    ..cellules,
    table.hline(stroke: filet),
  )
}

// ───────────────────────── Colonnes ─────────────────────────

/// Mise en colonnes (gouttière de la charte par défaut).
#let colonnes(n, gouttiere: auto, corps) = columns(
  n,
  gutter: if gouttiere == auto { _v("colonnes.gouttiere") } else { gouttiere },
  corps,
)

// ───────────────────────── Mentions ─────────────────────────

/// Mentions d'un produit, lues dans data/produit_mentions.csv et
/// data/mentions.csv, dans la langue demandée (textes vides ignorés).
#let mentions-produit(code, langue) = {
  let textes = (:)
  for m in csv("/data/mentions.csv", row-type: dictionary) {
    textes.insert(m.code, m.at("texte_" + langue))
  }
  let res = ()
  for pm in csv("/data/produit_mentions.csv", row-type: dictionary) {
    if pm.produit_code == code {
      if pm.mention_code not in textes {
        panic("charte : mention inconnue " + pm.mention_code + " pour " + code)
      }
      let t = textes.at(pm.mention_code)
      if t != "" { res.push(t) }
    }
  }
  if res.len() == 0 { panic("charte : aucune mention trouvée pour " + code) }
  res
}

// ───────────────────────── Typographie ─────────────────────────

// Espaces insécables : nombre + unité ; ponctuation haute en français.
#let _typo(langue, corps) = {
  if not _v("typo.insecables") { return corps }
  show regex("\d [\p{L}µ°]"): it => it.text.replace(" ", _car("nombre.espace-unite"))
  show regex(" [;!?%]"): it => if langue == "fr" { "\u{202F}" + it.text.trim() } else { it }
  show regex(" :"): it => if langue == "fr" { "\u{A0}:" } else { it }
  corps
}

// ───────────────────────── Document ─────────────────────────

/// Gabarit de document. S'utilise en règle show :
/// `#show: fiche.with(titre: "…", …)`.
#let fiche(
  titre: none,
  sous-titre: none,
  marque: "MindShelf",
  langue: "en",
  format: sys.inputs.at("format", default: "a4"),
  mentions: (),
  version: none,
  gabarit: "fiche",
  numerotation: false,
  sommaire: auto,
  corps,
) = {
  if format not in _formats {
    panic("charte : format inconnu « " + str(format) + " » (attendu : " + _formats.join(", ") + ")")
  }
  if langue not in _langues {
    panic("charte : langue inconnue « " + str(langue) + " » (attendu : en, fr)")
  }
  if gabarit not in _gabarits {
    panic("charte : gabarit inconnu « " + str(gabarit) + " » (attendu : fiche, guide)")
  }
  if type(mentions) == str { mentions = (mentions,) }

  let c(nom) = _couleur(nom, format)
  let tablette = format == "tablette"
  let avec-sommaire = if sommaire == auto { tablette } else { sommaire }
  let corps-taille = _v("corps." + gabarit + "." + format)
  let pf = "page." + format + "."
  let polices = (jeton("police.texte"),) + _liste("police.secours")

  set document(title: titre, author: marque)

  // Pied de page : mentions à gauche, marque · version · pagination à droite.
  let pied(pagination) = block(width: 100%, _typo(langue, {
    set text(font: polices, size: corps-taille, lang: langue, hyphenate: false)
    set text(size: _v("taille.pied"), fill: c("encre-douce"))
    set par(leading: _v("interligne.pied"), justify: false, spacing: 0pt)
    line(length: 100%, stroke: _v("trait.filet") + c("filet"))
    v(_v("pied.ecart-filet"), weak: false)
    grid(
      columns: (1fr, auto),
      column-gutter: _v("pied.gouttiere"),
      mentions.join(jeton("pied.separateur")),
      align(right, {
        marque
        if version != none { jeton("pied.separateur") + version }
        jeton("pied.separateur")
        pagination
      }),
    )
  }))

  _etat.update((format: format, gabarit: gabarit, langue: langue))

  context {
    let largeur = _v(pf + "largeur")
    let marge-x = _v(pf + "marge.x")
    let h-pied = measure(pied("99 / 99"), width: largeur - 2 * marge-x).height
    let bas = _v(pf + "marge.bas")
    let haut = _v(pf + "marge.haut")

    set page(
      width: largeur,
      height: _v(pf + "hauteur"),
      margin: (x: marge-x, top: haut, bottom: bas + h-pied + _v("pied.ecart")),
      fill: c("fond-page"),
      header-ascent: _v("page.entete-montee"),
      footer-descent: _v("pied.ecart"),
      header: context {
        if counter(page).get().first() > 1 {
          set text(font: polices, size: corps-taille, lang: langue)
          set text(size: _v("taille.entete-courant"), fill: c("encre-douce"))
          block(width: 100%, stroke: (bottom: _v("trait.entete-courant") + c("filet")),
            inset: (bottom: _v("pied.ecart-filet")), grid(
              columns: (1fr, auto),
              column-gutter: _v("pied.gouttiere"),
              titre,
              if tablette and avec-sommaire {
                link(<ms-sommaire>, text(fill: c("lien"), _libelle("retour-sommaire")))
              } else { marque },
            ))
        }
      },
      footer: pied(context counter(page).display(jeton("pied.numerotation"), both: true)),
    )

    set text(
      font: polices,
      size: corps-taille,
      fill: c("encre"),
      lang: langue,
      region: if langue == "fr" { "FR" } else { "US" },
      hyphenate: _v("cesure"),
    )
    set par(
      leading: _v("interligne." + gabarit),
      spacing: _v("espace.paragraphe." + gabarit),
      justify: _v("paragraphe.justifier"),
    )
    set block(spacing: _v("espace.bloc." + gabarit))
    set strong(delta: int(_v("graisse.gras")) - 400)
    set list(
      marker: (text(fill: c("marque"), jeton("liste.puce1")), text(fill: c("marque"), jeton("liste.puce2"))),
      indent: _v("liste.retrait"),
      body-indent: _v("liste.ecart-puce"),
      spacing: _v("espace.liste." + gabarit),
    )
    set enum(
      numbering: jeton("liste.numerotation"),
      indent: _v("liste.retrait"),
      body-indent: _v("liste.ecart-puce"),
      spacing: _v("espace.liste." + gabarit),
    )
    set math.equation(numbering: none)
    show math.equation: set text(font: jeton("police.math"))
    // Virgule décimale en français : pas d'espace après la virgule en maths.
    show math.equation: it => if langue == "fr" {
      show ",": math.class("normal", ",")
      it
    } else { it }
    show raw: set text(font: jeton("police.mono"), size: _v("taille.mono") / 0.8)
    show link: it => if type(it.dest) == str {
      underline(text(fill: c("lien"), it))
    } else { it }

    show: _typo.with(langue)

    // Titres.
    set heading(numbering: if numerotation { jeton("titre.numerotation") } else { none })
    show heading: set text(weight: _v("graisse.titre"))
    show heading.where(level: 1): it => {
      set text(size: _v("taille.titre1"), fill: c("titre1"))
      block(
        width: 100%,
        sticky: true,
        above: _v("titre1.avant"),
        below: _v("titre1.apres"),
        stroke: (bottom: _v("trait.titre1") + c("titre1")),
        inset: (bottom: _v("titre1.filet-ecart")),
        {
          if it.numbering != none {
            box(fill: c("titre1"), radius: _v("rayon.badge"),
              inset: (x: _v("numero-titre.marge.x"), y: _v("numero-titre.marge.y")),
              text(fill: c("sur-fonce"), number-width: "tabular", counter(heading).display(it.numbering)))
            h(_v("titre1.ecart-numero"))
          }
          it.body
        },
      )
    }
    show heading.where(level: 2): it => {
      set text(size: _v("taille.titre2"), fill: c("titre2"))
      block(sticky: true, above: _v("titre2.avant"), below: _v("titre2.apres"), {
        if it.numbering != none { counter(heading).display(it.numbering); h(_v("titre1.ecart-numero")) }
        it.body
      })
    }
    show heading.where(level: 3): it => {
      set text(size: _v("taille.titre3"), fill: c("titre3"))
      block(sticky: true, above: _v("titre3.avant"), below: _v("titre3.apres"), {
        if it.numbering != none { counter(heading).display(it.numbering); h(_v("titre1.ecart-numero")) }
        it.body
      })
    }

    // En-tête produit (première page).
    block(width: 100%, below: _v("entete.apres"), {
      grid(
        columns: (1fr, auto),
        column-gutter: _v("entete.ecart-colonnes"),
        align: (left + bottom, right + bottom),
        {
          set par(leading: _v("interligne.titre-produit"), spacing: _v("interligne.titre-produit"))
          if titre != none {
            text(size: _v("taille.titre-produit"), weight: _v("graisse.titre-produit"), fill: c("encre"), titre)
          }
          if sous-titre != none {
            parbreak()
            text(size: _v("taille.sous-titre"), fill: c("encre-douce"), sous-titre)
          }
        },
        logo(marque),
      )
      v(_v("entete.ecart-filet"))
      line(length: 100%, stroke: _v("trait.entete") + c("marque"))
    })

    // Sommaire cliquable (tablette par défaut ; sur demande ailleurs).
    if avec-sommaire {
      block(width: 100%, fill: c("sommaire.fond"), inset: _v("sommaire.marge"),
        radius: _v("rayon.encadre"), {
          [#metadata("sommaire") <ms-sommaire>]
          text(weight: _v("graisse.titre"), fill: c("titre1"), _libelle("sommaire"))
          set text(size: _v("taille.sommaire"))
          show outline.entry.where(level: 1): set text(weight: _v("graisse.titre"))
          show outline.entry: set block(spacing: _v("espace.liste." + gabarit))
          columns(int(_v("sommaire.colonnes")), gutter: _v("colonnes.gouttiere"),
            outline(title: none, depth: int(_v("sommaire.profondeur"))))
        })
    }

    corps
  }
}
