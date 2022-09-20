#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /
chown -R http:http /srv/http/data/webradis*
count=$( find -L $dirdata/$type -type f ! -path '*/img/*' | wc -l )
sed -i -E 's/("webradio": ).*/\1'$count'/' /srv/http/data/mpd/counts
curl -s -X POST http://127.0.0.1/pub?id=radiolist -d '{"type":"webradio","count":'$count'}'

installfinish
