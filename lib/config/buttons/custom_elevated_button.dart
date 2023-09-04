import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';

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
            backgroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
            foregroundColor: MaterialStateProperty.all<Color>(kBlackColor),
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: BorderSide(color: kTextGreyColor.withOpacity(0.2)),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12))))),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: child,
        ));
  }
}
