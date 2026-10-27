# Charte MindShelf et marque FR : API du modèle Typst

Le modèle `charte/modele.typ` est commun aux deux marques. Seuls le nom de marque (paramètre `marque`) et la langue changent. **Toutes les valeurs de style** (couleurs, polices, tailles, interlignes, marges, rayons, épaisseurs, dimensions de page, libellés) sont dans `data/charte_tokens.csv` (`cle, valeur, usage`). Le modèle ne contient que de la logique : pour changer l'apparence, on modifie une ligne du CSV, jamais le `.typ`.

## Compilation

```python
import typst
R = "/home/claude/mindshelf"
typst.compile(f"{R}/produits/EN01/src/main.typ",
              output=f"{R}/produits/EN01/livraison/EN01-STD/EN01-STD-a4.pdf",
              root=R,                                    # obligatoire : le modèle lit /data/…
              font_paths=[f"{R}/charte/polices"],        # obligatoire : Fira Sans, Fira Math, Fira Mono
              ignore_system_fonts=True,                  # recommandé : rendu identique sur toute machine
              sys_inputs={"format": "a4"})               # a4 | letter | nb | tablette
```

- `root` doit être la racine du dépôt (les chemins `/data/…` et `/charte/…` sont absolus depuis la racine) ; le fichier compilé doit se trouver sous cette racine.
- Les quatre formats viennent de la même source : seule l'entrée `format` change.
- Toute erreur de données (jeton absent, format ou langue inconnus, mention introuvable) fait échouer la compilation avec un message `charte : …`.
- Vérifier ensuite les polices avec `pdffonts` : toutes doivent être `emb yes`.

## Gabarit de document : `fiche`

```typst
#import "/charte/modele.typ": *
#show: fiche.with(
  titre: "Dosage Calculation & IV Drip Rates",
  sous-titre: "Formulas, worked examples, traps",
  marque: "MindShelf",                 // ou le nom de la marque FR
  langue: "en",                        // "en" | "fr"
  format: sys.inputs.at("format", default: "a4"),
  mentions: mentions-produit("EN01", "en"),
  version: "v1",
)
```

| Paramètre | Type | Défaut | Effet |
|---|---|---|---|
| `titre` | contenu | `none` | Titre en tête de première page, en-tête courant des pages suivantes, métadonnée PDF `Title` |
| `sous-titre` | contenu | `none` | Ligne sous le titre |
| `marque` | chaîne | `"MindShelf"` | Logo-type (pictogramme + nom), pied de page, métadonnée PDF `Author` |
| `langue` | `"en"` \| `"fr"` | `"en"` | `set text(lang:)` : césure, guillemets, libellés des composants, séparateurs de nombres, espaces fines avant `; : ! ? %` en français |
| `format` | `"a4"` \| `"letter"` \| `"nb"` \| `"tablette"` | entrée `format` ou `"a4"` | Dimensions, marges et corps de page (jetons `page.<format>.*`, `corps.<gabarit>.<format>`) ; `"nb"` utilise la palette `couleur-nb.*` |
| `mentions` | tableau de chaînes (ou une chaîne) | `()` | Pied de page de chaque page, séparées par ` · ` |
| `version` | chaîne | `none` | Affichée dans le pied de page après la marque |
| `gabarit` | `"fiche"` \| `"guide"` | `"fiche"` | `fiche` : corps 8 pt, très dense (cheat sheet) ; `guide` : corps 9,5 pt, plus aéré (guides de 30 à 80 pages) |
| `numerotation` | booléen | `false` | Numérote les titres (`1`, `1.1`, `1.1.1`) ; le niveau 1 reçoit un pavé numéroté |
| `sommaire` | `auto` \| booléen | `auto` | Sommaire cliquable en tête. `auto` = oui en tablette seulement |

### Comportement par format

| Format | Page | Couleurs | Particularités |
|---|---|---|---|
| `a4` | 210 × 297 mm | couleur | Format de référence |
| `letter` | 8,5 × 11 in | couleur | Texte un peu plus large et corps réduit (7,7 pt) : une fiche A4 d'une page tient sur une page Letter |
| `nb` | A4 | niveaux de gris (`couleur-nb.*`) | Icônes, hachures et libellés conservés : aucune information ne dépend de la couleur |
| `tablette` | 240 × 167 mm paysage (rapport d'un iPad Air) | couleur | Corps agrandi (9,5 pt fiche, 11 pt guide), sommaire cliquable généré en tête, lien « ↑ Contents / ↑ Sommaire » dans l'en-tête de chaque page, signets PDF. Une fiche A4 d'une page peut occuper 2 ou 3 pages : c'est normal |

Pour un produit FR, `mentions-produit("FR01", "fr")` et `langue: "fr"` suffisent : tous les libellés passent en français (`Exemple`, `Piège`, `Note clinique`, `Sommaire`).

## Titres

```typst
= Section            // niveau 1 : grand, couleur de marque, filet dessous
== Sous-section      // niveau 2
=== Intertitre       // niveau 3
```

Les titres de niveaux 1 et 2 alimentent le sommaire (tablette) et les signets PDF. Ils restent collés au bloc qui les suit (pas de titre orphelin en bas de colonne). Pour exclure un titre du sommaire : `#heading(outlined: false)[…]`.

## Composants

Tous les encadrés prennent toute la largeur de leur colonne et peuvent se couper entre deux pages ; leur ligne de libellé ne reste jamais seule en bas de page.

### `formule(titre: none)[corps]`
Encadré à barre pleine, fond teinté, chiffres tabulaires ; les équations centrées y ont un espacement resserré. Sans libellé ni icône (c'est le composant le plus fréquent).
```typst
#formule(titre: "Desired over have")[
  $ V = D / H times Q $
  $D$ ordered dose, $H$ dose on hand, $Q$ volume containing $H$.
]
```

### `exemple(titre: none)[corps]`
Libellé `EXAMPLE` / `EXEMPLE` en petites capitales, icône cercle coché, barre pleine verte.
```typst
#exemple(titre: "Oral suspension")[
  Ordered 250 mg; on hand 500 mg per 5 mL.
  $ V = 250 / 500 times 5 = #nombre("2.5") "mL" $
]
```

### `piege(titre: none)[corps]`
Libellé `TRAP` / `PIÈGE`, icône triangle « ! », **barre hachurée** (reconnaissable en N&B même sans lire le libellé).
```typst
#piege[Convert *before* you divide: mixing mg and µg multiplies the error by 1000.]
```

### `note-clinique(titre: none)[corps]`
Libellé `CLINICAL NOTE` / `NOTE CLINIQUE`, icône carré « + », barre pleine violette. Pour les points de surveillance et de sécurité patient.
```typst
#note-clinique(titre: "Monitoring")[Two independent checks for high-alert drugs.]
```

### `encadre(titre: none)[corps]`
Encadré générique à contour fin et bandeau de titre gris : méthodes, rappels, résumés.
```typst
#encadre(titre: "Method in 3 steps")[
  + Write the formula with units.
  + Convert to the same unit.
  + Check the order of magnitude.
]
```

### `tableau(columns: auto, entete: 1, ..cellules)`
Tableau dense : texte condensé (Fira Sans Condensed), chiffres tabulaires, en-tête teinté en semi-gras **répété en haut de chaque page**, lignes alternées, filet de fin.

- `entete` : nombre de lignes d'en-tête prises dans les premières cellules (`0` = pas d'en-tête).
- On peut aussi passer un `table.header(…)` en première cellule (alors `entete` donne son nombre de lignes, 1 par défaut).
- Tout autre paramètre de `table` (`align`, `fill`, `stroke`, `inset`…) est transmis et remplace celui de la charte ; `table.cell(colspan: …)`, `table.hline()` etc. fonctionnent.
```typst
#tableau(
  columns: (1fr, auto, auto),
  align: (left, right, left),
  [Set], [Drop factor], [Typical use],
  [Macro-drip], [10–20 gtt/mL], [Adults],
  [Micro-drip], [60 gtt/mL], [Pediatrics],
)
```

### `colonnes(n, gouttiere: auto, equilibre: auto)[corps]`
Met le contenu en `n` colonnes (gouttière `colonnes.gouttiere`). Si tout le contenu tient dans la place restante de la page, les colonnes sont **équilibrées** (même hauteur, pas de colonne vide) ; sinon le texte s'écoule normalement de colonne en colonne et de page en page. `equilibre: false` force l'écoulement simple. Fonctionne aussi dans un encadré. Le contenu après `colonnes` reprend en pleine largeur.
```typst
#colonnes(2)[
  = Core formulas
  #formule[…]
  = Reference values
  #tableau(…)
]
= Full-width section
#colonnes(3)[ … ]
```

## Fonctions utilitaires

### `mentions-produit(code, langue)` → tableau de chaînes
Lit `data/produit_mentions.csv` et `data/mentions.csv` et renvoie les textes du produit dans la langue (`"en"` ou `"fr"`), en ignorant les textes vides (les mentions de marque déposée n'existent qu'en anglais). Échoue si le produit n'a aucune mention. À passer tel quel à `mentions:`.

### `nombre(valeur, decimales: none)` → contenu
Formate un nombre selon la langue du texte : `1,234.5` en anglais, `1 234,5` en français (espace fine insécable à partir de 5 chiffres : `1000`, `10 000`), signe moins typographique.
- Passer une **chaîne lue dans le CSV** (`nombre(ligne.resultat)`) conserve exactement ses chiffres (`"0.30"` → `0,30`), y compris les zéros significatifs. Un nombre Typst calculé peut produire des artefacts flottants (`0.1 + 0.2`) : dans ce cas, préciser `decimales`.
- `decimales: 1` arrondit et garde les zéros (`125` → `125,0`).
- Utilisable en mode maths : `$ V = #nombre("2.5") "mL" $`.

### `logo(marque)` → contenu
Logo-type seul (pictogramme « trois livres sur une étagère » + nom), aux couleurs du format courant. Utile pour une couverture de kit ou de guide.

### `couleur(nom)` → couleur (dans un `context`)
Couleur d'un rôle de la palette pour le format courant (palette N&B en `nb`). Pour les schémas dessinés en code (ECG, courbes) : `#context line(stroke: couleur("marque"))`. Rôles disponibles : voir les clés `couleur.*` du CSV, sans le préfixe (ex. `"encre"`, `"piege.trait"`).

### `config-fiche()` → dictionnaire (dans un `context`)
`(format: …, gabarit: …, langue: …)` du document en cours, pour adapter un contenu au format (ex. masquer un schéma très large en tablette).

### `jeton(cle)` → chaîne
Valeur brute d'un jeton du CSV ; échoue si la clé n'existe pas.

## Règles pour les producteurs

1. **Aucune valeur de style dans les sources produit** : pas de `set text(size: …)`, de couleur, de marge ni de police. Si un besoin manque, le signaler pour ajout d'un jeton.
2. **Aucun nombre tapé en dur** : les valeurs viennent de `donnees/*.csv` et passent par `nombre()`.
3. **La couleur ne porte jamais seule un sens** : utiliser les composants (icône et libellé intégrés) plutôt que du texte coloré ; dans un schéma, doubler toute couleur par un libellé, un motif ou une forme.
4. **Densité** : une fiche (`gabarit: "fiche"`) vise une page A4 en 2 colonnes ; un guide utilise `gabarit: "guide"` et `numerotation: true`.
5. Glyphes : Fira Sans couvre le latin, le grec, les flèches et les symboles courants (`≈ ≤ ± × µ ° ½ ‰`). Les rares glyphes absents (`✓ ✗ ⚠ ★`) passent par les polices de secours (`police.secours`) ; préférer les composants, dont les icônes sont dessinées.

## Fichiers

| Fichier | Rôle |
|---|---|
| `data/charte_tokens.csv` | Toutes les valeurs de style (229 jetons), palette couleur et palette N&B |
| `charte/modele.typ` | Logique du modèle (aucune valeur en dur) |
| `charte/demo.typ` | Démonstration de tous les composants (entrées `format`, `langue`, `marque`) |
| `charte/demo/demo-{a4,letter,nb,tablette}.pdf` | Rendus de la démo en anglais ; `demo-fr-a4.pdf` en français |
| `charte/polices/` | Fira Sans 4.301, Fira Math 0.3.4, Fira Mono 3.206, chacune avec son `OFL.txt` (SIL Open Font License 1.1) |
| `charte/marque-fr.md` | Propositions de nom pour la marque FR |

## Choix de la charte

- **Typographie** : Fira Sans (humaniste, très lisible en petit corps, chiffres tabulaires, variante Condensed pour les tableaux denses) ; Fira Math pour les formules, dessinée pour s'accorder à Fira Sans ; Fira Mono pour le code. Toutes sous SIL OFL 1.1.
- **Couleurs** : bleu pétrole `#134B5F` pour la marque et les titres, accent ocre `#C98A2B` réservé au pictogramme ; un code par composant (bleu formule, vert exemple, rouge piège, violet note clinique), toujours doublé d'une icône, d'un libellé et, pour le piège, d'une barre hachurée. Contraste de chaque texte ou pictogramme sur son fond : 6,2:1 au minimum en couleur et 11:1 en N&B (texte courant 17,8:1), au-delà du niveau WCAG AA (4,5:1).
- **Densité** : corps 8 pt en fiche, interligne serré, deux colonnes équilibrées, encadrés à barre gauche plutôt qu'à cadre complet pour économiser la place.
