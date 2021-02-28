### matchbox-window-manager

```sh
pacman -Syu
pacman -S --needed base-devel dbus-glib intltool gtk-doc gobject-introspection git gnome-common \
    libjpeg libpng libsm libxcursor libxext polkit pango startup-notification xsettings-client

# setup distcc
systemctl start distccd

#1 - gconf - depend
su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/gconf.tar.gz | bsdtar xf -
cd gconf
makepkg -A

su
pacman -U gconf*.pkg.tar.xz

#2 - libmatchbox - depend
su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/libmatchbox.tar.gz | bsdtar xf -
cd libmatchbox

sed -i "s/ 'libjpeg>=7'//" PKGBUILD

makepkg -A

su
pacman -U libmatchbox*.pkg.tar.xz

#3 - matchbox-window-manager
su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/matchbox-window-manager.tar.gz | bsdtar xvf -
cd matchbox-window-manager
makepkg -A
```
