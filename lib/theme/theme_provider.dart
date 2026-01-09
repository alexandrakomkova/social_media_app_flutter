import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  static const String _themeKey = 'themeMode';
  ThemeMode _themeMode = ThemeMode.system;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    switch (_sharedPreferences.getString(_themeKey)) {
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

    await _sharedPreferences.setString(_themeKey, _themeMode.name);

    notifyListeners();
  }
}
