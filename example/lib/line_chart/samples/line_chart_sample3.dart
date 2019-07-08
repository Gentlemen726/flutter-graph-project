import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample3 extends StatelessWidget {

  var weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Average Line',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),),
            const Text(' and ',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
            const Text('Indiactors',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
          ],
        ),
        const SizedBox(height: 18,),
        SizedBox(
          width: 300,
          height: 140,
          child: FlChart(
            chart: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator: (List<TouchedSpot> spots) {
                    return spots.map((spot) {
                      if (spot.spot.x == 0 || spot.spot.x == 6) {
                        return null;
                      }
                      return TouchedSpotIndicatorData(
                        const FlLine(color: Colors.blue, strokeWidth: 4),
                        const FlDotData(dotSize: 8, dotColor: Colors.deepOrange),
                      );
                    }).toList();
                  },
                  touchTooltipData: TouchTooltipData(
                    tooltipBgColor: Colors.blueAccent,
                    getTooltipItems: (List<TouchedSpot> spots) {
                      return spots.map((spot) {
                        final flSpot = spot.spot;
                        if (flSpot.x == 0 || flSpot.x == 6) {
                          return null;
                        }

                        return TooltipItem(
                          '${weekDays[flSpot.x.toInt()]} \n${flSpot.y} k colories',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    }
                  )
                ),
                extraLinesData: ExtraLinesData(
                  showVerticalLines: true,
                  verticalLines: [
                    VerticalLine(
                      y: 1.8,
                      color: Colors.green.withOpacity(0.7),
                      strokeWidth: 4,
                    ),
                  ]

                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1.3),
                      FlSpot(1, 1),
                      FlSpot(2, 1.8),
                      FlSpot(3, 1.5),
                      FlSpot(4, 2.2),
                      FlSpot(5, 1.8),
                      FlSpot(6, 3),
                    ],
                    isCurved: false,
                    barWidth: 4,
                    colors: [
                      Colors.orange,
                    ],
                    belowBarData: BelowBarData(
                      show: true,
                      colors: [
                        Colors.orange.withOpacity(0.5),
                        Colors.orange.withOpacity(0.0),
                      ],
                      gradientColorStops: [0.5, 1.0],
                      gradientFrom: Offset(0, 0),
                      gradientTo: Offset(0, 1),
                      belowSpotsLine: BelowSpotsLine(
                        show: true,
                        flLineStyle: const FlLine(
                          color: Colors.blue,
                          strokeWidth: 2,
                        ),
                        checkToShowSpotBelowLine: (spot) {
                          if (spot.x == 0 || spot.x == 6) {
                            return false;
                          }

                          return true;
                        }
                      )
                    ),
                    dotData: FlDotData(
                      show: true,
                      dotColor: Colors.deepOrange,
                      dotSize: 6,
                      checkToShowDot: (spot) {
                        return spot.x != 0 && spot.x != 6;
                      }),
                  ),
                ],
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawHorizontalGrid: true,
                  drawVerticalGrid: true,
                  getDrawingVerticalGridLine: (value) {
                    if (value == 0) {
                      return const FlLine(
                        color: Colors.deepOrange,
                        strokeWidth: 2,
                      );
                    } else {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    }
                  },
                  getDrawingHorizontalGridLine: (value) {
                    if (value == 0) {
                      return const FlLine(
                        color: Colors.black,
                        strokeWidth: 2,
                      );
                    } else {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  getHorizontalTitles: (value) {
                    return weekDays[value.toInt()];
                  },
                  getVerticalTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return "";
                      case 1:
                        return "1k colories";
                      case 2:
                        return "2k colories";
                      case 3:
                        return "3k colories";
                    }

                    return "";
                  },
                  horizontalTitlesTextStyle: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                  verticalTitlesTextStyle: TextStyle(color: Colors.black, fontSize: 10)),
              ),
            ),
          ),
        ),
      ],
    );
  }

}