#!/bin/bash

alias=cami

getVersion() {
	user=HEnquist
	repo=$1
	version=$( curl -I https://github.com/$user/$repo/releases/latest \
				| awk -F'/' '/^location/ {print $NF}' \
				| sed 's/[^v.0-9]//g' )
}

pacman -Sy --needed --noconfirm python-aiohttp python-jsonschema python-matplotlib python-numpy python-pip python-websocket python-websocket-client

### gui
getVersion pycamilladsp
pip install git+https://github.com/HEnquist/pycamilladsp.git@$version
getVersion pycamilladsp-plot
pip install git+https://github.com/HEnquist/pycamilladsp-plot.git@$version

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
