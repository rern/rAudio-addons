#!/bin/bash

alias=rank

# restore 20230501
#. /srv/http/bash/settings/addons.sh

# 20230501
[[ -e /srv/http/bash/settings/addons.sh ]] && . /srv/http/bash/settings/addons.sh || . /srv/http/bash/addons.sh

installstart $@

sec=${args[0]}
[[ ! $sec ]] && sec=3

echo "
$bar Get latest mirrorlist of package servers ...
"
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

tmpdir=/tmp/rankmirrors
rm -rf $tmpdir && mkdir $tmpdir

echo "
$bar Get file list for download test ..."
readarray -t srcfiles <<< $( curl -sL http://mirror.archlinuxarm.org/os/ | sed -E -n '/>Arch.*gz</ {s/.*>(Arch.*gz).*/\1/; p}' )
[[ ! $srcfiles ]] && echo "$warn Download file list failed." && exit

srcL=${#srcfiles[@]}
echo "
$bar Test ${#servers[@]} servers @ $sec seconds random download + 3 pings:"
i=0
for server in ${servers[@]}; do # download from each mirror
	(( i++ ))
	srcfile=${srcfiles[$(( $RANDOM % $srcL ))]}
	echo "<a class='cgr'>Download: $srcfile</a>"
	curl --max-time $sec -sLo $tmpdir/srcfile $server/os/$srcfile?$( date +%s )
	wait
	dl=$( du -c $tmpdir | grep total | awk '{print $1}' ) # get downloaded amount
	ping=$( ping -4 -c 3 -w 3 ${server/http*\:\/\/} | tail -1 | cut -d'/' -f5 )
	if [[ $ping ]]; then
		latency=$( printf %.0f $ping )
	else
		latency=999
	fi
	
	server0='Server = '$server'/$arch/$repo'
	speed=$(( dl / sec ))
	dl_server+="$server0 $speed $latency\n"
	printf "%3s %-37s %11s %7s\n" $i. $server "$speed kB/s" "$latency ms"
done

rank=$( echo -e "$dl_server" | awk NF | sort -g -k4,4nr -k5n )
rankfile=$( cut -d' ' -f1-3 <<< $rank )

echo "
$info Top 3 servers:"

lines=$( head -3 <<< "$rank" | sed 's/Server = \|\/\$arch.*repo//g' )
for i in 1 2 3; do
	fields=( $( sed -n "$i p" <<< $lines ) )
	printf "%3s %-37s %11s %7s\n" $i. ${fields[0]} "${fields[1]} kB/s" "${fields[2]} ms"
done

list=/etc/pacman.d/mirrorlist
[[ ! -e $list.backup ]] && cp $list $list.backup
echo "$rankfile" > $list
rm -rf $tmpdir

echo "
$bar Update package database ..."
rm -f /var/lib/pacman/db.lck
pacman -Sy

installfinish
