#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

curl -sL https://github.com/rern/rAudio-addons/raw/main/webradio/radiofrance.tar.xz | bsdtar xvf - -C /srv/http/data
chown -R http:http /srv/http/data/webradios*
count=$( find $dirdata/webradios -type f \
			| grep -v '.jpg$\|.gif$' \
			| wc -l )
sed -i 's/\("webradio": \).*/\1'$count'/' /srv/http/data/mpd/counts

installfinish
