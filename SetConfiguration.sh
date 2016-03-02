#!/bin/bash
############
# Name: 	TrodeProcess
# Purpose: 	The purpose of this script is to crawl through a folder structure and 
#		copy a configuration to all rec files found in the folder structure. This can
# 		be used to mass fix rec files with corrupted configuration headers or for changing
#		properties of configuration ad hoc.
############s

# INPUTS
#
# $1 -- The folder to apply our search with
# $2 -- The configuration file to apply

# Initialize if no third input
if [ "$#" -le  "2" ]
   then
     levelsdeep=0
     echo The script being run is $SCRIPT
else
     levelsdeep=$3
fi

# Establish color of message based on nesting
let color=$levelsdeep+91
colortag="\e[${color}m"

# Get the path to this script, for purpose of recursion
SCRIPT=`realpath $0`

echo =========================
echo Folder Level $levelsdeep
echo =========================

# Save original path and jump into the folder we're about to process
ORIGINAL_PATH=$(pwd);
cd $1

for f in $(ls $1); do

	# If it's a directory, recurse into the thingamajig
	if [ -d $f ]; then
                let levelsdeep=$levelsdeep+1
                let color=$levelsdeep+91
                colortag="\e[${color}m"
                printf "$colortag Recursing into $(pwd)/$f"
                $SCRIPT $(pwd)/$f $2 $levelsdeep
                let levelsdeep=$levelsdeep-1
	fi

	if [[ $f =~ .*\.rec$ ]] ; then
                printf "Creating trodesconf for recFile: $f \n"
                plainfile=$(echo $f | sed 's/.rec//g')
		cp $2 $(pwd)/${plainfile}.trodesConf
	fi;

done;

# Return to the orignal directory
cd $ORIGINAL_PATH

printf $colortag _______________________________________________________
