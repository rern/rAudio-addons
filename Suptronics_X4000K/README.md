Suptronics X4000K - ES9018K2M
---

![X4000K](https://github.com/rern/rAudio-addons/raw/main/Suptronics_X4000K/X4000K.jpg)

### Hardware
- 1st layer spacers: shorter ones with threaded tips
- Fixed base spacers:
	- threads are very tight - beware head cut off
	- should fix only front-left and rear-right
- Audio output jumpers: move all 3 to `RPi I2S` on the right

### Software  
**HDMI**
- HDMI on X4000 cannot auto switch to a proper mode - no output on local screen
- Append `hdmi_group=n` and `hdmi_mode=n` to `/boot/config.txt`
- Initial power on there will be no output until reboot 

**Audio** (RuneAudio 0.4b)
- Menu > Settings
	- I²S kernel modules = `RPI DAC` (via HDMI)
		- `Apply Settings`
		- Reboot
- Menu > MPD
	- Audio output interface = `I-Sabre DAC (I²S)`
	- Volume control = `disabled` (for better sound quality)
	- (no need - for USB only) DSD support = `DSD (native)`
		- `Save and Apply`
- Support up to **DSD128** (DSD256 - stuttering)
