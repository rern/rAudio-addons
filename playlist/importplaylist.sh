#!/bin/bash

alias=plsi

[[ -e /srv/http/bash/addons.sh ]] && . /srv/http/bash/addons.sh || . /srv/http/bash/addons-functions.sh

installstart $@

# all files include sub-directory
files=$( find /var/lib/mpd/playlists -type f 2> /dev/null )
if [[ -z $files ]]; then
	title -l '=' "$info No playlists found."
	title -nt 'Copy *.m3u to /var/lib/mpd/playlists then run again.'
	exit
fi

title -l '=' "$bar Playlist Import ..."

(( mpc playlist | wc -l > 0 )) && php /srv/http/mpdplaylist.php save _importtemp || mpc -q clear

readarray -t files <<<"$files"
for file in "${files[@]}"; do
	name=$( basename "$file" .m3u )
	if [[ -e "/srv/http/data/playlists/$name" ]]; then
		echo -e "$info Skip: $name exists"
		continue
	fi
	
	echo $name
	sed 's|\\|/|g' "$file" | mpc add
	php /srv/http/mpdplaylist.php save "$name"
	mpc -q clear
done

if [[ -e /srv/http/data/playlists/_importtemp ]]; then
	/srv/http/mpdplaylist.php load _importtemp
	rm /srv/http/data/playlists/_importtemp
fi

installfinish
