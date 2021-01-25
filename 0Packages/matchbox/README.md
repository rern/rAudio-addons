### matchbox-window-manager

```sh
pacman -Syu
pacman -S --needed base-devel  dbus-glib intltool gtk-doc gobject-introspection git gnome-common

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

#1 - gconf - depend
su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/gconf.tar.gz | bsdtar xf -
cd gconf
makepkg -A

su
pacman -U libmatchbox*.pkg.tar.xz

#2 - libmatchbox - depend
su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/libmatchbox.tar.gz | bsdtar xf -
cd libmatchbox
sed -i "s/ 'libjpeg>=7'//" PKGBUILD
makepkg -A

su
pacman -U libmatchbox*.pkg.tar.xz

#3 - matchbox-window-manager
su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/matchbox-window-manager.tar.gz | bsdtar xvf -
cd matchbox-window-manager
makepkg -A

# upload and update RR repo
wget -qO - https://github.com/rern/rOS/raw/main/repoupdate.sh | sh
```
