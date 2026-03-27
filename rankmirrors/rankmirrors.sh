#!/bin/bash

alias=rank

[[ ! -e /usr/bin/rate-mirrors ]] && pacman -Sy --noconfirm rate-mirrors

. /srv/http/bash/settings/addons.sh

basename $0 .sh > $dirshm/script

installstart $@

rate_mirrors --allow-root --disable-comments-in-file --save /etc/pacman.d/mirrorlist archarm

echo "
$bar Update package database ..."
rm -f /var/lib/pacman/db.lck
pacman -Sy

installfinish
