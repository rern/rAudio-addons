## Radio Paradise 

### Streams
- Main Mix - http://stream.radioparadise.com/flacm
- Mellow Mix - http://stream.radioparadise.com/mellow-flacm
- Rock Mix - http://stream.radioparadise.com/rock-flacm
- World/Etc Mix - http://stream.radioparadise.com/world-etc-flacm

### Metadata API 
```sh
# 0: Main Mix; 1: Mellow Mix; 2: Rock Mix; 3: World Mix
n=0
https://api.radioparadise.com/api/now_playing?chan=$n

# {"time":secondsLeft,"artist":"Artist","title":"TiTle","album":"Album","year":"Year","cover":"URL"}
```
