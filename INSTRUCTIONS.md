
### INSTALLATION INSTRUCTIONS
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

### PURPOSE
-----------------------------
This script suite has three different useful functions

1) SetConfiguration.sh 

	Usage: ./SetConfiguration.sh X Y
	, where X = recursive folder path
		Y = configuration file

SetConfiguration permits you to take a configuration file (.xml or .trodesConf) and apply it to every rec file in a directory structure. The script dives into each folder and for every X.rec it finds, it creates a X.trodesConf with the Y configuration file provided.

2) TrodeProcess.sh

	Usage: ./TrodeProcess.sh X Y Z
	, where X = recursive folder path
		Y = exportdio or exporttime or exportspikes or exportLFP
		Z = filter string, e.g. SJ6

Trode process applies to every .rec it finds in the entire nested folder structure of X and starts extraction program Y. Z is optional, and indicates a rec file filter. E.g. if it's DM4, only rec files beginning with DM4 will be processed. When the program finds a folder of rec files, it stitches them together into a single resultant folder, just like the matlab export functions. Further, it titles the output with the largest string common in all matching rec file names. E.g. DM4_Wmaze1.rec DM4_WMaze2.rec would produce a folder for the the output as DM4_WMaze.*

3) AllProcess.sh

	Usage: ./AllProcess.sh X Y
	, where X = recursive folder path	
		Y = filter string, e.g. SJ6

Applies all export programs to all recfiles in the nested folder structure of X. Knocks out all of the extraction process once and for all, generating all the .dat files for all .rec files. This opens 4 processes that run in the background and handle each of the exports respectively. Once this process has begun, to terminate, type "q" and hit enter. The program proceeds to process matclust and filter files if it finishes processing all rec files. 

#### OTHER FEATURES
---------------------------------
If you set an environmental variable SKIPPROCESSED to 1, it will skip rec files that have already been processed.
	type "export SKIPPROCESSED=1", and then run the programs above as normal
