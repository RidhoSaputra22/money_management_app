import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/views/shared/buttons/cancel_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';

class IncomeForm extends StatefulWidget {
  final Function(IncomeModel income) onSubmit;
  final IncomeModel? income;
  final List<BudgetModel> budgets; // Tambahkan list budget

  const IncomeForm({
    super.key,
    required this.onSubmit,
    this.income,
    required this.budgets,
  });

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();
  // String? _selectedBudgetId;
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
    _sourceController.text = widget.income?.source ?? '';
    _amountController.text = widget.income?.amount.toString() ?? '';
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final source = _sourceController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        IncomeModel(
          userId: userId,
          id: widget.income?.id ?? '',
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
          Spacer(),
          Row(
            spacing: spacing,
            children: [
              Expanded(child: SaveButton(onPressed: _submit)),
              if (widget.income != null)
                CancelButton(onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}
