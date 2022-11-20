// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  const _BarChart({Key? key, required this.dailyStats}) : super(key: key);

  final List dailyStats;
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        baselineY: 1,
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '';
        break;
      case 1:
        text = '';
        break;
      case 2:
        text = '';
        break;
      case 3:
        text = '';
        break;
      case 4:
        text = '';
        break;
      case 5:
        text = '';
        break;
      case 6:
        text = '';
        break;
      case 7:
        text = '';
        break;
      case 8:
        text = '';
        break;
      case 9:
        text = '';
        break;
      case 10:
        text = '';
        break;
      case 11:
        text = '';
        break;
      case 12:
        text = '';
        break;
      case 13:
        text = '';
        break;
      case 14:
        text = '';
        break;
      case 15:
        text = '';
        break;
      case 16:
        text = '';
        break;
      case 17:
        text = '';
        break;
      case 18:
        text = '';
        break;
      case 19:
        text = '';
        break;
      case 20:
        text = '';
        break;
      case 21:
        text = '';
        break;
      case 22:
        text = '';
        break;
      case 23:
        text = '';
        break;
      case 24:
        text = '';
        break;
      case 25:
        text = '';
        break;
      case 26:
        text = '';
        break;
      case 27:
        text = '';
        break;
      case 28:
        text = '';
        break;
      case 29:
        text = '';
        break;

      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.lightBlueAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          barsSpace: 1,
          x: 0,
          barRods: [
            BarChartRodData(
              fromY: dailyStats[0].toDouble(),
              toY: dailyStats[0].toDouble() <= 20
                  ? dailyStats[0].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: dailyStats[1].toDouble() <= 20
                  ? dailyStats[1].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: dailyStats[2].toDouble() <= 20
                  ? dailyStats[2].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: dailyStats[3].toDouble() <= 20
                  ? dailyStats[3].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: dailyStats[4].toDouble() <= 20
                  ? dailyStats[4].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: dailyStats[5].toDouble() <= 20
                  ? dailyStats[5].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: dailyStats[6].toDouble() <= 20
                  ? dailyStats[6].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
              toY: dailyStats[7].toDouble() <= 20
                  ? dailyStats[7].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: dailyStats[8].toDouble() <= 20
                  ? dailyStats[8].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
              toY: dailyStats[9].toDouble() <= 20
                  ? dailyStats[9].toDouble()
                  : 20,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
              toY: dailyStats[10].toDouble() <= 15
                  ? dailyStats[10].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
              toY: dailyStats[11].toDouble() <= 15
                  ? dailyStats[11].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 12,
          barRods: [
            BarChartRodData(
              toY: dailyStats[12].toDouble() <= 15
                  ? dailyStats[12].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 13,
          barRods: [
            BarChartRodData(
              toY: dailyStats[13].toDouble() <= 15
                  ? dailyStats[13].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 14,
          barRods: [
            BarChartRodData(
              toY: dailyStats[14].toDouble() <= 15
                  ? dailyStats[14].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 15,
          barRods: [
            BarChartRodData(
              toY: dailyStats[15].toDouble() <= 15
                  ? dailyStats[15].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 16,
          barRods: [
            BarChartRodData(
              toY: dailyStats[16].toDouble() <= 15
                  ? dailyStats[16].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 17,
          barRods: [
            BarChartRodData(
              toY: dailyStats[17].toDouble() <= 15
                  ? dailyStats[17].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 18,
          barRods: [
            BarChartRodData(
              toY: dailyStats[18].toDouble() <= 15
                  ? dailyStats[18].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 19,
          barRods: [
            BarChartRodData(
              toY: dailyStats[19].toDouble() <= 15
                  ? dailyStats[19].toDouble()
                  : 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          barsSpace: 1,
          x: 20,
          barRods: [
            BarChartRodData(
              toY: 9,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 21,
          barRods: [
            BarChartRodData(
              toY: 11,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 22,
          barRods: [
            BarChartRodData(
              toY: 17,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 23,
          barRods: [
            BarChartRodData(
              toY: 18,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 24,
          barRods: [
            BarChartRodData(
              toY: 11,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 25,
          barRods: [
            BarChartRodData(
              toY: 6,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 26,
          barRods: [
            BarChartRodData(
              toY: 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 27,
          barRods: [
            BarChartRodData(
              toY: 11,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 28,
          barRods: [
            BarChartRodData(
              toY: 20,
              gradient: _barsGradient,
            )
          ],
        ),
        // BarChartGroupData(
        //   x: 29,
        //   barRods: [
        //     BarChartRodData(
        //       toY: dailyStats[29].toDouble() <= 15
        //           ? dailyStats[29].toDouble()
        //           : 15,
        //       gradient: _barsGradient,
        //     )
        //   ],
        // ),
      ];
}

class DailyAnalyticsBarChart extends StatefulWidget {
  const DailyAnalyticsBarChart({Key? key, required this.dailyStats})
      : super(key: key);
  final List dailyStats;

  @override
  State<StatefulWidget> createState() => DailyAnalyticsBarChartState();
}

class DailyAnalyticsBarChartState extends State<DailyAnalyticsBarChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        child: _BarChart(dailyStats: widget.dailyStats),
      ),
    );
  }
}
