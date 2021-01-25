### HFS File System support
Source: [hfsprogs](https://github.com/muflone/pkgbuilds/tree/master/hfsprogs)
```sh
pacman -Syu
pacman -S --needed base-devel
# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/hfsprogs.tar.gz \
    | bsdtar xf -
cd hfsprogs

makepkg -A

# upload and update RR repo
wget -qO - https://github.com/rern/rOS/raw/main/repoupdate.sh | sh
```
