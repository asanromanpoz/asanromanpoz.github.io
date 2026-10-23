#!/usr/bin/env bash
# =============================================================================
# actualizar-preprint.sh
# Copia el PDF del working paper de hospitales (versión OSF) dentro de la web
# y apunta su fecha de actualización (la lee papers.md sola).
#
# Uso:  1. Compila tú el .tex en VS Code, como siempre.
#       2. Desde la carpeta de la web, ejecuta:
#            ./actualizar-preprint.sh
#       3. Sube los cambios (git add/commit/push) para publicarlo.
#
# No recompila a propósito: el PDF lleva \today (fecha de compilación), así
# que la fecha de la web se toma del PDF y siempre coincide con la impresa.
#
# Ojo: esto actualiza la WEB. La nueva versión en OSF la subes tú en
# osf.io/fuez5 → "Edit preprint" → "New version" (mismo DOI).
#
# Si en el futuro el preprint vive en OTRO .tex, cambia solamente la línea
# PREPRINT_TEX de abajo.
# =============================================================================

set -e  # si algo falla, para

# --- 1. Dónde está el .tex del preprint (ÚNICA línea que quizá tengas que cambiar) ---
PREPRINT_TEX="$HOME/Desktop/PHD/2. HOSPITALES/latex/osf_221026.tex"

# --- 2. Carpeta de la web, destino del PDF y clave en _data/preprints.yml (no lo toques) ---
WEB_ROOT="$(cd "$(dirname "$0")" && pwd)"
DESTINO="$WEB_ROOT/assets/pdf/sanroman2026_missedopportunities_osf.pdf"
CLAVE="missed_opportunities"

PREPRINT_PDF="${PREPRINT_TEX%.tex}.pdf"

# --- 3. Comprueba que el PDF existe y está al día con el .tex ---
if [ ! -f "$PREPRINT_PDF" ]; then
  echo "❌ No encuentro el PDF: $PREPRINT_PDF  (compila el .tex primero)"
  exit 1
fi
if [ "$PREPRINT_TEX" -nt "$PREPRINT_PDF" ]; then
  echo "⚠️  El .tex es más nuevo que el PDF: compílalo otra vez y vuelve a ejecutar."
  exit 1
fi

echo "📥 Copiando el PDF a la web..."
cp "$PREPRINT_PDF" "$DESTINO"

# --- 4. Escribe la fecha de actualización (la lee papers.md sola) ---
# Se toma de la fecha del PDF (= día en que lo compilaste = fecha impresa en él).
PREPRINT_DATE="$(date -r "$PREPRINT_PDF" +%Y-%m-%d)"
cat > "$WEB_ROOT/_data/preprints.yml" <<EOF
# Fecha de última actualización de cada preprint. La escribe actualizar-preprint.sh automáticamente.
$CLAVE:
  updated: $PREPRINT_DATE
EOF

echo "✅ Listo. Preprint (actualizado $PREPRINT_DATE) copiado a la web."
echo "   Sube los cambios para publicarlo:"
echo "     git add assets/pdf/sanroman2026_missedopportunities_osf.pdf _data/preprints.yml && git commit -m \"Update preprint\" && git push"
