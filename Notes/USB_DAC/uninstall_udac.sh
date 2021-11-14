#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Remove file ..."

rm -v /etc/udev/rules.d/usbdac.rules /etc/systemd/system/usbdac* /root/usbdac

echo -e "$bar Restore files ..."

cat << 'EOF' > /etc/udev/rules.d/rune_usb-audio.rules
#KERNEL=="card*", DRIVER=="snd-usb-audio", RUN+="/var/www/command/refresh_ao"
KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao"
EOF
restorefile /srv/http/app/libs/runeaudio.php

udevadm control --reload-rules
systemctl restart systemd-udevd

redis-cli del aodefault &> /dev/null

uninstallfinish $@
