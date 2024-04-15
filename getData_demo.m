station = 'VAQ58';
% https://service.iris.edu/irisws/timeseries/docs/1/builder/
% https://service.iris.edu/irisws/timeseries/1/query?net=EM&sta=VAQ58&cha=LQN&start=2016-06-10T18:19:06&end=2016-06-25T15:46:02&format=plot&loc=--
% https://service.iris.edu/irisws/timeseries/1/query?net=EM&sta=VAQ58&cha=LQE&start=2016-06-10T18:19:06&end=2016-06-25T15:46:02&format=plot&loc=--
% https://service.iris.edu/irisws/timeseries/1/query?net=EM&sta=VAQ58&cha=LQN&start=2016-06-10T18:19:06&end=2016-06-25T15:46:02&format=geocsv.tspair&loc=--
% https://service.iris.edu/irisws/timeseries/1/query?net=EM&sta=VAQ58&cha=LQE&start=2016-06-10T18:19:06&end=2016-06-25T15:46:02&format=geocsv.tspair&loc=--

%station = 'ORF03';
%station = 'RET54';

%station = 'KSR29';
%station = 'ORG03';

% Get rows of data/catalog.txt associated with station.
siteInfo = getSiteInfo(station);

channels = siteInfo(:,1);

% Get unique channels
uchannels = unique(channels);

close all;
for c = 1:length(uchannels)

    % Find rows associated with channel
    I = strmatch(uchannels{c},channels);

    % Get earliest start date for channel
    starts = siteInfo(I,2);
    startdns = datenum(datevec(siteInfo(I,2),'yyyy-mm-ddTHH:MM:SS'));
    startdns = sort(startdns);
    start = datestr(startdns(1),'yyyy-mm-dd HH:MM:SS');

    % Get latest stop date for channel
    stops = siteInfo(I,3);
    stopdns = datenum(datevec(siteInfo(I,3),'yyyy-mm-ddTHH:MM:SS'));
    stopdns = sort(stopdns);
    stop = datestr(stopdns(end),'yyyy-mm-dd HH:MM:SS');

    [segments,fname] = getData(station, uchannels{c}, start, stop);

    % Add dataScaled and dataScaledUnits to each segment structure,
    % if possible.
    segments = counts2physical(segments,1);
    save([fname,'.mat'],'segments');
    fprintf('getData_demo: Saved %s\n',[fname,'.mat'])

    figure();orient tall;
    for s = 1:length(segments)
        subplot(length(segments), 1, s);
        if isfield(segments(s),'dataScaled')
            plot(segments(s).dataScaled);
        else
            plot(segments(s).data);
        end
        th = '';
        if s == 1
            th = sprintf('%s/%s\n',station,uchannels{c});
        end
        title(sprintf('%sSegment %d %s to %s',th,s,...
                datestr(segments(s).startTime,'yyyy-mm-ddTHH:MM:SS'),...
                datestr(segments(s).endTime,'yyyy-mm-ddTHH:MM:SS')));
        xlabel('Sample number');

        % Units of 'counts' based on plots from web service. See
        % directory v0/scale for example plots.
        if isfield(segments(s),'dataScaled')
            ylabel(segments(s).dataScaledUnits);
        else
            ylabel('Counts');
        end
    end
end
