import 'package:flutter/widgets.dart';

class CategoryModel {
  final String category;
  final int amount;
  final Color color;
  final int planned;
  final int actual;

  CategoryModel({
    required this.category,
    required this.amount,
    required this.color,
    required this.planned,
    required this.actual,
  });

  static List<CategoryModel> get sampleData => [
    CategoryModel(
      category: 'Makanan',
      amount: 200,
      color: Color(0xFF42A5F5),
      planned: 250,
      actual: 200,
    ),
    CategoryModel(
      category: 'Transportasi',
      amount: 150,
      color: Color(0xFFFF7043),
      planned: 160,
      actual: 150,
    ),
    CategoryModel(
      category: 'Hiburan',
      amount: 100,
      color: Color(0xFF66BB6A),
      planned: 120,
      actual: 100,
    ),
    CategoryModel(
      category: 'Kesehatan',
      amount: 80,
      color: Color(0xFFFFCA28),
      planned: 90,
      actual: 80,
    ),
    CategoryModel(
      category: 'Lainnya',
      amount: 50,
      color: Color(0xFFAB47BC),
      planned: 60,
      actual: 50,
    ),
  ];
}
