function [data, time] = catSegments(segments)

data = [];
time = [];
for s = 1:length(segments)    
    % Segment data
    sdata = segments(s).data;
    data = [data; sdata];

    % Segment time in fraction of day since start of segment.
    stime = [0:length(sdata)-1]'*(segments(s).sampleRate/86400);

    % Segment time as MATLAB datenum.
    stime = segments(s).startTime + stime;    
    time = [time; stime];
end