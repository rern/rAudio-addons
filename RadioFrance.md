### Radio France API 

| Station          | `chan` | URL                                                     |
|------------------|--------|---------------------------------------------------------|
| Fip              | 7      | `https://icecast.radiofrance.fr/fip-hifi.aac`           |
| Fip - Electro    | 74     | `https://icecast.radiofrance.fr/fipelectro-hifi.aac`    |
| Fip - Groove     | 66     | `https://icecast.radiofrance.fr/fipgroove-hifi.aac`     |
| Fip - Jazz       | 65     | `https://icecast.radiofrance.fr/fipjazz-hifi.aac`       |
| Fip - Nouveautés | 70     | `https://icecast.radiofrance.fr/fipnouveautes-hifi.aac` |
| Fip - Pop        | 78     | `https://icecast.radiofrance.fr/fippop-hifi.aac`        |
| Fip - Reggae     | 71     | `https://icecast.radiofrance.fr/fipreggae-hifi.aac`     |
| Fip - Rock       | 64     | `https://icecast.radiofrance.fr/fiprock-hifi.aac`       |
| Fip - World      | 69     | `https://icecast.radiofrance.fr/fipworld-hifi.aac`      |
| France Musique            | 4     | `https://icecast.radiofrance.fr/francemusique-hifi.aac`                    |
| Classique Easy            | 401   | `https://icecast.radiofrance.fr/francemusiqueeasyclassique-hifi.aac`       |
| Classique Plus            | 402   | `https://icecast.radiofrance.fr/francemusiqueclassiqueplus-hifi.aac`       |
| Concerts Radio France     | 403   | `https://icecast.radiofrance.fr/francemusiqueconcertsradiofrance-hifi.aac` |
| La B.O. Musiques de Films | 407   | `https://icecast.radiofrance.fr/francemusiquelabo-hifi.aac`                |
| La Baroque                | 408   | `https://icecast.radiofrance.fr/francemusiquebaroque-hifi.aac`             |
| La Contemporaine          | 406   | `https://icecast.radiofrance.fr/francemusiquelacontemporaine-hifi.aac`     |
| La Jazz                   | 405   | `https://icecast.radiofrance.fr/francemusiquelajazz-hifi.aac`              |
| Ocora Musiques du Monde   | 404   | `https://icecast.radiofrance.fr/francemusiqueocoramonde-hifi.aac`          |
| Opéra                     | 409   | `https://icecast.radiofrance.fr/francemusiqueopera-hifi.aac`               |

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
