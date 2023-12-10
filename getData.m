function [segments, fname] = getData(station, channel, start, stop)
%GETDATA
%
%   See getData_demo for example usage.

dirout = fullfile(fileparts(mfilename('fullpath')),'data');
dirout = fullfile(dirout,station);
fname = sprintf('%s-%s-%s_through_%s',station,channel,start(1:10),stop(1:10));
fname = fullfile(dirout,fname);

if exist([fname,'.mat'],'file')
    fprintf('Reading %s.mat\n',fname);
    load(fname);
    saveASCII_(segments,channel,fname);
    return;
end

% Dir of irisFetch code
dircode = fullfile(fileparts(mfilename('fullpath')),'irisFetch'); 

jar = 'IRIS-WS-2.20.1.jar';
if ~exist(fullfile(dircode,jar),'file')
    % Download jar file.
    jarurl = 'http://ds.iris.edu/files/IRIS-WS/2/2.20.1/';
    jarurl = [jarurl,jar];
    websave(jar,jarurl);
end

addpath(fullfile(dircode,'irisFetch-matlab-2.0.12'));
javaaddpath(fullfile(dircode,'IRIS-WS-2.0.18.jar'));

fprintf('getData: Requesting %s %s from %s to %s\n',station,channel,start,stop);
segments = irisFetch.Traces('EM',station,'--',channel,start,stop);

for s = 1:length(segments)
    % Display content. mytrace has elements of data segment on a uniform
    % time grid and with no gaps.
    %segments(s)
end

if ~exist(dirout,'dir')
    mkdir(dirout);
end

fname = sprintf('%s-%s-%s_through_%s',station,channel,start(1:10),stop(1:10));
fname = fullfile(dirout,fname);
save([fname,'.mat'],'segments');
fprintf('getData: Saved %s.mat\n',[fname,'.mat'])

saveASCII_(segments,channel,fname);

% Remove data from segments structure. Will print structure to JSON
% file without data.
for s = 1:length(segments)
    segmentsx(s) = rmfield(segments(s),'data');
end

addpath(fullfile(fileparts(mfilename('fullpath')),'m'));
jsonstr = prettyjson(jsonencode(segmentsx));

fid = fopen([fname,'.json'],'w');
fprintf(fid,jsonstr);
fclose(fid);
fprintf('getData: Saved %s\n',[fname,'.json']);
end

function saveASCII_(segments,channel,fname)
    [data, time] = catSegments(segments);

    fid = fopen([fname,'.txt'],'w');
    fprintf(fid,'year, month, day, hour, minute, second, %s\n',channel);
    if all(isinteger(data))
        fprintf(fid,'%d, %d, %d, %d, %d, %d, %d\n',[datevec(time),data]');
    else
        fprintf(fid,'%d, %d, %d, %d, %d, %d, %.16f\n',[datevec(time),data]');
    end
    fclose(fid);
    fprintf('getData: Saved %s.txt\n',[fname,'.mat'])
end
