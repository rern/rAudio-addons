#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

pacman -Sy --noconfirm dab-scanner

timeout 1 rtl_test -t &> /dev/null && systemctl enable --now rtsp-simple-server

installfinish
