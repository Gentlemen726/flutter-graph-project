import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../data_pool.dart';

void main() {
  group('BaseChartData data equality check', () {
    test('FlBorderData equality test', () {
      expect(borderData1 == borderData1Clone, true);

      expect(
        borderData1 ==
            FlBorderData(
              show: false,
              border: Border.all(color: Colors.green),
            ),
        false,
      );

      expect(
        borderData1 ==
            FlBorderData(
              show: true,
            ),
        false,
      );
    });
  });
}
