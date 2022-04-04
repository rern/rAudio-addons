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

- Get audio hardware parameters (on-board audio - sample format: S16LE)
```sh
cat /proc/asound/card0/pcm0p/sub0/hw_params
```
