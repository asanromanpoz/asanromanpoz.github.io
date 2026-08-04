#!/usr/bin/env bash
# =============================================================================
# actualizar-cv.sh
# Recompila tu CV de LaTeX y copia el PDF resultante dentro de la web.
#
# Uso:  desde la carpeta de la web, ejecuta:
#         ./actualizar-cv.sh
#       Luego sube los cambios (git add/commit/push) para publicarlo.
#
# Si en el futuro tu CV vive en OTRA carpeta (nueva solicitud), cambia
# solamente la línea CV_TEX de abajo.
# =============================================================================

set -e  # si algo falla, para

# --- 1. Dónde está tu CV de LaTeX (ÚNICA línea que quizá tengas que cambiar) ---
# Tu CV centralizado (carpeta local sincronizada con Overleaf). El principal es cv_en_2p.tex.
CV_TEX="$HOME/Desktop/cv/latex/cv_en_2p.tex"

# --- 2. Carpeta de la web y destino del PDF (no lo toques) ---
WEB_ROOT="$(cd "$(dirname "$0")" && pwd)"
DESTINO="$WEB_ROOT/assets/pdf/cv.pdf"

# --- 3. Asegura que LaTeX está en el PATH (MacTeX) ---
export PATH="/Library/TeX/texbin:$PATH"

CV_DIR="$(dirname "$CV_TEX")"
CV_NAME="$(basename "$CV_TEX" .tex)"

echo "📄 Compilando CV desde: $CV_TEX"
cd "$CV_DIR"
latexmk -pdf -outdir=build "$CV_NAME.tex" >/dev/null

echo "📥 Copiando el PDF a la web..."
cp "build/$CV_NAME.pdf" "$DESTINO"

# --- 4. Escribe la fecha de actualización del CV (la lee about.md sola) ---
# Se toma de la fecha del propio cv_en_2p.tex, así no tienes que tocar nada a mano.
CV_DATE="$(date -r "$CV_TEX" +%Y-%m-%d)"
cat > "$WEB_ROOT/_data/cv.yml" <<EOF
# Fecha de última actualización del CV. La escribe actualizar-cv.sh automáticamente.
updated: $CV_DATE
EOF

echo "✅ Listo. CV (actualizado $CV_DATE) copiado a la web."
echo "   Sube los cambios para publicarlo:"
echo "     git add assets/pdf/cv.pdf _data/cv.yml && git commit -m \"Update CV\" && git push"
