#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

pacman -Sy --noconfirm dab-scanner inotify-tools
echo "\
[Unit]
Description=DAB Radio metadata

[Service]
Type=simple
ExecStart=/srv/http/bash/status-dab.sh
" > /etc/systemd/system/dab.service
systemctl daemon-reload

timeout 1 rtl_test -t &> /dev/null && systemctl enable --now rtsp-simple-server

installfinish
