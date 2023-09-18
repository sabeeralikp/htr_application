import 'package:flutter/material.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:htr/screens/home/home.dart';
import 'package:htr/screens/htr/result/result.dart';
import 'package:htr/screens/htr/segment/segment.dart';
import 'package:htr/screens/ocr/home/views/view.dart';
import 'package:htr/screens/ocr/result/views/view.dart';

import '../screens/htr/home/home.dart';

///
/// [RouteProvider.]
///
/// [@author]	Sabeerali
/// [@since]	v0.0.1 
/// [@version]	v1.0.0	March 1st, 2023
/// [@global]
/// [@descripttion Provides route to the application including navigation]
///
class RouteProvider {
  // Route Paths
  static const String htrHome = "/htr_home";
  static const String ocrHome = "/ocr_home";
  static const String home = "";
  static const String result = "/result";
  static const String ocrresult = "/ocr_result";
  static const String segment = "/segment";

  /// Generates the appropriate route based on the given RouteSettings.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        // If the route name is 'menu', returns a MaterialPageRoute that builds a Menu widget.
        return MaterialPageRoute(builder: (_) => const Home());
      case htrHome:
        // If the route name is 'home', returns a MaterialPageRoute that builds a Home widget.
        return MaterialPageRoute(builder: (_) => const HTRHome());
      case ocrHome:
        return MaterialPageRoute(builder: (_) => const OCRHome());
      case result:
        // If the route name is 'result', returns a MaterialPageRoute that builds a ResulPage widget, passing the arguments.
        return MaterialPageRoute(
            builder: (_) =>
                ResulPage(args: settings.arguments as List<dynamic>));
      case ocrresult:
        return MaterialPageRoute(
            builder: (_) =>
                OCRResult(ocrResult: settings.arguments as OCRResultModel));
      case segment:
        // If the route name is 'segment', returns a MaterialPageRoute that builds a Segment widget, passing the arguments.
        return MaterialPageRoute(
            builder: (_) =>
                Segment(args: settings.arguments as UploadHTRModel));
      default:
        // For any other route name, returns a MaterialPageRoute that builds a Home widget as the default.
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
