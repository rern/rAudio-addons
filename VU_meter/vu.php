<?php $time = time();?>
<html>
<head>
<meta charset="UTF-8">
<style>
#divvu {
	width: 230px;
	height: 230px;
	background: #000000;
}
#vuneedel {
	margin: -185px 115px;
	transform: rotate( -28.4deg);
	transform-origin: bottom;
	transition-duration: 1500ms;
}
</style>
</head>
<body>
<div id="divvu">
	<img src="vu.svg">
	<svg id="vuneedel" xmlns="http://www.w3.org/2000/svg" width="1px" height="180px" viewBox="0 0 1 180">
		<line style="stroke:#000000;" x1="0.5" y1="180" x2="0.5"/>
	</svg>
</div>
<script src="/assets/js/plugin/jquery-2.2.4.min.<?=$time?>.js"></script>
<script>

function vu() {
	var deg = 0;
	var inc;
	var $needel = $( '#vuneedel' );
	vuInt = setInterval( function() {
		inc = Math.random() * 40
		deg += inc;
		if ( deg < -28 ) {
			deg = -28 + inc;
		} else if ( deg > 12 ) {
			deg = 12 - inc;
		}
		$needel.css( 'transform', 'rotate( '+ deg +'deg )' );
	}, 1000 );
}
function vuStop() {
	clearInterval( vuInt );
	$( '#vuneedel' ).css( 'transform', 'rotate( -28.4deg )' );
}
vu();

</script>
</body>
</html>
