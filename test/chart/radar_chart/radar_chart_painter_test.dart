import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'radar_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('paint()', () {
    test('test 1', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: const [
              RadarEntry(value: 12),
              RadarEntry(value: 11),
              RadarEntry(value: 10),
            ],
          ),
          RadarDataSet(
            dataEntries: const [
              RadarEntry(value: 2),
              RadarEntry(value: 2),
              RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: const [
              RadarEntry(value: 4),
              RadarEntry(value: 4),
              RadarEntry(value: 4),
            ],
          ),
        ],
      );

      final radarPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);
      when(_mockUtils.convertRadiusToSigma(any))
          .thenAnswer((realInvocation) => 4.0);
      when(_mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(_mockUtils.normalizeBorderRadius(any, any))
          .thenAnswer((realInvocation) => BorderRadius.zero);
      when(_mockUtils.normalizeBorderSide(any, any)).thenAnswer(
          (realInvocation) => const BorderSide(color: MockData.color0));

      final _mockBuildContext = MockBuildContext();
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      radarPainter.paint(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );

      verify(_mockCanvasWrapper.drawCircle(any, any, any)).called(12);
      verify(_mockCanvasWrapper.drawLine(any, any, any)).called(7);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawTicks()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(_mockUtils);

      MockBuildContext _mockContext = MockBuildContext();

      List<Map<String, dynamic>> drawCircleResults = [];
      when(_mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawTicks(_mockContext, _mockCanvasWrapper, holder);

      expect(drawCircleResults.length, 3);

      // Background circle
      expect(drawCircleResults[0]['offset'], const Offset(200, 150));
      expect(drawCircleResults[0]['radius'], 120);
      expect(drawCircleResults[0]['paint_color'], MockData.color2);
      expect(drawCircleResults[0]['paint_style'], PaintingStyle.fill);

      // Border circle
      expect(drawCircleResults[1]['offset'], const Offset(200, 150));
      expect(drawCircleResults[1]['radius'], 120);
      expect(drawCircleResults[1]['paint_color'], MockData.color6);
      expect(drawCircleResults[1]['paint_stroke'], 33);
      expect(drawCircleResults[1]['paint_style'], PaintingStyle.stroke);

      // First Tick
      expect(drawCircleResults[2]['offset'], const Offset(200, 150));
      expect(drawCircleResults[2]['radius'], 60);
      expect(drawCircleResults[2]['paint_color'], MockData.color5);
      expect(drawCircleResults[2]['paint_stroke'], 55);
      expect(drawCircleResults[2]['paint_style'], PaintingStyle.stroke);

      final result =
          verify(_mockCanvasWrapper.drawText(captureAny, captureAny));
      expect(result.callCount, 1);
      final tp = result.captured[0] as TextPainter;
      expect((tp.text as TextSpan).text, '1.0');
      expect((tp.text as TextSpan).style, MockData.textStyle1);
      expect(result.captured[1] as Offset, const Offset(205, 76));
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(_mockUtils);

      List<Map<String, dynamic>> drawLineResults = [];
      when(_mockCanvasWrapper.drawLine(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawLineResults.add({
          'offset_from': inv.positionalArguments[0] as Offset,
          'offset_to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawGrids(_mockCanvasWrapper, holder);
      expect(drawLineResults.length, 3);

      expect(drawLineResults[0]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[0]['offset_to'], const Offset(200, 30));
      expect(drawLineResults[0]['paint_color'], MockData.color3);
      expect(drawLineResults[0]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[0]['paint_stroke'], 3);

      expect(drawLineResults[1]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[1]['offset_to'],
          const Offset(303.92304845413264, 209.99999999999997));
      expect(drawLineResults[1]['paint_color'], MockData.color3);
      expect(drawLineResults[1]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[1]['paint_stroke'], 3);

      expect(drawLineResults[2]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[2]['offset_to'],
          const Offset(96.07695154586739, 210.00000000000006));
      expect(drawLineResults[2]['paint_color'], MockData.color3);
      expect(drawLineResults[2]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[2]['paint_stroke'], 3);
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        getTitle: null,
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      final _mockContext = MockBuildContext();

      radarChartPainter.drawTitles(_mockContext, _mockCanvasWrapper, holder);

      verifyNever(_mockCanvasWrapper.drawText(any, any));
    });

    test('test 2', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        getTitle: (index) {
          return '$index$index';
        },
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      final _mockContext = MockBuildContext();

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawText(captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'tp_text':
              ((inv.positionalArguments[0] as TextPainter).text as TextSpan)
                  .text,
          'tp_style':
              ((inv.positionalArguments[0] as TextPainter).text as TextSpan)
                  .style,
        });
      });

      radarChartPainter.drawTitles(_mockContext, _mockCanvasWrapper, holder);
      expect(results.length, 3);

      expect(results[0]['tp_text'] as String, '00');
      expect(results[0]['tp_style'] as TextStyle, MockData.textStyle4);

      expect(results[1]['tp_text'] as String, '11');
      expect(results[1]['tp_style'] as TextStyle, MockData.textStyle4);

      expect(results[2]['tp_text'] as String, '22');
      expect(results[2]['tp_style'] as TextStyle, MockData.textStyle4);
    });
  });

  group('drawDataSets()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
            fillColor: MockData.color1,
            borderColor: MockData.color3,
            borderWidth: 3,
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
            fillColor: MockData.color2,
            borderColor: MockData.color2,
            borderWidth: 2,
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
            fillColor: MockData.color3,
            borderColor: MockData.color1,
            borderWidth: 1,
          ),
        ],
        getTitle: (index) {
          return '$index$index';
        },
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      List<Map<String, dynamic>> drawCircleResults = [];
      when(_mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint': inv.positionalArguments[2] as Paint,
        });
      });

      List<Map<String, dynamic>> drawPathResults = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
          'paint_stroke': (inv.positionalArguments[1] as Paint).strokeWidth,
          'paint_style': (inv.positionalArguments[1] as Paint).style,
        });
      });

      radarChartPainter.drawDataSets(_mockCanvasWrapper, holder);
      expect(drawCircleResults.length, 9);

      expect(
          drawCircleResults[0]['offset'] as Offset, const Offset(200.0, 110.0));
      expect(drawCircleResults[0]['radius'] as double, 5);

      expect(drawCircleResults[1]['offset'] as Offset,
          const Offset(269.2820323027551, 190.0));
      expect(drawCircleResults[1]['radius'] as double, 5);

      expect(drawCircleResults[2]['offset'] as Offset,
          const Offset(96.07695154586739, 210.00000000000006));
      expect(drawCircleResults[2]['radius'] as double, 5);

      expect(
          drawCircleResults[3]['offset'] as Offset, const Offset(200.0, 30.0));
      expect(drawCircleResults[3]['radius'] as double, 5);

      expect(drawCircleResults[4]['offset'] as Offset,
          const Offset(234.64101615137756, 170.0));
      expect(drawCircleResults[4]['radius'] as double, 5);

      expect(drawCircleResults[5]['offset'] as Offset,
          const Offset(130.71796769724492, 190.00000000000003));
      expect(drawCircleResults[5]['radius'] as double, 5);

      expect(
          drawCircleResults[6]['offset'] as Offset, const Offset(200.0, 70.0));
      expect(drawCircleResults[6]['radius'] as double, 5);

      expect(drawCircleResults[7]['offset'] as Offset,
          const Offset(303.92304845413264, 209.99999999999997));
      expect(drawCircleResults[7]['radius'] as double, 5);

      expect(drawCircleResults[8]['offset'] as Offset,
          const Offset(165.35898384862247, 170.0));
      expect(drawCircleResults[8]['radius'] as double, 5);

      expect(drawPathResults.length, 6);

      expect(drawPathResults[0]['paint_color'], MockData.color1);
      expect(drawPathResults[0]['paint_style'], PaintingStyle.fill);

      expect(drawPathResults[1]['paint_color'], MockData.color3);
      expect(drawPathResults[1]['paint_stroke'], 3);
      expect(drawPathResults[1]['paint_style'], PaintingStyle.stroke);

      expect(drawPathResults[2]['paint_color'], MockData.color2);
      expect(drawPathResults[2]['paint_style'], PaintingStyle.fill);

      expect(drawPathResults[3]['paint_color'], MockData.color2);
      expect(drawPathResults[3]['paint_stroke'], 2);
      expect(drawPathResults[3]['paint_style'], PaintingStyle.stroke);

      expect(drawPathResults[4]['paint_color'], MockData.color3);
      expect(drawPathResults[4]['paint_style'], PaintingStyle.fill);

      expect(drawPathResults[5]['paint_color'], MockData.color1);
      expect(drawPathResults[5]['paint_stroke'], 1);
      expect(drawPathResults[5]['paint_style'], PaintingStyle.stroke);
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);
      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      List<Map<String, dynamic>> drawCircleResults = [];
      when(_mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint': inv.positionalArguments[2] as Paint,
        });
      });

      List<Map<String, dynamic>> drawPathResults = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
          'paint_stroke': (inv.positionalArguments[1] as Paint).strokeWidth,
          'paint_style': (inv.positionalArguments[1] as Paint).style,
        });
      });

      expect(
          radarChartPainter.handleTouch(
              const Offset(287.8, 120.3), viewSize, holder),
          null);
      expect(
          radarChartPainter.handleTouch(
              const Offset(145.1, 125.4), viewSize, holder),
          null);
      expect(
          radarChartPainter.handleTouch(
              const Offset(175.9, 120.8), viewSize, holder),
          null);
      expect(
          radarChartPainter.handleTouch(
              const Offset(201.8, 153.7), viewSize, holder),
          null);
      expect(
          radarChartPainter.handleTouch(
              const Offset(259.5, 116.3), viewSize, holder),
          null);
      expect(
          radarChartPainter.handleTouch(
              const Offset(253.9, 175.9), viewSize, holder),
          null);
      expect(
          radarChartPainter.handleTouch(
              const Offset(146.4, 182.8), viewSize, holder),
          null);

      final result0 = radarChartPainter.handleTouch(
          const Offset(304.9, 212.9), viewSize, holder);
      expect(result0!.touchedDataSetIndex, 2);
      expect(result0.touchedRadarEntryIndex, 1);

      final result1 = radarChartPainter.handleTouch(
          const Offset(202.7, 73.4), viewSize, holder);
      expect(result1!.touchedDataSetIndex, 2);
      expect(result1.touchedRadarEntryIndex, 0);

      final result2 = radarChartPainter.handleTouch(
          const Offset(170.9, 171.9), viewSize, holder);
      expect(result2!.touchedDataSetIndex, 2);
      expect(result2.touchedRadarEntryIndex, 2);

      final result3 = radarChartPainter.handleTouch(
          const Offset(270.5, 192.3), viewSize, holder);
      expect(result3!.touchedDataSetIndex, 0);
      expect(result3.touchedRadarEntryIndex, 1);

      final result4 = radarChartPainter.handleTouch(
          const Offset(98.3, 216.8), viewSize, holder);
      expect(result4!.touchedDataSetIndex, 0);
      expect(result4.touchedRadarEntryIndex, 2);

      final result5 = radarChartPainter.handleTouch(
          const Offset(203.5, 114.3), viewSize, holder);
      expect(result5!.touchedDataSetIndex, 0);
      expect(result5.touchedRadarEntryIndex, 0);

      final result6 = radarChartPainter.handleTouch(
          const Offset(202.6, 33.5), viewSize, holder);
      expect(result6!.touchedDataSetIndex, 1);
      expect(result6.touchedRadarEntryIndex, 0);

      final result7 = radarChartPainter.handleTouch(
          const Offset(132.3, 191.2), viewSize, holder);
      expect(result7!.touchedDataSetIndex, 1);
      expect(result7.touchedRadarEntryIndex, 2);

      final result8 = radarChartPainter.handleTouch(
          const Offset(236.6, 169.3), viewSize, holder);
      expect(result8!.touchedDataSetIndex, 1);
      expect(result8.touchedRadarEntryIndex, 1);
    });
  });

  group('radarCenterY()', () {
    test('test 1', () {
      final painter = RadarChartPainter();
      expect(painter.radarCenterY(const Size(200, 400)), 200);
      expect(painter.radarCenterY(const Size(2314, 400)), 200);
    });
  });

  group('radarCenterX()', () {
    test('test 1', () {
      final painter = RadarChartPainter();
      expect(painter.radarCenterX(const Size(400, 200)), 200);
      expect(painter.radarCenterX(const Size(400, 2314)), 200);
    });
  });

  group('radarRadius()', () {
    test('test 1', () {
      final painter = RadarChartPainter();
      expect(painter.radarRadius(const Size(400, 200)), 80);
      expect(painter.radarRadius(const Size(400, 2314)), 160);
    });
  });

  group('calculateDataSetsPosition()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        getTitle: null,
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final result =
          radarChartPainter.calculateDataSetsPosition(viewSize, holder);
      expect(result.length, 3);
      expect(
        result[0].entriesOffset,
        [
          const Offset(200, 110),
          const Offset(269.2820323027551, 190.0),
          const Offset(96.07695154586739, 210.00000000000006),
        ],
      );
      expect(
        result[1].entriesOffset,
        [
          const Offset(200, 30),
          const Offset(234.64101615137756, 170.0),
          const Offset(130.71796769724492, 190.00000000000003),
        ],
      );
      expect(
        result[2].entriesOffset,
        [
          const Offset(200, 70),
          const Offset(303.92304845413264, 209.99999999999997),
          const Offset(165.35898384862247, 170),
        ],
      );
    });
  });
}
