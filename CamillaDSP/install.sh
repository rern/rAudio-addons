#!/bin/bash

alias=cami

getVersion() {
	user=HEnquist
	repo=$1
	version=$( curl -I https://github.com/$user/$repo/releases/latest \
				| awk -F'/' '/^location/ {print $NF}' \
				| sed 's/[^v.0-9]//g' )
}

pacman -Sy --needed --noconfirm python-aiohttp python-jsonschema python-matplotlib python-numpy python-pip python-websocket-client unzip

### gui
getVersion pycamilladsp
pip install git+https://github.com/HEnquist/pycamilladsp.git@$version
getVersion pycamilladsp-plo
pip install git+https://github.com/HEnquist/pycamilladsp-plot.git@v0.6.2

getVersion camillagui-backend
wget https://github.com/HEnquist/camillagui-backend/releases/download/$version/camillagui.zip
dircamillagui=/srv/http/camillagui
unzip camillagui -d $dircamillagui
rm camillagui.zip

### binary
curl -L https://github.com/rern/rAudio-addons/raw/main/CamillaDSP/camilladsp.tar.xz | bsdtar xf - -C /usr/bin
chmod +x /usr/bin/camilladsp

### config
cat << EOF > $dircamillagui/config/camillagui.yml
---
camilla_host: "0.0.0.0"
camilla_port: 1234
port: 5005
config_dir: "/srv/http/data/camilladsp/configs"
coeff_dir: "/srv/http/data/camilladsp/coeffs"
default_config: "/srv/http/camillagui/default_config.yml"
active_config: "/srv/http/camillagui/active_config.yml"
update_symlink: true
on_set_active_config: "/srv/http/bash/features.sh camilladspasound"
on_get_active_config: null
supported_capture_types: null
supported_playback_types: null
EOF

mkdir -p /srv/http/data/camilladsp/{coeffs,configs}
file=/srv/http/data/camilladsp/configs/camilladsp.yml
[[ ! -e $file ]] && cat << EOF > $file
---
devices:
  samplerate: 44100
  chunksize: 1024

  capture:
    type: Alsa
    channels: 2
    device: hw:Loopback,0
    format: S32LE

  playback:
    type: Alsa
    channels: 2
    device: hw:0,0
    format: S16LE

filters:
  New Filter 1:
    parameters:
      ramp_time: 200
    type: Volume

EOF

ln -sf $file /srv/http/camillagui/active_config.yml
chown -R http:http $dircamillagui

### service
cat << EOF > /etc/systemd/system/camillagui.service
[Unit]
Description=CamillaDSP GUI
After=multi-user.target

[Service]
User=root
Type=idle
ExecStart=/usr/bin/python /srv/http/camillagui/main.py

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /etc/systemd/system/camilladsp.service
[Unit]
Description=CamillaDSP Daemon
After=syslog.target
StartLimitIntervalSec=10
StartLimitBurst=10

[Service]
Type=simple
ExecStart=/usr/bin/camilladsp /srv/http/camillagui/configs/camilladsp.yml
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
EOF

systemctl daemon-reload
