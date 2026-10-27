"""Vidéo de feuilletage d'une variante, construite à partir de ses aperçus (pages puis extraits).

Chaque plan montre un aperçu centré sur un fond uni, avec un léger zoom (avant, puis arrière, en alternance)
et un fondu doux vers le plan suivant (par défaut en passant par le fond, pour ne jamais superposer deux pages
de texte). Les images sont composées avec Pillow (zoom sous-pixel, sans
saccade) et encodées par ffmpeg : MP4 H.264, yuv420p, sans piste audio.
Durée visée : milieu de [etsy_video_duree_min, etsy_video_duree_max]. Après encodage, ffprobe contrôle
durée, poids (< etsy_video_taille_max Mo), définition, codec et absence d'audio ; une vidéo non conforme
est supprimée et le script échoue.

Usage :
  python3 scripts/video_feuilletage.py EN02-STD
  python3 scripts/video_feuilletage.py --apercus dossier/apercus --sortie dossier/video/feuilletage.mp4
"""
import argparse
import json
import math
import re
import subprocess
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

from outillage_commun import (ErreurOutillage, dossier_produit, executer, lancer, relatif, reglage,
                              reglage_entier, reglage_nombre, variante)

MOTIF_PAGE = re.compile(r"^\d{2}-page-\d+\.png$")
MOTIF_EXTRAIT = re.compile(r"^\d{2}-extrait-.+\.png$")
OCTETS_PAR_MO = 1_000_000  # Mo décimal : plus strict que le Mio pour une limite exprimée en Mo
TYPES_TRANSITION = ("fondu_fond", "fondu_enchaine")


def images_du_dossier(dossier):
    """(pages, extraits) : PNG produits par apercus.py, dans l'ordre des visuels."""
    dossier = Path(dossier)
    if not dossier.is_dir():
        raise ErreurOutillage(f"dossier d'aperçus introuvable : {dossier} (lancer d'abord apercus.py)")
    noms = sorted(p.name for p in dossier.iterdir())
    pages = [dossier / n for n in noms if MOTIF_PAGE.match(n)]
    extraits = [dossier / n for n in noms if MOTIF_EXTRAIT.match(n)]
    if not pages:
        raise ErreurOutillage(f"aucune page NN-page-N.png dans {dossier} (lancer d'abord apercus.py)")
    return pages, extraits


# --- Réglages et plan de montage --------------------------------------------------------------

def reglages_video():
    r = {
        "duree_min": reglage_nombre("etsy_video_duree_min"),
        "duree_max": reglage_nombre("etsy_video_duree_max"),
        "taille_max_mo": reglage_nombre("etsy_video_taille_max"),
        "resolution_min": reglage_entier("etsy_video_resolution_min"),
        "largeur": reglage_entier("video_largeur_px"),
        "hauteur": reglage_entier("video_hauteur_px"),
        "ips": reglage_entier("video_ips"),
        "crf": reglage_entier("video_crf"),
        "preset": reglage("video_preset"),
        "transition": reglage_nombre("video_transition_s"),
        "transition_type": reglage("video_transition_type"),
        "plan_min": reglage_nombre("video_plan_min_s"),
        "pages_max": reglage_entier("video_pages_max"),
        "zoom_max": reglage_nombre("video_zoom_max"),
        "marge_pct": reglage_nombre("video_marge_pct"),
        "fond": reglage("video_fond_couleur"),
        "ombre_pct": reglage_nombre("video_ombre_pct"),
        "ombre_opacite": reglage_nombre("video_ombre_opacite"),
    }
    if r["largeur"] % 2 or r["hauteur"] % 2:
        raise ErreurOutillage("video_largeur_px et video_hauteur_px doivent être pairs (yuv420p)")
    if min(r["largeur"], r["hauteur"]) < r["resolution_min"]:
        raise ErreurOutillage(f"vidéo {r['largeur']}×{r['hauteur']} : plus petit côté sous "
                              f"etsy_video_resolution_min={r['resolution_min']}")
    if r["transition_type"] not in TYPES_TRANSITION:
        raise ErreurOutillage(f"video_transition_type « {r['transition_type']} » inconnu "
                              f"(attendu : {', '.join(TYPES_TRANSITION)})")
    if r["plan_min"] < 2 * r["transition"]:
        raise ErreurOutillage("video_plan_min_s doit valoir au moins deux fois video_transition_s")
    if r["zoom_max"] < 1 or r["pages_max"] < 1 or not 0 <= r["ombre_opacite"] <= 1:
        raise ErreurOutillage("video_zoom_max ≥ 1, video_pages_max ≥ 1 et 0 ≤ video_ombre_opacite ≤ 1 attendus")
    if not r["duree_min"] <= r["duree_max"]:
        raise ErreurOutillage("etsy_video_duree_min dépasse etsy_video_duree_max")
    return r


def plan_de_montage(pages, extraits, r):
    """Choisit les plans et leur durée pour viser le milieu de la plage de durée.
    Si les plans seraient trop courts, retire d'abord les pages après la première, puis les derniers extraits."""
    cible = (r["duree_min"] + r["duree_max"]) / 2
    pages, extraits = list(pages[:r["pages_max"]]), list(extraits)

    def duree_plan(n):
        return (cible + (n - 1) * r["transition"]) / n

    while len(pages) + len(extraits) > 1 and duree_plan(len(pages) + len(extraits)) < r["plan_min"]:
        if len(pages) > 1:
            pages.pop()
        else:
            extraits.pop()
    plans = pages + extraits
    return plans, duree_plan(len(plans)), cible


# --- Composition des images ------------------------------------------------------------------

def composer_plan(image, r):
    """Toile agrandie de zoom_max : l'aperçu centré, avec ombre douce, sur le fond.
    Le cadrage de chaque image de la vidéo est ensuite un sous-rectangle de cette toile."""
    cw, ch = round(r["largeur"] * r["zoom_max"]), round(r["hauteur"] * r["zoom_max"])
    toile = Image.new("RGB", (cw, ch), r["fond"])
    marge = r["marge_pct"] / 100 * ch
    with Image.open(image) as im:
        im = im.convert("RGB")
        echelle = min((cw - 2 * marge) / im.width, (ch - 2 * marge) / im.height)
        im = im.resize((max(1, round(im.width * echelle)), max(1, round(im.height * echelle))), Image.LANCZOS)
    x, y = (cw - im.width) // 2, (ch - im.height) // 2
    rayon = r["ombre_pct"] / 100 * ch
    if rayon > 0 and r["ombre_opacite"] > 0:
        masque = Image.new("L", (cw, ch), 0)
        decalage = round(rayon / 2)
        ImageDraw.Draw(masque).rectangle(
            (x, y + decalage, x + im.width, y + im.height + decalage), fill=round(255 * r["ombre_opacite"]))
        masque = masque.filter(ImageFilter.GaussianBlur(rayon))
        toile = Image.composite(Image.new("RGB", (cw, ch), (0, 0, 0)), toile, masque)
    toile.paste(im, (x, y))
    return toile


def cadrer(toile, zoom, r):
    """Image de la vidéo : toile vue au facteur zoom (1 = toile entière, zoom_max = détail 1:1)."""
    cw, ch = toile.size
    bw, bh = cw / zoom, ch / zoom
    x0, y0 = (cw - bw) / 2, (ch - bh) / 2
    return toile.resize((r["largeur"], r["hauteur"]), Image.BICUBIC, box=(x0, y0, x0 + bw, y0 + bh))


def lisse(t):
    t = min(1.0, max(0.0, t))
    return t * t * (3 - 2 * t)


def images_video(toiles, duree_plan, cible, r):
    """Génère les images successives : zoom linéaire par plan, fondu lissé entre plans
    (video_transition_type : fondu_fond ou fondu_enchaine)."""
    n_images = round(cible * r["ips"])
    pas = duree_plan - r["transition"]
    fond = Image.new("RGB", (r["largeur"], r["hauteur"]), r["fond"])
    for k in range(n_images):
        t = k / r["ips"]
        actifs = [i for i in range(len(toiles)) if i * pas <= t < i * pas + duree_plan] or [len(toiles) - 1]
        vues = []
        for i in actifs[:2]:
            p = min(1.0, max(0.0, (t - i * pas) / duree_plan))
            gain = (r["zoom_max"] - 1) * (p if i % 2 == 0 else 1 - p)
            vues.append((i, cadrer(toiles[i], 1 + gain, r)))
        if len(vues) == 2:
            alpha = (t - vues[1][0] * pas) / r["transition"]
            if r["transition_type"] == "fondu_enchaine":
                yield Image.blend(vues[0][1], vues[1][1], lisse(alpha))
            elif alpha < 0.5:  # fondu par le fond : la sortante s'efface, puis l'entrante apparaît
                yield Image.blend(vues[0][1], fond, lisse(2 * alpha))
            else:
                yield Image.blend(fond, vues[1][1], lisse(2 * alpha - 1))
        else:
            yield vues[0][1]


# --- Encodage et contrôle --------------------------------------------------------------------

def encoder(images, sortie, r):
    commande = ["ffmpeg", "-y", "-loglevel", "error",
                "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{r['largeur']}x{r['hauteur']}",
                "-r", str(r["ips"]), "-i", "-",
                "-an", "-c:v", "libx264", "-preset", r["preset"], "-crf", str(r["crf"]),
                "-pix_fmt", "yuv420p", "-movflags", "+faststart", str(sortie)]
    proc = subprocess.Popen(commande, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
    try:
        for im in images:
            proc.stdin.write(im.tobytes())
        proc.stdin.close()
    except BrokenPipeError:
        pass
    erreur = proc.stderr.read().decode(errors="replace").strip()
    if proc.wait() != 0:
        raise ErreurOutillage(f"ffmpeg a échoué : {erreur}")


def sonder(video):
    """Durée (s), poids (octets) et flux de la vidéo, lus par ffprobe."""
    sortie = executer(["ffprobe", "-v", "error", "-show_entries",
                       "format=duration,size:stream=codec_type,codec_name,width,height,pix_fmt",
                       "-of", "json", video])
    info = json.loads(sortie)
    return {"duree": float(info["format"]["duration"]), "taille": int(info["format"]["size"]),
            "flux": info.get("streams", [])}


def controler(video, r):
    """Liste des écarts aux règles (vide si la vidéo est conforme)."""
    s = sonder(video)
    ecarts = []
    if not r["duree_min"] <= s["duree"] <= r["duree_max"]:
        ecarts.append(f"durée {s['duree']:.2f} s hors de [{r['duree_min']:g}, {r['duree_max']:g}] s")
    if s["taille"] >= r["taille_max_mo"] * OCTETS_PAR_MO:
        ecarts.append(f"poids {s['taille'] / OCTETS_PAR_MO:.1f} Mo, limite {r['taille_max_mo']:g} Mo")
    videos = [f for f in s["flux"] if f.get("codec_type") == "video"]
    if any(f.get("codec_type") == "audio" for f in s["flux"]):
        ecarts.append("piste audio présente")
    if len(videos) != 1:
        ecarts.append(f"{len(videos)} flux vidéo au lieu de 1")
    for f in videos:
        if f.get("codec_name") != "h264" or f.get("pix_fmt") != "yuv420p":
            ecarts.append(f"codage {f.get('codec_name')}/{f.get('pix_fmt')} au lieu de h264/yuv420p")
        if min(f.get("width", 0), f.get("height", 0)) < r["resolution_min"]:
            ecarts.append(f"définition {f.get('width')}×{f.get('height')} sous {r['resolution_min']} px")
    return s, ecarts


def generer_video(pages, extraits, sortie):
    """Construit la vidéo à partir de listes explicites de PNG (pages puis extraits).
    Renvoie un dictionnaire : plans retenus, durée et poids mesurés. Échoue si la vidéo n'est pas conforme."""
    r = reglages_video()
    if not pages:
        raise ErreurOutillage("aucune page à montrer")
    for image in list(pages) + list(extraits):
        if not Path(image).is_file():
            raise ErreurOutillage(f"aperçu introuvable : {image}")
    plans, duree_plan, cible = plan_de_montage(pages, extraits, r)
    sortie = Path(sortie)
    sortie.parent.mkdir(parents=True, exist_ok=True)
    toiles = [composer_plan(p, r) for p in plans]
    encoder(images_video(toiles, duree_plan, cible, r), sortie, r)
    mesure, ecarts = controler(sortie, r)
    if ecarts:
        sortie.unlink(missing_ok=True)
        raise ErreurOutillage(f"vidéo non conforme, supprimée : {' ; '.join(ecarts)}")
    return {"plans": plans, "duree_plan": duree_plan, "duree": mesure["duree"], "taille": mesure["taille"],
            "definition": (r["largeur"], r["hauteur"])}


def video_variante(code_variante):
    dossier = dossier_produit(variante(code_variante)["produit_code"])
    pages, extraits = images_du_dossier(dossier / "apercus")
    return generer_video(pages, extraits, dossier / "video" / "feuilletage.mp4"), dossier / "video" / "feuilletage.mp4"


def main():
    ap = argparse.ArgumentParser(description="Vidéo de feuilletage MP4 à partir des aperçus.")
    ap.add_argument("variante", nargs="?", help="code de variante, ex. EN02-STD")
    ap.add_argument("--apercus", help="usage direct : dossier des aperçus")
    ap.add_argument("--sortie", help="usage direct : fichier MP4 à écrire")
    a = ap.parse_args()
    if a.apercus or a.sortie:
        if a.variante or not (a.apercus and a.sortie):
            ap.error("usage direct : --apercus et --sortie ensemble, sans code de variante")
        resultat, sortie = generer_video(*images_du_dossier(a.apercus), a.sortie), Path(a.sortie)
    elif a.variante:
        resultat, sortie = video_variante(a.variante)
    else:
        ap.error("donner un code de variante, ou --apercus et --sortie")
    print(f"{relatif(sortie)}  {resultat['definition'][0]}×{resultat['definition'][1]}, "
          f"{resultat['duree']:.2f} s, {resultat['taille'] / OCTETS_PAR_MO:.2f} Mo, "
          f"{len(resultat['plans'])} plans de {resultat['duree_plan']:.2f} s")
    for p in resultat["plans"]:
        print(f"  {Path(p).name}")


if __name__ == "__main__":
    lancer(main)
