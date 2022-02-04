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
# get interval - icy-metaint: 16000 (byte)
curl -v $URL -H 'icy-metadata: 1'

# get encoding - Transfer-Encoding: chunked
curl -v $URL -H 'icy-charset: 1'
```

- PHP Script (Bash curl not kill connection)
./[metadata.php](https://github.com/rern/rAudio-addons/blob/main/webradio/metadata.php) URL
