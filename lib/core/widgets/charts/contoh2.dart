import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Contoh2(),
    );
  }
}

class Contoh2 extends StatefulWidget {
  const Contoh2({super.key});

  @override
  State createState() => _Contoh2State();
}

class _Contoh2State extends State<Contoh2> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y.toDouble()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                barGroups: [
                  generateGroupData(1, 10),
                  generateGroupData(2, 18),
                  generateGroupData(3, 4),
                  generateGroupData(4, 11),
                ],
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback: (event, response) {
                    if (response != null && response.spot != null && event is FlTapUpEvent) {
                      setState(() {
                        final x = response.spot!.touchedBarGroup.x;
                        final isShowing = showingTooltip == x;
                        if (isShowing) {
                          showingTooltip = -1;
                        } else {
                          showingTooltip = x;
                        }
                      });
                    }
                  },
                  mouseCursorResolver: (event, response) {
                    return response == null || response.spot == null
                        ? MouseCursor.defer
                        : SystemMouseCursors.click;
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}