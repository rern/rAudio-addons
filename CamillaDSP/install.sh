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
getVersion pycamilladsp-plo
pip install git+https://github.com/HEnquist/pycamilladsp-plot.git@v0.6.2

getVersion camillagui-backend
wget https://github.com/HEnquist/camillagui-backend/releases/download/$version/camillagui.zip
dircamillagui=/srv/http/settings/camillagui
dircamilladsp=/srv/http/data/camilladsp
mkdir -p $dircamilladsp/{coeffs,configs}
unzip camillagui -d $dircamillagui
rm camillagui.zip

fileindex=$dircamillagui/build/index.html
sed -i 's/<script>/\n/' $fileindex
cat << 'EOF' | sed -i '1r /dev/stdin' $fileindex
<style>
body { padding-top: 40px; background: #000000; }
.head { position: fixed; top: 0; height: 40px; width: 100%; background: #313435; box-shadow: 0px 4px 10px #000000; }
.head img { position: absolute; width: 40px; height: 40px; }
.head span { margin-left: 55px; font-size: 26px; font-weight: 300; letter-spacing: 20px; }
#close { position: absolute; right: 16px; top: -12px; font-size: 40px; color: #0077b3; cursor: pointer; }
</style>
<div class="head"><img src="./static/media/icon.png"><span>CamillaDSP</span><div id="close">×</div></div>
<script>
document.getElementById('close').onclick = function() {
	var hostname = location.hostname;
	var http = new XMLHttpRequest();
	http.open('POST', 'http://'+ hostname +'/cmd.php', true);
	http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	http.send('cmd=bash&bash=systemctl%20stop%20camillagui');
	location.href = 'http://'+ hostname;
}
EOF

### binary
curl -L https://github.com/rern/rAudio-addons/raw/main/CamillaDSP/camilladsp.tar.xz | bsdtar xf - -C /usr/bin
chmod +x /usr/bin/camilladsp

### config
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

file=$dircamilladsp/configs/default_config.yml
if [[ ! -e $file ]]; then
	cat << EOF > $file
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
	ln -s $dircamilladsp/configs/{camilladsp,active_config}.yml
fi
chown -R http:http $dircamillagui $dircamilladsp

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
