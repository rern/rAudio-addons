### mpdscribble
Source: [mpdscribble](https://github.com/MusicPlayerDaemon/mpdscribble)
```sh
pacman -Syu
pacman -S --needed base-devel boost libmpdclient libsoup meson ninja

# setup distcc
systemctl start distccd

su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/mpdscribble.tar.gz | bsdtar xf -
cd mpdscribble
makepkg -A
```


### Configue
```sh
cp /usr/share/mpdscribble/mpdscribble.conf.example /etc/mpdscribble.conf
sed -i -e 's/^\(username =\).*/\1 USERNAME/
' -e 's/^\(password =\).*/\1 PASSWORD/
' /etc/mpdscribble.conf

mpdscribble
```
### mpdscribble.service
```sh
[Unit]
Description=MPD last.fm scrobbler
Requires=mpd.service
After=mpd.service

[Service]
Type=idle
ExecStart=/usr/bin/mpdscribble -D

[Install]
WantedBy=multi-user.target
```
