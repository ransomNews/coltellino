#!/bin/sh
# Ristampa il PDF della guida da guida-pin-sim.html: A4, taggato per
# i lettori di schermo, con segnalibri, link cliccabili e metadati ransomNews.
# Servono Google Chrome, exiftool e pdftotext (brew install exiftool poppler).
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT="$(cd .. && pwd)/ransomNews_guida_pin-sim.pdf"

"$CHROME" --headless --no-pdf-header-footer --export-tagged-pdf \
  --generate-pdf-document-outline --virtual-time-budget=10000 \
  --print-to-pdf="$OUT" "file://$PWD/guida-pin-sim.html"

exiftool -q -overwrite_original \
  -PDF:Title="ransomNews · Guida PIN SIM" \
  -PDF:Author="ransomNews" \
  -PDF:Creator="ransomNews" \
  -PDF:Subject="Perché attivare il blocco della SIM con PIN e come farlo, passo per passo, su Android e iPhone" \
  -PDF:Keywords="ransomNews, SIM, PIN, PUK, SIM swap, verifica in due passaggi, sicurezza" \
  -XMP-dc:Title="ransomNews · Guida PIN SIM" \
  -XMP-dc:Creator="ransomNews" \
  -XMP-dc:Language="it" \
  -XMP-dc:Rights="CC BY 4.0, ransomNews" \
  "$OUT"

# Controllo dell'impaginazione: nessuna pagina deve finire a metà.
if command -v pdftotext >/dev/null 2>&1; then
  python3 controlla_impaginazione.py "$OUT" || {
    echo "ATTENZIONE: impaginazione da correggere (vedi sopra). Non pubblicare questo PDF." >&2
    exit 1
  }
else
  echo "ATTENZIONE: controllo impaginazione saltato, manca pdftotext (brew install poppler)." >&2
fi

echo "Fatto: $OUT"
