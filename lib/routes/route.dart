import 'package:flutter/material.dart';
import 'package:htr/models/htr.dart';
import 'package:htr/screens/result/result.dart';
import 'package:htr/screens/segment/segment.dart';

import '../screens/home/home.dart';

class RouteProvider {
  static const String home = "";
  static const String result = "/result";
  static const String segment = "/segment";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case result:
        return MaterialPageRoute(
            builder: (_) => ResulPage(args: settings.arguments as HTRModel));
      case segment:
        return MaterialPageRoute(builder: (_) => const Edit());
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
