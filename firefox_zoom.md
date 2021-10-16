## Set Firefox zoom + fullscreen

### Zoom
`user.js`
```sh
dirfirefox=/root/.mozilla/firefox
profile=$( grep -m1 Default $dirfirefox/profiles.ini | cut -d= -f2 )
echo 'user_pref("layout.css.devPixelsPerPx", "1");' > $dirfirefox/$profile/user.js
```
zoom level `devPixelsPerPx`:
- `"1"` = 100%
- Can be decimal
- Must be quoted

### Fullscreen mode
```
firefox -kiosk http://localhost
```
