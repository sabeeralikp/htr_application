import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/widgets/fab.dart';

///
/// [ThemeData]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	March 1st, 2023 1:14 PM
/// [see]		RoundedRectSliderTrackShape
///

/// Returns a [ThemeData] object for the "HTR Dark" theme.
/// The returned [ThemeData] is a copy of the default dark theme
/// with the `useMaterial3` flag set to true.
///
/// [context] is the build context (optional).
///
/// Returns a [ThemeData] object with the "HTR Dark" theme settings,
/// including the `useMaterial3` flag set to true.
ThemeData htrDarkThemeData(BuildContext context) => ThemeData.dark().copyWith(
      useMaterial3: true,
    );

/// Configures the theme settings for elevated buttons and text buttons.
///
/// [elevatedButtonTheme] defines the style for elevated buttons.
///   - [backgroundColor] sets the background color of the button to [kPrimaryColor]
///     for all button states.
///   - [foregroundColor] sets the text color of the button to [kWhiteColor]
///     for all button states.
///   - [textStyle] sets the text style of the button to [fW16M] (Font Weight 16, Medium)
///     for all button states.
///
/// [textButtonTheme] defines the style for text buttons.
///   - [textStyle] sets the text style of the button to [fP14N] (Font Weight 16, Normal)
///     for all button states.
///
/// [visualDensity] sets the visual density of the theme to
/// [VisualDensity.adaptivePlatformDensity], which adapts the density based on the platform.
///
/// Returns a [ThemeData] object with the configured button and visual density settings.
ThemeData htrLightThemeData(BuildContext context) => ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      titleTextStyle: fP16M,
      backgroundColor: const Color(0xfff8f8f8),
      toolbarHeight: 70,
      shape: Border(
          bottom: BorderSide(color: kGreyColor.withOpacity(0.1), width: 1)),
    ),
    floatingActionButtonTheme: fabTheme,
    sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        activeTrackColor: kPrimaryColor,
        inactiveTrackColor: kWhiteColor,
        thumbColor: kPrimaryColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
            foregroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
            textStyle: MaterialStateProperty.all<TextStyle>(fW16M))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(fP14N))),
    visualDensity: VisualDensity.adaptivePlatformDensity);

/// A custom track shape for a slider that extends the [RoundedRectSliderTrackShape].
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    /// Retrieves the preferred dimensions of the track.
    ///
    /// [parentBox] is the render box of the slider.
    /// [offset] is the offset of the track.
    /// [sliderTheme] provides the theme data for the slider.
    /// [isEnabled] indicates whether the slider is enabled or disabled.
    /// [isDiscrete] indicates whether the slider is discrete or continuous.
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;

    /// Calculates the rectangular shape of the track.
    ///
    /// The track is positioned at [trackLeft] and [trackTop].
    /// It has a width of [trackWidth] and a height of [trackHeight].
    /// The track height is determined based on the difference between the parent box height
    /// and the track height divided by 2.
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
