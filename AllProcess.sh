#!/bin/bash

# Name:		AllProcess.sh
# Author:	Ryan Young
# Description: 	Script that processes applies all export functions to a folder hierarchy. Works by calling a nested tree of SingleProcess.sh background processes, and tracks them while they run. When the processes stop, it applies MatclustAndFilter.m as a final processing step -- this m-file can be run as a standalone script, but for conveinence, this script automatically applies it at the end of processing.
# Inputs: 	$1 - Path to parent folder
# 		$2 - (Optional) Filter string .. rec files that do not match the filter string will not be processed.

# Add SKIPPROCESSED=1 to skip processed rec files

############# SET FLAGS AND IMPORTANT VARIABLES #############

RED='\033[0;31m' # Red
NC='\033[0m' # No Color

dependency_path=$(which realpath)
detect_fundamental_program=${#dependency_path}
if [ "$detect_fundamental_program" -gt "0" ]
then

SCRIPT=`realpath $0`
scriptpath=$(echo $SCRIPT | sed 's/\/[a-zA-Z0-9]*.sh$/\//')
echo Script execution path detected: $scriptpath
sleep 0.5

# Path to export programs
TrodesPath=$(cat ${scriptpath}/TrodesPath.txt);
if [[ ! -d $TrodesPath ]]
then
	clear
	echo ==================================
	echo WARNING: Check your TrodesPath.txt
	echo ...cannot find folder indicated ...
	echo ... TrodesPath = $TrodesPath ...
	echo ==================================
	sleep 10
	exit 1
fi

export STOPALLPROCESS=0 # Flag that tracks whether user has requested to halt processing

clear
echo
echo
echo This program will now create background processes to run exportdio, exportLFP, exportspikes, exporttimes, and exportphy 
echo in parallel on all recfiles in folder structure $1 with file filter $2 ...
echo
read -p "Press enter to continue..."

processID=$2_$($1 | grep -o '[a-zA-Z0-9_\-]*$')
debugtext=${scriptpath}Logs/${processID}.allprocess.log
rm $debugtext
echo “” > $debugtext

############# CALL EXPORT PROCESSING CHILD PROGRAMS #############
clear
echo initiating DIO  ... ; sleep 0.5
${scriptpath}/SingleProcess.sh $1 exportdio $2 >> ${debugtext} 2>/dev/null &
clear
echo initiating LFP ... ; sleep 0.5
${scriptpath}/SingleProcess.sh $1 exportLFP $2 >> ${debugtext} 2>/dev/null &
clear
echo initiating spikes ... ; sleep 0.5
${scriptpath}/SingleProcess.sh $1 exportspikes $2 >> ${debugtext} 2>/dev/null &
clear
echo initiating times ... ; sleep 0.5
${scriptpath}/SingleProcess.sh $1 exporttime $2 >> ${debugtext} 2>/dev/null &
echo initiating analog ... ; sleep 0.5
${scriptpath}/SingleProcess.sh $1 exportanalog $2 >> ${debugtext} 2>/dev/null &
#${scriptpath}/SingleProcess.sh $1 exportphy

clear
echo ...
sleep 3;

############# WAIT FOR PROCESSES TO FINISH OR USER TO TERMINATE #############
X=""
PROCESSESRUNNING=$(ps --noheaders -O comm,pid -C exportLFP -C exportspikes -C exporttime -C exportdio | cut -d ' ' -f1,2,3 | tr '\n' ' ')
echo $PROCESSESRUNNING && sleep 1
while [[ ! $X = "q" ]] && [[ -n $PROCESSESRUNNING ]]
do
	clear
	echo ==========
	echo Current Background Master Processes:
	printf $RED 
	echo $PROCESSESRUNNING
	printf $NC
	echo "(i.e. export functions that are running in the background on your folder structure)"
	echo ==========
	echo
	echo
	echo "Type q to quit installation, or you can use a terminal by setting ''STOPALLPROCESS=1'' and ''export STOPALLPROCESS''."
	read -t 5 -a X
	PROCESSESRUNNING=$(ps --noheaders -O comm,pid -C exportLFP -C exportspikes -C exporttime -C exportdio | cut -d ' ' -f1,2,3 | tr '\n' ' ')
done

############# TERMINATION (IF REQUESTED WHEN LOOP ABOVE EXITS) #############
if [[ $X = "q" ]]
then
	echo Setting environmental variable to stop processing ...
	sleep 1
	# Signal future processes to stop
	STOPALLPROCESS=1
	export STOPALLPROCESS

	# Destroy currently running processes
	echo Destroying currently running Trode export programs ...
	sleep 1
	kill  $(ps --noheaders -O pid -C exportLFP -C exportspikes -C exporttime -C exportdio | cut -d ' ' -f1,2,3 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	echo All export processes halted! Done.
fi

############# CALL MATLAB TO CREATE MATCLUST ANF FILTER FILES #############

# Run matlab scripts to convert .dat spike files into matclust files and automagically
# create the matclust files for all .X folders
if [[ -z $PROCESSESRUNNING ]]
then
	echo Initiating final matlab processing ...
	
	echo
	echo ----------------------------------------------------------
	currpath=$(pwd)
	cd $1
	MATLAB_COMMAND="path(genpath('${scriptpath}'),path);cd('$1');pwd;MatclustAndFilter;if(exit_status==0);exit;end;"
	echo About to run $MATLAB_COMMAND in matlab
	matlab -nodisplay -nosplash -logfile ${scriptpath}Logs/${processID}.matlab.log -r $MATLAB_COMMAND
	cd $currpath
fi

else # If cannot find realpath, we ask user to install it and exit

echo "You need to install realpath with either macports or apt-get before using this program."
exit 1

fi
