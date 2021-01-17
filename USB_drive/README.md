USB Ddrive Detection Rules
---

**Reload new rules**
- `udevadm control --reload-rules && udevadm trigger`

**Create rules**
- Remove USB drive
- `udevadm monitor --udev`
- Plug in USB drive
```sh
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing

UDEV  [251306.151356] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2 (usb)
UDEV  [251306.164429] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0 (usb)
UDEV  [251306.166471] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1 (scsi)
UDEV  [251306.169205] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/scsi_host/host1 (scsi_host)
UDEV  [251306.173747] bind     /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0 (usb)
UDEV  [251306.179710] bind     /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2 (usb)
UDEV  [251307.193293] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0 (scsi)
UDEV  [251307.197564] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0 (scsi)
UDEV  [251307.200548] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/scsi_device/1:0:0:0 (scsi_device)
UDEV  [251307.204784] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/scsi_disk/1:0:0:0 (scsi_disk)
UDEV  [251307.205357] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/bsg/1:0:0:0 (bsg)
UDEV  [251307.232332] add      /devices/virtual/bdi/8:16 (bdi)
UDEV  [251307.295521] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/block/sdb (block)
UDEV  [251307.432967] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/block/sdb/sdb1 (block)
UDEV  [251307.446161] bind     /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0 (scsi)
```

**udev.rules**
```sh
ACTION=="add|remove", KERNEL=="block*", SUBSYSTEM=="sd*[0-9]", RUN+="/srv/http/bash/cmd.sh usbdrive"
ACTION=="add|remove", KERNEL=="block*", SUBSYSTEM=="sd*[0-9]", RUN+="/srv/http/bash/cmd.sh usbdrive$'\n'remove"
```
- from following info:

- `udevadm info --path=/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/block/sdb/sdb1 --attribute-walk`
```sh
Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/host1/target1:0:0/1:0:0:0/block/sdb/sdb1':
    KERNEL=="sdb1"
    SUBSYSTEM=="block"
    DRIVER==""
    ATTR{alignment_offset}=="0"
    ATTR{discard_alignment}=="0"
    ATTR{inflight}=="       0        0"
    ATTR{partition}=="1"
    ATTR{power/control}=="auto"
    ATTR{power/runtime_active_time}=="0"
    ATTR{power/runtime_status}=="unsupported"
    ATTR{power/runtime_suspended_time}=="0"
    ATTR{ro}=="0"
    ATTR{size}=="60086272"
    ATTR{start}=="2048"
    ATTR{stat}=="     393        1     7276      434        0        0        0        0        0      430        0        0        0        0        0"

  ...
```
