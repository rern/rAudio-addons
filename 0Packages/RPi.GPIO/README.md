### Python RPi.GPIO
Source: [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)

```sh
pacman -Syu
pacman -S --needed base-devel

# setup distcc
systemctl start distccd

su alarm
cd
mkdir rpigpio
cd rpigpio
wget https://github.com/rern/rAudio-addons/raw/main/0Packages/RPi.GPIO/PKGBUILD
makepkg -A
```
