# Overview

The code in this repository can be used to download all of the electromagnetic time series data associated with a given site in the [IRIS EM network database](http://ds.iris.edu/mda/EM/) using the [IRIS DMC Web Service](http://service.iris.edu/irisws/). 

The list of sites may be obtained using `getCatalog.m`, which reads the output of http://service.iris.edu/irisws/fedcatalog/1/query?net=EM.

The main function in this repository is `getData.m` and the input is [a IRIS station ID](http://ds.iris.edu/mda/EM/). See `getData_demo.m` for example usage. 

Sample output for running this code is at http://mag.gmu.edu/git-data/IRIS-EM-download/. The `mat` files contain the return values of `time, data, and segments` for each channel.
