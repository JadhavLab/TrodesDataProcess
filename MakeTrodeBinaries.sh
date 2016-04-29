#!/bin/bash

# Author: 	Ryan Young
# Description:  Makes all binaries in $1 and places them into a folder $2 of your choosing as 			specified by the first argument. Got kind of tired of encumbersome GUI and
#		dragging all compiled binaries into the right location.
#
#		$3 is an optional argument indicating whether or not we ought to clean the folder

function executeCompile()
{
	_numberOfJobs=8
	
	# HANDLE THE ARGUMENTS
	if [[ $2 =~ "*qmake" ]]
	then
		echo executeCompile: First argument to execute compile wrong
		return 1
	fi

	if [[ $3 =~ "*qmake" ]]
	then
		echo executeCompile: Second argument to execute compile wrong
		return 2
	fi

	_qmake=$1;

	# Acquire the binary name
	binary_name=$(echo $2 | grep -o '[A-Za-z0-9]*$')
	if [ $binary_name = "Source" ]
	then
		binary_name=Trodes
	fi
	if [ $binary_name = "exportPHY" ]
	then
		binary_name=exportphy
	fi

	# Move into the folder, generate makefile, and compile	
	cd $2; #echo executeCompile: running $_qmake in $(pwd) with ${binary_name}...; sleep 10;
	$_qmake
	mkdir $3/MakeLog 2> /dev/null
	make -j${_numberOfJobs} 1> $3/MakeLog/${binary_name}.stdout.makelog 2> $3/MakeLog/${binary_name}.stderr.makelog


	# Move binary into desired folder
	mv $binary_name $3

	return 0
}

#################
# Parsing arguments 4-end ...
# should we specifically only compile some subset of programs
#################

gitfolder=$1
targetfolder=$2
clean=$3

targetlist=""
greplist=""
while [[ -n $4 ]]
do
	targetlist="$4 ${targetlist}"
	greplist="-e $4 ${greplist}"
	shift	
done 
if [[ -n $targetlist ]]
then
	echo "Programs targeted for compilation -> " $targetlist
else
	echo "All programs targeted for compilation"
fi
sleep 1

################
# Should we clean before building?
################
if [[ -n $clean ]] && [[ $clean == 1 ]] 
then
	# If user requests we clean directories before compiling, remove all compiled objects, moc, obj, and generated Make files, then we do that here
	echo Cleaning before we start ..; sleep 1
	find $gitfolder -name moc -type d -exec rm -rf {} \; 2> /dev/null
	find $gitfolder -name obj -type d -exec rm -rf {} \; 2> /dev/null
	find $gitfolder -name *.o -type f -exec rm -rf {} \; 2> /dev/null
	find $gitfolder -name Makefile -type f -exec rm -rf {} \;
else
	echo Not cleaning out makefile and object files before starting ..; sleep 1
fi

export _qmake="/opt/Qt/5.4/gcc_64/bin/qmake"
currdir=$(pwd)

#################
# Compile Modules
#################
echo
echo ============================================================================
echo Compiling modules!; 
ListOfModules="cameraModule FSGui FSGui/FSData RewardGui stateScript stateScript/stateScriptEditor";sleep 2;
echo ListOfModules = $ListOfModules;
for m in $ListOfModules
do
	if [[ -z $targetlist ]] || [[ -n $(echo $m | grep $greplist) ]]
	then
		echo MakeTrodeBinaries: Making $m in "${gitfolder}/Modules/${m}" ...
		executeCompile $_qmake "${gitfolder}/Modules/${m}" ${targetfolder} &
	fi
done;

#################
# Compile Export Functions
#################
echo
echo ============================================================================
echo Compiling exports!; 
ListOfExports="exportdio exportLFP exportPHY exportspikes exporttime exportanalog";sleep 2;
echo ListOfExports = $ListOfExports;
for i in $ListOfExports
do
	if [[ -z $targetlist ]] || [[ -n $(echo $i | grep $greplist) ]]
	then
		echo MakeTrodeBinaries: Making $i in ${gitfolder}/Export/$i ${targetfolder} ...
		executeCompile $_qmake "${gitfolder}/Export/${i}" ${targetfolder} &
	fi
done;

#################
# Compile Trodes
#################
echo ============================================================================
echo Compiling Trodes main!; sleep 2;
if [[ -z $targetlist ]] || [[ -n $(echo "Trodes" | grep $greplist) ]]
then
	echo Making Trodes ...
	executeCompile $_qmake "${gitfolder}/Source" ${targetfolder} &
fi

cd $currdir

##################
# Run completed instance if proper env variable set
###################

if [[ -n $RUNTRODES ]] && ( [[ $RUNTRODES == "1" ]] || [[ $RUNTRODES == "true" ]] )
then
	
	makeprocesses=$(ps -A | grep make)
	while [[ -n $makeprocesses ]]
	do
		clear
		echo "Waiting for make to complete"
		makeprocesses=$(ps -A | grep make)
	done

	cd ${targetfolder}
	./Trodes.sh
	cd ${currdir}

fi
