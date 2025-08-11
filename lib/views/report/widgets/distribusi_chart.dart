import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/kategori_services.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class DistribusiData {
  final String kategori;
  final double total;
  final Color color;

  DistribusiData({
    required this.kategori,
    required this.total,
    required this.color,
  });
}

class DistribusiChart extends StatefulWidget {
  const DistribusiChart({super.key});

  @override
  State<DistribusiChart> createState() => _DistribusiChartState();
}

class _DistribusiChartState extends State<DistribusiChart> {
  List<DistribusiData> data = [];
  bool isLoading = true;
  bool isError = false;

  Future<void> _fetch() async {
    try {
      // Fetch kategori and expense in parallel
      final results = await Future.wait([
        KategoriService.fetchAll(),
        ExpenseService.fetchAll(),
      ]);
      final kategoriList = results[0] as List<KategoriModel>;
      final expenseList = results[1] as List<ExpenseModel>;

      // Build kategori lookup and color map
      final kategoriMap = {for (var k in kategoriList) k.id!: k};
      final Map<String, double> totalPerKategori = {};
      final Map<String, Color> colorPerKategori = {};

      // Aggregate totals per kategori
      for (var expense in expenseList) {
        final kategori = kategoriMap[expense.kategoriId];
        if (kategori == null) continue;
        totalPerKategori.update(
          kategori.kategori,
          (v) => v + expense.amount,
          ifAbsent: () => expense.amount,
        );
        colorPerKategori.putIfAbsent(
          kategori.kategori,
          () => kategori.color ?? Colors.grey,
        );
      }

      // Prepare chart data
      final distribusiDataList = totalPerKategori.entries
          .map(
            (entry) => DistribusiData(
              kategori: entry.key,
              total: entry.value,
              color: colorPerKategori[entry.key] ?? Colors.grey,
            ),
          )
          .toList();

      setState(() {
        data = distribusiDataList;
        isLoading = false;
        isError = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: data.map((kategori) {
          final total = data.fold<num>(
            0,
            (sum, item) => sum + (item.total as num),
          );
          final percent = ((kategori.total as num) / total * 100)
              .toStringAsFixed(1);
          return PieChartSectionData(
            value: ((kategori.total) as num).toDouble(),
            color: kategori.color,
            title: '$percent%',
            radius: 50,
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildDetailChart() {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 16,
        children: data.map((data) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              Tooltip(
                preferBelow: false,
                message: '${data.kategori} (${Utils.toIDR(data.total)})',
                child: Text(
                  data.kategori,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text(
        'Distribusi Pengeluaran Per Kategori',
        textAlign: TextAlign.center,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          SizedBox(
            height: 180,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildPieChart(),
          ),
          const SizedBox(height: 18),
          _buildDetailChart(),
        ],
      ),
    );
  }
}
