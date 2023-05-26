import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/widgets/fab.dart';

ThemeData htrDarkThemeData(BuildContext context) => ThemeData.dark().copyWith(
      useMaterial3: true,
    );

ThemeData htrLightThemeData(BuildContext context) => ThemeData(
      useMaterial3: true,
      floatingActionButtonTheme: fabTheme,
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        activeTrackColor: kPrimaryColor,
        inactiveTrackColor: kWhiteColor,
        thumbColor: kPrimaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
              foregroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
              textStyle: MaterialStateProperty.all<TextStyle>(fW16M))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(fP16N))),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
