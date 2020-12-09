Webradio import / export
---
_Tested on RuneAudio 0.3 and 0.4b_

- Webradio needs files and database data together to make the list.
- This script can import either `*.pls`(single or multiple items per file) or `*.m3u`
- Files can be in sub-directories
- Redundant names will be incremented as `name_N`

**webradio `<filename>.pls` file syntax:**    
`Radio name` in Webradio list = filename  
```sh
[playlist]
NumberOfEntries=1
File1=http://url/path
Title1=filename
```

**import files to database**  
- copy webradio  `*.pls`, `*.m3u` files to `/mnt/MPD/Webradio/`  
- run import script:
	- delete webradio database
	- get data from `*.pls` and `*.m3u` files
	- create individual `*.pls` files
	- delete source files
	- write data to database
	- update MPD data
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiodb.sh; chmod +x webradiodb.sh; ./webradiodb.sh
```
**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons) 
  
  
**export database to file**
- copy `rune.rdb` backup files to `/var/lib/redis/`  
- run export script
	- get data from database
	- write data to `*.pls` files
	- update MPD data
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiofile.sh; chmod +x webradiofile.sh; ./webradiofile.sh
``` 
