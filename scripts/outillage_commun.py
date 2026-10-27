"""Fonctions communes aux scripts d'outillage (aperçus, vidéo, Anki, annonces) :
résolution des chemins d'une variante, lecture des réglages, mentions, appel d'outils externes."""
import csv
import re
import subprocess
import sys
import unicodedata
from pathlib import Path

from tables import RACINE, DATA, lire, index, param

SCRIPTS = Path(__file__).resolve().parent
PRODUITS = RACINE / "produits"
FORMATS_PDF = ("a4", "letter", "nb", "tablette")

# Réglages techniques de l'outillage en attente de fusion dans data/parametres.csv
# (couleurs et police : dans data/charte_tokens.csv). Dès qu'une clé existe dans data/, c'est elle qui compte.
REGLAGES_EN_ATTENTE = SCRIPTS / "parametres_outillage.csv"
# Textes affichés par les outils (vignette, champs Anki), une ligne par clé et par langue.
LIBELLES = SCRIPTS / "libelles_outillage.csv"


class ErreurOutillage(Exception):
    """Erreur attendue (donnée manquante ou invalide) : message lisible, sans trace Python."""


# --- Réglages -----------------------------------------------------------------

def _cle_valeur(chemin):
    if not chemin.exists():
        return {}
    with open(chemin, newline="", encoding="utf-8") as f:
        return {l["cle"]: l["valeur"] for l in csv.DictReader(f)}


def reglage(cle):
    """Valeur d'un réglage : data/parametres.csv (tables.param), sinon scripts/parametres_outillage.csv.
    Une valeur « charte:<clé> » renvoie au jeton <clé> de data/charte_tokens.csv.
    Échoue si la clé n'existe nulle part."""
    valeur = ""
    try:
        valeur = param(cle)
    except KeyError:
        pass
    if valeur == "":
        valeur = _cle_valeur(REGLAGES_EN_ATTENTE).get(cle, "")
    if valeur == "":
        raise ErreurOutillage(
            f"réglage « {cle} » introuvable (data/parametres.csv, scripts/{REGLAGES_EN_ATTENTE.name})")
    if valeur.startswith("charte:"):
        jeton = valeur.split(":", 1)[1]
        valeur = _cle_valeur(DATA / "charte_tokens.csv").get(jeton, "")
        if valeur == "":
            raise ErreurOutillage(f"réglage « {cle} » : jeton « {jeton} » absent de data/charte_tokens.csv")
    return valeur


def reglage_nombre(cle):
    valeur = reglage(cle)
    try:
        return float(valeur)
    except ValueError:
        raise ErreurOutillage(f"réglage « {cle} » : « {valeur} » n'est pas un nombre")


def reglage_entier(cle):
    nombre = reglage_nombre(cle)
    if nombre != int(nombre):
        raise ErreurOutillage(f"réglage « {cle} » : {nombre} n'est pas un entier")
    return int(nombre)


def libelle(cle, langue):
    """Texte d'interface d'un outil dans la langue demandée (scripts/libelles_outillage.csv)."""
    with open(LIBELLES, newline="", encoding="utf-8") as f:
        textes = {(l["cle"], l["langue"]): l["texte"] for l in csv.DictReader(f)}
    texte = textes.get((cle, langue), "")
    if not texte:
        raise ErreurOutillage(f"libellé « {cle} » absent pour la langue « {langue} » (scripts/{LIBELLES.name})")
    return texte


# --- Tables : variante, produit, marché, mentions ------------------------------------

def variante(code_variante):
    ligne = index(lire("variantes.csv")).get(code_variante)
    if ligne is None:
        raise ErreurOutillage(f"variante inconnue : {code_variante} (data/variantes.csv)")
    return ligne


def produit(code_produit):
    ligne = index(lire("produits.csv")).get(code_produit)
    if ligne is None:
        raise ErreurOutillage(f"produit inconnu : {code_produit} (data/produits.csv)")
    return ligne


def produit_de_variante(code_variante):
    return produit(variante(code_variante)["produit_code"])


def langue_produit(ligne_produit):
    return index(lire("marches.csv"))[ligne_produit["marche_code"]]["langue"]


def risques():
    return index(lire("risques_ia.csv"))


def textes_mentions(codes, langue):
    """[(code, texte)] des mentions demandées, dans la langue demandée ;
    si le texte de cette langue est vide, celui d'une autre langue (data/mentions.csv)."""
    mentions = index(lire("mentions.csv"))
    inconnus = [c for c in codes if c not in mentions]
    if inconnus:
        raise ErreurOutillage(f"mentions inconnues : {', '.join(inconnus)} (data/mentions.csv)")
    resultat = []
    for code in codes:
        m = mentions[code]
        colonnes = [f"texte_{langue}"] + sorted(c for c in m if c.startswith("texte_") and c != f"texte_{langue}")
        texte = next((m[c].strip() for c in colonnes if (m.get(c) or "").strip()), "")
        if not texte:
            raise ErreurOutillage(f"mention {code} sans texte (data/mentions.csv)")
        resultat.append((code, texte))
    return resultat


def mentions_produit(code_produit, langue):
    """[(code, texte)] des mentions du produit (data/produit_mentions.csv), dans la langue demandée."""
    codes = [l["mention_code"] for l in lire("produit_mentions.csv") if l["produit_code"] == code_produit]
    return textes_mentions(codes, langue)


# --- Chemins d'un produit ----------------------------------------------------------

def dossier_produit(code_produit):
    return PRODUITS / code_produit


def dossier_livraison(code_variante):
    return dossier_produit(variante(code_variante)["produit_code"]) / "livraison" / code_variante


def chemin_pdf(code_variante, format_pdf="a4"):
    """produits/<CODE>/livraison/<VARIANTE>/<CODE>-<VARIANTE>-<format>.pdf (convention du pipeline)."""
    if format_pdf not in FORMATS_PDF:
        raise ErreurOutillage(f"format inconnu : {format_pdf} (attendu : {', '.join(FORMATS_PDF)})")
    code = variante(code_variante)["produit_code"]
    return dossier_livraison(code_variante) / f"{code}-{code_variante}-{format_pdf}.pdf"


def chemin_apkg(code_variante):
    code = variante(code_variante)["produit_code"]
    return dossier_livraison(code_variante) / f"{code}-{code_variante}.apkg"


# --- Divers ------------------------------------------------------------------------------

def lire_csv(chemin, colonnes):
    """Lit un CSV de données produit et vérifie que ses colonnes sont exactement celles attendues."""
    chemin = Path(chemin)
    if not chemin.is_file():
        raise ErreurOutillage(f"fichier introuvable : {chemin}")
    with open(chemin, newline="", encoding="utf-8-sig") as f:  # -sig : tolère le BOM d'un export tableur
        lecteur = csv.DictReader(f)
        entete = [c.strip() for c in (lecteur.fieldnames or [])]
        if entete != list(colonnes):
            raise ErreurOutillage(f"{chemin} : colonnes {entete}, attendu {list(colonnes)}")
        return [{k.strip(): (v or "").strip() for k, v in l.items()} for l in lecteur]


def slug(texte):
    texte = unicodedata.normalize("NFKD", texte).encode("ascii", "ignore").decode()
    return re.sub(r"[^a-z0-9]+", "-", texte.lower()).strip("-") or "sans-nom"


def executer(commande):
    """Lance un outil externe ; en cas d'échec, lève ErreurOutillage avec sa sortie d'erreur."""
    res = subprocess.run([str(c) for c in commande], capture_output=True, text=True)
    if res.returncode != 0:
        raise ErreurOutillage(f"{Path(str(commande[0])).name} a échoué ({res.returncode}) : {res.stderr.strip()}")
    return res.stdout


def relatif(chemin):
    """Chemin affiché relatif à la racine du dépôt quand c'est possible."""
    chemin = Path(chemin).resolve()
    try:
        return chemin.relative_to(RACINE)
    except ValueError:
        return chemin


def lancer(fonction):
    """Point d'entrée des CLI : une ErreurOutillage devient un message et le code de sortie 1."""
    try:
        code = fonction()
    except ErreurOutillage as e:
        print(f"ERREUR : {e}", file=sys.stderr)
        sys.exit(1)
    sys.exit(code or 0)
