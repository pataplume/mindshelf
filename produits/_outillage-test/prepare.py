"""Banc d'essai de l'outillage : régénère le PDF de test et exerce chaque script en mode chemins explicites.
Ce dossier n'est pas un produit (absent de data/produits.csv) : rien ici n'est publié.

Usage : python3 produits/_outillage-test/prepare.py      (code de sortie 1 au premier échec)
Les mentions contrôlées sont celles d'EN02 (marché EN), lues dans data/.
Tests négatifs : double signe moins (controle_pdf.py) et marqueurs de cartes.csv (anki.py), dans un dossier temporaire.
"""
import subprocess
import sys
import tempfile
from pathlib import Path

import typst

ICI = Path(__file__).resolve().parent
RACINE = ICI.parent.parent
SCRIPTS = RACINE / "scripts"
PRODUIT_REFERENCE = "EN02"  # produit réel dont on emprunte les mentions et le droit à Etsy

sys.path.insert(0, str(SCRIPTS))
from outillage_commun import langue_produit, produit  # noqa: E402
from tables import etsy_autorise, lire, index  # noqa: E402
import controle_pdf  # noqa: E402
from anki import relire_paquet  # noqa: E402

POLICES = RACINE / "charte" / "polices"


def lancer(*args):
    print("$", " ".join(str(a) for a in args))
    res = subprocess.run([sys.executable, *map(str, args)], cwd=RACINE)
    if res.returncode != 0:
        sys.exit(f"échec : {args[0]}")


def lancer_echec(*args):
    """Lance un script qui doit échouer (code 1) : test négatif."""
    print("$ (doit échouer)", " ".join(str(a) for a in args))
    res = subprocess.run([sys.executable, *map(str, args)], cwd=RACINE, capture_output=True, text=True)
    if res.returncode != 1:
        sys.exit(f"test négatif : {args[0]} aurait dû échouer (code {res.returncode})")
    print("  échec attendu :", (res.stdout + res.stderr).strip().splitlines()[-1])


def compiler(source, pdf):
    """Compile avec les polices de la charte seules (comme scripts/build.py) : rendu reproductible."""
    typst.compile(str(source), output=str(pdf), root=str(RACINE), font_paths=[str(POLICES)],
                  ignore_system_fonts=True)


def teste_double_moins(tmp):
    """controle_pdf.doubles_moins : un PDF avec « −−0,3 » est refusé, le même avec « −0,3 » passe."""
    # #"--…" : chaîne Typst, sinon le balisage changerait « -- » en tiret demi-cadratin.
    for nom, texte, attendu in (("double", 'x = \u2212\u22120,3 m ; y = #"--2"', 2), ("simple", 'x = \u22120,3 m ; #"--formats"', 0)):
        src, pdf = tmp / f"{nom}.typ", tmp / f"{nom}.pdf"
        src.write_text(f'#set text(font: "Fira Sans")\n{texte}\n', encoding="utf-8")
        typst.compile(str(src), output=str(pdf), root=str(tmp), font_paths=[str(POLICES)], ignore_system_fonts=True)
        trouves = controle_pdf.doubles_moins(pdf)
        print(f"$ double moins ({nom}) : {len(trouves)} trouvé(s) {trouves}")
        if len(trouves) != attendu:
            sys.exit(f"test double moins ({nom}) : {len(trouves)} trouvé(s), {attendu} attendu(s)")


def teste_marqueurs(tmp):
    """anki.py : {v:…}, {x:…} et {xe:…} remplacés depuis les tables de la fiche test ; marqueur inconnu refusé."""
    donnees = RACINE / "produits" / "_test" / "donnees"
    cartes, apkg = tmp / "cartes.csv", tmp / "marqueurs.apkg"
    cartes.write_text("recto,verso,tags\n"
                      "Débit par gravité (EX02) ?,{x:EX02} gouttes/min (calcul exact {xe:EX02}),test\n"
                      "Sans marqueur,Texte inchangé,test\n", encoding="utf-8")
    lancer(SCRIPTS / "anki.py", "--cartes", cartes, "--sortie", apkg, "--cle", "TEST-MARQUEURS", "--nom", "Marqueurs",
           "--langue", "fr", "--donnees", donnees)
    versos = sorted(champs[1] for champs, _ in relire_paquet(apkg)["notes"].values())
    if versos != ["31 gouttes/min (calcul exact 31,25)", "Texte inchangé"]:
        sys.exit(f"test marqueurs : versos inattendus {versos}")
    for marqueur in ("{q:EX02}", "{x:EX99}", "{v:CLE_ABSENTE}"):
        cartes.write_text(f"recto,verso,tags\nQuestion,{marqueur},test\n", encoding="utf-8")
        lancer_echec(SCRIPTS / "anki.py", "--cartes", cartes, "--sortie", apkg, "--cle", "TEST-MARQUEURS",
                     "--nom", "Marqueurs", "--langue", "fr", "--donnees", donnees)


def main():
    pdf = ICI / "livraison" / "test-a4.pdf"
    pdf.parent.mkdir(parents=True, exist_ok=True)
    compiler(ICI / "src" / "fiche.typ", pdf)
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
    with tempfile.TemporaryDirectory() as tmp:
        teste_double_moins(Path(tmp))
        teste_marqueurs(Path(tmp))
    print("Banc d'essai : tout passe.")


if __name__ == "__main__":
    main()
