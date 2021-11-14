## kid3-cli 

[**Kid3**](https://kid3.sourceforge.io/)
```sh
# all format by common tag names
# escape double quotes for arguments with spaces

# set tags
kid3-cli -c "select \"$FILE\"" \
 	 -c "set artist \"$ARTIST\"" \
	 -c "set picture:\"$IMAGE_FILE\""
	
# get tags
kid3-cli -c "select \"$FILE\"" \
	 -c "get artist" \
	 -c "get picture:\"$IMAGE_DEST\""
	 
# run with systemd - MUST cd > select > get
kid3-cli -c "cd \"$DIR\"" \
	 -c "select \"$FILE\"" \
	 -c "get picture:\"$IMAGE_DEST\""
	
# remove tags
kid3-cli -c "select \"$FILE\"" \
	 -c 'remove artist' \

# remove ID3v1
kid3-cli -c "select \"$FILE\"" \
	 -c 'remove 1' \ 
```

[**Tag Mapping**](https://kid3.sourceforge.io/kid3_en.html#table-frame-list)

| Kid3        | Vorbis(FLAC)           | ID3v2  | RIFF(WAV) |
|:----------- | :--------------------- | :---   | :-------- |
| artist      | ARTIST                 | TPE1   | IART      |
| album       | ALBUM                  | TALB   | IPRD      |
| albumartist | ALBUMARTIST            | TPE2   |           |
| composer    | COMPOSER               | TCOM   | IMUS      |
| genre       | GENRE                  | TCON   | IGNR      |
| lyrics      | LYRICS                 | USLT   |           |
| title       | TITLE                  | TIT2   | INAM      |
| tracknumber | TRACKNUMBER            | TRCK   | IPRT      |
| picture     | METADATA_BLOCK_PICTURE | APIC   | APIC      |

`METADATA_BLOCK_PICTURE` - Vorbis comments 
