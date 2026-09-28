#!/bin/sh
# Windows build (native Windows frontend), cross-compiled with MinGW.
# sh build-win.sh [CROSS=x86_64-w64-mingw32-]  -> tinyangband.exe
set -e
cd "$(dirname "$0")/src"
CROSS=${CROSS:-x86_64-w64-mingw32-}
SRCS="artifact.c autopick.c birth.c bldg.c cave.c chuukei.c cmd1.c cmd2.c cmd3.c cmd4.c cmd5.c cmd6.c
	dungeon.c effects.c files.c flavor.c generate.c grid.c init1.c init2.c japanese.c load.c
	melee1.c melee2.c monster1.c monster2.c mspells1.c mspells2.c mutation.c notes.c
	obj_kind.c object1.c object2.c racial.c rooms.c save.c scores.c spells1.c spells2.c spells3.c
	store.c streams.c tables.c util.c variable.c wild.c wizard1.c wizard2.c xtra1.c xtra2.c
	z-form.c z-rand.c z-term.c z-util.c z-virt.c main-win.c readdib.c"
${CROSS}windres ang_eng.rc -O coff -o angband.res
${CROSS}gcc -O2 -w -fcommon -DWINDOWS -I. $SRCS angband.res -s -static -mwindows -lwinmm -lws2_32 -o ../tinyangband.exe
rm -f angband.res
