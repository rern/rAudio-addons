USB DAC Plug and Play
---
As of 20190822, this has been integrated to [**RuneAudio+R e1**](https://github.com/rern/RuneAudio-Re1).

Automatically switch to/from MPD Audio output and reload configuration:
- USB DAC **power on** - switch to **USB DAC**
- USB DAC **power off** - switch to **preset** Audio output

**Reload new rules**
- `udevadm control --reload-rules && udevadm trigger`

**Create rules**
- Power off USB DAC
- `udevadm monitor --udev`
- Power on USB DAC
```
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing

UDEV  [2278.307838] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1/controlC1 (sound)
UDEV  [2278.308763] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1/pcmC1D0p (sound)
UDEV  [2278.313349] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1/pcmC1D0c (sound)
UDEV  [2278.318647] unbind   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.1 (usb)
UDEV  [2278.318890] unbind   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.2 (usb)
UDEV  [2278.319047] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.1 (usb)
UDEV  [2278.319225] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.3 (usb)
UDEV  [2278.319350] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.2 (usb)
UDEV  [2278.333652] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1 (sound)
UDEV  [2278.343672] unbind   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0 (usb)
UDEV  [2278.347395] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0 (usb)
UDEV  [2278.355274] unbind   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5 (usb)
UDEV  [2278.355643] remove   /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5 (usb)
```

**udev.rules**
```
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/srv/http/settings/mpd-conf.sh add"
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/srv/http/settings/mpd-conf.sh remove"
```
- from following info:

- `udevadm info --path=/sys/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1 --attribute-walk`
```
Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1':
    KERNEL=="card1"
    SUBSYSTEM=="sound"
    DRIVER==""
    ATTR{id}=="x20"
    ATTR{number}=="1"

  ...
```
