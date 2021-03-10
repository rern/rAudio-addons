#!/bin/bash

# Radio France metadata
# status-radiofrance.sh FILENAME
[[ -n $2 ]] && sleep $2

name=$( echo $1 | sed 's|.*/\(.*\)\-.*|\1|' )
case $name in
	fipelectro ) id=74;;
	fipgroove ) id=66;;
	fip ) id=7;;
	fipjazz ) id=65;;
	fipnouveautes ) id=70;;
	fippop ) id=78;;
	fipreggae ) id=71;;
	fiprock ) id=64;;
	fipworld ) id=69;;
	francemusiquebaroque ) id=402;;
	francemusiqueclassiqueplus ) id=408;;
	francemusiqueconcertsradiofrance ) id=403;;
	francemusiqueeasyclassique ) id=401;;
	francemusique ) id=4;;
	francemusiquelabo ) id=407;;
	francemusiquelacontemporaine ) id=406;;
	francemusiquelajazz ) id=405;;
	francemusiqueocoramonde ) id=404;;
	francemusiqueopera ) id=409;;
esac

metadataGet() {
	readarray -t metadata <<< $( curl -s -m 5 -G \
		--data-urlencode 'operationName=Now' \
		--data-urlencode 'variables={"bannerPreset":"600x600-noTransform","stationId":'$id',"previousTrackLimit":1}' \
		--data-urlencode 'extensions={"persistedQuery":{"version":1,"sha256Hash":"8a931c7d177ff69709a79f4c213bd2403f0c11836c560bc22da55628d8100df8"}}' \
		https://www.fip.fr/latest/api/graphql \
		| jq '.data.now.playing_item, .data.now.server_time' \
		| grep -v '{\|"__typename"\|"start_time"\|}' \
		| sed 's/^\s\+".*": "*//; s/"*,*$//' )
	
	data='{"Artist":"'${metadata[0]}'", "coverart": "'${metadata[2]}'", "Title":"'${metadata[1]}'", "file":"'$1'"}'
	curl -s -X POST http://127.0.0.1/pub?id=mpdplayer -d "$data"
}

metadataGet
while sleep 5; do
	metadataGet
done
