mpd_oled
---

## Build binary
```sh
pacman -Sy --needed base-devel git

su alarm
cd
git clone https://github.com/antiprism/mpd_oled
cd mpd_oled
./bootstrap
CPPFLAGS="-W -Wall -Wno-psabi" ./configure
make
su
make install-strip
```
## Configure
- `/boot/config.txt`
```sh
...
dtparam=i2c_arm=on
dtparam=i2c_arm_baudrate=1200000
```
- `/etc/modules-load.d/raspberrypi.conf`
```sh
i2c-dev
```
- `/etc/systemd/system/mpd_oled.service`
```sh
[Unit]
Description=MPD OLED Display

[Service]
ExecStart=/usr/local/bin/mpd_oled -o 6 -b 7 -f 25

[Install]
WantedBy=multi-user.target
```
