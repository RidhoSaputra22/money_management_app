import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/kategori_model.dart';

class Utils {
  static String currency(double amount) => '\$${amount.toStringAsFixed(2)}';

  static String toIDR(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDateIndonesian(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  static String generateUlid() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch.remainder(1000000);
    return '${now.toRadixString(36)}${random.toRadixString(36).padLeft(6, '0')}';
  }

  static int getRandomDistinctColor() {
    final colors = [
      0xFFE57373, // Red
      0xFF64B5F6, // Blue
      0xFF81C784, // Green
    ];
    colors.shuffle();
    return colors.first;
  }

  static String getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return month >= 1 && month <= 12 ? monthNames[month - 1] : '';
  }

  static List<String> getListMonthNames() {
    return [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
  }

  static List<String> getListDaysName() {
    return ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  }
}
