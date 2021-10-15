## Set Firefox zoom + fullscreen

### Zoom
`user.js`
```sh
dirfirefox=/root/.mozilla/firefox
profile=$( grep Default $dirfirefox/installs.ini | cut -d= -f2 )
fileuserjs=$dirfirefox/$profile/user.js

echo 'user_pref("layout.css.devPixelsPerPx", "1");' > $fileuserjs
```
zoom level `devPixelsPerPx`:
- `"1"` 100%
- `"1.5"` 150%
- `"2"` 200%

### Fullscreen mode
```
firefox -kiosk http://localhost
```
