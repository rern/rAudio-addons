### A spotify daemon
Source: [Spotifyd](https://github.com/Spotifyd/spotifyd)
```sh
pacman -Syu
pacman -S --needed base-devel cargo

# utilize all cpu cores - already utilized

su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/spotifyd.tar.gz \
    | bsdtar xf -
cd spotifyd

makepkg -A

# upload and update RR repo
wget https://github.com/rern/RuneOS/raw/master/repoupdate.sh -O - | sh
```
