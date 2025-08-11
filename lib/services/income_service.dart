import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/services/auth_service.dart';

class IncomeService {
  static Future<List<IncomeModel>> fetchAll() async {
    try {
      final userId = await AuthService().getCurrentUserId();
      final snapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => IncomeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load incomes: ${e.toString()}');
    }
  }

  static Future<void> addIncome(IncomeModel income) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('incomes')
          .add(income.toMap());
      // Update the document with its generated ID
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception('Failed to add income: ${e.toString()}');
    }
  }

  static Future<void> updateIncome(IncomeModel income) async {
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(income.id)
          .update(income.toMap());
    } catch (e) {
      throw Exception('Failed to update income: ${e.toString()}');
    }
  }

  static Future<void> deleteIncome(IncomeModel income) async {
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(income.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete income: ${e.toString()}');
    }
  }

  static Future<List<IncomeModel>> fetchByYear(int year) async {
    try {
      final start = DateTime(year, 1, 1);
      final end = DateTime(year + 1, 1, 1);
      final snapshot = await IncomeService.fetchAll();

      return snapshot.where((income) {
        final createAt = income.createAt;
        return createAt.isAfter(start) && createAt.isBefore(end);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch incomes by year: ${e.toString()}');
    }
  }
}
