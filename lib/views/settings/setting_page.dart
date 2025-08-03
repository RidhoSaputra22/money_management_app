import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_management_app/core/theme/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ThemeMode _themeMode = themeProvider.themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tema Aplikasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            ListTile(
              title: const Text('Terang'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: _themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode!);
                },
              ),
            ),
            ListTile(
              title: const Text('Gelap'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: _themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode!);
                },
              ),
            ),
            ListTile(
              title: const Text('Sistem'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: _themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
