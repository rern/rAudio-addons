Distcc Cross-Compiling
---

### Master - RPi


### Client - x86-64 Arch Linux
- Setup toolchains
```sh
archs=( armv6h armv7h armv8 )
for arch in $archs; do
  wget 
done
for arch in $archs; do
  pacman -U distccd-alarm-$arch
done
```sh

- Build
```sh
pacman -Sy distcc
su USER
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/distccd-alarm.tar.gz | bsdtar xf -
cd distccd-alarm
makepkg -s

su
pacman -U 
```
