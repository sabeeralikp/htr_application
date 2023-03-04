import 'dart:developer';

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
          children: const [
            SizedBox(
              width: 25,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                clipBehavior: Clip.hardEdge,
                child: Divider(
                  height: 30,
                  thickness: 5,
                ),
              ),
            )
          ],
        ),
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
        ElevatedButton(
          onPressed: () {
            log("ElevatedButton");
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Done', style: p16SB),
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmentation'),
      ),
      body: Stack(fit: StackFit.expand, children: [
        // Column(
        //   children: [
        //     Image.network(
        //         'https://th.bing.com/th/id/R.1c3eaf067186c49cbddfb7c678e71e6d?rik=gITa%2bZAwPUCmhg&riu=http%3a%2f%2flondonmedarb.com%2fwp-content%2fuploads%2f2015%2f08%2fSample-Legal-Document-008.png&ehk=2VDs3zm5uif9K5ZnroFy1xPSlUV0p9dVzUDkL03%2bvo4%3d&risl=&pid=ImgRaw&r=0')
        //   ],
        // ),
        DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.6,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
