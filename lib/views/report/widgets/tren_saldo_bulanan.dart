import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class TrenSaldoBulanan extends StatefulWidget {
  const TrenSaldoBulanan({super.key});

  @override
  State<TrenSaldoBulanan> createState() => _TrenSaldoBulananState();
}

class _TrenSaldoBulananState extends State<TrenSaldoBulanan> {
  final monthlyIncome = [5, 6, 7];
  final incomeData = [4200000, 4500000, 4700000];
  final expenseData = [3200000, 3400000, 360];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Tren Saldo Bulanan'),
      content: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            maxY: 50,
            minY: 0,
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) => Text('${value.toInt()} jt'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= monthlyIncome.length) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Bln ${monthlyIncome[index]}'),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(),
              topTitles: AxisTitles(),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(monthlyIncome.length, (i) {
                  final saldo = incomeData[i] - expenseData[i];
                  return FlSpot(i.toDouble(), saldo.toDouble() / 1000000);
                }),
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
