clear; close all;

try
	
if ~exist('animaldef.m','file')
	warning('animaldef.m not found! asking user where to put files');
    destination=input('Please provide a folder destination for output: ',...
        's');
end

if ~exist('createAllMatclustFiles.m','file')
	error('TrodesToMatlab not in path!!! ... exiting');
end

%% Process all .SPIKES folders in directory to generate matlab files

spikefiles = subdir('*.spikes');
currfolder = pwd;

fprintf('Found %d potential spike folders! ...\n',...
    numel(spikefiles));
for d = 1:numel(spikefiles)
    if spikefiles(d).isdir
        fprintf('About to process %s matclust files ...\n',...
            spikefiles(d).name);
		[where_to_proces, ~] = fileparts(spikefiles(d).name);
		cd(where_to_proces);
		
		% Processes the matclust files into the same .spikes folder
        createAllMatclustFiles;

    end
end


cd(currfolder);
	
%% Process all .LFP into filter framework files
LFPfiles = subdir('*.LFP');
if ~isempty(LFPfiles)
for d = 1:numel(LFPfiles)
    if LFPfiles(d).isdir

        fprintf('About to process %s into filter framework ...\n', ...
            LFPfiles(d).name);
        [where_to_proces, ~] = fileparts(LFPfiles(d).name);
		cd(where_to_proces);

        session = getSession(LFPfiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).LFP$';
        filteredstring = regexp(LFPfiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);

        createFilterFrameworkLFPFiles(animalinfo{2}, animalinfo{3}, session);

    end
end
end

%% Process all .DIO into filter framework files
DIOfiles = subdir('*.DIO');
if ~isempty(DIOfiles)
for d = 1:numel(DIOfiles)
    if DIOfiles(d).isdir

        fprintf('About to process %s into filter framework ...\n', ...
            DIOfiles(d).name);
        [where_to_proces, ~] = fileparts(DIOfiles(d).name);
		cd(where_to_proces);

        session = getSession(DIOfiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).DIO$';
        filteredstring = regexp(DIOfiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);

        createFilterFrameworkDioFiles(animalinfo{2}, animalinfo{3}, session);

    end
end
end

%% Process all .trodeComments into filter framework files
commentFiles = subdir('*.trodesComments');
if ~isempty(commentFiles)
for d = 1:numel(commentFiles)
    if ~commentFiles(d).isdir

        fprintf('About to process %s into filter framework ...\n', ...
            commentFiles(d).name);
        [where_to_proces, ~] = fileparts(commentFiles(d).name);
        cd(where_to_proces);

        session = getSession(commentFiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).trodeComments$';
        filteredstring = regexp(commentFiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);

        createFilterFrameworkTaskFile(animalinfo{2}, animalinfo{3}, session);
        createFilterFrameworkTrialFiles(animalinfo{2},animalinfo{3},session);

    end
end
else
    warning('No trodeComments files found!');
end

%% Process all .videoPositionTracking into filter framework files
videoTrackingFiles = subdir('*.videoPositionTracking');
if ~isempty(videoTrackingFiles)
for d = 1:numel(videoTrackingFiles)
    if ~videoTrackingFiles(d).isdir

        fprintf('About to process %s into filter framework ...\n', ...
            videoTrackingFiles(d).name);
        [where_to_proces, ~] = fileparts(videoTrackingFiles(d).name);
        cd(where_to_proces);

        session = getSession(videoTrackingFiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).videoPositionTracking$';
        filteredstring = regexp(videoTrackingFiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);

        createFilterFrameworkPosFiles(animalinfo{2}, animalinfo{3}, session);

    end
end
else
    warning('No video tracking files found!');
end	

%% Terminate
catch ME
	disp('Error occured while running automated matclust/filter code.');
    cd(currfolder);
    save('BashTrodes_Matlab_ProcessingError');
end
	
% exit