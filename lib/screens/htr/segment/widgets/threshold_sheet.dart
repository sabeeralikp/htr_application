import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/decorations/box.dart';
import 'package:htr/config/measures/padding.dart';

///
/// [ThresholdSideSheet]
///
/// [author]	Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	May 29th, 2023 1:32 PM
/// [see]		StatefulWidget
///
///A widget that displays a side sheet for thresholding.
///The [getBottomSheetComponents] parameter is a list of widgets that represent the components to be displayed in the side sheet.
///This widget is used to create a side sheet with customizable content.
///It takes a list of widgets as a parameter to specify the components to be displayed in the side sheet.
///Returns the stateful widget's state instance.
class ThresholdSideSheet extends StatefulWidget {
  final List<Widget> getBottomSheetComponents;
  const ThresholdSideSheet({required this.getBottomSheetComponents, super.key});

  @override
  State<ThresholdSideSheet> createState() => _ThresholdSideSheetState();
}

///The state class for the ThresholdSideSheet widget.
/// This class extends the State class and is responsible for managing the state of the widget.
/// The state includes properties like _drawerLeft, _drawerIcon, and _init.
/// It also includes a ScrollController for scrolling functionality.
/// The sideSheetWidthonPanUpdate function is called when the user pans on the side sheet.
/// It updates the _drawerLeft and _drawerIcon properties based on the pan details.
/// The _drawerLeft property determines the position of the side sheet.
/// The _drawerIcon property determines the icon displayed on the side sheet.
/// The build method is responsible for building the UI of the widget.
/// Returns the built widget.
class _ThresholdSideSheetState extends State<ThresholdSideSheet> {
  static const double _offset = 20;
  double _drawerLeft = 20;
  IconData _drawerIcon = Icons.arrow_back_ios;
  bool _init = true;
  final ScrollController controller = ScrollController();
  void sideSheetWidthonPanUpdate(details) {
    _drawerLeft += details.delta.dx;
    if (_drawerLeft <= MediaQuery.of(context).size.width * 3 / 4) {
      _drawerLeft = MediaQuery.of(context).size.width * 3 / 4;
    }
    if (_drawerLeft >= MediaQuery.of(context).size.width - _offset) {
      _drawerLeft = MediaQuery.of(context).size.width - _offset;
    }
    if (_drawerLeft <= MediaQuery.of(context).size.width * 3 / 4) {
      _drawerIcon = Icons.arrow_forward_ios;
    }
    if (_drawerLeft >= MediaQuery.of(context).size.width - 2 * _offset) {
      _drawerIcon = Icons.arrow_back_ios;
    }
    setState(() {});
  }

  /// Expands or collapses the threshold sheet based on its current state.
  /// If the _drawerLeft property is less than or equal to 3/4 of the device's width,
  /// it means the sheet is expanded, so the function collapses it by setting _drawerLeft
  /// to the width of the device minus twice the _offset, and _drawerIcon to Icons.arrow_back_ios.
  /// If the _drawerLeft property is greater than 3/4 of the device's width,
  /// it means the sheet is collapsed, so the function expands it by setting _drawerLeft
  /// to 3/4 of the device's width, and _drawerIcon to Icons.arrow_forward_ios.
  /// Finally, the function triggers a state update to reflect the changes.

  void thresholdSheetExpandCollapse() {
    if (_drawerLeft <= MediaQuery.of(context).size.width * 3 / 4) {
      _drawerLeft = MediaQuery.of(context).size.width - 2 * _offset;
      _drawerIcon = Icons.arrow_back_ios;
    } else {
      _drawerLeft = MediaQuery.of(context).size.width * 3 / 4;
      _drawerIcon = Icons.arrow_forward_ios;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /// Initialize the _drawerLeft property if it's the first build
    if (_init) {
      _drawerLeft = (MediaQuery.of(context).size.width * 3 / 4);
      _init = false;
    }

    /// Build the widget UI
    /// Builds a widget that represents a draggable and expandable/collapsible threshold sheet.
    /// The sheet is positioned using the Positioned widget within a Stack.
    /// The sheet's width is set to one-fourth of the device's width, and its position is determined
    /// by the _drawerLeft property.
    /// The sheet is wrapped in a GestureDetector to handle pan update events and call the
    /// sideSheetWidthonPanUpdate callback.
    /// The sheet's appearance is defined by the Container's decoration using the bDSBgTS24BS24 style.
    /// The sheet's content is arranged in a Row, with the arrow button on the left and the
    /// bottom sheet components on the right.
    /// The arrow button is wrapped in an InkWell to handle tap events and call the
    /// thresholdSheetExpandCollapse function.
    /// The bottom sheet components are wrapped in a Column and centered within the sheet.
    /// The entire sheet is wrapped in a Positioned widget to define its position within the Stack.

    return Stack(children: <Widget>[
      Positioned(
          width: MediaQuery.of(context).size.width / 4,
          top: 0,
          height: MediaQuery.of(context).size.height,
          left: _drawerLeft,
          child: GestureDetector(
              onPanUpdate: sideSheetWidthonPanUpdate,
              child: Container(
                  decoration: bDSBgTS24BS24,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: thresholdSheetExpandCollapse,
                          child: Padding(
                            padding: pL8,
                            child: Center(
                                child: Icon(_drawerIcon, color: kWhiteColor)),
                          ),
                        ),
                        Padding(
                            padding: pL32,
                            child: Column(
                                // mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [...widget.getBottomSheetComponents]))
                      ]))))
    ]);
  }
}
