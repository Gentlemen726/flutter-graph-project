library fl_chart;

import 'package:flutter/material.dart';

import 'chart/bar_chart/bar_chart.dart';
import 'chart/base/fl_chart/fl_chart.dart';
import 'chart/base/fl_chart/fl_chart_painter.dart';
import 'chart/line_chart/line_chart.dart';
import 'chart/pie_chart/pie_chart.dart';

export 'chart/bar_chart/bar_chart.dart';
export 'chart/bar_chart/bar_chart_data.dart';
export 'chart/base/fl_axis_chart/fl_axis_chart_data.dart';
export 'chart/base/fl_chart/fl_chart_data.dart';
export 'chart/line_chart/line_chart.dart';
export 'chart/line_chart/line_chart_data.dart';
export 'chart/pie_chart/pie_chart.dart';
export 'chart/pie_chart/pie_chart_data.dart';


/// A widget that holds a [FlChart] class
/// that contains [FlChartPainter] extends from [CustomPainter]
/// to paint the relative content on our [CustomPaint] class
/// [FlChart] is an abstract class and we should use a concrete class
/// such as [LineChart], [BarChart], [PieChart].
class FlChartWidget extends StatefulWidget {
  final FlChart flChart;

  FlChartWidget({
    Key key,
    @required this.flChart,
  }) : super(key: key) {
    if (flChart == null) {
      throw Exception("flChart might not be null");
    }
  }

  @override
  State<StatefulWidget> createState() => _FlChartState();
}

class _FlChartState extends State<FlChartWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.flChart.painter(),
    );
  }
}