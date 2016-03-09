function animalinfo = animaldef(animalname)
	
	% Get the user name!
	[~,username] = unix('whoami');
	switch deblank(username)
		case 'ss'				% on laptop
			if exist('/Volumes/Cerebellum/','dir')
				rootfolder = '/Volumes/Cerebellum/HP_8dayExpt/';
			else
				rootfolder = '/Volumes/mordorDATA/HP_8dayExpt/';
			end
		case {'jadhavlab','ryoung'}		% lab computer
			% particular lab computer must be rsynced such that its ~/Code
			% and ~/Data folders matches Ryan's
            if exist('~/Data/Mordor/HP_8dayExpt/','dir')
                rootfolder = '~/Data/Mordor/HP_8dayExpt/';
            elseif exist('/Volumes/Cerebellum/HP_8DayExpt','dir')
                rootfolder = '~/Data/Mordor/HP_8dayExpt/';
            else
                error('animaldef: Cannot find folder on system!');
            end
		otherwise
			error(['Haven''nt properly constructured animaldef to find path '...
				'to animal data.']);
	end

switch animalname
    
    % Ripple Disruption and Hippocampal-prefrontal animals
    
    case 'sjc'
        animalinfo = {'sjc', [rootfolder 'RippleInterruption/sjc_direct/'], 'sjc'};
    case 'RE1'
        animalinfo = {'RE1', [rootfolder 'RippleInterruption/RE1_direct/'], 'RE1'};
    case 'RNa'
        animalinfo = {'RNa', [rootfolder 'RippleInterruption/RNa_direct/'], 'RNa'};
    case 'RNb'
        animalinfo = {'RNb', [rootfolder 'RippleInterruption/RNb_direct/'], 'RNb'};
    case 'RNc'
        animalinfo = {'RNc', [rootfolder 'RippleInterruption/RNc_direct/'], 'RNc'};
    case 'RNd'
        animalinfo = {'RNd', [rootfolder 'RippleInterruption/RNd_direct/'], 'RNd'};
    case 'RCa'
        animalinfo = {'RCa', [rootfolder 'RippleInterruption/RCa_direct/'], 'RCa'};
    case 'RCb'
        animalinfo = {'RCb', [rootfolder 'RippleInterruption/RCb_direct/'], 'RCb'};
    case 'RCc'
        animalinfo = {'RCc', [rootfolder 'RippleInterruption/RCc_direct/'], 'RCc'};
    case 'RCd'
        animalinfo = {'RCd', [rootfolder 'RippleInterruption/RCd_direct/'], 'RCd'};
    case 'REc'
        animalinfo = {'REc', [rootfolder 'RippleInterruption/REc_direct/'], 'REc'};
    case 'REd'
        animalinfo = {'REd', [rootfolder 'RippleInterruption/REd_direct/'], 'REd'};
    case 'REe'
        animalinfo = {'REe', [rootfolder 'RippleInterruption/REe_direct/'], 'REe'};
    case 'REf'
        animalinfo = {'REf', [rootfolder 'RippleInterruption/REf_direct/'], 'REf'};
    case 'REg'
        animalinfo = {'REg', [rootfolder 'RippleInterruption/REg_direct/'], 'REg'};
    case 'REh'
        animalinfo = {'REh', [rootfolder 'RippleInterruption/REh_direct/'], 'REh'};
    case 'HPa'
        animalinfo = {'HPa', [rootfolder 'HPExpt/HPa_direct/'], 'HPa'};
    case 'HPb'
        animalinfo = {'HPb', [rootfolder 'HPExpt/HPb_direct/'], 'HPb'};
    case 'HPc'
        animalinfo = {'HPc', [rootfolder 'HPExpt/HPc_direct/'], 'HPc'};
    case 'Nadal'
        animalinfo = {'Ndl', [rootfolder 'HPExpt/Ndl_direct/'], 'Ndl'};
    case 'Rosenthal'
        animalinfo = {'Rtl', [rootfolder 'HPExpt/Rtl_direct/'], 'Rtl'};
    case 'Borg'
        animalinfo = {'Brg', [rootfolder 'HPExpt/Brg_direct/'], 'Brg'};
        
    otherwise
        
        error(['Animal ',animalname, ' not defined.']);
end

assert(~isempty(dir(animalinfo{2})), 'Directory not found! Error.');

fprintf('Using animal info at %s \n', animalinfo{2});