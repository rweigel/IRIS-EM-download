function fname_original = getData(sta,cha,days,units,dirout)

% Web service API:
% http://service.iris.edu/irisws/
% http://service.iris.edu/irisws/timeseries/1/

% http://service.iris.edu/irisws/fedcatalog/1/query?net=EM
% Get actual last day in archive from bottom of, e.g.,
% http://www.iris.washington.edu/mda/EM/MBB05

if nargin < 5
    % Dir of this script
    dirout = fullfile(fileparts(mfilename('fullpath')),'data'); 
end
if ~exist(dirout,'dir')
    mkdir(dirout);
end

force = 0; % Try to download file even if previous failure.

url0 = 'http://service.iris.edu/irisws/timeseries/1/query?net=EM&';

if strcmp(units,'counts')
  url1 = 'sta=%s&loc=--&cha=%s&starttime=%sT00:00:00&endtime=%sT23:59:59&output=ascii';
else
  url1 = 'sta=%s&loc=--&cha=%s&correct=true&units=DEF&starttime=%sT00:00:00&endtime=%sT23:59:59&output=ascii';
  url1 = 'sta=%s&loc=--&cha=%s&correct=true&units=DEF&starttime=%sT23:00:00&endtime=%sT01:00:00&output=ascii';
end

dir_site        = fullfile(dirout,sta);
dir_original    = fullfile(dir_site,'original');

if ~exist(dirout,'dir')
  % Will fail if one or more parent dirs need to be created. MATLAB 
  % does not have an equivalent to mkdir -p.
  mkdir(dirout);
end
if ~exist(dir_site,'dir')
  mkdir(dir_site);
end
if ~exist(dir_original,'dir')
  mkdir(dir_original);
end

for day = days

    ds = datestr(day,29);

    fname_base = sprintf('%s_%s_%s-%s.txt',sta,cha,ds,units);
    fname_original = fullfile(dir_original,fname_base);
    if exist(fname_original,'file') || exist([fname_original,'.gz'],'file')
        fprintf('Found %s. Not re-downloading.\n',fname_base);
        continue;
    end
    
    url = sprintf([url0,url1],sta,cha,ds,ds);
    urls1 = split(url,'?');
    urls2 = split(urls1{2},'&starttime');    
    fprintf('Downloading %s/%s/%s on %s from\n  %s?\n    %s\n    &starttime%s\n',...
        sta,cha,units,ds,urls1{1},urls2{1},urls2{2});

    try
        urlwrite(url,fname_original);
        fprintf('  Done.\n  Wrote %s\n', fname_original);
        failed = 0;
    catch
        fprintf('  Request failed for %s\n',url);
        failed = 1;
    end
    
    if failed == 1
        fid = fopen([fname_original,'.failed'],'w');
        fprintf('Download failed on %s. Writing .failed file.\n',datestr(now));
        fprintf(fid,'Download failed on %s. Writing .failed file.\n',datestr(now));
        fclose(fid);
        continue;
    end

end
