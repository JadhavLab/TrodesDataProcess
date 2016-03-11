clear; close all;
exit_status=1;
	
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
        
        try
        
        fprintf('About to process %s matclust files ...\n',...
            spikefiles(d).name);
		[where_to_proces, ~] = fileparts(spikefiles(d).name);
		cd(where_to_proces);
		
		% Processes the matclust files into the same .spikes folder
%         createAllMatclustFiles;
        
        catch ME
            disp('Error occured while running automated matclust/filter code.');
            cd(currfolder);
            save([datestr(now,'mm.dd-HH:MM-') 'Matclust_BashTrodes_Matlab_ProcessingError']);
        end

    end
end

cd(currfolder);
	
%% Process all .LFP into filter framework files
LFPfiles = subdir('*.LFP');
if ~isempty(LFPfiles)
for d = 1:numel(LFPfiles)
    if LFPfiles(d).isdir
        
        try

        fprintf('About to process %s into filter framework ...\n', ...
            LFPfiles(d).name);
        [where_to_proces, ~] = fileparts(LFPfiles(d).name);
		cd(where_to_proces);

        session = getSession(LFPfiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).LFP$';
        filteredstring = regexp(LFPfiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);
        warning off; mkdir([animalinfo{2} 'EEG/']); warning on;

        if exist('createNQLFPFiles.m','file')
            createNQLFPFiles([animalinfo{2} 'EEG/'], animalinfo{3}, session);
        elseif exist('createFilterFrameworkLFPFiles.m','file')
            createFilterFrameworkLFPFiles([animalinfo{2} 'EEG/'], animalinfo{3},...
                session);
        else
            warning('createNQLFPFiles DNE ... TrodesToMatlab potentially not on path.');
        end
        
        catch ME
            disp('Error occured while running automated matclust/filter code.');
            cd(currfolder);
            save([datestr(now,'mm.dd-HH:MM-') 'LFP_BashTrodes_Matlab_ProcessingError']);
        end

    end
end
end


%% Process all .DIO into filter framework files
DIOfiles = subdir('*.DIO');
if ~isempty(DIOfiles)
for d = 1:numel(DIOfiles)
    if DIOfiles(d).isdir
        
        try

        fprintf('About to process %s into filter framework ...\n', ...
            DIOfiles(d).name);
        [where_to_proces, ~] = fileparts(DIOfiles(d).name);
		cd(where_to_proces);

        session = getSession(DIOfiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).DIO$';
        filteredstring = regexp(DIOfiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);

        if exist('createNQDioFiles.m','file')
            createNQDioFiles(animalinfo{2}, animalinfo{3}, session);
        elseif exist('createFilterFrameworkDioFiles.m','file')
            createFilterFrameworkDioFiles(animalinfo{2}, animalinfo{3}, ...
                session);
        else
            warning('createNQDioFiles DNE ... TrodesToMatlab potentially not on path.');
        end
        
        catch ME
            disp('Error occured while running automated matclust/filter code.');
            cd(currfolder);
            save([datestr(now,'mm.dd-HH:MM-') 'DIO_BashTrodes_Matlab_ProcessingError']);
        end

    end
end
end


%% Process all .trodeComments into filter framework files
commentFiles = subdir('*.trodesComments');
if ~isempty(commentFiles)
for d = 1:numel(commentFiles)
    if ~commentFiles(d).isdir
        
        try

        fprintf('About to process %s into filter framework ...\n', ...
            commentFiles(d).name);
        [where_to_proces, ~] = fileparts(commentFiles(d).name);
        cd(where_to_proces);

        session = getSession(commentFiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).trodeComments$';
        filteredstring = regexp(commentFiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);
        
        if exist('createNQTaskFile.m','file')
            createNQTaskFile(animalinfo{2}, animalinfo{3}, session);
            createNQTrialFile(animalinfo{2}, animalinfo{3}, session);
        elseif exist('createFilterFrameworkTaskFile.m','file')
            createFilterFrameworkTaskFile(animalinfo{2}, animalinfo{3},...
                session);
            createFilterFrameworkTrialFiles(animalinfo{2},animalinfo{3},...
                session);
        else
            warning('createNQTaskFile DNE ... TrodesToMatlab potentially not on path.');
        end
        
        catch ME
            disp('Error occured while running automated matclust/filter code.');
            cd(currfolder);
            save([datestr(now,'mm.dd-HH:MM-') 'TrialTask_BashTrodes_Matlab_ProcessingError']);
        end

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
        
        try

        fprintf('About to process %s into filter framework ...\n', ...
            videoTrackingFiles(d).name);
        [where_to_proces, ~] = fileparts(videoTrackingFiles(d).name);
        cd(where_to_proces);

        session = getSession(videoTrackingFiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).videoPositionTracking$';
        filteredstring = regexp(videoTrackingFiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);

        if exist('createNQPosFiles.m','file')
            createNQPosFiles(animalinfo{2}, animalinfo{3}, session);
        elseif exist('createFilterFrameworkPosFiles.m','file')
             createFilterFrameworkPosFiles(animalinfo{2}, animalinfo{3}, ...
                 session);
        else
            warning('createNQPosFiles DNE ... TrodesToMatlab potentially not on path.');
        end
        
        catch ME
            disp('Error occured while running automated matclust/filter code.');
            cd(currfolder);
            save([datestr(now,'mm.dd-HH:MM-') 'PosTrack_BashTrodes_Matlab_ProcessingError']);
        end
       
    end
end
else
    warning('No video tracking files found!');
end	

%% Terminate

% Compute exit status
if ~exist('ME','var') || isempty(ME)
    exit_status = 0;
else
    exit_status = 0;
end