all: thez3en

runtests:
	ruby runtests.rb

thez3en:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esi -Cu -v3 +,PATHTOMYIFFOLDER/retro/tristam/puny/PunyInform-v3/lib tristam-en.inf

thez3fr:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esir -Cu -v3 --define NO_TRANSCRIPTING=1 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3fr tristam-fr.inf
	
thez3fr-noaccents:
	python3 transform_latin1_z3.py
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esi -Cu -v3 --define COMPILE_NO_ACCENTS=1 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3fr-noaccents tristam-fr-noaccents.inf
thez3fr-charsetchanges:
	python3 transform_latin1_z3.py
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esi -Cu -v3 --define NO_TRANSCRIPTING=1 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3fr-charsetchanges tristam-fr-charsetchanges.inf

	
retroen:
	./retrobuild.sh tristam-en.inf
retrofr:
	./retrobuild.sh tristam-fr.inf


thez5en:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esir -Cu -v5 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3/lib tristam-en.inf
thez5fr:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esirf -Cu -v5 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3fr tristam-fr.inf

	
	
	
thez3nakeden:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esi -Cu -v3 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3/lib tristam-en.inf
thez3nakedfr:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esi -Cu -v3 +,PATHTOMYIFFOLDER/retro/puny/myPunyInform/lib tristam-fr.inf


gb:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esi -Cu -v3 +,PATHTOMYIFFOLDER/retro/puny/myPunyInform/lib tristam-gameboy.inf



abbrinfen:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esiu -Cu -v3 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3/lib tristam-en.inf

abbren3:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esirf -Cu -v3 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3/lib tristam-en.inf
	python3 abbreviations.py -f
abbren5:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esirf -Cu -v5 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3/lib tristam-en.inf
	python3 abbreviations.py -f
abbrfr3:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esirf -Cu -v3 +,PATHTOMYIFFOLDER/retro/tristam-fr/puny-fr-1.5 tristam-fr.inf
	python3 abbreviations.py -f
abbrfr5:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esirf -Cu -v5 +,PATHTOMYIFFOLDER/retro/tristam-fr/puny-fr-1.5 tristam-fr.inf
	python3 abbreviations.py -f
abbrfr5puny:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esir -Cu -v5 +,PATHTOMYIFFOLDER/retro/tristam-fr/puny-fr-1.5 tristam-fr.inf
	python3 abbreviations.py -f


memorymapen:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esiz -v3 +,PATHTOMYIFFOLDER/retro/puny/PunyInform-v3/lib tristam-en.inf
memorymapfr:
	PATHTOMYIFFOLDER/outils/inform-636-beta/inform -d2esiz -v3 +,PATHTOMYIFFOLDER/retro/puny/myPunyInform/lib tristam-fr.inf
