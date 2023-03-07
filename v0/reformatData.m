function data = reformatData(sta,cha,days,units,dirout)

% Save .dat file with columns of 
%   year, month, day, hour, minute, second, channel_data
% Also save .mat file containing this content.

if nargin < 5
    % Dir of this script
    dirout = fullfile(fileparts(mfilename('fullpath')),'data'); 
end

dir_site     = fullfile(dirout,sta);
dir_original = fullfile(dir_site,'original');

dir_reformatted = fullfile(dir_site,'reformatted');
if ~exist(dir_reformatted,'dir')
  mkdir(dir_reformatted);
end


for day = days
    ds = datestr(day,29);

    fname_base         = sprintf('%s_%s_%s-%s',sta,cha,ds,units);
    fname_original     = fullfile(dir_original,[fname_base,'.txt']);
    fname_reformatted1 = fullfile(dir_reformatted,[fname_base,'.dat']);
    fname_reformatted2 = fullfile(dir_reformatted,[fname_base,'.mat']);
    
    if exist(fname_reformatted1,'file') && exist(fname_reformatted2,'file')
        fprintf('Found %s/reformatted/%s.mat. Not re-creating\n',sta,fname_base);
        continue;
    end

    % Use perl because much faster than using MATLAB fscanf to read.
    com = sprintf('perl -p -e ''s/([0-9])\\-([0-9])/$1 $2/g'' %s | perl -p -e ''s/T|:/ /g'' | perl -p -e ''/^[0-9].*/g'' | grep -e "^[0-9]" > %s',fname_original,fname_reformatted1);
    system(com);
    fprintf('Wrote %s/reformatted/%s.dat\n',sta,fname_base);    
    try
        data = load(fname_reformatted1);
        save(fname_reformatted2,'data');
        fprintf('Wrote %s/reformatted/%s.mat\n',sta,fname_base);
    catch
        fprintf('Error loading %s/original/%s.dat. Skipping.\n',sta,fname_base);
    end

end