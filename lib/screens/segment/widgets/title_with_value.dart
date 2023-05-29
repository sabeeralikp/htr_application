import 'package:flutter/material.dart';
import 'package:htr/config/decorations/box.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';

class TitleWithValue extends StatelessWidget {
  const TitleWithValue({super.key, required double value, required this.title})
      : _horizontalValue = value;

  final double _horizontalValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: fP16M),
        w8,
        Container(
            decoration: bDW8,
            padding: pA8,
            child: Text(_horizontalValue.toStringAsFixed(1), style: fP16M))
      ],
    );
  }
}
