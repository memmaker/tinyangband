#!/usr/bin/env python3
"""Append grey "statue" copies of the monster tile rows to lib/xtra/graf/16x16.bmp.

Monster sprites live in rows 29..69 (attr 0x9D..0xC5); their grey copies go to
rows 71..111 (row + 42), which cave.c's statue code relies on.  Idempotent: the
sheet is cut back to its original 71 rows before the copies are added."""
import os
from PIL import Image

T = 16
FIRST, LAST, SHIFT = 29, 69, 42          # keep in sync with STATUE_ROW_* in defines.h
LEVELS = 24                              # grey shades added to the palette

here = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(here, 'lib/xtra/graf/16x16.bmp')

im = Image.open(path)
assert im.mode == 'P'
base = im.crop((0, 0, im.width, 71 * T))
pal = base.getpalette()[:256 * 3]
pal += [0] * (256 * 3 - len(pal))

# The frontend treats this pixel's colour as transparent (main-x11.c Term_pict)
blank = base.getpixel((0, 6 * T))

# Palette slots no pixel uses get the grey ramp (never pure black)
used = set(base.getdata())
free = [i for i in range(256) if i not in used][:LEVELS]
assert len(free) == LEVELS, 'not enough free palette entries'
shades = [70 + (170 * k) // (LEVELS - 1) for k in range(LEVELS)]
for idx, g in zip(free, shades):
    pal[idx * 3:idx * 3 + 3] = [g, g, g]

def grey(i):
    if i == blank:
        return i
    r, g, b = pal[i * 3:i * 3 + 3]
    lum = (299 * r + 587 * g + 114 * b) / 1000
    return free[min(LEVELS - 1, round(lum / 255 * (LEVELS - 1)))]

lut = [grey(i) for i in range(256)]

out = Image.new('P', (im.width, (LAST + SHIFT + 1) * T))
out.putpalette(pal)
out.paste(base, (0, 0))
strip = base.crop((0, FIRST * T, im.width, (LAST + 1) * T))
strip.putdata([lut[i] for i in strip.getdata()])
out.paste(strip, (0, (FIRST + SHIFT) * T))
out.save(path)
print(f'{path}: {out.size[1] // T} rows, grey copies of rows {FIRST}..{LAST} at +{SHIFT}')
