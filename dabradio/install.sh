#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

pacman -Sy --noconfirm dab-scanner
systemctl enable --now rtsp-simple-server
sed -i '/ffmpeg/ {n; s/".*"/"yes"/}' /etc/mpd.conf
/srv/http/bash/settings/player-conf.sh

installfinish

echo $info Scan DAB radio: Library update
