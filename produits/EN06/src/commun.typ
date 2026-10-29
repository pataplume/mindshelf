// EN06 : fonctions partagées par main.typ, systemes-a.typ (lot A) et systemes-b.typ (lot B).
// Un fichier inclus par #include n'hérite pas des définitions de main.typ : chaque fichier de système
// importe donc ce module (#import "commun.typ": *).
// Aucun nombre affiché n'est tapé dans le Typst : valeurs dans ../donnees/valeurs.csv (clés A_… pour le
// lot A, B_… pour le lot B), exemples calculés dans ../donnees/exemples-<lot>.csv (recalculés ici).
#import "/charte/modele.typ": *

#let lire(f) = csv("../donnees/" + f, row-type: dictionary)

// ── Valeurs de référence (fichier partagé) ──
#let valeurs = {
  let d = (:)
  for l in lire("valeurs.csv") {
    if l.id in d { panic("EN06 : valeur " + l.id + " en double dans donnees/valeurs.csv") }
    d.insert(l.id, l)
  }
  d
}
#let val(id) = {
  if id not in valeurs { panic("EN06 : valeur " + id + " absente de donnees/valeurs.csv") }
  valeurs.at(id)
}
// k("A_OS_ADULTE") : nombre seul ; k("A_RMP", u: true) : avec son unité.
#let k(id, u: false) = {
  let l = val(id)
  nombre(l.valeur)
  if u and l.unite != "" [ #l.unite]
}

// ── Marqueurs {v:CLE} dans le texte des tables (même syntaxe que cartes.csv) ──
#let _re-v = regex("\{v:([A-Za-z0-9_]+)\}")
#let remplir(texte) = {
  let morceaux = texte.split(_re-v)
  let marques = texte.matches(_re-v)
  let out = [#morceaux.at(0)]
  for (i, m) in marques.enumerate() {
    out += k(m.captures.at(0)) + [#morceaux.at(i + 1)]
  }
  out
}

// ── Exemples calculés : recalcul à la compilation, échec si écart ──
// Colonnes : id, enonce, entrees_json, formule, resultat_attendu, unite, tolerance, arrondi, mode_arrondi.
#let exemples(f) = {
  let d = (:)
  for l in lire(f) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    if calc.abs(calcule - float(l.resultat_attendu)) > float(l.tolerance) {
      panic("EN06 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    d.insert(l.id, l + (e: e, calcule: float(calcule)))
  }
  d
}
// Vérifie qu'une entrée d'exemple et une valeur de valeurs.csv disent la même chose.
#let concorde(ex, cle-entree, id-valeur) = {
  if cle-entree not in ex.e { panic("EN06 : entrée " + cle-entree + " absente de " + ex.id) }
  if float(ex.e.at(cle-entree)) != float(val(id-valeur).valeur) {
    panic("EN06 : " + ex.id + "." + cle-entree + " diffère de valeurs.csv " + id-valeur)
  }
}

// ── Gabarit commun d'un système ──
// Tableau « Key structures → function » lu depuis un CSV à deux colonnes : structure, fonction.
// Le texte des cellules peut contenir des marqueurs {v:CLE}.
#let structures(f, entete: ([Key structure], [Function])) = {
  let lignes = lire(f)
  if lignes.len() == 0 { panic("EN06 : table " + f + " vide") }
  tableau(
    columns: (auto, 1fr),
    ..entete,
    ..lignes.map(l => ([*#remplir(l.structure)*], remplir(l.fonction))).flatten(),
  )
}
