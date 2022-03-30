CamillaDSP
---

[CamillaDSP](https://github.com/HEnquist/camilladsp)

- `/etc/systemd/system/camilladsp.service`
```service
[Unit]
Description=CamillaDSP Daemon
After=syslog.target
StartLimitIntervalSec=10
StartLimitBurst=10

[Service]
Type=simple
ExecStart=/usr/bin/camilladsp /etc/configfile.yml
Restart=always
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=camilladsp
User=root
Group=root
CPUSchedulingPolicy=fifo
CPUSchedulingPriority=10

[Install]
WantedBy=graphical.target
```

- `/etc/camilladsp.yml`
```yml
devices:
  samplerate: 44100
  buffersize: 2048
  silence_threshold: -60
  silence_timeout: 3.0

  capture:
    channels: 2
    device: hw:Loopback,0
    format: S32LE
    type: Alsa

  playback:
    channels: 2
    device: hw:0,0
    format: S16LE
    type: Alsa

filters:
  volume:
    parameters:
      ramp_time: 200
    type: Volume
mixers:
  2x2:
    channels:
      in: 2
      out: 2
    mapping:
    - dest: 0
      mute: false
      sources:
      - channel: 0
        gain: 0
        inverted: false
        mute: false
    - dest: 1
      mute: false
      sources:
      - channel: 1
        gain: 0
        inverted: false
        mute: false
pipeline:
- name: 2x2
  type: Mixer
- channel: 0
  names:
  - volume
  type: Filter
- channel: 1
  names:
  - volume
  type: Filter
```

- `/etc/asound.conf`
```conf
pcm.!default { 
   type plug 
   slave.pcm camilladsp
}
pcm.camilladsp {
	slave {
		pcm {
			type     hw
			card     Loopback
			device   0
			channels 2
			format   S16_LE  # (on-board) SL24_LE, SL24_LE3, S32LE, FLOAT32LE, FLOAT64LE
			rate     44100
		}
	}
}
ctl.!default {
	type hw
	card Loopback
}
ctl.camilladsp {
	type hw
	card Loopback
}
```
