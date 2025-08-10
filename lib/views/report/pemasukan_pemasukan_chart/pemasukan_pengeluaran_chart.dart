import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/widgets/custom_card.dart';
import 'components/pemasukan_pengeluaran_bar_chart.dart';
import 'components/legend_row.dart';
import 'components/dropdowns_row.dart';

class PemasukanPengeluaranChart extends StatefulWidget {
  const PemasukanPengeluaranChart({super.key});

  @override
  State<PemasukanPengeluaranChart> createState() =>
      _PemasukanPengeluaranChartState();
}

class _PemasukanPengeluaranChartState extends State<PemasukanPengeluaranChart> {
  List<IncomeModel> _incomeData = [];
  List<ExpenseModel> _expenseData = [];
  bool _isLoading = true;

  String _viewType = 'Tahunan';
  int _selectedMonth = DateTime.now().month - 1;

  final List<String> _viewTypes = ['Tahunan', 'Bulanan'];
  final List<String> _months = Utils.getListMonthNames();

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final firestore = FirebaseFirestore.instance;
    final expensesSnapshot = await firestore
        .collection('expenses')
        .orderBy('createAt')
        .get();
    final incomesSnapshot = await firestore
        .collection('incomes')
        .orderBy('createAt')
        .get();

    setState(() {
      _incomeData = incomesSnapshot.docs
          .map((doc) => IncomeModel.fromMap(doc.data()))
          .toList();
      _expenseData = expensesSnapshot.docs
          .map((doc) => ExpenseModel.fromMap(doc.data()))
          .toList();
      _isLoading = false;
    });
  }

  void _onViewTypeChanged(String? value) {
    if (value != null) setState(() => _viewType = value);
  }

  void _onMonthChanged(int? value) {
    if (value != null) setState(() => _selectedMonth = value);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Pemasukan & Pengeluaran Bulanan'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownsRow(
            viewType: _viewType,
            selectedMonth: _selectedMonth,
            viewTypes: _viewTypes,
            months: _months,
            onViewTypeChanged: _onViewTypeChanged,
            onMonthChanged: _onMonthChanged,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 250,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PemasukanPengeluaranBarChart(
                    viewType: _viewType,
                    selectedMonth: _selectedMonth,
                    incomeData: _incomeData,
                    expenseData: _expenseData,
                  ),
          ),
          const SizedBox(height: 100),
          const LegendRow(),
        ],
      ),
    );
  }
}
