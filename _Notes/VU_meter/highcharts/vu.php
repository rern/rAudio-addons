<?php $time = time();?>
<html>
<head>
<meta charset="UTF-8">
<style>
#divvu {
	width: 230px;
	height: 230px;
	background-color: #000000;
}
</style>
</head>
<body>
<div id="divvu"><div id="vu"></div></div>
<script src="/assets/js/plugin/jquery-2.2.4.min.<?=$time?>.js"></script>
<script src="/assets/js/plugin/highcharts.<?=$time?>.js"></script>
<script src="/assets/js/plugin/highcharts-more.<?=$time?>.js"></script>  
<script>
$( document ).ready( function() { 
	var options = {
	  chart: {
		  type: 'gauge'
		, backgroundColor: 'none'
		, plotBorderWidth: 2
		, plotBorderColor: '#636769'
		, plotBackgroundColor: '#ffffff'
		, plotBackgroundImage: '/assets/img/vu.svg'
		, height: 130
	}
	, pane: [
		  {
			  startAngle: -28.5
			, endAngle: 28.5
			, background: null
			, center: [ '105px', '215px' ]
			, size: 340
		}
	]
	, yAxis: [
		  {
			  min: -20
			, max: 6
			, lineColor: 'none'
			, minorTickColor: 'none'
			, tickColor: 'none'
			, labels: false
			, pane: 0
		}
	]
	, plotOptions: {
		gauge: {
			  dataLabels: { enabled: false }
			, dial: {
				  borderWidth: 1
				, baseWidth: 1
				, topWidth: 1
				, radius: '107px'
			}
		}
	}
	, series: [ { data: [ -20 ], yAxis: 0 } ]
	, tooltip: { enabled: false }
	, credits: { enabled: false }
	, title: { text: '' }
}
$( '#vu' ).highcharts( options, function ( chart ) {
	setInterval( function () {
		var left = chart.series[0].points[0];
		var inc = (Math.random() - 0.5) * 8;
		var leftVal =  left.y + inc;
		if (leftVal < -20 || leftVal > 6) leftVal = left.y - inc;
		left.update(leftVal, false);
		chart.redraw();
	}, 200 );
} );

});
</script>
</body>
</html>
