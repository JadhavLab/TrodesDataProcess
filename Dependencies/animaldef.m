function animalinfo = animaldef(animalname)
	
	% Get the user name!
	[~,username] = unix('whoami');
	switch deblank(username)
		case 'ss'				% on laptop
			if exist('/Volumes/Cerebellum/','dir')
				rootfolder = '/Volumes/Cerebellum/';
			else
				rootfolder = '/Volumes/mordorDATA/';
			end
		case {'jadhavlab','ryoung','root','mcz'}		% lab computer
			% particular lab computer must be rsynced such that its ~/Code
			% and ~/Data folders matches Ryan's
            if exist('~/Data/Mordor/','dir')
                rootfolder = '~/Data/Mordor/';
            elseif exist('/Volumes/Cerebellum/','dir')
                rootfolder = '~/Volumes/Cerebellum/';
            elseif exist('/media/mcz/mordorDATA/','dir')
                rootfolder = '~/media/mcz/mordorDATA/'
            else
                error('animaldef: Cannot find folder on system!');
            end
		otherwise
			error(['Haven''nt properly constructured animaldef to find path '...
				'to animal data.']);
	end

switch animalname

    % CA3-CA1 animals
    % Right now, just animals we navigated tetrodes down to CA3 to figure out how to get there
    case 'EG1'
	animalinfo = {'EG1', [rootfolder 'CA3-CA1/Efizz/EG1_direct/'] , 'EG1'};

        
    % Single day animals
    case 'JS7'
        animalinfo = {'JS7', [rootfolder 'W-track_SingleDay/Efizz/JS7_direct/'],'JS7'};
    case 'SJ6'
        animalinfo = {'SJ6', [rootfolder 'W-track_SingleDay/Efizz/SJ6_direct/'],'SJ6'};
    case 'SJ1'
        animalinfo = {'SJ1', [rootfolder 'W-track_SingleDay/Beh/SJ1_direct/'],'SJ1'};
    case 'SJ2'
        animalinfo = {'SJ2', [rootfolder 'W-track_SingleDay/Beh/SJ2_direct/'],'SJ2'};
    case 'SJ3'
        animalinfo = {'SJ3', [rootfolder 'W-track_SingleDay/Beh/SJ3_direct/'],'SJ3'};
    case 'SJ4'
        animalinfo = {'SJ4', [rootfolder 'W-track_SingleDay/Beh/SJ4_direct/'],'SJ4'};
        
    % New 8day HC-PFC animals
    case 'SJ5'
        animalinfo = {'SJ5', [rootfolder 'HP_8dayExpt/SJ5_direct/'],'SJ5'};    
        
    % Ripple Disruption  animals
    case 'DM4'
        animalinfo = {'DM4', [rootfolder 'HP_8dayExpt/RippleInterruption_current/DM4_direct/'],'DM4'};
    case 'sjc'
        animalinfo = {'sjc', [rootfolder 'HP_8dayExpt/RippleInterruption/sjc_direct/'], 'sjc'};
    case 'RE1'
        animalinfo = {'RE1', [rootfolder 'HP_8dayExpt/RippleInterruption/RE1_direct/'], 'RE1'};
    case 'RNa'
        animalinfo = {'RNa', [rootfolder 'HP_8dayExpt/RippleInterruption/RNa_direct/'], 'RNa'};
    case 'RNb'
        animalinfo = {'RNb', [rootfolder 'HP_8dayExpt/RippleInterruption/RNb_direct/'], 'RNb'};
    case 'RNc'
        animalinfo = {'RNc', [rootfolder 'HP_8dayExpt/RippleInterruption/RNc_direct/'], 'RNc'};
    case 'RNd'
        animalinfo = {'RNd', [rootfolder 'HP_8dayExpt/RippleInterruption/RNd_direct/'], 'RNd'};
    case 'RCa'
        animalinfo = {'RCa', [rootfolder 'HP_8dayExpt/RippleInterruption/RCa_direct/'], 'RCa'};
    case 'RCb'
        animalinfo = {'RCb', [rootfolder 'HP_8dayExpt/RippleInterruption/RCb_direct/'], 'RCb'};
    case 'RCc'
        animalinfo = {'RCc', [rootfolder 'HP_8dayExpt/RippleInterruption/RCc_direct/'], 'RCc'};
    case 'RCd'
        animalinfo = {'RCd', [rootfolder 'HP_8dayExpt/RippleInterruption/RCd_direct/'], 'RCd'};
    case 'REc'
        animalinfo = {'REc', [rootfolder 'HP_8dayExpt/RippleInterruption/REc_direct/'], 'REc'};
    case 'REd'
        animalinfo = {'REd', [rootfolder 'HP_8dayExpt/RippleInterruption/REd_direct/'], 'REd'};
    case 'REe'
        animalinfo = {'REe', [rootfolder 'HP_8dayExpt/RippleInterruption/REe_direct/'], 'REe'};
    case 'REf'
        animalinfo = {'REf', [rootfolder 'HP_8dayExpt/RippleInterruption/REf_direct/'], 'REf'};
    case 'REg'
        animalinfo = {'REg', [rootfolder 'HP_8dayExpt/RippleInterruption/REg_direct/'], 'REg'};
    case 'REh'
        animalinfo = {'REh', [rootfolder 'HP_8dayExpt/RippleInterruption/REh_direct/'], 'REh'};

    % Hippocampal-prefrontal animals
    case 'HPa'
        animalinfo = {'HPa', [rootfolder 'HP_8dayExpt/HPExpt/HPa_direct/'], 'HPa'};
    case 'HPb'
        animalinfo = {'HPb', [rootfolder 'HP_8dayExpt/HPExpt/HPb_direct/'], 'HPb'};
    case 'HPc'
        animalinfo = {'HPc', [rootfolder 'HP_8dayExpt/HPExpt/HPc_direct/'], 'HPc'};
    case 'Nadal'
        animalinfo = {'Ndl', [rootfolder 'HP_8dayExpt/HPExpt/Ndl_direct/'], 'Ndl'};
    case 'Rosenthal'
        animalinfo = {'Rtl', [rootfolder 'HP_8dayExpt/HPExpt/Rtl_direct/'], 'Rtl'};
    case 'Borg'
        animalinfo = {'Brg', [rootfolder 'HP_8dayExpt/HPExpt/Brg_direct/'], 'Brg'};
        
    % UH  OH -- animal name not recognized ...
    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

if ~exist(animalinfo{2},'dir'),
    warning('Directory not found! Creating...');
    mkdir(animalinfo{2});
end

fprintf('Using animal info at %s \n', animalinfo{2});
