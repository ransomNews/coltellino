# Sorgente delle immagini

`banner.png` (in cima al README) e `social-preview.png` (anteprima del link sui social, da caricare in Settings, Social preview) si rifanno da questi file con Chrome:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --hide-scrollbars --force-device-scale-factor=1 --virtual-time-budget=8000 --window-size=1280,360 --screenshot="$PWD/../banner.png" "file://$PWD/banner.html"
```

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --hide-scrollbars --force-device-scale-factor=1 --virtual-time-budget=8000 --window-size=1280,640 --screenshot="$PWD/../social-preview.png" "file://$PWD/social.html"
```

Colori presi dal PDF della guida truffe WhatsApp, carattere Poppins come sul sito.

`social.html` segue il modello di GitHub per le anteprime dei repo: tutto il contenuto sta dentro un bordo di 80 pixel, così niente viene tagliato. `social.html` non usa `base.css`.
