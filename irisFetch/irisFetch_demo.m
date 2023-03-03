% To use:
%
% 1. (Optional) Download a jar file at
%      https://github.com/iris-edu/iris-ws/releases
%    Then modify the version number in the javaaddpath argument.
%
% 2. (Optional) Get the most recent version of irisFetch.m from
%      http://ds.iris.edu/ds/nodes/dmc/software/downloads/irisFetch.m/
%     and unzip. Then modify the version number in the addpath argument.
%
% Note that the jar file is auto-updated when irisFetch() is called,
% itself, so an older version can be downloaded.

if ~exist('IRIS-WS-2.0.18.jar','file')
    % Download jar file.
    jarurl = 'https://github.com/iris-edu/iris-ws/r';
    jarurl = [jarurl, 'releases/download/2.0.18/IRIS-WS-2.0.18.jar'];
    websave('IRIS-WS-2.0.18.jar',jarurl);
end

addpath('irisFetch-matlab-2.0.12');
javaaddpath('IRIS-WS-2.0.18.jar');

if ~exist('mytrace','var')
    segments = irisFetch.Traces('EM','VAQ58','--','LQE',...
                '2016-06-10 00:00:00','2016-06-26 00:00:00');
end        

for s = 1:length(segments)
    % Display content. mytrace has elements of data segment on a uniform
    % time grid and with no gaps.
    segments(s)
end

data = [];
time = [];
for s = 1:length(segments)    
    fprintf('segment %d: %s to %s\n',s,...
        datestr(datevec(segments(s).startTime),31),...
        datestr(datevec(segments(s).endTime),31));
    % Segment data
    sdata = segments(s).data;
    % Does this convert to "natural" EM units? 
    % segments(s).sensitivityUnits is empty.
    sdata = sdata/segments(s).sensitivity;
    data = [data; sdata];
    % Segment time in fraction of day since start of segment.
    stime = [0:length(sdata)-1]'*(segments(s).sampleRate/86400);
    % Segment time as MATLAB datenum.
    stime = segments(s).startTime + stime;    
    time = [time; stime];
end

plot(time, data);
title('Units TBD');
datetick()