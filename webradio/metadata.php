#!/usr/bin/php
<?php

// ./metadata.php URL

function getMp3StreamTitle($streamingUrl, $interval, $offset = 0, $headers = true)
{
	$needle = 'StreamTitle=';
	$ua = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36';

	$opts = [
		'http' => [
			'method' => 'GET',
			'header' => 'Icy-MetaData: 1',
			'user_agent' => $ua
		]
	];

	if (($headers = get_headers($streamingUrl))) {
		foreach ($headers as $h) {
			if (strpos(strtolower($h), 'icy-metaint') !== false && ($interval = explode(':', $h)[1])) {
				break;
			}
		}
	}

	$context = stream_context_create($opts);

	if ($stream = fopen($streamingUrl, 'r', false, $context)) {
		$buffer = stream_get_contents($stream, $interval, $offset);
		fclose($stream);

		if (strpos($buffer, $needle) !== false) {
			$title = explode($needle, $buffer)[1];
			echo substr($title, 1, strpos($title, ';') - 2);
		} else {
			return getMp3StreamTitle($streamingUrl, $interval, $offset + $interval, false);
		}
	} else {
		throw new Exception("Unable to open stream [{$streamingUrl}]");
	}
}

getMp3StreamTitle($argv[ 1 ], 19200);
