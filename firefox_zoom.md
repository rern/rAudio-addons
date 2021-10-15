## Set Firefox zoom + fullscreen

### Zoom
`user.js`
```sh
dirfirefox=/root/.mozilla/firefox
profile=$( grep Default $dirfirefox/installs.ini | cut -d= -f2 )
echo 'user_pref("layout.css.devPixelsPerPx", "1");' > $dirfirefox/$profile/user.js
```
zoom level `devPixelsPerPx`:
- `"1"` 100%
- `"1.5"` 150%
- `"2"` 200%

### Fullscreen mode
```
firefox -kiosk http://localhost
```
