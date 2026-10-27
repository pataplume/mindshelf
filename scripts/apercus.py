"""Aperçus d'annonce d'une variante, rendus fidèles du PDF A4 (jamais d'image générée par IA) :
  1. chaque page en PNG haute définition ;
  2. des recadrages d'extraits lisibles, définis par produits/<CODE>/donnees/extraits.csv
     (ordre,page,x_pct,y_pct,l_pct,h_pct,libelle ; origine en haut à gauche, en % de la page),
     sinon le haut et le bas de la page 1 ;
  3. si produits/<CODE>/donnees/contenu.csv existe (ordre,element), une vignette « ce qu'il y a dedans »
     composée par Typst : miniature de la page 1 et liste des éléments, sans autre contenu.

Nommage dans l'ordre des visuels d'annonce : 01-page-1.png, 02-page-2.png, …, puis NN-extrait-<libellé>.png,
puis NN-contenu.png. Les anciens fichiers de ce type sont supprimés avant chaque rendu.

Usage :
  python3 scripts/apercus.py EN02-STD
  python3 scripts/apercus.py --pdf fiche-a4.pdf --sortie apercus/ [--extraits extraits.csv]
                             [--contenu contenu.csv --langue en --titre "Titre"]
"""
import argparse
import json
import re
import shutil
import tempfile
from pathlib import Path

from PIL import Image
from pypdf import PdfReader

from outillage_commun import (RACINE, ErreurOutillage, chemin_pdf, dossier_produit, executer, langue_produit,
                              lancer, libelle, lire_csv, produit_de_variante, relatif, reglage,
                              reglage_entier, reglage_nombre, slug, variante)

COLONNES_EXTRAITS = ("ordre", "page", "x_pct", "y_pct", "l_pct", "h_pct", "libelle")
COLONNES_CONTENU = ("ordre", "element")
MOTIF_GENERE = re.compile(r"^\d{2}-(page-\d+|extrait-.+|contenu)\.png$")
GABARIT_VIGNETTE = Path(__file__).resolve().parent / "gabarits" / "vignette_contenu.typ"


# --- PDF ---------------------------------------------------------------------------------

def _pages(pdf):
    try:
        return PdfReader(str(pdf)).pages
    except Exception as e:
        raise ErreurOutillage(f"PDF illisible : {pdf} ({e})")


def taille_page_pt(page):
    """(largeur, hauteur) affichées d'une page pypdf, en points, rotation comprise."""
    largeur, hauteur = float(page.cropbox.width), float(page.cropbox.height)  # zone visible ; pdftoppm est appelé avec -cropbox
    if (page.get("/Rotate") or 0) % 180:
        largeur, hauteur = hauteur, largeur
    return largeur, hauteur


def rendre_page(pdf, num_page, sortie_png, largeur_px):
    """Rend une page entière à la largeur demandée (hauteur proportionnelle)."""
    base = Path(sortie_png).with_suffix("")
    executer(["pdftoppm", "-png", "-cropbox", "-f", num_page, "-l", num_page, "-scale-to-x", largeur_px,
              "-scale-to-y", -1, "-singlefile", pdf, base])
    return Path(sortie_png)


def rendre_zone(pdf, num_page, taille_pt, zone, sortie_png, largeur_px):
    """Rend la zone (x, y, l, h en % de la page) d'une page, agrandie à largeur_px."""
    x, y, l, h = zone
    larg_pt, haut_pt = taille_pt
    ppp = largeur_px * 72 / (l / 100 * larg_pt)
    echelle = ppp / 72
    executer(["pdftoppm", "-png", "-cropbox", "-f", num_page, "-l", num_page, "-r", f"{ppp:.4f}",
              "-x", round(x / 100 * larg_pt * echelle), "-y", round(y / 100 * haut_pt * echelle),
              "-W", largeur_px, "-H", round(h / 100 * haut_pt * echelle), "-singlefile",
              pdf, Path(sortie_png).with_suffix("")])
    return Path(sortie_png)


# --- Données ------------------------------------------------------------------------------

def _nombre(ligne, cle, chemin):
    try:
        return float(ligne[cle].replace(",", "."))
    except ValueError:
        raise ErreurOutillage(f"{chemin} : {cle}=« {ligne[cle]} » n'est pas un nombre (ligne ordre={ligne['ordre']})")


def lire_extraits(chemin, nb_pages):
    """Zones d'extraits validées et triées par ordre."""
    extraits = []
    for l in lire_csv(chemin, COLONNES_EXTRAITS):
        x, y, lg, ht = (_nombre(l, c, chemin) for c in ("x_pct", "y_pct", "l_pct", "h_pct"))
        page = int(_nombre(l, "page", chemin))
        ou = f"{chemin} (ordre={l['ordre']})"
        if not 1 <= page <= nb_pages:
            raise ErreurOutillage(f"{ou} : page {page} hors du PDF ({nb_pages} pages)")
        if min(x, y) < 0 or lg <= 0 or ht <= 0 or x + lg > 100 or y + ht > 100:
            raise ErreurOutillage(f"{ou} : zone hors page (x={x}, y={y}, l={lg}, h={ht} en %)")
        if not l["libelle"]:
            raise ErreurOutillage(f"{ou} : libelle vide")
        extraits.append({"ordre": _nombre(l, "ordre", chemin), "page": page, "zone": (x, y, lg, ht),
                         "libelle": l["libelle"]})
    if not extraits:
        raise ErreurOutillage(f"{chemin} : aucun extrait")
    libelles = [slug(e["libelle"]) for e in extraits]
    doublons = {s for s in libelles if libelles.count(s) > 1}
    if doublons:
        raise ErreurOutillage(f"{chemin} : libellés en double ({', '.join(sorted(doublons))})")
    return sorted(extraits, key=lambda e: e["ordre"])


def extraits_par_defaut():
    """Haut et bas de la page 1, sans les marges latérales, agrandis à apercu_extrait_largeur_px."""
    h = reglage_nombre("apercu_extrait_defaut_hauteur_pct")
    m = reglage_nombre("apercu_extrait_defaut_marge_pct")
    if not (0 < h <= 50 and 0 <= m < 50):
        raise ErreurOutillage("apercu_extrait_defaut_hauteur_pct dans ]0, 50] et apercu_extrait_defaut_marge_pct "
                              "dans [0, 50[ attendus")
    return [{"page": 1, "zone": (m, 0, 100 - 2 * m, h), "libelle": "haut-page-1"},
            {"page": 1, "zone": (m, 100 - h, 100 - 2 * m, h), "libelle": "bas-page-1"}]


def lire_contenu(chemin):
    lignes = lire_csv(chemin, COLONNES_CONTENU)
    elements = [l["element"] for l in sorted(lignes, key=lambda l: _nombre(l, "ordre", chemin)) if l["element"]]
    if not elements:
        raise ErreurOutillage(f"{chemin} : aucun élément")
    return elements


# --- Vignette « ce qu'il y a dedans » ----------------------------------------------------------

def generer_vignette(elements, sortie_png, langue, titre="", image_page=None):
    """Vignette composée par Typst : titre, rubrique traduite, liste des éléments, miniature de la page.
    Les éléments sont affichés tels quels (texte brut, pas de balisage Typst)."""
    import typst
    largeur = reglage_entier("apercu_vignette_largeur_px")
    hauteur = reglage_entier("apercu_vignette_hauteur_px")
    ppp = 144  # résolution de travail : 1 pt Typst = 2 px
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        image, ratio = None, None
        if image_page:
            with Image.open(image_page) as im:
                im = im.convert("RGB")
                im.thumbnail((largeur, hauteur), Image.LANCZOS)
                im.save(tmp / "page.png")
                ratio = im.width / im.height
            image = "page.png"
        donnees = {
            "largeur_pt": largeur * 72 / ppp, "hauteur_pt": hauteur * 72 / ppp,
            "police": reglage("apercu_vignette_police"), "langue": langue,
            "graisse_titre": reglage_entier("apercu_vignette_graisse_titre"),
            "graisse_rubrique": reglage_entier("apercu_vignette_graisse_rubrique"),
            "echelle_min": reglage_nombre("apercu_vignette_echelle_min"),
            "echelle_pas": reglage_nombre("apercu_vignette_echelle_pas"),
            "fond": reglage("apercu_vignette_fond_couleur"), "texte": reglage("apercu_vignette_texte_couleur"),
            "accent": reglage("apercu_vignette_accent_couleur"),
            "titre": titre, "rubrique": libelle("vignette_rubrique", langue),
            "elements": list(elements), "image": image, "image_ratio": ratio,
        }
        polices = RACINE / reglage("apercu_vignette_polices_dossier")
        shutil.copy(GABARIT_VIGNETTE, tmp / "vignette.typ")
        try:
            pages, alertes = typst.compile_with_warnings(
                str(tmp / "vignette.typ"), root=str(tmp), format="png", ppi=float(ppp),
                font_paths=[str(polices)] if polices.is_dir() else [],
                sys_inputs={"donnees": json.dumps(donnees, ensure_ascii=False)})
        except Exception as e:
            raise ErreurOutillage(f"vignette : compilation Typst impossible ({e})")
    alertes = [str(getattr(a, "message", a)) for a in alertes]
    if alertes:  # ex. police introuvable : Typst se replierait sans le dire sur une autre police
        raise ErreurOutillage("vignette : " + " ; ".join(alertes))
    if isinstance(pages, list):
        raise ErreurOutillage(f"vignette : le contenu déborde sur {len(pages)} pages, réduire contenu.csv")
    Path(sortie_png).write_bytes(pages)
    return Path(sortie_png)


# --- Ensemble ----------------------------------------------------------------------------------

def generer_apercus(pdf, sortie, extraits=None, contenu=None, langue=None, titre=""):
    """Rend pages, extraits et vignette du PDF `pdf` dans le dossier `sortie`.
    extraits : chemin d'un extraits.csv, ou None pour les recadrages par défaut.
    contenu : chemin d'un contenu.csv, ou None pour ne pas faire de vignette (langue alors obligatoire).
    Renvoie la liste ordonnée des PNG produits."""
    pdf, sortie = Path(pdf), Path(sortie)
    if not pdf.is_file():
        raise ErreurOutillage(f"PDF introuvable : {pdf}")
    if contenu and not langue:
        raise ErreurOutillage("la vignette demande une langue (en, fr)")
    largeur_min = reglage_entier("apercu_largeur_min_px")
    larg_page = reglage_entier("apercu_page_largeur_px")
    larg_extrait = reglage_entier("apercu_extrait_largeur_px")
    for cle, valeur in (("apercu_page_largeur_px", larg_page), ("apercu_extrait_largeur_px", larg_extrait)):
        if valeur < largeur_min:
            raise ErreurOutillage(f"{cle}={valeur} est sous apercu_largeur_min_px={largeur_min}")

    pages = _pages(pdf)
    zones = lire_extraits(extraits, len(pages)) if extraits else extraits_par_defaut()
    elements = lire_contenu(contenu) if contenu else None

    sortie.mkdir(parents=True, exist_ok=True)
    for ancien in sortie.iterdir():
        if MOTIF_GENERE.match(ancien.name):
            ancien.unlink()

    produits, rang = [], 0
    for num in range(1, len(pages) + 1):
        rang += 1
        produits.append(rendre_page(pdf, num, sortie / f"{rang:02d}-page-{num}.png", larg_page))
    for e in zones:
        rang += 1
        produits.append(rendre_zone(pdf, e["page"], taille_page_pt(pages[e["page"] - 1]), e["zone"],
                                    sortie / f"{rang:02d}-extrait-{slug(e['libelle'])}.png", larg_extrait))
    if elements:
        rang += 1
        produits.append(generer_vignette(elements, sortie / f"{rang:02d}-contenu.png", langue, titre, produits[0]))

    for png in produits:
        if not png.is_file():
            raise ErreurOutillage(f"rendu manquant : {png}")
        with Image.open(png) as im:
            if im.width < largeur_min:
                raise ErreurOutillage(f"{png.name} : {im.width} px de large, sous apercu_largeur_min_px={largeur_min}")
    return produits


def apercus_variante(code_variante):
    """Résout les chemins d'une variante via les tables, puis génère ses aperçus."""
    v = variante(code_variante)
    p = produit_de_variante(code_variante)
    dossier = dossier_produit(v["produit_code"])
    extraits = dossier / "donnees" / "extraits.csv"
    contenu = dossier / "donnees" / "contenu.csv"
    return generer_apercus(chemin_pdf(code_variante, "a4"), dossier / "apercus",
                           extraits if extraits.exists() else None,
                           contenu if contenu.exists() else None,
                           langue_produit(p), p["titre_travail"])


def main():
    ap = argparse.ArgumentParser(description="Aperçus PNG d'une variante (pages, extraits, vignette).")
    ap.add_argument("variante", nargs="?", help="code de variante, ex. EN02-STD")
    ap.add_argument("--pdf", help="usage direct : PDF A4 à rendre")
    ap.add_argument("--sortie", help="usage direct : dossier de sortie")
    ap.add_argument("--extraits", help="usage direct : extraits.csv")
    ap.add_argument("--contenu", help="usage direct : contenu.csv (vignette)")
    ap.add_argument("--langue", help="usage direct : langue de la vignette (en, fr)")
    ap.add_argument("--titre", default="", help="usage direct : titre affiché sur la vignette")
    a = ap.parse_args()
    if a.pdf or a.sortie:
        if a.variante or not (a.pdf and a.sortie):
            ap.error("usage direct : --pdf et --sortie ensemble, sans code de variante")
        fichiers = generer_apercus(a.pdf, a.sortie, a.extraits, a.contenu, a.langue, a.titre)
    elif a.variante:
        fichiers = apercus_variante(a.variante)
    else:
        ap.error("donner un code de variante, ou --pdf et --sortie")
    for f in fichiers:
        with Image.open(f) as im:
            print(f"{relatif(f)}  {im.width}×{im.height}")


if __name__ == "__main__":
    lancer(main)
