### Webradio import

To import Webradios, you can create a file `<radioname>.pls` and save it in `/mnt/MPD/Webradio`, using the following format
```sh
[playlist]
NumberOfEntries=1
File1=http://url/path
Title1=Pretty Name
```

If `Title` is defined inside the `.pls` file that value will be used, else we fall back to `filename`

