Spotify API
---

- Required: (from https://developer.spotify.com/dashboard/applications)
	- `CLIENT_ID`
	- `CLIENT_SECRET`

### Get current track metadata
- No user's authorization needed
- No current progress and status available
- Get `TOKEN`
```sh
#!/bin/bash
CLIENT_ID=CLIENT_ID
CLIENT_SECRET=CLIENT_SECRET

curl -s -X POST https://accounts.spotify.com/api/token \
	-u $CLIENT_ID:$CLIENT_SECRET \
	-d grant_type=client_credentials
```
- response: `"access_token":"TOKEN"` (expire: 1 hour)
- Get `$TRACK_ID` from spotifyd env variable
- Get metadata
```sh
#!/bin/bash
TRACK_ID=TRACK_ID
TOKEN=TOKEN

curl -s -X GET https://api.spotify.com/v1/tracks/$TRACK_ID \
	-H "Authorization: Bearer TOKEN"
```
- response: metadata

### Get current progress and metadata
- Get authorization `CODE`
- `REDIRECT_URI` page > `HOSTNAME`
- Extract `CODE` and `error` on redirect back from `REDIRECT_URI`
- `HOSTNAME` page response
- Get `TOKEN` and `REFRESH_TOKEN`
- Get new `TOKEN` after expired
---
- Get authorization `CODE`
```js
// js
var CLIENT_ID = 'CLIENT_ID';
var REDIRECT_URI = 'REDIRECT_URI';
var HOSTNAME = window.location.hostname; // for redirect back > get tokens

var data = {
	  response_type : 'code'
	, client_id     : CLIENT_ID
	, scope         : 'user-read-currently-playing user-read-playback-position'
	, state         : HOSTNAME
	, redirect_uri  : REDIRECT_URI
}

window.location = 'https://accounts.spotify.com/authorize?'+ $.param( data );
```
- response:
	- `code=CODE` in address bar of `REDIRECT_URI`
	- Expired on get `TOKEN`

- `REDIRECT_URI` page > `HOSTNAME`
```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
</head>
<body>
	<script>
	var url = new URL( window.location.href );
	var code = url.searchParams.get( 'code' );
	var hostname = url.searchParams.get( 'state' );
	var error = code ? '' : '&error='+ url.searchParams.get( 'error' );
	window.location = 'http://'+ hostname +'?code='+ code + error;
	</script>
</body>
</html>
```

- Extract `CODE` and `error` on redirect back from `REDIRECT_URI`
```php
<?php
if ( isset( $_GET[ 'code' ] ) ) {
	$code = $_GET[ 'code' ];
	if ( $code ) exec( 'GET_TOKENS.sh '.$code );
	echo '<a id="spotifycode" style="display: none">'.$_GET[ 'error' ].'</a>';
}
```

- `HOSTNAME` page response
```js
// js
var spotifycode = getElementById( 'spotifycode' );
if ( spotifycode.length ) {
	window.history.replaceState( 'page', 'normal', 'HOSTNAME' ); // reset URL with parameters to HOSTNAME
	var error = spotifycode.textContent;
	if ( error ) alert( error )
}
```

- Get `TOKEN` and `REFRESH_TOKEN`
```sh
#!/bin/bash
CODE=$1
CLIENT_ID=CLIENT_ID
CLIENT_SECRET=CLIENT_SECRET
CLIENT_BASE64=$( echo -n $CLIENT_ID:$CLIENT_SECRET | base64 -w 0 )
REDIRECT_URI=REDIRECT_URI

curl -X POST https://accounts.spotify.com/api/token \
	-H "Authorization: Basic $CLIENT_BASE64" \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-d "code=$CODE" \
	-d grant_type=authorization_code \
	--data-urlencode "$REDIRECT_URI"
```
- response:
	- `"access_token":"TOKEN"` (expire: 1 hour)
	- `"refresh_token":"REFRESH_TOKEN"` (never expires.)

- Get status
```sh
TOKEN=TOKEN

curl -X GET https://api.spotify.com/v1/me/player \
	-H "Authorization: Bearer TOKEN"
```
- response: 
	- metadata
	- `progress_ms` elapsed
	- `is_playing`  play (missing = pause)

- Get new `TOKEN` after expired
```sh
REFRESH_TOKEN=REFRESH_TOKEN
CLIENT_ID=CLIENT_ID
CLIENT_SECRET=CLIENT_SECRET
CLIENT_BASE64=$( echo -n $CLIENT_ID:$CLIENT_SECRET | base64 -w 0 )

curl -X POST https://accounts.spotify.com/api/token \
	-H "Authorization: Basic $CLIENT_BASE64" \
	-d grant_type=refresh_token \
	-d refresh_token=$REFRESH_TOKEN
```
- response: `"access_token":"TOKEN"`
