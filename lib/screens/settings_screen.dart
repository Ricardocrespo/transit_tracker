import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';
import 'package:transit_tracker/utils/lang/language_options.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Locale) onLanguageChange;

  const SettingsScreen({super.key, required this.onLanguageChange});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Locale selectedLocale;
  late List<LanguageOption> languages;

  @override
  void initState() {
    super.initState();
    selectedLocale = AppLocalizations.currentLocale;
    languages = getSupportedLanguageOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('navigation.settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            DropdownButtonFormField2<LanguageOption>(
              value: languages.firstWhere((l) => l.code == selectedLocale.languageCode),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate('settings.language'),
              ),
              items: languages.map((lang) {
                final label = AppLocalizations.of(context).translate('language.${lang.code}');
                return DropdownMenuItem<LanguageOption>(
                  value: lang,
                  child: Row(
                    children: [
                      Image.asset(lang.flagPath, width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (selected) {
                if (selected != null) {
                  setState(() => selectedLocale = selected.locale);
                  widget.onLanguageChange(selected.locale);
                }
              },
              dropdownStyleData: DropdownStyleData(
                direction: DropdownDirection.textDirection, 
                maxHeight: 200,
              )
            ),
          ],
        ),
      ),
    );
  }
}
