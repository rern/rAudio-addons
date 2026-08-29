#!/bin/bash

. /srv/http/bash/settings/addons.sh

installstart $@

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /
chown -R http:http $dirwebradio
count=$( find -L $dirwebradio -type f -name data | wc -l )
sed -i -E 's/("webradio": ).*/\1'$count'/' $dirmpd/counts
pushData radiolist '{ "channel": "radiolist", "data": {"type":"webradio","count":'$count'} }'

installfinish
