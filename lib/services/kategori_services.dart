import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';

class KategoriService {
  static Future<List<KategoriModel>> fetchKategorisByBudget(
    String budgetId,
  ) async {
    try {
      final userId = await AuthService().getCurrentUserId();
      final snapshot = await FirebaseFirestore.instance
          .collection('kategoris')
          .where('userId', isEqualTo: userId)
          .where('budgetId', isEqualTo: budgetId)
          .get();

      return snapshot.docs
          .map((doc) => KategoriModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load kategoris: ${e.toString()}');
    }
  }

  static Future<List<KategoriModel>> fetchAll() async {
    try {
      final userId = await AuthService().getCurrentUserId();
      final snapshot = await FirebaseFirestore.instance
          .collection('kategoris')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => KategoriModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load all kategoris: ${e.toString()}');
    }
  }

  static Future<void> addKategori(KategoriModel kategori) async {
    try {
      await FirebaseFirestore.instance
          .collection('kategoris')
          .add(kategori.toMap());
      // Update the document with its generated ID
    } catch (e) {
      throw Exception('Failed to add kategori: ${e.toString()}');
    }
  }

  static Future<void> updateKategori(KategoriModel kategori) async {
    try {
      await FirebaseFirestore.instance
          .collection('kategoris')
          .doc(kategori.id)
          .update(kategori.toMap());
    } catch (e) {
      throw Exception('Failed to update kategori: ${e.toString()}');
    }
  }

  static Future<void> deleteKategori(KategoriModel kategori) async {
    try {
      await FirebaseFirestore.instance
          .collection('kategoris')
          .doc(kategori.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete kategori: ${e.toString()}');
    }
  }
}
