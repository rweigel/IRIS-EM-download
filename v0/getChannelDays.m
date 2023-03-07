function channels = getChannelDays(siteinfo)

chas = siteinfo(:,1);
uchas = unique(chas);
channels = struct();
for c = 1:length(uchas)
    % Find all rows with common instrument values. When there is more
    % than one row, it means there are more than one segment of data.
    Is = find(strcmp(uchas(c),chas) == 1);
    channels.(uchas{c}) = 1;
    days = [];
    for seg = 1:length(Is)
        start = siteinfo{Is(seg),2};
        stop  = siteinfo{Is(seg),3};
        startdn(seg) = datenum(start(1:10));
        stopdn(seg) = datenum(stop(1:10));
        days = [startdn(seg):stopdn(seg),days];
    end
    channels.(uchas{c}) = unique(days);
end

