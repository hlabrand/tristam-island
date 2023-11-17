# coding: utf-8

# transforme_latin1_z3.py
#   by Hugo Labrande
#
# A tool to process Inform 6 code to compile successfully and in a variety of settings a game with accented characters
#
# Public domain



string_higherZSCII = "äöüÄÖÜß»«ëïÿËÏáéíóúýÁÉÍÓÚÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛåÅøØãñõÃÑÕæÆçÇþðÞÐ£œŒ¡¿"

# Translation for I6's compiler, if needed
#translation_higherZSCII = [ "@:a", "@:o", "@:u", "@:A", "@:O", "@:U", "@ss", "@>>", "@<<", "@:e", "@:i", "@:y", "@:E", "@:I", "@'a", "@'e", "@'i", "@'o", "@'u", "@'y", "@'A", "@'E", "@'I", "@'O", "@'U", "@'Y", "@`a", "@`e", "@`i", "@`o", "@`u", "@`A", "@`E", "@`I", "@`O", "@`U", "@^a", "@^e", "@^i", "@^o", "@^u", "@^A", "@^E", "@^I", "@^O", "@^U", "@oa", "@oA", "@/o", "@/O", "@~a", "@~n", "@~o", "@~A", "@~N", "@~O", "@ae", "@AE", "@cc", "@cC", "@th", "@et", "@Th", "@Et", "@LL", "@oe", "@OE", "@!!", "@??" ]

# Translation into ASCII characters, should work on any platform
translation_noaccents = [ "a", "o", "u", "A", "O", "U", "ss", "~", "~", "e", "i", "y", "E", "I", "a", "e", "i", "o", "u", "y", "A", "E", "I", "O", "U", "Y", "a", "e", "i", "o", "u", "A", "E", "I", "O", "U", "a", "e", "i", "o", "u", "A", "E", "I", "O", "U", "a", "A", "o", "O", "a", "n", "o", "A", "N", "O", "ae", "AE", "c", "C", "th", "d", "Th", "D", " pounds", "oe", "OE", "", "" ]

# Substitutions for a different charset
#   Some machines (Amstrad CPC, Oric, MSX, Atari 8-bit, etc) allow you to redraw the character set / use your own font
#   You can thus write "je suis fran\ais" in your code, then tell the computer that the "\" character is drawn like "ç"
#   This is useful if your computer cannot display more than 96 characters (Oric) or if you have a terp (like Infocom's) that cannot display characters in the higher ZSCII table (a modern addition to the z3 standard) and cannot be hacked

# charset substitutions for French :
#   Old printers (and Sedoric, command AZERTY) use
#        @ <=> à
#        \ <=> ç
#        { <=> é
#        | <=> ù
#        } <=> è
#        ~ <=> ë
#   We add:
#        ` <=> î
#        ^ <=> ô
#        _ <=> â
#        < <=> ê
#        # <=> û
#   We're still missing "ï", but it's not used very often, and we're running out of characters to replace
#   We CANNOT replace >, it's used for the prompt

translation_charsetchanges_fr = [ "a", "o", "u", "A", "O", "U", "ss", "~", "~", "@@126", "i", "y", "E", "I", "a", "{", "i", "o", "u", "y", "A", "E", "I", "O", "U", "Y", "@@64", "}", "i", "o", "|", "A", "E", "I", "O", "U", "_", "<", "`", "@@94", "#", "A", "E", "I", "O", "U", "a", "A", "o", "O", "a", "n", "o", "A", "N", "O", "ae", "AE", "@@92", "C", "th", "d", "Th", "D", " pounds", "oe", "OE", "", "" ]

# Customize this so it works on your own language! And do a pull request!


# read the filenames
source = "tristam-fr.inf"
#target1 = "tristamfr-compil.inf"
target2 = "tristam-fr-noaccents.inf"
target3 = "tristam-fr-charsetchanges.inf"

#print(len(string_higherZSCII))
#print(len(translation_noaccents))
#print(len(translation_charsetchanges_fr))

f = open(source, "r", encoding="UTF-8")
#g1 = open(target1, "w")
g2 = open(target2, "w")
g3 = open(target3, "w")
c = f.read(1)
while(c):
	pos = string_higherZSCII.find(c)
	if (pos >= 0):
#		print(c)
#		g1.write(translation_higherZSCII[pos])
		g2.write(translation_noaccents[pos])
		g3.write(translation_charsetchanges_fr[pos])
	else:
#		g1.write(c)
		g2.write(c)
		g3.write(c)
	c = f.read(1)
f.close()
#g1.close()
g2.close()
g3.close()
