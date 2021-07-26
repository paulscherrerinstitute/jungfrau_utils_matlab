# jungfrau_utils_matlab
A matlab wrapper for jungfrau_utils

Once cloned, add the repository folder to matlab path, and execute the following line (replacing the path to python with your conda environment path where [jungfrau_utils](https://github.com/paulscherrerinstitute/jungfrau_utils) is installed):
```
>> pyenv("Version", "/das/work/pXX/pXXXXX/miniconda3/bin/python", "ExecutionMode", "OutOfProcess")
```
This configuration needs to be done only once, e.g. it survives matlab restarts.

After that a very similar syntax can be used to create a `File` object:
```
>> juf = jungfrau_utils.File('/path/to/file');
```

Any `jungfrau_utils` optional parameter can be provided as a comma-separated pair (in the matlab style), e.g.
```
>> juf = jungfrau_utils.File('/path/to/file', 'gain_file', '/path/to/gain/file', 'pedestal_file', '/path/to/pedestal/file', 'geometry', false);
```

A matlab-style indexing can be used to get reconstructed data:
```
>> juf(0);  % first image
>> juf(0:9);  % first 10 images
>> juf(:);  % all images
>> juf(end-9:end)  # last 10 imaged
>> juf(0:2:end);  # every second image
```

While a string index will return the corresponding metadata dataset:
```
>> juf('data')
>> juf('is_good_frame')
```

To get a mask, a similar to `jungfrau_utils` function can be called:
```
>> mask = juf.get_pixel_mask();
```

It is possible to modify reconstruction options also after the file object creation:
```
>> size(juf(0))
ans =
         514        1030

>> juf.gap_pixels = false;
>> size(juf(0))
ans =
         512        1024
```
