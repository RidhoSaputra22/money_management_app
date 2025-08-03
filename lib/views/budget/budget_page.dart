import 'package:flutter/material.dart';
import 'package:money_management_app/views/budget/budget_form.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final List<Map<String, dynamic>> budgets = [
    {'category': 'Makanan', 'amount': 500000},
    {'category': 'Transportasi', 'amount': 200000},
    {'category': 'Hiburan', 'amount': 150000},
  ];

  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();

  int get totalBudget =>
      budgets.fold(0, (sum, item) => sum + item['amount'] as int);

  void _addBudget() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B233A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: BudgetForm(
            onSubmit: (category, amount) {
              setState(() {
                budgets.add({'category': category, 'amount': amount});
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      appBar: AppBar(title: const Text('Kelola Budget')),
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
                  "Total Budget",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp${totalBudget.toString()}",
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
                        onPressed: _addBudget,
                        tooltip: 'Tambah Budget',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // List Budget
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Budget',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: budgets.length,
                      itemBuilder: (context, index) {
                        final item = budgets[index];
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
                              backgroundColor: Colors.teal.withOpacity(0.15),
                              child: const Icon(
                                Icons.category,
                                color: Colors.teal,
                              ),
                            ),
                            title: Text(
                              item['category'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1B233A),
                              ),
                            ),
                            trailing: Text(
                              'Rp${item['amount']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
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
