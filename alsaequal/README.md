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

- Equalizer console: `su mpd -c 'alsamoxer -D equal`
