import 'package:flutter/material.dart';
import 'package:htr/config/themes/theme.dart';
import 'package:htr/providers/locale_provider.dart';
import 'package:htr/routes/route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: Consumer<LocaleProvider>(
            builder: (context, provider, snapshot) => MaterialApp(
                title: 'HTR',
                theme: htrLightThemeData(context),
                initialRoute: RouteProvider.home,
                onGenerateRoute: RouteProvider.generateRoute,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: provider.locale)));
  }
}
