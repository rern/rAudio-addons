### Radio Paradise API

- Main Mix      : http://stream.radioparadise.com/flacm
- Mellow Mix    : http://stream.radioparadise.com/mellow-flacm
- Rock Mix      : http://stream.radioparadise.com/rock-flacm
- Eclectic Mix  : http://stream.radioparadise.com/eclectic-flacm

```sh
# current playing
data=$( curl -s -m 5 -G \
    --data-urlencode "bitrate=4" \
    --data-urlencode "info=true" \
    https://api.radioparadise.com/api/get_block )

url=http:$( jq -r .image_base <<< $data )
url+=$( jq -r '.song."0".cover' <<< $data )

echo $url
```
Alternative: http://radioparadise.com/xml/now.xml

**Slideshow**
```sh
images=$( jq -r '.song."0".slideshow' <<< $data | tr ',' ' ' )
for img in$images; do
	wget -q http://img.radioparadise.com/slideshow/720/$img.jpg
done
