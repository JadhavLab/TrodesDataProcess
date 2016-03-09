#!/bin/bash

export STOPALLPROCESS=0 # Flag that tracks whether user has requested to halt processing
echo 0 > ${scriptpath}Logs/.processesfinished.log # Set file that tracks how many of the children TrodeProcess parent background processes finished, really can't used environmental variables here! Because parent processes cannot get an exported copy of a variable from children. Hence, the file, which is hidden and inside the log folder.

clear
echo Creating background processes to run exportdio, exportLFP, exportspikes, exporttimes, and exportphy in parallel on all recfiles in folder structure $1 with file filter $2
echo intializing PROCESSESFINISHED to $PROCESSESFINISHED
sleep 1

dependency_path=$(which realpath)
detect_fundamental_program=${#dependency_path}
if [ "$detect_fundamental_program" -gt "0" ]
then

echo d1

SCRIPT=`realpath $0`
scriptpath=$(echo $SCRIPT | sed 's/\/[a-zA-Z0-9]*.sh$/\//')
echo Script execution path detected: $scriptpath

debugtext=${scriptpath}Logs/allprocess.log.txt

echo “” > $debugtext

clear
echo processing DIO  ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exportdio $2 > ${debugtext} 2>/dev/null &
clear
echo processing LFP ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exportLFP $2 >> ${debugtext} 2>/dev/null &
clear
echo processing spikes ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exportspikes $2 >> ${debugtext} 2>/dev/null &
clear
echo processing times ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exporttime $2 >> ${debugtext} 2>/dev/null &
#${scriptpath}/TrodeProcess.sh $1 exportphy

X=""
while [[ ! $X = "q" ]] && [[ ! $PROCESSESFINISHED == "4" ]] ;
do
	clear
	PROCESSESFINISHED=$(cat ${scriptpath}Logs/.processesfinished.log)
	echo ==========
	echo Current Background Master Processes Finished: $PROCESSESFINISHED
	echo "(i.e. number of export functions that completed running on all folders)"
	echo ==========
	echo
	echo
	echo "Type q to quit installation, or you can use a terminal by setting ''STOPALLPROCESS=1'' and ''export STOPALLPROCESS''."
	read -t 5 -a X
done

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
	kill $(ps -A | grep exportLFP | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exportspikes | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exportdio | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exporttime | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null

	echo All export processes halted! Done.
fi

if [[ $PROCESSESFINISHED == "4" ]]
then
	echo Initiating final matlab processing ...
	# MATLAB PROCESSING!  
fi

 


else

echo "You need to install realpath with either macports or apt-get before using this program."

fi
