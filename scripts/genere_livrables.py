"""Construit ou complète data/livrables.csv : une ligne par variante et type de livrable.
Conserve les statuts et chemins déjà renseignés ; recalcule seulement 'applicable'.
Usage : python3 scripts/genere_livrables.py"""
from tables import lire, ecrire, index, etsy_autorise, DATA

ENTETE = ["variante_code", "type_livrable_code", "applicable", "statut_code", "chemin"]

produits = index(lire("produits.csv"))
risques = index(lire("risques_ia.csv"))
types = lire("types_livrable.csv")
existants = {}
if (DATA / "livrables.csv").exists():
    existants = {(l["variante_code"], l["type_livrable_code"]): l for l in lire("livrables.csv")}

lignes = []
for v in lire("variantes.csv"):
    p = produits[v["produit_code"]]
    for t in types:
        applicable = "oui"
        if t["condition"] == "SI_ETSY" and not etsy_autorise(p, risques):
            applicable = "non"
        cle = (v["code"], t["code"])
        ancien = existants.get(cle)
        lignes.append({
            "variante_code": v["code"],
            "type_livrable_code": t["code"],
            "applicable": applicable,
            "statut_code": ancien["statut_code"] if ancien else "A_FAIRE",
            "chemin": ancien["chemin"] if ancien else "",
        })

ecrire("livrables.csv", ENTETE, lignes)
print(f"{len(lignes)} livrables ({sum(l['applicable'] == 'oui' for l in lignes)} applicables)")
