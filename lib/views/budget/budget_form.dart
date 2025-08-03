import 'package:flutter/material.dart';

class BudgetForm extends StatefulWidget {
  final Function(String category, int amount) onSubmit;

  const BudgetForm({super.key, required this.onSubmit});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final category = _categoryController.text.trim();
      final amount = int.parse(_amountController.text.trim());
      widget.onSubmit(category, amount);
      _categoryController.clear();
      _amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Kategori',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Kategori wajib diisi'
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah (Rp)',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
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
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _submit,
              tooltip: 'Tambah Budget',
            ),
          ),
        ],
      ),
    );
  }
}
