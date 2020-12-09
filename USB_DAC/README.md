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
```sh
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
- `ACTION=="add|remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/srv/http/settings/mpdconf.sh"`
- from following info:

- `udevadm info --path=/sys/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/sound/card1 --attribute-walk`
```sh
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

  looking at parent device '/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0':
    KERNELS=="1-1.5:1.0"
    SUBSYSTEMS=="usb"
    DRIVERS=="snd-usb-audio"
    ATTRS{iad_bFunctionClass}=="01"
    ATTRS{interface}=="xCORE USB Audio 2.0"
    ATTRS{authorized}=="1"
    ATTRS{bNumEndpoints}=="00"
    ATTRS{bInterfaceNumber}=="00"
    ATTRS{supports_autosuspend}=="1"
    ATTRS{iad_bFunctionProtocol}=="20"
    ATTRS{iad_bInterfaceCount}=="03"
    ATTRS{bInterfaceSubClass}=="01"
    ATTRS{iad_bFunctionSubClass}=="00"
    ATTRS{bInterfaceProtocol}=="20"
    ATTRS{bAlternateSetting}==" 0"
    ATTRS{iad_bFirstInterface}=="00"
    ATTRS{bInterfaceClass}=="01"

  looking at parent device '/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5':
    KERNELS=="1-1.5"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{avoid_reset_quirk}=="0"
    ATTRS{configuration}==""
    ATTRS{devnum}=="6"
    ATTRS{product}=="xCORE USB Audio 2.0"
    ATTRS{version}==" 2.00"
    ATTRS{urbnum}=="100"
    ATTRS{manufacturer}=="XMOS"
    ATTRS{removable}=="removable"
    ATTRS{bMaxPacketSize0}=="64"
    ATTRS{devspec}=="  (null)"
    ATTRS{devpath}=="1.5"
    ATTRS{bmAttributes}=="c0"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{bNumConfigurations}=="2"
    ATTRS{maxchild}=="0"
    ATTRS{bDeviceSubClass}=="02"
    ATTRS{bMaxPower}=="0mA"
    ATTRS{authorized}=="1"
    ATTRS{tx_lanes}=="1"
    ATTRS{idVendor}=="20b1"
    ATTRS{speed}=="480"
    ATTRS{idProduct}=="000a"
    ATTRS{bNumInterfaces}==" 4"
    ATTRS{bDeviceProtocol}=="01"
    ATTRS{rx_lanes}=="1"
    ATTRS{bDeviceClass}=="ef"
    ATTRS{ltm_capable}=="no"
    ATTRS{bcdDevice}=="0660"
    ATTRS{busnum}=="1"
    ATTRS{quirks}=="0x0"

  looking at parent device '/devices/platform/soc/3f980000.usb/usb1/1-1':
    KERNELS=="1-1"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{rx_lanes}=="1"
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{version}==" 2.00"
    ATTRS{maxchild}=="5"
    ATTRS{idVendor}=="0424"
    ATTRS{busnum}=="1"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{idProduct}=="9514"
    ATTRS{urbnum}=="81"
    ATTRS{authorized}=="1"
    ATTRS{configuration}==""
    ATTRS{quirks}=="0x0"
    ATTRS{ltm_capable}=="no"
    ATTRS{speed}=="480"
    ATTRS{bDeviceProtocol}=="02"
    ATTRS{bDeviceSubClass}=="00"
    ATTRS{devnum}=="2"
    ATTRS{devpath}=="1"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{removable}=="unknown"
    ATTRS{bDeviceClass}=="09"
    ATTRS{bmAttributes}=="e0"
    ATTRS{avoid_reset_quirk}=="0"
    ATTRS{bMaxPacketSize0}=="64"
    ATTRS{bcdDevice}=="0200"
    ATTRS{bMaxPower}=="2mA"
    ATTRS{tx_lanes}=="1"

  looking at parent device '/devices/platform/soc/3f980000.usb/usb1':
    KERNELS=="usb1"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{manufacturer}=="Linux 4.19.76-1-ARCH dwc_otg_hcd"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{bDeviceSubClass}=="00"
    ATTRS{bDeviceProtocol}=="01"
    ATTRS{devpath}=="0"
    ATTRS{bMaxPower}=="0mA"
    ATTRS{authorized_default}=="1"
    ATTRS{bDeviceClass}=="09"
    ATTRS{bcdDevice}=="0419"
    ATTRS{ltm_capable}=="no"
    ATTRS{serial}=="3f980000.usb"
    ATTRS{busnum}=="1"
    ATTRS{idProduct}=="0002"
    ATTRS{maxchild}=="1"
    ATTRS{rx_lanes}=="1"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{configuration}==""
    ATTRS{urbnum}=="25"
    ATTRS{bmAttributes}=="e0"
    ATTRS{tx_lanes}=="1"
    ATTRS{speed}=="480"
    ATTRS{bMaxPacketSize0}=="64"
    ATTRS{quirks}=="0x0"
    ATTRS{version}==" 2.00"
    ATTRS{removable}=="unknown"
    ATTRS{interface_authorized_default}=="1"
    ATTRS{idVendor}=="1d6b"
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{authorized}=="1"
    ATTRS{product}=="DWC OTG Controller"
    ATTRS{avoid_reset_quirk}=="0"
    ATTRS{devnum}=="1"

  looking at parent device '/devices/platform/soc/3f980000.usb':
    KERNELS=="3f980000.usb"
    SUBSYSTEMS=="platform"
    DRIVERS=="dwc_otg"
    ATTRS{gpvndctl}=="GPVNDCTL = 0x00000000"
    ATTRS{mode_ch_tim_en}=="Mode Change Ready Timer Enable = 0x0"
    ATTRS{ggpio}=="GGPIO = 0x00000000"
    ATTRS{guid}=="GUID = 0x2708a000"
    ATTRS{remote_wakeup}=="Remote Wakeup Sig = 0 Enabled = 0 LPM Remote Wakeup = 0"
    ATTRS{fr_interval}=="Frame Interval = 0x1d4b"
    ATTRS{rd_reg_test}=="Time to read GNPTXFSIZ reg 10000000 times: 750 msecs (75 jiffies)"
    ATTRS{hcd_frrem}=="HCD Dump Frame Remaining"
    ATTRS{regvalue}=="invalid offset"
    ATTRS{hprt0}=="HPRT0 = 0x00001005"
    ATTRS{spramdump}=="SPRAM Dump"
    ATTRS{hnp}=="HstNegScs = 0x0"
    ATTRS{srpcapable}=="SRPCapable = 0x1"
    ATTRS{wr_reg_test}=="Time to write GNPTXFSIZ reg 10000000 times: 340 msecs (34 jiffies)"
    ATTRS{hcddump}=="HCD Dump"
    ATTRS{devspeed}=="Device Speed = 0x0"
    ATTRS{gotgctl}=="GOTGCTL = 0x001c0001"
    ATTRS{enumspeed}=="Device Enumeration Speed = 0x1"
    ATTRS{gnptxfsiz}=="GNPTXFSIZ = 0x01000306"
    ATTRS{driver_override}=="(null)"
    ATTRS{hptxfsiz}=="HPTXFSIZ = 0x02000406"
    ATTRS{srp}=="SesReqScs = 0x1"
    ATTRS{rem_wakeup_pwrdn}==""
    ATTRS{regdump}=="Register Dump"
    ATTRS{gusbcfg}=="GUSBCFG = 0x20001700"
    ATTRS{busconnected}=="Bus Connected = 0x1"
    ATTRS{hnpcapable}=="HNPCapable = 0x1"
    ATTRS{bussuspend}=="Bus Suspend = 0x0"
    ATTRS{inv_sel_hsic}=="Invert Select HSIC = 0x0"
    ATTRS{hsic_connect}=="HSIC Connect = 0x1"
    ATTRS{grxfsiz}=="GRXFSIZ = 0x00000306"
    ATTRS{buspower}=="Bus Power = 0x1"
    ATTRS{mode}=="Mode = 0x1"
    ATTRS{regoffset}=="0xffffffff"
    ATTRS{gsnpsid}=="GSNPSID = 0x4f54280a"

  looking at parent device '/devices/platform/soc':
    KERNELS=="soc"
    SUBSYSTEMS=="platform"
    DRIVERS==""
    ATTRS{driver_override}=="(null)"

  looking at parent device '/devices/platform':
    KERNELS=="platform"
    SUBSYSTEMS==""
    DRIVERS==""
```
