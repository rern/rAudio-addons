Monitor resolution
---
Fix wrong resolution after power off > on
```sh
### get monitor data file
# turn on monitor
tvservice -d /boot/edid.dat

### append data file
echo 'hdmi_edid_file=1' >> /boot/config.txt
```
