import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/material.dart';

import 'axis_chart_data.dart';
import 'side_titles/side_titles_widget.dart';

class AxisChartScaffoldWidget extends StatelessWidget {
  final Widget chart;
  final AxisChartData data;

  const AxisChartScaffoldWidget({
    Key? key,
    required this.chart,
    required this.data,
  }) : super(key: key);

  bool get showLeftTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.leftTitles.showAxisTitles;
    final showSideTitles = data.titlesData.leftTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showRightTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.rightTitles.showAxisTitles;
    final showSideTitles = data.titlesData.rightTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showTopTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.topTitles.showAxisTitles;
    final showSideTitles = data.titlesData.topTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showBottomTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.bottomTitles.showAxisTitles;
    final showSideTitles = data.titlesData.bottomTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  List<Widget> stackWidgets(BoxConstraints constraints) {
    List<Widget> widgets = [
      Padding(
        padding: data.titlesData.allSidesPadding,
        child: chart,
      )
    ];

    int insertIndex(bool drawBelow) => drawBelow ? 0 : widgets.length;

    if (showLeftTitles) {
      widgets.insert(
        insertIndex(data.titlesData.leftTitles.drawBelowEverything),
        SideTitlesWidget(
          side: TitlesSide.left,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showTopTitles) {
      widgets.insert(
        insertIndex(data.titlesData.topTitles.drawBelowEverything),
        SideTitlesWidget(
          side: TitlesSide.top,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showRightTitles) {
      widgets.insert(
        insertIndex(data.titlesData.rightTitles.drawBelowEverything),
        SideTitlesWidget(
          side: TitlesSide.right,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showBottomTitles) {
      widgets.insert(
        insertIndex(data.titlesData.bottomTitles.drawBelowEverything),
        SideTitlesWidget(
          side: TitlesSide.bottom,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(children: stackWidgets(constraints));
    });
  }
}
