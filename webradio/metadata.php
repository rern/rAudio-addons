#!/usr/bin/php

<?php
// usage  : ./metadata.php URL

// source : https://gist.github.com/fracasula/5781710

$url = $argv[ 1 ];
$context = stream_context_create( [
	'http' => [
		'method'     => 'GET',
		'header'     => 'Icy-MetaData: 1',
	]
] );
$headers = get_headers( $url, false, $context );
foreach ( $headers as $h ) {
	if ( strpos( strtolower( $h ), 'icy-metaint' ) !== false ) {
		$interval = explode( ':', $h )[ 1 ];
		break;
	}
}
$stream = fopen( $url, 'r', false, $context );
$buffer = stream_get_contents( $stream, $interval, $interval );
fclose( $stream );
$title = explode( 'StreamTitle=', $buffer )[ 1 ];
echo substr( $title, 1, strpos( $title, ';' ) - 2 );
