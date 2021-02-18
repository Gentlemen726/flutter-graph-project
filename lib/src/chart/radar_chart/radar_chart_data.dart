import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef GetTitleByIndexFunction = String Function(int index);

class RadarChartData extends BaseChartData {
  //ToDo(payam) : document data classes
  RadarChartData({
    this.dataSets = const [],
    this.fillColor = Colors.transparent,
    this.chartBorderData = const BorderSide(color: Colors.black, width: 2),
    this.radarTouchData,
    this.getTitle,
    @required this.titleCount,
    this.titleTextStyle = const TextStyle(color: Colors.black, fontSize: 12),
    this.titlePositionPercentageOffset = 0.2,
    @required this.tickCount,
    this.ticksTextStyle = const TextStyle(color: Colors.black, fontSize: 9),
    this.tickBorderData = const BorderSide(color: Colors.black, width: 2),
    this.gridBorderData = const BorderSide(color: Colors.black, width: 2),
    FlBorderData borderData,
  })  : assert(dataSets != null, "the dataSets field can't be null"),
        assert(titleCount != null && titleCount >= 2, "RadarChart need's more then 2 titles"),
        assert(tickCount != null && tickCount >= 2, "RadarChart need's more then 2 ticks"),
        assert(
          titlePositionPercentageOffset >= 0 && titlePositionPercentageOffset <= 1,
          'titlePositionPercentageOffset must be something between 0 and 1 ',
        ),
        assert(
          dataSets.firstWhere(
                (element) => element.dataEntries.length != titleCount,
                orElse: () => null,
              ) ==
              null,
          'dataSets value count must be equal to titleCount value',
        ),
        super(borderData: borderData, touchData: radarTouchData);

  final List<RadarDataSet> dataSets;

  final Color fillColor;
  final BorderSide chartBorderData;

  final GetTitleByIndexFunction getTitle;
  final int titleCount;
  final TextStyle titleTextStyle;

  /// the [titlePositionPercentageOffset] is the place of showing title on the section
  /// the degree is statically on the center of each section,
  /// but the radius of drawing is depend of this field,
  /// this field should be between 0 and 1,
  /// if it is 0 the title will be drawn near the inside section,
  /// if it is 1 the title will be drawn near the outside of section,
  /// the default value is 0.5, means it draw on the center of section.
  final double titlePositionPercentageOffset;

  final int tickCount;
  final TextStyle ticksTextStyle;
  final BorderSide tickBorderData;

  final BorderSide gridBorderData;

  final RadarTouchData radarTouchData;

  RadarEntry get maxEntry {
    var maximum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets) {
      for (final entry in dataSet.dataEntries) {
        if (entry.value > maximum.value) maximum = entry;
      }
    }
    return maximum;
  }

  RadarEntry get minEntry {
    var minimum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets) {
      for (final entry in dataSet.dataEntries) {
        if (entry.value < minimum.value) minimum = entry;
      }
    }

    return minimum;
  }

  @override
  RadarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is RadarChartData && b is RadarChartData && t != null) {
      return RadarChartData(
        dataSets: lerpRadarDataSetList(a.dataSets, b.dataSets, t),
        fillColor: Color.lerp(a.fillColor, b.fillColor, t),
        getTitle: b.getTitle,
        titleCount: lerpInt(a.titleCount, b.titleCount, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        titlePositionPercentageOffset: lerpDouble(
          a.titlePositionPercentageOffset,
          b.titlePositionPercentageOffset,
          t,
        ),
        tickCount: lerpInt(a.tickCount, b.tickCount, t),
        ticksTextStyle: TextStyle.lerp(a.ticksTextStyle, b.ticksTextStyle, t),
        gridBorderData: BorderSide.lerp(a.gridBorderData, b.gridBorderData, t),
        chartBorderData: BorderSide.lerp(a.chartBorderData, b.chartBorderData, t),
        tickBorderData: BorderSide.lerp(a.tickBorderData, b.tickBorderData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        radarTouchData: b.radarTouchData,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        borderData,
        touchData,
        dataSets,
        fillColor,
        chartBorderData,
        getTitle,
        titleCount,
        titleTextStyle,
        titlePositionPercentageOffset,
        tickCount,
        ticksTextStyle,
        tickBorderData,
        gridBorderData,
        radarTouchData,
      ];
}

class RadarDataSet extends Equatable {
  const RadarDataSet({
    this.dataEntries = const [],
    @required this.fillColor,
    @required this.borderColor,
    this.borderWidth = 2,
    this.entryRadius = 5.0,
  });

  final List<RadarEntry> dataEntries;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double entryRadius;

  static RadarDataSet lerp(RadarDataSet a, RadarDataSet b, double t) {
    return RadarDataSet(
      dataEntries: lerpRadarEntryList(a.dataEntries, b.dataEntries, t),
      fillColor: Color.lerp(a.fillColor, b.fillColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      entryRadius: lerpDouble(a.entryRadius, b.entryRadius, t),
    );
  }

  @override
  List<Object> get props => [
        dataEntries,
        fillColor,
        borderColor,
        borderWidth,
        entryRadius,
      ];
}

class RadarEntry extends Equatable {
  final double value;

  const RadarEntry({this.value = 0});

  static RadarEntry lerp(RadarEntry a, RadarEntry b, double t) {
    return RadarEntry(value: lerpDouble(a.value, b.value, t));
  }

  @override
  List<Object> get props => [value];
}

class RadarTouchData extends FlTouchData {
  /// you can implement it to receive touches callback
  final Function(RadarTouchResponse) touchCallback;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  final bool enableNormalTouch;

  RadarTouchData({
    bool enabled = true,
    this.enableNormalTouch,
    this.touchCallback,
    this.touchSpotThreshold = 10,
  }) : super(enabled);

  @override
  List<Object> get props => [
        enabled,
        touchSpotThreshold,
        enableNormalTouch,
        touchCallback,
      ];
}

class RadarTouchResponse extends BaseTouchResponse {
  final RadarTouchedSpot touchedSpot;

  RadarTouchResponse(
    this.touchedSpot,
    FlTouchInput touchInput,
  ) : super(touchInput);

  @override
  List<Object> get props => [
        touchedSpot,
        touchInput,
      ];
}

class RadarTouchedSpot extends TouchedSpot {
  final RadarDataSet touchedDataSet;
  final int touchedDataSetIndex;

  final RadarEntry touchedRadarEntry;
  final int touchedRadarEntryIndex;

  RadarTouchedSpot(
    this.touchedDataSet,
    this.touchedDataSetIndex,
    this.touchedRadarEntry,
    this.touchedRadarEntryIndex,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);

  Color getColor() {
    return Colors.black;
  }

  @override
  List<Object> get props => [
        spot,
        offset,
        touchedDataSet,
        touchedDataSetIndex,
        touchedRadarEntry,
        touchedRadarEntryIndex,
      ];
}

class RadarChartDataTween extends Tween<RadarChartData> {
  RadarChartDataTween({
    RadarChartData begin,
    RadarChartData end,
  }) : super(begin: begin, end: end);

  @override
  RadarChartData lerp(double t) => begin.lerp(begin, end, t);
}
