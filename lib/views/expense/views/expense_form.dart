import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/views/expense/views/kategori_pickers.dart';

import 'package:money_management_app/views/shared/buttons/cancel_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';

class ExpenseForm extends StatefulWidget {
  final Function(ExpenseModel expense) onSubmit;
  final ExpenseModel? expense;
  final List<BudgetModel> budgets; // Tambahkan list budget

  const ExpenseForm({
    super.key,
    required this.onSubmit,
    this.expense,
    required this.budgets,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBudgetId;
  KategoriModel? _selectedKategori;

  double spacing = 12.0;

  @override
  void dispose() {
    _sourceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sourceController.text = widget.expense?.source ?? '';
    _amountController.text = widget.expense?.amount.toString() ?? '';
    _selectedKategori = widget.expense?.kategoriId != null
        ? widget.budgets
              .firstWhere((budget) => budget.id == widget.expense!.budgetId)
              .kategoris!
              .firstWhere(
                (kategori) => kategori.id == widget.expense!.kategoriId,
              )
        : null;
    _selectedBudgetId =
        widget.expense?.budgetId ??
        (widget.budgets.isNotEmpty ? widget.budgets.first.id : null);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final source = _sourceController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        ExpenseModel(
          id: widget.expense?.id ?? Utils.generateUlid(),
          kategoriId: _selectedKategori!.id!,
          budgetId: _selectedBudgetId!,
          userId: userId,
          source: source,
          amount: amount,
          createAt: DateTime.now(),
        ),
      );
      _sourceController.clear();
      _amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: spacing,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Budget'),
            value: _selectedBudgetId,
            items: widget.budgets
                .map(
                  (budget) => DropdownMenuItem(
                    value: budget.id,
                    child: Text(budget.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedBudgetId = value;
              });
            },
            validator: (value) =>
                value == null || value.isEmpty ? 'Pilih budget' : null,
          ),
          Row(
            spacing: spacing,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Sumber'),
                  controller: _sourceController,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Sumber wajib diisi'
                      : null,
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration().copyWith(
                    labelText: 'Jumlah',
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Jumlah wajib diisi';
                    final numValue = int.tryParse(value.trim());
                    if (numValue == null || numValue <= 0)
                      return 'Jumlah harus > 0';
                    return null;
                  },
                ),
              ),
            ],
          ),
          if (_selectedBudgetId != null)
            KategoriPickers(
              categories: widget.budgets
                  .firstWhere((budget) => budget.id == _selectedBudgetId)
                  .kategoris!,
              selectedCategory: _selectedKategori,
              onCategorySelected: (kategori) {
                setState(() {
                  _selectedKategori = kategori;
                });
              },
            ),
          Spacer(),
          Row(
            spacing: spacing,
            children: [
              Expanded(child: SaveButton(onPressed: _submit)),
              if (widget.expense != null)
                CancelButton(onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}
