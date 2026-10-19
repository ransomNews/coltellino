#!/usr/bin/env python3
"""Controlla l'impaginazione di un PDF stampato: nessuna pagina deve finire a metà.

Legge ogni pagina con pdftotext (poppler) e segnala:
- una pagina, tranne l'ultima, il cui testo finisce prima dell'80% dell'altezza;
- uno spazio vuoto più alto del 12% della pagina, anche in cima, prima della
  prima riga di testo.

Nasce dalla ristampa del 19 ottobre 2026, quando ogni scheda partiva su una
pagina nuova e dopo il titolo della Parte B restavano due terzi di pagina vuoti.

Uso: python3 controlla_impaginazione.py file.pdf
Esce con 0 se va bene, 1 se trova problemi, 2 se non riesce a leggere il file.
"""
import re
import subprocess
import sys

MIN_RIEMPIMENTO = 0.80
MAX_BUCO = 0.12


def main(pdf):
    try:
        out = subprocess.run(['pdftotext', '-bbox', pdf, '-'], capture_output=True, text=True, check=True).stdout
    except (OSError, subprocess.CalledProcessError) as e:
        print(f'errore: non riesco a leggere {pdf} con pdftotext ({e})', file=sys.stderr)
        return 2
    pagine = out.split('<page ')[1:]
    problemi = 0
    for n, p in enumerate(pagine, 1):
        h = float(re.search(r'height="([\d.]+)"', p).group(1))
        righe = sorted((float(a), float(b)) for a, b in re.findall(r'yMin="(-?[\d.]+)" xMax="-?[\d.]+" yMax="(-?[\d.]+)"', p))
        if not righe:
            print(f'pagina {n}: vuota')
            problemi += 1
            continue
        fine, buco, dove = 0.0, 0.0, 0.0
        for alto, basso in righe:
            if alto - fine > buco:
                buco, dove = alto - fine, fine
            fine = max(fine, basso)
        if n < len(pagine) and fine < MIN_RIEMPIMENTO * h:
            print(f'pagina {n}: il testo finisce al {fine / h:.0%} della pagina')
            problemi += 1
        if buco > MAX_BUCO * h:
            print(f'pagina {n}: {buco / h:.0%} di pagina vuoto dopo il {dove / h:.0%}')
            problemi += 1
    print(f'{len(pagine)} pagine controllate, {problemi} problemi')
    return 1 if problemi else 0


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
