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
	 -c 'set title "TITLE"' \
	 -c 'set tracknumber "TRACK"' \
	 -c 'set picture:/path/source'
	
# get tags
kid3-cli -c "select \"/path/to file\"" \
	 -c 'get artist' \
	 -c 'get picture:/path/destination'
	
# remove tags
kid3-cli -c "select \"/path/to file\"" \
	 -c 'remove artist' \
	 -c 'remove picture' \
	 -c 'remove 1' \ # remove ID3v1
```

[**Tag Mapping**](https://kid3.sourceforge.io/kid3_en.html#table-frame-list)

| FLAC                   | ID3v2  | RIFF | Kid3 name   |
| ---------------------- | ----   | ---- | ----------- |
| ARTIST                 | TPE1   | IART | artist      
| ALBUM                  | TALB   | IPRD | album       |
| ALBUMARTIST            | TPE2   |      | albumartist |
| COMPOSER               | TCOM   | IMUS | composer    |
| GENRE                  | TCON   | IGNR | genre       |
| TITLE                  | TIT2   | INAM | title       |
| TRACKNUMBER            | TRCK   | IPRT | tracknumber |
| METADATA_BLOCK_PICTURE | APIC   | APIC | picture     |

`METADATA_BLOCK_PICTURE` - Vorbis comments  
`*.wav` files use RIFF  

**Build**
```sh
pacman -Syu
pacman -S --needed  base-devel chromaprint extra-cmake-modules id3lib libmp4v2 ninja python qt5-multimedia qt5-tools docbook-xsl taglib

# kid3-cli ninja not support distcc
# RPi Zero - compile on Docker

su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/kid3-cli.tar.gz | bsdtar xf -
cd kid3-cli
makepkg -A
```
