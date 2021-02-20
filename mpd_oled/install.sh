#!/bin/bash

alias=oled

. /srv/http/bash/addons.sh

if grep -q dtoverlay=tft35a /boot/config.txt; then
	ech0 -e "$info TFT LCD must be disabled."
	exit
fi

installstart "$1"

getinstallzip

getuninstall

chmod +x /usr/bin/mpd_oled*

if [[ ${args[0]} == i2c ]]; then
	echo dtparam=i2c_arm=on >> /boot/config.txt
	echo i2c-dev >> /etc/modules-load.d/raspberrypi.conf
else
	echo dtparam=spi=on >> /boot/config.txt
fi

systemctl daemon-reload
systemctl enable --now mpd_oled

installfinish

echo -e "$info Reboot required."
