import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/kategori_services.dart';

class BudgetService {
  static Future<List<BudgetModel>> fetchBudgetsWithKategoris() async {
    try {
      final userId = await AuthService().getCurrentUserId();
      final budgets = await FirebaseFirestore.instance
          .collection('budgets')
          .where('userId', isEqualTo: userId)
          .get();

      var budgetsWithKategoris = await Future.wait(
        budgets.docs.map((doc) async {
          List<KategoriModel> kategoris =
              await KategoriService.fetchKategorisByBudget(doc.id);
          return BudgetModel.fromMap({
            ...doc.data(),
            'id': doc.id,
            'kategoris': kategoris.map((kategori) => kategori.toMap()).toList(),
          });
        }).toList(),
      );
      return budgetsWithKategoris;
    } catch (e) {
      throw Exception('Failed to load budgets: ${e.toString()}');
    }
  }

  static Future<List<BudgetModel>> fetchAll() async {
    try {
      final userId = await AuthService().getCurrentUserId();
      final budgets = await FirebaseFirestore.instance
          .collection('budgets')
          .where('userId', isEqualTo: userId)
          .get();

      return budgets.docs.map((doc) {
        return BudgetModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to load budgets: ${e.toString()}');
    }
  }

  // Budget state management
  static Future<void> addBudget(BudgetModel budget) async {
    try {
      await FirebaseFirestore.instance
          .collection('budgets')
          .add(budget.toMap());
      // Update the document with its generated ID
    } catch (e) {
      throw Exception('Failed to add budget: ${e.toString()}');
    }
  }

  static Future<void> updateBudget(BudgetModel budget) async {
    try {
      // Logic to update a budget
      final dbref = FirebaseFirestore.instance
          .collection('budgets')
          .doc(budget.id);

      await dbref.update(budget.toMap());
    } catch (e) {
      throw Exception('Failed to update budget: ${e.toString()}');
    }
  }

  static Future<void> deleteBudget(BudgetModel budget) async {
    try {
      for (KategoriModel kategori in budget.kategoris ?? []) {
        await FirebaseFirestore.instance
            .collection('kategoris')
            .doc(kategori.id)
            .delete();
      }

      final List<ExpenseModel> expenses = await ExpenseService.fetchByBudget(
        budget.id,
      );
      await Future.wait(
        expenses.map((expense) async {
          await ExpenseService.deleteExpense(expense);
        }),
      );

      await FirebaseFirestore.instance
          .collection('budgets')
          .doc(budget.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete budget: ${e.toString()}');
    }
  }
}
