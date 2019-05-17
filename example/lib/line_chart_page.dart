import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class LineChartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("LineChart", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
          SizedBox(child: sample1(), width: 300, height: 140,),
          SizedBox(child: sample2(), width: 300, height: 140,),
          SizedBox(child: sample3(), width: 300, height: 140,),
        ],
      ),
    );
  }

  Widget sample3() {
    return FlChartWidget(
      flChart: LineChart(
        LineChartData(
          spots: [
            LineChartSpot(0, 1),
            LineChartSpot(1, 2),
            LineChartSpot(2, 1.5),
            LineChartSpot(3, 3),
            LineChartSpot(4, 3.5),
            LineChartSpot(5, 5),
            LineChartSpot(6, 8),
          ],
          barData: LineChartBarData(
            isCurved: true,
            barWidth: 4,
          ),
          showBelowBar: true,
          showDots: false,
          titlesData: LineChartTitlesData(
            getVerticalTitle: (val) {
              return "";
            },
            verticalTitleMargin: 0,
            verticalTitlesReservedWidth: 0,
            getHorizontalTitle: (val) {
              switch (val.toInt()) {
                case 0:
                  return "00:00";
                case 1:
                  return "04:00";
                case 2:
                  return "08:00";
                case 3:
                  return "12:00";
                case 4:
                  return "16:00";
                case 5:
                  return "20:00";
                case 6:
                  return "23:59";
              }
              return "";
            },
            horizontalTitlesTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontFamily: "Digital",
              fontSize: 18,
            )
          ),
          showGridLines: false,
          showBorder: true,
        ),
      ),
    );
  }

  Widget sample2() {
    return FlChartWidget(
      flChart: LineChart(
        LineChartData(
          spots: [
            LineChartSpot(0, 4),
            LineChartSpot(1, 3.5),
            LineChartSpot(2, 4.5),
            LineChartSpot(3, 1),
            LineChartSpot(4, 4),
            LineChartSpot(5, 6),
            LineChartSpot(6, 6.5),
            LineChartSpot(7, 6),
            LineChartSpot(8, 4),
            LineChartSpot(9, 6),
            LineChartSpot(10, 6),
            LineChartSpot(11, 7),
          ],
          barData: LineChartBarData(
            isCurved: true,
            barWidth: 8,
            barColor: Colors.purpleAccent,
          ),
          showBelowBar: true,
          belowBarData: BelowBarData(
            colors: [Colors.deepPurple.withOpacity(0.2)],
          ),
          titlesData: LineChartTitlesData(
            horizontalTitlesTextStyle: TextStyle(
              fontSize: 10,
              color: Colors.purple,
              fontWeight: FontWeight.bold
            ),
            getVerticalTitle: (value) {
              return "\$ ${value + 0.5}";
            },
            getHorizontalTitle: (value) {
              switch(value.toInt()) {
                case 0:
                  return "Jan";
                case 1:
                  return "Feb";
                case 2:
                  return "Mar";
                case 3:
                  return "Apr";
                case 4:
                  return "May";
                case 5:
                  return "Jun";
                case 6:
                  return "Jul";
                case 7:
                  return "Aug";
                case 8:
                  return "Sep";
                case 9:
                  return "Oct";
                case 10:
                  return "Nov";
                case 11:
                  return "Dec";
              }
            }
          ),
          showDots: false,
          showGridLines: true,
          gridData: LineChartGridData(
            checkToShowVerticalGrid: (double value) {
              return value == 1 || value == 6 || value == 4 || value == 5;
            }
          ),
        ),
      ),
    );
  }

  Widget sample1() {
    return FlChartWidget(
      flChart: LineChart(
        LineChartData(
          spots: [
            LineChartSpot(0, 1.3),
            LineChartSpot(1, 1),
            LineChartSpot(2, 1.8),
            LineChartSpot(3, 1.5),
            LineChartSpot(4, 2.2),
            LineChartSpot(5, 1.8),
            LineChartSpot(6, 3),
          ],
          barData: LineChartBarData(
            isCurved: false,
            barWidth: 4,
            barColor: Colors.orange,
          ),
          showBelowBar: true,
          belowBarData: BelowBarData(
            colors: [Colors.orange, Colors.orange.withOpacity(0.0),],
            colorStops: [0.5, 1.0],
            from: Offset(0, 0),
            to: Offset(0, 1),
          ),
          showDots: true,
          dotData: LineChartDotData(
            dotColor: Colors.deepOrange,
            dotSize: 6,
            checkToShowDot: (spot) {
              return spot.x != 0 && spot.x != 6;
            }
          ),
          showGridLines: true,
          gridData: LineChartGridData(
            drawHorizontalGrid: true,
            drawVerticalGrid: true,
          ),
          titlesData: LineChartTitlesData(
            getHorizontalTitle: (value) {
              switch (value.toInt()) {
                case 0:
                  return 'Sat';

                case 1:
                  return 'Sun';

                case 2:
                  return 'Mon';

                case 3:
                  return 'Tue';

                case 4:
                  return 'Wed';

                case 5:
                  return 'Thu';

                case 6:
                  return 'Fri';
              }

              return '';
            },
            getVerticalTitle: (value) {
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
            verticalTitlesTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 10
            )
          ),
          showBorder: false,
        ),
      ),
    );
  }

}