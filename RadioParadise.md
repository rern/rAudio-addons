### Radio Paradise API 

- Main Mix     - `chan=0` : `http://stream.radioparadise.com/flac`
- Mellow Mix   - `chan=1` : `http://stream.radioparadise.com/mellow-flac`
- Rock Mix     - `chan=2` : `http://stream.radioparadise.com/rock-flac`
- Eclectic Mix - `chan=3` : `http://stream.radioparadise.com/eclectic-flac`

Note: `*-falcm`, streams with metadata, emit `playlist` and `player` every 5 seconds

**Now playing**
```sh
chan=CHANNEL
curl -s -m 5 -G \
	--data-urlencode "chan=$chan" \
	https://api.radioparadise.com/api/now_playing
```
- `artist`
- `title`
- `album`
- `cover`
- `time` - seconds to track change

**Playlist**
- FLAC - `bitrate=4`
- List - Not consistent on reload (cache issue?)
```sh
chan=CHANNEL
curl -s -m 5 -G \
	--data-urlencode "chan=$chan" \
	--data-urlencode "bitrate=4" \
	--data-urlencode "info=true" \
	https://api.radioparadise.com/api/get_block
```
- Track
```sh
chan=CHANNEL
event=TRACK_ID
curl -s -m 5 -G \
	--data-urlencode "bitrate=4" \
	--data-urlencode "info=true" \
	--data-urlencode "chan=$chan" \
	--data-urlencode "event=$event" \
	https://api.radioparadise.com/api/get_block
```
- `event` - track id from List
- `url` - url for play or skip track
`song."0"`
- `artist`
- `title`
- `album`
- `cover` - prefix `https://img.radioparadise.com/` needed
- `sched_time_millis` - start timestamp (ms)
- `duration` (ms)
- seconds to track change: ( `sched_time_millis` + `duration` ) / 1000 - `$( date +%s )`

Legacy now playing: http://radioparadise.com/xml/now.xml
