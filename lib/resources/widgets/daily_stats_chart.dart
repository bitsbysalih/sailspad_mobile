import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyStatsChart extends StatefulWidget {
  DailyStatsChart({
    super.key,
    required this.dailyStats,
    required this.totalDailyVisits,
  });

  final List dailyStats;
  final int totalDailyVisits;

  @override
  State<StatefulWidget> createState() => DailyStatsChartState();
}

class DailyStatsChartState extends State<DailyStatsChart> {
  final Color barBackgroundColor = Color.fromARGB(255, 182, 224, 248);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xffFBFBFB),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Visitor\s in the last 30 days',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF455154),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.totalDailyVisits.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xFF64B3DF),
    double width = 1,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => widget.dailyStats.map((i) {
        switch (i) {
          case 0:
            return makeGroupData(0, i.toDouble());
          case 1:
            return makeGroupData(1, i.toDouble());
          case 2:
            return makeGroupData(2, i.toDouble());
          case 3:
            return makeGroupData(3, i.toDouble());
          case 4:
            return makeGroupData(4, i.toDouble());
          case 5:
            return makeGroupData(5, i.toDouble());
          case 6:
            return makeGroupData(6, i.toDouble());
          case 7:
            return makeGroupData(
              7,
              i.toDouble(),
            );
          case 8:
            return makeGroupData(
              8,
              i.toDouble(),
            );
          case 9:
            return makeGroupData(
              9,
              i.toDouble(),
            );
          case 10:
            return makeGroupData(
              10,
              i.toDouble(),
            );
          case 11:
            return makeGroupData(
              11,
              i.toDouble(),
            );
          default:
            return makeGroupData(
              12,
              i.toDouble(),
            );
        }
      }).toList();

  BarChartData mainBarData() {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 5,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('', style: style);
        break;
      case 2:
        text = const Text('', style: style);
        break;
      case 3:
        text = const Text('', style: style);
        break;
      case 4:
        text = const Text('', style: style);
        break;
      case 5:
        text = const Text('', style: style);
        break;
      case 6:
        text = const Text('', style: style);
        break;
      case 7:
        text = const Text('', style: style);
        break;
      case 8:
        text = const Text('', style: style);
        break;
      case 9:
        text = const Text('', style: style);
        break;
      case 10:
        text = const Text('', style: style);
        break;
      case 11:
        text = const Text('', style: style);
        break;
      default:
        text = const Text('Dec', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
