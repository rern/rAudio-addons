### Radio France API 

| Station          | `chan`    | URL                                                     |
|------------------|-----------|---------------------------------------------------------|
| Fip              | `chan=7`  | `https://icecast.radiofrance.fr/fip-hifi.aac`           |
| Fip - Electro    | `chan=74` | `https://icecast.radiofrance.fr/fipelectro-hifi.aac`    |
| Fip - Groove     | `chan=66` | `https://icecast.radiofrance.fr/fipgroove-hifi.aac`     |
| Fip - Jazz       | `chan=65` | `https://icecast.radiofrance.fr/fipjazz-hifi.aac`       |
| Fip - Nouveautés | `chan=70` | `https://icecast.radiofrance.fr/fipnouveautes-hifi.aac` |
| Fip - Pop        | `chan=78` | `https://icecast.radiofrance.fr/fippop-hifi.aac`        |
| Fip - Reggae     | `chan=71` | `https://icecast.radiofrance.fr/fipreggae-hifi.aac`     |
| Fip - Rock       | `chan=64` | `https://icecast.radiofrance.fr/fiprock-hifi.aac`       |
| Fip - World      | `chan=69` | `https://icecast.radiofrance.fr/fipworld-hifi.aac`      |
| Fip - World      | `chan=69` | `https://icecast.radiofrance.fr/fipworld-hifi.aac`      |

- France Musique            - `chan=4`   : `https://icecast.radiofrance.fr/francemusique-hifi.aac`
- Classique Easy            - `chan=401` : `https://icecast.radiofrance.fr/francemusiqueeasyclassique-hifi.aac`
- Classique Plus            - `chan=402`  : `https://icecast.radiofrance.fr/francemusiqueclassiqueplus-hifi.aac`
- Concerts Radio France     - `chan=403`  : `https://icecast.radiofrance.fr/francemusiqueconcertsradiofrance-hifi.aac`
- La B.O. Musiques de Films - `chan=407`  : `https://icecast.radiofrance.fr/francemusiquelabo-hifi.aac`
- La Baroque                - `chan=408`  : `https://icecast.radiofrance.fr/francemusiquebaroque-hifi.aac`
- La Contemporaine          - `chan=406`  : `https://icecast.radiofrance.fr/francemusiquelacontemporaine-hifi.aac`
- La Jazz                   - `chan=405`  : `https://icecast.radiofrance.fr/francemusiquelajazz-hifi.aac`
- Ocora Musiques du Monde   - `chan=404`  : `https://icecast.radiofrance.fr/francemusiqueocoramonde-hifi.aac`
- Opéra                     - `chan=409`  : `https://icecast.radiofrance.fr/francemusiqueopera-hifi.aac`

**Now playing**
```sh
chan=CHANNEL
curl -s -m 5 -G \
	--data-urlencode "operationName=Now" \
	--data-urlencode 'variables={"bannerPreset":"600x600-noTransform","stationId":'$chan',"previousTrackLimit":1}' \
	--data-urlencode 'extensions={"persistedQuery":{"version":1,"sha256Hash":"8a931c7d177ff69709a79f4c213bd2403f0c11836c560bc22da55628d8100df8"}}' \
	--data-urlencode "v=$( date +%s )" \
	https://www.fip.fr/latest/api/graphql
```
`.data.now`
- `.server_time` - timestamp (ms)
- `.playing_item`
	- `.title` - artist
	- `.subtitle` - title
	- `.cover`
	- `.end_time` - ms to track change
- `.song.album`
