### Lastfm Scrobble

- API:
	- `apisig` signature string:
		- Must be in alphabetical order
		- Syntax `key${value}...$sharedsecret`
		- encode to `utf8`
		- Hash with `md5sum`
		- Trim to 32 characters
	- `curl`:
		- Must be in alphabetical order
		- Append with `apisig` and `format`

- Authorize with usernme and password > `.session.key` (`sk`)
```sh
apikey=$apikey
password=$password
username=$username
sharedsecret=$sharedsecret
apisig=$( echo -n "api_key${apikey}methodauth.getMobileSessionpassword${password}username${username}$sharedsecret" \
			| iconv -t utf8 \
			| md5sum \
			| cut -c1-32 )
sk=$( curl -sX POST \
	--data-urlencode "api_key=$apikey" \
	--data-urlencode "method=auth.getMobileSession" \
	--data-urlencode "password=$password" \
	--data-urlencode "username=$username" \
	--data-urlencode "api_sig=$apisig" \
	--data-urlencode "format=json" \
	http://ws.audioscrobbler.com/2.0/ \
	| jq -r .session.key )
```

- Scrobble
```sh
album=$Album
apikey=$apikey
artist=$Artist
sk=$sk
timestamp=$( date +%s )
track=$Title
sharedsecret=$sharedsecret
apisigscrobble=$( echo -n "album${album}api_key${apikey}artist${artist}methodtrack.scrobblesk${sk}timestamp${timestamp}track${track}${sharedsecret}" \
					| iconv -t utf8 \
					| md5sum \
					| cut -c1-32 )
accepted=$( curl -sX POST \
	--data-urlencode "album=$album" \
	--data-urlencode "api_key=$apikey" \
	--data-urlencode "artist=$artist" \
	--data-urlencode "method=track.scrobble" \
	--data-urlencode "sk=$sk" \
	--data-urlencode "timestamp=$timestamp" \
	--data-urlencode "track=$track" \
	--data-urlencode "api_sig=$apisigscrobble" \
	--data-urlencode "format=json" \
	http://ws.audioscrobbler.com/2.0/ \
	| jq  '.scrobbles."@attr".accepted' )
[[ $accepted == 1 ]] && success=yes
```


- Alternative - Authorize with user's browser
	- Get token > `.token`
	- Authorize at URL link
	- Get `.session.key`
```sh
# .token
apikey=$apikey
sharedsecret=$sharedsecret
apisig=$( echo -n "api_key${apikey}methodauth.getToken${sharedsecret}" \
			| iconv -t utf8 \
			| md5sum \
			| cut -c1-32 )
token=$( curl -sX POST \
	--data-urlencode "api_key=$apikey" \
	--data-urlencode "api_sig=$apisig" \
	--data-urlencode "method=auth.getToken" \
	--data-urlencode "format=json" \
	http://ws.audioscrobbler.com/2.0/ \
	| jq -r .token )

# URL
echo "URL: https://www.last.fm/api/auth?api_key=$apikey&token=$token"

# .session.key
apisig=$( echo -n "api_key${apikey}methodauth.getSessiontoken${token}${sharedsecret}" \
			| iconv -t utf8 \
			| md5sum \
			| cut -c1-32 )
sk=$( curl -sX POST \
	--data-urlencode "api_key=$apikey" \
	--data-urlencode "method=auth.getSession" \
	--data-urlencode "token=$token" \
	--data-urlencode "api_sig=$apisig" \
	--data-urlencode "format=json" \
	http://ws.audioscrobbler.com/2.0/ \
	| jq -r .session.key )
```
