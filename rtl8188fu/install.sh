#!/bin/bash

# restore 20230501
#. /srv/http/bash/settings/addons.sh

# 20230501
[[ -e /srv/http/bash/settings/addons.sh ]] && . /srv/http/bash/settings/addons.sh || . /srv/http/bash/addons.sh

installstart $@

wget -q https://github.com/rern/rAudio-addons/raw/main/rtl8188fu/rtl8188fufw.bin -P /lib/firmware/rtlwifi
echo 'blacklist r8188eu
blacklist r8188fu
options rtl8188fu rtw_power_mgnt=0 rtw_enusbss=0' > /etc/modprobe.d/rtl8188fu.conf

installfinish
