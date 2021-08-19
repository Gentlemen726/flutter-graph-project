import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';

/// [BarChart] needs this class to render itself.
///
/// It holds data needed to draw a bar chart,
/// including bar lines, colors, spaces, touches, ...
class BarChartData extends AxisChartData with EquatableMixin {
  /// [BarChart] draws [barGroups] that each of them contains a list of [BarChartRodData].
  final List<BarChartGroupData> barGroups;

  /// Apply space between the [barGroups].
  final double groupsSpace;

  /// Arrange the [barGroups], see [BarChartAlignment].
  final BarChartAlignment alignment;

  /// Titles on left, top, right, bottom axis for each number.
  final FlTitlesData titlesData;

  /// Handles touch behaviors and responses.
  final BarTouchData barTouchData;

  /// [BarChart] draws some [barGroups] and aligns them using [alignment],
  /// if [alignment] is [BarChartAlignment.center], you can define [groupsSpace]
  /// to apply space between them.
  ///
  /// It draws some titles on left, top, right, bottom sides per each axis number,
  /// you can modify [titlesData] to have your custom titles,
  /// also you can define the axis title (one text per axis) for each side
  /// using [axisTitleData], you can restrict the y axis using [minX], and [maxY] values.
  ///
  /// It draws a color as a background behind everything you can set it using [backgroundColor],
  /// then a grid over it, you can customize it using [gridData],
  /// and it draws 4 borders around your chart, you can customize it using [borderData].
  ///
  /// You can annotate some regions with a highlight color using [rangeAnnotations].
  ///
  /// You can modify [barTouchData] to customize touch behaviors and responses.
  BarChartData({
    List<BarChartGroupData>? barGroups,
    double? groupsSpace,
    BarChartAlignment? alignment,
    FlTitlesData? titlesData,
    BarTouchData? barTouchData,
    FlAxisTitleData? axisTitleData,
    double? maxY,
    double? minY,
    FlGridData? gridData,
    FlBorderData? borderData,
    RangeAnnotations? rangeAnnotations,
    Color? backgroundColor,
  })  : barGroups = barGroups ?? const [],
        groupsSpace = groupsSpace ?? 16,
        alignment = alignment ?? BarChartAlignment.spaceBetween,
        titlesData = titlesData ?? FlTitlesData(),
        barTouchData = barTouchData ?? BarTouchData(),
        super(
            axisTitleData: axisTitleData ?? FlAxisTitleData(),
            gridData: gridData ??
                FlGridData(
                  show: false,
                ),
            borderData: borderData,
            rangeAnnotations: rangeAnnotations ?? RangeAnnotations(),
            backgroundColor: backgroundColor,
            touchData: barTouchData ?? BarTouchData(),
            minX: 0,
            maxX: 1,
            maxY: maxY ?? BarChartHelper.calculateMaxAxisValues(barGroups ?? []).maxY,
            minY: minY ?? BarChartHelper.calculateMaxAxisValues(barGroups ?? []).minY);

  /// Copies current [BarChartData] to a new [BarChartData],
  /// and replaces provided values.
  BarChartData copyWith({
    List<BarChartGroupData>? barGroups,
    double? groupsSpace,
    BarChartAlignment? alignment,
    FlTitlesData? titlesData,
    FlAxisTitleData? axisTitleData,
    RangeAnnotations? rangeAnnotations,
    BarTouchData? barTouchData,
    FlGridData? gridData,
    FlBorderData? borderData,
    double? maxY,
    double? minY,
    Color? backgroundColor,
  }) {
    return BarChartData(
      barGroups: barGroups ?? this.barGroups,
      groupsSpace: groupsSpace ?? this.groupsSpace,
      alignment: alignment ?? this.alignment,
      titlesData: titlesData ?? this.titlesData,
      axisTitleData: axisTitleData ?? this.axisTitleData,
      rangeAnnotations: rangeAnnotations ?? this.rangeAnnotations,
      barTouchData: barTouchData ?? this.barTouchData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      maxY: maxY ?? this.maxY,
      minY: minY ?? this.minY,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  BarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData) {
      return BarChartData(
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        groupsSpace: lerpDouble(a.groupsSpace, b.groupsSpace, t),
        alignment: b.alignment,
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        axisTitleData: FlAxisTitleData.lerp(a.axisTitleData, b.axisTitleData, t),
        rangeAnnotations: RangeAnnotations.lerp(a.rangeAnnotations, b.rangeAnnotations, t),
        barTouchData: b.barTouchData,
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        minY: lerpDouble(a.minY, b.minY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        barGroups,
        groupsSpace,
        alignment,
        titlesData,
        barTouchData,
        axisTitleData,
        maxY,
        minY,
        gridData,
        borderData,
        rangeAnnotations,
        backgroundColor,
      ];
}

/// defines arrangement of [barGroups], check [MainAxisAlignment] for more details.
enum BarChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

/// Represents a group of rods (or bars) inside the [BarChart].
///
/// in the [BarChart] we have some rods, they can be grouped or not,
/// if you want to have grouped bars, simply put them in each group,
/// otherwise just pass one of them in each group.
class BarChartGroupData with EquatableMixin {
  /// defines the group's value among the x axis (simply set it incrementally).
  @required
  final int x;

  /// [BarChart] renders [barRods] that represents a rod (or a bar) in the bar chart.
  final List<BarChartRodData> barRods;

  /// [BarChart] applies [barsSpace] between [barRods].
  final double barsSpace;

  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [BarChartRodData] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  final List<int> showingTooltipIndicators;

  /// [BarChart] renders groups, and arrange them using [alignment],
  /// [x] value defines the group's value in the x axis (set them incrementally).
  /// it renders a list of [BarChartRodData] that represents a rod (or a bar) in the bar chart,
  /// and applies [barsSpace] between them.
  ///
  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [BarChartRodData] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  BarChartGroupData({
    required int x,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  })  : x = x,
        barRods = barRods ?? const [],
        barsSpace = barsSpace ?? 2,
        showingTooltipIndicators = showingTooltipIndicators ?? const [];

  /// width of the group (sum of all [BarChartRodData]'s width and spaces)
  double get width {
    if (barRods.isEmpty) {
      return 0;
    }

    final sumWidth =
        barRods.map((rodData) => rodData.width).reduce((first, second) => first + second);
    final spaces = (barRods.length - 1) * barsSpace;

    return sumWidth + spaces;
  }

  /// Copies current [BarChartGroupData] to a new [BarChartGroupData],
  /// and replaces provided values.
  BarChartGroupData copyWith({
    int? x,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  }) {
    return BarChartGroupData(
      x: x ?? this.x,
      barRods: barRods ?? this.barRods,
      barsSpace: barsSpace ?? this.barsSpace,
      showingTooltipIndicators: showingTooltipIndicators ?? this.showingTooltipIndicators,
    );
  }

  /// Lerps a [BarChartGroupData] based on [t] value, check [Tween.lerp].
  static BarChartGroupData lerp(BarChartGroupData a, BarChartGroupData b, double t) {
    return BarChartGroupData(
      x: (a.x + (b.x - a.x) * t).round(),
      barRods: lerpBarChartRodDataList(a.barRods, b.barRods, t),
      barsSpace: lerpDouble(a.barsSpace, b.barsSpace, t),
      showingTooltipIndicators:
          lerpIntList(a.showingTooltipIndicators, b.showingTooltipIndicators, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x,
        barRods,
        barsSpace,
        showingTooltipIndicators,
      ];
}

/// Holds data about rendering each rod (or bar) in the [BarChart].
class BarChartRodData with EquatableMixin {
  /// [BarChart] renders rods vertically from zero to [y].
  final double y;

  /// if you pass just one color, the solid color will be used,
  /// or if you pass more than one color, we use gradient mode to draw.
  /// then the [gradientFrom], [gradientTo] and [colorStops] is important,
  final List<Color> colors;

  /// Determines the start point of gradient,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right.
  final Offset gradientFrom;

  /// Determines the end point of gradient,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right.
  final Offset gradientTo;

  /// if more than one color provided gradientColorStops will hold
  /// stop points of the gradient.
  final List<double>? colorStops;

  /// [BarChart] renders each rods with this value.
  final double width;

  /// If you want to have a rounded rod, set this value.
  final BorderRadius? borderRadius;

  /// If you want to have a border for rod, set this value.
  final BorderSide borderSide;

  /// If you want to have a bar drawn in rear of this rod, use [backDrawRodData],
  /// it uses to have a bar with a passive color in rear of the rod,
  /// for example you can use it as the maximum value place holder.
  final BackgroundBarChartRodData backDrawRodData;

  /// If you are a fan of stacked charts (If you don't know what is it, google it),
  /// you can fill up the [rodStackItems] to have a Stacked Chart.
  final List<BarChartRodStackItem> rodStackItems;

  /// [BarChart] renders rods vertically from zero to [y],
  /// and the x is equivalent to the [BarChartGroupData.x] value.
  ///
  /// It renders each rod using [color], [width], and [borderRadius] for rounding corners and also [borderSide] for stroke border.
  ///
  /// If you want to have a bar drawn in rear of this rod, use [backDrawRodData],
  /// it uses to have a bar with a passive color in rear of the rod,
  /// for example you can use it as the maximum value place holder.
  ///
  /// If you are a fan of stacked charts (If you don't know what is it, google it),
  /// you can fill up the [rodStackItems] to have a Stacked Chart.
  /// for example if you want to have a Stacked Chart with three colors:
  /// ```
  /// BarChartRodData(
  ///   y: 9,
  ///   color: Colors.grey,
  ///   rodStackItems: [
  ///     BarChartRodStackItem(0, 3, Colors.red),
  ///     BarChartRodStackItem(3, 6, Colors.green),
  ///     BarChartRodStackItem(6, 9, Colors.blue),
  ///   ]
  /// )
  /// ```
  BarChartRodData({
    required double y,
    List<Color>? colors,
    Offset? gradientFrom,
    Offset? gradientTo,
    List<double>? gradientColorStops,
    double? width,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    BackgroundBarChartRodData? backDrawRodData,
    List<BarChartRodStackItem>? rodStackItems,
  })  : y = y,
        colors = colors ?? [Colors.cyan],
        gradientFrom = gradientFrom ?? const Offset(0.5, 1),
        gradientTo = gradientTo ?? const Offset(0.5, 0),
        colorStops = gradientColorStops,
        width = width ?? 8,
        borderRadius = normalizeBorderRadius(borderRadius, width ?? 8),
        borderSide = normalizeBorderSide(borderSide, width ?? 8),
        backDrawRodData = backDrawRodData ?? BackgroundBarChartRodData(),
        rodStackItems = rodStackItems ?? const [];

  /// Copies current [BarChartRodData] to a new [BarChartRodData],
  /// and replaces provided values.
  BarChartRodData copyWith({
    double? y,
    List<Color>? colors,
    Offset? gradientFrom,
    Offset? gradientTo,
    List<double>? colorStops,
    double? width,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    BackgroundBarChartRodData? backDrawRodData,
    List<BarChartRodStackItem>? rodStackItems,
  }) {
    return BarChartRodData(
      y: y ?? this.y,
      colors: colors ?? this.colors,
      gradientFrom: gradientFrom ?? this.gradientFrom,
      gradientTo: gradientTo ?? this.gradientTo,
      gradientColorStops: colorStops ?? this.colorStops,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      backDrawRodData: backDrawRodData ?? this.backDrawRodData,
      rodStackItems: rodStackItems ?? this.rodStackItems,
    );
  }

  /// Lerps a [BarChartRodData] based on [t] value, check [Tween.lerp].
  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) {
    return BarChartRodData(
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      colors: lerpColorList(a.colors, b.colors, t),
      gradientColorStops: lerpDoubleList(a.colorStops, b.colorStops, t),
      width: lerpDouble(a.width, b.width, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
      y: lerpDouble(a.y, b.y, t)!,
      backDrawRodData: BackgroundBarChartRodData.lerp(a.backDrawRodData, b.backDrawRodData, t),
      rodStackItems: lerpBarChartRodStackList(a.rodStackItems, b.rodStackItems, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        y,
        width,
        borderRadius,
        borderSide,
        backDrawRodData,
        rodStackItems,
        colors,
        gradientFrom,
        gradientTo,
        colorStops,
      ];
}

/// A colored section of Stacked Chart rod item
///
/// Each [BarChartRodData] can have a list of [BarChartRodStackItem] (with different colors
/// and position) to represent a Stacked Chart rod,
class BarChartRodStackItem with EquatableMixin {
  /// Renders a Stacked Chart section from [fromY]
  final double fromY;

  /// Renders a Stacked Chart section to [toY]
  final double toY;

  /// Renders a Stacked Chart section with [color]
  final Color color;

  /// Renders border stroke for a Stacked Chart section
  final BorderSide borderSide;

  /// Renders a section of Stacked Chart from [fromY] to [toY] with [color]
  /// for example if you want to have a Stacked Chart with three colors:
  /// ```
  /// BarChartRodData(
  ///   y: 9,
  ///   color: Colors.grey,
  ///   rodStackItems: [
  ///     BarChartRodStackItem(0, 3, Colors.red),
  ///     BarChartRodStackItem(3, 6, Colors.green),
  ///     BarChartRodStackItem(6, 9, Colors.blue),
  ///   ]
  /// )
  /// ```
  BarChartRodStackItem(this.fromY, this.toY, this.color, [this.borderSide = DefaultBorderSide]);

  /// Copies current [BarChartRodStackItem] to a new [BarChartRodStackItem],
  /// and replaces provided values.
  BarChartRodStackItem copyWith(
      {double? fromY, double? toY, Color? color, BorderSide? borderSide}) {
    return BarChartRodStackItem(
        fromY ?? this.fromY, toY ?? this.toY, color ?? this.color, borderSide ?? this.borderSide);
  }

  /// Lerps a [BarChartRodStackItem] based on [t] value, check [Tween.lerp].
  static BarChartRodStackItem lerp(BarChartRodStackItem a, BarChartRodStackItem b, double t) {
    return BarChartRodStackItem(lerpDouble(a.fromY, b.fromY, t)!, lerpDouble(a.toY, b.toY, t)!,
        Color.lerp(a.color, b.color, t)!, BorderSide.lerp(a.borderSide, b.borderSide, t));
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [fromY, toY, color, borderSide];
}

/// Holds values to draw a rod in rear of the main rod.
///
/// If you want to have a bar drawn in rear of the main rod, use [BarChartRodData.backDrawRodData],
/// it uses to have a bar with a passive color in rear of the rod,
/// for example you can use it as the maximum value place holder in rear of your rod.
class BackgroundBarChartRodData with EquatableMixin {
  /// Determines to show or hide this
  final bool show;

  /// [y] is the height of this rod
  final double y;

  /// if you pass just one color, the solid color will be used,
  /// or if you pass more than one color, we use gradient mode to draw.
  /// then the [gradientFrom], [gradientTo] and [colorStops] is important,
  final List<Color> colors;

  /// Determines the start point of gradient,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right.
  final Offset gradientFrom;

  /// Determines the end point of gradient,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right.
  final Offset gradientTo;

  /// if more than one color provided gradientColorStops will hold
  /// stop points of the gradient.
  final List<double>? colorStops;

  /// It will be rendered in rear of the main rod,
  /// with [y] as the height, and [color] as the fill color,
  /// you prevent to show it, using [show] property.
  BackgroundBarChartRodData({
    double? y,
    bool? show,
    List<Color>? colors,
    Offset? gradientFrom,
    Offset? gradientTo,
    List<double>? colorStops,
  })  : y = y ?? 8,
        show = show ?? false,
        colors = colors ?? [Colors.blueGrey],
        gradientFrom = gradientFrom ?? const Offset(0, 0),
        gradientTo = gradientTo ?? const Offset(1, 0),
        colorStops = colorStops;

  /// Lerps a [BackgroundBarChartRodData] based on [t] value, check [Tween.lerp].
  static BackgroundBarChartRodData lerp(
      BackgroundBarChartRodData a, BackgroundBarChartRodData b, double t) {
    return BackgroundBarChartRodData(
      y: lerpDouble(a.y, b.y, t),
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      colors: lerpColorList(a.colors, b.colors, t),
      colorStops: lerpDoubleList(a.colorStops, b.colorStops, t),
      show: b.show,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        y,
        colors,
        gradientTo,
        gradientFrom,
        colorStops,
      ];
}

/// Holds data to handle touch events, and touch responses in the [BarChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart's renderer captures the touch events, and passes the pointerEvent
/// to the painter, and gets touched spot, and wraps it into a concrete [BarTouchResponse].
class BarTouchData extends FlTouchData with EquatableMixin {
  /// Configs of how touch tooltip popup.
  final BarTouchTooltipData touchTooltipData;

  /// Distance threshold to handle the touch event.
  final EdgeInsets touchExtraThreshold;

  /// Determines to handle touches on the back draw bar.
  final bool allowTouchBarBackDraw;

  /// Determines to handle default built-in touch responses,
  /// [BarTouchResponse] shows a tooltip popup above the touched spot.
  final bool handleBuiltInTouches;

  /// Informs the touchResponses
  final Function(BarTouchResponse)? touchCallback;

  /// You can disable or enable the touch system using [enabled] flag,
  /// if [handleBuiltInTouches] is true, [BarChart] shows a tooltip popup on top of the bars if
  /// touch occurs (or you can show it manually using, [BarChartGroupData.showingTooltipIndicators]),
  /// You can customize this tooltip using [touchTooltipData].
  /// If you need to have a distance threshold for handling touches, use [touchExtraThreshold].
  /// If [allowTouchBarBackDraw] sets to true, touches will work
  /// on [BarChartRodData.backDrawRodData] too (by default it only works on the main rods).
  ///
  /// You can listen to touch events using [touchCallback],
  /// It gives you a [BarTouchResponse] that contains some
  /// useful information about happened touch.
  BarTouchData({
    bool? enabled,
    BarTouchTooltipData? touchTooltipData,
    EdgeInsets? touchExtraThreshold,
    bool? allowTouchBarBackDraw,
    bool? handleBuiltInTouches,
    Function(BarTouchResponse)? touchCallback,
  })  : touchTooltipData = touchTooltipData ?? BarTouchTooltipData(),
        touchExtraThreshold = touchExtraThreshold ?? const EdgeInsets.all(4),
        allowTouchBarBackDraw = allowTouchBarBackDraw ?? false,
        handleBuiltInTouches = handleBuiltInTouches ?? true,
        touchCallback = touchCallback,
        super(enabled ?? true);

  /// Copies current [BarTouchData] to a new [BarTouchData],
  /// and replaces provided values.
  BarTouchData copyWith({
    bool? enabled,
    BarTouchTooltipData? touchTooltipData,
    EdgeInsets? touchExtraThreshold,
    bool? allowTouchBarBackDraw,
    bool? handleBuiltInTouches,
    Function(BarTouchResponse)? touchCallback,
  }) {
    return BarTouchData(
      enabled: enabled ?? this.enabled,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      touchExtraThreshold: touchExtraThreshold ?? this.touchExtraThreshold,
      allowTouchBarBackDraw: allowTouchBarBackDraw ?? this.allowTouchBarBackDraw,
      handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchTooltipData,
        touchExtraThreshold,
        allowTouchBarBackDraw,
        handleBuiltInTouches,
        touchCallback,
      ];
}

/// Controls showing tooltip on top or bottom.
enum TooltipDirection {
  /// Tooltip shows on top if value is positive, on bottom if value is negative.
  auto,

  /// Tooltip always shows on top.
  top,

  /// Tooltip always shows on bottom.
  bottom,
}

/// Holds representation data for showing tooltip popup on top of rods.
class BarTouchTooltipData with EquatableMixin {
  /// The tooltip background color.
  final Color tooltipBgColor;

  /// Sets a rounded radius for the tooltip.
  final double tooltipRoundedRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Applies a bottom margin for showing tooltip on top of rods.
  final double tooltipMargin;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetBarTooltipItem getTooltipItem;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// Controls showing tooltip on top or bottom, default is auto.
  final TooltipDirection direction;

  /// Controls the rotation of the tooltip.
  final double rotateAngle;

  /// if [BarTouchData.handleBuiltInTouches] is true,
  /// [BarChart] shows a tooltip popup on top of rods automatically when touch happens,
  /// otherwise you can show it manually using [BarChartGroupData.showingTooltipIndicators].
  /// Tooltip shows on top of rods, with [tooltipBgColor] as a background color,
  /// and you can set corner radius using [tooltipRoundedRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding],
  /// or If you want to have a bottom margin, set [tooltipMargin].
  /// Content of the tooltip will provide using [getTooltipItem] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [BarChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  BarTouchTooltipData({
    Color? tooltipBgColor,
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    double? tooltipMargin,
    double? maxContentWidth,
    GetBarTooltipItem? getTooltipItem,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    TooltipDirection? direction,
    double? rotateAngle,
  })  : tooltipBgColor = tooltipBgColor ?? Colors.blueGrey.darken(15),
        tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipMargin = tooltipMargin ?? 16,
        maxContentWidth = maxContentWidth ?? 120,
        getTooltipItem = getTooltipItem ?? defaultBarTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        direction = direction ?? TooltipDirection.auto,
        rotateAngle = rotateAngle ?? 0.0,
        super();

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        tooltipBgColor,
        tooltipRoundedRadius,
        tooltipPadding,
        tooltipMargin,
        maxContentWidth,
        getTooltipItem,
        fitInsideHorizontally,
        fitInsideVertically,
        rotateAngle,
      ];
}

/// Provides a [BarTooltipItem] for showing content inside the [BarTouchTooltipData].
///
/// You can override [BarTouchTooltipData.getTooltipItem], it gives you
/// [group], [groupIndex], [rod], and [rodIndex] that touch happened on,
/// then you should and pass your custom [BarTooltipItem] to show inside the tooltip popup.
typedef GetBarTooltipItem = BarTooltipItem? Function(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
);

/// Default implementation for [BarTouchTooltipData.getTooltipItem].
BarTooltipItem? defaultBarTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  final textStyle = TextStyle(
    color: rod.colors.first,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.y.toString(), textStyle);
}

/// Holds data needed for showing custom tooltip content.
class BarTooltipItem with EquatableMixin {
  /// Text of the content.
  final String text;

  /// TextStyle of the showing content.
  final TextStyle textStyle;

  /// TextAlign of the showing content.
  final TextAlign textAlign;

  /// Direction of showing text.
  final TextDirection textDirection;

  /// List<TextSpan> add further style and format to the text of the tooltip
  final List<TextSpan>? children;

  /// content of the tooltip, is a [text] String with a [textStyle],
  /// [textDirection] and optional [children].
  BarTooltipItem(
    this.text,
    this.textStyle, {
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.children,
  });

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        text,
        textStyle,
        textAlign,
        textDirection,
        children,
      ];
}

/// [BarChart]'s touch callback.
typedef BarTouchCallback = void Function(BarTouchResponse);

/// Holds information about touch response in the [BarChart].
///
/// You can override [BarTouchData.touchCallback] to handle touch events,
/// it gives you a [BarTouchResponse] and you can do whatever you want.
class BarTouchResponse extends BaseTouchResponse {
  /// Gives information about the touched spot
  final BarTouchedSpot? spot;

  /// If touch happens, [BarChart] processes it internally and passes out a BarTouchedSpot
  /// that contains a [spot], it gives you information about the touched spot.
  /// [touchInput] is the type of happened touch.
  /// [clickHappened] will be true, if we detect a click event.
  BarTouchResponse(
    BarTouchedSpot? spot,
    PointerEvent touchInput,
    bool clickHappened,
  )   : spot = spot,
        super(touchInput, clickHappened);

  /// Copies current [BarTouchResponse] to a new [BarTouchResponse],
  /// and replaces provided values.
  BarTouchResponse copyWith({
    BarTouchedSpot? spot,
    PointerEvent? touchInput,
    bool? clickHappened,
  }) {
    return BarTouchResponse(
      spot ?? this.spot,
      touchInput ?? this.touchInput,
      clickHappened ?? this.clickHappened,
    );
  }
}

/// It gives you information about the touched spot.
class BarTouchedSpot extends TouchedSpot with EquatableMixin {
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupIndex;

  final BarChartRodData touchedRodData;
  final int touchedRodDataIndex;

  /// It can be null, if nothing found
  final BarChartRodStackItem? touchedStackItem;

  /// It can be -1, if nothing found
  final int touchedStackItemIndex;

  /// When touch happens, a [BarTouchedSpot] returns as a output,
  /// it tells you where the touch happened.
  /// [touchedBarGroup], and [touchedBarGroupIndex] tell you in which group touch happened,
  /// [touchedRodData], and [touchedRodDataIndex] tell you in which rod touch happened,
  /// [touchedStackItem], and [touchedStackItemIndex] tell you in which rod stack touch happened
  /// ([touchedStackItemIndex] means nothing found).
  /// You can also have the touched x and y in the chart as a [FlSpot] using [spot] value,
  /// and you can have the local touch coordinates on the screen as a [Offset] using [offset] value.
  BarTouchedSpot(
    BarChartGroupData touchedBarGroup,
    int touchedBarGroupIndex,
    BarChartRodData touchedRodData,
    int touchedRodDataIndex,
    BarChartRodStackItem? touchedStackItem,
    int touchedStackItemIndex,
    FlSpot spot,
    Offset offset,
  )   : touchedBarGroup = touchedBarGroup,
        touchedBarGroupIndex = touchedBarGroupIndex,
        touchedRodData = touchedRodData,
        touchedRodDataIndex = touchedRodDataIndex,
        touchedStackItem = touchedStackItem,
        touchedStackItemIndex = touchedStackItemIndex,
        super(spot, offset);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        touchedBarGroup,
        touchedBarGroupIndex,
        touchedRodData,
        touchedRodDataIndex,
        touchedStackItem,
        touchedStackItemIndex,
        spot,
        offset,
      ];
}

/// It lerps a [BarChartData] to another [BarChartData] (handles animation for updating values)
class BarChartDataTween extends Tween<BarChartData> {
  BarChartDataTween({required BarChartData begin, required BarChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [BarChartData] based on [t] value, check [Tween.lerp].
  @override
  BarChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
