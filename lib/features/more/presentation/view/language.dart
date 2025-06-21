import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_mindmed_project/main.dart';
import 'package:provider/provider.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  // Initialize with default values
  late String _selectedLanguage;
  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'US', 'locale': 'en'},
    {'name': 'Arabic', 'code': 'SA', 'locale': 'ar'},
  ];

  @override
  void initState() {
    super.initState();
    // Set initial selection based on current locale
    _selectedLanguage = _getInitialLanguage();
  }

  String _getInitialLanguage() {
    final currentLocale =
        Provider.of<LocaleProvider>(context, listen: false).locale;
    if (currentLocale.languageCode == 'ar') {
      return 'Arabic';
    } else {
      return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secoundryColor,
        foregroundColor: primaryColor,
        title: Text(
          localizations.selectLanguage,
          style: const TextStyle(color: primaryColor),
        ),
      ),
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final language = _languages[index];
          return RadioListTile<String>(
            title: Row(
              children: [
                CountryFlag.fromCountryCode(
                  language['code']!,
                  width: 30,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  language['name']!,
                  style: const TextStyle(
                      color: mainBlueColor,
                      fontSize: 21,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            value: language['name']!,
            groupValue: _selectedLanguage,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _selectedLanguage = value;
                  final selectedLocale = _languages.firstWhere(
                    (lang) => lang['name'] == value,
                  )['locale'];
                  localeProvider.setLocale(Locale(selectedLocale!));
                });
              }
            },
          );
        },
      ),
    );
  }
}
