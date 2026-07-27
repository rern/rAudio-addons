#!/bin/bash

. /srv/http/bash/settings/addons.sh

installstart $@

pacman -Sy --noconfirm dab-scanner

file=/etc/systemd/system/dab.service
if [[ ! -e $file ]]; then
	echo "\
[Unit]
Description=DAB Radio metadata

[Service]
Type=simple
ExecStart=/srv/http/bash/status-dab.sh
" > $file
	systemctl daemon-reload
fi

installfinish
