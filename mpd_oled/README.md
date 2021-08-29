mpd_oled
---

## Build binary
- with [`cava`](https://github.com/rern/rern.github.io/tree/master/Packages/cava) already installed
```sh
pacman -Sy --needed base-devel git

su alarm
cd
git clone https://github.com/antiprism/mpd_oled
cd mpd_oled
./bootstrap
CPPFLAGS="-W -Wall -Wno-psabi"
./configure
make
su
make install-strip
```
## Configure
- `/boot/config.txt`
- `/etc/mpd.conf`
- `/etc/modules-load.d/raspberrypi.conf`
- `/etc/systemd/system/mpd_oled.service`
```sh
echo "\
dtparam=i2c_arm=on
dtparam=i2c_arm_baudrate=1200000
" >> /boot/config.txt

echo '
audio_output {
     type           "fifo"
     name           "mpd_oled"
     path           "/tmp/mpd.fifo"
     buffer_time    "1000000"
}
' >> /etc/mpd.conf

echo i2c-dev >> /etc/modules-load.d/raspberrypi.conf

echo "\
[Unit]
Description=MPD OLED Display

[Service]
ExecStart=/usr/local/bin/mpd_oled -o 6 -b 7 -f 25 -k -c 'fifo,/tmp/mpd.fifo'

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/mpd_oled.service
```
