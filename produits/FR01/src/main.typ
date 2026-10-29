// FR01 : Calculs de doses et débits — fiche méthode (marché FR, marque Clairance). Fiche d'une page, risque IA FORT :
// méthode rédigée par l'agent (methode_auteur = AGENT), brouillon soumis à relecture infirmière
// (donnees/statut-methode.md), Whop uniquement, jamais Etsy. Adaptée de EN01 v3 (pas une traduction).
// Contrat : titre, marque, version, langue, format, variante, référentiel et mentions arrivent par sys.inputs.
// Aucun nombre n'est tapé ici : exemples (donnees/exemples.csv, recalculés ci-dessous, échec si écart),
// constantes (donnees/valeurs.csv), ligne d'UE propre à la variante (donnees/variantes.csv).
// Règle d'arrondi unique : la colonne `arrondi` donne les décimales de la seule valeur réglée ou prélevée ;
// si le calcul exact diffère, on affiche « exact ⇒ réglable ». Poids, concentrations, intermédiaires : jamais arrondis.
#import "/charte/modele.typ": *

// ── Contrat sys.inputs ──
#let entree(cle) = {
  let v = sys.inputs.at(cle, default: "")
  if v == "" { panic("FR01 : entrée sys.inputs « " + cle + " » absente (scripts/build.py la fournit)") }
  v
}

// ── Exemples : recalcul de chaque résultat ──
#let exemples = {
  let d = (:)
  for l in csv("../donnees/exemples.csv", row-type: dictionary) {
    let e = json(bytes(l.entrees_json))
    let calcule = eval(l.formule, scope: e)
    let attendu = float(l.resultat_attendu)
    if calc.abs(calcule - attendu) > float(l.tolerance) {
      panic("FR01 : " + l.id + " : " + l.formule + " = " + str(calcule) + ", attendu " + l.resultat_attendu)
    }
    if l.arrondi.trim() == "" { panic("FR01 : " + l.id + " : colonne arrondi vide") }
    d.insert(l.id, l + (e: e, x: attendu, n: int(l.arrondi)))
  }
  d
}
#let ex(id) = {
  if id not in exemples { panic("FR01 : exemple " + id + " absent de donnees/exemples.csv") }
  exemples.at(id)
}
#let brut(id, cle) = {
  let e = ex(id).e
  if cle not in e { panic("FR01 : entrée " + cle + " absente de " + id + " (entrees_json)") }
  e.at(cle)
}
// Entrée affichée (chaîne : nombre() conserve les chiffres, virgule décimale, jamais de zéro final).
#let v(id, cle) = nombre(str(brut(id, cle)))
// Résultat : « = 125 mL/h » si exact au pas réglable, sinon « ≈ 41,67 ⇒ 42 gouttes/min » (réglable en gras).
#let res(id, unite: auto) = {
  let l = ex(id)
  let un = if unite == auto { l.unite } else { unite }
  let r = calc.round(l.x, digits: l.n)
  if r == l.x { [#sym.eq #nombre(str(r))#sym.space.nobreak#un] } else {
    let montre = calc.round(l.x, digits: l.n + 2)
    let rel = if montre == l.x { "=" } else { sym.approx }
    [#rel #nombre(str(montre)) #sym.arrow.r.double *#nombre(str(r))#sym.space.nobreak#un*]
  }
}
#let x(id) = ex(id).x

// ── Constantes ──
#let valeurs = {
  let d = (:)
  for l in csv("../donnees/valeurs.csv", row-type: dictionary) { d.insert(l.cle, l) }
  d
}
#let val-brut(cle) = {
  if cle not in valeurs { panic("FR01 : valeur " + cle + " absente de donnees/valeurs.csv") }
  float(valeurs.at(cle).valeur)
}
#let val(cle) = { let _ = val-brut(cle); nombre(valeurs.at(cle).valeur) }
#let valu(cle) = [#val(cle)#sym.space.nobreak#valeurs.at(cle).unite]

// ── Ligne propre à la variante (référentiel 2009 ou 2026) ──
#let ligne-variante(cle) = {
  let lignes = csv("../donnees/variantes.csv", row-type: dictionary).filter(l => l.variante == entree("variante") and l.cle == cle)
  if lignes.len() != 1 { panic("FR01 : " + str(lignes.len()) + " ligne(s) « " + cle + " » pour " + entree("variante") + " dans donnees/variantes.csv (1 attendue)") }
  let l = lignes.first()
  if l.referentiel != entree("referentiel") {
    panic("FR01 : " + entree("variante") + " : référentiel " + l.referentiel + " ≠ entrée " + entree("referentiel"))
  }
  l.valeur
}

// ── Cohérence entre lignes et avec les constantes (échec de compilation si écart) ──
#let meme(a, b, quoi) = if calc.abs(float(a) - float(b)) > 0.000000001 {
  panic("FR01 : incohérence " + quoi + " : " + str(a) + " ≠ " + str(b))
}
#meme(brut("EX02A", "K"), val-brut("facteur_metrique"), "mg par g")
#meme(brut("EX02B", "K"), val-brut("facteur_metrique"), "µg par mg")
#meme(brut("EX03A", "K"), val-brut("facteur_metrique"), "mg par g (EX03)")
#meme(brut("EX03A", "C"), val-brut("pct_volume"), "100 mL du pourcentage")
#meme(x("EX03A"), brut("EX03B", "N"), "concentration EX03")
#meme(brut("EX04A", "K"), val-brut("facteur_metrique"), "mg par g (EX04)")
#meme(x("EX04A"), brut("EX04B", "N"), "concentration EX04")
#meme(brut("EX05A", "W"), brut("EX05B", "W"), "poids EX05")
#meme(brut("EX05C", "J"), val-brut("heures_par_jour"), "heures par jour")
#meme(brut("EX06A", "V"), brut("EX06B", "V"), "volume EX06")
#meme(brut("EX06A", "T"), brut("EX06B", "T"), "durée EX06")
#meme(brut("EX06B", "DF"), val-brut("gtt_standard"), "perfuseur standard")
#meme(brut("EX06B", "M"), val-brut("min_par_h"), "minutes par heure")
#meme(brut("EX07", "DF"), val-brut("gtt_pedia"), "perfuseur pédiatrique")
#meme(brut("EX07", "M"), val-brut("min_par_h"), "minutes par heure (EX07)")
#meme(brut("EX08A", "V"), brut("EX08B", "V"), "volume EX08")
#meme(brut("EX08A", "R"), brut("EX08B", "R"), "débit EX08")
#meme(x("EX09A"), brut("EX09B", "N"), "concentration EX09")
#meme(brut("EX10A", "K"), val-brut("facteur_metrique"), "µg par mg (EX10)")
#meme(x("EX10A"), brut("EX10B", "N"), "concentration EX10")
#meme(brut("EX10B", "M"), val-brut("min_par_h"), "minutes par heure (EX10)")
#if brut("EX09A", "V") > val-brut("seringue_pse") { panic("FR01 : EX09A : volume supérieur à la seringue du PSE") }

// Heures décimales → « 20 h 15 » ; durée → « 6 h 15 min » (chiffres issus des données).
#let hm(h) = {
  let hh = int(calc.floor(h))
  let mm = int(calc.round((h - hh) * val-brut("min_par_h")))
  (hh, mm)
}
#let deux(n) = if n < 10 { "0" + str(n) } else { str(n) }
#let horloge(h) = { let (hh, mm) = hm(h); [#hh#sym.space.nobreak;h#sym.space.nobreak#deux(mm)] }
#let duree(h) = { let (hh, mm) = hm(h); [#hh#sym.space.nobreak;h #mm#sym.space.nobreak;min] }

#show: fiche.with(
  titre: entree("titre"),
  sous-titre: [Méthode pas à pas, exemples détaillés et pièges, pour les calculs de doses et de débits en IFSI],
  marque: entree("marque"),
  langue: entree("langue"),
  format: entree("format"),
  mentions: mentions-produit(entree("produit"), entree("langue")),
  version: entree("version"),
  numerotation: true,
)

// Unités composées insécables (EN01, rapport v2, N4) : un gluon (U+2060) suit chaque « / » entre deux lettres.
#show regex("[\\p{L}²]/[\\p{L}]"): it => it.text.replace("/", "/\u{2060}")

#colonnes(2)[

_#ligne-variante("ligne_ue")._\
_Produits A à F et leurs chiffres : valeurs d'exercice, pas des recommandations posologiques._

= Méthode et produit en croix

#encadre(titre: "Méthode en 4 étapes")[
  + Lire la prescription : dose, unité, voie, durée.
  + Tout convertir dans la même unité.
  + Poser le calcul (produit en croix) avec les unités.
  + Vérifier l'ordre de grandeur avant de préparer.
]

#formule(titre: "Produit en croix")[
  $H$ mg dans $Q$ mL ; $D$ mg prescrits dans $V$ mL : $V = D times Q slash H$.
]

#exemple(titre: "Ampoule (Produit A, valeurs d'exercice)")[
  Prescription #v("EX01", "D") mg ; ampoule de #v("EX01", "Q") mL contenant #v("EX01", "H") mg.\
  #v("EX01", "D") × #v("EX01", "Q") ÷ #v("EX01", "H") #res("EX01") (seringue de #valu("seringue_petite"), graduée au #valu("seringue_petite_pas")).
]

= Conversions

#formule(titre: [L'échelle × #val("facteur_metrique")])[
  g → mg → µg et L → mL : × #val("facteur_metrique") à chaque marche descendue, ÷ #val("facteur_metrique") à chaque marche remontée.
  #v("EX02A", "G") g × #v("EX02A", "K") #res("EX02A")\; #v("EX02B", "M") mg × #v("EX02B", "K") #res("EX02B").
]

#piege[Mélanger mg et µg multiplie l'erreur par #val("facteur_metrique") : convertir *avant* de diviser.]

= Concentrations et dilutions

#formule[
  concentration = quantité ÷ volume *total* (après dilution).
  % (m/V) = g pour #valu("pct_volume") : #v("EX03A", "P") % = #v("EX03A", "P") × #v("EX03A", "K") ÷ #v("EX03A", "C") #res("EX03A").
]

#exemple(titre: "Solution en % (Produit C, valeurs d'exercice)")[
  Prescription #v("EX03B", "O") mg de Produit C à #v("EX03A", "P") % : #v("EX03B", "O") ÷ #v("EX03B", "N") #res("EX03B").
]

= Reconstitution

#exemple(titre: "Poudre (Produit E, valeurs d'exercice)")[
  Flacon de #v("EX04A", "G") g ; notice : ajouter #v("EX04A", "A") mL de solvant pour obtenir #v("EX04A", "F") mL.
  #v("EX04A", "G") × #v("EX04A", "K") ÷ #v("EX04A", "F") #res("EX04A").
  Prescription #v("EX04B", "O") mg : #v("EX04B", "O") ÷ #v("EX04B", "N") #res("EX04B").
]

#piege[La poudre occupe un volume : diviser par les #v("EX04A", "F") mL finaux, pas par les #v("EX04A", "A") mL de solvant.]

= Doses rapportées au poids

#formule[
  dose = mg/kg × kg ; *par jour* ÷ nombre de prises = *par prise*.
  Conforme si borne basse × kg ≤ dose prescrite par jour ≤ borne haute × kg.
]

#exemple(titre: "Fourchette (Produit B, valeurs d'exercice)")[
  #v("EX05A", "L") à #v("EX05B", "U") mg/kg/j ; #v("EX05A", "W") kg ; prescription #v("EX05C", "O") mg toutes les #v("EX05C", "I") h.
  Min #v("EX05A", "L") × #v("EX05A", "W") #res("EX05A")\; max #v("EX05B", "U") × #v("EX05B", "W") #res("EX05B").
  Prescrit #v("EX05C", "O") × #v("EX05C", "J") ÷ #v("EX05C", "I") #res("EX05C") : conforme. Hors fourchette : ne pas administrer, joindre le.la prescripteur.rice.
]

#piege[mg/kg/j est un total sur #val("heures_par_jour") h : comparer par jour ou par prise, à grandeur égale.]

= Débits de perfusion

#formule[
  *Pompe, PSE :* débit (mL/h) = $V$ (mL) ÷ $T$ (h).
  *Gravité :* gouttes/min = $V$ × DF ÷ ($T$ × #val("min_par_h")).
  DF (gouttes/mL) : perfuseur standard #val("gtt_standard") ; perfuseur pédiatrique (microgouttes) #val("gtt_pedia").
  *Avec #val("gtt_pedia") gouttes/mL :* gouttes/min = mL/h. *Avec #val("gtt_standard") :* gouttes/min = mL/h ÷ #nombre(str(val-brut("min_par_h") / val-brut("gtt_standard"))).
]

#exemple(titre: "Même prescription, pompe ou gravité")[
  #v("EX06A", "V") mL en #v("EX06A", "T") h. Pompe : #v("EX06A", "V") ÷ #v("EX06A", "T") #res("EX06A").\
  Perfuseur standard : #v("EX06B", "V") × #v("EX06B", "DF") ÷ (#v("EX06B", "T") × #v("EX06B", "M")) #res("EX06B").
]

#exemple(titre: "Perfuseur pédiatrique")[
  #v("EX07", "V") mL en #v("EX07", "T") h : #v("EX07", "V") × #v("EX07", "DF") ÷ (#v("EX07", "T") × #v("EX07", "M")) #res("EX07").
]

#piege[Des gouttes par *minute* : oublier ÷ #val("min_par_h") donne un débit #val("min_par_h") fois trop fort.]

= Heure de fin

#exemple(titre: "Durée et heure de fin")[
  #v("EX08A", "V") mL à #v("EX08A", "R") mL/h, début à #horloge(brut("EX08B", "S")) :
  #v("EX08A", "V") ÷ #v("EX08A", "R") #res("EX08A") (#duree(x("EX08A"))) → fin à #horloge(x("EX08B")).
]

= Pousse-seringue électrique (PSE)

#formule[
  mL/h = dose par heure ÷ concentration.
  $C$ (µg/mL) = mg × #val("facteur_metrique") ÷ mL.
  mL/h = µg/kg/min × kg × #val("min_par_h") ÷ $C$.
]

#exemple(titre: "Dose en mg/h (Produit D, valeurs d'exercice)")[
  #v("EX09A", "Q") mg complétés à #v("EX09A", "V") mL (seringue de #valu("seringue_pse")) #res("EX09A").
  #v("EX09B", "P") mg/h ÷ #v("EX09B", "N") #res("EX09B").
]

#exemple(titre: "Dose en µg/kg/min (Produit F, valeurs d'exercice)")[
  #v("EX10A", "D") mg dans #v("EX10A", "V") mL : #v("EX10A", "D") × #v("EX10A", "K") ÷ #v("EX10A", "V") #res("EX10A").
  #v("EX10B", "O") µg/kg/min ; #v("EX10B", "W") kg (tel que pesé) : #v("EX10B", "O") × #v("EX10B", "W") × #v("EX10B", "M") ÷ #v("EX10B", "N") #res("EX10B").
]

#piege[Seringue en mg, prescription en µg : × #val("facteur_metrique") d'abord ; une dose par minute demande × #val("min_par_h").]

= Arrondis

// Encadré non sécable (EN01, rapport v2, N6) : les règles d'arrondi restent sur une même page (tablette).
#block(breakable: false, encadre(titre: "N'arrondir que ce qui se règle ou se prélève")[
  - Poids : noté tel que pesé (au #valu("poids_pas")), puis utilisé tel quel.
  - Concentrations et résultats intermédiaires : jamais arrondis.
  - Gouttes/min : entières. mL/h : au pas de l'appareil (#valu("debit_pas") ici ; certains : mL/h entier).
  - Volume : à la graduation de la seringue (#valu("seringue_petite_pas") pour #valu("seringue_petite")).
])

#piege[Arrondir une concentration ou un résultat intermédiaire décale le débit final.]

= Sécurité

*Règle des 5 B :* bon patient, bon médicament, bonne dose, bonne voie, bon moment.
#note-clinique[Prescription incomplète ou illisible : la faire préciser avant d'administrer. Erreurs de programmation des pompes et PSE, et erreurs avec le chlorure de potassium injectable, figurent parmi les « never events » de l'ANSM : double vérification selon la procédure du service.]
]
