import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/measures/border_radius.dart';
import 'package:htr/config/measures/padding.dart';

///
/// [DraggableScrollableSheetForThresholding]
///
/// [author] Swathy
/// [since]	v0.0.1
/// [version]	v1.0.0	May 29th, 2023 1:32 PM
/// [see]		StatefulWidget
///
///A widget that displays a draggable scrollable sheet for thresholding.
///The [getBottomSheetComponents] parameter is a function that returns the components to be displayed in the bottom sheet.
///This widget is used to create a draggable scrollable sheet with customizable content.
///It takes a function as a parameter to obtain the components to be displayed in the bottom sheet.
///Returns the stateful widget's state instance.
class DraggableScrollableSheetForThresholding extends StatefulWidget {
  final Function getBottomSheetComponents;
  const DraggableScrollableSheetForThresholding(
      {super.key, required this.getBottomSheetComponents});

  @override
  State<DraggableScrollableSheetForThresholding> createState() =>
      _DraggableScrollableSheetForThresholdingState();
}

///The state class for the DraggableScrollableSheetForThresholding widget.
/// This class extends the State class and is responsible for building the UI of the widget.
/// The UI consists of a DraggableScrollableSheet widget, which provides a draggable scrollable sheet.
///The content of the sheet is determined by the [getBottomSheetComponents] function passed to the parent widget.
/// The components are displayed in a ListView.builder within a Container.
///Returns the built widget.
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
                        widget.getBottomSheetComponents(context)[index]))));
  }
}
