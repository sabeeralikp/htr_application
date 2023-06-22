import 'package:htr/screens/segment/widgets/widgets.dart';

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

  _getCordinates() async {
    _cordinates = await postThresholdValues(
        _thresholdValue, _horizontalValue, _verticalValue, widget.args!.id);
    _isTapped = [for (int k = 0; k < _cordinates.length; k++) false];
    setState(() {});
  }

  _getAutoSegmentationCordinates(uploadHTR) async {
    _cordinates = await postAutoSegmentationValues(uploadHTR);
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
          .pushNamed(RouteProvider.result, arguments: extractedText)
          .then((value) => {
                setState(() {
                  isLoading = false;
                })
              });
    }
  }

  void thresholdSliderOnChanged(value) {
    _selectedCordinates = [];
    setState(() {
      _thresholdValue = value;
    });
  }

  void horizontalSliderOnChanged(value) {
    _selectedCordinates = [];
    setState(() {
      _horizontalValue = value;
    });
  }

  void verticalSliderOnChanged(value) {
    _selectedCordinates = [];
    setState(() {
      _verticalValue = value;
    });
  }

  List<Widget> getBottomSheetComponents(context) => [
        Container(width: 48, height: 4, margin: pT16B64, decoration: bDW32),
        Text(AppLocalizations.of(context).sheet_components_adjust, style: fP20SB, textAlign: TextAlign.center),
        h20,
        TitleWithValue(title: AppLocalizations.of(context).sheet_components_threshold_value, value: _thresholdValue),
        Slider(
            value: _thresholdValue,
            min: 0,
            max: 300,
            onChanged: thresholdSliderOnChanged),
        TitleWithValue(title: AppLocalizations.of(context).sheet_components_horizontal_spacing, value: _horizontalValue),
        Slider(
            value: _horizontalValue,
            min: 0,
            max: 100,
            onChanged: horizontalSliderOnChanged),
        TitleWithValue(title: AppLocalizations.of(context).sheet_components_vertical_spacing, value: _verticalValue),
        Slider(
            value: _verticalValue,
            min: 0,
            max: 100,
            onChanged: verticalSliderOnChanged),
        h16,
        ElevatedButton(
            onPressed: _getCordinates,
            child: Padding(padding: pA16, child: Text(AppLocalizations.of(context).eleveted_button_threshold))),
      ];

  void initFunction() {
    if (widget.args!.segment == "auto") {
      _getAutoSegmentationCordinates(widget.args!.id);
    } else if (widget.args!.segment == "manual") {
      _getCordinates();
    }
  }

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void selectAllOnClick() {
    setState(() {
      _isTapped = [for (int k = 0; k < _cordinates.length; k++) true];
      for (var i = 0; i < _cordinates.length; i++) {
        _selectedCordinates.add(_cordinates[i]);
      }
    });
  }

  void nextOnClick() async {
    if (_selectedCordinates.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      List<dynamic> extractedText =
          await _getExtractedText(widget.args!.id) as List<dynamic>;
      navigateToResult(extractedText);
    }
  }

  Widget imageLoadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
  }

  void boundingBoxOnClick(int j) {
    setState(() {
      _isTapped[j] = _isTapped[j] ? false : true;
    });
    if (_isTapped[j]) {
      _selectedCordinates.add(_cordinates[j]);
    } else {
      if (_selectedCordinates.contains(_cordinates[j])) {
        _selectedCordinates.remove(_cordinates[j]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appbar_title),
        actions: [
          TextButton(
              onPressed: selectAllOnClick, child: Text(AppLocalizations.of(context).text_button_selectall)),
          w8,
          Padding(
            padding: pR8,
            child: ElevatedButton(
                onPressed: nextOnClick,
                child: Padding(padding: pY8, child: Text(AppLocalizations.of(context).elevated_button_next))),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: LoadingIndicator())
          : Stack(fit: StackFit.expand, children: [
              ListView(children: [
                for (int i = 0; i < widget.args!.numberOfPages!; i++)
                  Column(children: [
                    Stack(children: [
                      Image.network(
                          '$baseURL/media/pdf2img/${widget.args!.filename!.replaceAll('.pdf', '').replaceAll('.jpeg', '').replaceAll('.jpg', '').replaceAll('.png', '')}/$i.png',
                          loadingBuilder: imageLoadingBuilder),
                      _cordinates.isNotEmpty
                          ? SizedBox(
                              height: _cordinates[i].imgH!.toDouble(),
                              child: Stack(children: [
                                for (int j = 0; j < _cordinates.length; j++)
                                  _cordinates[j].p == i
                                      ? Positioned(
                                          left: _cordinates[j].x!.toDouble() *
                                              _deviceWidth /
                                              _cordinates[j].imgW!.toDouble(),
                                          top: _cordinates[j].y!.toDouble() *
                                              _deviceWidth /
                                              _cordinates[j].imgW!.toDouble(),
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
                                                        .remove(_cordinates[j]);
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
                                                        ? kBlueColor
                                                        : kUnSelectedBlueColor,
                                                    width: 1,
                                                  )))))
                                      : const SizedBox()
                              ]))
                          : const SizedBox()
                    ]),
                    h18
                  ]),
                h18
              ]),
              if (widget.args!.segment != "auto")
                LayoutBuilder(
                    builder: (context, constraint) => (constraint.maxWidth <
                            700)
                        ? DraggableScrollableSheetForThresholding(
                            getBottomSheetComponents: getBottomSheetComponents)
                        : ThresholdSideSheet(
                            getBottomSheetComponents:
                                getBottomSheetComponents(context))),
            ]),
    );
  }
}
