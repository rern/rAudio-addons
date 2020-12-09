#!/bin/bash

alias=aria

. /srv/http/bash/addons.sh

installstart "$1"

mnt=$( df --output=target | grep /mnt/MPD | tail -1 )
[[ -z $mnt ]] && title "$info No drive for download found." && exit
[[ ! -w $mnt ]] && title "$info $( tcolot "$mnt" ) has no write permission." && exit

getuninstall

[[ ! -e /usr/bin/aria2c ]] && pacman -Sy --noconfirm aria2

path=$mnt/aria2
mkdir -p $path/web

echo -e "$bar WebUI ..."
wgetnc https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf master.zip --strip 2 -C $path/web ./webui-aria2-master/docs
rm master.zip

ln -s $path/web /srv/http/aria2
# disable UI language feature
sed -i '/determinePreferredLanguage/ s|^|//|' /srv/http/aria2/app.js

mkdir -p /root/.config/aria2

file=/root/.config/aria2/aria2.conf
echo $file

cat << EOF > $file
enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
dir=$path
max-connection-per-server=4
EOF

file=/etc/systemd/system/aria2.service
echo $file

cat << 'EOF' > $file
[Unit]
Description=Aria2
After=network-online.target
[Service]
Type=forking
ExecStart=/usr/bin/aria2c
[Install]
WantedBy=multi-user.target
EOF

chmod 644 $file

systemctl daemon-reload

echo -e "$bar Start $title ..."
if ! systemctl enable --now aria2 &> /dev/null; then
	title -l = "$warn $title install failed."
	exit
fi

installfinish

title -nt "Download directory: $path"
