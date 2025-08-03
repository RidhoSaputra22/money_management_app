import 'package:flutter/material.dart';
import 'package:money_management_app/views/income/income_form.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final List<Map<String, dynamic>> incomes = [
    {'category': 'Gaji', 'amount': 5000000, 'date': '2025-08-01'},
    {'category': 'Freelance', 'amount': 1200000, 'date': '2025-08-02'},
    {'category': 'Bonus', 'amount': 800000, 'date': '2025-08-03'},
  ];

  void _addIncome() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: IncomeForm(
            onSubmit: (category, amount) {
              setState(() {
                incomes.add({
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

  int get totalIncome =>
      incomes.fold(0, (sum, item) => sum + item['amount'] as int);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(title: const Text('Kelola Pemasukan')),
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
                  "Total Pemasukan",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp${totalIncome.toString()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 8),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addIncome,
                        tooltip: 'Tambah Pemasukan',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // List Income
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Pemasukan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: incomes.length,
                      itemBuilder: (context, index) {
                        final item = incomes[index];
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
                              backgroundColor: Colors.green.withOpacity(0.15),
                              child: const Icon(
                                Icons.attach_money,
                                color: Colors.green,
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
                                color: Colors.green,
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
