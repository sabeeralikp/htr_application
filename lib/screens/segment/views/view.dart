import 'package:flutter/material.dart';
import 'package:htr/config/fonts/fonts.dart';

class Segment extends StatefulWidget {
  const Segment({super.key});

  @override
  State<Segment> createState() => _SegmentState();
}

// creating a variable
// ignore: unused_element
double _thresholdValue = 0;
double _horizontalValue = 0;
double _verticalValue = 0;


class _SegmentState extends State<Segment> {
  get controller => null;
  List<Widget> getBottomSheetComponents(context) => [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Threshold', style: p16SB),
            Slider(
                value: _thresholdValue,
                onChanged: (value) {
                  setState(() {
                    _thresholdValue = value;
                  });
                })
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Horizontal Spacing', style: p16SB),
            Slider(
                value: _horizontalValue,
                onChanged: (value) {
                  setState(() {
                    _horizontalValue = value;
                  });
                })
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vertical Spacing', style: p16SB),
            Slider(
                value: _verticalValue,
                onChanged: (value) {
                  setState(() {
                    _verticalValue = value;
                  });
                })
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmentation'),
      ),
      body: Stack(fit: StackFit.expand, children: [
        Image.network(
            'https://www.freepik.com/free-photo/top-view-typesetting-parts_30588756.htm#query=malayalam%20letters%20images&position=0&from_view=search&track=ais',
            fit: BoxFit.cover),
        DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (context, controller) => ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  child: Container(
                    color: const Color.fromARGB(31, 92, 89, 255),
                    padding:
                        const EdgeInsets.only(left: 32, top: 32, right: 32),
                    child: ListView.builder(
                        controller: controller,
                        itemCount: getBottomSheetComponents(context).length,
                        itemBuilder: (context, index) {
                          return getBottomSheetComponents(context)[index];
                        }),
                  ),
                )),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }
}
