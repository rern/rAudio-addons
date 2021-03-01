## upmpdcli

An UPnP Audio Media Renderer based on MPD. [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/)
```sh
pacman -Syu
pacman -S --needed base-devel aspell-en id3lib git jsoncpp libmicrohttpd libmpdclient libupnp python-bottle python-mutagen python-requests python-setuptools python-waitress recoll

# setup distcc
systemctl start distccd

# libnpupnp - depend 1
su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/libnpupnp.tar.gz | bsdtar xf -
cd libnpupnp
makepkg -A

su
pacman -U libnpupnp*.pkg.tar.xz

# libupnpp - depend 2
su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz | bsdtar xf -
cd libupnpp
makepkg -A

su
pacman -U libupnpp*.pkg.tar.xz

# upmpdcli
su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz | bsdtar xf -
cd upmpdcli
makepkg -A
```
