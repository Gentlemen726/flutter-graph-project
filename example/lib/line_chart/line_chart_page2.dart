import 'package:flutter/material.dart';

import 'samples/line_chart_sample3.dart';
import 'samples/line_chart_sample4.dart';
import 'samples/line_chart_sample5.dart';

class LineChartPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "LineChart",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            LineChartSample3(),
            LineChartSample4(),
            LineChartSample5(),
          ],
        ),
      ),
    );
  }
}
