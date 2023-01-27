import 'package:fl_chart_app/menu/app_menu.dart';
import 'package:fl_chart_app/pages/chart_samples_page.dart';
import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int selectedMenuIndex;

  final menuItems = [
    ChartMenuItem(ChartType.line, ChartType.line.getSimpleName(), AppAssets.icLineChart),
    ChartMenuItem(ChartType.bar, ChartType.bar.getSimpleName(), AppAssets.icBarChart),
    ChartMenuItem(ChartType.pie, ChartType.pie.getSimpleName(), AppAssets.icPieChart),
    ChartMenuItem(ChartType.scatter, ChartType.scatter.getSimpleName(), AppAssets.icScatterChart),
    ChartMenuItem(ChartType.radar, ChartType.radar.getSimpleName(), AppAssets.icRadarChart),
  ];

  @override
  void initState() {
    selectedMenuIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMenu = menuItems[selectedMenuIndex];
    return LayoutBuilder(
      builder: (context, constraints) {
        final needsDrawer =
            constraints.maxWidth <= AppDimens.menuMaxNeededWidth + AppDimens.chartBoxMinWidth;
        final appMenuWidget = AppMenu(
          menuItems: menuItems,
          currentSelectedIndex: selectedMenuIndex,
          onItemSelected: (newIndex, chartMenuItem) {
            setState(() {
              selectedMenuIndex = newIndex;
            });
            if (needsDrawer) {
              /// to close the drawer
              Navigator.of(context).pop();
            }
          },
        );
        final samplesSectionWidget = IndexedStack(
          index: selectedMenuIndex,
          children: menuItems.map((e) => ChartSamplesPage(chartType: e.chartType)).toList(),
        );

        final body = needsDrawer
            ? samplesSectionWidget
            : Row(
                children: [
                  SizedBox(
                    width: AppDimens.menuMaxNeededWidth,
                    child: appMenuWidget,
                  ),
                  Expanded(
                    child: samplesSectionWidget,
                  )
                ],
              );

        return Scaffold(
          body: body,
          drawer: needsDrawer
              ? Drawer(
                  child: appMenuWidget,
                )
              : null,
          appBar: needsDrawer
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(selectedMenu.chartType.getName()),
                )
              : null,
        );
      },
    );
  }
}
