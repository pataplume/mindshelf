"""Contrôle des PDF d'une variante (appelé à la fin de scripts/build.py, ou seul).

Pour chaque format :
  - fichier présent et lisible ;
  - polices toutes incorporées (pdffonts : colonne emb = yes) ;
  - métadonnées : Title = titre du produit, Author = marque ;
  - nombre de pages entre 1 et pages_max × controle_pages_facteur_<format> (arrondi au-dessus) ;
  - aucune page blanche (page sans aucun contenu hors en-tête, pied de page et décor) ;
  - aucun texte qui sort de la zone de texte latérale (marges page.<format>.marge.x de la charte) ;
  - N&B : aucun pixel coloré (rendu à controle_nb_ppp, écart entre canaux > controle_nb_ecart_max) ;
  - tablette : page en paysage, liens internes (sommaire, retour au sommaire) et signets présents.

Usage :
  python3 scripts/controle_pdf.py EN02-STD
  python3 scripts/controle_pdf.py --pdf a/X-a4.pdf b/X-nb.pdf --titre "…" --marque MindShelf --pages-max 1
    (le format se lit dans le suffixe du nom : -a4, -letter, -nb, -tablette)
Code de sortie 1 si un contrôle échoue.
"""
import argparse
import math
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageChops
from pypdf import PdfReader
from pypdf.generic import ContentStream

from outillage_commun import (FORMATS_PDF, ErreurOutillage, chemin_pdf, executer, lancer, relatif,
                              reglage_entier, reglage_nombre)
from tables import DATA

# Opérateurs PDF qui peignent quelque chose (texte, tracé, image, dégradé).
OPERATEURS_PEINTURE = {b"TJ", b"Tj", b"'", b'"', b"f", b"F", b"f*", b"B", b"B*", b"b", b"b*", b"S", b"s",
                       b"Do", b"sh"}
POINTS_PAR_MM = 72 / 25.4


class Resultat:
    def __init__(self, fmt, nom, ok, detail=""):
        self.fmt, self.nom, self.ok, self.detail = fmt, nom, ok, detail


# --- Contrôles élémentaires -------------------------------------------------------------

def polices(pdf):
    """[(nom, incorporée)] d'après pdffonts."""
    sortie = executer(["pdffonts", pdf])
    lignes = sortie.splitlines()[2:]  # en-tête + filet
    res = []
    for l in lignes:
        morceaux = l.split()
        if len(morceaux) < 6:
            continue
        res.append((morceaux[0], morceaux[-5] == "yes"))
    return res


def page_vide(lecteur, page):
    """Vrai si la page ne peint rien en dehors du contenu marqué /Artifact (en-tête, pied, fond, décor).
    Typst balise ainsi tout PDF ; un PDF sans aucun balisage est jugé sur l'ensemble de ses opérateurs."""
    try:
        ops = ContentStream(page.get_contents(), lecteur).operations
    except Exception:
        return False  # contenu illisible : on ne conclut pas à une page blanche
    balise = any(op in (b"BDC", b"BMC") for _, op in ops)
    pile, peints = [], 0
    for operandes, op in ops:
        if op in (b"BDC", b"BMC"):
            pile.append(str(operandes[0]) if operandes else "")
        elif op == b"EMC":
            if pile:
                pile.pop()
        elif op in OPERATEURS_PEINTURE and (not balise or "/Artifact" not in pile):
            peints += 1
    return peints == 0


def mots_hors_zone(pdf, marge_pt, tolerance_pt):
    """[(page, mot, x)] des mots qui dépassent la zone de texte latérale ou la page (pdftotext -bbox)."""
    import html
    import re
    sortie = executer(["pdftotext", "-bbox", pdf, "-"])
    res, page, largeur, hauteur = [], 0, 0.0, 0.0
    for l in sortie.splitlines():
        m = re.search(r'<page width="([\d.]+)" height="([\d.]+)"', l)
        if m:
            page += 1
            largeur, hauteur = float(m.group(1)), float(m.group(2))
            continue
        m = re.search(r'<word xMin="([\d.-]+)" yMin="([\d.-]+)" xMax="([\d.-]+)" yMax="([\d.-]+)">(.*)</word>', l)
        if m:
            x0, y0, x1, y1 = map(float, m.groups()[:4])
            if (x0 < marge_pt - tolerance_pt or x1 > largeur - marge_pt + tolerance_pt
                    or y0 < -tolerance_pt or y1 > hauteur + tolerance_pt):
                res.append((page, html.unescape(m.group(5)), round(x1 if x1 > largeur / 2 else x0, 1)))
    return res


def pixels_colores(pdf, ppp, ecart_max):
    """[(page, nb de pixels dont l'écart entre canaux RVB dépasse ecart_max)] pour les pages fautives."""
    fautives = []
    with tempfile.TemporaryDirectory() as tmp:
        executer(["pdftoppm", "-png", "-r", ppp, pdf, Path(tmp) / "p"])
        for png in sorted(Path(tmp).glob("p-*.png"), key=lambda p: int(p.stem.split("-")[-1])):
            with Image.open(png) as im:
                r, g, b = im.convert("RGB").split()
            ecart = ImageChops.lighter(ImageChops.lighter(ImageChops.difference(r, g), ImageChops.difference(g, b)),
                                       ImageChops.difference(r, b))
            histo = ecart.histogram()
            n = sum(histo[ecart_max + 1:])
            if n:
                fautives.append((int(png.stem.split("-")[-1]), n))
    return fautives


def liens_internes(page):
    """Nombre d'annotations de lien qui pointent dans le document (destination ou action GoTo)."""
    n = 0
    for a in page.get("/Annots") or []:
        a = a.get_object()
        if a.get("/Subtype") != "/Link":
            continue
        action = a.get("/A")
        if a.get("/Dest") is not None or (action is not None and action.get_object().get("/S") == "/GoTo"):
            n += 1
    return n


def _jeton_mm(cle):
    """Longueur en mm d'un jeton de data/charte_tokens.csv (ex. « 10mm »)."""
    import csv
    with open(DATA / "charte_tokens.csv", newline="", encoding="utf-8") as f:
        jetons = {l["cle"]: l["valeur"] for l in csv.DictReader(f)}
    valeur = jetons.get(cle, "")
    if not valeur.endswith("mm"):
        raise ErreurOutillage(f"jeton « {cle} » absent ou pas en mm dans data/charte_tokens.csv")
    return float(valeur[:-2])


# --- Contrôle d'un PDF -------------------------------------------------------------------

def controler(pdf, fmt, titre, marque, pages_max):
    """Liste de Resultat pour un PDF d'un format donné."""
    pdf = Path(pdf)
    if not pdf.is_file():
        return [Resultat(fmt, "fichier", False, f"absent : {relatif(pdf)}")]
    try:
        lecteur = PdfReader(str(pdf))
        pages = lecteur.pages
        nb = len(pages)
    except Exception as e:
        return [Resultat(fmt, "fichier", False, f"PDF illisible : {e}")]
    res = [Resultat(fmt, "fichier", True, str(relatif(pdf)))]

    pol = polices(pdf)
    non_incorporees = [n for n, emb in pol if not emb]
    res.append(Resultat(fmt, "polices", bool(pol) and not non_incorporees,
                        f"{len(pol)} incorporées" if pol and not non_incorporees
                        else ("aucune police" if not pol else "non incorporées : " + ", ".join(non_incorporees))))

    meta = lecteur.metadata or {}
    t, a = (meta.get("/Title") or "").strip(), (meta.get("/Author") or "").strip()
    res.append(Resultat(fmt, "métadonnées", t == titre and a == marque,
                        f"Title « {t} », Author « {a} »" + ("" if t == titre and a == marque
                                                            else f" ; attendu « {titre} », « {marque} »")))

    borne = math.ceil(pages_max * reglage_nombre(f"controle_pages_facteur_{fmt}"))
    res.append(Resultat(fmt, "pages", 1 <= nb <= borne, f"{nb} (max {borne})"))

    vides = [i + 1 for i, p in enumerate(pages) if page_vide(lecteur, p)]
    res.append(Resultat(fmt, "pages blanches", not vides, "aucune" if not vides else f"pages {vides}"))

    marge = _jeton_mm(f"page.{fmt}.marge.x") * POINTS_PAR_MM
    hors = mots_hors_zone(pdf, marge, reglage_nombre("controle_debordement_tolerance_pt"))
    res.append(Resultat(fmt, "débordement", not hors, "aucun" if not hors else
                        "; ".join(f"p. {p} « {m} » x={x}" for p, m, x in hors[:5])
                        + (f" (+{len(hors) - 5})" if len(hors) > 5 else "")))

    if fmt == "nb":
        fautives = pixels_colores(pdf, reglage_entier("controle_nb_ppp"), reglage_entier("controle_nb_ecart_max"))
        total = sum(n for _, n in fautives)
        tolere = reglage_entier("controle_nb_pixels_max")
        res.append(Resultat(fmt, "sans couleur", total <= tolere,
                            "aucun pixel coloré" if not total else
                            f"{total} pixel(s) coloré(s) (tolérés : {tolere}) : "
                            + ", ".join(f"p. {p} : {n}" for p, n in fautives)))

    if fmt == "tablette":
        larg, haut = float(pages[0].mediabox.width), float(pages[0].mediabox.height)
        res.append(Resultat(fmt, "paysage", larg > haut, f"{larg:.0f} × {haut:.0f} pt"))
        par_page = [liens_internes(p) for p in pages]
        sans_lien = [i + 1 for i, n in enumerate(par_page) if i > 0 and n == 0]
        ok = par_page[0] > 0 and not sans_lien
        res.append(Resultat(fmt, "liens internes", ok,
                            f"{sum(par_page)} liens (sommaire p. 1 : {par_page[0]})"
                            + (f" ; pages sans retour au sommaire : {sans_lien}" if sans_lien else "")))
        signets = len(lecteur.outline or [])
        res.append(Resultat(fmt, "signets", signets > 0, f"{signets} au premier niveau"))
    return res


def controler_ensemble(pdfs, titre, marque, pages_max):
    """pdfs : {format: chemin}. Renvoie la liste de tous les Resultat."""
    res = []
    for fmt, pdf in pdfs.items():
        if fmt not in FORMATS_PDF:
            raise ErreurOutillage(f"format inconnu : {fmt} (attendu : {', '.join(FORMATS_PDF)})")
        res.extend(controler(pdf, fmt, titre, marque, pages_max))
    return res


def afficher(resultats):
    """Affiche un tableau lisible ; renvoie le nombre d'échecs."""
    echecs = 0
    for r in resultats:
        echecs += not r.ok
        print(f"  {'OK   ' if r.ok else 'ÉCHEC'} {r.fmt:<9} {r.nom:<16} {r.detail}")
    return echecs


def main():
    ap = argparse.ArgumentParser(description="Contrôle les PDF d'une variante.")
    ap.add_argument("variante", nargs="?", help="code de variante, ex. EN02-STD (contrôle les 4 formats)")
    ap.add_argument("--pdf", nargs="+", help="mode direct : PDF nommés <…>-<format>.pdf")
    ap.add_argument("--titre", help="mode direct : Title attendu")
    ap.add_argument("--marque", help="mode direct : Author attendu")
    ap.add_argument("--pages-max", type=int, help="mode direct : pages maximales en A4")
    a = ap.parse_args()
    if a.pdf:
        if a.variante or not (a.titre and a.marque and a.pages_max):
            ap.error("mode direct : --pdf, --titre, --marque et --pages-max ensemble, sans code de variante")
        pdfs = {}
        for f in a.pdf:
            fmt = Path(f).stem.rsplit("-", 1)[-1]
            if fmt not in FORMATS_PDF:
                ap.error(f"{f} : le nom doit finir par -{'/-'.join(FORMATS_PDF)}.pdf")
            pdfs[fmt] = Path(f)
        titre, marque, pages_max = a.titre, a.marque, a.pages_max
    elif a.variante:
        from build import donnees_variante  # import tardif : build importe ce module
        d = donnees_variante(a.variante)
        pdfs = {fmt: chemin_pdf(a.variante, fmt) for fmt in FORMATS_PDF}
        titre, marque, pages_max = d["entrees"]["titre"], d["entrees"]["marque"], d["pages_max"]
    else:
        ap.error("donner un code de variante, ou --pdf …")
    print(f"Contrôle : {a.variante or ', '.join(a.pdf)}")
    echecs = afficher(controler_ensemble(pdfs, titre, marque, pages_max))
    if echecs:
        raise ErreurOutillage(f"{echecs} contrôle(s) PDF en échec")
    print("Tous les contrôles passent.")
    return 0


if __name__ == "__main__":
    lancer(main)
