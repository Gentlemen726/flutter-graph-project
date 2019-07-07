import 'dart:async';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'line_chart_data.dart';

class LineChartPainter extends AxisChartPainter {
  final LineChartData data;

  /// [barPaint] is responsible to painting the bar line
  /// [belowBarPaint] is responsible to fill the below space of our bar line
  /// [dotPaint] is responsible to draw dots on spot points
  /// [clearAroundBorderPaint] is responsible to clip the border
  /// [extraLinesPaint] is responsible to draw extr lines
  /// [touchLinePaint] is responsible to draw touch indicators(below line and spot)
  /// [bgTouchTooltipPaint] is responsible to draw box backgroundTooltip of touched point;
  Paint barPaint, belowBarPaint, belowBarLinePaint,
    dotPaint, clearAroundBorderPaint, extraLinesPaint,
    touchLinePaint;

  LineChartPainter(
    this.data,
    FlTouchInputNotifier touchInputNotifier,
    StreamSink<LineTouchResponse> touchedResponseSink,
  ) : super(data, touchInputNotifier: touchInputNotifier, touchedResponseSink: touchedResponseSink) {

    barPaint = Paint()
      ..style = PaintingStyle.stroke;

    belowBarPaint = Paint()..style = PaintingStyle.fill;

    belowBarLinePaint = Paint()
      ..style = PaintingStyle.stroke;

    dotPaint = Paint()
      ..style = PaintingStyle.fill;

    clearAroundBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.dstIn;

    extraLinesPaint = Paint()
      ..style = PaintingStyle.stroke;

    touchLinePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    super.paint(canvas, viewSize);
    if (data.lineBarsData.isEmpty) {
      return;
    }

    if (data.clipToBorder) {
      /// save layer to clip it to border after lines drew
      canvas.saveLayer(Rect.fromLTWH(0, -40, viewSize.width + 40, viewSize.height + 40), Paint());
    }

    /// it holds list of nearest touched spots of each line
    /// and we use it to draw touch stuff on them
    final List<LineTouchedSpot> touchedSpots = [];
    /// draw each line independently on the chart
    for (LineChartBarData barData in data.lineBarsData) {
      drawBarLine(canvas, viewSize, barData);
      drawDots(canvas, viewSize, barData);

      // find the nearest spot on touch area in this bar line
      final LineTouchedSpot foundTouchedSpot = _getNearestTouchedSpot(canvas, viewSize, barData);
      if (foundTouchedSpot != null) {
        touchedSpots.add(foundTouchedSpot);
      }
    }

    if (data.clipToBorder) {
      removeOutsideBorder(canvas, viewSize);
      /// restore layer to previous state (after clipping the chart)
      canvas.restore();
    }

    // Draw touch indicators (below spot line and spot dot)
    drawTouchedSpotsIndicator(canvas, viewSize, touchedSpots);

    drawTitles(canvas, viewSize);

    drawExtraLines(canvas, viewSize);

    // Draw touch tooltip on most top spot
    super.drawTouchTooltip(canvas, viewSize, data.lineTouchData.touchTooltipData, touchedSpots);

    if (touchedResponseSink != null) {
      touchedResponseSink.add(LineTouchResponse(touchedSpots, touchInputNotifier.value));
    }
  }

  void drawBarLine(Canvas canvas, Size viewSize, LineChartBarData barData) {
    Path barPath = _generateBarPath(viewSize, barData);
    drawBelowBar(canvas, viewSize, barPath, barData);
    drawBar(canvas, viewSize, barPath, barData);
  }

  /// find the nearest spot base on the touched offset
  LineTouchedSpot _getNearestTouchedSpot(Canvas canvas, Size viewSize, LineChartBarData barData) {
    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    if (touchInputNotifier == null || touchInputNotifier.value == null) {
      return null;
    }

    final touch = touchInputNotifier.value;

    if (touch.getOffset() == null) {
      return null;
    }

    final touchedPoint = touch.getOffset();

    /// Find the nearest spot (on X axis)
    for (FlSpot spot in barData.spots) {
      if ((touchedPoint.dx - getPixelX(spot.x, chartViewSize)).abs() <= data.lineTouchData.touchSpotThreshold) {
        final nearestSpot = spot;
        final Offset nearestSpotPos = Offset(
          getPixelX(nearestSpot.x, chartViewSize),
          getPixelY(nearestSpot.y, chartViewSize),
        );

        return LineTouchedSpot(barData, nearestSpot, nearestSpotPos);
      }
    }

    return null;
  }

  void drawDots(Canvas canvas, Size viewSize, LineChartBarData barData) {
    if (!barData.dotData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);
    barData.spots.forEach((spot) {
      if (barData.dotData.checkToShowDot(spot)) {
        double x = getPixelX(spot.x, viewSize);
        double y = getPixelY(spot.y, viewSize);
        dotPaint.color = barData.dotData.dotColor;
        canvas.drawCircle(Offset(x, y), barData.dotData.dotSize, dotPaint);
      }
    });
  }

  /// firstly we generate the bar line that we should draw,
  /// then we reuse it to fill below bar space.
  /// there is two type of barPath that generate here,
  /// first one is the sharp corners line on spot connections
  /// second one is curved corners line on spot connections,
  /// and we use isCurved to find out how we should generate it,
  Path _generateBarPath(Size viewSize, LineChartBarData barData) {
    viewSize = getChartUsableDrawSize(viewSize);
    Path path = Path();
    int size = barData.spots.length;
    path.reset();

    var temp = const Offset(0.0, 0.0);

    double x = getPixelX(barData.spots[0].x, viewSize);
    double y = getPixelY(barData.spots[0].y, viewSize);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barData.spots[i].x, viewSize),
        getPixelY(barData.spots[i].y, viewSize),
      );

      /// previous spot
      final previous = Offset(
        getPixelX(barData.spots[i - 1].x, viewSize),
        getPixelY(barData.spots[i - 1].y, viewSize),
      );

      /// next point
      final next = Offset(
        getPixelX(barData.spots[i + 1 < size ? i + 1 : i].x, viewSize),
        getPixelY(barData.spots[i + 1 < size ? i + 1 : i].y, viewSize),
      );

      final controlPoint1 = previous + temp;

      /// if the isCurved is false, we set 0 for smoothness,
      /// it means we should not have any smoothness then we face with
      /// the sharped corners line
      final smoothness = barData.isCurved ? barData.curveSmoothness : 0.0;
      temp = ((next - previous) / 2) * smoothness;

      if (barData.preventCurveOverShooting) {
        if ((next - current).dy <= 10 || (current - previous).dy <= 10) {
          temp = Offset(temp.dx, 0);
        }

        if ((next - current).dx <= 10 || (current - previous).dx <= 10) {
          temp = Offset(0, temp.dy);
        }
      }

      final controlPoint2 = current - temp;

      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        current.dx, current.dy,
      );
    }

    return path;
  }

  /// in this phase we get the generated [barPath] as input
  /// that is the raw line bar.
  /// then we make a copy from it and call it [belowBarPath],
  /// we continue to complete the path to cover the below section.
  /// then we close the path to fill the below space with a color or gradient.
  void drawBelowBar(Canvas canvas, Size viewSize, Path barPath, LineChartBarData barData) {
    if (!barData.belowBarData.show) {
      return;
    }

    var belowBarPath = Path.from(barPath);

    Size chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Bottom Right
    double x = getPixelX(barData.spots[barData.spots.length - 1].x, chartViewSize);
    double y = chartViewSize.height - getTopOffsetDrawSize();
    belowBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    y = chartViewSize.height - getTopOffsetDrawSize();
    belowBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    y = getPixelY(barData.spots[0].y, chartViewSize);
    belowBarPath.lineTo(x, y);
    belowBarPath.close();

    /// here we update the [belowBarPaint] to draw the solid color
    /// or the gradient based on the [BelowBarData] class.
    if (barData.belowBarData.colors.length == 1) {
      belowBarPaint.color = barData.belowBarData.colors[0];
      belowBarPaint.shader = null;
    } else {

      List<double> stops = [];
      if (barData.belowBarData.gradientColorStops == null
        || barData.belowBarData.gradientColorStops.length != barData.belowBarData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          double ss = 1.0 / barData.colors.length;
          stops.add(ss * (index + 1));
        });
      } else {
        stops = barData.colorStops;
      }

      var from = barData.belowBarData.gradientFrom;
      var to = barData.belowBarData.gradientTo;
      belowBarPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        barData.belowBarData.colors,
        stops,
      );
    }

    canvas.drawPath(belowBarPath, belowBarPaint);


    /// draw below spots line
    if (barData.belowBarData.belowSpotsLine != null) {
      for (FlSpot spot in barData.spots) {
        if (barData.belowBarData.belowSpotsLine.show &&
          barData.belowBarData.belowSpotsLine.checkToShowSpotBelowLine(spot)) {
          final Offset from = Offset(
            getPixelX(spot.x, chartViewSize),
            getPixelY(spot.y, chartViewSize),
          );

          final double bottomPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
          final Offset to = Offset(
            getPixelX(spot.x, chartViewSize),
            viewSize.height - bottomPadding,
          );

          belowBarLinePaint.color = barData.belowBarData.belowSpotsLine.flLineStyle.color;
          belowBarLinePaint.strokeWidth =
            barData.belowBarData.belowSpotsLine.flLineStyle.strokeWidth;

          canvas.drawLine(from, to, belowBarLinePaint);
        }
      }
    }
  }

  void drawBar(Canvas canvas, Size viewSize, Path barPath, LineChartBarData barData) {
    if (!barData.show) {
      return;
    }

    barPaint.strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt;

    /// here we update the [barPaint] to draw the solid color or
    /// the gradient color,
    /// if we have one color, solid color will apply,
    /// but if we have more than one color, gradient will apply.
    if (barData.colors.length == 1) {
      barPaint.color = barData.colors[0];
      barPaint.shader = null;
    } else {

      List<double> stops = [];
      if (barData.colorStops == null || barData.colorStops.length != barData.colors.length) {
        /// provided colorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          double ss = 1.0 / barData.colors.length;
          stops.add(ss * (index + 1));
        });
      } else {
        stops = barData.colorStops;
      }

      barPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize(),
          getTopOffsetDrawSize() + (viewSize.height / 2),
        ),
        Offset(
          getLeftOffsetDrawSize() + viewSize.width,
          getTopOffsetDrawSize() + (viewSize.height / 2),
        ),
        barData.colors,
        stops,
      );
    }

    barPaint.strokeWidth = barData.barWidth;
    canvas.drawPath(barPath, barPaint);
  }

  /// clip the border (remove outside the border)
  void removeOutsideBorder(Canvas canvas, Size viewSize) {
    if (!data.clipToBorder) {
      return;
    }

    clearAroundBorderPaint.strokeWidth = barPaint.strokeWidth / 2;
    double halfStrokeWidth = clearAroundBorderPaint.strokeWidth / 2;
    Rect rect = Rect.fromLTRB(
      getLeftOffsetDrawSize() - halfStrokeWidth,
      getTopOffsetDrawSize() - halfStrokeWidth,
      viewSize.width - (getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize()) + halfStrokeWidth,
      viewSize.height - (getExtraNeededVerticalSpace() - getTopOffsetDrawSize()) + halfStrokeWidth,
    );
    canvas.drawRect(rect, clearAroundBorderPaint);
  }

  void drawTouchedSpotsIndicator(Canvas canvas, Size viewSize, List<LineTouchedSpot> lineTouchedSpots) {
    if (touchInputNotifier.value is FlLongPressEnd) {
      return;
    }

    if (lineTouchedSpots == null || lineTouchedSpots.isEmpty) {
      return;
    }

    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    /// sort the touched spots top to down, base on their y value
    lineTouchedSpots.sort((a, b) => a.offset.dy.compareTo(b.offset.dy));

    final List<TouchedSpotIndicatorData> indicatorsData =
      data.lineTouchData.getTouchedSpotIndicator(lineTouchedSpots);

    if (indicatorsData.length != lineTouchedSpots.length) {
      throw Exception('indicatorsData and touchedSpotOffsets size should be same');
    }

    for (int i = 0; i < lineTouchedSpots.length; i++) {
      final TouchedSpotIndicatorData indicatorData = indicatorsData[i];
      final LineTouchedSpot touchedSpot = lineTouchedSpots[i];

      if (indicatorData == null) {
        continue;
      }

      /// Draw the indicator line
      final from = Offset(touchedSpot.offset.dx, getTopOffsetDrawSize() + chartViewSize.height);
      final to = touchedSpot.offset;

      touchLinePaint.color = indicatorData.indicatorBelowLine.color;
      touchLinePaint.strokeWidth = indicatorData.indicatorBelowLine.strokeWidth;
      canvas.drawLine(from, to, touchLinePaint);

      /// Draw the indicator dot
      final double selectedSpotDotSize =
        indicatorData.touchedSpotDotData.dotSize;
      dotPaint.color = indicatorData.touchedSpotDotData.dotColor;
      canvas.drawCircle(to, selectedSpotDotSize, dotPaint);
    }
  }

  void drawTitles(Canvas canvas, Size viewSize) {
    if (!data.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Vertical Titles
    if (data.titlesData.showVerticalTitles) {
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        double x = 0 + getLeftOffsetDrawSize();
        double y = getPixelY(verticalSeek, viewSize) +
            getTopOffsetDrawSize();

        final String text =
            data.titlesData.getVerticalTitles(verticalSeek);

        final TextSpan span = TextSpan(style: data.titlesData.verticalTitlesTextStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x -= tp.width + data.titlesData.verticalTitleMargin;
        y -= tp.height / 2;
        tp.paint(canvas, Offset(x, y));

        verticalSeek += data.gridData.verticalInterval;
      }
    }

    // Horizontal titles
    if (data.titlesData.showHorizontalTitles) {
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        double x = getPixelX(horizontalSeek, viewSize);
        double y = viewSize.height + getTopOffsetDrawSize();

        String text = data.titlesData
            .getHorizontalTitles(horizontalSeek);

        TextSpan span = TextSpan(style: data.titlesData.horizontalTitlesTextStyle, text: text);
        TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout();

        x -= tp.width / 2;
        y += data.titlesData.horizontalTitleMargin;

        tp.paint(canvas, Offset(x, y));

        horizontalSeek += data.gridData.horizontalInterval;
      }
    }
  }

  void drawExtraLines(Canvas canvas, Size viewSize) {
    if (data.extraLinesData == null) {
      return;
    }

    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    if (data.extraLinesData.showHorizontalLines) {
      for (HorizontalLine line in data.extraLinesData.horizontalLines) {

        final double topChartPadding = getTopOffsetDrawSize();
        final Offset from = Offset(getPixelX(line.x, chartUsableSize), topChartPadding);

        final double bottomChartPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
        final Offset to = Offset(getPixelX(line.x, chartUsableSize), viewSize.height - bottomChartPadding);

        extraLinesPaint.color = line.color;
        extraLinesPaint.strokeWidth = line.strokeWidth;

        canvas.drawLine(from, to, extraLinesPaint);
      }
    }

    if (data.extraLinesData.showVerticalLines) {
      for (VerticalLine line in data.extraLinesData.verticalLines) {

        final double leftChartPadding = getLeftOffsetDrawSize();
        final Offset from = Offset(leftChartPadding, getPixelY(line.y, chartUsableSize));

        final double rightChartPadding = getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize();
        final Offset to = Offset(viewSize.width - rightChartPadding, getPixelY(line.y, chartUsableSize));

        extraLinesPaint.color = line.color;
        extraLinesPaint.strokeWidth = line.strokeWidth;

        canvas.drawLine(from, to, extraLinesPaint);
      }
    }
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize], and the whole
  @override
  double getExtraNeededHorizontalSpace() {
    double parentNeeded = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
        data.titlesData.verticalTitlesReservedWidth +
        data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  /// We add our needed vertical space to parent needed.
  /// we have some titles that maybe draw in the bottom side of our chart.
  @override
  double getExtraNeededVerticalSpace() {
    double parentNeeded = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show && data.titlesData.showHorizontalTitles) {
      return parentNeeded +
        data.titlesData.horizontalTitlesReservedHeight +
        data.titlesData.horizontalTitleMargin;
    }
    return parentNeeded;
  }

  /// calculate left offset for draw the chart,
  /// maybe we want to show both left and right titles,
  /// then just the left titles will effect on this function.
  @override
  double getLeftOffsetDrawSize() {
    double parentNeeded = super.getLeftOffsetDrawSize();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
        data.titlesData.verticalTitlesReservedWidth +
        data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) =>
      oldDelegate.data != data ||
        oldDelegate.touchInputNotifier != touchInputNotifier;

}