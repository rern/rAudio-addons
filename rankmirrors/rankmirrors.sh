#!/bin/bash

alias=rank

[[ ! -e /usr/bin/rate-mirrors ]] && pacman -Sy --noconfirm rate-mirrors

. /srv/http/bash/settings/addons.sh

basename $0 .sh > $dirshm/script

installstart $@

rate-mirrors --allow-root --save=mirrorlist archarm
grep ^Server mirrorlist > /etc/pacman.d/mirrorlist
rm mirrorlist

echo "
$bar Update package database ..."
rm -f /var/lib/pacman/db.lck
pacman -Sy

installfinish
