### Bluetooth Audio ALSA Backend
Source: [bluealsa](https://github.com/Arkq/bluez-alsa)

```sh
pacman -Syu
pacman -S --needed base-devel bluez bluez-libs bluez-utils git libfdk-aac python-docutils sbc

# setup distcc
systemctl start distccd

su alarm
cd
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/bluez-alsa-git.tar.gz | bsdtar xf -
cd bluez-alsa-git

sed -i -e 's/^\(pkgname=bluez-alsa\)-git/\1/
' -e '/^\s\+--enable-aac/ a\
		--enable-ofono\
		--enable-debug
' PKGBUILD

makepkg -A
```
Note: upgrade - uninstall existing then install

---

### unit files
**`/etc/systemd/system/bluetooth.service.d/override.conf`** - BlueZ - main
```sh
[Unit]
After=nginx.service
BindsTo=bluealsa.service bluealsa-aplay.service bluez-authorize.service

[Service]
ExecStartPost=/srv/http/bash/network.sh btset
```
**`network.sh btset`**
```sh
#!/bin/bash
bluetoothctl discoverable yes
bluetoothctl discoverable-timeout 0
bluetoothctl pairable yes
```

**`/etc/systemd/system/bluealsa.service.d/override.conf`** - BlueALSA - enable ALSA for BlueZ
```sh
[Unit]
After=bluetooth.service
Requires=bluetooth.service
```
**`/etc/systemd/system/bluealsa-aplay.service`** - BlueALSA sink - enable receive mode
```sh
[Unit]
Description=Bluetooth audio receiver
After=bluetooth.service
Requires=bluetooth.service

[Service]
Type=Idle
ExecStart=bluealsa-aplay 00:00:00:00:00:00
```
**`/etc/systemd/system/bluez-authorize.service`** - BlueZ auto authorization in receive mode
```sh
[Unit]
Description=Bluetooth auto authorization
After=bluetooth.service
Requires=bluetooth.service

[Service]
Type=Idle
ExecStart=/srv/http/bash/bluez_authorize.py
```
**`bluez-authorize.py`**
```sh
#!/usr/bin/python

import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

AGENT_INTERFACE = 'org.bluez.Agent1'

class Agent(dbus.service.Object):
	@dbus.service.method(AGENT_INTERFACE, in_signature='os', out_signature='')
	def AuthorizeService(self, device, uuid):
		return

	@dbus.service.method(AGENT_INTERFACE, in_signature='o', out_signature='')
	def RequestAuthorization(self, device):
		return

if __name__ == '__main__':
	dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

	bus = dbus.SystemBus()
	path = '/test/autoagent'
    
	Agent(bus, path)
    
	mainloop = GLib.MainLoop()

	obj = bus.get_object('org.bluez', '/org/bluez');
	manager = dbus.Interface(obj, 'org.bluez.AgentManager1')
	manager.RegisterAgent(path, 'NoInputNoOutput')
	manager.RequestDefaultAgent(path)

	mainloop.run()
```
---
### config files
**`/etc/asound.conf`** - change default output for `sink` mode (if not card 0)  
card list: `cat /proc/asound/cards` or `aplay -l`
```sh
defaults.pcm.card N
defaults.ctl.card N
```
`N` = card number  

**`/etc/default/bluealsa`** - enable both send and receive mode
Enable `source` + `sink` mode
```sh
# default: -p a2dp-source
OPTIONS="-p a2dp-source -p a2dp-sink"
```

**`mpd.conf`** - BlueALSA output
```sh
...
# mac=$( bluetoothctl paired-devices | cut -d' ' -f2 )
audio_output {
	name           "Bluetooth"
	device         "bluealsa:DEV=$mac,PROFILE=a2dp"
	type           "alsa"
	mixer_type     "software"
}
```

**`/etc/udev/rules.d/bluetooth.rules`** - configure mpd on connect/disconnect
```sh
ACTION=="add", SUBSYSTEM=="bluetooth", RUN+="/srv/http/bash/mpd-conf.sh bt"
ACTION=="remove", SUBSYSTEM=="bluetooth", RUN+="/srv/http/bash/mpd-conf.sh"
```
---
### run
```sh
# depends for bluez_authorize.py
pacman -Sy python-dbus python-gobject

systemctl daemon-reload
systemctl enable --now bluetooth
```
---

**Commandline** `bluetoothctl`  
- `bluetoothctl scan on` > get MAC
- `bluetoothctl scan off`
- `bluetoothctl trust MAC` - skip PIN authentication and auto reconnect when power on
- `bluetoothctl pair MAC`
- `bluetoothctl connect MAC`

**Session** `bluetoothctl`  
- Pairing while in `bluetoothctl` session will require PIN authentication with phones or tablets.
```sh
bluetoothctl

# search
scan on
# list found devices > Device xx:xx:xx:xx:xx:xx NAME
devices
# connect
trust xx:xx:xx:xx:xx:xx
pair xx:xx:xx:xx:xx:xx

# reconnect paired devices
connect xx:xx:xx:xx:xx:xx

# remove
remove xx:xx:xx:xx:xx:xx
```
**ALSA devices** `bluealsa-aplay`
```sh
# connected Bluetooth audio devices
bluealsa-aplay -l

# available Bluetooth audio PCMs on connected devices
bluealsa-aplay -L
```
**Mixer device** `bluealsa`
```sh
# status
amixer -D bluealsa

# set
control=$( amixer -D bluealsa scontrols | cut -d"'" -f2 )
amixer -D bluealsa sset "$control" 100%
```
