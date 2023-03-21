import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:htr/api/api.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/models/cordinates.dart';
import 'package:htr/models/upload_htr.dart';

class Segment extends StatefulWidget {
  final UploadHTRModel? args;
  const Segment({required this.args, super.key});

  @override
  State<Segment> createState() => _SegmentState();
}

class _SegmentState extends State<Segment> {
  double _thresholdValue = 80;
  double _horizontalValue = 3;
  double _verticalValue = 40;
  List<bool> _isTapped = [];
  List<Cordinates> _cordinates = [];
  double _deviceWidth = 0;
  _getCordinates(uploadHTR) async {
    _cordinates = await postThresholdValues(
        _thresholdValue, _horizontalValue, _verticalValue, uploadHTR);
    _isTapped = [for (int k = 0; k < _cordinates.length; k++) false];
    setState(() {});
  }

  selectBoxes(event, i) {
    for (int j = 0; j < _cordinates.length; j++) {
      double kc = _deviceWidth / _cordinates[j].imgW!.toDouble();
      double xB = _cordinates[j].x! * kc;
      double xS = event.position.dx;
      double wB = _cordinates[j].w! * kc;
      double yB = _cordinates[j].y! * kc;
      double yS = event.position.dy;
      double hB = _cordinates[j].h! * kc;

      if (xB < xS &&
          xS < (xB + wB) &&
          yB < yS &&
          yS < (yB + hB) &&
          _cordinates[j].p == i) {
        setState(() {
          _isTapped[j] = _isTapped[j] ? false : true;
        });
      }
    }
  }

  List<Widget> getBottomSheetComponents(context) => [
        Column(children: [
          Container(
              width: 32,
              height: 4,
              margin: t16B64,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32), color: kWhiteColor))
        ]),
        Text('Adjust Threshold', style: p20SB, textAlign: TextAlign.center),
        h20,
        Text('Threshold Value $_thresholdValue', style: p16M),
        Slider(
            value: _thresholdValue,
            min: 0,
            max: 300,
            onChanged: (value) {
              setState(() {
                _thresholdValue = value;
              });
            }),
        Text('Horizontal Spacing $_horizontalValue', style: p16M),
        Slider(
            value: _horizontalValue,
            onChanged: (value) {
              setState(() {
                _horizontalValue = value;
              });
            }),
        Text('Vertical Spacing $_verticalValue', style: p16M),
        Slider(
            value: _verticalValue,
            onChanged: (value) {
              setState(() {
                _verticalValue = value;
              });
            }),
        h32,
        ElevatedButton(
            onPressed: () {
              log("ElevatedButton");
              _getCordinates(widget.args!.id);
            },
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Done', style: p16SB)))
      ];
  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        ListView(children: [
          for (int i = 0; i < widget.args!.numberOfPages!; i++)
            Column(children: [
              Stack(
                children: [
                  Image.network(
                    '$baseURL/media/pdf2img/${widget.args!.filename!.replaceAll('.pdf', '')}/$i.png',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  Listener(
                    onPointerDown: (PointerDownEvent event) {
                      selectBoxes(event, i);
                    },
                    child: _cordinates.isNotEmpty
                        ? SizedBox(
                            height: _cordinates[i].imgH!.toDouble(),
                            child: Stack(
                              children: [
                                for (int j = 0; j < _cordinates.length; j++)
                                  _cordinates[j].p == i
                                      ? Positioned(
                                          left: _cordinates[j].x!.toDouble() *
                                              _deviceWidth /
                                              _cordinates[j].imgW!.toDouble(),
                                          top: _cordinates[j].y!.toDouble() *
                                              _deviceWidth /
                                              _cordinates[j].imgW!.toDouble(),
                                          child: Container(
                                              height: _cordinates[j]
                                                      .h!
                                                      .toDouble() *
                                                  _deviceWidth /
                                                  _cordinates[j]
                                                      .imgW!
                                                      .toDouble(),
                                              width:
                                                  _cordinates[j].w!.toDouble() *
                                                      _deviceWidth /
                                                      _cordinates[j]
                                                          .imgW!
                                                          .toDouble(),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                color: _isTapped[j]
                                                    ? Colors.blue
                                                    : Colors.blue[100]!,
                                                width: 1,
                                              ))),
                                        )
                                      : Text(j.toString()),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  )
                ],
              ),
              h18
            ]),
          h18
        ]),
        DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.18,
            maxChildSize: 0.65,
            builder: (context, controller) => ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  child: Container(
                    color: kSecondaryBgColor,
                    padding: x32,
                    child: ListView.builder(
                        controller: controller,
                        itemCount: getBottomSheetComponents(context).length,
                        itemBuilder: (context, index) {
                          return getBottomSheetComponents(context)[index];
                        }),
                  ),
                )),
               
                
      ]),
    );
  }
}
