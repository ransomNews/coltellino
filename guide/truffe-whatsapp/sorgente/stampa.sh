#!/bin/sh
# Ristampa il PDF della guida da guida-truffe-whatsapp.html: A4, taggato per
# i lettori di schermo, con segnalibri, link cliccabili e metadati ransomNews.
# Servono Google Chrome e exiftool (brew install exiftool).
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT="$(cd .. && pwd)/ransomNews_guida_truffe-whatsapp.pdf"

"$CHROME" --headless --no-pdf-header-footer --export-tagged-pdf \
  --generate-pdf-document-outline --virtual-time-budget=10000 \
  --print-to-pdf="$OUT" "file://$PWD/guida-truffe-whatsapp.html"

exiftool -q -overwrite_original \
  -PDF:Title="ransomNews · Guida truffe WhatsApp" \
  -PDF:Author="ransomNews" \
  -PDF:Creator="ransomNews" \
  -PDF:Subject="Come riconoscere le truffe WhatsApp e, caso per caso, tutti i passaggi per risolvere" \
  -PDF:Keywords="ransomNews, Forenser, WhatsApp, truffe, phishing, sicurezza" \
  -XMP-dc:Title="ransomNews · Guida truffe WhatsApp" \
  -XMP-dc:Creator="ransomNews" \
  -XMP-dc:Language="it" \
  -XMP-dc:Rights="CC BY 4.0, ransomNews" \
  "$OUT"

echo "Fatto: $OUT"
