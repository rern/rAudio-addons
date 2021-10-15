## Set Firefox zoom

### Profile Folder
Settings > Help > More Trobleshooting information > Profile Folder

### User preference file
Add `user.js` in the profile folder
```
user_pref("layout.css.devPixelsPerPx", "1");
```
zoom level:
`"1"` 100%
`"1.5"` 150%
`"2"` 200%
