#!/bin/bash

. /srv/http/bash/addons.sh

installstart "$1"

pacman -Sy --noconfirm dab-scanner
systemctl enable rtsp-simple-server

cat << 'EOF' > /usr/local/bin/uninstall_dab.sh
#!/bin/bash

. /srv/http/bash/addons.sh

uninstallstart "$1"

systemctl disable --now rtsp-simple-server
pacman -R --noconfirm dab-scanner rtsp-simple-server

uninstallfinish
EOF

chmod +x /usr/local/bin/uninstall_dab.sh

installfinish

echo $info Scan DAB radio: Library update
