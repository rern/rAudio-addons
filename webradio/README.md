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
# get data format: 
#    - icy-metaint    - metadata send interval in byte
#    - ice-audio-info - audio format
curl -v $URL -H 'icy-metadata: 1'

> GET /m/rsc_de/aacp_96 HTTP/1.1
> Host: stream.srg-ssr.ch
> User-Agent: curl/7.81.0
> Accept: */*
> icy-metadata: 1
>
* Mark bundle as not supporting multiuse
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Content-Type: audio/aac
< Date: Fri, 04 Feb 2022 02:11:45 GMT
< icy-br:96
< ice-audio-info: bitrate=96
< icy-br:96
< icy-description:SwissClassic_AAC@96Kbps
< icy-genre:Entertainment
< icy-mimetype:audio/aac
< icy-name:/SwissClassic_Room2.aac
< icy-pub:0
< icy-url:www.srgssr.ch
< Server: Icecast 2.4.0-kh10
< Cache-Control: no-cache, no-store
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Headers: Origin, Accept, X-Requested-With, Content-Type
< Access-Control-Allow-Methods: GET, OPTIONS, HEAD
< Expires: Mon, 26 Jul 1997 05:00:00 GMT
< icy-metaint:16000
< Connection: close
```

- PHP Script (Bash curl not close connection)
./[metadata.php](https://github.com/rern/rAudio-addons/blob/main/webradio/metadata.php) URL
