#!/bin/bash

. /srv/http/bash/settings/addons.sh

installstart $@

pacman -Sy --noconfirm dab-scanner

dir=/etc/systemd/system
echo "\
[Unit]
Description=DAB Radio metadata
Requires=mediamtx.service
After=mediamtx.service

[Service]
Type=simple
ExecStart=/srv/http/bash/status-dab.sh
" > $dir/dab.service

dir+=/mediamtx.service.d
mkdir -p $dir
echo "\
[Unit]
BindsTo=dab.service
" > $dir/override.conf
systemctl daemon-reload

installfinish
