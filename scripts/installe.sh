#!/usr/bin/env bash
# Installation reproductible de la chaîne de fabrication MindShelf (idempotent : relançable sans effet de bord).
# Versions figées sur celles avec lesquelles la charte et la fiche test ont été rendues (run R00).
# Usage : bash scripts/installe.sh      (code de sortie 1 si un élément manque)
set -euo pipefail

TYPST_VERSION="0.15.0"     # paquet Python typst (compilateur Typst embarqué) ; changer de version = refaire les rendus de référence
GENANKI_VERSION="0.13.1"
PYPDF_VERSION="6.17.0"
PILLOW_VERSION="12.3.0"

RACINE="$(cd "$(dirname "$0")/.." && pwd)"
manque=0

version_installee() {  # $1 = nom du paquet pip
  python3 -m pip show "$1" 2>/dev/null | awk '/^Version:/ {print $2}'
}

installe_pip() {  # $1 = paquet, $2 = version
  if [ "$(version_installee "$1")" = "$2" ]; then
    echo "ok      $1 $2"
  else
    echo "install $1==$2"
    python3 -m pip install --quiet --break-system-packages "$1==$2"
  fi
}

installe_pip typst "$TYPST_VERSION"
installe_pip genanki "$GENANKI_VERSION"
installe_pip pypdf "$PYPDF_VERSION"
installe_pip pillow "$PILLOW_VERSION"

# Outils système (poppler-utils, ffmpeg) : vérifiés, pas installés (dépendent du système).
for outil in pdftoppm pdffonts pdftotext ffmpeg ffprobe; do
  if command -v "$outil" >/dev/null 2>&1; then
    echo "ok      $outil"
  else
    echo "MANQUE  $outil  (paquet poppler-utils ou ffmpeg)" >&2
    manque=1
  fi
done

# Polices de la charte (incorporées dans chaque PDF).
if ls "$RACINE"/charte/polices/*/*.otf >/dev/null 2>&1; then
  echo "ok      polices charte/polices"
else
  echo "MANQUE  polices dans charte/polices" >&2
  manque=1
fi

# Contrôle final : la version de typst réellement importée.
python3 -c "import typst, sys; v = typst.__version__; sys.exit(0 if v == '$TYPST_VERSION' else f'typst {v} importé, $TYPST_VERSION attendu')"

if [ "$manque" -ne 0 ]; then
  echo "Installation incomplète." >&2
  exit 1
fi
echo "Chaîne prête (typst $TYPST_VERSION)."
