#!/bin/bash

alias=tran

. /srv/http/bash/addons.sh

uninstallstart

systemctl disable --now transmission

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
dirweb=/usr/share/transmission/web
rm -r $dirweb/tr-web-control
rm -v $dirweb/{favicon.ico,index.html,index.mobile.html}
mv $dirweb/index{.original,}.html

uninstallfinish
