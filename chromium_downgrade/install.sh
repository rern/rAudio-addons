#!/bin/bash

alias=chro

. /srv/http/bash/addons.sh

installstart "$1"

echo -e "$bar Download files ..."

arch=$( uname -m )
curl -sLO https://github.com/rern/rAudio-addons/releases/download/chromium_downgrade/$arch.tar.xz
bsdtar --strip 1 -xvf $arch.tar.xz

mv libicu/* /lib
rm -rf libicu
pacman -U --noconfirm chromium*
rm chromium*

grep -q chromium /etc/pacman.conf || sed -i '/#IgnorePkg/ a\IgnorePkg = chromium' /etc/pacman.conf

installfinish