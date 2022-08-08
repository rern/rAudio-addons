#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /
chown -R http:http /srv/http/data/webradis*
count=$( find -L $dirdata/webradio -type f | wc -l )
sed -i 's/\("webradio": \).*/\1'$count'/' /srv/http/data/mpd/counts

installfinish
