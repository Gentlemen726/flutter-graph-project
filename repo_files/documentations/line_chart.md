# LineChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart.jpg" width="300" >

### How to use
```
FlChart(
   chart: LineChart(
      LineChartData(
         // read about it in the below section
      ),
   ),
);
```

### LineChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|lineBarsData| list of [LineChartBarData ](#LineChartBarData ) to show the chart's lines, they stack and be drawn on top of each other|[]|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)| FlTitlesData()|
|extraLinesData| [ExtraLinesData](#ExtraLinesData) object to hold drawing details of extra horizontal and vertical lines.
|gridData| check the [FlGridData](base_chart.md#FlGridData)|FlGridData()|
|borderData| check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|
|minX| gets minimum x of x axis, if null, value will read from the input lineBars |null|
|maxX| gets maximum x of x axis, if null, value will read from the input lineBars | null|
|minY| gets minimum y of y axis, if null, value will read from the input lineBars | null|
|maxY| gets maximum y of y axis, if null, value will read from the input lineBars | null|
|clipToBorder| clip the chart to the border (prevent drawing outside the border) | false|


### LineChartBarData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines to show or hide the bar line|true|
|spots| list of [FlSpot](base_chart.md#FlSpot)'s x and y coordinates that the line go through it| []
|colors| colors the line, if multiple colors provided it will be gradient|[Colors.redAccent]|
|colorStops| gets the stop positions of the gradient color, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|null|
|barWidth| gets the stroke width of the line bar|2.0|
|isCurved| curves the corners of the line on the spot's positions| false|
|curveSmoothness| smoothness radius of the curve corners (works when isCurved is true) | 0.35|
|isStrokeCapRound| determines whether start and end of the bar line is Qubic or Round | false|
|belowBarData| check the [BelowBarData](#BelowBarData) |BelowBarData()|
|dotData| check the [FlDotData](#FlDotData) | FlDotData()|


### BelowBarData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the below bar|true|
|colors|colors the below bar area, if multiple colors provided it will be gradient|[Colors.blueGrey]|
|gradientFrom|determines start of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(0, 0)|
|gradientTo|determines end of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(1, 0)|
|gradientColorStops|gets the stop positions of the gradient color, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|null|
|belowSpotsLine| draw a line from each spot to the bottom of the chart|[BelowSpotsLine](#BelowSpotsLine)()|


### BelowSpotsLine
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines show or hide the below spots line|true|
|flLineStyle|a [FlLine](base_chart.md#FlLine) object that determines style of the line|[Colors.blueGrey]|
|checkToShowSpotBelowLine|a function to determine whether to show or hide the below line on the given spot|showAllSpotsBelowLine|


### FlDotData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the dots|true|
|dotColor|colors the showing dot|Colors.blue|
|dotSize|size of showing dot|4.0|
|checkToShowDot|a function to determine whether to show or hide the dot on the given spot|showAllDots|


### HorizontalLine
|PropName|Description|default value|
|:-------|:----------|:------------|
|x|draw straight line from bottom to top of the chart with dynamic x value|null|
|color|color of the line|Colors.black|
|strokeWidth|strokeWidth of the line|2|


### VerticalLine
|PropName|Description|default value|
|:-------|:----------|:------------|
|x|draw straight line from left to right of the chart with dynamic y value|null|
|color|color of the line|Colors.black|
|strokeWidth|strokeWidth of the line|2|


### ExtraLinesData
|PropName|Description|default value|
|:-------|:----------|:------------|
|showHorizontalLines|determines to show or hide the horizontal lines|false|
|horizontalLines|list of [HorizontalLine](#HorizontalLine) to draw on the chart|[]|
|showVerticalLines|determines to show or hide the vertical lines|false|
|verticalLines|list of [VerticalLine](#VerticalLine) to draw on the chart|[]|


### some samples
----
##### Sample 1 ([Source Code](/example/lib/line_chart/samples/line_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1.png" width="300" >


##### Sample 2 ([Source Code](/example/lib/line_chart/samples/line_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2.png" width="300" >


##### Sample 3 ([Source Code](/example/lib/line_chart/samples/line_chart_sample3.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_3.png" width="300" >


##### Sample 4 ([Source Code](/example/lib/line_chart/samples/line_chart_sample4.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_4.png" width="300" >


##### Sample 5 ([Source Code](/example/lib/line_chart/samples/line_chart_sample5.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_5.png" width="300" >
