"""Accès aux tables CSV de data/ et règles métier partagées par les scripts."""
import csv
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
DATA = RACINE / "data"


def lire(nom):
    with open(DATA / nom, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def ecrire(nom, entete, lignes):
    with open(DATA / nom, "w", newline="", encoding="utf-8") as f:
        wr = csv.DictWriter(f, fieldnames=entete)
        wr.writeheader()
        wr.writerows(lignes)


def index(lignes, cle="code"):
    return {l[cle]: l for l in lignes}


def param(cle):
    return index(lire("parametres.csv"), "cle")[cle]["valeur"]


def etsy_autorise(produit, risques):
    """Un produit va sur Etsy si son niveau de risque IA le permet.
    FORT : seulement si la méthode est écrite par Tristan (règle Etsy du 22.10.2026)."""
    regle = risques[produit["risque_code"]]["etsy_autorise"]
    if regle == "oui":
        return True
    if regle == "si_methode_tristan":
        return produit["methode_auteur"] == "TRISTAN"
    return False


def canaux_produit(produit, risques):
    canaux = ["WHOP"]
    if etsy_autorise(produit, risques):
        canaux.append("ETSY")
    return canaux
