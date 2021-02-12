#!/bin/bash

alias=plsi

. /srv/http/bash/addons.sh

installstart $@

# all files include sub-directory
files=$( find /var/lib/mpd/playlists -type f 2> /dev/null )
if [[ -z $files ]]; then
	title -l '=' "$info No playlists found."
	title -nt 'Copy *.m3u to /var/lib/mpd/playlists then run again.'
	exit
fi

title -l '=' "$bar Playlist Import ..."

(( $( mpc playlist | wc -l ) > 0 )) && php /srv/http/mpdplaylist.php save _existing
mpc -q clear

readarray -t files <<<"$files"
for file in "${files[@]}"; do
	name=$( basename "$file" .m3u )
	[[ -e "/srv/http/data/playlists/$name" ]] && name="${name}_1"
	
	echo $name
	sed 's|\\|/|g' "$file" | mpc add
	php /srv/http/mpdplaylist.php save "$name"
done

if [[ -e /srv/http/data/playlists/_existing ]]; then
	mpc -q clear
	php /srv/http/mpdplaylist.php load _existing
	rm /srv/http/data/playlists/_existing
fi

installfinish
