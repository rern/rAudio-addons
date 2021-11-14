## Character LCD - 40x4, 20x4, 16x2

With [RPLCD](https://github.com/dbrgn/RPLCD)

### Wiring
**Via I²C board**
- 5V to 3.3V I²C + 5V LCD mod  

	![i2c](https://github.com/rern/rAudio-addons/raw/main/LCD_Character/i2c_backpack_mod.jpg)

```
LCD: • 2 •...............
I²C: • | •GND•VCC•SDA•SCL•
J8:  • 4 • 6 • 1 • 3 • 5 •
```
**Direct**
- With 10k variable resister for contrast
```
LCD: • 1 • 2 • 3 • 4 • 5 • 6 •  •11 •12 •13 •14 •15 •16 •
J8:  • 6 • 4 • | •15 •18 •16 •  •21 •22 •23 •24 • 4 • 6 •
VR:  • L • R • M •
```

### Python modules
```sh
# copy manually
cp -r /source/path/{RPLCD,smbus2} /usr/lib/python3.8/site-packages

# install
pacman -Sy i2c-tools python-pip
pip install RPLCD pigpio smbus2

echo -n "\
i2c-bcm2708
i2c-dev
" >> /etc/modules-load.d/raspberrypi.conf
echo dtparam=i2c_arm=on >> /boot/config.txt
reboot
```

## Test 
```sh
cp /source/path/rplcd-tests.py

# if copied manually
cp -r /source/path/RPLCD-Tests /usr/lib/python3.8/site-packages

# i2c mode - get address
address=0x$( i2cdetect -y $( ls /dev/i2c* | tail -c 2 ) | grep -v '^\s' | cut -d' ' -f2- | tr -d ' \-' | grep . )

## test display
#  - change 'addr' if not '0x27'
#  - change 'cols' and 'rows'
#  - if no texts displayed, try adjusting contrast with blue potentiometer on i2c board
./rplcd-tests.py i2c testsuite expander=PCF8574 addr=0x27 port=1 cols=20 rows=4

# show character map (A00 - with Japanese characters)
./rplcd-tests.py i2c show_charmap expander=PCF8574 addr=0x27 port=1 cols=20 rows=4
```

### Script
```py
#!/usr/bin/python

import sys

cols = 20
rows = 4

### i2c
address = 0x27 # can be integer 39
chip = 'PCF8574'

from RPLCD.i2c import CharLCD
lcd = CharLCD( cols=cols, rows=rows, address=address, i2c_expander=chip )

### gpio
#from RPLCD.gpio import CharLCD
#lcd = CharLCD( cols=cols, rows=rows, numbering_mode=GPIO.BOARD, pin_rs=15, pin_rw=18, pin_e=16, pins_data=[21, 22, 23, 24] )

# argument - string
lines = sys.argv[ 1 ]  # display strings (\r\n as newline)
lcd.clear()
lcd.write_string( lines )
lcd.close()

# read stdin pipe
for line in iter( sys.stdin.readline, b'' ):
    print( line.rstrip() ) # remove newline
```
