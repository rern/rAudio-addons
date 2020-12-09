<?php
$file = $_POST[ 'file' ];
$byte = ( $ext === 'DSF' ) ? 56 : 60;
$bin = file_get_contents( $file, false, NULL, $byte, 4 );
$hex = bin2hex( $bin );
if ( $ext === 'DSF' ) {
	$hex = str_split( $hex, 2 );
	$hex = array_reverse( $hex );
	$hex = implode( '', $hex );
}
$bitrate = hexdec( $hex );

echo $bitrate;
