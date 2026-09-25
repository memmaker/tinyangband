#!/bin/sh
# Build TinyAngband for the browser (Emscripten + Asyncify).
# Output goes to web/dist; deploy with web/deploy.sh.
set -e
cd "$(dirname "$0")/.."
OUT=web/dist
rm -rf "$OUT" web/stage && mkdir -p "$OUT" web/stage/lib

# Game files: everything but the X11 fonts and BMP tiles
for d in edit file help pref; do cp -R lib/$d web/stage/lib/; done
mkdir -p web/stage/lib/data web/stage/lib/script web/stage/lib/info web/stage/lib/save web/stage/lib/user web/stage/lib/apex web/stage/lib/bone
find web/stage -name 'Makefile*' -delete
# 16x16.bmp keyed on its "black" pixel -> PNG with alpha (drawn by the page)
python3 web/bmp2png.py lib/xtra/graf/16x16.bmp "$OUT/16x16.png"

SRCS=$(sed -n '/^tinyangband_SOURCES/,/^$/p' src/Makefile.am | grep -o '[a-z0-9_-]*\.c' \
	| grep -v '^main' | sed 's|^|src/|')

emcc -O2 -fcommon -std=gnu99 -DHAVE_CONFIG_H -DUSE_WEB -Isrc -w \
	$SRCS src/main.c src/main-web.c \
	-o "$OUT/tinyangband-core.js" \
	-sASYNCIFY -sASYNCIFY_STACK_SIZE=65536 -sSTACK_SIZE=1048576 \
	-sALLOW_MEMORY_GROWTH -sINITIAL_MEMORY=64MB \
	-sEXPORTED_FUNCTIONS=_main,_web_request_save \
	-sEXPORTED_RUNTIME_METHODS=FS,IDBFS,HEAPU8,addRunDependency,removeRunDependency \
	-sFORCE_FILESYSTEM -lidbfs.js -sENVIRONMENT=web \
	--preload-file web/stage/lib@/tinyangband/lib

cp web/index.html web/rvip-wm.js web/tinyangband.js "$OUT/"
# Sounds and town music: TinyAngband ships none; same event names as Quickband's set
cp -R ../quickband/lib/xtra/sound "$OUT/sound"
mkdir -p "$OUT/music" && cp ../quickband/web/music/new_town.ogg "$OUT/music/"
python3 web/make-help.py > "$OUT/help.html"
rm -rf web/stage
ls -la "$OUT"
