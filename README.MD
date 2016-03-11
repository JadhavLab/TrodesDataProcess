
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
3) For automated matclust and NeuroQuery file creation, have TrodesToMatlab and BashTrodes folders/subfolders in path
4) DONE!

### PURPOSE
-----------------------------
This script suite has three different useful functions. One thing it allows you to do, is process an entire server containing multiple experiments, each having their own folder structure of rec files in one command.

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

Applies all export programs to all recfiles in the nested folder structure of X. Knocks out all of the extraction process once and for all, generating all the .dat files for all .rec files. This opens 4 processes that run in the background and handle each of the exports respectively. Once this process has begun, to terminate, type "q" and hit enter. 

The program proceeds to call MatclustAndFilter.m on all files that it finished processing, and places your filter files into folders in accordance with your animaldef.m

4) MatclustAndFilter.m
	
	Usage: (cd to the folder structure of interest) ... then type into Matlab "MatclustAndFilter"

This matlab function finds every .LFP, .spikes, .time, .DIO folder nested subfolders and process them to genereate matclust and NeuroQuery (Filter Framework) files. In order to assign a session number automatically, it only has expectation. Every time it finds a .DATA folder, it looks at the parent folder to infer its session ID number. So, suppose you have X.LFP, it then looks at the folder structure above it, and per folder containing one single session, it expects a date or session number and date in the folder name. For example, X.LFP may exist in 20160204, and the folder that contains that folder has sessions 20160203 20160204 20160205. It then infers that the session ID of X.LFP is 2. It does this by ranking dates it pulls out and computing its location in that list. ALternatively, one can structure folders containing each session as 01_date1 02_date2 03_date2 04_date3 and so on, and it will ignore the date, and interpet the number leading the underscore as session number. All other folders in the hierarchy can be titled however.

#### OTHER FEATURES
---------------------------------
If you set an environmental variable SKIPPROCESSED to 1, it will skip rec files that have already been processed.
	type "export SKIPPROCESSED=1", and then run the programs above as normal
