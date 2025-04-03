import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String _selectedLanguage = 'English'; // Default language

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'US'},
    {'name': 'Arabic', 'code': 'SA'},
    {'name': 'French', 'code': 'FR'},
    {'name': 'Spanish', 'code': 'ES'},
    {'name': 'German', 'code': 'DE'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secoundryColor,
        foregroundColor: primaryColor,
        title: const Text(
          'Select Language',
          style: TextStyle(color: primaryColor),
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
                });
              }
            },
          );
        },
      ),
    );
  }
}
