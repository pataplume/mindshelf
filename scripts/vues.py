"""Génère les vues lisibles (docs/PLAN-RUNS.md, docs/CATALOGUE.md, docs/BUDGET.md) à partir des tables.
Les vues ne contiennent aucune donnée propre : on modifie les tables, puis on relance ce script.
Usage : python3 scripts/vues.py"""
from collections import defaultdict
from tables import lire, index, canaux_produit, etsy_autorise, param, RACINE

DOCS = RACINE / "docs"
AVERTISSEMENT = "<!-- Fichier généré par scripts/vues.py à partir de data/. Ne pas éditer à la main. -->\n\n"

runs = lire("runs.csv")
taches = lire("run_taches.csv")
phases = index(lire("phases.csv"))
statuts = index(lire("statuts.csv"))
roles = index(lire("roles_agents.csv"))
produits = index(lire("produits.csv"))
risques = index(lire("risques_ia.csv"))
marches = index(lire("marches.csv"))
variantes = lire("variantes.csv")
decisions = lire("decisions.csv")
deps = defaultdict(list)
for d in lire("run_dependances.csv"):
    deps[d["run_code"]].append(d["depend_de_run_code"])
taches_run = defaultdict(list)
for t in taches:
    taches_run[t["run_code"]].append(t)
decisions_idx = index(decisions)
decisions_run = defaultdict(list)
runs_decision = defaultdict(list)
for l in lire("decision_runs.csv"):
    decisions_run[l["run_code"]].append(decisions_idx[l["decision_code"]])
    runs_decision[l["decision_code"]].append(l["run_code"])
statut_run = {r["code"]: r["statut_code"] for r in runs}
SEUIL_FAIT = int(statuts["A_VALIDER"]["ordre"])


def duree(run_code):
    ph = {t["phase_code"] for t in taches_run[run_code]}
    return sum(int(phases[p]["duree_cible_min"]) for p in ph)


def lancable(r):
    if r["statut_code"] != "A_FAIRE":
        return False
    if any(int(statuts[statut_run[d]]["ordre"]) < SEUIL_FAIT for d in deps[r["code"]]):
        return False
    return not any(d["statut"] != "tranche" for d in decisions_run[r["code"]])


def h(m):
    return f"{m // 60} h {m % 60:02d}" if m >= 60 else f"{m} min"


# ---------- PLAN-RUNS ----------
total = sum(duree(r["code"]) for r in runs)
restant = sum(duree(r["code"]) for r in runs if r["statut_code"] == "A_FAIRE")
L = [AVERTISSEMENT, "# Plan des runs\n\n"]
L.append(f"- Runs : {len(runs)} · tâches : {len(taches)}\n")
L.append(f"- Durée estimée totale : {h(total)} · restant : {h(restant)} (hors validation par Tristan)\n")
L.append(f"- Validation estimée : {param('validation_estimee_par_produit')} min par variante produite\n\n")
pret = [r["code"] for r in runs if lancable(r)]
L.append(f"**Lançables maintenant :** {', '.join(pret) if pret else 'aucun (voir décisions bloquantes)'}\n\n")
ouvertes = [d for d in decisions if d["statut"] != "tranche"]
if ouvertes:
    L.append("## Décisions ouvertes\n\n| Code | Sujet | Options | Bloque |\n|---|---|---|---|\n")
    for d in ouvertes:
        L.append(f"| {d['code']} | {d['sujet']} | {d['options']} | {', '.join(runs_decision[d['code']]) or '—'} |\n")
    L.append("\n")
actions = [a for a in lire("actions_tristan.csv") if a["statut_code"] not in ("VALIDE", "PUBLIE")]
if actions:
    types_action = index(lire("types_action.csv"))
    L.append("## En attente de Tristan\n\n| # | Type | Produit | Détail | Depuis |\n|---|---|---|---|---|\n")
    for a in actions:
        L.append(f"| {a['id']} | {types_action[a['type_code']]['libelle']} | {a['produit_code'] or '—'} | {a['detail']} | {a['depuis']} |\n")
    L.append("\n")
L.append("## Runs\n\n")
for r in runs:
    c = r["code"]
    L.append(f"### {c} — {r['titre']}\n\n")
    L.append(f"≈ {h(duree(c))} · statut : {statuts[r['statut_code']]['libelle']}")
    if deps[c]:
        L.append(f" · dépend de : {', '.join(deps[c])}")
    if decisions_run[c]:
        L.append(f" · décisions requises : {', '.join(d['code'] for d in decisions_run[c])}")
    L.append("\n\n| # | Phase | Rôle | Produit | Lot | Tâche | Statut |\n|---|---|---|---|---|---|---|\n")
    for t in sorted(taches_run[c], key=lambda t: (int(phases[t["phase_code"]]["ordre"]), int(t["id"]))):
        p = t["produit_code"]
        lib = f"{p} {produits[p]['titre_travail']}" if p else "—"
        L.append(f"| {t['id']} | {phases[t['phase_code']]['libelle']} | {roles[t['role_code']]['libelle']} | {lib} | {t['lot'] or '—'} | {t['description']} | {statuts[t['statut_code']]['libelle']} |\n")
    L.append("\n")
(DOCS / "PLAN-RUNS.md").write_text("".join(L), encoding="utf-8")

# ---------- CATALOGUE ----------
vars_prod = defaultdict(list)
for v in variantes:
    vars_prod[v["produit_code"]].append(v)
comp = defaultdict(list)
for c in lire("compositions.csv"):
    comp[c["kit_code"]].append(c["composant_code"])
run_prod = defaultdict(set)
for t in taches:
    if t["produit_code"] and t["role_code"] in ("PRODUCTEUR", "ASSEMBLEUR"):
        run_prod[t["produit_code"]].add(t["run_code"])
C = [AVERTISSEMENT, "# Catalogue\n\n"]
for m in marches.values():
    liste = [p for p in produits.values() if p["marche_code"] == m["code"]]
    C.append(f"## {m['libelle']} ({m['devise']})\n\n")
    C.append("| Code | Produit | Type | Risque IA | Relecture métier | Méthode | Canaux | Prix | Variantes | Runs | Statut |\n|---|---|---|---|---|---|---|---|---|---|---|\n")
    for p in liste:
        titre = p["titre_travail"] + (f" ({' + '.join(comp[p['code']])})" if comp[p["code"]] else "")
        C.append(f"| {p['code']} | {titre} | {p['type_code']} | {p['risque_code']} | {p['relecture_metier']} | {p['methode_auteur']} | {' + '.join(canaux_produit(p, risques))} | {p['prix_cible']} | {len(vars_prod[p['code']])} | {', '.join(sorted(run_prod[p['code']]))} | {statuts[p['statut_code']]['libelle']} |\n")
    C.append("\n")
C.append("## Produits Whop existants\n\n| Whop | Titre | Prix | Visibilité | Remplacé par | Décision |\n|---|---|---|---|---|---|\n")
for w in lire("whop_existants.csv"):
    C.append(f"| {w['whop_product_id']} | {w['titre']} | {w['prix']} {w['devise']} | {w['visibilite']} | {w['produit_code'] or '—'} | {w['decision_code'] or '—'} |\n")
(DOCS / "CATALOGUE.md").write_text("".join(C), encoding="utf-8")

# ---------- BUDGET ----------
frais = index(lire("frais_canaux.csv"), "id")
nb_etsy = sum(1 for v in variantes if etsy_autorise(produits[v["produit_code"]], risques))
B = [AVERTISSEMENT, "# Budget de lancement\n\n| Poste | Calcul | Montant max |\n|---|---|---|\n"]
tot = 0.0
for b in lire("budget.csv"):
    f = frais[b["frais_id"]]
    q = int(b["quantite"]) if b["quantite"] else nb_etsy
    m = float(f["montant_max"]) * q
    tot += m
    B.append(f"| {b['poste']} | {q} × {f['montant_max']} {f['devise']} | {m:.2f} {f['devise']} |\n")
dep = sum(float(d["montant"]) for d in lire("depenses.csv"))
B.append(f"| Dépenses déjà engagées (data/depenses.csv) | | {dep:.2f} USD |\n")
plafond = float(param("budget_depart_max"))
B.append(f"| **Total** | plafond {plafond:.0f} USD | **{tot + dep:.2f} USD** |\n\n")
B.append(f"Variantes publiables sur Etsy : {nb_etsy}. Les frais de mise en ligne se renouvellent tous les 4 mois par annonce. ")
B.append("Les frais par vente (transaction, paiement, conversion) sont dans data/frais_canaux.csv et ne sont pas des dépenses de lancement.\n")
(DOCS / "BUDGET.md").write_text("".join(B), encoding="utf-8")
print(f"Vues générées : {len(runs)} runs, {h(total)} estimées, lançables : {', '.join(pret) or 'aucun'}")
