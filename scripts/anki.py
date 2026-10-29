"""Paquet Anki (.apkg) d'une variante, depuis produits/<CODE>/donnees/cartes.csv (colonnes : recto,verso,tags).

- tags séparés par des espaces ; recto et verso peuvent contenir du HTML simple (b, i, u, br, sub, sup, ul, li…) ;
- identifiants de modèle et de paquet stables d'une version à l'autre : dérivés d'un hash du code de variante ;
- GUID de note stable : hash du recto (une carte corrigée au verso met à jour la carte existante à l'import) ;
- nom du paquet : titre du produit (data/produits.csv, colonne titre_travail) ;
- horodatage = date de génération : Anki n'applique une mise à jour que si la note importée est plus récente ;
- nombres tirés des données (pas de nombre tapé en dur qui pourrait diverger de la fiche) : marqueurs
  {v:CLE} (valeur de donnees/valeurs.csv), {x:ID} (résultat affiché de donnees/exemples.csv, arrondi selon
  ses colonnes arrondi et mode_arrondi), {xe:ID} (résultat exact, tel qu'écrit) et {t:FICHIER:CLE:COLONNE}
  (cellule de n'importe quelle table donnees/FICHIER.csv, ligne dont la première colonne vaut CLE), formatés
  selon la langue (jetons nombre.* de data/charte_tokens.csv) ; une cellule {t:…} qui n'est pas un nombre est
  reprise telle quelle (&, <, > échappés). Un marqueur inconnu, une table, une clé ou une colonne absentes font
  échouer le script.
  Le GUID reste tiré du recto source (marqueurs compris) : corriger une donnée met la carte à jour.

Usage :
  python3 scripts/anki.py EN02-STD
  python3 scripts/anki.py --cartes cartes.csv --sortie paquet.apkg --cle EN02-STD --nom "Titre" [--langue en]
"""
import argparse
import csv
import hashlib
import html
import json
import re
import sqlite3
import tempfile
import warnings
import zipfile
from decimal import ROUND_CEILING, ROUND_FLOOR, ROUND_HALF_UP, Decimal, InvalidOperation
from pathlib import Path

import genanki

from outillage_commun import (ErreurOutillage, chemin_apkg, dossier_produit, lancer, langue_produit, libelle,
                              lire_csv, produit_de_variante, reglage, reglage_entier, relatif, variante)
from tables import DATA

COLONNES = ("recto", "verso", "tags")
BALISES_AUTORISEES = {"b", "strong", "i", "em", "u", "s", "br", "sub", "sup", "p", "div", "span", "ul", "ol",
                      "li", "small", "code", "hr", "table", "thead", "tbody", "tr", "td", "th"}
# Mise en page seulement : police, taille et couleurs restent celles du thème Anki de l'utilisateur.ice
# (mode nuit compris). Épaisseur des filets et marges des cellules : data/parametres.csv (anki_*).
def css():
    return (".card { text-align: center; }\n"
            "ul, ol { display: inline-block; text-align: left; }\n"
            "table { margin: 0 auto; border-collapse: collapse; }\n"
            f"td, th {{ border: {reglage('anki_tableau_trait')} solid; padding: {reglage('anki_cellule_marge')}; }}")


# Marqueurs de nombres : {type:argument}. Tout « {…:…} » d'un type inconnu fait échouer le script.
MOTIF_MARQUEUR = re.compile(r"\{([^{}:\s]*):([^{}]*)\}")
# Cellule {t:…} lue comme un nombre (formatée selon la langue) : signe éventuel, chiffres, décimales éventuelles.
MOTIF_NOMBRE = re.compile(r"[+\-\u2212]?\d+(?:[.,]\d+)?")
# Méthodes d'arrondi (colonne methode de data/modes_arrondi.csv) → mode decimal.
METHODES_ARRONDI = {"plus_proche": ROUND_HALF_UP, "defaut": ROUND_FLOOR, "exces": ROUND_CEILING}


def _jetons_charte():
    with open(DATA / "charte_tokens.csv", newline="", encoding="utf-8") as f:
        return {l["cle"]: l["valeur"] for l in csv.DictReader(f)}


def _car(valeur):
    """« U+202F » → caractère ; sinon la valeur telle quelle (comme _car() de charte/modele.typ)."""
    return chr(int(valeur[2:], 16)) if re.fullmatch(r"U\+[0-9A-Fa-f]{4,6}", valeur) else valeur


def formater_nombre(chaine, langue):
    """Même rendu que nombre() de la charte pour une chaîne : chiffres gardés tels quels, séparateurs de la langue,
    milliers groupés à partir de nombre.<langue>.groupe-min chiffres, signe moins typographique."""
    jetons = _jetons_charte()
    lg = "fr" if langue == "fr" else "en"
    brut = chaine.strip().replace(",", ".").replace("\u2212", "-")
    try:
        Decimal(brut)
    except InvalidOperation:
        raise ErreurOutillage(f"« {chaine} » n'est pas un nombre")
    negatif = brut.startswith("-")
    ent, _, dec = brut.lstrip("+-").partition(".")
    if len(ent) >= int(jetons[f"nombre.{lg}.groupe-min"]):
        groupes = []
        while len(ent) > 3:
            groupes.insert(0, ent[-3:])
            ent = ent[:-3]
        ent = _car(jetons[f"nombre.{lg}.milliers"]).join([ent] + groupes)
    texte = ent + (_car(jetons[f"nombre.{lg}.decimale"]) + dec if dec else "")
    return (_car(jetons["nombre.moins"]) + texte) if negatif and texte.strip("0.,") else texte


class Marqueurs:
    """Remplace {v:CLE}, {x:ID}, {xe:ID} et {t:FICHIER:CLE:COLONNE} par les données des tables du produit
    (dossier donnees/). Les tables ne sont lues qu'au premier marqueur : un paquet sans marqueur ne dépend pas d'elles."""

    def __init__(self, dossier_donnees, langue):
        self.dossier, self.langue = Path(dossier_donnees), langue
        self._valeurs = self._exemples = self._modes = None
        self._tables = {}  # {t:…} : nom de fichier → (en-tête, {clé: ligne}, clés en double)

    def _table_generique(self, nom, marqueur):
        if nom not in self._tables:
            chemin = self.dossier / nom
            if not chemin.is_file():
                raise ErreurOutillage(f"table {chemin} introuvable (marqueur {marqueur})")
            with open(chemin, newline="", encoding="utf-8-sig") as f:
                lignes = [l for l in csv.reader(f) if any(c.strip() for c in l)]
            if not lignes:
                raise ErreurOutillage(f"table {chemin} vide (marqueur {marqueur})")
            entete, par_cle, doubles = [c.strip() for c in lignes[0]], {}, set()
            for l in lignes[1:]:
                cle = l[0].strip()
                if cle in par_cle:
                    doubles.add(cle)
                par_cle.setdefault(cle, l)
            self._tables[nom] = (entete, par_cle, doubles)
        return self._tables[nom]

    def cellule(self, arg):
        """{t:FICHIER:CLE:COLONNE} : cellule COLONNE de donnees/FICHIER(.csv), ligne dont la première colonne vaut
        CLE. Nombre : formaté selon la langue ; texte : repris tel quel, HTML échappé."""
        marqueur = "{t:" + arg + "}"
        parties = [x.strip() for x in arg.split(":")]
        if len(parties) != 3 or not all(parties):
            raise ErreurOutillage(f"marqueur {marqueur} mal formé (attendu : {{t:FICHIER:CLE:COLONNE}})")
        fichier, cle, colonne = parties
        if Path(fichier).name != fichier or fichier.startswith("."):
            raise ErreurOutillage(f"marqueur {marqueur} : « {fichier} » doit nommer une table du dossier {self.dossier}")
        nom = fichier if fichier.endswith(".csv") else fichier + ".csv"
        entete, par_cle, doubles = self._table_generique(nom, marqueur)
        chemin = self.dossier / nom
        if colonne not in entete:
            raise ErreurOutillage(f"colonne « {colonne} » absente de {chemin} (colonnes : {', '.join(entete)})")
        if cle in doubles:
            raise ErreurOutillage(f"clé « {cle} » en double dans la première colonne de {chemin}")
        ligne = par_cle.get(cle)
        if ligne is None:
            raise ErreurOutillage(f"clé « {cle} » absente de la première colonne (« {entete[0]} ») de {chemin}")
        i = entete.index(colonne)
        valeur = (ligne[i] if i < len(ligne) else "").strip()
        if not valeur:
            raise ErreurOutillage(f"cellule vide : {chemin}, clé « {cle} », colonne « {colonne} »")
        if MOTIF_NOMBRE.fullmatch(valeur):
            return formater_nombre(valeur, self.langue)
        return html.escape(valeur, quote=False)

    def _table(self, nom):
        chemin = self.dossier / nom
        if not chemin.is_file():
            raise ErreurOutillage(f"{chemin} introuvable (demandé par un marqueur de cartes.csv)")
        with open(chemin, newline="", encoding="utf-8") as f:
            return list(csv.DictReader(f))

    def valeur(self, cle):
        if self._valeurs is None:
            lignes = self._table("valeurs.csv")
            col = "cle" if lignes and "cle" in lignes[0] else "id"
            self._valeurs = {l.get(col, ""): l for l in lignes}
        l = self._valeurs.get(cle)
        if l is None:
            raise ErreurOutillage(f"clé « {cle} » absente de {self.dossier / 'valeurs.csv'}")
        nombre = (l.get("valeur") or l.get("mantisse") or "").strip()
        if not nombre:
            raise ErreurOutillage(f"clé « {cle} » sans valeur (colonne valeur ou mantisse) dans valeurs.csv")
        texte = formater_nombre(nombre, self.langue)
        exposant = (l.get("exposant") or "").strip()
        if exposant and float(exposant.replace(",", ".")) != 0:
            texte += " × 10<sup>" + formater_nombre(exposant, self.langue) + "</sup>"
        return texte

    def exemple(self, ident):
        if self._exemples is None:
            self._exemples = {l["id"]: l for l in self._table("exemples.csv")}
        l = self._exemples.get(ident)
        if l is None:
            raise ErreurOutillage(f"exemple « {ident} » absent de {self.dossier / 'exemples.csv'}")
        return l

    def resultat_affiche(self, ident):
        """Résultat arrondi à `arrondi` décimales selon `mode_arrondi` (code de data/modes_arrondi.csv ;
        vide ou colonne absente : arrondi_mode_defaut). Sans colonne arrondi : le résultat tel qu'écrit."""
        l = self.exemple(ident)
        exact = l["resultat_attendu"].strip()
        decimales = (l.get("arrondi") or "").strip()
        if not decimales:
            return exact
        if self._modes is None:
            with open(DATA / "modes_arrondi.csv", newline="", encoding="utf-8") as f:
                self._modes = {m["code"]: m["methode"] for m in csv.DictReader(f)}
        code = (l.get("mode_arrondi") or "").strip() or str(reglage_entier("arrondi_mode_defaut"))
        methode = self._modes.get(code)
        if methode not in METHODES_ARRONDI:
            raise ErreurOutillage(f"exemple « {ident} » : mode d'arrondi « {code} » inconnu (data/modes_arrondi.csv)")
        x = Decimal(exact.replace(",", ".").replace("\u2212", "-"))
        r = x.quantize(Decimal(1).scaleb(-int(decimales)), rounding=METHODES_ARRONDI[methode])
        texte = format(r, "f")
        if reglage_entier("anki_zeros_finaux") == 0 and "." in texte:
            texte = texte.rstrip("0").rstrip(".")
        return texte

    def remplacer(self, texte):
        def un(m):
            genre, arg = m.group(1), m.group(2).strip()
            if genre == "v":
                return self.valeur(arg)
            if genre == "x":
                return formater_nombre(self.resultat_affiche(arg), self.langue)
            if genre == "xe":
                return formater_nombre(self.exemple(arg)["resultat_attendu"], self.langue)
            if genre == "t":
                return self.cellule(m.group(2))
            raise ErreurOutillage(f"marqueur inconnu « {m.group(0)} » "
                                  "(admis : {v:CLE}, {x:ID}, {xe:ID}, {t:FICHIER:CLE:COLONNE})")
        return MOTIF_MARQUEUR.sub(un, texte)


def identifiant_stable(*valeurs):
    """Entier stable dans [2^30, 2^31) (plage d'identifiants conseillée par genanki), tiré d'un SHA-256."""
    empreinte = hashlib.sha256("::".join(valeurs).encode("utf-8")).digest()
    return (1 << 30) + int.from_bytes(empreinte[:8], "big") % (1 << 30)


def guid_note(recto):
    return genanki.guid_for(normaliser_recto(recto))


def normaliser_recto(recto):
    return re.sub(r"\s+", " ", recto).strip()


def controler_html(texte):
    """Balises inconnues ou mal formées (liste vide si tout va bien)."""
    problemes = []
    for balise in sorted({b.lower() for b in re.findall(r"</?\s*([a-zA-Z][a-zA-Z0-9]*)[^>]*>", texte)}):
        if balise not in BALISES_AUTORISEES:
            problemes.append(f"balise <{balise}> non prévue")
    if texte.count("<") != texte.count(">"):
        problemes.append("chevrons < > déséquilibrés (écrire &lt; et &gt; pour les signes)")
    return problemes


def lire_cartes(chemin):
    cartes, vus, erreurs = [], {}, []
    for n, l in enumerate(lire_csv(chemin, COLONNES), start=2):
        if not l["recto"] or not l["verso"]:
            erreurs.append(f"ligne {n} : recto ou verso vide")
            continue
        for cote in ("recto", "verso"):
            erreurs += [f"ligne {n} ({cote}) : {p}" for p in controler_html(l[cote])]
        tags = l["tags"].split()
        if any(not re.fullmatch(r"[^\s\"]+", t) for t in tags):
            erreurs.append(f"ligne {n} : tag invalide dans « {l['tags']} »")
        cle = normaliser_recto(l["recto"])
        if cle in vus:
            erreurs.append(f"ligne {n} : même recto que la ligne {vus[cle]} (le GUID serait identique)")
        vus[cle] = n
        cartes.append({"recto": l["recto"], "verso": l["verso"], "tags": tags, "ligne": n})
    if erreurs:
        raise ErreurOutillage(f"{chemin} :\n  " + "\n  ".join(erreurs))
    if not cartes:
        raise ErreurOutillage(f"{chemin} : aucune carte")
    return cartes


def modele(cle, nom, langue):
    recto, verso = libelle("anki_champ_recto", langue), libelle("anki_champ_verso", langue)
    return genanki.Model(
        identifiant_stable("modele", cle),
        f"{nom} ({cle})",
        fields=[{"name": recto}, {"name": verso}],
        templates=[{"name": f"{recto} → {verso}",
                    "qfmt": "{{" + recto + "}}",
                    "afmt": "{{FrontSide}}<hr id=answer>{{" + verso + "}}"}],
        css=css(),
    )


def generer_paquet(cartes_csv, sortie, cle, nom, langue="en", donnees=None):
    """Écrit le .apkg. cle : chaîne qui fixe les identifiants (code de variante) ; nom : nom du paquet ;
    donnees : dossier des tables lues par les marqueurs (valeurs.csv, exemples.csv, tables de {t:…} ;
    par défaut : celui de cartes.csv).
    Renvoie (nombre de cartes, identifiant du paquet, identifiant du modèle)."""
    cartes = lire_cartes(cartes_csv)
    marqueurs, erreurs = Marqueurs(Path(cartes_csv).parent if donnees is None else donnees, langue), []
    for c in cartes:
        for cote in ("recto", "verso"):
            try:
                c[cote + "_affiche"] = marqueurs.remplacer(c[cote])
            except ErreurOutillage as e:
                erreurs.append(f"ligne {c['ligne']} ({cote}) : {e}")
    if erreurs:
        raise ErreurOutillage(f"{cartes_csv} :\n  " + "\n  ".join(erreurs))
    m = modele(cle, nom, langue)
    paquet = genanki.Deck(identifiant_stable("paquet", cle), nom)
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")  # le HTML a déjà été contrôlé ci-dessus
        for c in cartes:
            paquet.add_note(genanki.Note(model=m, fields=[c["recto_affiche"], c["verso_affiche"]], tags=c["tags"],
                                         guid=guid_note(c["recto"])))
    sortie = Path(sortie)
    sortie.parent.mkdir(parents=True, exist_ok=True)
    genanki.Package(paquet).write_to_file(str(sortie))
    return len(cartes), paquet.deck_id, m.model_id


def relire_paquet(apkg):
    """Contenu d'un .apkg relu depuis sa base : {guid: (champs, tags)}, noms des paquets et des modèles."""
    with tempfile.TemporaryDirectory() as tmp, zipfile.ZipFile(apkg) as z:
        z.extract("collection.anki2", tmp)
        base = sqlite3.connect(Path(tmp) / "collection.anki2")
        notes = {g: (f.split("\x1f"), t.split()) for g, f, t in base.execute("select guid, flds, tags from notes")}
        decks, models = base.execute("select decks, models from col").fetchone()
        nb_cartes = base.execute("select count(*) from cards").fetchone()[0]
        base.close()
    decks, models = json.loads(decks), json.loads(models)
    return {"notes": notes, "nb_cartes": nb_cartes,
            "paquets": {int(k): v["name"] for k, v in decks.items()},
            "modeles": {int(k): v["name"] for k, v in models.items()}}


def anki_variante(code_variante):
    v = variante(code_variante)
    p = produit_de_variante(code_variante)
    sortie = chemin_apkg(code_variante)
    resultat = generer_paquet(dossier_produit(v["produit_code"]) / "donnees" / "cartes.csv", sortie,
                              code_variante, p["titre_travail"], langue_produit(p))
    return resultat, sortie


def main():
    ap = argparse.ArgumentParser(description="Paquet Anki .apkg depuis donnees/cartes.csv.")
    ap.add_argument("variante", nargs="?", help="code de variante, ex. EN02-STD")
    ap.add_argument("--cartes", help="usage direct : cartes.csv")
    ap.add_argument("--sortie", help="usage direct : .apkg à écrire")
    ap.add_argument("--cle", help="usage direct : clé des identifiants stables (code de variante)")
    ap.add_argument("--nom", help="usage direct : nom du paquet")
    ap.add_argument("--langue", default="en", help="usage direct : langue des noms de champs et des nombres (en, fr)")
    ap.add_argument("--donnees", help="usage direct : dossier des tables des marqueurs (valeurs.csv, exemples.csv, "
                                      "tables de {t:…} ; défaut : celui de --cartes)")
    a = ap.parse_args()
    direct = (a.cartes, a.sortie, a.cle, a.nom)
    if any(direct):
        if a.variante or not all(direct):
            ap.error("usage direct : --cartes, --sortie, --cle et --nom ensemble, sans code de variante")
        resultat, sortie = generer_paquet(a.cartes, a.sortie, a.cle, a.nom, a.langue, a.donnees), Path(a.sortie)
    elif a.variante:
        resultat, sortie = anki_variante(a.variante)
    else:
        ap.error("donner un code de variante, ou --cartes, --sortie, --cle et --nom")
    n, id_paquet, id_modele = resultat
    print(f"{relatif(sortie)}  {n} cartes, paquet {id_paquet}, modèle {id_modele}")


if __name__ == "__main__":
    lancer(main)
