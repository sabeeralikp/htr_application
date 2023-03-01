import 'package:flutter/material.dart';
import 'package:htr/config/themes/theme.dart';
import 'package:htr/routes/route.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTR',
      theme: htrLightThemeData(context),
      initialRoute: RouteProvider.home,
      onGenerateRoute: RouteProvider.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
