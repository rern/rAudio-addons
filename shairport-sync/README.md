### Shairport Sync
[Shairport Sync](https://github.com/mikebrady/shairport-sync) - AirPlay audio player. Shairport Sync adds multi-room capability with Audio Synchronisation

[Shairport Sync Metadata](https://github.com/mikebrady/shairport-sync-metadata-reader)

**Note**
```
# fix if needed - Failed to determine user credentials: No such process
systemctl daemon-reexec
```

**Metadata**
```sh
# data from fifo / named pipe
cat /tmp/shairport-sync-metadata

...
<item><type>636f7265</type><code>6173616c</code><length>18</length>
<data encoding="base64">
U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
...

# <type>
--------------------------------------
hex       hex2bin by
--------------------------------------
636f7265  core    AirPlay data
73736e63  ssnc    Shairport-sync data

# order (time unit @44100 / second)
----------------------------------------------------------------------------------
hex2bin field
----------------------------------------------------------------------------------
pvol    volume         (-24.78,24.08,0.00,60.00 : airplay,current,limitH,limitL)
mdst    metadata start (1056687241)
asal    Album
asar    Artist
        Comment
        Composer
        Genre
        filetype
minm    Title
        sort
mden    metadata end   (1056687241)
mdst    metadata start (1056687241)
PICT    coverart
mden    metadata end   (1056687241)
prgr    progress       (1056674953/1056687241/1072515673 : start/elapsed/end

----------------------------------------------------------------------------------------------------------------
hex       hex2bin field              base64 decode - PHP / JS
----------------------------------------------------------------------------------------------------------------
6173616c  asal    Album              base64_decode( $DATA ) / atob( DATA )
61736172  asar    Artist             base64_decode( $DATA ) / atob( DATA )
50494354  PICT    coverart           "data:image/jpeg;base64,$DATA" // already base64
70726772  prgr    elapsed/start/end  base64_decode( $DATA ) / atob( DATA )
6d696e6d  minm    Title              base64_decode( $DATA ) / atob( DATA )
70766f6c  pvol    volume             base64_decode( $DATA ) / atob( DATA )
```

**`shairport-sync-metadata-reader`**
```sh
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport-sync-metadata-reader -P /usr/local/bin
chmod 755 /usr/local/bin/shairport-sync-metadata-reader

shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```
