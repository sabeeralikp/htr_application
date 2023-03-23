import 'package:flutter/material.dart';
import 'package:htr/models/upload_htr.dart';
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
            builder: (_) =>
                ResulPage(args: settings.arguments as List<dynamic>));
      case segment:
        return MaterialPageRoute(
            builder: (_) =>
                Segment(args: settings.arguments as UploadHTRModel));
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
