#!/bin/bash

### RSEARCH V1.1 : ROFI FILES SEARCH TOOL
### Sorts files by access time. Displays modification time for each file.
### This script combines find command, sort command and rofi "dmenu" text searching abilities
### It can be used for "recent files" finding and for file searching by path name.
### A dmenu version (instead of rofi -dmenu) is available in commented lines.
### Written by Girafenaine for use on fluxbox and especially MX-Fluxbox 10/04/21
### Released under GNU General Public License V3

### to initialize options and vars-i 0 -d -p "~/Documents
#########################################################################
#to create database files with restricted permissions (rw-------)
umask 177
#default intial path to search in
inpath=$HOME
#default command to open files without any "xdg" rules
editor=geany
#default suffix for database file ("h" added for database including hidden files)
dbpathhid=""
dbpathhid2="h"
#default nb of files to display (modified with -l option)
lines=22
#default width for rofi window (modified with -w option)
width=65
#default way to display files (find command option), with no "initial path" (/home/username/ is not displayed)
print="%P"
print2="%p"
#default excluded patterns in find search, to exclude hidden files and thunderbird profile folders
exclu='! -ipath \/home\/*\/\.* ! -ipath \/home\/*\.default\/* '
exclu2='! -ipath *cache\/* ! -ipath *\/cache* ! -ipath \/home\/*\/\.cache* '
#default file type that are searched for. Find options. f for "real" files, d for directories
type="f"
type2="f,d"
#default indicator for displaying file type or not
dtype=""
dtype2="%y  "
#default mode indicator (1=normal: sorted home files, 2=sorted home files including hidden files, 3=whole filesystem, without any sorting)
mode=1
#default update indicator
update=0
#default interval between two database updates in minutes. "O" means : update at each call.
interval=180

### to catch options
#########################################################################
while [ $# -gt 0 ] ; do

if [[ $1 = "-h" || $1 = "--help" ]] ; then
echo '#########################################################
RSEARCH - ROFI RECENT FILES SEARCH TOOL 
#########################################################

rsearch generates a "database" file listing your files from the initial path of your choice. Your home is the default initial path. It sorts them by access times, and displays modification times (the access time is used for sorting but not displayed), and lets you search through your files thanks to rofi -dmenu.

Thanks to rofi abilities, it is well suited for those wanting a snappy tool that you call with a chosen key and then you directly hit first letters of the wanted file to make it to appear, then return to open it with the appropriate program.

You can use it with "-i 0" option to generate the database each time the script is called. If the database takes too much time to be generated when you call the script, you can separate database generation (at startup, and/or when you call the script but only if the database is too old, and/or every x min/h with a cron task) and database searching. Thus your searching is snappier and easier. Default behaviour is to update if database is older than 3 hours.

rsearch generates a database file for each initial path. Thus you can use it to search in different folders or media, each with its own database file making rofi interface to jump quickly on your screen.

With default settings only your home files are listed, and the hidden files are... hidden. You can include hidden files with -hf option (except for cache folders), or even search though you whole file system with -a (--all) option. In this last mode the script uses "locate" command instead of find, to be quick enough, and files are not sorted by access time.

If you prefer you could use this one-line command that does quite the same as this script, without some options and without the ability to use a database file :
choice=$(find ~ -type f ! -ipath "/home/*/.*" ! -ipath "/home/*/*.default/*" -printf "%A@ %Tx %P\n" | sort -rn | cut -c23- | rofi -dmenu -i -width 70 -l 22 -p rsearch: | cut -c12-) && if [[ $choice != "" ]] ; then thunar ~/"$choice" ; fi

#################################
YOU MAY USE FOLLOWING OPTIONS :

	-u (or --update) : the script only updates the files database and quit. Useful to separate database generation and searching if database generation is long and makes the script not snappy enough.
	-d (or --directories) : directories are searched for as well as files. "f" and "d" are displayed in the files list.
	-hf (or --hidden-files) : home files including hidden files. Only cache folders are hidden. Files are sorted by access time.
	-a (or -all) : global search : initial path is / and hidden files are included. So you can access all files on you system file. This mode uses "locate" command, which comes with its own database management. Files are not sorted by access time.
	-i (or --interval) interval-in-seconds : max time interval between two database update (default : 3 hours). I you use -i 0, then the database will be generated each time you call the script. Furthermore with -i 0 option, the script removes the database files so you do not keep any list of your home files. It could be useful if you have privacy concerns. You can set any other time interval you want.
	-p (or --path) initial-path : default initial path to search from (default is your home). With this option, files are displayed with their short path, without initial path, which is easier to read.
	-mp (or --multiple-paths) " "path1" "path2"..." : several initial paths to search from. With this option, files are displayed with their full path, including initial path. May work with only one path of course. Paths should be quoted together.
	-l (or --lines) number-of-displayed-files : modify number of displayed files in rofi -dmenu (default is 22). One file by line.
	-w (or --width) rofi-window-width : modify rofi window width. It is a rofi option, under 100 it is a percentage of your screen, above 100 it is a number of pixels. Default is 65 (which is 65% of your screen width)
	-h (or --help) : displays this help text

#################################
TO USE THIS SCRIPT :

	0. Install rofi (sudo apt install rofi) if not already installed. You can customize its appearance with rofi-theme-selector.

	1. Copy this script in a file in your chosen place (eg ~/.local/bin/) with the name rsearch, and give it execution permission.
		
	2. Add a shortcut to call the script easily. In fluxbox for example, add in your keys file such a line :
		none F2 :Exec ~/.local/bin/rsearch -i 60 -l 20 (update if older than 1 hour, display 20 lines)
		and you could add for full search including hidden files :
		Shift F2 :Exec ~/.local/bin/rsearch -hf - i 240 -d -l 20 (include hidden files, update if older than 4 hour, display 20 lines and include directories)

In addition you may :

	3.a Add the script with --update option to your startup file, for your files database to be updated at the session beginning. Just add the line : ~/.local/scripts/rsearch --update -your-desired-options
	
	3.b Adapt the interval between two updates. Default behaviour is following : when the script is called it checks how old is the database file. If older than 3 hours it updates the database, else it use the existing one. You can modify this interval with -i option. If you use -i 0, the script updates the database each time it is called, and no database file is kept.
 
	3.b Use cron (needs cron service to be on) to execute it every eg 1 hour : "crontab -e", then add a line such as "*/60 * * * * ~/.local/scripts/rsearch -d -l 18 --update"
' | less
	exit

	elif [[ $1 = "-u" || $1 = "--update" ]] ; then update=1 ; shift
	elif [[ $1 = "-i" || $1 = "--interval" ]] ; then interval=$2 ; shift 2
	elif [[ $1 = "-d" || $1 = "--directories" ]] ; then type=$type2 ; dtype=$dtype2 ; shift
	elif [[ $1 = "-hf" || $1 = "--hidden-files" ]] ; then mode=2 ; exclu=$exclu2 ; dbpathhid=$dbpathhid2 ; shift
	elif [[ $1 = "-a" || $1 = "--all" ]] ; then mode=3 ; shift
	elif [[ $1 = "-p" || $1 = "--path" ]] ; then inpath=$2 ; shift 2
	elif [[ $1 = "-mp" || $1 = "--multiple-paths" ]] ; then inpath=$2 ; print=$print2 ; shift 2
	elif [[ $1 = "-w" || $1 = "--width" ]] ; then width=$2 ; shift 2
	elif [[ $1 = "-l" || $1 = "--lines" ]] ; then lines=$2 ; shift 2
#	elif [[ $1 = "-e" || $1 = "--editor" ]] ; then editor=$2 ; shift 2
	else echo "unkown option \"$1\" ignored" ; shift
fi

done

### management of database files
#########################################################################
inode=$( ls -id $inpath | cut -d" " -f1 )
dbpath="$HOME/.local/share/rsdb_$inode$dbpathhid"

### if interval=0 then it means that you want to regenerate database each time you call the script. So you don't need to keep the database. Furthermore this could be a good thing for privacy and security. So we remove database files, as for temporary files, as soon as exit signal is caught.
if [[ $interval == 0 ]] ; then
	trap "rm -f "$HOME/.local/share/rsdb_$inode" "$HOME/.local/share/rsdb_${inode}h" " EXIT
fi

### function to open files
#########################################################################
function openfile () {
	umask 022
	mimetype=$( xdg-mime query filetype "$1" )
	mimeapp=$( xdg-mime query default "$mimetype" )
	if [[ $mimeapp != "" ]] ; then
	echo "echo "opening $1 through xdg-open with ${mimeapp%\.desktop}" "
	xdg-open "$1" 2>/dev/null &
	else
	echo "echo "opening $fullname with $editor \(no associated app for this mimetype\)" "
	$editor "$1" 2>/dev/null &
	fi
}

#other function for the same goal, using your file manager instead of xdg-open
#function openfile () {
#		umask 022
#		filemgrdesktop=$( xdg-mime query default inode/directory )
#		filemgr=${filemgrdesktop%\.desktop}
#		echo "echo "opening $1 through $filemgr" "
#		$filemgr "$1" &
#}

### mode 3 : whole filesystem with locate command, without any sorting
#########################################################################
if [[ $mode == 3 ]] ; then
	choice=$(locate / | rofi -dmenu -i -width $width -l $lines -p rsearch -keep-right -no-custom )
	#dmenu version
	#choice=$( locate -e / | dmenu -f -b -i -l $lines -p dsearch )
	
	if [[ $choice != "" ]] ; then $(openfile "$choice") ; fi
	exit 0
fi

### modes 1 and 2 : update check, and update if needed (if given interval is over)
#########################################################################
if [[ $update == 0 ]] && [[ -e $dbpath ]] && [[ $(date -r $dbpath +%s) -gt $(($(date +%s)-$interval*60)) ]] ; then
	echo "database $dbpath updated at $(date -r $dbpath +%c), no required update, search with rofi is going to begin"

else
	find $inpath $exclu -type $type -printf "%A@ %Tx  ${dtype}${print}\n" | sort -nr | cut -d" " -f2- > $dbpath
	
	if [[ $update == 1 ]] ; then echo "database $dbpath updated, end of script" ; exit 0 ; fi
	
	echo "database $dbpath updated, search with rofi is going to begin"
fi

### mode 1 and 2 : rofi for searching through database
#########################################################################
choice=$( rofi -dmenu -input $dbpath -i -width $width -l $lines -p "rsearch" -keep-right -no-custom )
#dmenu version
#choice=$( cat $dbpath | dmenu -f -b -i -l $lines -p dsearch )

#remove useless part of the chosen line and call "openfile" function
file=${choice#*\ \ }
fullname=$inpath/${file#[fd]\ \ }
if [[ $choice != "" ]] ; then sudo -u $USER $(openfile "$fullname") ; fi

#if you just used "hidden files" database, use this database to update "home" database to be ready for future calls by sorting out hidden files (containing " \." in their path, and *.default/ files)
#if [[ $mode == 2 ]] && [[ $interval -gt 0 ]] ; then
#	grep -Eiv "[[:space:]\/][\.].*|.*\.default\/.*"  $dbpath > "$HOME/.local/share/rsearch_$inode" &
#fi
	
exit 0
