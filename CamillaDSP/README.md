CamillaDSP
---

[CamillaDSP](https://github.com/HEnquist/camilladsp)
- Compile
```sh
getVersion() {
	user=HEnquist
	repo=$1
	version=$( curl -I https://github.com/$user/$repo/releases/latest \
				| awk -F'/' '/^location/ {print $NF}' \
				| sed 's/[^v.0-9]//g' )
}

pacman -Sy --needed cargo git pkg-config python-aiohttp python-jsonschema python-matplotlib python-pip python-websocket-client

# binary
su alarm
cd
mkdir camilladsp
getVersion camilladsp
curl -L  https://github.com/HEnquist/camilladsp/archive/refs/tags/$version.tar.gz | bsdtar xf - -C camilladsp
cd camilladsp
cargo build --release
cp target/release/camilladsp /usr/bin
```

- Install
```sh
getVersion() {
	user=HEnquist
	repo=$1
	version=$( curl -I https://github.com/$user/$repo/releases/latest \
				| awk -F'/' '/^location/ {print $NF}' \
				| sed 's/[^v.0-9]//g' )
}

### binary
wget https://github.com/rern/rAudio-addons/raw/main/CamillaDSP/camilladsp -P /usr/bin
chmod +x /usr/bin/camilladsp

### gui
# python libraries
su
cd ..
getVersion pycamilladsp
pip install git+https://github.com/HEnquist/pycamilladsp.git@$version
getVersion pycamilladsp-plo
pip install git+https://github.com/HEnquist/pycamilladsp-plot.git@v0.6.2

getVersion camillagui-backend
wget https://github.com/HEnquist/camillagui-backend/releases/download/$version/camillagui.zip
dir=/srv/http/camillagui
unzip camillagui -d $dir
# fixes
mkdir $dir/coeffs
sed -i -e 's/configs/config/
' -e "s|~/camilladsp|$dir|
" $dir/config/camillagui.yml
cp $dir/{config/camillagui,active_config}.yml
cp $dir/{active,default}_config.yml
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
