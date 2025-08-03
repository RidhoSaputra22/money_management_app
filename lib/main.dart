import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_management_app/core/theme/app_theme.dart';
import 'package:money_management_app/core/theme/theme_provider.dart';
import 'package:money_management_app/views/home/home_page.dart';
import 'package:money_management_app/views/auth/login_page.dart';
import 'package:money_management_app/views/auth/register_page.dart';
import 'package:money_management_app/views/income/income_page.dart';
import 'package:money_management_app/views/expense/expense_page.dart';
import 'package:money_management_app/views/budget/budget_page.dart';
import 'package:money_management_app/views/report/report_page.dart';
import 'package:money_management_app/views/settings/setting_page.dart';

final routes = {
  '/': (context) => HomePage(),
  '/register': (context) => RegisterPage(),
  '/income': (context) => IncomePage(),
  '/expense': (context) => ExpensePage(),
  '/budget': (context) => BudgetPage(),
  '/report': (context) => ReportPage(),
  '/login': (context) => LoginPage(),
  '/settings': (context) => SettingPage(), // Assuming you have a SettingsPage
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      title: 'Zero Based Budgeting',
      initialRoute: '/',
      routes: routes,
    );
  }
}
