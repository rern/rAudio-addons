### MPD - Exclude subdirectories from database
`.mpdignore` contains ignored sibling directories

**Directory Tree**
```sh
/mnt
└────/MPD
     ├────/LocalStorage
     ├────/NAS
     ├────/USB
     │    └────/root
     │         ├────/Movies
     │         ├────/Music
     │         │    ├────/A
     │         │    │    ├────/Artwork
     │         │    │    │    ├────p.jpg
     │         │    │    │    └────q.jpg
     │         │    │    ├────.mpdignore
     │         │    │    ├────a.mp3
     │         │    │    └────b.mp3
     │         │    └────/B
     │         │         ├────/artworks
     │         │         │    ├────r.jpg
     │         │         │    └────s.jpg
     │         │         ├────.mpdignore
     │         │         ├────c.flac
     │         │         └────d.flac
     │         ├────/Others
     │         └────.mpdignore
     └────/Webradio

```
**Exclude all except `Music` at USB root**
```sh
label="usb label"
dir="music directory"
cd "/mnt/MPD/USB/$label"
ls | grep -v "$dir" | tr ' ' '\n' >> .mpdignore

cat .mpdignore
# Movies
# Others
```

**Exclude all `Artwork` and `artworks` subdirectories in `Music`**
```sh
label="usb label"
dir="music directory"
find "/mnt/MPD/USB/$label/$dir" -iname artwork* -type d -execdir sh -c 'echo -e "?rtwork*" > .mpdignore'
```
- `-iname artwork*` case insensitive name with wildcard
- `-type d` only directory
- `-execdir` run command in found directory
- `sh -c` child shell (`-execdir` cannot run command with arguments)
