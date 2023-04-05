import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:htr/api/api.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/widgets/loading.dart';
import 'package:htr/models/cordinates.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:htr/routes/route.dart';

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
  List<Cordinates> _selectedCordinates = [];
  bool isLoading = false;
  double _deviceWidth = 0;
  _getCordinates(uploadHTR) async {
    _cordinates = await postThresholdValues(
        _thresholdValue, _horizontalValue, _verticalValue, uploadHTR);
    _isTapped = [for (int k = 0; k < _cordinates.length; k++) false];
    setState(() {});
  }

  _getExtractedText(uploadHTR) async {
    List<dynamic> extractedText =
        await postExtractText(_selectedCordinates, uploadHTR);
    return extractedText;
  }

  void navigateToResult(extractedText) {
    if (_selectedCordinates.isNotEmpty) {
      Navigator.of(context)
          .pushNamed(RouteProvider.result, arguments: extractedText);
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
              _selectedCordinates = [];
              setState(() {
                _thresholdValue = value;
              });
            }),
        Text('Horizontal Spacing $_horizontalValue', style: p16M),
        Slider(
            value: _horizontalValue,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _horizontalValue = value;
              });
            }),
        Text('Vertical Spacing $_verticalValue', style: p16M),
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
              _getCordinates(widget.args!.id);
            },
            child: const Padding(
                padding: EdgeInsets.all(16.0), child: Text('Threshold'))),
        TextButton(
            onPressed: () async {
              log("Next Button");
              if (_selectedCordinates.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });
                List<dynamic> extractedText =
                    await _getExtractedText(widget.args!.id) as List<dynamic>;
                log(extractedText.toString());
                navigateToResult(extractedText);
              }
            },
            child: const Text('Next'))
      ];
  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segment'),
      ),
      body: isLoading
          ? const Center(child: LoadingIndicator())
          : Stack(fit: StackFit.expand, children: [
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        _cordinates.isNotEmpty
                            ? SizedBox(
                                height: _cordinates[i].imgH!.toDouble(),
                                child: Stack(
                                  children: [
                                    for (int j = 0; j < _cordinates.length; j++)
                                      _cordinates[j].p == i
                                          ? Positioned(
                                              left:
                                                  _cordinates[j].x!.toDouble() *
                                                      _deviceWidth /
                                                      _cordinates[j]
                                                          .imgW!
                                                          .toDouble(),
                                              top:
                                                  _cordinates[j].y!.toDouble() *
                                                      _deviceWidth /
                                                      _cordinates[j]
                                                          .imgW!
                                                          .toDouble(),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _isTapped[j] = _isTapped[j]
                                                        ? false
                                                        : true;
                                                  });
                                                  if (_isTapped[j]) {
                                                    _selectedCordinates
                                                        .add(_cordinates[j]);
                                                  } else {
                                                    if (_selectedCordinates
                                                        .contains(
                                                            _cordinates[j])) {
                                                      _selectedCordinates
                                                          .remove(
                                                              _cordinates[j]);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    height: _cordinates[j]
                                                            .h!
                                                            .toDouble() *
                                                        _deviceWidth /
                                                        _cordinates[j]
                                                            .imgW!
                                                            .toDouble(),
                                                    width: _cordinates[j]
                                                            .w!
                                                            .toDouble() *
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
                                              ),
                                            )
                                          : Text(j.toString()),
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                    h18
                  ]),
                h18
              ]),
              LayoutBuilder(builder: (context, constraint) {
                if (constraint.maxWidth < 700) {
                  return DraggableScrollableSheet(
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
                                  itemCount:
                                      getBottomSheetComponents(context).length,
                                  itemBuilder: (context, index) {
                                    return getBottomSheetComponents(
                                        context)[index];
                                  }),
                            ),
                          ));
                }
                return ThresholdSideSheet(
                  getBottomSheetComponents: getBottomSheetComponents(context),
                );
              }),
            ]),
    );
  }
}

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
              onPanUpdate: (details) {
                _drawerLeft += details.delta.dx;
                if (_drawerLeft <= MediaQuery.of(context).size.width * 3 / 4) {
                  _drawerLeft = MediaQuery.of(context).size.width * 3 / 4;
                }
                if (_drawerLeft >=
                    MediaQuery.of(context).size.width - _offset) {
                  _drawerLeft = MediaQuery.of(context).size.width - _offset;
                }
                if (_drawerLeft <= MediaQuery.of(context).size.width * 3 / 4) {
                  _drawerIcon = Icons.arrow_forward_ios;
                }
                if (_drawerLeft >=
                    MediaQuery.of(context).size.width - 2 * _offset) {
                  _drawerIcon = Icons.arrow_back_ios;
                }
                setState(() {});
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: kSecondaryBgColor,
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(24),
                        bottomStart: Radius.circular(24))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (_drawerLeft <=
                            MediaQuery.of(context).size.width * 3 / 4) {
                          _drawerLeft =
                              MediaQuery.of(context).size.width - 2 * _offset;
                          _drawerIcon = Icons.arrow_back_ios;
                        } else {
                          _drawerLeft =
                              MediaQuery.of(context).size.width * 3 / 4;
                          _drawerIcon = Icons.arrow_forward_ios;
                        }
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(_drawerIcon, color: kWhiteColor),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
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
