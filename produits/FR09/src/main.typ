// FR09 — PASS/LAS Biostatistiques, fiche formules (marché FR). Une page A4 en 3 colonnes.
// Contrat : scripts/README-pipeline.md (titre, marque, version, langue, format, produit arrivent par sys.inputs).
// Aucun nombre de donnée n'est tapé ici :
//   - exemples chiffrés : ../donnees/exemples.csv, chaque résultat recalculé depuis sa formule (échec si écart) ;
//   - valeurs usuelles (z, khi-deux, règle 68-95-99,7, seuils des conditions) : ../donnees/valeurs.csv ;
//   - sous-titre : ../donnees/textes.csv ; libellés de sources : ../donnees/sources.csv ;
//   - justification de chaque élément : ../donnees/references.csv.
// Les entiers propres à l'écriture d'une formule (n - 1, 1 - p, carré, ½…) restent dans les formules.
#import "/charte/modele.typ": *

#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("FR09 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples chiffrés (recalculés) ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("FR09 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e, calcule: calcule))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("FR09 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let v(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("FR09 : entrée " + cle + " absente de " + id) }
  nombre(str(e.at(cle)).replace("\u{2212}", "-"))
}
#let res(id) = nombre(float(ex(id).resultat_attendu), decimales: int(ex(id).arrondi))
#let rel(id) = {
  let x = ex(id).calcule
  if calc.abs(calc.round(x, digits: int(ex(id).arrondi)) - x) < 1e-9 { sym.eq } else { sym.approx }
}

// ── Valeurs usuelles ──
#let valeurs-liste = csv("../donnees/valeurs.csv", row-type: dictionary)
#let valeurs = {
  let d = (:)
  for l in valeurs-liste { d.insert(l.id, l) }
  d
}
#let val(id) = {
  if id not in valeurs { panic("FR09 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
#let q(id) = nombre(val(id).valeur)
#let qf(id) = float(val(id).valeur)
#let groupe(g) = valeurs-liste.filter(l => l.groupe == g).sorted(key: l => int(l.ordre))

#let textes = {
  let d = (:)
  for l in csv("../donnees/textes.csv", row-type: dictionary) { d.insert(l.id, l.texte) }
  d
}
#let texte(id) = {
  if id not in textes { panic("FR09 : texte " + id + " absent de donnees/textes.csv") }
  textes.at(id)
}

// ── Cohérence des tables entre elles (échec de compilation si elles se contredisent) ──
#let verifie(nom, a, b, tol) = if calc.abs(a - b) > tol {
  panic("FR09 : incohérence " + nom + " : " + str(a) + " ≠ " + str(b))
}
#verifie("BX02 m = BX01", float(ex("BX02").e.m), ex("BX01").calcule, 0)
#verifie("BX03 v = BX02", float(ex("BX03").e.v), ex("BX02").calcule, 0)
#for id in ("BX09", "BX10", "BX11", "BX12") { verifie(id + " z = Z95", float(ex(id).e.z), qf("Z95"), 0) }
#verifie("BX07 e^-l", calc.exp(-ex("BX07").e.l), ex("BX07").e.em, 0.000001)
#verifie("BX06 C(n, j)", float(ex("BX06").e.c), float(calc.binom(ex("BX06").e.n, ex("BX06").e.j)), 0)
#verifie("BX06 k = n - j", float(ex("BX06").e.k), float(ex("BX06").e.n - ex("BX06").e.j), 0)
#verifie("BX07 f = k!", float(ex("BX07").e.f), float(calc.fact(ex("BX07").e.k)), 0)
#{
  let e = ex("BX01").e
  let s = (e.x1, e.x2, e.x3, e.x4, e.x5).sorted()
  verifie("BX01 série ordonnée, médiane = x3", float(s.at(2)), float(e.x3), 0)
  verifie("BX01 série ordonnée", if s == (e.x1, e.x2, e.x3, e.x4, e.x5) { 1 } else { 0 }, 1, 0)
}
#verifie("BX15 → BX14 ea", ex("BX15").calcule, float(ex("BX14").e.ea), 0)
#verifie("BX14 eb", float(ex("BX15").e.N - ex("BX15").e.k) * ex("BX15").e.l / ex("BX15").e.N, float(ex("BX14").e.eb), 0)
#verifie("BX15 l = a + b", float(ex("BX15").e.l), float(ex("BX14").e.a + ex("BX14").e.b), 0)
#verifie("BX15 k = a + c", float(ex("BX15").e.k), float(ex("BX14").e.a + ex("BX14").e.c), 0)
#for id in ("BX16", "BX17") {
  for c in ("a", "b", "c", "d") { verifie(id + "." + c, float(ex(id).e.at(c)), float(ex("BX14").e.at(c)), 0) }
}
#verifie("BX19 b = BX18", float(ex("BX19").e.b), ex("BX18").calcule, 0)
#verifie("BX20 r = BX18", float(ex("BX20").e.r), float(ex("BX18").e.r), 0)
// Conditions d'application des exemples : n p et n (1 - p) > seuil ; effectifs attendus ≥ seuil.
#verifie("BX11 conditions", if ex("BX11").e.n * ex("BX11").e.p > qf("COND_IC") and ex("BX11").e.n * (1 - ex("BX11").e.p) > qf("COND_IC") { 1 } else { 0 }, 1, 0)
#verifie("BX14 attendus", if calc.min(ex("BX14").e.ea, ex("BX14").e.eb) >= qf("COND_KHI") { 1 } else { 0 }, 1, 0)

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: texte("SOUS_TITRE"),
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
)

#colonnes(3)[

= Statistique descriptive

#formule[
  Moyenne $overline(x) = (sum x_i) \/ n$ ; médiane : valeur centrale de la série ordonnée ($n$ pair : moyenne des deux valeurs centrales) ; mode : valeur la plus fréquente.
  $ s^2 = (sum (x_i - overline(x))^2) / (n - 1) #h(1em) sigma^2 = (sum (x_i - mu)^2) / N $
  Écart-type $s = sqrt(s^2)$, dans l'unité des données. $s^2$ : estimation à partir d'un échantillon ; $sigma^2$ : population entière.
]

#exemple(titre: "Série " + [#v("BX01", "x1"), #v("BX01", "x2"), #v("BX01", "x3"), #v("BX01", "x4"), #v("BX01", "x5")])[
  $overline(x) = #res("BX01")$ ; $s^2 = #res("BX02")$ ; $s = #res("BX03")$.
  Médiane #v("BX01", "x3") < moyenne : la valeur #v("BX01", "x5") tire la moyenne vers le haut.
]

= Probabilités

#formule[
  $P(overline(A)) = 1 - P(A)$ ; $P(A union B) = P(A) + P(B) - P(A inter B)$.
  $ P(A | B) = P(A inter B) / P(B) #h(1em) P(A inter B) = P(A | B) P(B) $
  Indépendants : $P(A inter B) = P(A) P(B)$, soit $P(A | B) = P(A)$. Incompatibles : $P(A inter B) = 0$.
  Bayes, avec les probabilités totales :
  $ P(A | B) = (P(B | A) P(A)) / (P(B | A) P(A) + P(B | overline(A)) P(overline(A))) $
]

= Tests diagnostiques

#tableau(
  columns: (auto, 1fr, 1fr),
  align: (left, center, center),
  [], [Malades (M)], [Non malades],
  [Test +], [VP], [FP],
  [Test −], [FN], [VN],
)

#formule[
  $"Se" = "VP" \/ ("VP" + "FN")$ ; $"Sp" = "VN" \/ ("VN" + "FP")$.
  $"VPP" = "VP" \/ ("VP" + "FP")$ ; $"VPN" = "VN" \/ ("VN" + "FN")$.
  Par Bayes, avec la prévalence $P$ :
  $ "VPP" = ("Se" P) / ("Se" P + (1 - "Sp")(1 - P)) $
  Se et Sp décrivent le test ; VPP et VPN dépendent aussi de la prévalence.
]

#exemple(titre: "Maladie rare")[
  Se #v("BX04", "se"), Sp #v("BX04", "sp"), $P = #v("BX04", "p")$ (valeurs d'exercice) : VPP #rel("BX04") #res("BX04")~% ; VPN #rel("BX05") #res("BX05")~%. Un test positif reste le plus souvent un faux positif.
]

= Lois de probabilité

#formule[
  Binomiale $cal(B)(n, p)$ : $n$ épreuves indépendantes, deux issues, même $p$.
  $ P(X = k) = binom(n, k) p^k (1 - p)^(n - k) $
  $ E = n p #h(1em) V = n p (1 - p) $
  Poisson $cal(P)(lambda)$ : $P(X = k) = e^(-lambda) lambda^k \/ k!$ ; $E = V = lambda$. Approche $cal(B)(n, p)$ si $n$ grand et $p$ petit, avec $lambda = n p$.
  Normale $cal(N)(mu, sigma^2)$ : $Z = (X - mu) \/ sigma$ suit $cal(N)(0, 1)$.
]

#exemple(titre: "Binomiale, Poisson, centrage")[
  $cal(B)(#v("BX06", "n"), #v("BX06", "p"))$ : $P(X = #v("BX06", "j")) = #v("BX06", "c") times #v("BX06", "p") times (1 - #v("BX06", "p"))^#v("BX06", "k") = #res("BX06")$.
  $cal(P)(#v("BX07", "l"))$ : $P(X = #v("BX07", "k")) = e^(-#v("BX07", "l")) times #v("BX07", "l")^#v("BX07", "k") \/ #v("BX07", "f") #rel("BX07") #res("BX07")$.
  $mu = #v("BX08", "mu")$, $sigma = #v("BX08", "sigma")$, $x = #v("BX08", "x")$ : $z = #res("BX08")$.
]

#tableau(
  columns: (1fr, auto, auto, auto),
  align: (left, right, right, right),
  [Normale], ..groupe("EMP").map(l => [$plus.minus #l.k_sigma sigma$]),
  [Part des valeurs], ..groupe("EMP").map(l => [#nombre(l.valeur)~%]),
)

= Estimation

#formule[
  Erreur standard de la moyenne : $sigma \/ sqrt(n)$ (théorème central limite : $overline(X)$ approximativement normale si $n$ grand).
  IC d'une moyenne, $n$ grand : $overline(x) plus.minus z_(alpha\/2) s \/ sqrt(n)$. Petit $n$ (population normale) : $t$ de Student à $n - 1$ ddl à la place de $z$.
  IC d'une proportion : $p plus.minus z_(alpha\/2) sqrt(p(1 - p) \/ n)$, si $n p$ et $n(1 - p) > #q("COND_IC")$.
]

#exemple(titre: "Intervalles de confiance à 95 %")[
  $overline(x) = #v("BX09", "m")$, $s = #v("BX09", "s")$, $n = #v("BX09", "n")$ : IC $#rel("BX09") [#res("BX09")\; #res("BX10")]$.
  $p = #v("BX11", "p")$, $n = #v("BX11", "n")$ : IC $#rel("BX11") [#res("BX11")\; #res("BX12")]$ (en %).
]

#tableau(
  columns: (1fr, auto, auto),
  align: (left, right, right),
  [Confiance], [$alpha$ bilatéral], [$z_(alpha\/2)$],
  ..groupe("Z").map(l => ([#nombre(str(calc.round((1 - float(l.alpha)) * 100, digits: 0)))~%], [#nombre(l.alpha)], [#nombre(l.valeur)])).flatten(),
)

= Tests d'hypothèse

#formule[
  $H_0$ (pas de différence) contre $H_1$ (uni- ou bilatérale).
  $alpha$ = $P$(rejeter $H_0$ | $H_0$ vraie), risque de 1#super[re] espèce ; $beta$ = $P$(ne pas rejeter $H_0$ | $H_0$ fausse), risque de 2#super[e] espèce ; puissance $1 - beta$.
  $p$ : probabilité, si $H_0$ est vraie, d'un résultat au moins aussi éloigné de $H_0$ que celui observé. $p < alpha$ : rejet de $H_0$.
  Deux moyennes, grands échantillons indépendants :
  $ z = (overline(x)_1 - overline(x)_2) / sqrt(s_1^2 \/ n_1 + s_2^2 \/ n_2) $
]

#exemple(titre: "Deux moyennes")[
  #v("BX13", "m1") ($s = #v("BX13", "s1")$) contre #v("BX13", "m2") ($s = #v("BX13", "s2")$), $n = #v("BX13", "n1")$ par groupe : $z #rel("BX13") #res("BX13") > #q("Z95")$, différence significative à 5 %.
]

= Khi-deux

#formule[
  $ chi^2 = sum (O - E)^2 / E #h(1em) E = (T_l times T_c) / N $
  $O$ observé, $E$ attendu sous $H_0$ (indépendance) ; $T_l$, $T_c$ : totaux de la ligne et de la colonne. ddl $= (l - 1)(c - 1)$ ; chaque $E >= #q("COND_KHI")$.
]

#tableau(
  columns: (1fr, auto, auto),
  align: (left, right, right),
  [Seuil $chi^2$], [ddl], [$alpha$],
  ..groupe("KHI").map(l => ([#nombre(l.valeur)], [#nombre(l.ddl)], [#nombre(l.alpha)])).flatten(),
)

= Corrélation et régression

#formule[
  $r = "cov"(x, y) \/ (s_x s_y)$, $-1 <= r <= 1$ ; $r^2$ : part de la variation de $y$ expliquée par la droite.
  Moindres carrés : $hat(y) = a + b x$, $b = r s_y \/ s_x$, $a = overline(y) - b overline(x)$ ; la droite passe par $(overline(x), overline(y))$.
]

#exemple(titre: "Droite de régression")[
  $r = #v("BX18", "r")$, $s_x = #v("BX18", "sx")$, $s_y = #v("BX18", "sy")$ : $b = #res("BX18")$ ; $overline(x) = #v("BX19", "mx")$, $overline(y) = #v("BX19", "my")$ : $a = #res("BX19")$ ; $r^2 = #res("BX20")$.
]

= Épidémiologie

#formule[
  Incidence cumulée = nouveaux cas / population à risque au début de la période.
  Taux d'incidence = nouveaux cas / somme des personnes-temps.
  Prévalence = cas existants / population, à un instant ou sur une période ; elle dépend de l'incidence et de la durée de la maladie.
]

#tableau(
  columns: (auto, 1fr),
  [Étude], [Principe : mesure],
  [Expérimentale], [exposition attribuée par l'investigateur (essai randomisé), puis suivi],
  [Cohorte], [exposés et non exposés suivis, incidences comparées : RR],
  [Cas-témoins], [malades et témoins, expositions passées comparées : OR],
  [Transversale], [exposition et maladie mesurées en même temps : prévalence],
)

#tableau(
  columns: (1fr, auto, auto),
  align: (left, center, center),
  [], [Malades], [Non malades],
  [Exposés], [$a$ = #v("BX14", "a")], [$b$ = #v("BX14", "b")],
  [Non exposés], [$c$ = #v("BX14", "c")], [$d$ = #v("BX14", "d")],
)

#formule[
  Cohorte : $"RR" = (a \/ (a + b)) \/ (c \/ (c + d))$. Cas-témoins : $"OR" = a d \/ (b c)$, proche du RR si la maladie est rare.
]

#exemple(titre: "Même tableau")[
  $"RR" = #res("BX16")$ ; $"OR" #rel("BX17") #res("BX17")$.
  $E_a = #v("BX15", "l") times #v("BX15", "k") \/ #v("BX15", "N") = #res("BX15")$ ; $chi^2 #rel("BX14") #res("BX14") > #q("KHI1_95")$ (ddl 1) : association significative à 5 %.
]

#piege[
  - Variance d'échantillon : diviser par $n - 1$, pas par $n$.
  - Écart-type (dispersion des données) ≠ erreur standard (précision de la moyenne).
  - Incompatibles ≠ indépendants : deux événements incompatibles de probabilité non nulle sont dépendants.
  - $P(A | B) != P(B | A)$ : Se ≠ VPP.
  - Ne pas rejeter $H_0$ ne prouve pas $H_0$ (puissance).
  - $p$ n'est pas la probabilité que $H_0$ soit vraie.
  - Khi-deux : effectifs, jamais des pourcentages.
  - Corrélation ≠ causalité ; $r$ ne mesure qu'une liaison linéaire.
  - Prévalence (stock) ≠ incidence (flux).
]
]
