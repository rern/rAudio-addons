#!/bin/bash

. /srv/http/bash/settings/addons.sh

installstart $@

pacman -Sy --noconfirm dab-scanner

echo "\
[Unit]
Description=DAB Radio metadata

[Service]
Type=simple
ExecStart=/srv/http/bash/status-dab.sh
" > /etc/systemd/system/dab.service
systemctl daemon-reload

installfinish
