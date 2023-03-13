#!/bin/bash

alias=radi

. /srv/http/bash/addons.sh

installstart $@

# all files include sub-directory
files=$( find /mnt/MPD/Webradio -type f 2> /dev/null )
if [[ ! $files ]]; then
	echo "
$info No webradio files found.
Copy *.pls to /mnt/MPD/Webradio/ then run again.
"
	exit
fi

title "$bar Webradio Import ..."

readarray -t files <<<"$files"
for file in "${files[@]}"; do
	name=$( basename "$file" .pls )
	url=$( grep '^File' "$file" | cut -d '=' -f2- )
	printf "%-30s : $url\n" "$name"
	echo $name > /srv/http/data/webradio/${url//\//|}
done
count=$( ls -1q /srv/http/data/webradio | wc -l )
sed -i 's/\("webradio": \).*/\1'$count'/' /srv/http/data/mpd/counts

installfinish
