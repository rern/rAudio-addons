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

### `amixer`
```sh
card=$( head -1 /etc/asound.conf | tail -c 2 )
amixer -c $card scontents
```
```
Simple mixer control 'Mic',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 127
  Front Left: Capture 127 [100%] [0.00dB] [on]
  Front Right: Capture 127 [100%] [0.00dB] [on]
Simple mixer control 'Mic',1
  Capabilities: cvolume cvolume-joined cswitch cswitch-joined
  Capture channels: Mono
  Limits: Capture 0 - 127
  Mono: Capture 127 [100%] [0.00dB] [on]
Simple mixer control 'xCORE USB Audio 2.0 Output',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 127
  Mono:
  Front Left: Playback 127 [100%] [0.00dB] [on]
  Front Right: Playback 127 [100%] [0.00dB] [on]
Simple mixer control 'xCORE USB Audio 2.0 Output',1
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 127
  Mono: Playback 127 [100%] [0.00dB] [on]
```
