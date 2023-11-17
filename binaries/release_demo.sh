#!/bin/bash

folder=~/Hobbies/0-IF/AAAAMes-jeux/retro/tristam-en/disks
projectname=tristam-island-demo

# MAKE SURE YOU HAVE IF_DEMO FLAG ON IN THE .INF
# THEN MAKE RETRO AND RUN THIS SCRIPT

cd demo
rm *.zip
cd ..


# Amiga
zip -j amiga-demo.zip manuals/manual-amiga.txt $folder"/tristam.adf"

# Amstrad CPC
zip -j amstrad-cpc-demo.zip manuals/manual-amstradcpc.txt $folder"/tristam-cpc.dsk"
# Amstrad PCW
zip -j amstrad-pcw-demo.zip manuals/manual-amstradpcw.txt $folder"/tristam-pcw.dsk"

# Apple II
zip -j appleii-demo.zip manuals/manual-appleii.txt $folder"/tristam-appleii.dsk"

# Atari 8-bit
zip -j atari-8bit-demo.zip manuals/manual-atari8bit.txt $folder"/tristam.atr"

# Atari ST
cp manuals/manual-atariST.txt $folder"/AtariST"
pushd $folder"/AtariST"
zip -r ../../release/atari-st-demo.zip manual-atariST.txt tristam.st ./contents/
popd

# BBC & Acorn
zip -j bbc-acorn-demo.zip manuals/manual-bbc-acorn.txt $folder"/tristam.ssd"

# Commodore PET & VIC-20
zip -j commodore-pet-demo.zip manuals/manual-commodore-pet.txt $folder"/tristam-pet.d64"
zip -j commodore-vic20-demo.zip manuals/manual-commodore-vic20.txt $folder"/tristam-vic20.d64"
# Commodore Plus/4
zip -j commodore-plus4-demo.zip manuals/manual-commodore-plus4.txt $folder"/tristam-plus4.d64" $folder"/tristam-plus4.d81"
# Commodore 64
zip -j commodore64-demo.zip manuals/manual-commodore64.txt $folder"/tristam-c64.d64" $folder"/tristam-c64.d81"
# Commodore 128
zip -j commodore128-demo.zip manuals/manual-commodore128.txt $folder"/tristam-c128.d64" $folder"/tristam-c128.d81"

# DOS
zip -j dos-demo.zip manuals/manual-DOS.txt $folder"/DOS/DOSINFO.COM" $folder"/DOS/FROTZ.EXE" $folder"/DOS/PICTVIEW.CFG" $folder"/DOS/SCREEN.PNG" $folder"/DOS/STORY.DAT" $folder"/DOS/TRISTAM.BAT" $folder"/DOS/VIEWER.EXE"

# Dragon 64
zip -j dragon64-demo.zip manuals/manual-dragon64.txt $folder"/tristam-dragon64.vdk" $folder"/tristam-dragon64-loader.vdk"

# Dreamcast
zip -j dreamcast-demo.zip manuals/manual-dreamcast.txt $folder"/tristam.cdi"

# GameBoy
zip -j gameboy-demo.zip manuals/manual-gameboy.txt $folder"/tristam.gb"

# GameBoy advance
zip -j gameboy-advance-demo.zip manuals/manual-gameboyadvance.txt $folder"/tristam.gba"

# Lectrote
cp $folder"/tristam.zblorb" ../../Interpreters/lectrote
cp manuals/manual-windows.txt ../../Interpreters/lectrote/
cp manuals/manual-linux.txt ../../Interpreters/lectrote/
cp manuals/manual-osx.txt ../../Interpreters/lectrote/
pushd ../../Interpreters/lectrote
zip -r $folder"/../release/windows-32bit-demo.zip" manual-windows.txt tristam.zblorb Lectrote-win32-ia32/ 
zip -r $folder"/../release/windows-64bit-demo.zip" manual-windows.txt tristam.zblorb Lectrote-win32-x64/
zip -r $folder"/../release/linux-32bit-demo.zip" manual-linux.txt tristam.zblorb Lectrote-linux-ia32/
zip -r $folder"/../release/linux-64bit-demo.zip" manual-linux.txt tristam.zblorb Lectrote-linux-x64/
zip $folder"/../release/osx-64bit-demo.zip" manual-osx.txt tristam.zblorb Lectrote-macos-x64.dmg
popd

# Macintosh
zip -j macintosh-demo.zip manuals/manual-macintosh.txt $folder"/tristam-mac.dsk"

# MEGA65
zip -j mega65-demo.zip manuals/manual-mega65.txt $folder"/tristam.d81"

# MSX
zip -j msx-demo.zip manuals/manual-msx.txt $folder"/tristam-msx.dsk"

# Nintendo DS
cp manuals/manual-nintendoDS.txt ../../Interpreters/glkpogo-nds/
pushd ../../Interpreters/glkpogo-nds
zip -r ~/Hobbies/0-IF/AAAAMes-jeux/retro/tristam-en/release/nintendods-demo.zip manual-nintendoDS.txt frotz.nds ./DATA ./fonts
popd

# Nintendo DS - DSFrotz package
cp manuals/manual-nintendoDS-DSfrotz.txt $folder"/DSFrotz/"
pushd $folder"/DSFrotz"
zip -r ~/Hobbies/0-IF/AAAAMes-jeux/retro/tristam-en/release/nintendods-dsfrotz-demo.zip manual-nintendoDS-DSfrotz.txt ./data/DSFrotz/Tristam\ Island
popd

# Oric Atmos
zip -j oric-atmos-telestrat-demo.zip manuals/manual-oric-atmos-telestrat.txt ../../Interpreters/pinforic.dsk $folder"/tristam-oric.dsk"

# PSP
pushd $folder"/PSP"
zip -r ../../release/psp-demo.zip ../../release/manuals/manual-psp.txt *
popd

# Sam Coupé
zip -j sam-coupe-demo.zip manuals/manual-samcoupe.txt $folder"/tristam-samcoupe.cpm" $folder"/tristam-samcoupe-prodosv2.dsk"

# Spectrum +3
zip -j spectrum-plus3-demo.zip manuals/manual-spectrumplus3.txt $folder"/tristam-spectrum3zxzvm.dsk" $folder"/tristam-spectrum3cpm.dsk"

# Spectrum Next
zip -j spectrum-next-demo.zip manuals/manual-spectrumnext.txt $folder"/tristam.z3"

# TI-83+ & TI-84+CE
cp manuals/manual-ti84.txt $folder"/TI84"
pushd $folder"/TI84"
zip -r ../../release/ti84-demo.zip manual-ti84.txt zemu.8xp ./vars/
popd

# TI-99/4A
zip -j ti994a-demo.zip manuals/manual-ti994a.txt $folder"/tristam-ti994a.dsk"

# TRS-CoCo
zip -j trs-coco-demo.zip manuals/manual-trscoco.txt $folder"/tristam-coco.dsk"

# Z-machine version
zip -j z-machine-demo.zip manuals/manual-zmachine.txt $folder"/tristam.z3"


mv *.zip demo/

# Uploading with butler

cd demo

butler push amiga-demo.zip hlabrande/$projectname":amiga"
butler push amstrad-cpc-demo.zip hlabrande/$projectname":amstrad-cpc"
butler push amstrad-pcw-demo.zip hlabrande/$projectname":amstrad-pcw"
butler push appleii-demo.zip hlabrande/$projectname":appleii"
butler push atari-8bit-demo.zip hlabrande/$projectname":atari-8bit"
butler push atari-st-demo.zip hlabrande/$projectname":atari-st"
butler push bbc-acorn-demo.zip hlabrande/$projectname":bbc-acorn"
butler push commodore-pet-vic20-demo.zip hlabrande/$projectname":commodore-8bit"
butler push commodore-plus4-demo.zip hlabrande/$projectname":plus4"
butler push commodore64-demo.zip hlabrande/$projectname":c64"
butler push commodore128-demo.zip hlabrande/$projectname":c128"
butler push dos-demo.zip hlabrande/$projectname":dos"
butler push dragon64-demo.zip hlabrande/$projectname":dragon64"
butler push dreamcast-demo.zip hlabrande/$projectname":dreamcast"
butler push gameboy-advance-demo.zip hlabrande/$projectname":gba"
butler push gameboy-demo.zip hlabrande/$projectname":gb"
butler push macintosh-demo.zip hlabrande/$projectname":macintosh"
butler push mega65-demo.zip hlabrande/$projectname":mega65"
butler push msx-demo.zip hlabrande/$projectname":msx"
butler push nintendods-demo.zip hlabrande/$projectname":nds"
butler push nintendods-dsfrotz-demo.zip hlabrande/$projectname":nds-dsfrotz"
butler push psp-demo.zip hlabrande/$projectname":psp"
butler push oric-atmos-telestrat-demo.zip hlabrande/$projectname":oric-atmos"
butler push sam-coupe-demo.zip hlabrande/$projectname":sam-coupe"
butler push spectrum-plus3-demo.zip hlabrande/$projectname":spectrum-plus3"
butler push spectrum-next-demo.zip hlabrande/$projectname":spectrum-next"
butler push ti84-demo.zip hlabrande/$projectname":ti83-ti84"
butler push ti994a-demo.zip hlabrande/$projectname":ti994a"
butler push trs-coco-demo.zip hlabrande/$projectname":trs-coco"
butler push z-machine-demo.zip hlabrande/$projectname":z3"
butler push windows-32bit-demo.zip hlabrande/$projectname":win32"
butler push windows-64bit-demo.zip hlabrande/$projectname":win64"
butler push linux-32bit-demo.zip hlabrande/$projectname":linux32"
butler push linux-64bit-demo.zip hlabrande/$projectname":linux64"
butler push osx-64bit-demo.zip hlabrande/$projectname":osx64"

cd ../manuals
butler push manual-cpm.txt hlabrande/$projectname":cpm"
butler push manual-trs80.txt hlabrande/$projectname":trs80"
