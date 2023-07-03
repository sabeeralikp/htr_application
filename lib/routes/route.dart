import 'package:flutter/material.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:htr/screens/result/result.dart';
import 'package:htr/screens/segment/segment.dart';

import '../screens/home/home.dart';

///
/// [RouteProvider.]
///
/// [@author	Unknown]
/// [ @since	v0.0.1 ]
/// [@version	v1.0.0	March 1st, 2023]
/// [@global]
/// [@descripttion Provides route to the application including navigation]
///
class RouteProvider {
  // Route Paths
  static const String home = "";
  static const String result = "/result";
  static const String segment = "/segment";

  /// Generates the appropriate route based on the given RouteSettings.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        // If the route name is 'home', returns a MaterialPageRoute that builds a Home widget.
        return MaterialPageRoute(builder: (_) => const Home());
      case result:
        // If the route name is 'result', returns a MaterialPageRoute that builds a ResulPage widget, passing the arguments.
        return MaterialPageRoute(
            builder: (_) =>
                ResulPage(args: settings.arguments as List<dynamic>));
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
