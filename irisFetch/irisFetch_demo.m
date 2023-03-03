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

if ~exists('IRIS-WS-2.0.18.jar','file')
    % Download jar file.
    jarurl = 'https://github.com/iris-edu/iris-ws/r';
    jarurl = [jarurl, 'releases/download/2.0.18/IRIS-WS-2.0.18.jar'];
    websave('IRIS-WS-2.0.18.jar',jarurl);
end

addpath('irisFetch-matlab-2.0.18');
javaaddpath('IRIS-WS-2.0.18.jar'); 

if 0
mytrace = irisFetch.Traces('EM','VAQ58','--','LQE',...
            '2016-06-10 00:00:00','2016-06-26 00:00:00');
end        

for i = 1:length(mytrace)
    mytrace(i)
end