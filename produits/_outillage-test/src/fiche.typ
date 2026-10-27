// Fiche factice du banc d'essai de l'outillage (scripts/apercus.py, video_feuilletage.py).
// Ce n'est pas un produit : mise en page de démonstration, textes et formules de physique générale.
// Compilation : python3 produits/_outillage-test/prepare.py
#set document(title: "Banc d'essai outillage", author: "MindShelf")
#set page(paper: "a4", margin: (x: 16mm, y: 14mm),
  footer: context [#set text(8pt, fill: luma(90)); Banc d'essai outillage — page #counter(page).display() / #counter(page).final().first()])
#set text(font: "Inter", size: 9.5pt, lang: "en")
#set par(leading: 0.5em)

#let accent = rgb("#2F6F73")
#let encadre(titre, corps) = block(width: 100%, inset: 8pt, radius: 3pt, stroke: 0.7pt + accent, below: 8pt)[
  #text(weight: "bold", fill: accent, titre) \
  #corps
]

#block(width: 100%, inset: (y: 8pt), below: 10pt, stroke: (bottom: 1.5pt + accent))[
  #text(18pt, weight: "bold")[Physics Formula Sheet — TEST BENCH] \
  #text(10pt, fill: luma(70))[Sample layout used only to test preview, video and listing tools]
]

#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  [
    #encadre[1. Kinematics][
      $v = v_0 + a t$ \
      $x = x_0 + v_0 t + 1/2 a t^2$ \
      $v^2 = v_0^2 + 2 a (x - x_0)$
    ]
    #encadre[2. Dynamics][
      $F = m a$ #h(1em) $W = m g$ \
      $f_k = mu_k N$ #h(1em) $p = m v$
    ]
    #encadre[3. Energy][
      $K = 1/2 m v^2$ #h(1em) $U = m g h$ \
      $W = F d cos theta$ #h(1em) $P = W / t$
    ]
  ],
  [
    #encadre[4. Circular motion][
      $a_c = v^2 / r$ #h(1em) $F_c = m v^2 / r$ \
      $omega = 2 pi f$ #h(1em) $T = 1 / f$
    ]
    #encadre[5. Fluids][
      $P = F / A$ #h(1em) $P = P_0 + rho g h$ \
      $A_1 v_1 = A_2 v_2$
    ]
    #encadre[6. Waves][
      $v = f lambda$ #h(1em) $I prop A^2$
    ]
  ],
)

#encadre[Worked example (illustrative)][
  A cart starts from rest with constant acceleration $a$. After time $t$ its speed is $v = a t$ and the distance
  covered is $x = 1/2 a t^2$. #text(fill: luma(80))[(Symbols only: this test sheet carries no numerical data.)]
]

#v(1fr)
#block(width: 100%, inset: 8pt, fill: accent.lighten(88%), radius: 3pt)[
  #text(weight: "bold")[Common pitfalls] \
  Mixing degrees and radians · forgetting the sign of $g$ · adding vectors as scalars.
]

#pagebreak()

#block(width: 100%, inset: (y: 8pt), below: 10pt, stroke: (bottom: 1.5pt + accent))[
  #text(14pt, weight: "bold")[Electricity & Optics — TEST BENCH]
]

#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  [
    #encadre[7. Electrostatics][
      $F = k (q_1 q_2) / r^2$ \
      $E = F / q$ #h(1em) $V = k q / r$
    ]
    #encadre[8. Circuits][
      $V = I R$ #h(1em) $P = I V$ \
      Series: $R = R_1 + R_2$ \
      Parallel: $1/R = 1/R_1 + 1/R_2$
    ]
  ],
  [
    #encadre[9. Optics][
      $n = c / v$ \
      $n_1 sin theta_1 = n_2 sin theta_2$ \
      $1/f = 1/d_o + 1/d_i$
    ]
    #encadre[10. Units][
      #table(columns: 2, stroke: 0.4pt + luma(150), inset: 4pt,
        [*Quantity*], [*SI unit*],
        [Force], [newton (N)],
        [Energy], [joule (J)],
        [Power], [watt (W)],
        [Charge], [coulomb (C)],
      )
    ]
  ],
)

#v(1fr)
#text(8pt, fill: luma(80))[Test bench only. Not a product, not for sale.]
