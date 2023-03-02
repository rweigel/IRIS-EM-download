
The code in this repository can be used to download all of the EM time series data associated with a given site in the IRIS database suing the [IRIS DMC Web Service](http://service.iris.edu/irisws/). The list of sites may be obtained using `getCatalog.m`, which reads the output of http://service.iris.edu/irisws/fedcatalog/1/query?net=EM.

The main function in this repository is `getData.m` and the input is the IRIS site ID. See `getData_demo.m` for example usage. 

Sample output for running this code is at http://mag.gmu.edu/git-data/IRIS-EM-download/data.

For each channel available from a site, `getData_demo.m`

1. requests data over a 1-day time range on each day that there are data available. The associated data are stored in `data/SITEID/original`;

2. reads each file in `data/SITEID/original` and write in a format that is faster to read with MATLAB. The associated files are stored in `data/SITEID/reformatted`;

3. reads all reformatted files and places data on a 1-second time grid by filling data gaps with `NaNs`. A single file is then written with data that spans all days of available data. The files are stored in `data/SITEID/gapfilled`; and

4. plots the contents of the gap filled data. The plots are stored in `data/SITEID/gapfilled`.
