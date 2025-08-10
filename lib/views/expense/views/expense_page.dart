import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/filter_model.dart';
import 'package:money_management_app/views/expense/blocs/expense_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_event.dart';
import 'package:money_management_app/views/expense/blocs/expense_state.dart';
import 'package:money_management_app/views/expense/views/expense_form.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/views/shared/filter_form.dart';
import 'package:money_management_app/views/shared/list_card.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  void _showFilterDialog(
    BuildContext context,
    Map<String?, dynamic>? filterApply,
    List<BudgetModel> budgets,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ExpenseBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilterForm(
            filter: FilterModel(
              budgetId: filterApply?["budgetId"],
              from: filterApply?["from"],
              to: filterApply?["to"],
            ),
            budgets: budgets,
            onFilter: (filter) {
              context.read<ExpenseBloc>().add(
                FilteredExpenseEvent(
                  budgetId: filter.budgetId,
                  from: filter.from,
                  to: filter.to,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _addExpense(BuildContext context, List<BudgetModel> budgets) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ExpenseBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ExpenseForm(
            budgets: budgets,
            onSubmit: (expense) {
              context.read<ExpenseBloc>().add(
                CreateExpenseEvent(expense: expense),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _editExpense(
    BuildContext context,
    ExpenseModel expense,
    List<BudgetModel> budgets,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ExpenseBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ExpenseForm(
            expense: expense,
            budgets: budgets,
            onSubmit: (updatedExpense) {
              context.read<ExpenseBloc>().add(
                UpdateExpenseEvent(expense: updatedExpense),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    List<ExpenseModel> expenses,
    List<BudgetModel> budgets,
    BuildContext context,
  ) {
    return Container(
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
            Utils.toIDR(
              expenses.fold<double>(
                0,
                (prev, expense) => prev + expense.amount,
              ),
            ),
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
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _addExpense(context, budgets),
                  tooltip: 'Tambah Pengeluaran',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    Map<String?, dynamic>? filtersApply,
    List<BudgetModel> budgets,
    BuildContext context,
    ExpenseLoaded state,
  ) {
    if (filtersApply == null || filtersApply.isEmpty) {
      return Text(
        'Total ${Utils.toIDR(state.expenses.fold<double>(0, (prev, expense) => prev + expense.amount))}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filtersApply.entries.map((entry) {
          String label;
          if (entry.key == 'budgetId') {
            final budget = budgets.firstWhere(
              (b) => b.id == entry.value,
              orElse: () => BudgetModel(
                id: '',
                name: 'Semua',
                amount: 0,
                startAt: DateTime.now(),
                endAt: DateTime.now(),
              ),
            );
            label = 'Budget: ${budget.name}';
          } else if (entry.key == 'from') {
            label =
                'Min: ${Utils.toIDR((entry.value is num) ? entry.value.toDouble() : 0)}';
          } else if (entry.key == 'to') {
            label =
                'Max: ${Utils.toIDR((entry.value is num) ? entry.value.toDouble() : 0)}';
          } else {
            label = '${entry.key}: ${entry.value ?? 'Semua'}';
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(label),
              backgroundColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onDeleted: () {
                context.read<ExpenseBloc>().add(
                  FilteredExpenseEvent(
                    budgetId: entry.key == 'budgetId'
                        ? null
                        : (filtersApply['budgetId'] as String?),
                    from: entry.key == 'from'
                        ? null
                        : (filtersApply['from'] is num
                              ? (filtersApply['from'] as num).toDouble()
                              : null),
                    to: entry.key == 'to'
                        ? null
                        : (filtersApply['to'] is num
                              ? (filtersApply['to'] as num).toDouble()
                              : null),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseList(
    List<ExpenseModel> expenses,
    List<BudgetModel> budgets,
    BuildContext context,
  ) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data pemasukan',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final item = expenses[index];
        return ListCard(
          onTap: () => _editExpense(context, item, budgets),
          title: item.source,
          subtitle: Utils.formatDateIndonesian(item.createAt),
          trailingText: Utils.toIDR(item.amount),
          leadingIcon: Icons.attach_money,
          leadingColor: Colors.green,
          iconColor: Colors.green,
          trailingColor: Colors.green,
          action: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<ExpenseBloc>().add(
                DeleteExpenseEvent(expense: item),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      appBar: AppBar(title: const Text('Kelola Pengeluaran')),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseInitial) {
              context.read<ExpenseBloc>().add(LoadExpenseEvent());
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpenseLoaded) {
              final expenses = state.expenses;
              final budgets = state.budgets;
              return Column(
                children: [
                  _buildHeaderCard(expenses, budgets, context),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Daftar Pengeluaran',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.filter_list),
                                tooltip: 'Filter Pengeluaran',
                                color: Colors.blue,
                                iconSize: 28,
                                onPressed: () => _showFilterDialog(
                                  context,
                                  state.filtersApply,
                                  budgets,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildFilterChips(
                                  state.filtersApply,
                                  budgets,
                                  context,
                                  state,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Jumlah: ${expenses.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.5, color: Colors.grey),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _buildExpenseList(
                              expenses,
                              budgets,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Text(
                'Tidak ada data pemasukan',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
