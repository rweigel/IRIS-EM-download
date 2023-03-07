function catalog = getCatalog(update)
% getCatalog - Returns IRIS EM catalog
%
%   catalog = getCatalog() downloads the text catalog file
%
%     http://service.iris.edu/irisws/fedcatalog/1/query?net=EM
%
%   and returns a cell array with columns that match the columns of the
%   text catalog file. 
%
%   The returned catalog is stored in catalog.mat and subsequent calls
%   return the content of this cached file.
%
%   catalog = getCatalog(1) forces catalog file to be updated.
%
%   See also getCatalog_demo.m

if (nargin == 0)
  update = false;
end

% TODO: Does this service have JSON output as an option?
url = 'http://service.iris.edu/irisws/fedcatalog/1/query?net=EM';

scriptDir = fullfile(fileparts(mfilename('fullpath'))); % Dir of this script
fnametxt  = fullfile(scriptDir,'data','catalog.txt');
fnamemat  = fullfile(scriptDir,'data','catalog.mat');

if ~exist(fnametxt,'file') || update
    fprintf('getCatalog: Getting %s\n', url);
    websave(fnametxt, url);
    fprintf('getCatalog: Wrote %s\n', fnametxt);
end

if ~exist(fnamemat,'file') || update
	i = 1;
	fid = fopen(fnametxt);
	while 1
        tline = fgetl(fid);
        if ~ischar(tline)
            % Skip empty line
            break;
        end
        %fprintf('%s\n',tline);
        if isempty(tline)
            % End of file
            continue;
        end
        % Split line on spaces
        tmp = strsplit(tline,' ');
        if strcmp('EM',tmp{1})
            for j = 1:6
                catalog{i,j} = tmp{j};
            end
            i = i + 1;
        end
	end
	fclose(fid);
    fprintf('getCatalog: Catalog has %d sites\n', length(unique(catalog(:,2))));
    fprintf('getCatalog: Writing %s\n', fnamemat);
	save(fnamemat, 'catalog');
    fprintf('getCatalog: Wrote %s\n', fnamemat);    
else
	load(fnamemat, 'catalog');
end