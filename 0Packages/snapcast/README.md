### Synchronous multi-room audio player
Source: [Snapcast](https://github.com/badaix/snapcast)
```sh
pacman -Syu
pacman -S --needed alsa-utils base-devel boost cmake git

# setup distcc
systemctl start distccd

su alarm
cd

curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/snapcast.tar.gz | bsdtar xf -
cd snapcast
makepkg -A
```


### Configuration
**mpd.conf**
```sh
audio_output {
	type           "fifo"
	name           "snapcast"
	path           "/tmp/snapfifo"
	format         "48000:16:2"
	mixer_type     "software"
}
```
**Server**
```sh
systemctl start snapserver
```
**Client**
```sh
systemctl start snapclient
```
