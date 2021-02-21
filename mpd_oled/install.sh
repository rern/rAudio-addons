#!/bin/bash

alias=oled

. /srv/http/bash/addons.sh

installstart "$1"

wget -qP /etc/systemd/system https://github.com/rern/rAudio-addons/blob/main/mpd_oled/mpd_oled.service
wget -qP /usr/bin https://github.com/rern/rAudio-addons/blob/main/mpd_oled/mpd_oled
wget -qP /usr/bin https://github.com/rern/rAudio-addons/blob/main/mpd_oled/mpd_oled_cava

chmod +x /usr/bin/mpd_oled*

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
