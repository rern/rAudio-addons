#!/usr/bin/python

import sys
import os
import configparser
config = configparser.ConfigParser()
conffile = '/etc/lcdchar.conf'
timerfile = '/srv/http/data/shm/lcdchartimer'
if not os.path.exists( conffile ): quit()

os.system( 'killall lcdchartimer.sh &> /dev/null' )

config.read( conffile )
section = 'var'
cols = int( config.get( section, 'cols' ) )
charmap = config.get( section, 'charmap' )
backlight = config.get( section, 'backlight' )

if config.has_option( section, 'address' ):
    address = int( config.get( section, 'address' ), 16 ) # base 16 string > integer ( can be hex or int )
    chip = config.get( section, 'chip' )
else:
    address = ''
    pin_rs = int( config.get( section, 'pin_rs' ) )
    pin_rw = int( config.get( section, 'pin_rw' ) )
    pin_e = int( config.get( section, 'pin_e' ) )
    data = config.get( section, 'pins_data' ).split( ',' )
    data = map( int, data )
    pins_data = list( data )
    
rows = cols == 16 and 2 or 4

if address: # i2c
    from RPLCD.i2c import CharLCD
    lcd = CharLCD( chip, address )
    lcd = CharLCD( cols=cols, rows=rows, charmap=charmap, address=address, i2c_expander=chip, auto_linebreaks=False )
else:
    from RPLCD.gpio import CharLCD
    from RPi import GPIO
    lcd = CharLCD( cols=cols, rows=rows, charmap=charmap, numbering_mode=GPIO.BOARD, pin_rs=pin_rs, pin_rw=pin_rw, pin_e=pin_e, pins_data=pins_data, auto_linebreaks=False )
    
off = 0b00000
on = 0b11111
b = [
    ( off, off, off, off, off, off, off, on ),
    ( off, off, off, off, off, off, on, on ),
    ( off, off, off, off, off, on, on, on ),
    ( off, off, off, off, on, on, on, on ),
    ( off, off, off, on, on, on, on, on ),
    ( off, off, on, on, on, on, on, on ),
    ( off, on, on, on, on, on, on, on ),
    ( on, on, on, on, on, on, on, on )
]
for i in range( 8 ):
    lcd.create_char( i, b[ i - 1 ] )
ib = [ '', '\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07' ]
# cava.conf: framerate = 4, ascii_max_range = 8
for line in iter( sys.stdin.readline, b'' ):
    val = line[:-2].split( ';' )
    str = ''
    for i in val:
        str = str + ib[ int( i ) ]
    lcd.clear()
    lcd.write_string( str )
