#!/bin/bash

# Add SKIPPROCESSED=1 to skip processed rec files

############# SET FLAGS AND IMPORTANT VARIABLES #############

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
echo "0" > ${scriptpath}Logs/.processesfinished.log # Set file that tracks how many of the children TrodeProcess parent background processes finished, really can't used environmental variables here! Because parent processes cannot get an exported copy of a variable from children. Hence, the file, which is hidden and inside the log folder.

clear
echo
echo
echo This program will now create background processes to run exportdio, exportLFP, exportspikes, exporttimes, and exportphy in parallel on all recfiles in folder structure $1 with file filter $2 ...
echo
read -p "Press enter to continue..."


PROCESSESFINISHED=$(cat ${scriptpath}Logs/.processesfinished.log)
debugtext=${scriptpath}Logs/allprocess.log.txt

echo “” > $debugtext

############# CALL EXPORT PROCESSING CHILD PROGRAMS #############
clear
echo initiating DIO  ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exportdio $2 > ${debugtext} 2>/dev/null &
clear
echo initiating LFP ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exportLFP $2 >> ${debugtext} 2>/dev/null &
clear
echo initiating spikes ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exportspikes $2 >> ${debugtext} 2>/dev/null &
clear
echo initiating times ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exporttime $2 >> ${debugtext} 2>/dev/null &
#${scriptpath}/TrodeProcess.sh $1 exportphy

############# WAIT FOR PROCESSES TO FINISH OR USER TO TERMINATE #############
X=""
PROCESSESFINISHED=$(ps -A | grep exportLFP | cut -d ' ' -f1,7)$(ps -A | grep exportspikes | cut -d ' ' -f1,7)$(ps -A | grep exportdio | cut -d ' ' -f1,7)$(ps -A | grep exporttime | cut -d ' ' -f1,7) # NEW METHOD
while [[ ! $X = "q" ]] && [[ -n $PROCESSESFINISHED ]]
do
	clear
	echo ==========
	echo Current Background Master Processes: 
	echo $PROCESSESFINISHED
	echo "(i.e. number of export functions that completed running on all folders)"
	echo ==========
	echo
	echo
	echo "Type q to quit installation, or you can use a terminal by setting ''STOPALLPROCESS=1'' and ''export STOPALLPROCESS''."
	read -t 5 -a X
	PROCESSESFINISHED=$(ps -A | grep exportLFP | cut -d ' ' -f1,7)$(ps -A | grep exportspikes | cut -d ' ' -f1,7)$(ps -A | grep exportdio | cut -d ' ' -f1,7)$(ps -A | grep exporttime | cut -d ' ' -f1,7) # NEW METHOD
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
	kill $(ps -A | grep exportLFP | cut -d ' ' -f1,2 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exportspikes | cut -d ' ' -f1,2 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exportdio | cut -d ' ' -f1,2 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exporttime | cut -d ' ' -f1,2 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null

	echo All export processes halted! Done.
fi

############# CALL MATLAB TO CREATE MATCLUST ANF FILTER FILES #############

# Run matlab scripts to convert .dat spike files into matclust files and automagically
# create the matclust files for all .X folders
if [[ -z $PROCESSESFINISHED ]]
then
	echo Initiating final matlab processing ...
	
	echo
	echo ----------------------------------------------------------
	currpath=$(pwd)
	cd $1
	MATLAB_COMMAND="path(genpath('${scriptpath}'),path);cd('$1');pwd;MatclustAndFilter;if(exit_status==0);exit;end;"
	echo About to run $MATLAB_COMMAND in matlab
	matlab -nodisplay -nosplash -r $MATLAB_COMMAND
	cd $currpath
fi

else # If cannot find realpath, we ask user to install it and exit

echo "You need to install realpath with either macports or apt-get before using this program."
exit 1

fi
