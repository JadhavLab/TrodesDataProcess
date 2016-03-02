#!/bin/bash
#
# Add SKIPPROCESSED=1 to skip processed rec files

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

# Initialize the variable that keeps track of whether this process is finished
FINISHEDPROCESS=0

clear
echo processing DIO ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exportdio > ${debugtext} 2>/dev/null &
clear
echo processing LFP ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exportLFP >> ${debugtext} 2>/dev/null &
clear
echo processing spikes ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exportspikes >> ${debugtext} 2>/dev/null &
clear
echo processing times ... ; sleep 0.5
${scriptpath}/TrodeProcess.sh $1 exporttime >> ${debugtext} 2>/dev/null &
#${scriptpath}/TrodeProcess.sh $1 exportphy

X=initial
while [ $FINISHEDPROCESS != "1" -a $X != "q" ] ;
do

	# Start background process to check if this finished!
	#/.checkprocessfinished.sh &

	# Otherwise, wait for user to hit the quit key
	clear
	echo $X
	echo $FINISHEDPROCESS
	echo "Type q to quit installation, or you can use a terminal by setting ''STOPALLPROCESS=1'' and ''export STOPALLPROCESS''."
	read X
done

if [ $X = "q" ] ;
then

	echo Setting environmental variable to stop processing ...
	sleep 1
	# Signal future processes to stop
	export STOPALLPROCESS=1

	# Destroy currently running processes
	echo Destroying currently running Trode export programs ...
	sleep 1
	kill $(ps -A | grep exportLFP | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exportspikes | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exportdio | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null
	kill $(ps -A | grep exporttime | cut -d ' ' -f1 | tr '\n' ' ') 2>>${debugtext} 1>/dev/null

	echo All export processes halted! Done.

	export STOPALLPROCESS=0

fi

# Run matlab scripts to convert .dat spike files into matclust files and automagically
# create the matclust files for all .X folders

if [ -z $(echo $LD_LIBRARY_PATH | grep libmwlaunchermain.so) ] ;
then
	echo
	echo ----------------------------------------------------------
	echo Before we process matclust files and filter files, we need to put a matlab libary \
		on path.
	echo Searching ...
	missinglibrary=$(find / -name libmwlaunchermain.so 2> /dev/null)
	missinglibrary=$(echo $missinglibrary | head -n 1)
	echo Adding library ...
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$missinglibrary
	echo ----------------------------------------------------------
	echo
fi

echo
echo ----------------------------------------------------------
currpath=$(pwd)
cd $1
"${scriptpath}"AutoProcessToFilterFramework
cd $currpath

else

echo "You need to install realpath with either macports or apt-get before using this program."

fi
