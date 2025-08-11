import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';

import 'package:money_management_app/views/shared/buttons/cancel_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';

class KategoriForm extends StatefulWidget {
  final Function(KategoriModel kategori) onSubmit;
  final KategoriModel? kategori;

  const KategoriForm({super.key, required this.onSubmit, this.kategori});

  @override
  State<KategoriForm> createState() => _KategoriFormState();
}

class _KategoriFormState extends State<KategoriForm> {
  final _formKey = GlobalKey<FormState>();
  final _kategoriController = TextEditingController();
  final _plannedController = TextEditingController();
  Color? _selectedColor;

  double spacing = 12.0;

  @override
  void dispose() {
    _kategoriController.dispose();
    _plannedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _kategoriController.text = widget.kategori?.kategori ?? '';
    _plannedController.text = widget.kategori?.planned.toString() ?? '';
    _selectedColor = widget.kategori?.color ?? Colors.grey[300];
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final kategori = _kategoriController.text.trim();
      final planned = double.parse(_plannedController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        KategoriModel(
          id: widget.kategori?.id,
          userId: userId,
          kategori: kategori,
          planned: planned,
          createdAt: DateTime.now(),
          color: _selectedColor ?? const Color(0xFF000000),
          budgetId: widget.kategori!.budgetId,
        ),
      );
      if (widget.kategori == null) {
        _kategoriController.clear();
        _plannedController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: spacing,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Kategori'),
            controller: _kategoriController,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Kategori wajib diisi'
                : null,
          ),
          TextFormField(
            decoration: const InputDecoration().copyWith(labelText: 'Jumlah'),
            controller: _plannedController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Jumlah wajib diisi';
              final numValue = int.tryParse(value.trim());
              if (numValue == null || numValue <= 0) return 'Jumlah harus > 0';

              if (numValue > widget.kategori!.planned &&
                  widget.kategori!.id != null)
                return 'Jumlah tidak boleh lebih besar dari sisa anggaran';
              return null;
            },
          ),
          Row(
            spacing: spacing,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _selectedColor ?? Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final color = await showDialog<Color>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pilih Warna'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: _selectedColor ?? Colors.grey[300]!,
                            onColorChanged: (color) {
                              Navigator.of(context).pop(color);
                            },
                          ),
                        ),
                      ),
                    );
                    if (color != null) {
                      setState(() {
                        _selectedColor = color;
                      });
                    }
                  },
                  child: Text(
                    'Pilih Warna',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            spacing: spacing,
            children: [
              Expanded(child: SaveButton(onPressed: _submit)),
              if (widget.kategori != null)
                CancelButton(onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}
