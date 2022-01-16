#!/bin/bash

alias=chro

. /srv/http/bash/addons.sh

installstart "$1"

arch=$( uname -m )
curl -sLO https://github.com/rern/rAudio-addons/releases/download/chromium_downgrade/$arch.tar.xz
bsdtar --strip 1 -xvf $arch.tar.xz

mv libicu/* /lib
rm -rf libicu
pacman -U --noconfirm chromium*
rm chromium*

sed -i '/#Ignore/ a\Ignore = chromium' /etc/pacman.conf

installfinish
