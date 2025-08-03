import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final Function(String category, int amount) onSubmit;

  const ExpenseForm({super.key, required this.onSubmit});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Kategori',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF232B47),
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Jumlah (Rp)',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF232B47),
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
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: _submit,
              tooltip: 'Tambah Pengeluaran',
            ),
          ),
        ],
      ),
    );
  }
}
