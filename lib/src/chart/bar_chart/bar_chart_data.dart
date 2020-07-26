import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

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
    List<BarChartGroupData> barGroups,
    double groupsSpace,
    BarChartAlignment alignment,
    FlTitlesData titlesData,
    BarTouchData barTouchData,
    FlAxisTitleData axisTitleData,
    double maxY,
    double minY,
    FlGridData gridData,
    FlBorderData borderData,
    RangeAnnotations rangeAnnotations,
    Color backgroundColor,
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
        ) {
    initSuperMinMaxValues(maxY, minY);
  }

  /// fills [minX], [maxX], [minY], [maxY] if they are null,
  /// based on the provided [barGroups].
  void initSuperMinMaxValues(
    double maxY,
    double minY,
  ) {
    for (int i = 0; i < barGroups.length; i++) {
      final BarChartGroupData barData = barGroups[i];
      if (barData.barRods == null || barData.barRods.isEmpty) {
        throw Exception('barRods could not be null or empty');
      }
    }

    if (barGroups.isNotEmpty) {
      final canModifyMaxY = maxY == null;
      if (canModifyMaxY) {
        maxY = barGroups[0].barRods[0].y;
      }

      final canModifyMinY = minY == null;
      if (canModifyMinY) {
        minY = 0;
      }

      for (int i = 0; i < barGroups.length; i++) {
        final BarChartGroupData barGroup = barGroups[i];
        for (int j = 0; j < barGroup.barRods.length; j++) {
          final BarChartRodData rod = barGroup.barRods[j];

          if (canModifyMaxY && rod.y > maxY) {
            maxY = rod.y;
          }

          if (canModifyMaxY &&
              rod.backDrawRodData.show &&
              rod.backDrawRodData.y != null &&
              rod.backDrawRodData.y > maxY) {
            maxY = rod.backDrawRodData.y;
          }

          if (canModifyMinY && rod.y < minY) {
            minY = rod.y;
          }

          if (canModifyMinY &&
              rod.backDrawRodData.show &&
              rod.backDrawRodData.y != null &&
              rod.backDrawRodData.y < minY) {
            minY = rod.backDrawRodData.y;
          }
        }
      }
    }

    super.minX = 0;
    super.maxX = 1;
    super.minY = minY ?? 0;
    super.maxY = maxY ?? 1;
  }

  /// Copies current [BarChartData] to a new [BarChartData],
  /// and replaces provided values.
  BarChartData copyWith({
    List<BarChartGroupData> barGroups,
    double groupsSpace,
    BarChartAlignment alignment,
    FlTitlesData titlesData,
    FlAxisTitleData axisTitleData,
    RangeAnnotations rangeAnnotations,
    BarTouchData barTouchData,
    FlGridData gridData,
    FlBorderData borderData,
    double maxY,
    double minY,
    Color backgroundColor,
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
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData && t != null) {
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
  List<Object> get props => [
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
    @required int x,
    List<BarChartRodData> barRods,
    double barsSpace,
    List<int> showingTooltipIndicators,
  })  : x = x,
        barRods = barRods ?? const [],
        barsSpace = barsSpace ?? 2,
        showingTooltipIndicators = showingTooltipIndicators ?? const [],
        assert(x != null);

  /// width of the group (sum of all [BarChartRodData]'s width and spaces)
  double get width {
    if (barRods.isEmpty) {
      return 0;
    }

    final double sumWidth =
        barRods.map((rodData) => rodData.width).reduce((first, second) => first + second);
    final double spaces = (barRods.length - 1) * barsSpace;

    return sumWidth + spaces;
  }

  /// Copies current [BarChartGroupData] to a new [BarChartGroupData],
  /// and replaces provided values.
  BarChartGroupData copyWith({
    int x,
    List<BarChartRodData> barRods,
    double barsSpace,
    List<int> showingTooltipIndicators,
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
  List<Object> get props => [
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

  /// [BarChart] renders each rods using this [color].
  final Color color;

  /// [BarChart] renders each rods with this value.
  final double width;

  /// If you want to have a rounded rod, set this value.
  final BorderRadius borderRadius;

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
  /// It renders each rod using [color], [width], and [borderRadius] for rounding corners.
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
    double y,
    Color color,
    double width,
    BorderRadius borderRadius,
    BackgroundBarChartRodData backDrawRodData,
    List<BarChartRodStackItem> rodStackItems,
  })  : y = y,
        color = color ?? Colors.blueAccent,
        width = width ?? 8,
        borderRadius = normalizeBorderRadius(borderRadius, width ?? 8),
        backDrawRodData = backDrawRodData ?? BackgroundBarChartRodData(),
        rodStackItems = rodStackItems ?? const [];

  /// Copies current [BarChartRodData] to a new [BarChartRodData],
  /// and replaces provided values.
  BarChartRodData copyWith({
    double y,
    Color color,
    double width,
    Radius borderRadius,
    BackgroundBarChartRodData backDrawRodData,
    List<BarChartRodStackItem> rodStackItems,
  }) {
    return BarChartRodData(
      y: y ?? this.y,
      color: color ?? this.color,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      backDrawRodData: backDrawRodData ?? this.backDrawRodData,
      rodStackItems: rodStackItems ?? this.rodStackItems,
    );
  }

  /// Lerps a [BarChartRodData] based on [t] value, check [Tween.lerp].
  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) {
    return BarChartRodData(
      color: Color.lerp(a.color, b.color, t),
      width: lerpDouble(a.width, b.width, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      y: lerpDouble(a.y, b.y, t),
      backDrawRodData: BackgroundBarChartRodData.lerp(a.backDrawRodData, b.backDrawRodData, t),
      rodStackItems: lerpBarChartRodStackList(a.rodStackItems, b.rodStackItems, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        y,
        color,
        width,
        borderRadius,
        backDrawRodData,
        rodStackItems,
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
  BarChartRodStackItem(this.fromY, this.toY, this.color);

  /// Copies current [BarChartRodStackItem] to a new [BarChartRodStackItem],
  /// and replaces provided values.
  BarChartRodStackItem copyWith({
    double fromY,
    double toY,
    Color color,
  }) {
    return BarChartRodStackItem(
      fromY ?? this.fromY,
      toY ?? this.toY,
      color ?? this.color,
    );
  }

  /// Lerps a [BarChartRodStackItem] based on [t] value, check [Tween.lerp].
  static BarChartRodStackItem lerp(BarChartRodStackItem a, BarChartRodStackItem b, double t) {
    return BarChartRodStackItem(
      lerpDouble(a.fromY, b.fromY, t),
      lerpDouble(a.toY, b.toY, t),
      Color.lerp(a.color, b.color, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        fromY,
        toY,
        color,
      ];
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

  /// it will be rendered with filled [color]
  final Color color;

  /// It will be rendered in rear of the main rod,
  /// with [y] as the height, and [color] as the fill color,
  /// you prevent to show it, using [show] property.
  BackgroundBarChartRodData({
    double y,
    bool show,
    Color color,
  })  : y = y ?? 8,
        show = show ?? false,
        color = color ?? Colors.blueGrey;

  /// Lerps a [BackgroundBarChartRodData] based on [t] value, check [Tween.lerp].
  static BackgroundBarChartRodData lerp(
      BackgroundBarChartRodData a, BackgroundBarChartRodData b, double t) {
    return BackgroundBarChartRodData(
      y: lerpDouble(a.y, b.y, t),
      color: Color.lerp(a.color, b.color, t),
      show: b.show,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        show,
        y,
        color,
      ];
}

/// Holds data to handle touch events, and touch responses in the [BarChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [BarTouchResponse].
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
  final Function(BarTouchResponse) touchCallback;

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
    bool enabled,
    BarTouchTooltipData touchTooltipData,
    EdgeInsets touchExtraThreshold,
    bool allowTouchBarBackDraw,
    bool handleBuiltInTouches,
    Function(BarTouchResponse) touchCallback,
  })  : touchTooltipData = touchTooltipData ?? BarTouchTooltipData(),
        touchExtraThreshold = touchExtraThreshold ?? const EdgeInsets.all(4),
        allowTouchBarBackDraw = allowTouchBarBackDraw ?? false,
        handleBuiltInTouches = handleBuiltInTouches ?? true,
        touchCallback = touchCallback,
        super(enabled ?? true);

  /// Copies current [BarTouchData] to a new [BarTouchData],
  /// and replaces provided values.
  BarTouchData copyWith({
    bool enabled,
    BarTouchTooltipData touchTooltipData,
    EdgeInsets touchExtraThreshold,
    bool allowTouchBarBackDraw,
    bool handleBuiltInTouches,
    Function(BarTouchResponse) touchCallback,
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
  List<Object> get props => [
        enabled,
        touchTooltipData,
        touchExtraThreshold,
        allowTouchBarBackDraw,
        handleBuiltInTouches,
        touchCallback,
      ];
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
  final double tooltipBottomMargin;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetBarTooltipItem getTooltipItem;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// if [BarTouchData.handleBuiltInTouches] is true,
  /// [BarChart] shows a tooltip popup on top of rods automatically when touch happens,
  /// otherwise you can show it manually using [BarChartGroupData.showingTooltipIndicators].
  /// Tooltip shows on top of rods, with [tooltipBgColor] as a background color,
  /// and you can set corner radius using [tooltipRoundedRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding],
  /// or If you want to have a bottom margin, set [tooltipBottomMargin].
  /// Content of the tooltip will provide using [getTooltipItem] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [BarChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  BarTouchTooltipData({
    Color tooltipBgColor,
    double tooltipRoundedRadius,
    EdgeInsets tooltipPadding,
    double tooltipBottomMargin,
    double maxContentWidth,
    GetBarTooltipItem getTooltipItem,
    bool fitInsideHorizontally,
    bool fitInsideVertically,
  })  : tooltipBgColor = tooltipBgColor ?? Colors.white,
        tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipBottomMargin = tooltipBottomMargin ?? 16,
        maxContentWidth = maxContentWidth ?? 120,
        getTooltipItem = getTooltipItem ?? defaultBarTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        super();

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        tooltipBgColor,
        tooltipRoundedRadius,
        tooltipPadding,
        tooltipBottomMargin,
        maxContentWidth,
        getTooltipItem,
        fitInsideHorizontally,
        fitInsideVertically,
      ];
}

/// Provides a [BarTooltipItem] for showing content inside the [BarTouchTooltipData].
///
/// You can override [BarTouchTooltipData.getTooltipItem], it gives you
/// [group], [groupIndex], [rod], and [rodIndex] that touch happened on,
/// then you should and pass your custom [BarTooltipItem] to show inside the tooltip popup.
typedef GetBarTooltipItem = BarTooltipItem Function(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
);

/// Default implementation for [BarTouchTooltipData.getTooltipItem].
BarTooltipItem defaultBarTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  const TextStyle textStyle = TextStyle(
    color: Colors.black,
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

  /// content of the tooltip, is a [text] String with a [textStyle].
  BarTooltipItem(String text, TextStyle textStyle)
      : text = text,
        textStyle = textStyle;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        text,
        textStyle,
      ];
}

/// Holds information about touch response in the [BarChart].
///
/// You can override [BarTouchData.touchCallback] to handle touch events,
/// it gives you a [BarTouchResponse] and you can do whatever you want.
class BarTouchResponse extends BaseTouchResponse with EquatableMixin {
  /// Gives information about the touched spot
  final BarTouchedSpot spot;

  /// If touch happens, [BarChart] processes it internally and passes out a BarTouchedSpot
  /// that contains a [spot], it gives you information about the touched spot.
  /// [touchInput] is the type of happened touch.
  BarTouchResponse(
    BarTouchedSpot spot,
    FlTouchInput touchInput,
  )   : spot = spot,
        super(touchInput);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        spot,
        touchInput,
      ];
}

/// It gives you information about the touched spot.
class BarTouchedSpot extends TouchedSpot with EquatableMixin {
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupIndex;

  final BarChartRodData touchedRodData;
  final int touchedRodDataIndex;

  /// It can be null, if nothing found
  final BarChartRodStackItem touchedStackItem;

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
    BarChartRodStackItem touchedStackItem,
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
  List<Object> get props => [
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
  BarChartDataTween({BarChartData begin, BarChartData end}) : super(begin: begin, end: end);

  /// Lerps a [BarChartData] based on [t] value, check [Tween.lerp].
  @override
  BarChartData lerp(double t) => begin.lerp(begin, end, t);
}
