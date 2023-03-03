import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants.dart';

class PieChartCustom extends StatelessWidget {
  final List<ChartData> chartData;

  const PieChartCustom({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom),
        tooltipBehavior: TooltipBehavior(enable: true,),
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => "${data.percent.toStringAsFixed(2)}%",
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 12,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            enableTooltip: true,
          )
        ]);
  }
}

class ChartData {
  ChartData(this.x, this.y, this.percent);

  final String x;
  final double y;
  final double percent;
}
