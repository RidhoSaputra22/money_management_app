import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/filter_model.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/views/income/bloc/income_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_event.dart';
import 'package:money_management_app/views/income/bloc/income_state.dart';
import 'package:money_management_app/views/income/views/income_form.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/views/shared/filter_form.dart';
import 'package:money_management_app/views/shared/list_card.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

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
        value: context.read<IncomeBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilterForm(
            filter: FilterModel(
              budgetId: filterApply?["budgetId"],
              from: filterApply?["from"],
              to: filterApply?["to"],
            ),
            onFilter: (filter) {
              context.read<IncomeBloc>().add(
                FilteredIncomeEvent(
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

  void _addIncome(BuildContext context, List<BudgetModel> budgets) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<IncomeBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IncomeForm(
            budgets: budgets,
            onSubmit: (income) {
              context.read<IncomeBloc>().add(CreateIncomeEvent(income: income));
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _editIncome(
    BuildContext context,
    IncomeModel income,
    List<BudgetModel> budgets,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<IncomeBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IncomeForm(
            income: income,
            budgets: budgets,
            onSubmit: (updatedIncome) {
              context.read<IncomeBloc>().add(
                UpdateIncomeEvent(income: updatedIncome),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    List<IncomeModel> incomes,
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
            "Total Pemasukan",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            Utils.toIDR(
              incomes.fold<double>(0, (prev, income) => prev + income.amount),
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
                  onPressed: () => _addIncome(context, budgets),
                  tooltip: 'Tambah Pemasukan',
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
    IncomeLoaded state,
  ) {
    if (filtersApply == null || filtersApply.isEmpty) {
      return Text(
        'Total ${Utils.toIDR(state.incomes.fold<double>(0, (prev, income) => prev + income.amount))}',
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
                userId: '',
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
                context.read<IncomeBloc>().add(
                  FilteredIncomeEvent(
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

  Widget _buildIncomeList(
    List<IncomeModel> incomes,
    List<BudgetModel> budgets,
    BuildContext context,
  ) {
    if (incomes.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data pemasukan',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        final item = incomes[index];
        return ListCard(
          onTap: () => _editIncome(context, item, budgets),
          title: item.source,
          subtitle: Utils.formatDateIndonesian(item.createAt),
          amount: item.amount,
          type: 'Income',
          color: Colors.green,
          action: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<IncomeBloc>().add(DeleteIncomeEvent(income: item));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(title: const Text('Kelola Pemasukan')),
      body: BlocListener<IncomeBloc, IncomeState>(
        listener: (context, state) {
          if (state is IncomeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is IncomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<IncomeBloc, IncomeState>(
          builder: (context, state) {
            if (state is IncomeInitial) {
              context.read<IncomeBloc>().add(LoadIncomeEvent());
              return const Center(child: CircularProgressIndicator());
            }
            if (state is IncomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is IncomeLoaded) {
              final incomes = state.incomes;
              final budgets = state.budgets;
              return Column(
                children: [
                  _buildHeaderCard(incomes, budgets, context),
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
                                'Daftar Pemasukan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.filter_list),
                                tooltip: 'Filter Pemasukan',
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
                                'Jumlah: ${incomes.length}',
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
                            child: _buildIncomeList(incomes, budgets, context),
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
