clear; close all;

try
	
if ~exist('animaldef.m','file')
	warning('animaldef.m not found! asking user where to put files');
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
        %createAllMatclustFiles;

    end
end


cd(currfolder);
	
%% Process all .LFP/.DIO/.TIME Folders to generate filter framework files
LFPfiles = subdir('*.LFP');
for d = 1:numel(LFPfiles)
    if LFPfiles(d).isdir

        fprintf('About to process %s into filter framework ...\n', ...
            LFPfiles(d).name);
        [where_to_proces, ~] = fileparts(LFPfiles(d).name);
		cd(where_to_proces);

        session = regexp(LFPfiles(d).name,'[1-9]?[0-9]{1}.LFP$','name');
        session = session(1:end-4);

        animal=filename(1:3);
        animaldestination = animaldef('HPa');
        animaldestination = animaldestination{2};

        createFilterFrameworkLFPFiles(animaldesintation, animal, session);

    end
end
	

%% Terminate
catch ME
	disp('Error occured while running automated matclust/filter code.');
end
	
exit