NGINX Upgrade with pushstream
---
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package

### compile
- NGINX mainline source files: https://archlinuxarm.org/packages/armv7h/nginx-mainline/files
```sh
# remove confilit file (mailcap reinstates it)
pacman -Syu
pacman -S --needed base-devel geoip mailcap

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

# RPi Zero, 1 - setup swap file
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 666 /swapfile
mkswap /swapfile
swapon /swapfile

su alarm
cd
mkdir nginx
cd nginx

# get build scripts
for file in PKGBUILD logrotate service; do
    wget --show-progress https://github.com/archlinux/svntogit-community/raw/packages/nginx-mainline/trunk/$file
done

# customize
pushstreamver=$( curl -s https://api.github.com/repos/wandenberg/nginx-push-stream-module/tags | grep -m 1 '"name":' | cut -d\" -f4 )
sed -i -e 's/^\(pkgname=\).*/\1nginx-mainline-pushstream/
' -e "/^pkgver/ a\
pushstreamver=$pushstreamver
" -e 's/\(package_nginx-mainline\)()/\1-pushstream()/
' -e '/^install/ d
' -e '/^source/ a\
        https://github.com/wandenberg/nginx-push-stream-module/archive/$pushstreamver.tar.gz
' -e '/--with-threads/ a\
  --add-module=/home/alarm/nginx/src/nginx-push-stream-module-$pushstreamver
' PKGBUILD

# set integrity
#makepkg -g >> PKGBUILD

makepkg -A --skipinteg
```
