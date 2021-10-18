ALSAEqual
---

- Install:
	- `pacman -S alsaequal`
	- `/etc/asound.conf`
		- Normal
		```sh
		...
		pcm.!default {
			type plug;
			slave.pcm plugequal;
		}
		ctl.equal {
			type equal;
		}
		pcm.plugequal {
			type equal;
			slave.pcm "plughw:$CARD,0";
		}
		```
		- Bluetooth
		```sh
		...
		#pcm.!default {
		#	type plug;
		#	slave.pcm plugequal;
		#}
		#ctl.equal {
		#	type equal;
		#}
		#pcm.plugequal {
		#	type equal;
			slave.pcm {
				type plug
				slave.pcm {
					type bluealsa;
					# 00:00:00:00:00:00 = latest connected device
					device "00:00:00:00:00:00";
					profile "a2dp";
					delay 20000;
				}
			}
		#}
		```
	- `/etc/mpd.conf`
	```
	...
	audio_output {
		name           "ALSAEqual"
		device         "plug:plugequal"
		type           "alsa"
		auto_resample  "no"
		mixer_type     "hardware"
	}
	```
	- Set user `mpd` permission to run command: `chsh -s /bin/bash mpd`

- Equalizer console: `sudo - mpd alsamixer -D equal`
- Command line:
	- Get: `sudo -u mpd amixer -D equal contents | awk -F ',' '/: val/ {print $NF}' | xargs`
	- Set: `sudo -u mpd amixer -D equal sset "BAND" N`
		- `BAND`: `00. 31 Hz`, `01. 63 Hz`, `02. 125 Hz`, `03. 250 Hz`, `04. 500 Hz`, `05. 1 kHz`, `06. 2 kHz`, `07. 4 kHz`, `08. 8 kHz`, `09. 16 kHz`
		- `N`: 0-100 (already mapped as %)
		- Flat (0dB): 60
