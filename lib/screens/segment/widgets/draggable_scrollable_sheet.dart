import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/measures/border_radius.dart';
import 'package:htr/config/measures/padding.dart';

class DraggableScrollableSheetForThresholding extends StatefulWidget {
  final Function getBottomSheetComponents;
  const DraggableScrollableSheetForThresholding(
      {super.key, required this.getBottomSheetComponents});

  @override
  State<DraggableScrollableSheetForThresholding> createState() =>
      _DraggableScrollableSheetForThresholdingState();
}

class _DraggableScrollableSheetForThresholdingState
    extends State<DraggableScrollableSheetForThresholding> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.15,
        maxChildSize: 0.7,
        builder: (context, controller) => ClipRRect(
              borderRadius: bRTL24TR24,
              child: Container(
                color: kSecondaryBgColor,
                padding: pX32,
                child: ListView.builder(
                    controller: controller,
                    itemCount: widget.getBottomSheetComponents(context).length,
                    itemBuilder: (context, index) =>
                        widget.getBottomSheetComponents(context)[index]),
              ),
            ));
  }
}
