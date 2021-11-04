Soptify API
---

- Required: (from https://developer.spotify.com/dashboard/applications)
	- `CLIENT_ID`
	- `CLIENT_SECRET`

### Get current track metadata
- No user's authorization needed
- No current progress and status available
- Get `TOKEN` (expired after 60 minutes)
```sh
CLIENT_ID=CLIENT_ID
CLIENT_SECRET=CLIENT_SECRET

curl -s -X POST https://accounts.spotify.com/api/token \
	-u $CLIENT_ID:$CLIENT_SECRET \
	-d grant_type=client_credentials
```
- response: `"access_token":"TOKEN"`
- Get `$TRACK_ID` from spotifyd env variable
- Get metadata
```sh
TRACK_ID=TRACK_ID
TOKEN=TOKEN

curl -s -X GET https://api.spotify.com/v1/tracks/$TRACK_ID \
	-H "Authorization: Bearer TOKEN"
```
- response: metadata

### Get current progress and status
- Need user's authorization (once)
- Get authorization `CODE`
```js
// authorization page for user
var CLIENT_ID = 'CLIENT_ID';
var REDIRECT_URI = 'REDIRECT_URI';

var data = {
	  response_type : 'code'
	, client_id     : CLIENT_ID
	, scope         : 'user-read-playback-position'
	, redirect_uri  : REDIRECT_URI
}

window.location = 'https://accounts.spotify.com/authorize?'+ $.param( data );
```
- response: `code=CODE` in address bar of `REDIRECT_URI` (`CODE` never expires.)

- Get `TOKEN` (expired after 60 minutes)
```sh
CODE=CODE
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
- response: `"access_token":"TOKEN"` `"refresh_token":"REFRESH_TOKEN"` (`REFRESH_TOKEN` never expires.)

- Get status
```sh
TOKEN=TOKEN

curl -X GET https://api.spotify.com/v1/me/player \
	-H "Authorization: Bearer TOKEN"
```
- response: `progress_ms`, `is_playing` (available after stop for a few seconds)

- Get new `TOKEN` after expired
```sh
CODE=CODE
REFRESH_TOKEN=REFRESH_TOKEN
CLIENT_ID=CLIENT_ID
CLIENT_SECRET=CLIENT_SECRET
CLIENT_BASE64=$( echo -n $CLIENT_ID:$CLIENT_SECRET | base64 -w 0 )

curl -X POST https://accounts.spotify.com/api/token \
	-H "Authorization: Basic $CLIENT_BASE64" \
	-d "code=$CODE" \
	-d grant_type=refresh_token \
	-d refresh_token=$REFRESH_TOKEN
```
- response: `"access_token":"TOKEN"`
