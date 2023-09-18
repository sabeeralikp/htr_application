import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
/// 
/// [UI update finished]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(September 4th, 2023 4:33 PM) 
///
/// A custom elevated button widget with customizable onPressed and child properties.
///
/// This widget wraps an [ElevatedButton] with a specific style and padding.
/// It is commonly used for creating elevated buttons with a consistent look and feel
/// throughout the app.
///
/// [onPressed]: A function callback that will be invoked when the button is pressed.
/// [child]: The widget to display as the button's content.
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const CustomElevatedButton(
      {required this.child, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))))),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: child,
        ));
  }
}
/// A custom white elevated button widget with customizable onPressed and child properties.
///
/// This widget wraps an [ElevatedButton] with a specific style, padding, and white background.
/// It is commonly used for creating elevated buttons with a white background and consistent
/// look and feel throughout the app.
///
/// [onPressed]: A function callback that will be invoked when the button is pressed.
/// [child]: The widget to display as the button's content.
class CustomWhiteElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const CustomWhiteElevatedButton(
      {required this.child, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
            backgroundColor: MaterialStateProperty.all<Color>(kWhiteColor),// Assumes kWhiteColor is defined.
            foregroundColor: MaterialStateProperty.all<Color>(kBlackColor),// Assumes kBlackColor is defined.
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: BorderSide(color: kTextGreyColor.withOpacity(0.2)), // Assumes kTextGreyColor is defined.
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12))))),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: child,
        ));
  }
}
