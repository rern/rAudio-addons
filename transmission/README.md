RuneAudio Transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  
- With optional WebUI alternative: [Transmission Web Control](https://github.com/ronggang/transmission-web-control#introduction)  

**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)   

**settings**  
`/path/transmission/settings.json` must be edited after stop transmission  
`transmission-daemon -d` will not correctly show `settings.json`  

**auto start download**  
add torrent files to `/path/transmission/torrents` will auto start download  

[optional] **set specific client IP**  
- allow only IP
- nolimit > `"rpc-whitelist-enabled": false`
```
    ...
    "rpc-whitelist": "127.0.0.1,[IP1],[IP2]",
    "rpc-whitelist-enabled": true,
    ...
```

**create torrent file**  
```
transmission-create -p -o <file> -c "<comment>" -t "<url>"

# -p --private                 Allow this torrent to only be used with the specified tracker(s)
# -o --outfile   <file>        Save the generated .torrent to this filename
# -c --comment   <comment>     Add a comment
# -t --tracker   <url>         Add a tracker's announce URL
```
