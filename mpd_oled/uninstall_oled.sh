#!/bin/bash

alias=oled

. /srv/http/bash/addons.sh

uninstallstart

systemctl disable --now mpd_oled
rm -v /usr/bin/mpd_oled* /etc/systemd/system/mpd_oled.service
systemctl daemon-reload

sed -i '/dtparam=i2c_arm=on/ d' /boot/config.txt
sed -i '/i2c-dev/ d' /etc/modules-load.d/raspberrypi.conf

uninstallfinish
