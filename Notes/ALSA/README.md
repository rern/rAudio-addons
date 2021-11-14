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
- `set` - simple control (NAME)
- 0dB = 100% (don't use % - linear sale)
- ±NdB - logarithmic scale (1dB = 1 step in alsamixer)
```sh
# get 1st simple control
card=$( head -1 /etc/asound.conf | tail -c 2 )
control=$( amixer -c $card scontents \
			| grep -A1 ^Simple \
			| sed 's/^\s*Cap.*: /^/' \
			| tr -d '\n' \
			| sed 's/--/\n/g' \
			| grep pvolume \
			| head -1 \
			| cut -d"'" -f2 )

# get % level ('-M' map to alsamixer scale)
amixer -M -c $card sget "$control" \
		| awk -F'[%[]' '/%/ {print $2}' \
		| head -1
# set % level
amixer -M -c $card sset "$control" 50%

# set dB
amixer -c $card sset "$control" 0dB # 100%
amixer -c $card sset "$control" 0   # mute
amixer -c $card sset "$control" 1dB-
amixer -c $card sset "$control" 1dB+
```

`scontrols`
```sh
amixer -c $card scontrols # simple list
amixer -c $card scontents # simple details
```
```
Simple mixer control 'Mic',0
Simple mixer control 'Mic',1
Simple mixer control 'xCORE USB Audio 2.0 Output',0
Simple mixer control 'xCORE USB Audio 2.0 Output',1
```
`scontents`
- `pvolume` - playback device
- `cvolume` - capture device
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

`controls`
```sh
amixer -c $card controls # list
amixer -c $card contents # details
```
```
numid=12,iface=CARD,name='Keep Interface'
numid=7,iface=CARD,name='XMOS Internal Clock Validity'
numid=8,iface=MIXER,name='Mic Capture Switch'
numid=9,iface=MIXER,name='Mic Capture Switch',index=1
numid=10,iface=MIXER,name='Mic Capture Volume'
numid=11,iface=MIXER,name='Mic Capture Volume',index=1
numid=3,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Switch'
numid=4,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Switch',index=1
numid=5,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Volume'
numid=6,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Volume',index=1
numid=2,iface=PCM,name='Capture Channel Map'
numid=1,iface=PCM,name='Playback Channel Map'
```
`contents`
```
numid=12,iface=CARD,name='Keep Interface'
  ; type=BOOLEAN,access=rw------,values=1
  : values=off
numid=7,iface=CARD,name='XMOS Internal Clock Validity'
  ; type=BOOLEAN,access=r-------,values=1
  : values=on
numid=8,iface=MIXER,name='Mic Capture Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=9,iface=MIXER,name='Mic Capture Switch',index=1
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=10,iface=MIXER,name='Mic Capture Volume'
  ; type=INTEGER,access=rw---R--,values=2,min=0,max=127,step=0
  : values=127,127
  | dBminmax-min=-127.00dB,max=0.00dB
numid=11,iface=MIXER,name='Mic Capture Volume',index=1
  ; type=INTEGER,access=rw---R--,values=1,min=0,max=127,step=0
  : values=127
  | dBminmax-min=-127.00dB,max=0.00dB
numid=3,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=4,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Switch',index=1
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=5,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Volume'
  ; type=INTEGER,access=rw---R--,values=2,min=0,max=127,step=0
  : values=127,127
  | dBminmax-min=-127.00dB,max=0.00dB
numid=6,iface=MIXER,name='xCORE USB Audio 2.0 Output Playback Volume',index=1
  ; type=INTEGER,access=rw---R--,values=1,min=0,max=127,step=0
  : values=127
  | dBminmax-min=-127.00dB,max=0.00dB
numid=2,iface=PCM,name='Capture Channel Map'
  ; type=INTEGER,access=r----R--,values=2,min=0,max=36,step=0
  : values=0,0
  | container
    | chmap-fixed=FL,FR
numid=1,iface=PCM,name='Playback Channel Map'
  ; type=INTEGER,access=r----R--,values=2,min=0,max=36,step=0
  : values=3,4
  | container
    | chmap-fixed=FL,FR
```
