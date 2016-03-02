

%% Process all .SPIKES folders in directory to generate matlab files
spikefiles = subdir('*.spikes')
currfolder = pwd;

fprintf('Found %d potential spike folders! ...\n',...
    numel(spikefiles));
for d = 1:numel(spikefiles)
    if spikefiles(d).isdir
        fprintf('About to process %s ...\n',...
            spikefiles(d).name);
        cd(spikefiles(d).folder);
        createAllMatclustFiles();

    end
end


cd(currfolder);

%% Process all .LFP/.DIO/.TIME Folders to generate filter framework files

