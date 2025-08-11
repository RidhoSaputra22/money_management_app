import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/views/budget/blocs/budget_bloc.dart';
import 'package:money_management_app/views/budget/blocs/budget_event.dart';
import 'package:money_management_app/views/budget/blocs/budget_state.dart';
import 'package:money_management_app/views/budget/views/budget_form.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/views/shared/list_card.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  void _showBudgetForm(BuildContext context, {BudgetModel? budget}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<BudgetBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BudgetForm(
            budget: budget,
            onSubmit: (BudgetModel newBudget) {
              context.read<BudgetBloc>().add(
                budget == null
                    ? CreateBudgetEvent(budget: newBudget)
                    : UpdateBudgetEvent(budget: newBudget),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double totalBudget) {
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
            "Total Budget",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            Utils.toIDR(totalBudget.toDouble()),
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
                  onPressed: () => _showBudgetForm(context),
                  tooltip: 'Tambah Budget',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetList(BuildContext context, List<BudgetModel> budgets) {
    return Expanded(
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
                  return ListCard(
                    onTap: () => _showBudgetForm(context, budget: item),
                    title: item.name,
                    subtitle: Utils.formatDateIndonesian(item.startAt),
                    amount: item.amount,
                    type: 'Budget',
                    action: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<BudgetBloc>().add(
                          DeleteBudgetEvent(budget: item),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BudgetState state) {
    if (state is BudgetInitial) {
      context.read<BudgetBloc>().add(LoadBudgetEvent());
      return const Center(child: CircularProgressIndicator());
    }

    if (state is BudgetLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is BudgetLoaded) {
      final budgets = state.budgets;
      final totalBudget = budgets.fold<double>(
        0,
        (sum, item) => sum + (item.amount),
      );
      return Column(
        children: [
          _buildHeader(context, totalBudget),
          const SizedBox(height: 24),
          _buildBudgetList(context, budgets),
        ],
      );
    }

    return const Center(child: Text('Tidak Ada Data'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      appBar: AppBar(title: const Text('Kelola Budget')),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Budget berhasil ditambahkan')),
            );
          }
          if (state is BudgetError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: _buildBody,
      ),
    );
  }
}
