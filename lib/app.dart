import 'package:flutter/material.dart';
import 'package:dhriti/config/themes/theme.dart';
import 'package:dhriti/providers/locale_provider.dart';
import 'package:dhriti/routes/route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

///
/// [MyApp]
///
/// [author]	Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	March 1st, 2023 1:14 PM
/// [see]		StatelessWidget]
/// [args] key
///
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // A Flutter app's root widget.

  checkUpdate() {
    InAppUpdate.checkForUpdate().then((updateInfo) async {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // checkUpdate();
    // Builds the UI representation of the widget.
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
        // Provides a LocaleProvider instance to descendants.
        child: Consumer<LocaleProvider>(
            // Listens to changes in the LocaleProvider.
            builder: (context, provider, snapshot) => MaterialApp(
                title: 'Dhriti OCR', // The title of the application.
                theme: htrLightThemeData(context), // The app's theme data.
                initialRoute: RouteProvider.home, // The initial route.
                onGenerateRoute: RouteProvider
                    .generateRoute, // Generates routes dynamically.
                debugShowCheckedModeBanner:
                    false, // Hides debug banner in release mode.
                localizationsDelegates: AppLocalizations
                    .localizationsDelegates, // Delegates for app localization.
                supportedLocales: AppLocalizations
                    .supportedLocales, // List of supported locales for the app.
                locale:
                    provider.locale // Uses the locale from the LocaleProvider.
                )));
  }
}
