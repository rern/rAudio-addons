## upmpdcli

An UPnP Audio Media Renderer based on MPD. [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/)
```sh
pacman -Syu
pacman -S --needed base-devel aspell-en id3lib git jsoncpp libmicrohttpd libmpdclient libupnp python-bottle python-mutagen python-requests python-setuptools python-waitress recoll

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

# libnpupnp - depend 1
su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/libnpupnp.tar.gz \
    | bsdtar xf -
cd libnpupnp

# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg

su
pacman -U libnpupnp*.pkg.tar.xz

# libupnpp - depend 2
su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz \
    | bsdtar xf -
cd libupnpp

# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg

su
pacman -U libupnpp*.pkg.tar.xz

# upmpdcli
su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz \
    | bsdtar xf -
cd upmpdcli

# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

# fix: errors on build with multicores
sed -i 's/\(MAKEFLAGS=\).*/\1"-j1"/' /etc/makepkg.conf

makepkg -A --skipinteg

# upload and upload and update RR repo
wget https://github.com/rern/RuneOS/raw/master/repoupdate.sh -O - | sh
```
