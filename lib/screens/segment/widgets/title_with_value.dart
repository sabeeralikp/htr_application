import 'package:flutter/material.dart';
import 'package:htr/config/decorations/box.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';

///
/// [TitleWithValue]
///
/// [author] Sabeerali
/// [since]	v0.0.1 
/// [version]	v1.0.0	May 29th, 2023 1:32 PM 
/// [see]		StatelessWidget
///
///A widget that displays a title and a corresponding numeric value horizontally.
/// The widget requires a value of type double and a title of type String.
/// The _horizontalValue property holds the numeric value to be displayed.
/// The build method constructs a Row widget that contains the title and value components.
/// The title is displayed as text using the fP16M style.
/// The value is displayed within a Container, which has a decoration defined by the bDW8 style,
/// and is padded with pA8. The value is displayed as text using the fP16M style, with a fixed number of decimal places.
class TitleWithValue extends StatelessWidget {
  const TitleWithValue({super.key, required double value, required this.title})
      : _horizontalValue = value;

  final double _horizontalValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: fP16M),
      w8,
      Container(
          decoration: bDW8,
          padding: pA8,
          child: Text(_horizontalValue.toStringAsFixed(1), style: fP16M))
    ]);
  }
}
