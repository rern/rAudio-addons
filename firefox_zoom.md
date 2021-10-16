## Launch Firefox with zoom + fullscreen

### Zoom
`user.js`
```sh
dirfirefox=/root/.mozilla/firefox
profile=$( grep -m1 Default $dirfirefox/profiles.ini | cut -d= -f2 )
echo 'user_pref("layout.css.devPixelsPerPx", "1");' > $dirfirefox/$profile/user.js
firefox -kiosk http://localhost
```
`devPixelsPerPx` zoom level: `"1"` = 100% (can be decimal and must be quoted)
