import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/charts/model.dart';
import 'package:leontech/features/home/controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OmsetGlobal extends StatelessWidget {
  const OmsetGlobal(this.c, this.dechart, {this.touchedGroupIndex = -1, super.key});
  final int touchedGroupIndex;
  final List<XBarData2> dechart;
  final HomePageController c;

  @override
  Widget build(BuildContext context) {
    BarChartGroupData generateBarGroup(
      int x,
      double omset,
      double pelunasan,
      double tempo,
    ) {
      double n = (isMobile(context)) ? 7 : 12;
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: omset,
            color: Colors.blue,
            width: n,
          ),
          BarChartRodData(
            toY: pelunasan,
            color: Colors.green,
            width: n,
          ),
          BarChartRodData(
            toY: tempo,
            color: Colors.red,
            width: n,
          ),
        ],
        showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
      );
    }

    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text('Pencapaian', style: TextStyle(color: Colors.blue, fontSize: 22)).animate(delay: 1000.ms, onPlay: (controller) => controller.repeat(reverse: true)).fadeIn().scale().moveX(delay: 300.ms, duration: 600.ms, begin: 100).fadeOut(delay: 5000.ms, duration: 1000.ms),
                ),
                InkWell(
                  onTap: () {
                    c.getChart();
                  },
                  child: const Icon(Icons.refresh, size: 14, color: Colors.grey),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemLegend('Penjualan', formatuang(c.ddashb.value.total), Colors.blue, onTap: () => Get.toNamed('/penjualan')),
                ItemLegend('Pelunasan', formatuang(c.ddashb.value.pelunasan), Colors.green),
                ItemLegend('Sisa Jatuh Tempo', formatuang(c.ddashb.value.piutang), Colors.red),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BarChart(BarChartData(
                  barGroups: dechart.asMap().entries.map((e) {
                    //final index = e.key;
                    final data = e.value;
                    return generateBarGroup(
                      data.bulan,
                      data.omset,
                      data.pelunasan,
                      data.tempo,
                    );
                  }).toList(),
                  alignment: BarChartAlignment.spaceBetween,
                  borderData: FlBorderData(
                    show: false,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.black.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            style: const TextStyle(fontSize: 10),
                            value.toStringAsPrecision(3),
                            textAlign: TextAlign.left,
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ))),
            ),
          ],
        ));
  }
}

Widget makeTransactionsIcon() {
  const width = 4.5;
  const space = 3.5;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: width,
        height: 10,
        color: Colors.blue.withOpacity(0.4),
      ),
      const SizedBox(width: space),
      Container(
        width: width,
        height: 28,
        color: Colors.blue.withOpacity(0.8),
      ),
      const SizedBox(width: space),
      Container(
        width: width,
        height: 42,
        color: Colors.red.withOpacity(1),
      ),
      const SizedBox(width: space),
      Container(
        width: width,
        height: 28,
        color: Colors.green.withOpacity(0.8),
      ),
      const SizedBox(width: space),
      Container(
        width: width,
        height: 10,
        color: Colors.orange.withOpacity(0.4),
      ),
    ],
  );
}

class ItemLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String? nilai;
  final VoidCallback? onTap;
  const ItemLegend(this.label, this.nilai, this.color, {this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 10, height: 30, color: color),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Text(nilai ?? '-'),
            ],
          ),
        ],
      ),
    );
  }
}
