#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /
chown -R http:http /srv/http/data/webradios*
count=$( ls -1 /srv/http/data/webradios | wc -l )
sed -i 's/\("webradio": \).*/\1'$count'/' /srv/http/data/mpd/counts
touch /srv/http/data/addons/fran

installfinish
