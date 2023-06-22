import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = AppLocalizations.supportedLocales[0];
  Locale? get locale => _locale;

  void changeLocale() {
    _locale = _locale == AppLocalizations.supportedLocales[0]
        ? AppLocalizations.supportedLocales[1]
        : AppLocalizations.supportedLocales[0];
    notifyListeners();
  }
}
