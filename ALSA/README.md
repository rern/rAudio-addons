## ALSA

### List
```sh
# all cards
aplay -l

# card names
cat /proc/asound/cards

# device names
aplay -L
```

### Volume
```sh
alsamixer
```

### Devices
```sh
amixer -c $card scontrols

amixer -c $card scontents
```
