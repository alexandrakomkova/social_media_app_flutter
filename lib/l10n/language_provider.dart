import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

class LanguageProvider with ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  Locale _locale;

  LanguageProvider({
    required SharedPreferences sharedPreferences,
    required Locale locale,
  }) : _sharedPreferences = sharedPreferences,
       _locale = locale {
    _loadLocale();
  }

  Locale get locale => _locale;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  void setLocale(Locale locale) async {
    if (locale == _locale) return;

    _locale = locale;
    notifyListeners();

    await _sharedPreferences.setString('languageCode', locale.languageCode);
  }

  Future<void> _loadLocale() async {
    String languageCode = _sharedPreferences.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
