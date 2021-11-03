User's authorization
---
Allow apps to access private data

### Request:
- Required: `CLIENT_ID` and `REDIRECT_URI` (from https://developer.spotify.com/dashboard/applications)
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

### Response:
- Redirect to `APP_URL`
- User's token in address bar:
	- token `access_token=TOKEN` (`expires_in=3600`)
	- code `code=CODE`

### Current track
- `curl -X GET https://api.spotify.com/v1/me/player -H "Authorization: Bearer TOKEN"`

### base64 encode for Authorization: Basic
```sh
# Authorization: Basic <base64 encoded CLIENT_ID:CLIENT_SECRET>
base64auth=$( echo -n $CLIENT_ID:$CLIENT_SECRET | base64 | tr -d '\n=' )
```
