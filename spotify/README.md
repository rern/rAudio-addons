Soptify API
---

- Required: `CLIENT_ID` and `REDIRECT_URI` (from https://developer.spotify.com/dashboard/applications)

### Get current track metadata
No user's authorization required
```sh
# get token
curl -s -X POST https://accounts.spotify.com/api/token \
	-u $client_id:$client_secret \
	-d grant_type=client_credentials
# get data
curl -s -X GET https://api.spotify.com/v1/me/player \
	-H "Authorization: Bearer TOKEN"
```

### Get current track status
- Required user's authorization to access private data: `progress_ms`, `is_playing`, ...
- JS open authorization page for user:
```js
var RESPONSE_TYPE = 'token' // or 'code'
var data = {
	  response_type : RESPONSE_TYPE
	, client_id     : CLIENT_ID
	, scope         : 'user-read-playback-position'
	, redirect_uri  : REDIRECT_URI
}
window.location = 'https://accounts.spotify.com/authorize?'+ $.param( data );
```
- Redirect to `APP_URL` with user's token in address bar:
	- token `access_token=TOKEN` (`expires_in=3600`)
	- code `code=CODE` (never expire unless revoked by user)
- Get status
```sh
# get token
base64auth=$( echo -n $CLIENT_ID:$CLIENT_SECRET | base64 | tr -d '\n=' )
curl https://accounts.spotify.com/api/token \
	-d "code=$code&grant_type=authorization_code&redirect_uri=REDIRECT_URI" \
	-H "Authorization: Basic $base64auth"
# get data
curl -X GET https://api.spotify.com/v1/me/player \
	-H "Authorization: Bearer TOKEN"
```
