ALSAEqual
---

- Install:
	- `pacman -S alsaequal`
	- `/etc/asound.conf`
	```
	...
	ctl.equal {
		type equal;
	}
	pcm.plugequal {
		type equal;
		slave.pcm "plug:dmix";
	}
	pcm.!default {
		type plug;
		slave.pcm plugequal;
	}
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
	- Set `su mpd` permission: `chsh -s /bin/bash mpd`

- Equalizer console: `su mpd -c 'alsamixer -D equal`
- Command line:
	- Set: `amixer -D equal sset 'BAND' N`
	- Get: `amixer -D equal sget 'BAND'`
	- `BAND`: `00. 31 Hz`, `01. 63 Hz`, `02. 125 Hz`, `03. 250 Hz`, `04. 500 Hz`, `05. 1 kHz`, `06. 2 kHz`, `07. 4 kHz`, `08. 8 kHz`, `09. 16 kHz`
	- `N`: 0-100 (already mapped as %)
