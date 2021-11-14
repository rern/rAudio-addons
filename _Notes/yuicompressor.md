## Minify js and css
[**yuicompressor**](https://github.com/yui/yuicompressor)
- `0%` and `0deg` converted to `0` bug
```sh
pacman -S jdk10-openjdk

wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar

java -jar yuicompressor-2.4.8.jar /path/file.js -o file.min.js
```
