import 'package:flutter/material.dart';
import 'package:money_management_app/models/category_model.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class KategoriPengeluaran extends StatefulWidget {
  const KategoriPengeluaran({super.key});

  @override
  State<KategoriPengeluaran> createState() => _KategoriPengeluaranState();
}

class _KategoriPengeluaranState extends State<KategoriPengeluaran> {
  final categoryData = CategoryModel.sampleData;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Kategori Pengeluaran Terbesar'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          ...categoryData
              .toList()
              .where((d) => (d.amount as num) > 0)
              .toList()
              .map(
                (data) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: data.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(data.category)),
                      Text('Rp${data.amount}'),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
