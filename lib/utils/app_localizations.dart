import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static final AppLocalizations _instance = AppLocalizations._internal();
  factory AppLocalizations() => _instance;
  AppLocalizations._internal();

  final Map<String, String> _localizedStrings = {};

  static Locale currentLocale = const Locale('en');

  Future<void> load(Locale locale) async {
    currentLocale = locale;
    final String langCode = locale.languageCode;
    final String jsonString =
        await rootBundle.loadString('assets/lang/$langCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings.clear();
    jsonMap.forEach((key, value) {
      _localizedStrings[key] = value.toString();
    });
  }

  String translate(String key) {
    return _localizedStrings[key] ?? '** $key not found';
  }

  // Static accessor for convenience
  static AppLocalizations of(BuildContext context) => _instance;

  static const supportedLocales = [Locale('en'), Locale('es')];
}
