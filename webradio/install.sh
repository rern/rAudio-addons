#!/bin/bash

. /srv/http/bash/settings/addons.sh

installstart $@

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /
chown -R http:http $dirwebradio
count=$( find -L $dirwebradio -type f ! -path '*/img/*' | wc -l )
sed -i -E 's/("webradio": ).*/\1'$count'/' $dirmpd/counts
curl -s -X POST http://127.0.0.1/pub?id=radiolist -d '{"type":"webradio","count":'$count'}'

installfinish
