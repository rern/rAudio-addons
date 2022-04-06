CamillaDSP
---

[CamillaDSP](https://github.com/HEnquist/camilladsp) - A flexible cross-platform IIR and FIR engine for crossovers, room correction etc.

- Required
	- Daemon
		- `camilladsp`
		- `camilladsp.service`
		- `camilladsp.yml`
	- GUI
		- `camillagui` + `camillagui-backend` = `camillagui.zip`
		- Python libraries
			- CamillaDSP: `pycamilladsp`, `pycamilladsp-plot`
			- Standard: `python-aiohttp python-jsonschema python-matplotlib python-numpy python-pip python-websocket python-websocket-client`
		- `camillagui.service`
		- `/path/to/camillagui/config/camillagui.yml` (provided):
			- port: 5005
			- config_dir: "/path/to/camilladsp.yml"
			- coeff_dir: "/path/to/coeffs"
			- default_config: "/path/to/default_config.yml"
			- active_config: "/path/to/active_config.yml"
		- Symlink: `ln -s /path/to/{camilladsp,active_config}.yml`

- Compile binary
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

- Get audio hardware parameters (RPi on-board audio - sample format: S16LE)
```sh
# while playing - get from loopback cardN/pcmNp
grep -r ^format: /proc/asound | sed 's|.*/\(card.\).*:\(format.*\)|\1 \2|'
```
