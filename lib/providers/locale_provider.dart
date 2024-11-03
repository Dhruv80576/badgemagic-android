// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en', 'US');

  Locale get locale => _locale;

  void changeLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
