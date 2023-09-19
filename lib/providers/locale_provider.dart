import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///
/// [localisation for malayalam added]
///
/// [author]	Swathy
/// [since]	v0.0.1
/// [version]	v1.0.0	June 22nd, 2023 12:25 PM
///

/// A class that provides the current locale and allows changing it.
/// It extends [ChangeNotifier] to notify listeners when the locale is changed.
class LocaleProvider with ChangeNotifier {
  Locale _locale = AppLocalizations.supportedLocales[0];

  /// Returns the current locale
  Locale? get locale => _locale;

  /// Changes the current locale to the next available locale.
  /// If the current locale is the first supported locale,
  /// it changes it to the second supported locale,
  /// otherwise it changes it back to the first supported locale.
  /// Finally, it notifies all the listeners that the locale has changed.

  void changeLocale() {
    _locale = _locale == AppLocalizations.supportedLocales[0]
        ? AppLocalizations.supportedLocales[1]
        : AppLocalizations.supportedLocales[0];
    notifyListeners();
  }
}
