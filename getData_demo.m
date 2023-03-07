station = 'VAQ58';

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

    [time,data,segments,fname] = getData(station, uchannels{c}, start, stop);

    Ns = length(segments) + 1;
    figure();orient tall;
    for s = 1:length(segments)
        subplot(Ns, 1, s);
        plot(segments(s).data);
        th = '';
        if s == 1
            th = sprintf('%s/%s\n',station,uchannels{c});
        end
        title(sprintf('%sSegment %d %s to %s',th,s,...
                datestr(segments(s).startTime,'yyyy-mm-ddTHH:MM:SS'),...
                datestr(segments(s).endTime,'yyyy-mm-ddTHH:MM:SS')));
        xlabel('Sample number');
    end
    
    % Interpolate onto a uniform time grid with dt = min time difference
    timei = [floor(time(1)):min(diff(time)):time(end)];
    datai = interp1(time,data,timei);

    subplot(length(segments) + 1, 1, s+1);
        plot(timei,datai);
        title(sprintf('All Segments',station,uchannels{c}));
        datetick();
    print([fname,'.pdf'], '-dpdf');
    print([fname,'.png'], '-dpng','-r300');
    fprintf('Wrote %s.{pdf,png\n',fname);
end


