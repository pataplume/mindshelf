"""Paquet Anki (.apkg) d'une variante, depuis produits/<CODE>/donnees/cartes.csv (colonnes : recto,verso,tags).

- tags séparés par des espaces ; recto et verso peuvent contenir du HTML simple (b, i, u, br, sub, sup, ul, li…) ;
- identifiants de modèle et de paquet stables d'une version à l'autre : dérivés d'un hash du code de variante ;
- GUID de note stable : hash du recto (une carte corrigée au verso met à jour la carte existante à l'import) ;
- nom du paquet : titre du produit (data/produits.csv, colonne titre_travail) ;
- horodatage = date de génération : Anki n'applique une mise à jour que si la note importée est plus récente.

Usage :
  python3 scripts/anki.py EN02-STD
  python3 scripts/anki.py --cartes cartes.csv --sortie paquet.apkg --cle EN02-STD --nom "Titre" [--langue en]
"""
import argparse
import hashlib
import json
import re
import sqlite3
import tempfile
import warnings
import zipfile
from pathlib import Path

import genanki

from outillage_commun import (ErreurOutillage, chemin_apkg, dossier_produit, lancer, langue_produit, libelle,
                              lire_csv, produit_de_variante, relatif, variante)

COLONNES = ("recto", "verso", "tags")
BALISES_AUTORISEES = {"b", "strong", "i", "em", "u", "s", "br", "sub", "sup", "p", "div", "span", "ul", "ol",
                      "li", "small", "code", "hr", "table", "thead", "tbody", "tr", "td", "th"}
# Mise en page seulement : police, taille et couleurs restent celles du thème Anki de l'utilisateur.ice
# (mode nuit compris), aucune valeur de style hors de la charte.
CSS = """.card { text-align: center; }
ul, ol { display: inline-block; text-align: left; }
table { margin: 0 auto; border-collapse: collapse; }
td, th { border: 1px solid; padding: 0.2em 0.5em; }"""


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
        cartes.append({"recto": l["recto"], "verso": l["verso"], "tags": tags})
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
        css=CSS,
    )


def generer_paquet(cartes_csv, sortie, cle, nom, langue="en"):
    """Écrit le .apkg. cle : chaîne qui fixe les identifiants (code de variante) ; nom : nom du paquet.
    Renvoie (nombre de cartes, identifiant du paquet, identifiant du modèle)."""
    cartes = lire_cartes(cartes_csv)
    m = modele(cle, nom, langue)
    paquet = genanki.Deck(identifiant_stable("paquet", cle), nom)
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")  # le HTML a déjà été contrôlé ci-dessus
        for c in cartes:
            paquet.add_note(genanki.Note(model=m, fields=[c["recto"], c["verso"]], tags=c["tags"],
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
    ap.add_argument("--langue", default="en", help="usage direct : langue des noms de champs (en, fr)")
    a = ap.parse_args()
    direct = (a.cartes, a.sortie, a.cle, a.nom)
    if any(direct):
        if a.variante or not all(direct):
            ap.error("usage direct : --cartes, --sortie, --cle et --nom ensemble, sans code de variante")
        resultat, sortie = generer_paquet(a.cartes, a.sortie, a.cle, a.nom, a.langue), Path(a.sortie)
    elif a.variante:
        resultat, sortie = anki_variante(a.variante)
    else:
        ap.error("donner un code de variante, ou --cartes, --sortie, --cle et --nom")
    n, id_paquet, id_modele = resultat
    print(f"{relatif(sortie)}  {n} cartes, paquet {id_paquet}, modèle {id_modele}")


if __name__ == "__main__":
    lancer(main)
