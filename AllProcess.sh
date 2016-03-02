#!/bin/bash

STOPALLPROCESS=0
export STOPALLPROCESS

echo Creating background processes to run exportdio, exportLFP, exportspikes, exporttimes, and exportphy in parallel on all recfiles in folder structure $1

dependency_path=$(which realpath)
detect_fundamental_program=${#dependency_path}
if [ "$detect_fundamental_program" -gt "0" ]
then

echo d1

SCRIPT=`realpath $0`
scriptpath=$(echo $SCRIPT | sed 's/\/[a-zA-Z0-9]*.sh$/\//')
echo Script execution path detected: $scriptpath

debugtext=${scriptpath}/allprocess.log.txt

echo “” > $debugtext

clear
echo processing DIO ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exportdio > ${debugtext} 2>/dev/null &
clear
echo processing LFP ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exportLFP >> ${debugtext} 2>/dev/null &
clear
echo processing spikes ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exportspikes >> ${debugtext} 2>/dev/null &
clear
echo processing times ... ; sleep 1
${scriptpath}/TrodeProcess.sh $1 exporttime >> ${debugtext} 2>/dev/null &
#${scriptpath}/TrodeProcess.sh $1 exportphy

clear
echo "Type q to quit installation, or you can use a terminal by setting ''STOPALLPROCESS=1'' and ''export STOPALLPROCESS''."
read X
if [ $X = "q" ];
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


else

echo "You need to install realpath with either macports or apt-get before using this program."

fi
