### A spotify daemon

Source: [Spotifyd[(https://github.com/Spotifyd/spotifyd)
```sh
pacman -Syu
pacman -S --needed base-devel cargo

# needs rust 1.47 (otherwise runtime error: librespot_tremor::tremor_sys::ov_callbacks)
wget http://tardis.tiny-vps.com/aarm/packages/r/rust/rust-1%3A1.47.0-4-aarch64.pkg.tar.xz
pacman -U rust*

# no distcc for cargo/rust
# utilize all cpu cores - already utilized

# RPi Zero, 1 - setup swap file
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 666 /swapfile
mkswap /swapfile
swapon /swapfile

su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/spotifyd.tar.gz | bsdtar xf -
cd spotifyd
sed -i 's/rustup/rust/' PKGBUILD

makepkg -A
```
