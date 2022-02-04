### Webradio import
For importing webradio in format of:
```sh
[playlist]
NumberOfEntries=1
File1=http://url/path
Title1=filename
```

### Get metadata from stream
```sh
# get data format
curl -v $URL -H 'icy-metadata: 1'
#   - icy-metaint: 16000
#   - ice-audio-info: bitrate=96
```

- PHP Script (Bash curl not kill connection)
./[metadata.php](https://github.com/rern/rAudio-addons/blob/main/webradio/metadata.php) URL
