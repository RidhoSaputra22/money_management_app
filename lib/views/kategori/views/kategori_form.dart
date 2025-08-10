import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
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
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final kategori = _kategoriController.text.trim();
      final planned = double.parse(_plannedController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        KategoriModel(
          userId: userId,
          kategori: kategori,
          planned: planned,
          createdAt: DateTime.now(),
          budgetId: widget.kategori!.budgetId,
        ),
      );
      _kategoriController.clear();
      _plannedController.clear();
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
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  controller: _kategoriController,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Kategori wajib diisi'
                      : null,
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration().copyWith(
                    labelText: 'Jumlah',
                  ),
                  controller: _plannedController,
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
              if (widget.kategori != null)
                CancelButton(onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}
