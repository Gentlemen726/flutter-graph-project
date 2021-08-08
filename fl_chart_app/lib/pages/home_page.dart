import 'package:fl_chart_app/menu/app_menu.dart';
import 'package:fl_chart_app/pages/chart_samples_page.dart';
import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedMenuIndex;

  final menuItems = const [
    ChartMenuItem(AppHelper.LINE_CHART_SLUG, 'Line', AppAssets.icLineChart),
    ChartMenuItem(AppHelper.BAR_CHART_SLUG, 'Bar', AppAssets.icBarChart),
    ChartMenuItem(AppHelper.PIE_CHART_SLUG, 'Pie', AppAssets.icPieChart),
    ChartMenuItem(AppHelper.SCATTER_CHART_SLUG, 'Scatter', AppAssets.icScatterChart),
    ChartMenuItem(AppHelper.RADAR_CHART_SLUG, 'Radar', AppAssets.icRadarChart),
  ];

  @override
  void initState() {
    selectedMenuIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final needsDrawer = constraints.maxWidth <= AppDimens.menuMaxNeededWidth + AppDimens.chartBoxMinWidth;
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
          children: menuItems.map((e) => ChartSamplesPage(chartSlug: e.slug)).toList(),
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
          backgroundColor: Color(0xFF1B2339),
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
                  title: Text('${menuItems[selectedMenuIndex].text} Chart'),
                )
              : null,
        );
      },
    );
  }
}