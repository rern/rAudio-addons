#!/bin/bash

alias=rank

. /srv/http/bash/addons.sh

installstart "$1"

sec=${args[0]}
[[ -z $sec ]] && sec=3

echo -e "\n$bar Get latest mirrorlist of package servers ..."
curl -sLo /tmp/mirrorlist https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist
tmplist=/tmp/mirrorlist
echo $( grep 'Generated' $tmplist | cut -d' ' -f2- )

# convert mirrorlist to url list
if grep -qs '# Server = ' $tmplist; then
	sed -i '/^\s*$/d
		/^# Server = /!d
		s/^# Server = //g
		s|/$arch/$repo||g' $tmplist
		# delete blank lines and lines not start with '# Server = ', remove '# Server = '
else
	sed -i 's/^Server = //g
		s|/$arch/$repo||g' $tmplist # already uncomment
fi

readarray servers < "$tmplist"

echo -e "\nTest ${#servers[@]} servers @ $sec seconds download + 3 pings:\n"

tmpdir=/tmp/rankmirrors
rm -rf $tmpdir && mkdir $tmpdir

srcfiles=( $( curl -sL mirror.archlinuxarm.org/os/ | grep 'Arch.*gz<' | sed 's/.*href="\(.*\.gz\)".*/\1/' ) )
srcL=${#srcfiles[@]}

i=0
for server in ${servers[@]}; do # download from each mirror
	(( i++ ))
	srcfile=${srcfiles[$(( $RANDOM % $srcL ))]}
	tcolor "Download: $srcfile" 8
	curl --max-time $sec -sLo $tmpdir/srcfile $server/os/$srcfile?$( date +%s )
	wait
	dl=$( du -c $tmpdir | grep total | awk '{print $1}' ) # get downloaded amount
	ping=$( ping -4 -c 3 -w 3 ${server/http*\:\/\/} | tail -1 | cut -d'/' -f5 )
	if [[ -n $ping ]]; then
		latency=$( printf %.0f $ping )
	else
		latency=999
	fi
	
	server0='Server = '$server'/$arch/$repo'
	speed=$(( dl / sec ))
	dl_server+="$server0 $speed $latency\n"
	printf "%3s %-37s %11s %7s\n" $i. $server "$speed kB/s" "$latency ms"
done

rank=$( echo -e "$dl_server" | grep . | sort -g -k4,4nr -k5n )
rankfile=$( echo -e "$rank" | cut -d' ' -f1-3 )

echo -e "\n$info Top 3 package servers ranked by speed and latency:\n"

lines=$( echo -e "$rank" | head -3 | sed 's/Server = \|\/\$arch.*repo//g' )
for i in 1 2 3; do
	fields=( $( echo "$lines" | sed -n "$i p" ) )
	printf "%3s %-37s %11s %7s\n" $i. ${fields[0]} "${fields[1]} kB/s" "${fields[2]} ms"
done

list=/etc/pacman.d/mirrorlist
[[ ! -e $list.backup ]] && cp $list $list.backup
echo -e "$rankfile" > $list
rm -rf $tmpdir

echo -e "\n$bar Update package database ..."

rm -f /var/lib/pacman/db.lck
pacman -Sy

installfinish
