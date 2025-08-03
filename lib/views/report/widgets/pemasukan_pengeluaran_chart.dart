import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class PemasukanPengeluaranChart extends StatefulWidget {
  const PemasukanPengeluaranChart({super.key});

  @override
  State<PemasukanPengeluaranChart> createState() =>
      _PemasukanPengeluaranChartState();
}

class _PemasukanPengeluaranChartState extends State<PemasukanPengeluaranChart> {
  final monthlyIncome = [5, 6, 7];
  final incomeData = [4200000, 4500000, 4700000];
  final expenseData = [3200000, 3400000, 3600000];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Pemasukan & Pengeluaran Bulanan'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                maxY: 5,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) =>
                          Text('${value.toInt()} jt'),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        if (value % 2 != 0) return const SizedBox();
                        final index = value ~/ 2;
                        if (index >= monthlyIncome.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Bln ${monthlyIncome[index]}'),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
                barGroups: List.generate(monthlyIncome.length * 2, (i) {
                  final isIncome = i % 2 == 0;
                  final index = i ~/ 2;

                  final value = isIncome
                      ? incomeData[index]
                      : expenseData[index];

                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: value.toDouble() / 1000000,
                        color: isIncome ? Colors.green : Colors.red,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text('Pemasukan'),
              const SizedBox(width: 18),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text('Pengeluaran'),
            ],
          ),
        ],
      ),
    );
  }
}
