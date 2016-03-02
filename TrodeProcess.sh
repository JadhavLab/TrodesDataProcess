#!/bin/bash
############
# Name: 	TrodeProcess
# Purpose: 	The purpose of this script is to crawl through a folder structure and 
#		process all the information found therein using an input binary file
############

# INPUTS
#
# $1 -- The folder to apply our search with
# $2 -- The binary to apple across the found rec files

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

for f in $(ls $1); do

	if [[ $STOPALLPROCESS == "1" ]]
	then
		continue;
	fi

	# If it's a directory, recurse into the thingamajig
	if [ -d $f ]; then
                echo "$2: Recursing into $(pwd)/$f"
		let levelsdeep=$levelsdeep+1
                $SCRIPT $(pwd)/$f $2 $levelsdeep
                let levelsdeep=$levelsdeep-1
	fi

	if [[ $f =~ .*\.rec$ ]] ; then

		if [[ $SKIPPROCESSED = "1" ]] ;
		then
			if [[ -d $(echo $f | sed 's/.rec//')${procExt} ]] ;
			then
				echo Recfile $f already processed ... moving on ... 
				continue;
			fi
		fi

                echo "$2: Processing RecFile: $f"
		echo About to run $TRODESPIKE
                $TRODESPIKE -rec $f

	fi;

done;

# Return to the orignal directory
cd $ORIGINAL_PATH
