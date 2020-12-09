#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

# all files include sub-directory
allfiles=$( find /mnt/MPD/Webradio -type f )
readarray -t files <<<"$allfiles"
for file in "${files[@]}"; do
	filename=$( basename "$file" )
	ext=${filename##*.}
	if [[ $ext == 'pls' || $ext == 'm3u' ]]; then
		rm -rf /tmp/Webradio
		mkdir -p /tmp/Webradio
		mv /mnt/MPD/Webradio/* /tmp/Webradio
		break
	fi
	title -l '=' "$info No webradio files found."
	title -nt 'Copy *.pls or *.m3u to /mnt/MPD/Webradio/ then run again.'
	exit
done

title -l '=' "$bar Webradio Import ..."

# clear database
redis-cli del webradios &> /dev/null

# add data to files
makefile() {
	cat << EOF > "/mnt/MPD/Webradio/$1.pls"
[playlist]
NumberOfEntries=1
Title1=$1
File1=$2
EOF
}
checkname() {
	for n in "${names[@]}"; do
		if [[ $n == $1 ]]; then
			[[ -n $( echo $n | grep '_[0-9]\+$' ) ]] && num=${n##*_} || num=1
			(( num++ ))
			name=${1%_*}'_'$num
			checkname "$name"
			break
		else
			name=$1
		fi
	done
}
incrementname() {
	if (( ${#names[@]} == 0 )); then
		name=$1
		names+=( "$name" )
		return
	fi
	checkname "$name"
	names+=( "$name" )
}

allfiles=$( find /tmp/Webradio -type f )
readarray -t files <<<"$allfiles"
for file in "${files[@]}"; do
	if [[ ${file##*.} == pls ]]; then
		# count to work with multiple items
		count=$( grep -c '^File' "$file" )
		for (( i=1; i <= $count; i++ )); do
			name=$( grep "^Title$i" "$file" | cut -d '=' -f2 )
			url=$( grep "^File$i" "$file" | cut -d '=' -f2 )
			# no name
			[[ -z $name ]] && name="noName"
			incrementname "$name"
			
			printf "%-30s : $url\n" "$name"
			redis-cli hset webradios "$name" "$url" &> /dev/null
			makefile "$name" "$url"
		done
	else
		# *.m3u
		cat $file | while read line; do
			[[ ${line:0:4} != http ]] && continue
			
			linenohttp=${line:7}
			if [[ $linenohttp =~ '/' ]]; then
				filename=${linenohttp##*/}
				name=${filename%.*}
			else
				name="noName"
			fi
			incrementname "$name"
			printf "%-30s : $line\n" "$name"
			redis-cli hset webradios "$name" "$line" &> /dev/null
			makefile "$name" "$line"
		done
	fi
done

rm -rf /tmp/Webradio

# refresh list
mpc update Webradio &> /dev/null

title -l '=' "$bar Webradio imported successfully."
