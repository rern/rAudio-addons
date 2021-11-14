I²S ES9018K2M DAC Board
---
_Tested on RPi3 RuneAudio+R e1_

![board](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/ES9018K2M.jpg)
- [~10$ on ebay](https://www.ebay.com/sch/i.html?_from=R40&_sacat=0&_sop=15&_nkw=es9018k2m+board&rt=nc&LH_BIN=1)
- Support DSD64 DSD128
- Output: RCA and 3.5mm headphone
- Power supply: DC 9-25V via 5.5x2.1mm jack (or AC 7V-0-7V to 18V-0-18V - center tapped transformer via green terminal)
- Input: I²S  
- ![input](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/input.png)  
```
#1  <  RPi #40 (BCM #21)  -  DATA  data
#2  <  RPi #12 (BCM #18)  -  BCK   bit clock
#3  <  RPi #35 (BCM #19)  -  LRCK  left-right clock
#4  -
#5  <  RPi #39            -  GND   ground
```
<img src="https://github.com/rern/_assets/blob/master/RuneUI_GPIO/RPi3_GPIO.svg" width="600">

### Setup
**Hardware**
- Connect I²S wires
- Connect power supply

![jumper](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/jumpers.jpg) ![adapter](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/adapter.jpg)

**Software**  
On RuneAudio+R e1:
- Settings > System > I²S module = `Generic RPI DAC`
