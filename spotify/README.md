User's authorization
---
Allow apps to access private data

### Request:
- Required: `CLIENT_ID` and `REDIRECT_URI` (from https://developer.spotify.com/dashboard/applications)
- URL for user: `https://accounts.spotify.com/authorize?response_type=token&scope=user-read-playback-position&client_id=CLIENT_ID&redirect_uri=REDIRECT_URI`

### Response:
- Redirect to `APP_URL`
- User's token in address bar: `access_token=TOKEN`
- Exipre: `expires_in=3600`

### Current track
- `curl -X GET https://api.spotify.com/v1/me/player -H "Authorization: Bearer TOKEN"`
