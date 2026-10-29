"""Fabrique les PDF d'une variante (A4, Letter, N&B, tablette) depuis sa source Typst unique, puis les contrôle.

Mode catalogue (chemins et entrées lus dans les tables) :
  python3 scripts/build.py EN02-STD [--formats a4,letter,nb,tablette]
    source  : produits/<CODE>/src/main.typ
    sortie  : produits/<CODE>/livraison/<VARIANTE>/<VARIANTE>-<format>.pdf

Mode explicite (tests, sources hors catalogue) :
  python3 scripts/build.py --source produits/_test/src/main.typ --sortie-dir produits/_test/livraison/TEST-EN \\
                           --inputs produits/_test/donnees/entrees-en.json [--pages-max N] [--formats …]
    --inputs : fichier JSON {clé: valeur} et/ou paires clé=valeur ; toutes les clés du contrat (CLES_CONTRAT)
               sont exigées ; « pages_max » (borne A4 du contrôle) peut y figurer au lieu de --pages-max.

Entrées transmises à Typst (sys.inputs, toutes des chaînes) : voir CLES_CONTRAT et scripts/README-pipeline.md.
Avant toute compilation, les sources .typ du dossier de la source et de ses sous-dossiers (produits/<CODE>/src/,
src/contenu/ compris) sont contrôlées :
un « ; » collé après #fonction(…) en mode texte, que Typst avale sans avertissement, fait échouer le build
(scripts/controle_source.py : fichier, ligne, extrait, correction « \\; »).
Tout avertissement Typst est traité comme une erreur (sauf AVERTISSEMENTS_ADMIS, vide à ce jour).
Code de sortie 1 au premier problème : source absente, donnée manquante, « ; » avalé dans la source, erreur ou
avertissement Typst, contrôle PDF en échec.
"""
import argparse
import json
import re
import time
from pathlib import Path

import controle_pdf
import controle_source
from outillage_commun import (FORMATS_PDF, ErreurOutillage, dossier_produit, lancer, produit, relatif,
                              variante)
from tables import RACINE, index, lire

# Clés de sys.inputs fournies à chaque compilation, en plus de « format ».
CLES_CONTRAT = ("variante", "produit", "referentiel", "langue", "marque", "version", "titre")
# Disposition du dépôt (conventions de chemins, pas des valeurs métier).
POLICES = RACINE / "charte" / "polices"
SOURCE_PRODUIT = Path("src") / "main.typ"
MOTIF_SOURCES = "**/*.typ"  # sources contrôlées (controle_source.py) : dossier de la source compilée et sous-dossiers
# Avertissements Typst tolérés : (motif regex, justification). Vide : tout avertissement fait échouer le build.
AVERTISSEMENTS_ADMIS = ()


# --- Données d'une variante -------------------------------------------------------------

def _colonne(ligne, cle, table, code):
    if cle not in ligne:
        raise ErreurOutillage(f"colonne « {cle} » absente de data/{table} (à ajouter par l'orchestrateur)")
    valeur = (ligne[cle] or "").strip()
    if not valeur:
        raise ErreurOutillage(f"{code} : « {cle} » vide dans data/{table}")
    return valeur


def donnees_variante(code_variante):
    """Entrées Typst et bornes de contrôle d'une variante, lues dans les tables. Échoue si une donnée manque."""
    v = variante(code_variante)
    p = produit(v["produit_code"])
    marches = index(lire("marches.csv"))
    marche = marches.get(p["marche_code"])
    if marche is None:
        raise ErreurOutillage(f"{p['code']} : marché « {p['marche_code']} » absent de data/marches.csv")
    marques = index(lire("marques.csv"))
    marque = marques.get(marche["marque_code"])
    if marque is None:
        raise ErreurOutillage(f"marché {marche['code']} : marque « {marche['marque_code']} » absente de data/marques.csv")
    if not (marque["nom"] or "").strip():
        decisions = [d["code"] for d in lire("decisions.csv")
                     if d["statut"] != "tranche" and "marque" in d["sujet"].lower()]
        raise ErreurOutillage(
            f"{code_variante} : la marque {marque['code']} n'a pas de nom (data/marques.csv, statut « {marque['statut']} »)"
            + (f" ; décision ouverte : {', '.join(decisions)}" if decisions else ""))
    pages_max = _colonne(p, "pages_max", "produits.csv", p["code"])
    try:
        pages_max = int(pages_max)
    except ValueError:
        raise ErreurOutillage(f"{p['code']} : pages_max « {pages_max} » n'est pas un entier (data/produits.csv)")
    entrees = {
        "variante": code_variante,
        "produit": p["code"],
        "referentiel": _colonne(v, "referentiel_code", "variantes.csv", code_variante),
        "langue": _colonne(marche, "langue", "marches.csv", marche["code"]),
        "marque": marque["nom"].strip(),
        "version": _colonne(v, "version", "variantes.csv", code_variante),
        "titre": _colonne(p, "titre_travail", "produits.csv", p["code"]),
    }
    return {
        "source": dossier_produit(p["code"]) / SOURCE_PRODUIT,
        "sortie": dossier_produit(p["code"]) / "livraison" / code_variante,
        "entrees": entrees,
        "pages_max": pages_max,
    }


def lire_entrees(valeurs):
    """--inputs : un fichier .json, ou des paires clé=valeur (les deux combinables, les paires l'emportent)."""
    entrees = {}
    for v in valeurs or []:
        if "=" in v and not Path(v).is_file():
            cle, valeur = v.split("=", 1)
            entrees[cle.strip()] = valeur
            continue
        chemin = Path(v)
        if not chemin.is_file():
            raise ErreurOutillage(f"--inputs : « {v} » n'est ni un fichier JSON ni une paire clé=valeur")
        try:
            contenu = json.loads(chemin.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            raise ErreurOutillage(f"--inputs : JSON invalide dans {chemin} ({e})")
        if not isinstance(contenu, dict):
            raise ErreurOutillage(f"--inputs : {chemin} doit contenir un objet JSON {{clé: valeur}}")
        entrees.update({k: str(val) for k, val in contenu.items()})
    manquantes = [c for c in CLES_CONTRAT if not str(entrees.get(c, "")).strip()]
    if manquantes:
        raise ErreurOutillage(f"--inputs : clés manquantes ou vides : {', '.join(manquantes)}")
    if "format" in entrees:
        raise ErreurOutillage("--inputs : « format » est fixé par le build (--formats), ne pas le fournir")
    return entrees


def pages_max_explicite(entrees, option):
    """Borne de pages du mode explicite : --pages-max, sinon la clé « pages_max » du JSON (retirée des entrées Typst)."""
    valeur = entrees.pop("pages_max", None)
    if option is not None:
        valeur = option
    try:
        valeur = int(valeur)
    except (TypeError, ValueError):
        raise ErreurOutillage("mode explicite : donner --pages-max ou une clé « pages_max » entière dans --inputs")
    if valeur < 1:
        raise ErreurOutillage("mode explicite : pages_max doit valoir au moins 1")
    return valeur


def lire_formats(texte):
    formats = [f.strip() for f in texte.split(",") if f.strip()]
    inconnus = [f for f in formats if f not in FORMATS_PDF]
    if inconnus or not formats:
        raise ErreurOutillage(f"--formats : {', '.join(inconnus) or 'vide'} (attendu : {', '.join(FORMATS_PDF)})")
    return list(dict.fromkeys(formats))


# --- Compilation --------------------------------------------------------------------------

def _diagnostic(obj):
    texte = str(getattr(obj, "diagnostic", "") or getattr(obj, "message", "") or obj).strip()
    indices = getattr(obj, "hints", None) or []
    return texte + "".join(f"\n  indice : {h}" for h in indices)


def _admis(avertissement):
    message = str(getattr(avertissement, "message", avertissement))
    return any(re.search(motif, message) for motif, _ in AVERTISSEMENTS_ADMIS)


def compiler(source, sortie_dir, code_variante, entrees, formats):
    """Compile la source pour chaque format ; renvoie {format: chemin du PDF}."""
    import typst
    source = Path(source).resolve()
    if not source.is_file():
        raise ErreurOutillage(f"source Typst introuvable : {relatif(source)}")
    try:
        source.relative_to(RACINE)
    except ValueError:
        raise ErreurOutillage(f"la source doit être sous la racine du dépôt ({RACINE}) : {source}")
    if not POLICES.is_dir():
        raise ErreurOutillage(f"dossier de polices introuvable : {relatif(POLICES)}")
    sources = sorted(source.parent.glob(MOTIF_SOURCES))
    controle_source.verifier(sources)  # « ; » avalés par Typst : échec avant toute compilation
    print(f"  source    : {len(sources)} fichier(s) .typ sans point-virgule avalé")
    sortie_dir = Path(sortie_dir)
    sortie_dir.mkdir(parents=True, exist_ok=True)
    pdfs = {}
    for fmt in formats:
        pdf = sortie_dir / f"{code_variante}-{fmt}.pdf"
        if pdf.exists():
            pdf.unlink()  # jamais d'ancien PDF laissé en place si la compilation échoue
        debut = time.monotonic()
        try:
            octets, avertissements = typst.compile_with_warnings(
                str(source), root=str(RACINE), font_paths=[str(POLICES)], ignore_system_fonts=True,
                sys_inputs={**entrees, "format": fmt})
        except typst.TypstError as e:
            raise ErreurOutillage(f"[{fmt}] compilation Typst en échec :\n{_diagnostic(e)}")
        refuses = [a for a in avertissements if not _admis(a)]
        if refuses:
            raise ErreurOutillage(f"[{fmt}] {len(refuses)} avertissement(s) Typst (traités comme des erreurs) :\n"
                                  + "\n".join(_diagnostic(a) for a in refuses))
        if not octets:
            raise ErreurOutillage(f"[{fmt}] Typst n'a produit aucun PDF")
        tmp = pdf.with_suffix(".pdf.tmp")
        tmp.write_bytes(octets)
        tmp.replace(pdf)
        print(f"  {fmt:<9} → {relatif(pdf)}  ({time.monotonic() - debut:.1f} s)")
        pdfs[fmt] = pdf
    return pdfs


def construire(source, sortie_dir, entrees, formats, pages_max):
    code = entrees["variante"]
    print(f"Build {code} : {relatif(Path(source).resolve())}")
    pdfs = compiler(source, sortie_dir, code, entrees, formats)
    print(f"Contrôle {code} :")
    mentions = [m for _, m in controle_pdf.mentions_produit(entrees["produit"], entrees["langue"])]
    resultats = controle_pdf.controler_ensemble(pdfs, entrees["titre"], entrees["marque"], pages_max, mentions)
    echecs = controle_pdf.afficher(resultats)
    if echecs:
        raise ErreurOutillage(f"{code} : {echecs} contrôle(s) PDF en échec")
    print(f"{code} : {len(pdfs)} PDF fabriqués et contrôlés.")
    return 0


def main():
    ap = argparse.ArgumentParser(description="Fabrique et contrôle les PDF d'une variante.")
    ap.add_argument("variante", nargs="?", help="code de variante (data/variantes.csv), ex. EN02-STD")
    ap.add_argument("--formats", default=",".join(FORMATS_PDF), help="sous-ensemble de a4,letter,nb,tablette")
    ap.add_argument("--source", help="mode explicite : fichier Typst à compiler (sous la racine du dépôt)")
    ap.add_argument("--sortie-dir", help="mode explicite : dossier de sortie des PDF")
    ap.add_argument("--inputs", nargs="+", help="mode explicite : fichier JSON et/ou paires clé=valeur")
    ap.add_argument("--pages-max", type=int, help="mode explicite : pages maximales en A4, sinon clé pages_max de "
                                                   "--inputs (autres formats : controle_pages_facteur_<format>)")
    a = ap.parse_args()
    formats = lire_formats(a.formats)
    explicite = a.source or a.sortie_dir or a.inputs or a.pages_max is not None
    if explicite:
        if a.variante or not (a.source and a.sortie_dir and a.inputs):
            ap.error("mode explicite : --source, --sortie-dir et --inputs ensemble, sans code de variante")
        entrees = lire_entrees(a.inputs)
        pages_max = pages_max_explicite(entrees, a.pages_max)
        return construire(a.source, a.sortie_dir, entrees, formats, pages_max)
    if not a.variante:
        ap.error("donner un code de variante, ou le mode explicite (--source …)")
    d = donnees_variante(a.variante)
    return construire(d["source"], d["sortie"], d["entrees"], formats, d["pages_max"])


if __name__ == "__main__":
    lancer(main)
