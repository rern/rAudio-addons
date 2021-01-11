<html>
<head>
	<style>
		#divvu {
			width: 230px;
			height: 230px;
			background: #000000;
		}
		#vuneedel {
			margin: -185px 115px;
			transform: rotate( -28.5deg);
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
<script>

var needel = document.getElementById( 'vuneedel' );
function vu() {
	var deg = 0;
	var inc;
	vuInt = setInterval( function() {
		inc = Math.random() * 40
		deg += inc;
		if ( deg < -28 ) {
			deg = -28 + inc;
		} else if ( deg > 11 ) {
			deg = 11 - inc;
		}
		needel.style.transform = 'rotate( '+ deg +'deg )';
	}, 1000 );
}
function vuStop() {
	clearInterval( vuInt );
	needel.style.transform = 'rotate( -28.5deg )';
}
//vu();

</script>
</body>
</html>
