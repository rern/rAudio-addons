#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."
#----------------------------------------------------------------------------------
file=/srv/http/app/libs/runeaudio.php
echo $file

commentS 'Audio output switched'
#----------------------------------------------------------------------------------
file=/etc/udev/rules.d/rune_usb-audio.rules
rm $file
# long running script must run with systemd ( TAG+= not work here )
cat << 'EOF' > /etc/udev/rules.d/usbdac.rules
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/usr/bin/systemctl start usbdacon.service"
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/usr/bin/systemctl start usbdacoff.service"
EOF
#----------------------------------------------------------------------------------
echo -e "$bar Add files ..."
file=/root/usbdac
echo $file

cat << 'EOF' > $file
#!/usr/bin/php

<?php
$redis = new Redis();
$redis->pconnect( '127.0.0.1' );
include '/srv/http/app/libs/runeaudio.php';

wrk_mpdconf( $redis, 'refresh' );

if ( $argc > 1 ) {
	// "exec" gets only last line which is new power-on card
	$ao = exec( '/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2' );
	$name = $ao;
} else {
	$ao = $redis->get( 'aodefault' );
	$acards = $redis->hGetAll( 'acards' );
	foreach( $acards as $key => $value ) {
		if ( $key === $ao ) {
			$value = json_decode( $value );
			$name = $value->extlabel ?: $value->name;
			break;
		}
	}
}
ui_render( 'notify', json_encode( array( 'title' => 'Audio Output Switched', 'text' => $name, 'icon' => 'output' ) ) );
wrk_mpdconf( $redis, 'switchao', $ao );
EOF

chmod +x /root/usbdac
#----------------------------------------------------------------------------------
unitfile() {
    file=/etc/systemd/system/$2.service
	echo $file
	
    cat << EOF > $file
[Unit]
Description=Hotplug USB DAC
After=multi-user.target
[Service]
Type=oneshot
ExecStart=/root/usbdac $1
EOF
}
unitfile on usbdacon
unitfile '' usbdacoff
#----------------------------------------------------------------------------------
udevadm control --reload-rules
systemctl restart systemd-udevd

redis-cli set aodefault "$1" &> /dev/null

installfinish $@
