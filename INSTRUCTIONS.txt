
INSTALLATION INSTRUCTIONS
-----------------------------
1) type "which realpath" 
... if nothing comes up, its a quick download. As long as you have unix, do the following
	a) Debian/Ubuntu: 
		sudo apt-get install realpath
	b) Mac OS: If you do not have macports, install it; then run 
		sudo port install realpath
2) Enter the path to the folder containing your export functions (e.g. exportspikes, exportdio) in TrodesPath.txt
	e.g. "~/Code/Trodes"
3) DONE!

PURPOSE
-----------------------------
This script suite has three different useful functions

1) SetConfiguration.sh 

	Usage: ./SetConfiguration.sh X Y
	, where X = recursive folder path
		Y = configuration file

	SetConfiguration permits you to take a configuration file (.xml or .trodesConf) and apply it to every rec file in a directory structure. The script dives into each folder and for every X.rec it finds, it creates a X.trodesConf with the Y configuration file provided.

2) TrodeProcess.sh

	Usage: ./TrodeProcess.sh X Y
	, where X = recursive folder path
		Y = exportdio or exporttime or exportspikes or exportLFP

	Trode process applies to every .rec it finds in the entire nested folder structure of X and starts extraction program Y.

3) AllProcess.sh

	Usage: ./TrodeProcess.sh X
	, where X = recursive folder path	


	Applies all export programs to all recfiles in the nested folder structure of X. Knocks out all of the extraction process once and for all, generating all the .dat files for all .rec files. This opens 5 processes that run in the background and handle each of the exports respectively. Once this process has begun, it is at the moment, difficult to terminate, because the processes run in the background: you have to terminate each sub-process from using unix’s top or mac os’s activity monitor.

OTHER FEATURES
---------------------------------
If you set an environmental variable SKIPPROCESSED to 1, it will skip rec files that have already been processed.
	type "export SKIPPROCESSED=1", and then run the programs above as normal
