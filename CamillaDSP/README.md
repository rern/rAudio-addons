CamillaDSP
---

[CamillaDSP](https://github.com/HEnquist/camilladsp)
- Compile
```sh
pacman -Sy cargo pkg-config
wget https://github.com/HEnquist/camilladsp/archive/refs/heads/master.zip
bsdtar xf master.zip
cd camilla-master
cargo build --release
cp target/release/camilladsp /usr/bin
```

- On-board audio - `/etc/camilladsp.yml`
```yml
  ...
  playback:
    ..
    device: hw:0,0
    format: S16LE
  ...
```
