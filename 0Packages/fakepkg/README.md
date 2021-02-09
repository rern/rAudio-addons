### fakepkg
Source: [fakepkg](https://github.com/Edenhofer/fakepkg)

```sh
pacman -Syu
pacman -S --needed base-devel

su alarm
cd
mkdir fakepkg
cd fakepkg
wget https://aur.archlinux.org/cgit/aur.git/snapshot/fakepkg.tar.gz
bsdtar xf fakepkg.tar.gz
rm fakepkg.tar.gz

makepkg -A
```
