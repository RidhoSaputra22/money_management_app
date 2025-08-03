import 'package:flutter/material.dart';
import 'package:money_management_app/views/report/widgets/summary_info.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class RingkasanBulanIni extends StatefulWidget {
  const RingkasanBulanIni({super.key});

  @override
  State<RingkasanBulanIni> createState() => _RingkasanBulanIniState();
}

class _RingkasanBulanIniState extends State<RingkasanBulanIni> {
  final monthlyIncome = [5, 6, 7];
  final incomeData = [4200000, 4500000, 4700000];
  final expenseData = [3200000, 3400000, 3600000];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Ringkasan Bulan Ini'),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SummaryInfo(
              label: 'Pemasukan',
              value: 'Rp${incomeData.last}',
              color: Colors.green,
            ),
            const SizedBox(width: 24),
            SummaryInfo(
              label: 'Pengeluaran',
              value: 'Rp${expenseData.last}',
              color: Colors.red,
            ),
            const SizedBox(width: 24),
            SummaryInfo(
              label: 'Saldo',
              value: 'Rp${incomeData.last - expenseData.last}',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
