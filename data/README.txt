Cached output from execution of `getData_demo.m` in
https://github.com/rweigel/IRIS-EM-download.

The `mat` files contain the original data returned by `irisFetch` in a
structure named `segments`.

The `data` arrays contains concatenated segment data segments and the `time`
array is the time stamp associated with each element in the `data` array
(in MATLAB `datenum` format).

The `txt` files contain the content of `time` and `data`. The columns are 
year, month, day, hour, minute, channel_data.