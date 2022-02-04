#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /tmp
cp -r /tmp/webradios/* /srv/http/data/webradios
cp /tmp/webradiosimg/* /srv/http/data/webradiosimg
chown -R http:http /srv/http/data/webradios*
count=$( find -L $dirdata/webradios -type f | wc -l )
sed -i 's/\("webradio": \).*/\1'$count'/' /srv/http/data/mpd/counts

installfinish
