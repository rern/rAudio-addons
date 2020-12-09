#!/bin/bash

# $pwd-password

alias=tran

# tmp
rm -rf /etc/systemd/system/transmission.service.d
sed -i 's|/etc/systemd/system/transmission.service.d|/usr/bin/transmission-cli|' /srv/http/index-body.php

. /srv/http/bash/addons.sh

mnt=$( df --output=target | grep /mnt/MPD | tail -1 )
[[ -z $mnt ]] && title "$info No drive for download found." && exit
[[ ! -w $mnt ]] && title "$info $( tcolot "$mnt" ) has no write permission." && exit

installstart "$1"

pwd=${args[0]}

getuninstall

[[ ! -e /usr/bin/transmission-cli ]] && pacman -Sy --noconfirm transmission-cli

path="$mnt/transmission"
if [[ ! -e "$path" ]]; then
	mkdir -p "$path"
	mkdir -p "$path/{incomplete,watch}"
fi
# custom systemd unit
systemctl disable --now transmission

cp /{usr/lib,etc}/systemd/system/transmission.service
sed -i -e 's/^\(User=\).*/\1root/
' -e "/^User/ a\
Environment=TRANSMISSION_HOME=$path
" -e '/ExecStart/ s|$| -g /mnt/MPD/USB/2TB/transmission|
' /etc/systemd/system/transmission.service

systemctl daemon-reload

file="$path/settings.json"
if [[ ! -e "$file" ]]; then
	# create new settings.json
	systemctl start transmission
	systemctl stop transmission
	
	sed -i -e 's|\("download-dir": "\).*|\1'"$path"'",|
	' -e 's|\("incomplete-dir": "\).*|\1'"$path"'/incomplete",|
	' -e 's|\("incomplete-dir-enabled": \).*|\1true,|
	' -e 's|\("rpc-whitelist-enabled": \).*|\1false,|
	' -e '/[^{},\{, \}]$/ s/$/, /
	' -e '/^}$/ i\
    "watch-dir": "'"$path"'/watch", \
    "watch-dir-enabled": true
	' $file
	# set password
	if [[ -n $pwd && $pwd != 0 ]]; then
		sed -i -e 's|\("rpc-authentication-required": \).*|\1true,|
		' -e 's|\("rpc-password": "\).*|\1'"$pwd"'",|
		' -e 's|\("rpc-username": "\).*|\1root",|
		' $file
	else
		sed -i 's|\("rpc-authentication-required": \).*|\1false,|' $file
	fi
else
	if [[ -n $pwd && $pwd != 0 ]]; then
		sed -i 's|\("rpc-password": "\).*|\1'"$pwd"'",|' $file
	else
		sed -i 's|\("rpc-authentication-required": \).*|\1false,|' $file
	fi
fi

# web ui alternative
echo -e "$bar Get WebUI alternative ..."
wgetnc https://github.com/ronggang/transmission-web-control/archive/master.zip

dirweb=/usr/share/transmission/web
mv $dirweb/index{,.original}.html
bsdtar --strip 2 --exclude '.*' --exclude '*.md' -C $dirweb -xf master.zip transmission-web-control-master/src
rm master.zip
chown -R root:root $dirweb

# set buffers
echo -e "$bar Set buffer size ..."
echo 'net.core.rmem_max = 16777216
net.core.wmem_max = 4194304' > /etc/sysctl.d/buffer.conf
sysctl --system

echo -e "$bar Start Transmission ..."
if ! systemctl enable --now transmission &> /dev/null; then
	title -l = "$warn Transmission install failed."
	exit
fi

installfinish

echo "Download directory: $path"
title -nt "User: root"
