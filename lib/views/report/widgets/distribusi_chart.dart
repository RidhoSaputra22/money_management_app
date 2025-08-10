import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/kategori_services.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class DistribusiChart extends StatefulWidget {
  DistribusiChart({super.key});

  @override
  State<DistribusiChart> createState() => _DistribusiChartState();
}

class _DistribusiChartState extends State<DistribusiChart> {
  List<KategoriModel> data = [];
  bool isLoading = true;
  bool isError = false;

  _fetch() async {
    try {
      List<KategoriModel> list = await KategoriService.fetchAll();
      setState(() {
        data = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
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
            (sum, item) => sum + (item.planned as num),
          );
          final percent = ((kategori.planned as num) / total * 100)
              .toStringAsFixed(1);
          return PieChartSectionData(
            value: ((kategori.planned) as num).toDouble(),
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
                message: '${data.kategori} (${Utils.toIDR(data.planned)})',
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
