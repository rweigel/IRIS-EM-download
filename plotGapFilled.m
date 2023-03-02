function plotGapFilled(data, site, cha, days, units, dirout)

if nargin < 6
    % Dir of this script
    dirout = fullfile(fileparts(mfilename('fullpath')),'data'); 
end

time = days(1) + (0:size(data,1)-1)/86400;
plot(time,data);
title(sprintf('%s/%s',site,cha));
ylabel(units);
datetick();
xticks = cellstr(get(gca,'XTickLabel'));
xticks{1} = sprintf('%s\\newline%s',xticks{1},datestr(days(1),'yyyy'));
set(gca,'XTickLabel',xticks);

dsi = datestr(days(1),29);
dsf = datestr(days(end),29);

sub_dir_gapfilled   = fullfile(site,'gapfilled');
dir_gapfilled       = fullfile(dirout,sub_dir_gapfilled);
fname_out_base = sprintf('%s_%s_%s_through_%s-%s',site,cha,dsi,dsf,units);
fname_out      = fullfile(dir_gapfilled,fname_out_base);

fprintf('Writing %s/%s.png\n',sub_dir_gapfilled,fname_out)
print([fname_out,'.png'],'-dpng','-r300');