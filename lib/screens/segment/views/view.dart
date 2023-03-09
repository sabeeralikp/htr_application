import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';

class Segment extends StatefulWidget {
  const Segment({super.key});

  @override
  State<Segment> createState() => _SegmentState();
}

// creating a variable
// ignore: unused_element
double _thresholdValue = 10;
double _horizontalValue = 30;
double _verticalValue = 50;

class _SegmentState extends State<Segment> {
  get controller => null;
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
        Text('Threshold Value', style: p16M),
        Slider(
            value: _thresholdValue,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _thresholdValue = value;
              });
            }),
        Text('Horizontal Spacing', style: p16M),
        Slider(
            value: _horizontalValue,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _horizontalValue = value;
              });
            }),
        Text('Vertical Spacing', style: p16M),
        Slider(
            value: _verticalValue,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _verticalValue = value;
              });
            }),
        h16,
        ElevatedButton(
            onPressed: () {
              log("ElevatedButton");
            },
            child: const Padding(
                padding: EdgeInsets.all(16.0), child: Text('Threshold'))),
        TextButton(onPressed: () {}, child: const Text('Next'))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmentation'),
      ),
      body: Stack(fit: StackFit.expand, children: [
        ListView(padding: x16T32B64, children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Image.network(
                'https://image.isu.pub/171101225917-98e8fff30de9ee1d950dd520987b7977/jpg/page_1.jpg'),
          ),
          h18,
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Image.network(
                'https://image.isu.pub/171101225917-98e8fff30de9ee1d950dd520987b7977/jpg/page_1.jpg'),
          ),
          h36
        ]),
        DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.15,
            maxChildSize: 0.7,
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
