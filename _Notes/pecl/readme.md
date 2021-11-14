### php-pear - `pecl`

```sh
pacman -S --needed  base-devel

su alarm
cd
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/php-pear.tar.gz \
    | bsdtar xf -
cd php-pear

# import key
gpg --keyserver pool.sks-keyservers.net --recv-keys 72A321BAC245F175

makepkg -A
```
