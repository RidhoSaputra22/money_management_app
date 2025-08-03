class BudgetModel {
  final String userId;
  final String month;
  final double totalIncome;
  final double totalPlannedExpense;
  final DateTime createdAt;

  BudgetModel({
    required this.userId,
    required this.month,
    required this.totalIncome,
    required this.totalPlannedExpense,
    required this.createdAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      userId: json['userId'] as String,
      month: json['month'] as String,
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalPlannedExpense: (json['totalPlannedExpense'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'month': month,
      'totalIncome': totalIncome,
      'totalPlannedExpense': totalPlannedExpense,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
