#!/bin/bash

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

if [[ ! -e /var/lib/redis/rune.rdb ]]; then
	title -l '=' "$info No database file found."
	title -nt 'Copy rune.rdb backup to /var/lib/ then run again.'
	exit
fi

title -l '=' "$bar Webradio export ..."

path=/mnt/MPD/Webradio
# clear files
rm -f $path/*.pls

echo -e "$bar $path"
# create files from database
i=1
#str= # no need to initially set blank var in bash
redis-cli hgetall webradios | \
while read line; do
	if [[ $(( i % 2)) == 1 ]]; then
		str+="[playlist]\nNumberOfEntries=1\n"
		title="Title1=$line\n"
		filename=$line.pls
	else
		str+="File1=$line\n"
		str+=$title
		echo -e "$str" > "$path/$filename"
		printf "%3s. $filename\n" $(( i / 2 ))
		str= # reset to empty
	fi
	(( i++ ))
done

# refresh ui
mpc update Webradio &> /dev/null

title -l '=' "$bar Webradio exported successfully."
title -nt "$info Webradio files: /mnt/MPD/Webradio/"
