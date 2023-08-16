import 'package:flutter/material.dart';
import 'package:htr/config/themes/theme.dart';
import 'package:htr/providers/locale_provider.dart';
import 'package:htr/routes/route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    // Builds the UI representation of the widget.
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
        // Provides a LocaleProvider instance to descendants.
        child: Consumer<LocaleProvider>(
            // Listens to changes in the LocaleProvider.
            builder: (context, provider, snapshot) => MaterialApp(
                title: 'HTR', // The title of the application.
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
