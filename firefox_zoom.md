## Set Firefox zoom + fullscreen

### Profile Folder
- Path: `/root/.mozilla/firefox` (or or GUI: Settings > Help > More Trobleshooting information > Profile Folder)
- Default profile directory: `/root/.mozilla/firefox/profiles.ini` > `Default=NAME.default-release`

### User preference file
Add `user.js` in `/root/.mozilla/firefox/NAME.default-release`
```
user_pref("layout.css.devPixelsPerPx", "1");
```
zoom level:
`"1"` 100%
`"1.5"` 150%
`"2"` 200%

### Fullscreen mode
```
firefox -kiosk http://localhost
```
