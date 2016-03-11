function session = getSession(fullfilename)

    % Store the calling folder
    curr_dir = pwd;

    % The following regular expression will be used to find the parent
    % folders date or session number, and if no sesion number, then derive
    % one from the other dates in the folder
    stringstartfilt = '((\/)([0-9]{2}_)?([12]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1})(.*\/))';
    
    % Let's find the parent folder containing sessions
    starts = regexp(fullfilename,stringstartfilt,'start');
    starts = min(starts);
    
    % Cd to that parent folder
    cd(fullfilename(1:starts-1));
    
    % Create filter for date and session
%     datesessionfilt = ...
%         '(?<session>[0-9]{2}_)?(?<date>[12]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1})';
      propertyfilt = '(?<animal>[A-Z]{1,10}[0-9]{0,2}_)?(?<session>[0-9]{2}_)?(?<date>[12]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1})(_[[:alphanum:]])?(?<directtag>_direct)?';

    % Collect all session and dates
    dates = []; sessions = [];
    files = dir;
    for f = 3:numel(files)
        if files(f).isdir
            % Identify parent directory containing sessions
            results = regexp(files(f).name,propertyfilt,'names');
            
            % Skip anything that's not a raw data session folder
            if ~isempty(results.animal) || ~isempty(results.directtag)
                continue;
            end
            
            dates    = strvcat(dates,results.date);
            sessions = strvcat(sessions,results.session);
        end
    end
    
    if size(dates,1) > size(sessions,1)
        % Someimtes only a date is given, if this is true, we will have to
        % infer the session number from the date
        
        this_date=regexp(fullfilename,propertyfilt,'names');
        this_date=this_date.date;
        this_date=datetime(this_date,'Format','yyyyMMdd');
        
        dates = datetime(dates,'Format','yyyyMMdd');
        dates = sort(dates);
        
        [~,session] = ismember(this_date,dates);
        
    elseif size(dates,1) == size(sessions,1)
        % If session number is provided, and it was provided for all
        % folders, it's safe to just take the session number.
        this_session=regexp(fullfilename,propertyfilt,'names');
        this_session=this_session.session;
        
        session = str2num(this_session);
        
    end
    
    % Return to the calling folder!
    cd(curr_dir);
    
end