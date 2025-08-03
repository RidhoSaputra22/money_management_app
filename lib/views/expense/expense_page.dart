import 'package:flutter/material.dart';
import 'package:money_management_app/views/expense/expense_form.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final List<Map<String, dynamic>> expenses = [
    {'category': 'Makanan', 'amount': 75000, 'date': '2025-08-03'},
    {'category': 'Transportasi', 'amount': 25000, 'date': '2025-08-02'},
    {'category': 'Hiburan', 'amount': 50000, 'date': '2025-08-01'},
  ];

  void _addExpense() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B233A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ExpenseForm(
            onSubmit: (category, amount) {
              setState(() {
                expenses.add({
                  'category': category,
                  'amount': amount,
                  'date': DateTime.now().toIso8601String().substring(0, 10),
                });
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  int get totalExpense =>
      expenses.fold(0, (sum, item) => sum + item['amount'] as int);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      appBar: AppBar(title: const Text('Kelola Pengeluaran'), elevation: 0),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Pengeluaran",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp${totalExpense.toString()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 8),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: _addExpense,
                        tooltip: 'Tambah Pengeluaran',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // List Expense
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Pengeluaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final item = expenses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red.withOpacity(0.15),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                            ),
                            title: Text(
                              item['category'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1B233A),
                              ),
                            ),
                            subtitle: Text(
                              item['date'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            trailing: Text(
                              'Rp${item['amount']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
