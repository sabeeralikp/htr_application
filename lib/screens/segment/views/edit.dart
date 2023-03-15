import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.network(
                'https://image.isu.pub/171101225917-98e8fff30de9ee1d950dd520987b7977/jpg/page_1.jpg'),
          ),
          const BoundingBox(left: 50, top: 200, height: 20, width: 50),
          const BoundingBox(left: 100, top: 200, height: 20, width: 50),
          const BoundingBox(left: 150, top: 200, height: 20, width: 50),
          const BoundingBox(left: 200, top: 200, height: 20, width: 50),
          const BoundingBox(left: 250, top: 200, height: 20, width: 50),
        ]),
      ),
    );
  }
}

class BoundingBox extends StatefulWidget {
  final double left, top, height, width;
  const BoundingBox({
    required this.left,
    required this.top,
    required this.height,
    required this.width,
    super.key,
  });

  @override
  State<BoundingBox> createState() => _BoundingBoxState();
}

class _BoundingBoxState extends State<BoundingBox> {
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      height: widget.height,
      width: widget.width,
      child: Listener(
        onPointerDown: (event) {
          _isTapped = _isTapped ? false : true;
          setState(() {});
        },
        onPointerMove: (event) {
          _isTapped = _isTapped ? false : true;
          setState(() {});
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              border: Border.all(
            color: _isTapped ? Colors.blue : Colors.blue[100]!,
            width: 2,
          )),
        ),
      ),
    );
  }
}
