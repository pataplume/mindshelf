"""Banc d'essai de l'outillage : régénère le PDF de test et exerce chaque script en mode chemins explicites.
Ce dossier n'est pas un produit (absent de data/produits.csv) : rien ici n'est publié.

Usage : python3 produits/_outillage-test/prepare.py      (code de sortie 1 au premier échec)
Les mentions contrôlées sont celles d'EN02 (marché EN), lues dans data/.
"""
import subprocess
import sys
from pathlib import Path

import typst

ICI = Path(__file__).resolve().parent
RACINE = ICI.parent.parent
SCRIPTS = RACINE / "scripts"
PRODUIT_REFERENCE = "EN02"  # produit réel dont on emprunte les mentions et le droit à Etsy

sys.path.insert(0, str(SCRIPTS))
from outillage_commun import langue_produit, produit  # noqa: E402
from tables import etsy_autorise, lire, index  # noqa: E402


def lancer(*args):
    print("$", " ".join(str(a) for a in args))
    res = subprocess.run([sys.executable, *map(str, args)], cwd=RACINE)
    if res.returncode != 0:
        sys.exit(f"échec : {args[0]}")


def main():
    pdf = ICI / "livraison" / "test-a4.pdf"
    pdf.parent.mkdir(parents=True, exist_ok=True)
    typst.compile(str(ICI / "src" / "fiche.typ"), output=str(pdf), root=str(RACINE))
    print(f"PDF : {pdf.relative_to(RACINE)}")

    p = produit(PRODUIT_REFERENCE)
    langue = langue_produit(p)
    mentions = [l["mention_code"] for l in lire("produit_mentions.csv") if l["produit_code"] == PRODUIT_REFERENCE]
    etsy = "oui" if etsy_autorise(p, index(lire("risques_ia.csv"))) else "non"

    lancer(SCRIPTS / "apercus.py", "--pdf", pdf, "--sortie", ICI / "apercus",
           "--extraits", ICI / "donnees" / "extraits.csv", "--contenu", ICI / "donnees" / "contenu.csv",
           "--langue", langue, "--titre", f"{p['titre_travail']} — test bench")
    lancer(SCRIPTS / "video_feuilletage.py", "--apercus", ICI / "apercus", "--sortie", ICI / "video" / "feuilletage.mp4")
    lancer(SCRIPTS / "anki.py", "--cartes", ICI / "donnees" / "cartes.csv", "--sortie", ICI / "livraison" / "test.apkg",
           "--cle", "TEST-OUTILLAGE", "--nom", p["titre_travail"], "--langue", langue)
    lancer(SCRIPTS / "annonces.py", "--dossier", ICI, "--langue", langue, "--mentions", ",".join(mentions),
           "--etsy", etsy)
    print("Banc d'essai : tout passe.")


if __name__ == "__main__":
    main()
