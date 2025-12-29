
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale;

  LanguageProvider(this._locale) {
    _loadLocale();
  }

  Locale get locale => _locale;
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  void setLocale(Locale locale) async {
    if (locale == _locale) return;

    _locale = locale;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }
}