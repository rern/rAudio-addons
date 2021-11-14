#!/bin/bash

# usage: ./dsdbitrate.sh </path/file>

ext=$( echo "$1" | sed 's/^.*\.//' | tr '[:lower:]' '[:upper:]' )

IFS0=$IFS
IFS=$( echo -en "\n\b" )
if [[ $ext == DSF ]]; then
	hexword=$( hexdump -x -s56 -n4 $1 )
		# 0000040 5758 5960 000003c
	IFS=$IFS0
	hex=( $( echo $hexword | cut -d' ' -f2,3 ) )
	# bitrate byte order: #59#60#57#58
	bitrate=$( echo $(( 16#${hex[1]}${hex[0]} )) )
else # DFF
	hexword=$( hexdump -x -s60 -n4 $1 )
		# 000003c 6162 6364 0000040
	IFS=$IFS0
	hex=( $( echo $hexword | cut -d' ' -f2,3 | tr -d ' ' | sed 's/.\{2\}/& /g' ) )
	# bitrate byte order: #62#61#64#63
	bitrate=$( echo $(( 16#${hex[1]}${hex[0]}${hex[3]}${hex[2]} )) )
fi

echo $bitrate
