#!/usr/bin/php

<?php
// extract metadada from stream and convert to utf-8
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
foreach ( $headers as $h ) if ( substr( $h, 0, 11 ) === 'icy-metaint' ) break;
$metaint = substr( $h, 12 ); // icy-metaint: nnnnn
$fopen = fopen( $url, 'r', false, $context );
$stream = stream_get_contents( $fopen, $metaint, $metaint );
fclose( $fopen );
$streamtitle = explode( 'StreamTitle=', $stream )[ 1 ];
$artis_title = substr( $streamtitle, 1, strpos( $streamtitle, ';' ) - 2 );
echo utf8_encode( $artis_title ); // convert iso-8859-1 to utf-8
