import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';

// Button Styles

ButtonStyle wPButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(kWhiteColor),
    foregroundColor: MaterialStateProperty.all(kPrimaryColor));

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
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8)),
            backgroundColor: MaterialStateProperty.all<Color>(
                kWhiteColor), // Assumes kWhiteColor is defined.
            foregroundColor: MaterialStateProperty.all<Color>(
                kBlackColor), // Assumes kBlackColor is defined.
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: BorderSide(
                        color: kTextGreyColor.withOpacity(
                            0.2)), // Assumes kTextGreyColor is defined.
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12))))),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: child,
        ));
  }
}
