import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tolerance = 0.0001;
  group('iterateThroughAxis()', () {
    test('test 1', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        max: 0.1,
        interval: 0.001,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 101);
    });

    test('test 2', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        minIncluded: false,
        max: 0.1,
        maxIncluded: false,
        interval: 0.001,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 99);
      expect(results[0], closeTo(0.001, tolerance));
      expect(results[98], closeTo(0.099, tolerance));
    });

    test('test 3', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        max: 1000,
        interval: 200,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 6);
      expect(results[0], 0);
      expect(results[1], 200);
      expect(results[2], 400);
      expect(results[3], 600);
      expect(results[4], 800);
      expect(results[5], 1000);
    });

    test('test 4', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        max: 10,
        interval: 3,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 5);
      expect(results[0], 0);
      expect(results[1], 3);
      expect(results[2], 6);
      expect(results[3], 9);
      expect(results[4], 10);
    });

    test('test 4', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        minIncluded: false,
        max: 10,
        maxIncluded: false,
        interval: 3,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 3);
      expect(results[0], 3);
      expect(results[1], 6);
      expect(results[2], 9);
    });

    test('test 4', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 35,
        max: 130,
        interval: 50,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 4);
      expect(results[0], 35);
      expect(results[1], 50);
      expect(results[2], 100);
      expect(results[3], 130);
    });
  });
}
