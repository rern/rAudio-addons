#!/bin/bash

alias=cami

getVersion() {
	user=HEnquist
	repo=$1
	version=$( curl -I https://github.com/$user/$repo/releases/latest \
				| awk -F'/' '/^location/ {print $NF}' \
				| sed 's/[^v.0-9]//g' )
}

pacman -Sy --needed --noconfirm python-aiohttp python-jsonschema python-matplotlib python-numpy python-pip python-websocket python-websocket-client unzip

### gui
getVersion pycamilladsp
pip install git+https://github.com/HEnquist/pycamilladsp.git@$version
getVersion pycamilladsp-plot
pip install git+https://github.com/HEnquist/pycamilladsp-plot.git@$version
getVersion camillagui-backend
wget https://github.com/HEnquist/camillagui-backend/releases/download/$version/camillagui.zip
dircamilladsp=/srv/http/data/system/camilladsp
dircamillagui=/srv/http/camillagui
unzip camillagui -d $dircamillagui
rm camillagui.zip
# allow symlink
sed -i 's/"build")$/"build", follow_symlinks=True)/' /srv/http/settings/camillagui/backend/routes.py
ln -s /srv/http/{,settings/camillagui/build/static/}assets
# config
cat << EOF > $dircamillagui/config/camillagui.yml
---
camilla_host: "0.0.0.0"
camilla_port: 1234
port: 5005
config_dir: "$dircamilladsp/configs"
coeff_dir: "$dircamilladsp/coeffs"
default_config: "$dircamilladsp/configs/default_config.yml"
active_config: "$dircamilladsp/configs/active_config.yml"
update_symlink: true
on_set_active_config: "/srv/http/bash/features.sh camilladspasound"
on_get_active_config: null
supported_capture_types: null
supported_playback_types: null
EOF

mkdir -p $dircamilladsp/{coeffs,configs}
cat << EOF > $dircamilladsp/configs/default_config.yml
---
devices:
  adjust_period: 10
  capture:
    avoid_blocking_read: false
    channels: 2
    device: hw:Loopback,0
    format: S32LE
    retry_on_error: false
    type: Alsa
  capture_samplerate: 0
  chunksize: 2048
  enable_rate_adjust: false
  enable_resampling: false
  playback:
    channels: 2
    device: hw:0,0
    format: S16LE
    type: Alsa
  queuelimit: 4
  rate_measure_interval: 1
  resampler_type: Synchronous
  samplerate: 44100
  silence_threshold: -60
  silence_timeout: 3
  stop_on_rate_change: false
  target_level: 0
filters:
  Volume:
    parameters:
      ramp_time: 200
    type: Volume
mixers: {}
pipeline:
- channel: 0
  names:
  - Volume
  type: Filter
- channel: 1
  names:
  - Volume
  type: Filter
EOF
cp $dircamilladsp/configs/{default_config,camilladsp}.yml
ln -sf $dircamilladsp/configs/{camilladsp,active_config}.yml

### binary
curl -L https://github.com/rern/rAudio-addons/raw/main/CamillaDSP/camilladsp.tar.xz | bsdtar xf - -C /usr/bin
chmod +x /usr/bin/camilladsp

### service
cat << EOF > /etc/systemd/system/camillagui.service
[Unit]
Description=CamillaDSP GUI

[Service]
Type=idle
ExecStart=/usr/bin/python /srv/http/settings/camillagui/main.py
EOF

cat << EOF > /etc/systemd/system/camilladsp.service
[Unit]
Description=CamillaDSP Daemon
StartLimitIntervalSec=10
StartLimitBurst=10

[Service]
Type=simple
ExecStart=/usr/bin/camilladsp --port 1234 /srv/http/data/camilladsp/configs/camilladsp.yml
Restart=always
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=camilladsp
CPUSchedulingPolicy=fifo
CPUSchedulingPriority=10
EOF

systemctl daemon-reload

echo "
CamillaDSP:
    systemctl start camilladsp
CamillaDSP GUI:
    systemctl start camillagui
    URL - http://IP_ADDRESS:5005
"
