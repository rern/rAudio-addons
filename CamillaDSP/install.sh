#!/usr/bin

getVersion() {
	user=HEnquist
	repo=$1
	version=$( curl -I https://github.com/$user/$repo/releases/latest \
				| awk -F'/' '/^location/ {print $NF}' \
				| sed 's/[^v.0-9]//g' )
}

### binary
wget https://github.com/rern/rAudio-addons/raw/main/CamillaDSP/camilladsp -P /usr/bin
chmod +x /usr/bin/camilladsp

### gui
# python libraries
getVersion pycamilladsp
pip install git+https://github.com/HEnquist/pycamilladsp.git@$version
getVersion pycamilladsp-plo
pip install git+https://github.com/HEnquist/pycamilladsp-plot.git@v0.6.2

getVersion camillagui-backend
wget https://github.com/HEnquist/camillagui-backend/releases/download/$version/camillagui.zip
dir=/srv/http/camillagui
unzip camillagui -d $dir
# fixes
mkdir $dir/coeffs
sed -i -e 's/configs/config/
' -e "s|~/camilladsp|$dir|
" $dir/config/camillagui.yml
cp $dir/{config/camillagui,active_config}.yml
cp $dir/{active,default}_config.yml

cat << EOF > /etc/camilladsp.yml
devices:
  samplerate: 44100
  buffersize: 2048
  silence_threshold: -60
  silence_timeout: 3.0

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
EOF

cat << EOF > /etc/systemd/system/camilladsp.service
[Unit]
Description=CamillaDSP Daemon
After=syslog.target
StartLimitIntervalSec=10
StartLimitBurst=10

[Service]
Type=simple
ExecStart=/usr/bin/camilladsp /etc/camilladsp.yml
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

cat << EOF > /etc/systemd/system/camilladsp.service
[Unit]
Description=CamillaDSP GUI
After=multi-user.target

[Service]
User=root
Type=idle
ExecStart=python /srv/http/camillagui/main.py

[Install]
WantedBy=multi-user.target
EOF