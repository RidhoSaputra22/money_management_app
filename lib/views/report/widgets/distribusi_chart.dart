import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/models/category_model.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class DistribusiChart extends StatefulWidget {
  final List<CategoryModel> data;
  DistribusiChart({super.key, required this.data});

  @override
  State<DistribusiChart> createState() => _DistribusiChartState();
}

class _DistribusiChartState extends State<DistribusiChart> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Distribusi Pengeluaran per Kategori'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: widget.data.map((data) {
                  final total = widget.data.fold<num>(
                    0,
                    (sum, item) => sum + (item.amount as num),
                  );
                  final percent = ((data.amount as num) / total * 100)
                      .toStringAsFixed(1);
                  return PieChartSectionData(
                    value: ((data.amount) as num).toDouble(),
                    color: data.color,
                    title: '$percent%',
                    radius: 50,
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 16,
            children: widget.data.map((data) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: data.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(data.category),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
