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

# STRING values
<type> <code>                = hex2bin -i <<< $STRING
<data encoding="base64">     = base64 -d <<< $STRING ( PHP: base64_decode( $DATA ); JS: atob( DATA ) )
<code>50494354</code> - PICT = data:image/jpeg;base64,$STRING
prgr time value @ 41000/s    = $(( ( $value * 20500 ) / 41000 ))

# <type>
636f7265  core    AirPlay
73736e63  ssnc    Shairport-sync

----------------------------------------------------------------------------------
hex       code    field          decoded value
----------------------------------------------------------------------------------
70766f6c  pvol    volume         (-24.78,24.08,0.00,60.00 : airplay,current,limitH,limitL)

# each meatadata set (in order)					 
          mdst    metadata start (1056687241)
6173616c  asal    Album
61736172  asar    Artist
                  Comment
                  Composer
                  Genre
                  filetype
6d696e6d  minm    Title
          sort
          mden    metadata end   (1056687241)
          mdst    metadata start (1056687241)
50494354  PICT    coverart
          mden    metadata end   (1056687241)
70726772  prgr    progress       (1056674953/1056687241/1072515673 : start/elapsed/end
```

**`shairport-sync-metadata-reader`**
```sh
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport-sync-metadata-reader -P /usr/local/bin
chmod 755 /usr/local/bin/shairport-sync-metadata-reader

shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```
