rankmirrors.sh
---
_for ArchLinuxArm (tested on RuneAudio 0.3, 0.4b and 0.5)_  
  
Fix packages download errors:  
- get current `mirrorlist` from ArchLinuxArm source
- enable(uncomment) all mirror servers
- ranked by download speed and latency
- update mirrorlist file, **/etc/pacman.d/mirrorlist** (with original backup)

Remark:
- 2nd run in the same day might get the download file from ISP cache which results in same speed.

**Rank**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

or from SSH terminal
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh -P /usr/local/bin; chmod +x /usr/local/bin/rankmirrors.sh; rankmirrors.sh
```
