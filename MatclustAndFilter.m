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
curr_dir = pwd;

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
         createAllMatclustFiles;
        
        catch ME
           processError(ME,'Matclust');
        end

    end
end
cd(curr_dir);
	
%% Process all .LFP into filter framework files
LFPfiles = subdir('*.LFP');

fprintf('Found %d potential LFP folders! ...\n',...
    numel(LFPfiles));
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
            processError(ME,'LFP');
        end

    end
end
end
cd(curr_dir);


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
            processError(ME,'DIO');
        end

    end
end
end
cd(curr_dir);


%% Process all .trodeComments into filter framework files

commentFiles = subdir('*.trodesComments');
fprintf('Found %d potential comment files! ...\n',...
    numel(commentFiles));
if ~isempty(commentFiles)
for d = 1:numel(commentFiles)
    if ~commentFiles(d).isdir
        
        try

        fprintf('About to process %s into filter framework ...\n', ...
            commentFiles(d).name);
        [where_to_proces, ~] = fileparts(commentFiles(d).name);
        cd(where_to_proces);

        session = getSession(commentFiles(d).name);

        animalfilter = '(.*)(?<animal>[A-Z]{2,12}[0-9]{0,2})_(.*).trodesComments$';
        filteredstring = regexp(commentFiles(d).name,animalfilter,'names');
        animalinfo = animaldef(filteredstring.animal);
        
        if exist('createNQTaskFile.m','file')
            createNQTaskFile(animalinfo{2}, animalinfo{3}, session);
            if ~isempty(dir(['*_scLog.txt']))
                createNQTrialFiles(animalinfo{2}, animalinfo{3}, session);
            end
        elseif exist('createFilterFrameworkTaskFile.m','file')
            createFilterFrameworkTaskFile(animalinfo{2}, animalinfo{3},...
                session);
            if ~isempty(dir(['*_scLog.txt']))
                createFilterFrameworkTrialFiles(animalinfo{2},animalinfo{3},...
                    session);
            end
        else
            warning('createNQTaskFile DNE ... TrodesToMatlab potentially not on path.');
        end
        
        catch ME
           processError(ME,'TaskTrial');
        end

    end
end
else
    warning('No trodeComments files found!');
end
cd(curr_dir);

%% Process all .videoPositionTracking into filter framework files
videoTrackingFiles = subdir('*.videoPositionTracking');
fprintf('Found %d potential video tracking files! ...\n',...
    numel(videoTrackingFiles));
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
            processError(ME,'PositionTracking');
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