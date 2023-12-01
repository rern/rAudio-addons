#!/bin/bash

. /srv/http/bash/settings/addons.sh

installstart $@

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /srv/http/data/webradio
chown -R http:http $dirwebradio
count=$( find -L $dirwebradio -type f ! -path '*/img/*' | wc -l )
sed -i -E 's/("webradio": ).*/\1'$count'/' $dirmpd/counts
data='{ "channel": "radiolist", "data": {"type":"webradio","count":'$count'} }'
[[ -e /usr/bin/websocat ]] && echo $data | websocat ws://127.0.0.1:8080 || echo $data | wsdump ws://127.0.0.1:8080 &> /dev/null

installfinish
