
catalog = getCatalog();

sites       = catalog(:,2);
instruments = catalog(:,4);
starts      = catalog(:,5);
stops       = catalog(:,6);

% Find all rows associated with a given site.
I = strcmp('WYYS3',sites);

instruments(I)
starts(I)
stops(I)

