import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/views/budget/blocs/budget_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_bloc.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_bloc.dart';
import 'package:money_management_app/views/kategori/views/kategori_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_management_app/core/theme/app_theme.dart';
import 'package:money_management_app/core/theme/theme_provider.dart';
import 'package:money_management_app/views/home/home_page.dart';
import 'package:money_management_app/views/auth/login_page.dart';
import 'package:money_management_app/views/auth/register_page.dart';
import 'package:money_management_app/views/income/views/income_page.dart';
import 'package:money_management_app/views/expense/views/expense_page.dart';
import 'package:money_management_app/views/budget/views/budget_page.dart';
import 'package:money_management_app/views/report/report_page.dart';
import 'package:money_management_app/views/settings/setting_page.dart';
import 'package:intl/date_symbol_data_local.dart';

final routes = {
  '/': (context) => HomePage(),
  '/register': (context) => RegisterPage(),
  '/income': (context) =>
      BlocProvider(create: (_) => IncomeBloc(), child: IncomePage()),
  '/expense': (context) =>
      BlocProvider(create: (_) => ExpenseBloc(), child: ExpensePage()),
  '/budget': (context) =>
      BlocProvider(create: (_) => BudgetBloc(), child: BudgetPage()),
  '/report': (context) => ReportPage(),
  '/login': (context) => LoginPage(),
  '/settings': (context) => SettingPage(), // Assuming you have a SettingsPage
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
