#!/bin/bash
############
# Name: 	SingleProcess
# Author: 	Ryan Young
# Purpose: 	The purpose of this script is to crawl through a folder structure and 
#		process all the rec files found therein for a single Trodes export 
# 		function specified by the user. Each processing instance opens as a background
# 		shell process so processing can be run on multiple cores. 
############

# INPUTS
#
# $1 -- The folder to apply our search with
# $2 -- The binary to apple across the found rec files
# $3 -- File filter, only process rec files matching this input

############# SET IMPORTANT FLAGS AND VARIABLES #############

# Compute how deep we are into the script; if it's the first level, initialize
if [ "$#" -le  "2" ]
   then
     levelsdeep=0
     echo $2: The script being run is $SCRIPT
else
     levelsdeep=$3
fi

# Get the path to this script, for purpose of recursion
SCRIPT=`realpath $0`
scriptpath=$(echo $SCRIPT | sed 's/\/[a-zA-Z0-9]*.sh$/\//')

# Obtain path to Trodes
TrodesPath=$(cat ${scriptpath}/TrodesPath.txt);

# Path to Trode Spikes processor
TRODESPIKE=${TrodesPath}/$2

# Switch to determine the name of processed folders, for detecting when
# we already processed data, and don't need to again.
case $2 in
	exportLFP )
		procExt=.LFP;;
	exportdio )
		procExt=.DIO;;
	exportspikes )
		procExt=.spikes;;
	exporttime )
		proceExt=.time;;
esac

# Save original path and jump into the folder we're about to process
ORIGINAL_PATH=$(pwd);
cd $1

# Check if stop process flag has been thrown!
if [[ $STOPALLPROCESS == "1" ]]
then
	break;
fi

############# CHECK CURRENT LOCATION FOR REC FILES TO PROCESS #############
if [[ $(ls $1 ) =~ .*\.rec ]]; then
	# This is directory that has recfiles!
	echo
	echo
        echo Found folder $1 with rec files and processing...
	
	# Now to concatonate the arguments to feed into the export function
	recfilestring=""
	commonstring=$(ls -1 *$3*.rec | head -n 1)
	# Create rec file argument string to pass to the export function, containing all rec files to process in order
	echo result of recfile list: $(ls -tr *$3*.rec)
	for r in $(ls -tr *$3*.rec) # crawls over all rec files, oldest to newest
	do
		# Append to the rec file argument list
		recfilestring="${recfilestring}-rec $(pwd)/$r "
		# Here, calculating the common string pattern for all processed files, for naming output later
		commonstring=$(printf "%s\n%s\n" "$r" "$commonstring" | sed -e 'N;s/^\(.*\).*\n\1.*$/\1/')
	done

	# If common string ends with a _ .. remove it!
	if [[ $(echo $commonstring | tail -c 1) == "_" ]]
	then
		commonstring=$(echo $commonstring | sed -r 's/[_]{1}$/''/g')
	fi

	#echo "DEBUG: $2: Processing RecFile argument list: $recfilestring"
	logdirectory=${scriptpath}Logs$(pwd | grep -o '\/[a-zA-Z0-9_\-]*\/[a-zA-Z0-9_\-]*$' | sed 's/\//./2')
	echo ========
	echo "About to run --> "$TRODESPIKE $recfilestring -output $commonstring"" 
	echo
	echo Outputting to $logdirectory
	echo ========
	mkdir $logdirectory 2> /dev/null
	echo "" > $logdirectory/$2.log
	$TRODESPIKE $recfilestring -output $commonstring 2>> $logdirectory/$2.log 1>> $logdirectory/$2.log &
	echo
fi

############# RECURSE INTO ANY FOLDERS, AND CALL THIS PROGRAM AGAIN ON THEM #############
# Now that we processed any recfiles potentially in this folder, attempt to descend into nested folders
# and look for more
for f in $(ls $1); do

	if [[ $STOPALLPROCESS == "1" ]]
	then
		# If stopprocess flag is thrown, we should exit
		break;
	fi

	# If it's a directory, recurse into it
	if [[ -d $f ]] ; then
		
		echo "$2: Recursing into $(pwd)/$f"
		let levelsdeep=$levelsdeep+1
                $SCRIPT $(pwd)/$f $2 $levelsdeep 1>&1 | sed 's/^/    /'
                let levelsdeep=$levelsdeep-1
		echo 
	fi

#	# This section for right now is not terribly useful ... will have to rework it for BashTrodes2.0
#	if [[ $(ls $f) =~ .*\.rec$ ]] ; then
#
#		if [[ $SKIPPROCESSED = "1" ]] ;
#		then
#			if [[ -d $(echo $f | sed 's/.rec//')${procExt} ]] ;
#			then
#				echo Recfile $f already processed ... moving on ... 
#				continue;
#			fi
#		fi
#
#	fi;

done;

# Return to the orignal directory
cd $ORIGINAL_PATH

# Potentially let a parent AllProcess program instance know we're done processing
# If it's running stand-alone, this doesn't matter
if [[ $levelsdeep = "0" ]]
then
	echo finished process tree ...
	#PROCESSESFINISHED=$(cat ${scriptpath}Logs/.processesfinished.log)
	#let PROCESSESFINISHED=$PROCESSESFINISHED+1;
	#echo $PROCESSESFINISHED > ${scriptpath}Logs/.processesfinished.log
fi

