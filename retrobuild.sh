#!/bin/sh

currentfolder=PATHTOMYIFFOLDER/retro/

inform=PATHTOMYIFFOLDER/outils/inform-636-beta/inform
lib=,$currentfolder"puny/PunyInform-v3/lib"
a8bin=$currentfolder"Interpreters/a8.bin"
info3m=$currentfolder"Interpreters/info3m.bin"
v=-v3


main()
{
	# find the radical
	game=`basename $game .inf`
	# name without the "-en" and "-fr" to put on all the disks
        gamename="tristam"
        # the filename
	gamefile=$gamename".z3"
	
	# make a new folder
	diskfolder=$currentfolder""$game"/disks"
	diskfolder_old=$diskfolder"_old"
	rm -rf $diskfolder_old
	mkdir $diskfolder_old
	mv -vf $diskfolder/* $diskfolder_old
	
	# compile the game	
	$inform -d2esi $v +$lib $game".inf"
	#rm $gamefile
	# compile a crunched version of the game
        #python extra-abbrev.py $game".inf"
	#$inform -d2esi $v +$lib $game"-crunch.inf"
	#cp $game"-crunch.z3" $gamefile
	
	cp $gamefile STORY.DAT
	
	
	# Adding to the zblorb for lectrote
	python Interpreters/blorbtool.py $game.zblorb import ZCOD $gamefile -f
	cp $gamefile Interpreters/lectrote/
	cp $game.zblorb Interpreters/lectrote
	
	
	######## INFOCOM TERPS
	
	
	# building the atari 8bit image
	#    (to execute it: sudo su, cd /usr/share/atari800, atari800 PATHTOMYIFFOLDER/retro/tristam-en.atr)
	#    TODO: fix my paths to the roms (in /home/hugo/.atari.cfg ?)
	# WARNING: this outputs a disk image for 130kb ; but the terp is 7kb and my game is 128kb, so it won't fit (for a physical release). But people use a dongle to load disks and roms, nowadays, so it's still worth releasing; we might just need to make it a 230kb disk, that's all.
	cat Interpreters/a8.bin $gamefile > $gamename".atr"
	size=`ls -l $gamename".atr" | cut -d' ' -f5`
	if [ "$size" -lt "138256" ];
        then
            head --bytes $((138256-$size)) /dev/zero >> $gamename".atr"
	fi
	
	# building the Apple II image
	# ref: https://www.kansasfest.org/wp-content/uploads/apple_ii_inform_paper.pdf
	# this sometimes doesn't work with punyinform (version M of the terp)
	interlz3 $info3m $gamefile $gamename"-appleii.dsk" >/dev/null
	# this always works but is a bit slower
	#cat Interpreters/info3e.bin $gamefile >$gamename"-appleii.dsk"
        #size=`ls -l $gamename"-appleii.dsk" | cut -d' ' -f5`
        #head --bytes $((143360-$size)) /dev/zero >> $gamename"-appleii.dsk"
	
	
	
	# building the CoCo 32 col image
	# (mame coco3 -window -flop1 tristam-en-coco.dsk , then LOADM "GAME then EXEC)
	# coco-newgame generated from "decb dskini newgame.dsk"
	# ref: https://retrotinker.blogspot.com/2017/11/building-infocom-disk-images-for-coco.html?m=1
	cp Interpreters/coco-newgame.dsk $gamename"-coco.dsk"
	dd if=Interpreters/ballyhoo-coco.dsk of=$gamename"-coco.dsk" conv=notrunc bs=1 count=161280 >/dev/null
	# skip the first two tracks, they have the terp
	dd if=$gamefile of=$gamename"-coco.dsk" conv=notrunc bs=1 seek=9216 count=64512 >/dev/null
	# track starting at 64512 is the directory, for loadm + exec
	dd if=$gamefile of=$gamename"-coco.dsk" conv=notrunc bs=1 skip=64512 seek=82944 count=69120 >/dev/null
        # we're fine cause the boot track (34) is at 156672, and we land at 147 or 152 
        
        # building the Dragon64 image, which uses the coco disk
        # (mame dragon64 -window -flop1 tristam-dragon64.vdk -flop2 tristam-dragon64-loader.vdk then LOAD"2:ENG05V32.BIN" then EXEC&H1100)
        # (the ":" is Shift+°, the key next to 0)
        # Dragon64 reference: http://www.retrowiki.es/viewtopic.php?t=200033991
        # create an empty Dragon disk image
        touch $gamename"-dragon64.vdk"
        # append Dragon DOS header to file
        dd if=Interpreters/dragon64/dragondos_header of=$gamename"-dragon64.vdk" bs=1G oflag=append conv=notrunc
        # append TRS CoCo disk image to file
        dd if=$gamename"-coco.dsk" of=$gamename"-dragon64.vdk" bs=1G oflag=append conv=notrunc
        # fill Dragon disk image with bytes for the correct file size
        dd if=Interpreters/dragon64/dragon_bytefill of=$gamename"-dragon64.vdk" bs=1G oflag=append conv=notrunc
        
        
        # building the CoCo 64-col image
        # TODO: this has never worked
	# (mame coco3 -window -flop1 tristam-en-coco.dsk , then LOADM "GAME then EXEC)
	# coco-newgame generated from "decb dskini newgame.dsk"
	# ref: https://thezippsterzone.com/2018/05/11/64-column-infocom-interpreter/
	#cp Interpreters/coco-newgame.dsk $gamename"-coco3-64col.dsk"
	#dd if=Interpreters/ballyhoo-coco3-64col.dsk of=$gamename"-coco3-64col.dsk" conv=notrunc bs=1 count=161280 >/dev/null
	# skip the first two tracks, they have the terp
	#dd if=$gamefile of=$gamename"-coco3-64col.dsk" conv=notrunc bs=1 seek=9216 count=64512 >/dev/null
	# track starting at 64512 is the directory, for loadm + exec
	#dd if=$gamefile of=$gamename"-coco3-64col.dsk" conv=notrunc bs=1 skip=64512 seek=82944 count=69120 >/dev/null
        # we're fine cause the boot track (34) is at 156672, and we land at 147 or 152 
        
        
        
        
	# building the CPC Image - "|cpm" to run it (| = shift + [ on a qwerty)
        cp Interpreters/CPC/example.dsk $gamename"-cpc.dsk"
        #cp Interpreters/CPC/cpc_pcw.dsk $gamename"-cpc.dsk"
            #place story on disk image (how do we suppress all the output?)
        idsk $gamename"-cpc.dsk" -i Interpreters/CPC/DISC -f >/dev/null
        idsk $gamename"-cpc.dsk" -i Interpreters/CPC/PAL -t 1 -c a000 -f >/dev/null
        idsk $gamename"-cpc.dsk" -i Interpreters/CPC/SCREEN -t 1 -c c000 -f >/dev/null
        idsk $gamename"-cpc.dsk" -i STORY.DAT -t 0 -f >/dev/null
        
        # building the PCW image - "INTERPRE"
        cp Interpreters/CPC/cpc_pcw.dsk $gamename"-pcw.dsk"
        idsk $gamename"-pcw.dsk" -i STORY.DAT -t 0 >/dev/null
    
        # to test : fuse --machine plus3 Interpreters/CPM+.dsk --no-auto-load, then when it's done loading insert disk "tristam-spectrum3.dsk" then type PLAY
        cp Interpreters/Spec_Infocom.dsk $gamename"-spectrum3cpm.dsk"
        idsk $gamename"-spectrum3cpm.dsk" -i STORY.DAT -t 0 >/dev/null
        
        
        # MSX
        # testing ./fmsx -diska PATHTOMYIFFOLDER/retro/tristam-en-msx.dsk -msx2 (or -msx1), then DIR, then TRISTAM
        cp STORY.DAT Interpreters/MSX/
        cp graphical/msx-retouche.sc2 Interpreters/MSX/LPIC.SC2
        cd Interpreters/MSX
        cp MSXTERP.DSK $gamename"-msx.dsk"
        ./dsktool a $gamename"-msx.dsk" LPIC.SC2 STORY.DAT
        cd $currentfolder
        mv Interpreters/MSX/$gamename"-msx.dsk" .
        
        
        
        
        
        
        
        
        ########### NON INFOCOM TERPS
        
        
        
        # ZXZVM for spectrum +3 : it's in 64col, grey, barely legible... in 32 col the font needs to change... meh...
        #    stefan hates this terp and says it's super slow. Looks about the same in an emulator but I believe him
        # to test : fuse --machine plus3 tristam-en-spectrum3zxzvm.dsk
        cp Interpreters/Spec_ZXZVM.dsk $gamename"-spectrum3zxzvm.dsk"
        idsk $gamename"-spectrum3zxzvm.dsk" -i STORY.DAT -t 0 >/dev/null
        
        # building the Atari ST Image
        #cp Interpreters/ATARIST.PRG TRIS.PRG
        #zip -v tristam.zip TRIS.PRG TRIS.PRG >/dev/null
        mkdir $diskfolder"/AtariST"
        mkdir $diskfolder"/AtariST/contents"
        cp $gamefile Interpreters/AtariST/
        cp $gamefile Interpreters/AtariST/contents
        cd Interpreters/AtariST
        rm $gamename".st"
        zip -v $gamename".zip" JZIP.TTP JZIP.TTP >/dev/null
        zip -v $gamename".zip" $gamefile $gamefile >/dev/null
        zip -rv $gamename".zip" AUTO/INTROTRI.PRG AUTO/INTROTRI.PRG  >/dev/null
        zip2st $gamename".zip" $gamename".st" >/dev/null
        rm $gamename".zip"
        cd $currentfolder
        cp Interpreters/AtariST/$gamename".st" $diskfolder"/AtariST"
        cp -R Interpreters/AtariST/contents/ $diskfolder"/AtariST"
            # to test : hatari tristam-en.st, then click in the .ttp in the disk and type "tristam-en.z3"
        
        
        # Ozmoo for Commodore
        # C64 (with loader screen)
        ruby Interpreters/ozmoo/my-make.rb -S1 -i Interpreters/ozmoo/sc.kla -c Interpreters/ozmoo/tristam_optimization.txt -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        mv c64_$gamename".d64" $gamename"-c64.d64"
        ruby Interpreters/ozmoo/my-make.rb -81 -i Interpreters/ozmoo/sc.kla -c Interpreters/ozmoo/tristam_optimization.txt -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        mv c64_$gamename".d81" $gamename"-c64.d81"
	# building the Mega65 Image
	# run xemu-xmega65, right click attach d81 image, go64, load"*"
	cp $gamefile Interpreters/ozmoo
	cd Interpreters/ozmoo/
	ruby my-make.rb -81 -t:mega65 -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        #ruby Interpreters/ozmoo/my-make.rb -81 -t:mega65 -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        cp mega65_$gamename".d81" ~/.local/share/xemu-lgb/mega65/TRISTAM.D81
        mv mega65_$gamename".d81" ../../$gamename".d81"
        cd ../..
        # building the plus4 Image (with loader screen)
        ruby Interpreters/ozmoo/my-make.rb -S1 -c Interpreters/ozmoo/tristam_optimization.txt -t:plus4 -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        mv plus4_$gamename".d64" $gamename"-plus4.d64"
        ruby Interpreters/ozmoo/my-make.rb -81 -c Interpreters/ozmoo/tristam_optimization.txt -t:plus4 -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        mv plus4_$gamename".d81" $gamename"-plus4.d81"
        # building the C128 image
        ruby Interpreters/ozmoo/my-make.rb -S1 -c Interpreters/ozmoo/tristam_optimization.txt -t:c128 -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        mv c128_$gamename".d64" $gamename"-c128.d64"
        ruby Interpreters/ozmoo/my-make.rb -81 -c Interpreters/ozmoo/tristam_optimization.txt -t:c128 -rc:4=13,5=9 -dc:4:2 -sc:5 -ss1:"TRISTAM ISLAND" -ss2:"by Hugo Labrande" -ss3:"hlabrande.itch.io" -sw:6 $gamefile >/dev/null
        mv c128_$gamename".d81" $gamename"-c128.d81"
        
	# building the Commodore PET & VIC-20
	# to start: LOAD"$",8,1, then LIST, then LOAD"tristam-pet",8,1
	c1541 -format $gamename",if" D64 $gamename"-pet-vic20.d64" 8  >/dev/null
	# F1-F4 + Shift+F2 to change colors, it's written in config.seq (that you can extract with droid64)
        # add ram expansions: dans vice, "paramètres > paramètres du modèle > expansions de mémoire > config communes > full"
        c1541 -attach $gamename"-pet-vic20.d64" -write Interpreters/z3-vic $gamename"-vic"  >/dev/null
        c1541 -attach $gamename"-pet-vic20.d64" -write Interpreters/z3-pet $gamename"-pet"  >/dev/null
        c1541 -attach $gamename"-pet-vic20.d64" -write $gamefile "z3 story,s"  >/dev/null
        c1541 -attach $gamename"-pet-vic20.d64" -write Interpreters/config.seq "config,s" >/dev/null
        
        

	# building the TI-99/4A image
	# note: I have a specially-crafted file that was made for me with TRIS1 and TRIS2
	#       for other/future games: change the names of the files & the names in the terps (80TRIS-I, TRIS-I), and the menu in LOAD
	# to test: ~/Documents/ooey-gui/ooeygui, config "tristam-config.xml"
	# note: the game requires a supercart if the high memory mark is at > 22528 ; you test that by looking at the two-byte value starting at byte 4 of the story file
	# note: one day, we'll have an updated interpreter from InsaneMultitasker with accented support and native z3 support! woop!
	cp $gamefile Interpreters/TI994A/tris.z3
	#cp $gamefile Interpreters/TI994A/tris.z3
        # for the loader screen - use Convert9918 to take a PNG and save in RAW FILE (6144 bytes per file), no headers, then concatenate
        #cat TRISBIN.TIAP TRISBIN.TIAC >TRISBIN
	cp graphical/ti99-retouche.bin Interpreters/TI994A/TRISBIN
	cd Interpreters/TI994A
	python3 testSupercart.py
	python3 z3toTI994A.py
	cp TRISTAM.dsk $gamename"-ti994a.dsk"
	./tidisk --add=TRIS1 $gamename"-ti994a.dsk" >/dev/null
        ./tidisk --add=TRIS2 $gamename"-ti994a.dsk" >/dev/null
        # this command has never worked, and messed up the disk in fact :
        #     ./tidisk --add=TRISBIN $game"-ti994a.dsk" >/dev/null
	cd $currentfolder
	mv Interpreters/TI994A/$gamename"-ti994a.dsk" .
	
	# building the DOS package
	#cp graphical/LoaderScreens/AtariST-E.png Interpreters/DOS/
	cp -r Interpreters/DOS/ $diskfolder
        cp STORY.DAT $diskfolder"/DOS/STORY.DAT"
        
        # building the Ozmoo for Acorn disk
        cp $gamefile Interpreters/OzmooBeeb/$gamefile
        #cp $gamefile Interpreters/OzmooBeeb
        cd Interpreters/OzmooBeeb
        #python convert.py # generate the cover image
        # this is to make a disk with all the interpreters on it; but your game can't be more than 124k if you include a screen loader
        #     unless steve has updated his interpreter to compress the image and save that space
        python make-acorn.py --splash-image output.bbc --splash-mode 2 --title "TRISTAM ISLAND" --subtitle "A game by Hugo Labrande." --default-fg-colour 7 --default-bg-colour 0 --default-mode-7-status-colour 6 $gamefile
        cd $currentfolder
        cp Interpreters/OzmooBeeb/$gamename.ssd .
        
        # building the SAM Coupé image
        # (emulator: SimCoupé)
        cp $gamefile story.dat
        cp Interpreters/SAM_image.cpm .
        mv SAM_image.cpm $gamename"-samcoupe.cpm"
        cpmcp -f prodos $gamename"-samcoupe.cpm" story.dat 0:story.dat
        cpmls -f prodos $gamename"-samcoupe.cpm"
        rm story.dat
        
        
        # building the Amiga image
        cp $gamefile Story.Data
            #copy Amiga disk image template
        cp Interpreters/Amiga/tristam.adf $gamename".adf"
        #cp Interpreters/Amiga/amiga_ZIP_no_screen.adf tristam.adf
            #add file to Amiga disk image
        #xdftool tristam.adf write Story.Data
            # to find that path: python, then import amitools, then amitools.__file__
        python3 ~/.local/lib/python3.6/site-packages/amitools/tools/xdftool.py $gamename".adf" delete Story.Data
        python3 ~/.local/lib/python3.6/site-packages/amitools/tools/xdftool.py $gamename".adf" write Story.Data
        #cp Interpreters/Amiga/splash.iff .
        #python3 ~/.local/lib/python3.6/site-packages/amitools/tools/xdftool.py tristam.adf delete splash.iff
        #python3 ~/.local/lib/python3.6/site-packages/amitools/tools/xdftool.py tristam.adf write splash.iff
            # to test : fs-uae tristam.adf
        rm Story.Data
        
        # putting a copy in the right folder for browser play
        # we're gonna use Encrusted by Sterling De Mille (TODO: never worked)
        #$inform -d2esi +$lib tristam.inf
        #python game2js.py tristam.z5 >browser-play/interpreter/tristam.z5.js

        
        # Building a Dreamcast image
        # NOTE: if you chose a theme and you don't like it, it was saved in the VMU, so you can just clear it there
        #cp $gamefile PATHTOMYIFFOLDER/retro/Interpreters/frotzdc-0.5/frotz
        #cd PATHTOMYIFFOLDER/retro/Interpreters/frotzdc-0.5
        cp $gamefile $currentfolder"Interpreters/frotzdc-1.1/"$game
        cd $currentfolder"Interpreters/frotzdc-1.1/"$game
        # Creating a .iso image from a directory 
        # Make sure you have a working IP.BIN in your current directory. Or change IP.BIN path to wherever you like.
        # Useful option for mkisofs is *-m* which allow to exclude files from the iso image (useful to remove .git, or some other folder)
        mkisofs -C 0,11702 -V "TristamIsland" -G IP.BIN -r -J -l -o $gamename".iso" . >/dev/null
        # Transform your .iso into a .cdi
        PATHTOMYIFFOLDER/retro/Interpreters/cdi4dc $gamename".iso" $gamename".cdi" >/dev/null
        # cleanup
        rm $gamename".iso"
        cd $currentfolder
        mv Interpreters/frotzdc-1.1/$game"/"$gamename".cdi" .
        
        # Building a Gameboy image
        cp $game".z3" $currentfolder"Interpreters/infgmb/STORY.DAT"
        # Run this to concatenate and stll get the right headers and filesize
        cd $currentfolder"Interpreters/infgmb"
        wine INFGMB.COM STORY.DAT >/dev/null
        cd $currentfolder
        # VisualBoyAdvance only recognizes .GB files
        cp $currentfolder"Interpreters/infgmb/STORY.GMB" $gamename".gb"
        
        # Building a GBA image
        cp $gamefile Interpreters/GBAFrotz/$gamename".zcode"
        cd $currentfolder"Interpreters/GBAFrotz"
        cp frotz.bin game.bin
        wine addfiles game.bin keyb.dat my-font.font fixed.font gfx5.font fixed4.font fixed6.font screenfox.font $gamename".zcode" tristam.cfg >/dev/null
        cd $currentfolder
        mv Interpreters/GBAFrotz/game.bin $gamename".gba"
        
        # Building a PSP image
        cp $gamefile Interpreters/psp/frotzpsp/story.file
        
        # Building a NDS image
        cp -R Interpreters/glkpogo-nds/ $diskfolder
        cp $gamefile $diskfolder"/glkpogo-nds/DATA/game.dat"
        cp -R Interpreters/DSFrotz/ $diskfolder
        cp $gamefile $diskfolder"/DSFrotz/data/DSFrotz/Tristam\ Island"

        
        # TI-84+CE - ZEMU by Nicholas Hunter Mosier
        #     current version: 6-sep
        cp $gamefile Interpreters/TI84/vars/$gamefile
        cp Interpreters/TI84/z3tozemu.py Interpreters/TI84/vars
        cd Interpreters/TI84/vars
        python3 z3tozemu.py
        rm z3tozemu.py
        rm $gamefile
        cd $currentfolder
        mkdir $diskfolder"/TI84"
        cp Interpreters/TI84/zemu.8xp $diskfolder"/TI84"
        cp -R Interpreters/TI84/vars/ $diskfolder"/TI84"
        
        
        # Oric - Pinforic
        # open Oricutron, right click load pinforic.dsk in the disc 0, LOAD"INFOCOM.COM" (software keyboard)
        #    then put the dsk in the disc 0 again and hit a key
        mkdosfs -C $gamename"-oric.dsk" 360
        cp STORY.DAT TRISTAM.DAT
        mcopy -i $gamename"-oric.dsk" TRISTAM.DAT ::TRISTAM.DAT
        rm TRISTAM.DAT # TODO keep it?
        Interpreters/Oric/raw2mfm-old $gamename"-oric.dsk"
        
        # Oric - Pinforic with magic boot
        #  works in Euphoric but not in Oricutron
        #  wine euphoric.exe -a t.dsk
        #        (careful, it's DOS, so the file name should be short)
        cp $gamefile Interpreters/Oric/TRISTAM.DAT
        cd Interpreters/Oric
        rm $gamename"-oric.dsk"
        mkdosfs -C $gamename"-oric.dsk" 720
        mcopy -i $gamename"-oric.dsk" PINFO20 ::PINFO20
        mcopy -i $gamename"-oric.dsk" TRISTAM.DAT  ::TRISTAM.DAT
        dd if=$gamename"-oric.dsk" of=end bs=512 skip=1
        cat MAGICBT2.BIN end >$gamename"_mfm.dsk"
        ./raw2mfm $gamename"_mfm.dsk"
        cd $currentfolder
        cp Interpreters/Oric/$gamename"_mfm.dsk" $gamename"-oric-auto.dsk"
        
        # Macintosh - MaxZIP by Andrew Plotkin
        # emulator is vmac, open system75.dsk to boot, drag the disk on the emulator, start MaxZIP, file open zcode file, filter=all
        cp Interpreters/Macintosh/$gamename"-mac.dsk" .
        hmount $gamename"-mac.dsk"
        hcopy $gamefile :
        hls
        humount

        
        
        
        # move everyone to the right folder
        cd $currentfolder
        mv STORY.DAT $diskfolder
        mv $gamename".adf" $diskfolder
        mv $gamename".atr" $diskfolder
        mv $gamename".cdi" $diskfolder
        mv $gamename".gb" $diskfolder
        mv $gamename".gba" $diskfolder
        mv $gamename".ssd" $diskfolder
        #mv $gamename".st" $diskfolder  already done
        mv $gamename"-appleii.dsk" $diskfolder
        mv $gamename"-c64.d64" $diskfolder
        mv $gamename"-c64.d81" $diskfolder
        mv $gamename"-c128.d64" $diskfolder
        mv $gamename"-c128.d81" $diskfolder
        mv $gamename"-plus4.d81" $diskfolder
        mv $gamename"-plus4.d64" $diskfolder
        mv $gamename".d81" $diskfolder
        mv $gamename"-mac.dsk" $diskfolder
        mv $gamename"-msx.dsk" $diskfolder
        mv $gamename"-oric.dsk" $diskfolder
        mv $gamename"-oric-auto.dsk" $diskfolder
        mv $gamename"-pcw.dsk" $diskfolder
        #mv $gamename"-coco3-64col.dsk" $diskfolder
        mv $gamename"-pet-vic20.d64" $diskfolder
        mv $gamename"-coco.dsk" $diskfolder
        mv $gamename"-dragon64.vdk" $diskfolder
        cp Interpreters/dragon64/dragon64_loader.vdk $diskfolder"/tristam-dragon64-loader.vdk"
        mv $gamename"-cpc.dsk" $diskfolder
        mv $gamename"-spectrum3cpm.dsk" $diskfolder
        mv $gamename"-spectrum3zxzvm.dsk" $diskfolder
        mv $gamename"-ti994a.dsk" $diskfolder
        mv $gamename"-samcoupe.cpm" $diskfolder
        cp Interpreters/Pro-DOS-v2.dsk $diskfolder"/tristam-samcoupe-prodosv2.dsk"
        
        mv $gamefile $diskfolder
        cp $game".z5" $diskfolder
        cp $game"-crunch.z3" $diskfolder
        cp $game"-gameboy.z3" $diskfolder
        cp $game".zblorb" $diskfolder
        
	exit 0
}

usage()
{
	echo "Usage: i6 game.inf"
	echo "       i6 [-5] game.inf"
	echo ""
	echo "       -5 : create v5 release"
	echo ""
	echo "By default i6 creates Z-code v3 releases."
	exit 0
}

# Start of script

if [ ! -z `echo $1 | grep '.inf'` ]; then
	game=$1
	main
elif [ -z "$1" ]; then
	usage
fi	

while getopts 5:h opts
do
	case $opts in
		5) game=$2
		   v=-v5
		   a8bin=""
		   main
		;;
		h) usage
		;;
		*) usage
		;;
	esac
done
