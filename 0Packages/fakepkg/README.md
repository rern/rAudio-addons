### fakepkg
Source: [fakepkg](https://github.com/Edenhofer/fakepkg)

```sh
pacman -Syu
pacman -S --needed base-devel

su alarm
cd
mkdir fakepkg
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/fakepkg.tar.gz | bsdtar xf -
cd fakepkg
makepkg -A
```
