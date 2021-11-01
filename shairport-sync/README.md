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

hex2bin() {
	sed 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' <<< $1 | xargs printf
}

# STRING values
<type> <code>                = hex2bin $STRING
<data encoding="base64">     = base64 -d <<< $STRING
                               PHP: base64_decode( $DATA )
                               JS:  atob( DATA )
<code>50494354</code> - PICT = file:   base64 -d <<< $STRING > coverart.jpg
                               string: data:image/jpeg;base64,$STRING
time (unit: 41000/second)    = $(( value / 41000 ))

# <type>
636f7265  core    AirPlay
73736e63  ssnc    Shairport-sync

----------------------------------------------------------------------------------
hex       code    field           decoded value - example : format
----------------------------------------------------------------------------------
70766f6c  pvol    volume          -24.78,24.08,0.00,60.00 : airplay,current,limitH,limitL
70626567  pbeg    [play begin]				 
          mdst    [data start]    1056687241
6173616c  asal    Album
61736172  asar    Artist
          ascm    Comment
          ascp    Composer
6173676e  asgn    Genre
          asdt    filetype
6d696e6d  minm    Title
          assn    sort as
          mden    [data end]      1056687241
          mdst    [data start]    1056687241
50494354  PICT    coverart
          mden    [adata end]     1056687241
70726772  prgr    progress        1056674953/1056687241/1072515673 : start/current/end
70656e64  pend    [play end]
```

**`shairport-sync-metadata-reader`**
```sh
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport-sync-metadata-reader -P /usr/local/bin
chmod 755 /usr/local/bin/shairport-sync-metadata-reader

shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```
