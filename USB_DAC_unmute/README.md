USB DAC Unmute
---
Fix mute USB DAC 

**amixer**
- `mute`, `unmute` with `Simple mixer control` names only
```sh
# cardnum list
aplay -l | grep '^card'

# name list - Simple mixer control
cardnum=1
amixer -c $cardnum scontrols
# unmute $name
amixer -c $cardnum sset "$name" unmute

# unmute all
cardnum=1
scontrols=$( amixer -c $cardnum scontents | grep -B1 'pvolume' | grep '^Simple' | awk -F"['']" '{print $2}' )
readarray -t mixers <<<"$scontrols"
for mixer in "${mixers[@]}"; do
	amixer -c $cardnum sset "$mixer" unmute
done

# amixer list - numid
amixer -c $cardnum controls

# master volume numid
numid=$( amixer -c $cardnum controls | grep "Playback Volume'$" | cut -d',' -f1 )

# set volume level 50%
amixer -c $cardnum cset $numid 50%
```
 
**ALSA mixer**  
```sh
alsamixer
```
![1](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/1.png)  

**Select Sound Device**  
`F6` select menu  
![2](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/2.png)  

**Setting**  
`MM` = mute  
![3](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/3.png)  

**Unmute**
- `M` toggles `MM` mute <-> `00` unmute  
- `left arrow` `right arrow` switches channel  
- `Esc` exit  

![4](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/4.png)  

**Save Setting**  
```sh
alsactl store
```
