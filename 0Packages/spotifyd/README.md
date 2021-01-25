### A spotify daemon
Source: [Spotifyd](https://github.com/Spotifyd/spotifyd)
```sh
pacman -Syu
pacman -S --needed base-devel cargo

# utilize all cpu cores - already utilized

# RPi Zero, 1 - setup swap file
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 666 /swapfile
mkswap /swapfile
swapon /swapfile

su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/spotifyd.tar.gz \
    | bsdtar xf -
cd spotifyd

makepkg -A
```
[**Upload and upload and update RR repo**](https://github.com/rern/rOS/blob/main/repoupdate.md)
