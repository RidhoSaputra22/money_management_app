// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/views/budget/blocs/budget_bloc.dart';
import 'package:money_management_app/views/budget/blocs/budget_event.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_bloc.dart';
import 'package:money_management_app/views/kategori/views/kategori_page.dart';
import 'package:money_management_app/views/shared/buttons/edit_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';

class BudgetForm extends StatefulWidget {
  final Function(BudgetModel budget) onSubmit;
  final BudgetModel? budget;

  const BudgetForm({super.key, required this.onSubmit, this.budget});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  String _range = 'monthly';

  double spacing = 12.0;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _nameController.text = widget.budget!.name;
      _amountController.text = widget.budget!.amount.toString();
      _descriptionController.text = widget.budget!.description ?? '';
      _range = widget.budget!.range;
      _selectedMonth = widget.budget!.startAt.month;
      _selectedYear = widget.budget!.startAt.year;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final startAt = DateTime(_selectedYear, _selectedMonth, 1);
      final endAt = DateTime(_selectedYear, _selectedMonth + 1, 0);
      final budget = BudgetModel(
        userId: await AuthService().getCurrentUserId(),
        id: widget.budget?.id,
        name: _nameController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        startAt: startAt,
        endAt: endAt,
        range: _range,
        description: _descriptionController.text.trim(),
      );
      widget.onSubmit(budget);
      _nameController.clear();
      _amountController.clear();
      _descriptionController.clear();
      setState(() {
        _range = 'monthly';
      });
    }
  }

  void _kategoriButtonPressed() async {
    BudgetModel budget = BudgetModel(
      userId: await AuthService().getCurrentUserId(),
      id: widget.budget?.id,
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      startAt: DateTime(_selectedYear, _selectedMonth, 1),
      endAt: DateTime(_selectedYear, _selectedMonth + 1, 0),
      range: _range,
      description: _descriptionController.text.trim(),
    );

    if (widget.budget == null) {
      context.read<BudgetBloc>().add(CreateBudgetEvent(budget: budget));
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => KategoriBloc(),
          child: KategoriPage(budget: budget),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear + i);
    final months = List.generate(12, (i) => i + 1);

    return Form(
      key: _formKey,
      child: Column(
        spacing: spacing,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nama Budget',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama wajib diisi'
                : null,
          ),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah (Rp)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Jumlah wajib diisi';
              }
              final numValue = double.tryParse(value.trim());
              if (numValue == null || numValue <= 0) return 'Jumlah harus > 0';
              return null;
            },
          ),

          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Deskripsi (opsional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Row(
            spacing: spacing,
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedMonth,
                  decoration: InputDecoration(
                    labelText: 'Bulan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: months
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(
                            DateFormat('MMMM', 'id_ID').format(DateTime(0, m)),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value ?? DateTime.now().month;
                    });
                  },
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedYear,
                  decoration: InputDecoration(
                    labelText: 'Tahun',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: years
                      .map(
                        (y) => DropdownMenuItem(
                          value: y,
                          child: Text(y.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value ?? DateTime.now().year;
                    });
                  },
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            spacing: spacing,

            children: [
              Expanded(
                child: SaveButton(
                  onPressed: () {
                    _submit();
                  },
                ),
              ),
              if (widget.budget != null) ...[
                EditButton(
                  label: "Kategori",
                  onPressed: () {
                    _kategoriButtonPressed();
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
