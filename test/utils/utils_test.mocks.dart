// Mocks generated by Mockito 5.1.0 from annotations
// in fl_chart/test/utils/utils_test.dart.
// Do not manually edit this file.

import 'dart:ui' as _i2;

import 'package:fl_chart/src/utils/utils.dart' as _i5;
import 'package:flutter/foundation.dart' as _i4;
import 'package:flutter/material.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeSize_0 extends _i1.Fake implements _i2.Size {}

class _FakeOffset_1 extends _i1.Fake implements _i2.Offset {}

class _FakeBorderSide_2 extends _i1.Fake implements _i3.BorderSide {}

class _FakeTextStyle_3 extends _i1.Fake implements _i3.TextStyle {
  @override
  String toString({_i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeWidget_4 extends _i1.Fake implements _i3.Widget {
  @override
  String toString({_i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeInheritedWidget_5 extends _i1.Fake implements _i3.InheritedWidget {
  @override
  String toString({_i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeDiagnosticsNode_6 extends _i1.Fake implements _i3.DiagnosticsNode {
  @override
  String toString(
          {_i4.TextTreeConfiguration? parentConfiguration,
          _i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

/// A class which mocks [Utils].
///
/// See the documentation for Mockito's code generation for more information.
class MockUtils extends _i1.Mock implements _i5.Utils {
  MockUtils() {
    _i1.throwOnMissingStub(this);
  }

  @override
  double radians(double? degrees) =>
      (super.noSuchMethod(Invocation.method(#radians, [degrees]),
          returnValue: 0.0) as double);
  @override
  double degrees(double? radians) =>
      (super.noSuchMethod(Invocation.method(#degrees, [radians]),
          returnValue: 0.0) as double);
  @override
  _i2.Size getDefaultSize(_i2.Size? screenSize) =>
      (super.noSuchMethod(Invocation.method(#getDefaultSize, [screenSize]),
          returnValue: _FakeSize_0()) as _i2.Size);
  @override
  double translateRotatedPosition(double? size, double? degree) =>
      (super.noSuchMethod(
          Invocation.method(#translateRotatedPosition, [size, degree]),
          returnValue: 0.0) as double);
  @override
  _i2.Offset calculateRotationOffset(_i2.Size? size, double? degree) => (super
      .noSuchMethod(Invocation.method(#calculateRotationOffset, [size, degree]),
          returnValue: _FakeOffset_1()) as _i2.Offset);
  @override
  _i3.BorderRadius? normalizeBorderRadius(
          _i3.BorderRadius? borderRadius, double? width) =>
      (super.noSuchMethod(
              Invocation.method(#normalizeBorderRadius, [borderRadius, width]))
          as _i3.BorderRadius?);
  @override
  _i3.BorderSide normalizeBorderSide(
          _i3.BorderSide? borderSide, double? width) =>
      (super.noSuchMethod(
          Invocation.method(#normalizeBorderSide, [borderSide, width]),
          returnValue: _FakeBorderSide_2()) as _i3.BorderSide);
  @override
  double getEfficientInterval(double? axisViewSize, double? diffInAxis,
          {double? pixelPerInterval = 40.0}) =>
      (super.noSuchMethod(
          Invocation.method(#getEfficientInterval, [axisViewSize, diffInAxis],
              {#pixelPerInterval: pixelPerInterval}),
          returnValue: 0.0) as double);
  @override
  double roundInterval(double? input) =>
      (super.noSuchMethod(Invocation.method(#roundInterval, [input]),
          returnValue: 0.0) as double);
  @override
  String formatNumber(double? number) =>
      (super.noSuchMethod(Invocation.method(#formatNumber, [number]),
          returnValue: '') as String);
  @override
  _i3.TextStyle getThemeAwareTextStyle(
          _i3.BuildContext? context, _i3.TextStyle? providedStyle) =>
      (super.noSuchMethod(
          Invocation.method(#getThemeAwareTextStyle, [context, providedStyle]),
          returnValue: _FakeTextStyle_3()) as _i3.TextStyle);
  @override
  double getBestInitialIntervalValue(double? min, double? max, double? interval,
          {double? baseline = 0.0}) =>
      (super.noSuchMethod(
          Invocation.method(#getBestInitialIntervalValue, [min, max, interval],
              {#baseline: baseline}),
          returnValue: 0.0) as double);
  @override
  double convertRadiusToSigma(double? radius) =>
      (super.noSuchMethod(Invocation.method(#convertRadiusToSigma, [radius]),
          returnValue: 0.0) as double);
}

/// A class which mocks [BuildContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuildContext extends _i1.Mock implements _i3.BuildContext {
  MockBuildContext() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Widget get widget => (super.noSuchMethod(Invocation.getter(#widget),
      returnValue: _FakeWidget_4()) as _i3.Widget);
  @override
  bool get debugDoingBuild => (super
          .noSuchMethod(Invocation.getter(#debugDoingBuild), returnValue: false)
      as bool);
  @override
  _i3.InheritedWidget dependOnInheritedElement(_i3.InheritedElement? ancestor,
          {Object? aspect}) =>
      (super.noSuchMethod(
          Invocation.method(
              #dependOnInheritedElement, [ancestor], {#aspect: aspect}),
          returnValue: _FakeInheritedWidget_5()) as _i3.InheritedWidget);
  @override
  void visitAncestorElements(bool Function(_i3.Element)? visitor) =>
      super.noSuchMethod(Invocation.method(#visitAncestorElements, [visitor]),
          returnValueForMissingStub: null);
  @override
  void visitChildElements(_i3.ElementVisitor? visitor) =>
      super.noSuchMethod(Invocation.method(#visitChildElements, [visitor]),
          returnValueForMissingStub: null);
  @override
  void dispatchNotification(_i3.Notification? notification) => super
      .noSuchMethod(Invocation.method(#dispatchNotification, [notification]),
          returnValueForMissingStub: null);
  @override
  _i3.DiagnosticsNode describeElement(String? name,
          {_i4.DiagnosticsTreeStyle? style =
              _i4.DiagnosticsTreeStyle.errorProperty}) =>
      (super.noSuchMethod(
          Invocation.method(#describeElement, [name], {#style: style}),
          returnValue: _FakeDiagnosticsNode_6()) as _i3.DiagnosticsNode);
  @override
  _i3.DiagnosticsNode describeWidget(String? name,
          {_i4.DiagnosticsTreeStyle? style =
              _i4.DiagnosticsTreeStyle.errorProperty}) =>
      (super.noSuchMethod(
          Invocation.method(#describeWidget, [name], {#style: style}),
          returnValue: _FakeDiagnosticsNode_6()) as _i3.DiagnosticsNode);
  @override
  List<_i3.DiagnosticsNode> describeMissingAncestor(
          {Type? expectedAncestorType}) =>
      (super.noSuchMethod(
          Invocation.method(#describeMissingAncestor, [],
              {#expectedAncestorType: expectedAncestorType}),
          returnValue: <_i3.DiagnosticsNode>[]) as List<_i3.DiagnosticsNode>);
  @override
  _i3.DiagnosticsNode describeOwnershipChain(String? name) =>
      (super.noSuchMethod(Invocation.method(#describeOwnershipChain, [name]),
          returnValue: _FakeDiagnosticsNode_6()) as _i3.DiagnosticsNode);
}
