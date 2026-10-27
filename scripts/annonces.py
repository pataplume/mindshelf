"""Contrôle des textes d'annonce d'un produit.

produits/<CODE>/annonce/whop.md : sections « # Titre », « # Accroche », « # Description », « # Labels » (liste à puces) ;
  longueurs ≤ whop_titre_car_max, whop_accroche_car_max, whop_description_car_max.
produits/<CODE>/annonce/etsy/annonce.md, seulement si le produit a droit à Etsy (tables.etsy_autorise ;
  s'il n'y a pas droit, la présence du fichier est une erreur) : « # Titre » (≤ etsy_titre_mots_max mots,
  ≤ etsy_titre_car_max caractères, caractères admis par Etsy), « # Tags » (exactement etsy_tags_max tags,
  chacun ≤ etsy_tag_car_max caractères, caractères admis, sans doublon), « # Description », « # Visuels »
  (liste numérotée de chemins relatifs au dossier produit, qui doivent exister ; au plus etsy_photos_par_annonce_max
  images et etsy_videos_par_annonce_max vidéos).
Chaque mention de data/produit_mentions.csv doit figurer mot pour mot dans chaque description, dans la langue
du marché du produit. Les commentaires HTML (<!-- … -->) des gabarits sont ignorés partout.

Usage :
  python3 scripts/annonces.py EN02
  python3 scripts/annonces.py --dossier produits/_outillage-test --langue en --mentions A,B --etsy oui
Sortie : liste des erreurs ; code de sortie 1 s'il y en a.
"""
import argparse
import re
import sys
import unicodedata
from pathlib import Path

from tables import etsy_autorise
from outillage_commun import (dossier_produit, lancer, langue_produit, mentions_produit, produit, reglage,
                              reglage_entier, relatif, risques, textes_mentions)

SECTIONS_WHOP = ("Titre", "Accroche", "Description", "Labels")
SECTIONS_ETSY = ("Titre", "Tags", "Description", "Visuels")
EXTENSIONS_IMAGES = {".png", ".jpg", ".jpeg", ".gif", ".webp"}
EXTENSIONS_VIDEOS = {".mp4", ".mov", ".m4v", ".avi", ".flv", ".3gp", ".mpeg", ".mpg"}
PUCE = re.compile(r"^\s*[-*+](?:\s+(.*))?$")
NUMERO = re.compile(r"^\s*(\d+)[.)]\s+(.*)$")


# --- Lecture du Markdown ------------------------------------------------------------------------

def sans_commentaires(texte):
    return re.sub(r"<!--.*?-->", "", texte, flags=re.S)


def sections(chemin, attendues, erreurs):
    """{titre: texte} des sections de niveau 1 ; signale sections manquantes, inconnues, en double ou hors ordre."""
    texte = sans_commentaires(Path(chemin).read_text(encoding="utf-8")).replace("\r\n", "\n")
    trouvees, ordre, courante = {}, [], None
    for ligne in texte.split("\n"):
        m = re.match(r"^#\s+(.+?)\s*#*\s*$", ligne)
        if m:
            courante = m.group(1).strip()
            if courante in trouvees:
                erreurs.append(f"section « # {courante} » en double")
            trouvees[courante] = []
            ordre.append(courante)
        elif courante is not None:
            trouvees[courante].append(ligne)
        elif ligne.strip():
            erreurs.append(f"texte hors section : « {ligne.strip()[:60]} »")
    for s in ordre:
        if s not in attendues:
            erreurs.append(f"section inconnue « # {s} » (attendues : {', '.join(attendues)})")
    for s in attendues:
        if s not in trouvees:
            erreurs.append(f"section « # {s} » manquante")
    if [s for s in ordre if s in attendues] != [s for s in attendues if s in trouvees]:
        erreurs.append(f"sections dans le désordre (ordre attendu : {', '.join(attendues)})")
    return {s: "\n".join(lignes).strip() for s, lignes in trouvees.items()}


def une_ligne(texte, nom, erreurs):
    lignes = [l.strip() for l in texte.split("\n") if l.strip()]
    if not lignes:
        erreurs.append(f"{nom} vide")
        return ""
    if len(lignes) > 1:
        erreurs.append(f"{nom} sur {len(lignes)} lignes, une seule attendue")
    return " ".join(lignes)


def liste(texte, motif, nom, erreurs):
    """Éléments d'une liste (à puces ou numérotée) ; toute autre ligne non vide est une erreur."""
    elements = []
    for l in texte.split("\n"):
        if not l.strip():
            continue
        m = motif.match(l)
        if not m:
            erreurs.append(f"{nom} : ligne hors liste « {l.strip()[:60]} »")
            continue
        elements.append(tuple(g or "" for g in m.groups()))
    return elements


def longueur(texte):
    """Nombre de caractères tels qu'affichés (forme Unicode composée)."""
    return len(unicodedata.normalize("NFC", texte))


def plafond(nom, texte, cle, erreurs):
    maxi = reglage_entier(cle)
    n = longueur(texte)
    if n > maxi:
        erreurs.append(f"{nom} : {n} caractères, maximum {maxi} ({cle})")


def caracteres_interdits(texte, cle_categories, cle_speciaux):
    """Caractères absents des catégories Unicode et des caractères spéciaux admis."""
    categories = reglage(cle_categories).split()
    speciaux = set(reglage(cle_speciaux))
    return sorted({c for c in texte
                   if c not in speciaux and not any(unicodedata.category(c).startswith(cat) for cat in categories)})


def normaliser(texte):
    """Forme comparable : Unicode composé, blancs consécutifs (dont retours à la ligne) réduits à une espace."""
    return " ".join(unicodedata.normalize("NFC", texte).split())


def controler_mentions(description, mentions, nom, erreurs):
    """Chaque mention doit figurer mot pour mot (ponctuation et apostrophes comprises ;
    seul un retour à la ligne peut remplacer une espace)."""
    norm = normaliser(description)
    for code, texte in mentions:
        if normaliser(texte) not in norm:
            erreurs.append(f"{nom} : mention {code} absente ou modifiée (attendu mot pour mot : « {texte} »)")


# --- Whop ------------------------------------------------------------------------------------

def controler_whop(chemin, mentions):
    erreurs = []
    s = sections(chemin, SECTIONS_WHOP, erreurs)
    if "Titre" in s:
        plafond("Titre", une_ligne(s["Titre"], "Titre", erreurs), "whop_titre_car_max", erreurs)
    if "Accroche" in s:
        plafond("Accroche", une_ligne(s["Accroche"], "Accroche", erreurs), "whop_accroche_car_max", erreurs)
    if "Description" in s:
        if not s["Description"]:
            erreurs.append("Description vide")
        plafond("Description", s["Description"], "whop_description_car_max", erreurs)
        controler_mentions(s["Description"], mentions, "Description", erreurs)
    if "Labels" in s:
        labels = [g[0].strip() for g in liste(s["Labels"], PUCE, "Labels", erreurs)]
        if not labels:
            erreurs.append("Labels : aucun label (liste à puces attendue)")
        if any(not l for l in labels):
            erreurs.append("Labels : puce vide")
        doublons = sorted({l for l in labels if labels.count(l) > 1})
        if doublons:
            erreurs.append(f"Labels en double : {', '.join(doublons)}")
    return erreurs


# --- Etsy ------------------------------------------------------------------------------------

def controler_etsy(chemin, dossier, mentions):
    erreurs = []
    s = sections(chemin, SECTIONS_ETSY, erreurs)
    if "Titre" in s:
        titre = une_ligne(s["Titre"], "Titre", erreurs)
        mots = len(titre.split())
        maxi = reglage_entier("etsy_titre_mots_max")
        if mots > maxi:
            erreurs.append(f"Titre : {mots} mots, maximum {maxi} (etsy_titre_mots_max)")
        plafond("Titre", titre, "etsy_titre_car_max", erreurs)
        interdits = caracteres_interdits(titre, "etsy_titre_categories_unicode", "etsy_titre_car_speciaux")
        if interdits:
            erreurs.append(f"Titre : caractères refusés par Etsy : {' '.join(interdits)}")
        for c in reglage("etsy_titre_car_uniques"):
            if titre.count(c) > 1:
                erreurs.append(f"Titre : « {c} » utilisé {titre.count(c)} fois, une seule autorisée")
    if "Tags" in s:
        controler_tags(s["Tags"], erreurs)
    if "Description" in s:
        if not s["Description"]:
            erreurs.append("Description vide")
        controler_mentions(s["Description"], mentions, "Description", erreurs)
    if "Visuels" in s:
        controler_visuels(s["Visuels"], dossier, erreurs)
    return erreurs


def controler_tags(texte, erreurs):
    elements = [g[0].strip() for g in liste(texte, PUCE, "Tags", erreurs)]
    if len(elements) == 1 and "," in elements[0]:
        erreurs.append("Tags : un tag par puce, pas de liste séparée par des virgules")
    attendu = reglage_entier("etsy_tags_max")
    if len(elements) != attendu:
        erreurs.append(f"Tags : {len(elements)} tags, exactement {attendu} attendus (etsy_tags_max)")
    maxi = reglage_entier("etsy_tag_car_max")
    vus = {}
    for t in elements:
        if not t:
            erreurs.append("Tags : puce vide")
            continue
        if longueur(t) > maxi:
            erreurs.append(f"Tag « {t} » : {longueur(t)} caractères, maximum {maxi} (etsy_tag_car_max)")
        interdits = caracteres_interdits(t, "etsy_tag_categories_unicode", "etsy_tag_car_speciaux")
        if interdits:
            erreurs.append(f"Tag « {t} » : caractères refusés par Etsy : {' '.join(interdits)}")
        cle = " ".join(t.casefold().split())
        if cle in vus:
            erreurs.append(f"Tag « {t} » en double (déjà « {vus[cle]} »)")
        vus[cle] = t


def controler_visuels(texte, dossier, erreurs):
    elements = liste(texte, NUMERO, "Visuels", erreurs)
    if not elements:
        erreurs.append("Visuels : aucun visuel (liste numérotée attendue)")
        return
    numeros = [int(n) for n, _ in elements]
    if numeros != list(range(1, len(numeros) + 1)):
        erreurs.append(f"Visuels : numérotation {numeros}, attendu 1 à {len(numeros)} sans trou")
    images = videos = 0
    racine = Path(dossier).resolve()
    chemins = []
    for _, brut in elements:
        rel = brut.strip().strip("`").strip()
        chemin = (racine / rel).resolve()
        if Path(rel).is_absolute() or racine not in chemin.parents:
            erreurs.append(f"Visuels : « {rel} » doit être un chemin relatif dans le dossier produit")
            continue
        if rel in chemins:
            erreurs.append(f"Visuels : « {rel} » listé deux fois")
        chemins.append(rel)
        if not chemin.is_file():
            erreurs.append(f"Visuels : fichier introuvable « {rel} »")
        extension = chemin.suffix.lower()
        if extension in EXTENSIONS_IMAGES:
            images += 1
        elif extension in EXTENSIONS_VIDEOS:
            videos += 1
        else:
            erreurs.append(f"Visuels : « {rel} » n'est ni une image ni une vidéo reconnue")
    if images == 0:
        erreurs.append("Visuels : aucune image")
    for n, cle, nature in ((images, "etsy_photos_par_annonce_max", "images"),
                           (videos, "etsy_videos_par_annonce_max", "vidéos")):
        maxi = reglage_entier(cle)
        if n > maxi:
            erreurs.append(f"Visuels : {n} {nature}, maximum {maxi} ({cle})")


# --- Ensemble ----------------------------------------------------------------------------------

def controler_annonces(dossier, mentions, etsy):
    """Contrôle les annonces d'un dossier produit. mentions : [(code, texte)] dans la langue du marché ;
    etsy : True si le produit a droit à Etsy. Renvoie la liste des erreurs, préfixées par le fichier."""
    dossier = Path(dossier)
    whop = dossier / "annonce" / "whop.md"
    etsy_md = dossier / "annonce" / "etsy" / "annonce.md"
    erreurs = []
    if whop.is_file():
        erreurs += [f"{relatif(whop)} : {e}" for e in controler_whop(whop, mentions)]
    else:
        erreurs.append(f"{relatif(whop)} : fichier manquant")
    if etsy:
        if etsy_md.is_file():
            erreurs += [f"{relatif(etsy_md)} : {e}" for e in controler_etsy(etsy_md, dossier, mentions)]
        else:
            erreurs.append(f"{relatif(etsy_md)} : fichier manquant (le produit a droit à Etsy)")
    elif etsy_md.exists():
        erreurs.append(f"{relatif(etsy_md)} : le produit n'a pas droit à Etsy (risque IA), ce fichier ne doit pas exister")
    return erreurs


def annonces_produit(code_produit):
    p = produit(code_produit)
    mentions = mentions_produit(code_produit, langue_produit(p))
    return controler_annonces(dossier_produit(code_produit), mentions, etsy_autorise(p, risques()))


def main():
    ap = argparse.ArgumentParser(description="Contrôle des annonces Whop et Etsy d'un produit.")
    ap.add_argument("produit", nargs="?", help="code produit, ex. EN02")
    ap.add_argument("--dossier", help="usage direct : dossier produit contenant annonce/")
    ap.add_argument("--langue", help="usage direct : langue des mentions (en, fr)")
    ap.add_argument("--mentions", default="", help="usage direct : codes de mentions séparés par des virgules")
    ap.add_argument("--etsy", choices=("oui", "non"), help="usage direct : le produit a-t-il droit à Etsy")
    a = ap.parse_args()
    if a.dossier:
        if a.produit or not (a.langue and a.etsy):
            ap.error("usage direct : --dossier, --langue et --etsy ensemble, sans code produit")
        mentions = textes_mentions([c.strip() for c in a.mentions.split(",") if c.strip()], a.langue)
        erreurs, cible = controler_annonces(a.dossier, mentions, a.etsy == "oui"), a.dossier
    elif a.produit:
        erreurs, cible = annonces_produit(a.produit), a.produit
    else:
        ap.error("donner un code produit, ou --dossier, --langue et --etsy")
    if erreurs:
        print(f"{len(erreurs)} erreur(s) dans les annonces de {cible} :")
        for e in erreurs:
            print(f"  - {e}")
        return 1
    print(f"Annonces de {cible} conformes.")
    return 0


if __name__ == "__main__":
    lancer(main)
