import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'themeMode';
  ThemeMode _themeMode = ThemeMode.system;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (prefs.getString(_themeKey)) {
      case 'dark':
        _themeMode = ThemeMode.dark;
      case 'light':
        _themeMode = ThemeMode.light;
      default:
        _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark == true ? ThemeMode.dark : ThemeMode.light;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeMode.name);

    notifyListeners();
  }
}
