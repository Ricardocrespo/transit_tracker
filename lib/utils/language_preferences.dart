
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguagePreferences {
  static const _key = 'selected_language';

  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  static Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null) return null;
    return Locale(code);
  }
}
