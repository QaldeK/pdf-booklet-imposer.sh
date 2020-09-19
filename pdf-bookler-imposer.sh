#!/bin/bash

########################################################################
# 
# pdf-booklet-imposer -- Gui-Script to achieve some imposition on PDF documents : 
# generate A5 and A6 pdf booklet from A4 page by page document, and 
# separate A5/A6 cover and text-only (without cover) pdf.


# Dependances :
# This script use zenity, bookletimposer (Kjö Hansi Glaz) and pdftk. 
# You have to # install them for use this script. 

# Usage :
# <path/to/the/script/pdf-booklet-imposer.sh> <path/to/the/file.pdf>

# You can also configure a thunar custom action (on Xfce, or nautilus 
# script on gnome) for quick acces by right clic on the pdf. 
# 	Go to thunar menu "Edit > configure custom action > add new > 
# 	name : pdf-booklet-imposer" / 
# 	command : <path/to/script/pdf-booklet-imposer.sh> %f
# 	> Appearence Condition > File pattern : *.pdf *.PDF /
# 	Appears if selection contains : other files

# Or add this lines (without "#") in ~/.config/Thunar/uca.xml

# 	<action>
# 		<icon>bookletimposer</icon>
# 		<name>pdf-booklet-imposer</name>
# 		<unique-id>1600521438161521-1</unique-id>
# 		<command>/path/to/script/pdf-booklet-imposer.sh %f</command>
# 		<description></description>
# 		<patterns>*.pdf;*.PDF</patterns>
# 		<other-files/>
# 	</action>

######################################################################## 
# Copyright (C) QaldeK (aldek@vivaldi.net)
# 
# This program is  free software; you can redistribute  it and/or modify
# it under the  terms of the GNU General Public  License as published by
# the Free Software Foundation; either  version 3 of the License, or (at
# your option) any later version.
# 
# This program  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

#Zenity Gui (Interface graphique)
GUI=$(zenity --list --checklist \
	--height 600 \
	--width 800 \
	--title="Impose booklet" \
	--text="Select what you want to do.
For Cover and text-only (for A5 and A6), you have to work with an appropriate
input pdf format, or create also the desired booklet format. " \
	--column=Cochez \
	--column=Actions \
	--column=Description \
	\
	FALSE "Compress pdf" "..." \
	FALSE "DO ALL" "Generate A5 & A6 & cover-only & text-only from A4 pdf" \
	FALSE "A4>A5 ALL" "Generate 3 pdf (from A4): A5, A5 cover and A5 text-only" \
	FALSE "A4>A6 ALL" "Generate 3 pdf (from A4): A6, A6 cover and A6 text-only" \
	FALSE "A5>A6 ALL" "Generate 3 pdf (from A4): A6, A6 cover and A6 text-only" \
	FALSE "A4>A5" "Create A5 booklet" \
	FALSE "A4>A6" "Create A6 booklet from A4 document (A6 x2)" \
	FALSE "A5>A6" "Create A6 booklet from A5 booklet (A6 x2)" \
	FALSE "A5 Cover" "Create Cover-only A5 booklet" \
	FALSE "A6 Cover" "Create Cover-only A6 booklet" \
	FALSE "A5 text" "Create text-only (remove Cover) A5  booklet" \
	FALSE "A6 text" "Create text-only (remove Cover) A6  booklet" \
	

)


file="$1"
basename=${file%.pdf}


A5="$basename""_A5.pdf"
A6="$basename""_A6.pdf"


#Compress pdf
if [[ $GUI == *"Compress pdf"* ]]
then
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=output.pdf "$1"
	mv output.pdf "$file"
fi 

#BOOKLET ALL

if [[ $GUI == *"DO ALL"* ]]
then
	# generate $A5 _________
	bookletimposer "$1" -a -b -f A4 -k -o "$A5"
	# generate $A6 _________
	bookletimposer "$A5" -a -f A4 -n -p 1x2 -k -c -o "$A6"

	# generate $A5 Cover _________
	pdftk A="$A5" cat A1 A2 output "${A5%.pdf}""_COUV.pdf"
	# generate $A6 Cover _________
	pdftk A="$A6" cat A1 A2 output "${A6%.pdf}""_COUV.pdf"

	# generate $A5 text-only _________
	pdftk A="$A5" cat A3-end output "${A5%.pdf}""_TXT.pdf"
	# generate $A6 text-only _________
	pdftk A="$A6" cat A3-end output "${A6%.pdf}""_TXT.pdf"
fi

if [[ $GUI == *"A4>A5 ALL"* ]]
then
	# generate $A5 _________
	bookletimposer "$1" -a -b -f A4 -k -o "$A5"
	# generate $A5 Cover _________
	pdftk A="$A5" cat A1 A2 output "${A5%.pdf}""_COUV.pdf"
	# generate $A5 text-only _________
	pdftk A="$A5" cat A3-end output "${A5%.pdf}""_TXT.pdf"
fi

if [[ $GUI == *"A4>A6 ALL"* ]]
then
	# generate $A5 _________
	bookletimposer "$1" -a -b -f A4 -k -o "$A5"
	# generate $A6 _________
	bookletimposer "$A5" -a -f A4 -n -p 1x2 -k -c -o "$A6"
	rm "$A5"
	# generate $A6 Cover _________
	pdftk A="$A6" cat A1 A2 output "${A6%.pdf}""_COUV.pdf"
	# generate $A6 text-only _________
	pdftk A="$A6" cat A3-end output "${A6%.pdf}""_TXT.pdf"
fi

if [[ $GUI == *"A5>A6 ALL"* ]]
then
	# generate $A6 _________
	bookletimposer "$1" -a -f A4 -n -p 1x2 -k -c -o "$A6"
	# generate $A6 Cover _________
	pdftk A="$A6" cat A1 A2 output "${A6%.pdf}""_COUV.pdf"
	# generate $A6 text-only _________
	pdftk A="$A6" cat A3-end output "${A6%.pdf}""_TXT.pdf"
fi


#BOOKLET

if [[ $GUI == *"A4>A5"* ]]
then
	# generate $A5 _________
	bookletimposer "$1" -a -b -f A4 -k -o "$A5"
fi

if [[ $GUI == *"A4>A6"* ]]
then
	# generate $A5 _________
	bookletimposer "$1" -a -b -f A4 -k -o "$A5"
	# generate $A6 _________
	bookletimposer "$A5" -a -f A4 -n -p 1x2 -k -c -o "$A6"
	rm "$A5"
fi

if [[ $GUI == *"A5>A6"* ]]
then
	# generate $A6 _________
	if [[ $GUI == *"A4>A5"* ]]
	then
		bookletimposer "$A5" -a -f A4 -n -p 1x2 -k -c -o "$A6"
	else
		bookletimposer "$1" -a -f A4 -n -p 1x2 -k -c -o "$A6"
	fi
fi

# Cover
if [[ $GUI == *"A5 Cover"* ]]
then
	# generate $A5 Cover _________
	if  [[ $GUI == *"A4>A5"* ]]
	then
		pdftk A="$A5" cat A1 A2 output "${A5%.pdf}""_COUV.pdf"
	else
		pdftk A="$1" cat A1 A2 output "${1%.pdf}""_COUV.pdf"
	fi

fi

if [[ $GUI == *"A6 Cover"* ]]
then
	# generate $A6 Cover _________
	if [[ $GUI == *"A5>A6"* ]] || [[ $GUI == *"A4>A6"* ]]
	then
		pdftk A="$A6" cat A1 A2 output "${A6%.pdf}""_COUV.pdf"
	else
		pdftk A="$1" cat A1 A2 output "${1%.pdf}""_COUV.pdf"
	fi

fi

#TEXT ONLY (remove Cover)
if [[ $GUI == *"A5 text"* ]]
then
	# generate $A5 text-only _________
	if [[ $GUI == *"A4>A5"* ]]
	then
		pdftk A="$A5" cat A3-end output "${A5%.pdf}""_TXT.pdf"
	else
		pdftk A="$1" cat A3-end output "${1%.pdf}""_TXT.pdf"
	fi
fi

if [[ $GUI == *"A6 text"* ]]
then
	# generate $A6 text-only _________
	if [[ $GUI == *"A5>A6"* ]] || [[ $GUI == *"A4>A6"* ]]
	then
		pdftk A="$A6" cat A3-end output "${A6%.pdf}""_TXT.pdf"
	else
		pdftk A="$1" cat A3-end output "${1%.pdf}""_TXT.pdf"
	fi

fi





