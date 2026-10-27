<!--
Gabarit d'annonce Whop. Copier dans produits/<CODE>/annonce/whop.md, remplir, puis contrôler :
  python3 scripts/annonces.py <CODE>

Règles générales
- Langue = langue du marché du produit (data/produits.csv → data/marches.csv) : anglais pour EN, français pour FR.
- Limites lues dans data/parametres.csv : whop_titre_car_max, whop_accroche_car_max, whop_description_car_max.
  Les commentaires HTML comme celui-ci ne comptent pas et sont ignorés par le contrôle.
- Garder les quatre sections, dans cet ordre, avec ces intitulés exacts (« # Titre », « # Accroche »,
  « # Description », « # Labels »), même si l'annonce est en anglais.
- Ton factuel (agents/conditionneur.md, docs/conformite.md) : pas de promesse de réussite à un examen, pas de faux
  avis, pas de qualification inexacte (« écrit par un médecin » est faux), aucun chiffre qui ne soit pas dans le produit.
- Les marques (MCAT, NCLEX, TEAS, SPI…) ne servent qu'à dire à quel examen sert le produit, avec leur mention.
-->

# Titre
<!-- Une seule ligne, ≤ whop_titre_car_max caractères. Le nom du produit tel qu'on le chercherait, sans emoji ni MAJUSCULES criardes. -->


# Accroche
<!-- Une seule ligne, ≤ whop_accroche_car_max caractères (champ « headline » de Whop). Ce que la personne en tire, sans promesse de résultat. -->


# Description
<!--
≤ whop_description_car_max caractères, mentions comprises. Paragraphes courts ; listes à puces permises.
Ordre conseillé :
1. Ce que l'acheteur.euse reçoit : formats livrés (PDF A4, US Letter, noir et blanc, tablette, paquet Anki), nombre de pages.
2. Ce qui est couvert (reprendre les éléments réellement présents dans le PDF).
3. À qui c'est destiné.
4. Les mentions, en fin de description : copier mot pour mot, une par paragraphe, le texte de chaque mention du produit
   (data/produit_mentions.csv → data/mentions.csv, colonne texte_en ou texte_fr selon le marché).
   Le contrôle échoue si une seule lettre diffère.
-->


# Labels
<!-- Liste à puces (« - … »), un label court par ligne, sans doublon : thèmes, examen visé, public. -->
- 
