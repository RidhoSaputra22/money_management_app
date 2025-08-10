import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:money_management_app/models/kategori_model.dart';

class BudgetModel {
  final String? id;
  final String name;
  final double amount;
  final DateTime startAt;
  final DateTime endAt;
  final String range; // Tambahan: 'monthly', 'weekly', 'yearly', dll
  final String? description;
  final DateTime createdAt;
  final List<KategoriModel>? kategoris;

  BudgetModel({
    DateTime? createdAt,
    this.id,
    required this.name,
    required this.amount,
    required this.startAt,
    required this.endAt,
    this.range = 'bulanan', // default bulanan
    this.description,
    this.kategoris,
  }) : createdAt = createdAt ?? DateTime.now();

  BudgetModel copyWith({
    ValueGetter<String?>? id,
    String? name,
    double? amount,
    DateTime? startAt,
    DateTime? endAt,
    String? range,
    ValueGetter<String?>? description,
    DateTime? createdAt,
    ValueGetter<List<KategoriModel>?>? kategoris,
  }) {
    return BudgetModel(
      id: id != null ? id() : this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      range: range ?? this.range,
      description: description != null ? description() : this.description,
      createdAt: createdAt ?? this.createdAt,
      kategoris: kategoris != null ? kategoris() : this.kategoris,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'startAt': startAt.millisecondsSinceEpoch,
      'endAt': endAt.millisecondsSinceEpoch,
      'range': range,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'kategoris': kategoris?.map((x) => x.toMap()).toList(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      name: map['name'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      startAt: DateTime.fromMillisecondsSinceEpoch(map['startAt']),
      endAt: DateTime.fromMillisecondsSinceEpoch(map['endAt']),
      range: map['range'] ?? '',
      description: map['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      kategoris: map['kategoris'] != null
          ? List<KategoriModel>.from(
              map['kategoris']?.map((x) => KategoriModel.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, amount: $amount, startAt: $startAt, endAt: $endAt, range: $range, description: $description, createdAt: $createdAt, kategoris: $kategoris)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetModel &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.startAt == startAt &&
        other.endAt == endAt &&
        other.range == range &&
        other.description == description &&
        other.createdAt == createdAt &&
        listEquals(other.kategoris, kategoris);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        startAt.hashCode ^
        endAt.hashCode ^
        range.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        kategoris.hashCode;
  }
}
