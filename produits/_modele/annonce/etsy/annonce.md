<!--
Gabarit de paquet d'annonce Etsy. À créer SEULEMENT si le produit a droit à Etsy (scripts/tables.py, etsy_autorise :
risque IA FAIBLE ou MOYEN, ou FORT avec méthode écrite par Tristan). Sinon ce fichier ne doit pas exister.
Copier dans produits/<CODE>/annonce/etsy/annonce.md, remplir, puis contrôler :
  python3 scripts/annonces.py <CODE>
Tristan publie à la main à partir de ce fichier (docs/conformite.md).

Règles générales
- Langue = langue du marché du produit. Garder les quatre sections, dans cet ordre, avec ces intitulés exacts.
- Limites lues dans data/parametres.csv (etsy_*).
  Les commentaires HTML comme celui-ci sont ignorés par le contrôle.
- Aucune promesse de réussite, aucun faux avis, aucune affirmation non vérifiée.
-->

# Titre
<!--
Une seule ligne, titre naturel (ce qu'est le produit, pour qui), pas d'empilement de mots-clés.
≤ etsy_titre_mots_max mots et ≤ etsy_titre_car_max caractères.
Caractères admis par Etsy : lettres, chiffres, ponctuation, symboles mathématiques, espaces, ™ © ® ;
% : & + au plus une fois chacun.
-->


# Tags
<!--
Liste à puces, exactement etsy_tags_max tags (un par ligne, « - … »), chacun ≤ etsy_tag_car_max caractères.
Des expressions que les acheteur.euse.s tapent vraiment (ex. « nursing cheat sheet », « fiche ifsi »), sans doublon
(la casse ne compte pas). Caractères admis : lettres, chiffres, espaces, tiret, apostrophe droite, ™ © ®
(pas de virgule, de point, d'esperluette ni de barre oblique).
-->
- 


# Description
<!--
Ordre imposé (agents/conditionneur.md) :
1. Ce que l'acheteur.euse reçoit, en premier : formats (PDF A4, US Letter, noir et blanc, tablette, paquet Anki),
   nombre de pages, fichier numérique téléchargeable (rien n'est expédié).
2. Le contenu, élément par élément, tel qu'il figure dans le PDF.
3. La déclaration IA, puis les avertissements, puis les mentions de marque : copier mot pour mot le texte de chaque
   mention du produit (data/produit_mentions.csv → data/mentions.csv, colonne de la langue du marché).
   Le contrôle échoue si une seule lettre diffère.
-->


# Visuels
<!--
Liste numérotée (1. 2. 3. …), dans l'ordre d'affichage de l'annonce. Chemins relatifs au dossier produit, qui doivent
exister : aperçus générés par scripts/apercus.py (apercus/NN-….png) puis vidéos (video/feuilletage.mp4, puis la vidéo
iPhone si elle existe). Au plus etsy_photos_par_annonce_max images et etsy_videos_par_annonce_max vidéos.
Uniquement des rendus fidèles du PDF : jamais d'image générée, jamais de contenu absent du produit.
-->
1. apercus/01-page-1.png
