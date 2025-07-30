import 'package:flutter/material.dart';

class LanguageOption {
  final Locale locale;
  final String code;
  final String flagPath;

  const LanguageOption({
    required this.locale,
    required this.code,
    required this.flagPath,
  });
}

List<LanguageOption> getSupportedLanguageOptions() {
  return const [
    LanguageOption(
      locale: Locale('en', 'EN'),
      code: 'en',
      flagPath: 'assets/lang/en.png',
    ),
    LanguageOption(
      locale: Locale('es', 'ES'),
      code: 'es',
      flagPath: 'assets/lang/es.png',
    ),
  ];
}
