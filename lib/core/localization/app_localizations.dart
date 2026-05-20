import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  final Map<String, String> _localizedStrings;

  AppLocalizations(this.locale, this._localizedStrings);

  /// Helper to get instance from BuildContext
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Delegate for MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Lookup method with fallback
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Operator overload for easy access
  String operator [](String key) => translate(key);

  /// Load JSON from assets
  static Future<Map<String, String>> _load(Locale locale) async {
    final path = 'assets/locales/${locale.languageCode}.json';
    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ur'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final strings = await AppLocalizations._load(locale);
    return AppLocalizations(locale, strings);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}