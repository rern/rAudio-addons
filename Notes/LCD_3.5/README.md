## GPIO 3.5" LCD Display
- Pin assignments
![pinout](https://github.com/rern/RuneAudio/raw/master/LCD3.5/pinout.jpg)
	- Can be stacked on top of I2S DAC:
		- I2S DACs exclusively use I2S pin# 12, 35, 38 and 40 (some with extra I2C pin# 3 and 5)
		- LCD with pin# 12 for backlight control - this pin must be cut off to use with I2S DAC.
	
- Driver: `/boot/overlays/tft35a.dtbo`
- Packages: `xf86-video-fbturbo` `xf86-input-evdev` `xinput_calibrator`
	- `/etc/X11/xorg.conf.d/99-fbturbo.conf`
	- `/etc/X11/xorg.conf.d/99-calibration.conf`
	- `/usr/share/X11/xorg.conf.d/45-evdev.conf`
- Files:
	- `/boot/cmdline.txt` (skip if no console text mode)
	- `/boot/config.txt`
	- `/etc/modules-load.d/raspberrypi.conf`

### Installation
```sh
### driver
wget https://github.com/rern/RuneAudio/raw/master/LCD3.5/tft35a.dtbo -P /boot/overlays

### packages
# display
pacman -S xf86-video-fbturbo
sed -i 's/fb0/fb1/' /etc/X11/xorg.conf.d/99-fbturbo.conf

# touchscreen
pacman -S xf86-input-evdev xinput_calibrator
mv /usr/share/X11/xorg.conf.d/{10,45}-evdev.conf
cat << EOF > /etc/X11/xorg.conf.d/99-calibration.conf
Section "InputClass"
    Identifier    "calibration"
    MatchProduct  "ADS7846 Touchscreen"
    Option  "Calibration"  "571 3757 363 3904"
EndSection
EOF

### rpi config (skip if no console text mode)
sed -i '1 s/$/ fbcon=map:10 fbcon=font:ProFont6x11/' /boot/cmdline.txt

echo -n "\
hdmi_force_hotplug=1
dtparam=i2c_arm=on
dtparam=spi=on
dtoverlay=tft35a:rotate=0
" >> /boot/config.txt

echo -n "\
i2c-bcm2708
i2c-dev
" >> /etc/modules-load.d/raspberrypi.conf

reboot
```

### Rotate LCD
`/boot/config.txt`
```sh
# 0, 90, 180, 270 ( 0 - portrait )
dtoverlay=tft35a:rotate=DEGREE

reboot
```
### Rotate touchscreen
`/etc/X11/xorg.conf.d/99-calibration.conf`  

`/etc/X11/lcd0 - portrait`
```sh
Section "InputClass"
    Identifier    "calibration"
    MatchProduct  "ADS7846 Touchscreen"
    Option  "Calibration"  "571 3757 363 3904"
EndSection
```
`/etc/X11/lcd90`
```sh
Section "InputClass"
    Identifier    "calibration"
    MatchProduct  "ADS7846 Touchscreen"
    Option  "Calibration"  "3878 317 558 3842"
    Option  "SwapAxes"     "1"
EndSection
```
`/etc/X11/lcd180`
```sh
Section "InputClass"
    Identifier    "calibration"
    MatchProduct  "ADS7846 Touchscreen"
    Option  "Calibration"  "3740 509 3909 241"
EndSection
```
`/etc/X11/lcd270`
```sh
Section "InputClass"
    Identifier    "calibration"
    MatchProduct  "ADS7846 Touchscreen"
    Option  "Calibration"  "311 3917 3810 449"
    Option  "SwapAxes"     "1"
EndSection
```
### Calibrate touchscreen
`/etc/X11/xorg.conf.d/99-calibration.conf`  
- set default file of each angle to define pointer area. (Otherwise missed clicks.)
- save stdout to 99-calibration.conf
```sh
cp -f /etc/X11/{lcd$degree,xorg.conf.d/99-calibration.conf}
calibrate=$( DISPLAY=:0 xinput_calibrator | sed -n '/Section/,/EndSection/ p' )
if [[ -n $calibrate ]]; then
	echo "$calibrate" > /etc/X11/xorg.conf.d/99-calibration.conf
	systemctl restart localbrowser
fi
```
### Switch to HDMI
```sh
sed -i 's/fb1/fb0/' /etc/X11/xorg.conf.d/99-fbturbo.conf

reboot
```
