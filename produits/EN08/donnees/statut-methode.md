# Relecture médicale en attente

**Produit :** EN08-STD « Lab Values Cheat Sheet » (MindShelf, marché EN/US, étudiant.e.s infirmier.ère.s, NCLEX), référentiel AUCUN, 1 page.
**Statut :** rédigé par l'agent producteur (run R03, 29.10.2026), `methode_auteur = AGENT`, risque IA **FAIBLE** (Whop et Etsy). Aucune valeur ni aucun passage n'a encore été contrôlé par le vérificateur ni par la relectrice.

> **PUBLICATION BLOQUÉE JUSQU'À LA RELECTURE MÉDICALE.** Aucun dépôt Whop ni Etsy (ni envoi du PDF à qui que ce soit) tant que `data/revues.csv` ne contient pas une ligne de relecture métier validée par la médecin stagiaire (`data/produit_relecteurs.csv` : EN08 → MEDECIN_STAGIAIRE) pour EN08-STD. Raison : le pied de page affirme « content checked and approved by the seller », exact seulement après cette relecture. Le PDF ne porte pas de filigrane de brouillon : ce fichier en tient lieu.

## Pour la relectrice

### Fichier et version
- **Fichier :** `livraison/EN08-STD/EN08-STD-a4.pdf` (Letter, N&B et tablette : même contenu, autre mise en page).
- **Version :** le pied de page affiche **v1** (`data/variantes.csv`, colonne `version`). La ligne de `data/revues.csv` reprend la version du PDF relu.

### Où consigner les décisions
Chaque décision va dans un champ de table, jamais dans une note en texte.

| Décision | Champ |
|---|---|
| Une borne d'intervalle à corriger | `donnees/examens.csv`, colonnes `bas_us` / `haut_us` (ou `bas_si` / `haut_si` pour le Ca ionisé, seule ligne dont la source est en SI), puis relancer le générateur ou recalculer l'autre unité : la compilation échoue si US et SI ne concordent pas |
| Un facteur de conversion | `donnees/exemples.csv`, ligne `F_<code>` (entrées et formule), et `donnees/facteurs.csv`, colonne `facteur` (arrondi de la dérivation, contrôlé à la compilation) |
| Une ligne à retirer ou à ajouter | une ligne de `donnees/examens.csv` (groupes dans `donnees/groupes.csv`) |
| Le seuil INR de risque hémorragique | `donnees/valeurs.csv`, clé `inr_saignement` |

## Source des intervalles
- **Source principale (une seule, cohérente) :** ABIM Laboratory Test Reference Ranges, January 2026 (`references.csv`, `ABIM_2026`). Elle donne les valeurs en unités US conventionnelles, sauf le Ca ionisé (mmol/L).
- **Valeurs SI :** calculées depuis la valeur US et le facteur **arrondi affiché** (règle : facteur arrondi, puis utilisé tel qu'arrondi), arrondies au demi supérieur. Le Ca ionisé US est calculé depuis la valeur SI.
- **Autres sources :** MedlinePlus pour l'INR (sans anticoagulant et cible sous warfarine) et la digoxine, car l'ABIM ne les donne pas.
- **Facteurs :** calculés depuis les masses atomiques IUPAC (table abrégée) et les définitions SI ; chaque dérivation est une ligne de `exemples.csv`.
- **Droits :** les intervalles sont des données factuelles ; le tableau de la fiche n'est pas celui de l'ABIM (sélection, regroupement, colonnes SI et facteur ajoutées, libellés reformulés).

## Points à confirmer (A-VERIFIER)

### Valeurs
1. **ABIM_2026 : relire chaque valeur dans le PDF de l'ABIM.** Le texte a été obtenu par un outil de lecture web ; le PDF lui-même n'a pas pu être téléchargé (proxy). Pages non relevées.
2. **Digoxine 0.5–1.9 ng/mL (MedlinePlus).** Intervalle « général » de MedlinePlus ; d'autres sources donnent d'autres bornes (cibles plus basses selon l'indication). La fiche le présente comme général et renvoie à la cible du.de la prescripteur.rice. Garder, préciser ou retirer ?
3. **HbA1c en mmol/mol** : équation IFCC = (% − 2.15) × 10.929, source candidate Hanas & John 2010 non relue. Résultat affiché 20–38 mmol/mol.
4. **Triglycérides** : facteur 0.0113 calculé en assimilant les triglycérides à la trioléine (convention à confirmer).
5. **Enzymes en µkat/L** (× 0.0167) : beaucoup de laboratoires SI gardent l'U/L. Garder la colonne µkat/L ou écrire « U/L » des deux côtés ?
6. **SaO₂ ≥ 95 %** : l'ABIM ne donne qu'une borne basse ; la fiche affiche « ≥ 95 % » et « ≥ 0.95 (fraction) ».
7. **Masses atomiques IUPAC** (table abrégée 2021) : non relues dans ce run.

### Interprétation (périmètre de la médecin stagiaire)
8. **Piège « Total vs ionized calcium »** (albumine basse, Ca total bas, Ca ionisé possiblement normal) : **non sourcé** dans ce run. La formule de correction par l'albumine n'est pas affichée, faute de source.
9. **Piège « Hemolyzed sample »** (K⁺ faussement élevé) : **non sourcé** dans ce run.
10. **Note « Potassium and the heart »** (K⁺ haut ou bas, risque de trouble du rythme ; signaler, ECG selon protocole) : **non sourcée** dans ce run.
11. **Note « INR and bleeding »** : « Report per protocol » est une consigne générique ajoutée par l'agent (la source dit seulement que le risque hémorragique augmente au-dessus de 3.0).
12. **Clarté** : libellés anglais des examens, « BUN (urea nitrogen) → urea », « IFCC eq. » dans la colonne des facteurs.

## Non couvert (choix ou faute de source)
- Lithium (taux thérapeutique) : source non obtenue dans ce run.
- Valeurs critiques : aucune source consultée ne les écrit de façon générale (elles sont propres à chaque laboratoire).
- Formule du calcium corrigé par l'albumine, trou anionique, lactate, intervalles pédiatriques et de grossesse, urines.

## Pages web non obtenues pendant ce run
- PDF ABIM en téléchargement direct (proxy 403) ; lu par un outil de lecture web.
- Merck Manual Professional, « Normal Laboratory Values » (erreur du site).
- MedlinePlus Lab Tests « Prothrombin Time Test and INR » et « Potassium Blood Test » ; testing.com « Lithium » ; PMC10197277 (autorisation non accordée à temps) ; PMC2390954 (captcha).
