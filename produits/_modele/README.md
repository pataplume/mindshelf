# Structure d'un dossier produit

```
produits/<CODE>/
├── src/                     sources Typst (une seule source pour tous les formats)
│   ├── main.typ             point d'entrée ; lit la charte et les données
│   └── contenu/             sections du produit
├── donnees/
│   ├── exemples.csv         id, enonce, entrees_json, formule, resultat_attendu, unite, tolerance, arrondi
│   ├── references.csv       element, source_code, localisation (page, section, article)
│   ├── variantes.csv        correspondances propres à une variante (ex. numéros d'UE 2009 / 2026)
│   ├── cartes.csv           recto, verso, tags (export Anki)
│   └── qcm.csv              guides seulement : id, question, a, b, c, d, bonne, explication, source_code
├── lots/<LOT>/              travail d'un agent quand la tâche est découpée en lots
├── livraison/<VARIANTE>/    PDF A4, Letter, N&B, tablette et .apkg livrés
├── verif/rapport-v<N>.md    rapports du vérificateur
├── apercus/                 PNG des pages, dans l'ordre des visuels d'annonce
├── video/                   feuilletage.mp4 et script-iphone.md
└── annonce/
    ├── whop.md              titre, accroche, description, labels
    └── etsy/                titre, 13 tags, description, ordre des visuels (si le produit va sur Etsy)
```

Chaque nombre affiché dans une fiche (exemple, norme, constante) provient d'un fichier de `donnees/`, jamais tapé directement dans le Typst.
