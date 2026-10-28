"""Contrôle d'intégrité des tables : clés étrangères, valeurs autorisées, doublons.
Usage : python3 scripts/verifie_tables.py   (code de sortie 1 si erreur)"""
import sys
from tables import lire, index

erreurs = []


def fk(table, col, cible, cible_col="code", vide_ok=False):
    valeurs = {l[cible_col] for l in lire(cible)}
    for i, l in enumerate(lire(table), start=2):
        v = l[col]
        if v == "" and vide_ok:
            continue
        if v not in valeurs:
            erreurs.append(f"{table}:{i} {col}='{v}' absent de {cible}.{cible_col}")


def unique(table, col):
    vus = set()
    for i, l in enumerate(lire(table), start=2):
        if l[col] in vus:
            erreurs.append(f"{table}:{i} doublon {col}='{l[col]}'")
        vus.add(l[col])


for t, c in [("produits.csv", "code"), ("variantes.csv", "code"), ("runs.csv", "code"),
             ("marques.csv", "code"), ("marches.csv", "code"), ("sources.csv", "code"),
             ("mentions.csv", "code"), ("decisions.csv", "code"), ("run_taches.csv", "id")]:
    unique(t, c)

fk("marches.csv", "marque_code", "marques.csv")
fk("produits.csv", "marche_code", "marches.csv")
fk("produits.csv", "type_code", "types_produit.csv")
fk("produits.csv", "risque_code", "risques_ia.csv")
fk("produits.csv", "statut_code", "statuts.csv")
fk("variantes.csv", "produit_code", "produits.csv")
fk("variantes.csv", "referentiel_code", "referentiels.csv")
fk("compositions.csv", "kit_code", "produits.csv")
fk("compositions.csv", "composant_code", "produits.csv")
fk("produit_mentions.csv", "produit_code", "produits.csv")
fk("produit_mentions.csv", "mention_code", "mentions.csv")
fk("frais_canaux.csv", "canal_code", "canaux.csv")
fk("frais_canaux.csv", "source_code", "sources.csv")
fk("budget.csv", "frais_id", "frais_canaux.csv", "id")
fk("runs.csv", "statut_code", "statuts.csv")
fk("run_dependances.csv", "run_code", "runs.csv")
fk("run_dependances.csv", "depend_de_run_code", "runs.csv")
fk("run_taches.csv", "run_code", "runs.csv")
fk("run_taches.csv", "phase_code", "phases.csv")
fk("run_taches.csv", "role_code", "roles_agents.csv")
fk("run_taches.csv", "produit_code", "produits.csv", vide_ok=True)
fk("run_taches.csv", "statut_code", "statuts.csv")
fk("types_livrable.csv", "phase_code", "phases.csv")
fk("types_livrable.csv", "role_code", "roles_agents.csv")
fk("revues.csv", "variante_code", "variantes.csv")
fk("revues.csv", "etape_code", "revue_etapes.csv")
fk("publications.csv", "variante_code", "variantes.csv")
fk("publications.csv", "canal_code", "canaux.csv")
fk("produit_sources.csv", "produit_code", "produits.csv")
fk("produit_sources.csv", "source_code", "sources.csv")
fk("whop_existants.csv", "produit_code", "produits.csv", vide_ok=True)
fk("whop_existants.csv", "decision_code", "decisions.csv", vide_ok=True)
fk("produit_relecteurs.csv", "produit_code", "produits.csv")
fk("produit_relecteurs.csv", "relecteur_code", "relecteurs.csv")
fk("decision_runs.csv", "decision_code", "decisions.csv")
fk("decision_runs.csv", "run_code", "runs.csv")
fk("runs_durees.csv", "run_code", "runs.csv")
fk("runs_durees.csv", "phase_code", "phases.csv")
fk("runs_durees.csv", "role_code", "roles_agents.csv")

# Règles métier
produits = index(lire("produits.csv"))
for p in produits.values():
    if p["methode_auteur"] not in ("AGENT", "TRISTAN"):
        erreurs.append(f"produits.csv {p['code']} methode_auteur invalide")
for p in produits.values():
    if not p.get("pages_max", "").isdigit() or int(p["pages_max"]) < 1:
        erreurs.append(f"produits.csv {p['code']} pages_max invalide")
for v in lire("variantes.csv"):
    if not v.get("version"):
        erreurs.append(f"variantes.csv {v['code']} sans version")
for c in lire("compositions.csv"):
    if produits[c["kit_code"]]["type_code"] != "KIT":
        erreurs.append(f"compositions.csv {c['kit_code']} n'est pas un KIT")
    if produits[c["composant_code"]]["marche_code"] != produits[c["kit_code"]]["marche_code"]:
        erreurs.append(f"compositions.csv {c['kit_code']}/{c['composant_code']} marchés différents")
avec_relecteur = {l["produit_code"] for l in lire("produit_relecteurs.csv")}
for p in produits.values():
    if p["relecture_metier"] == "oui" and p["code"] not in avec_relecteur:
        erreurs.append(f"produits.csv {p['code']} relecture métier sans relecteur.rice (produit_relecteurs.csv)")
avec_variante = {v["produit_code"] for v in lire("variantes.csv")}
for code in produits:
    if code not in avec_variante:
        erreurs.append(f"produits.csv {code} sans variante")
produits_planifies = {t["produit_code"] for t in lire("run_taches.csv") if t["role_code"] in ("PRODUCTEUR", "ASSEMBLEUR")}
for code in produits:
    if code not in produits_planifies:
        erreurs.append(f"produits.csv {code} n'est produit par aucun run")

if erreurs:
    print("\n".join(erreurs))
    sys.exit(1)
print("Tables cohérentes.")
