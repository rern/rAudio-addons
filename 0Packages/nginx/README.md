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
mkdir nginx-mainline-pushstream
cd nginx-mainline-pushstream

# get build scripts
getScripts() {
    for file in PKGBUILD logrotate service; do
        wget --show-progress -qO - https://archlinuxarm.org/packages/armv7h/nginx-mainline/files/$file \
            | sed -n '/<pre>/,/<\/pre>/ p' \
            | sed 's/.*<pre><code>\|<\/code><\/pre>//g; s/&amp;/\&/g; s/&lt;/\</g; s/&gt;/\>/g; s/&quot;/\"/g' > $file
    done
}
getScripts

# customize
pushstreamver=$( curl -s https://api.github.com/repos/wandenberg/nginx-push-stream-module/tags | grep -m 1 '"name":' | cut -d\" -f4 )
sed -i -e 's/\(pkgname=.*\)/\1-pushstream/
' -e "/^pkgver/ a\
pushstreamver=$pushstreamver
" -e '/^install/ d
' -e '/^source/ a\
        https://github.com/wandenberg/nginx-push-stream-module/archive/$pushstreamver.tar.gz
' -e '/md5sums/,/)/ d
' -e '/sha512sums/,/)/ d
' -e '/--with-threads/ a\
  --add-module=/home/alarm/nginx-mainline-pushstream/src/nginx-push-stream-module-$pushstreamver
' PKGBUILD

# set integrity
#makepkg -g >> PKGBUILD

makepkg -A --skipinteg

# upload and update RR repo
wget https://github.com/rern/RuneOS/raw/master/repoupdate.sh -O - | sh
```
