import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';

// coverage:ignore-start

/// Low level BarChart Widget.
class BarChartLeaf extends LeafRenderObjectWidget {
  const BarChartLeaf({Key? key, required this.data, required this.targetData})
      : super(key: key);

  final BarChartData data;
  final BarChartData targetData;

  @override
  RenderBarChart createRenderObject(BuildContext context) => RenderBarChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaleFactor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderBarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..buildContext = context;
  }
}
// coverage:ignore-end

/// Renders our BarChart, also handles hitTest.
class RenderBarChart extends RenderBaseChart<BarTouchResponse> {
  RenderBarChart(
    BuildContext context,
    BarChartData data,
    BarChartData targetData,
    double textScale,
  )   : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.barTouchData, context);

  BarChartData get data => _data;
  BarChartData _data;

  set data(BarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  BarChartData get targetData => _targetData;
  BarChartData _targetData;

  set targetData(BarChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.barTouchData);
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;

  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  BarChartPainter painter = BarChartPainter();

  PaintHolder<BarChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    painter.paint(
      buildContext,
      CanvasWrapper(canvas, mockTestSize ?? size),
      paintHolder,
    );
    canvas.restore();
  }

  @override
  BarTouchResponse getResponseAtLocation(Offset localPosition) {
    final touchedSpot = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return BarTouchResponse(touchedSpot);
  }
}
