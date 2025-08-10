import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/services/firestore_service.dart';

class ExpenseService {
  static Future<List<ExpenseModel>> fetchExpenses() async {
    try {
      final userId = await AuthService().getCurrentUserId();
      final snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();

      var kategoris = snapshot.docs
          .map((doc) => ExpenseModel.fromMap(doc.data()))
          .toList();
      print('Fetched ${kategoris} expenses for userId: $userId');
      return kategoris;
    } catch (e) {
      print('Error fetching expenses: ${e.toString()}');
      throw Exception('Failed to load expenses: ${e.toString()}');
    }
  }

  static Future<void> addExpense(ExpenseModel expense) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('expenses')
          .add(expense.toMap());
      // Update the document with its generated ID
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception('Failed to add expense: ${e.toString()}');
    }
  }

  static Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id)
          .update(expense.toMap());
    } catch (e) {
      throw Exception('Failed to update expense: ${e.toString()}');
    }
  }

  static Future<void> deleteExpense(ExpenseModel expense) async {
    try {
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete expense: ${e.toString()}');
    }
  }
}
