clear; close all;
try
	
if ~exist('animaldef.m','file')
	warning('animaldef.m not found! asking user where to put files');
end

%% Process all .SPIKES folders in directory to generate matlab files

spikefiles = subdir('*.spikes.dat')
currfolder = pwd;

fprintf('Found %d potential spike folders! ...\n',...
    numel(spikefiles));
for d = 1:numel(spikefiles)
    if spikefiles(d).isdir
        fprintf('About to process %s matclust files ...\n',...
            spikefiles(d).name);
		
		destination = fileparts(spikesfiles(d).name);
		
		% Processes the matclust files into the same .spikes folder
        createAllMatclustFiles(spikesfiles(d).name, destination);

    end
end


cd(currfolder);

%% Decide which code framework to use
% First we need to decide if each folder contains one or multiple recfiles
% ... that will determine if we are to use mattias's pipeline or a modified
% version of mattias's pipeline designed for folders where epochs were
% taken in several rec files


if singlerecfile % mode for all current to future collected data
	
	%% Process all .LFP/.DIO/.TIME Folders to generate filter framework files
	LFPfiles = subdir('*.LFP')
	for d = 1:numel(LFPfiles)
		if LFPfiles(d).isdir

			fprintf('About to process %s into filter framework ...\n', ...
				LFPfiles(d).name);
			cd(LFPfiles(d).folder);

			filename = LFPfiles(d).name;

			session = regexp(LFPfiles(d).name,'[1-9]?[0-9]{1}.mat$','name');
			session = session(1:end-4);

			animal=filename(1:3);
			animaldestination = animaldef('HPa');
			animaldestination = animaldestination{2};

			createFilterFrameworkLFPFiles(animaldesintation, animal, session);

		end
	end
	
else			% use a special version of the pipeline for stitching
				% and go folder by folder
	
	
	
end

%% Terminate
catch ME
	disp('Error occured while running automated matclust/filter code.');
	
end
	
exit