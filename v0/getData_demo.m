
station = 'VAQ58';

units = 'counts'; % or 'natural'.
% Requests units = 'natural' usually fail. See scale directory for obtaining
% scale conversion factors visually.

% Get rows of data/catalog.txt associated with site.
siteInfo = getSiteInfo(station); 

% Get channels and a list of days (in MATLAB datenum() format) that
% data are available for each channel.
channelDays = getChannelDays(siteInfo);

% Loop over channels
channelNames = fieldnames(channelDays);
for i = 1:length(channelNames)
    days = channelDays.(channelNames{i});

    % Download all data available on each day. Save in daily files.
    getData(station,cha,days,units);

    % Reformat daily files for easier reading in MATLAB.
    reformatData(station,channelNames{i},days,units);
end

% Plot gapfilled data
close all;
set(0,'DefaultFigureWindowStyle','normal');    
for i = 1:length(channelNames)
    days = channelDays.(channelNames{i});
    data = fillGaps(station, channelNames{i}, days, units);

    figure(i);clf;
    set(gcf,'Position',[1 1 900 300]);
    plotGapFilled(data, station, channelNames{i}, days, units);
end