# pdf-booklet-imposer.sh
Bash script for create A5 and A6 pdf booklet (with GUI)

pdf-booklet-imposer -- Gui-Script to achieve some imposition on PDF documents : 
generate A5 and A6 pdf booklet from A4 page by page document, and 
separate A5/A6 cover and text-only (without cover) pdf.


## Dependances :
This script use [zenity](https://gitlab.gnome.org/GNOME/zenity), 
[bookletimposer](https://github.com/con-f-use/bookletimposer)(Kjö Hansi Glaz) and [pdftk](https://github.com/mikehaertl/php-pdftk). 
You have to install them for use this script. 

## Usage :
<path/to/the/script/pdf-booklet-imposer.sh> <path/to/the/file.pdf>

You can also configure a thunar custom action (on Xfce, or nautilus 
script on gnome) for quick acces by right clic on the pdf. 
	Go to thunar menu "Edit > configure custom action > add new > 
	name : pdf-booklet-imposer" / 
	command : <path/to/script/pdf-booklet-imposer.sh> %f
	> Appearence Condition > File pattern : *.pdf *.PDF /
	Appears if selection contains : other files

Or add this lines (without "#") in ~/.config/Thunar/uca.xml

	<action>
		<icon>bookletimposer</icon>
		<name>pdf-booklet-imposer</name>
		<unique-id>1600521438161521-1</unique-id>
		<command>/path/to/script/pdf-booklet-imposer.sh %f</command>
		<description></description>
		<patterns>*.pdf *.PDF</patterns>
		<other-files/>
	</action>
  
