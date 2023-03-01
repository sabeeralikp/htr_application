import 'package:flutter/material.dart';
import 'package:htr/config/widgets/fab.dart';

ThemeData htrDarkThemeData(BuildContext context) => ThemeData.dark().copyWith(
      useMaterial3: true,
    );

ThemeData htrLightThemeData(BuildContext context) => ThemeData(
      useMaterial3: true,
      floatingActionButtonTheme: fabTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
