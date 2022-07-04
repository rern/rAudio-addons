#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

pacman -Sy --noconfirm dab-scanner
systemctl enable rtsp-simple-server

installfinish

echo $info Scan DAB radio: Library update
