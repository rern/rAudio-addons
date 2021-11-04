Soptify API
---

Required: (from https://developer.spotify.com/dashboard/applications)
	- `CLIENT_ID`
	- `CLIENT_SECRET`

### Get current track metadata
- No user's authorization needed
- No current progress and status available
```sh
# get token
CLIENT_ID=CLIENT_ID
CLIENT_SECRET=CLIENT_SECRET

curl -s -X POST https://accounts.spotify.com/api/token \
	-u $CLIENT_ID:$CLIENT_SECRET \
	-d grant_type=client_credentials
	
# get $TRACK_ID from spotifyd env variable

# get data
#TRACK_ID=TRACK_ID
TOKEN=TOKEN

curl -s -X GET https://api.spotify.com/v1/tracks/$TRACK_ID \
	-H "Authorization: Bearer TOKEN"
```

### Get current progress and status
- Need user's authorization
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
- `code=CODE` in address bar of `REDIRECT_URI`

```sh
# get token
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
	--data-urlencode $REDIRECT_URI
	
# get status
TOKEN=TOKEN

curl -X GET https://api.spotify.com/v1/me/player \
	-H "Authorization: Bearer TOKEN"
```
- `progress_ms`, `is_playing`