import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const viewSize = Size(400, 400);

  final lineChartDataBase = LineChartData(
    minX: 0,
    maxX: 10,
    minY: 0,
    maxY: 10,
  );

  final lineChartDataWithNoTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: false,
      leftTitles: AxisTitles(),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
    ),
  );

  final lineChartDataWithAllTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_left),
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_drop_up),
        axisNameSize: 20,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('T-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      rightTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_right),
        axisNameSize: 30,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('R-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_drop_down),
        axisNameSize: 40,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('B-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
    ),
  );

  final lineChartDataWithOnlyLeftTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_left),
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
    ),
  );

  final lineChartDataWithOnlyLeftTitlesWithoutAxisName =
      lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
    ),
  );

  testWidgets(
    'LineChart with no titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithNoTitles,
                ),
              ),
            ),
          ),
        ),
      );
      expect(chartDrawingSize, viewSize);
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Icon), findsNothing);
    },
  );

  testWidgets(
    'LineChart with all titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithAllTitles,
                ),
              ),
            ),
          ),
        ),
      );

      Future checkSide(TitlesSide side) async {
        String axisChar;
        switch (side) {
          case TitlesSide.left:
            axisChar = 'L';
            break;
          case TitlesSide.top:
            axisChar = 'T';
            break;
          case TitlesSide.right:
            axisChar = 'R';
            break;
          case TitlesSide.bottom:
            axisChar = 'B';
            break;
          default:
            throw StateError('Invalid');
        }
        for (int i = 0; i <= 10; i++) {
          expect(find.text('$axisChar-$i'), findsOneWidget);
        }
      }

      expect(chartDrawingSize, const Size(320, 280));
      expect(find.byIcon(Icons.arrow_left), findsOneWidget);
      checkSide(TitlesSide.left);

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      checkSide(TitlesSide.top);

      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      checkSide(TitlesSide.right);

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      checkSide(TitlesSide.bottom);

      expect(find.byType(Text), findsNWidgets(44));
      expect(find.byType(Icon), findsNWidgets(4));
    },
  );

  testWidgets(
    'LineChart with only left titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithOnlyLeftTitles,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(380, 400));
      expect(find.byIcon(Icons.arrow_left), findsOneWidget);
      for (int i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(11));
      expect(find.byType(Icon), findsNWidgets(1));
    },
  );

  testWidgets(
    'LineChart with only left titles without axis name',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithOnlyLeftTitlesWithoutAxisName,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(390, 400));
      for (int i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(11));
      expect(find.byType(Icon), findsNothing);
    },
  );
}
