### Synchronous multi-room audio player
Source: [Snapcast](https://github.com/badaix/snapcast)
```sh
pacman -Syu
pacman -S --needed alsa-utils base-devel boost cmake git

# setup distcc

su alarm
cd

#git clone https://github.com/badaix/snapcast.git
#cd snapcast/externals
#git submodule update --init --recursive

curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/snapcast.tar.gz | bsdtar xf -
cd snapcast

systemctl start distccd
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
