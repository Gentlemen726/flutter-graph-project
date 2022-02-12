import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  const tolerance = 0.001;

  test('test degrees to radians', () {
    expect(Utils().radians(57.2958), closeTo(1, tolerance));
    expect(Utils().radians(120), closeTo(2.0944, tolerance));
    expect(Utils().radians(324), closeTo(5.65487, tolerance));
    expect(Utils().radians(180), closeTo(3.1415, tolerance));
  });

  test('test radians to degree', () {
    expect(Utils().degrees(1.5), closeTo(85.9437, tolerance));
    expect(Utils().degrees(1.8), closeTo(103.132, tolerance));
    expect(Utils().degrees(1.2), closeTo(68.7549, tolerance));
  });

  test('test default size', () {
    expect(Utils().getDefaultSize(const Size(1080, 1920)).width,
        closeTo(756, tolerance));
    expect(Utils().getDefaultSize(const Size(1080, 1920)).height,
        closeTo(756, tolerance));

    expect(Utils().getDefaultSize(const Size(728, 1080)).width,
        closeTo(509.6, tolerance));
    expect(Utils().getDefaultSize(const Size(728, 1080)).height,
        closeTo(509.6, tolerance));

    expect(Utils().getDefaultSize(const Size(2560, 1600)).width,
        closeTo(1120, tolerance));
    expect(Utils().getDefaultSize(const Size(2560, 1600)).height,
        closeTo(1120, tolerance));

    expect(Utils().getDefaultSize(const Size(1000, 1000)).width,
        closeTo(700, tolerance));
  });

  test('translate rotated position', () {
    expect(Utils().translateRotatedPosition(100, 90), 25);
    expect(Utils().translateRotatedPosition(100, 0), 0);
  });

  test('calculateRotationOffset()', () {
    expect(Utils().calculateRotationOffset(MockData.size1, 90), Offset.zero);
    expect(
      Utils().calculateRotationOffset(MockData.size1, 45).dx,
      closeTo(-2.278, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 45).dy,
      closeTo(-2.278, tolerance),
    );

    expect(
      Utils().calculateRotationOffset(MockData.size1, 180).dx,
      closeTo(0.0, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 180).dy,
      closeTo(0.0, tolerance),
    );

    expect(
      Utils().calculateRotationOffset(MockData.size1, 220).dx,
      closeTo(-2.2485, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 220).dy,
      closeTo(-2.2485, tolerance),
    );

    expect(
      Utils().calculateRotationOffset(MockData.size1, 350).dx,
      closeTo(-0.87150, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 350).dy,
      closeTo(-0.87150, tolerance),
    );
  });

  test('lerp gradient', () {
    expect(
        lerpGradient([
          Colors.red,
          Colors.green,
        ], [], 0.0),
        Colors.red);

    expect(
        lerpGradient([
          Colors.red,
          Colors.green,
        ], [], 1.0),
        Colors.green);
  });

  test('test roundInterval', () {
    expect(Utils().roundInterval(99), 100);
    expect(Utils().roundInterval(75), 50);
    expect(Utils().roundInterval(76), 100);
    expect(Utils().roundInterval(60), 50);
    expect(Utils().roundInterval(0.000123), 0.0001);
    expect(Utils().roundInterval(0.000190), 0.0002);
    expect(Utils().roundInterval(0.000200), 0.0002);
    expect(Utils().roundInterval(0.000390000000), 0.0005);
    expect(Utils().roundInterval(0.000990000000), 0.001);
    expect(Utils().roundInterval(0.00000990000), 0.00001000);
    expect(Utils().roundInterval(0.0000009), 0.0000009);
    expect(Utils().roundInterval(0.000000000000000000990000000),
        0.000000000000000000990000000);
    expect(Utils().roundInterval(0.000004901960784313726), 0.000005);
  });

  test('test Utils().getEfficientInterval', () {
    expect(Utils().getEfficientInterval(472, 340, pixelPerInterval: 10), 5);
    expect(Utils().getEfficientInterval(820, 10000, pixelPerInterval: 10), 100);
    expect(Utils().getEfficientInterval(1024, 412345234, pixelPerInterval: 10),
        5000000);
    expect(
        Utils().getEfficientInterval(720, 812394712349, pixelPerInterval: 10),
        10000000000);
    expect(
        Utils().getEfficientInterval(1024, 0.01, pixelPerInterval: 100), 0.001);
    expect(Utils().getEfficientInterval(1024, 0.0005, pixelPerInterval: 10),
        0.000005);
    expect(Utils().getEfficientInterval(200, 0.5, pixelPerInterval: 20), 0.05);
    expect(Utils().getEfficientInterval(200, 1.0, pixelPerInterval: 20), 0.1);
    expect(Utils().getEfficientInterval(100, 0.5, pixelPerInterval: 20), 0.1);
  });

  test('test formatNumber', () {
    expect(Utils().formatNumber(0), '0');
    expect(Utils().formatNumber(423), '423');
    expect(Utils().formatNumber(-423), '-423');
    expect(Utils().formatNumber(1000), '1K');
    expect(Utils().formatNumber(1234), '1.2K');
    expect(Utils().formatNumber(10000), '10K');
    expect(Utils().formatNumber(41234), '41.2K');
    expect(Utils().formatNumber(82349), '82.3K');
    expect(Utils().formatNumber(82350), '82.3K');
    expect(Utils().formatNumber(82351), '82.4K');
    expect(Utils().formatNumber(-82351), '-82.4K');
    expect(Utils().formatNumber(100000), '100K');
    expect(Utils().formatNumber(101000), '101K');
    expect(Utils().formatNumber(2345123), '2.3M');
    expect(Utils().formatNumber(2352123), '2.4M');
    expect(Utils().formatNumber(-2352123), '-2.4M');
    expect(Utils().formatNumber(521000000), '521M');
    expect(Utils().formatNumber(4324512345), '4.3B');
    expect(Utils().formatNumber(4000000000), '4B');
    expect(Utils().formatNumber(-4000000000), '-4B');
    expect(Utils().formatNumber(823147521343), '823.1B');
    expect(Utils().formatNumber(8231475213435), '8231.5B');
    expect(Utils().formatNumber(-8231475213435), '-8231.5B');
  });

  test('test getInitialIntervalValue()', () {
    expect(Utils().getBestInitialIntervalValue(-3, 3, 2), -2);
    expect(Utils().getBestInitialIntervalValue(-3, 3, 1), -3);
    expect(Utils().getBestInitialIntervalValue(-30, -20, 13), -30);
    expect(Utils().getBestInitialIntervalValue(0, 13, 8), 0);
    expect(Utils().getBestInitialIntervalValue(1, 13, 7), 1);
    expect(Utils().getBestInitialIntervalValue(1, 13, 3), 1);
    expect(Utils().getBestInitialIntervalValue(-1, 13, 3), 0);
    expect(Utils().getBestInitialIntervalValue(-2, 13, 3), 0);
    expect(Utils().getBestInitialIntervalValue(-3, 13, 3), -3);
    expect(Utils().getBestInitialIntervalValue(-4, 13, 3), -3);
    expect(Utils().getBestInitialIntervalValue(-5, 13, 3), -3);
    expect(Utils().getBestInitialIntervalValue(-6, 13, 3), -6);
    expect(Utils().getBestInitialIntervalValue(-6.5, 13, 3), -6);
    expect(Utils().getBestInitialIntervalValue(-1, 1, 2), -1);
    expect(Utils().getBestInitialIntervalValue(-1, 2, 2), 0);
    expect(Utils().getBestInitialIntervalValue(-2, 0, 2), -2);
    expect(Utils().getBestInitialIntervalValue(-3, 0, 2), -2);
    expect(Utils().getBestInitialIntervalValue(-4, 0, 2), -4);
    expect(Utils().getBestInitialIntervalValue(-0.5, 0.5, 2), -0.5);
  });

  test('test convertRadiusToSigma()', () {
    expect(Utils().convertRadiusToSigma(10), closeTo(6.2735, tolerance));
    expect(Utils().convertRadiusToSigma(42), closeTo(24.7487, tolerance));
    expect(Utils().convertRadiusToSigma(26), closeTo(15.5111, tolerance));
  });
}
