import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/decorations/box.dart';
import 'package:htr/config/measures/padding.dart';

class ThresholdSideSheet extends StatefulWidget {
  final List<Widget> getBottomSheetComponents;
  const ThresholdSideSheet({required this.getBottomSheetComponents, super.key});

  @override
  State<ThresholdSideSheet> createState() => _ThresholdSideSheetState();
}

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
    if (_init) {
      _drawerLeft = (MediaQuery.of(context).size.width * 3 / 4);
      _init = false;
    }
    return Stack(
      children: <Widget>[
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
                        children: [...widget.getBottomSheetComponents],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
