function S = getSiteInfo(site)

catalog = getCatalog();

sites       = catalog(:,2);
instruments = catalog(:,4);
starts      = catalog(:,5);
stops       = catalog(:,6);

% Find all rows associated with given site.
I = strcmp(site,sites);

S(:,1) = instruments(I);
S(:,2) = starts(I);
S(:,3) = stops(I);
