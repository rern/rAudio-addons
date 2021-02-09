### Python RPi.GPIO
Source: [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)

```sh
pacman -Syu
pacman -S --needed base-devel

su alarm
cd
mkdir rpigpio
cd rpigpio
wget https://github.com/rern/rAudio-addons/raw/main/0Packages/RPi.GPIO/PKGBUILD

# get version
wget -qO - https://sourceforge.net/p/raspberry-gpio-python/code/ci/default/tree/CHANGELOG.txt

makepkg -A --skipinteg
```