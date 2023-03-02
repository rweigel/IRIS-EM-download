function data = fillGaps(sta,cha,days,units,dirout)
%FILLGAPS
%
%   data = fillGaps(site,cha,days,units)
%
%   For each channel cha, read reformatted files for site between days(1)
%   and days(end). Return data that are on a 1-second time grid with NaNs
%   where no data were available.

% TODO: Put a check here to see if gap is too large.

if nargin < 5
    % Dir of this script
    dirout = fullfile(fileparts(mfilename('fullpath')),'data'); 
end
if ~exist(dirout,'dir')
    mkdir(dirout);
end

sub_dir_reformatted = fullfile(sta,'reformatted');
dir_reformatted     = fullfile(dirout,sub_dir_reformatted);
sub_dir_gapfilled   = fullfile(sta,'gapfilled');
dir_gapfilled       = fullfile(dirout,sub_dir_gapfilled);

if ~exist(dir_gapfilled,'dir')
  mkdir(dir_gapfilled);
end

dsi = datestr(days(1),29);
dsf = datestr(days(end),29);

fname_out_base = sprintf('%s_%s_%s_through_%s-%s',sta,cha,dsi,dsf,units);
fname_out = fullfile(dir_gapfilled,fname_out_base);

if exist([fname_out,'.mat'],'file')
    fprintf('Found %s/%s.mat. Not re-creating\n',dir_gapfilled,fname_out_base);
    load(fname_out);
    return
end

dataf = [];
for day = days(1):days(end)

  	di = NaN(86400,1);
    ds = datestr(day,29);
    fname_reformatted_base = sprintf('%s_%s_%s-%s.mat',sta,cha,ds,units);
    fname_reformatted = fullfile(dir_reformatted,fname_reformatted_base);
	
	if ~exist(fname_reformatted,'file')
        fprintf('Using fills for %s because no file found named %s/%s.mat\n',...
            ds,sub_dir_reformatted,fname_reformatted_base);
    else
	    fprintf('Reading %s/%s.mat. ',...
            sub_dir_reformatted,fname_reformatted_base);
	    file = load(fname_reformatted);
        data = file.data;
        dnx = datenum(data(:,1:3));
	    I = find(dnx == day);
        if length(I) ~= size(data,1)
            warning('File contains data from wrong day. Keeping only data from day associated with file name.');
        end
	    data = data(I,:);
	    % 1 + second of day
	    m = floor(data(:,6));
	    s = (data(:,6) - m)*60;
	    if ~all(s == 0)
            fprintf('\n\nWarning: Sub-second data in file.\n');
            fprintf('  Rounding to nearest second.\n');
            fprintf('  Using last value when multiple records have\n');
            fprintf('  same second value.\n\n');
	    end
	    t = 1 + data(:,4)*60*60 + data(:,5)*60 + m;
	    % data column
	    d = data(:,7);
	    % Fill array
	    % Replace fill with valid points.
	    di(t) = d;
	    fprintf('%d values.\n',length(t));
    end
    dataf = [dataf;di];
end

data = dataf;
fprintf('Writing %s/%s.mat.\n',sub_dir_gapfilled,fname_out_base);
save([fname_out,'.mat'],'data');

fprintf('Writing %s/%s.dat\n',sub_dir_gapfilled,fname_out_base);
fid = fopen([fname_out,'.dat'],'w');
fprintf(fid,'%d\n',data);
fclose(fid);
