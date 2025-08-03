import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_management_app/models/category_model.dart';
import 'package:money_management_app/views/report/widgets/distribusi_chart.dart';
import 'package:money_management_app/views/report/widgets/kategori_pengeluaran.dart';
import 'package:money_management_app/views/report/widgets/pemasukan_pengeluaran_chart.dart';
import 'package:money_management_app/views/report/widgets/ringkasan_bulan_ini.dart';
import 'package:money_management_app/views/report/widgets/summary_info.dart';
import 'package:money_management_app/views/report/widgets/tren_saldo_bulanan.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 4),
      appBar: AppBar(title: const Text('Laporan Keuangan')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          DistribusiChart(data: CategoryModel.sampleData),
          const SizedBox(height: 32),
          PemasukanPengeluaranChart(),
          const SizedBox(height: 32),
          RingkasanBulanIni(),
          const SizedBox(height: 32),
          KategoriPengeluaran(),
          const SizedBox(height: 32),
          TrenSaldoBulanan(),
        ],
      ),
    );
  }
}
