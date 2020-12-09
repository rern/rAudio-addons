**pwr_led**: #6`gnd` #8`v+`
```sh
sed -i '$ a\
enable_uart=1
' /boot/config.txt
```

**act_led**: #14`gnd` #18`v+`  
(not available in 0.3)
```sh
sed -i '$ a\
dtparam=pi3-act-led,gpio=24
' /boot/config.txt
```
<img src="https://github.com/rern/_assets/blob/master/RuneUI_GPIO/RPi3_GPIO.svg" width="600">
