## kid3-cli 

[**Kid3**](https://kid3.sourceforge.io/)
```sh
# all format by common tag names
# escape double quotes for arguments with spaces

# set tags
kid3-cli -c "select \"/path/to file\"" \
	 -c 'set artist "ARTIST"' \
	 -c 'set album "ALBUM"' \
	 -c 'set albumartist "ALBUMARTIST"' \
	 -c 'set composer "COMPOSER"' \
	 -c 'set genre "GENRE"' \
	 -c 'set lyrics "LYRICS"' \
	 -c 'set title "TITLE"' \
	 -c 'set tracknumber "TRACK"' \
	 -c 'set picture:/path/source'
	
# get tags
kid3-cli -c "select \"/path/to file\"" \
	 -c 'get artist' \
	 -c 'get picture:/path/destination'
	 
# run with systemd - MUST cd > select > get
kid3-cli -c "cd \"/path/to dir\"" \
	-c "select \"filename\"" \
	-c 'get picture:/path/destination'
	
# remove tags
kid3-cli -c "select \"/path/to file\"" \
	 -c 'remove artist' \
	 -c 'remove picture' \
	 -c 'remove 1' \ # remove ID3v1
```

[**Tag Mapping**](https://kid3.sourceforge.io/kid3_en.html#table-frame-list)

| Kid3        | Vorbis                 | ID3v2  | RIFF |
|------------ | ---------------------- | ----   | ---- |
| artist      | ARTIST                 | TPE1   | IART |
| album       | ALBUM                  | TALB   | IPRD |
| albumartist | ALBUMARTIST            | TPE2   |      |
| composer    | COMPOSER               | TCOM   | IMUS |
| genre       | GENRE                  | TCON   | IGNR |
| lyrics      | LYRICS                 | USLT   |      |
| title       | TITLE                  | TIT2   | INAM |
| tracknumber | TRACKNUMBER            | TRCK   | IPRT |
| picture     | METADATA_BLOCK_PICTURE | APIC   | APIC |

`METADATA_BLOCK_PICTURE` - Vorbis comments  
`*.wav` files use RIFF  
