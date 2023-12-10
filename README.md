# Overview

The code in this repository can be used to download all of the electromagnetic time series data associated with a given site in the [IRIS EM network database](http://ds.iris.edu/mda/EM/) using the [IRIS DMC Web Service](http://service.iris.edu/irisws/).

The list of sites may be obtained using `getCatalog.m`, which reads the output of http://service.iris.edu/irisws/fedcatalog/1/query?net=EM.

The main function in this repository is `getData.m`, which takes an input of a [a IRIS station ID](http://ds.iris.edu/mda/EM/), a channel string and start/stop times. See `getData_demo.m` for example usage. `getData.m` is a wrapper to the `irisFetch.m` function in the directory `irisFetch`.

Sample output for running this code is at http://mag.gmu.edu/git-data/IRIS-EM-download/. 

The directory `v0` contains code that does not use the `irisFetch` MATLAB client and was developed before this client was available (or known of).