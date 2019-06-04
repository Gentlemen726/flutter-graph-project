import 'dart:ui';

import 'package:flutter/material.dart';

import '../base/fl_chart/fl_chart_data.dart';
import 'pie_chart.dart';

/// Holds all data needed to draw [PieChart],
class PieChartData extends FlChartData {
  final List<PieChartSectionData> sections;
  final double centerSpaceRadius;
  final Color centerSpaceColor;

  /// space between sections together
  final double sectionsSpace;

  /// determines where the sections will be drawn value should be (0 to 360),
  /// the default value is 0, it means the sections
  /// will be drawn from 0 degree (zero degree is right/center of a circle).
  final double startDegreeOffset;

  /// we hold this value to determine weight of each [FlBorderData.value].
  double sumValue;

  PieChartData({
    this.sections = const [],
    this.centerSpaceRadius = 80,
    this.centerSpaceColor = Colors.transparent,
    this.sectionsSpace = 2,
    this.startDegreeOffset = 0,
    FlBorderData borderData,
  }) : super(
          borderData: borderData,
        ) {
    sumValue = sections.map((data) => data.value).reduce((first, second) => first + second);
  }
}

/***** PieChartSectionData *****/
/// this class holds data about each section of the pie chart,
class PieChartSectionData {

  /// the [value] is weight of the section,
  /// for example if all values is 25, and we have 4 section,
  /// then the sum is 100 and each section takes 1/4 of whole circle (360/4) degree.
  final double value;
  final Color color;

  /// the [radius] is the width radius of each section
  final double radius;
  final bool showTitle;
  final TextStyle titleStyle;
  final String title;

  /// the [titlePositionPercentageOffset] is the place of showing title on the section
  /// the degree is statically on the center of each section,
  /// but the radius of drawing is depend of this field,
  /// this field should be between 0 and 1,
  /// if it is 0 the title will be drawn near the inside section,
  /// if it is 1 the title will be drawn near the outside of section,
  /// the default value is 0.5, means it draw on the center of section.
  final double titlePositionPercentageOffset;

  PieChartSectionData({
    this.value = 10,
    this.color = Colors.red,
    this.radius = 40,
    this.showTitle = true,
    this.titleStyle =
        const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    this.title = '1',
    this.titlePositionPercentageOffset = 0.5,
  });
}
