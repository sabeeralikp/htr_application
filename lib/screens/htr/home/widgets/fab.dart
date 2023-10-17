import 'package:flutter/material.dart';
import 'package:dhriti/config/fonts/fonts.dart';

///
/// [FloatingActionButton]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	 April 27th, 2023 8:01 PM
/// [see]		RoundedRectSliderTrackShape
///
/// Constructs a custom [FloatingActionButton] with an extended layout.
/// The button displays a [Text] label, an [icon], and invokes the [onPressedFn] callback
/// when pressed.
///
/// [onPressedFn] is the callback function to be executed when the button is pressed.
/// [title] is the text to be displayed as the label for the button.
/// [icon] is the icon to be displayed on the button.
///
/// Returns a [FloatingActionButton] widget with an extended layout,
/// including a label, icon, and callback for the onPressed event.
FloatingActionButton floatingActionButton(onPressedFn, title, icon) {
  return FloatingActionButton.extended(
      label: Text(title, style: fW16M), icon: icon, onPressed: onPressedFn);
}
