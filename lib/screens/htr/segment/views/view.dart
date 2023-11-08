import 'dart:developer';

import 'package:htr/config/buttons/custom_elevated_button.dart';
import 'package:htr/screens/htr/segment/widgets/widgets.dart';

/// [segment added]
/// [author] swathyas96
/// [since]	v0.0.1
/// [version]	v1.0.0	(March 3rd, 2023 10:04 AM)
///
/// A StatefulWidget for displaying and managing the segmentation settings and results.
class Segment extends StatefulWidget {
  /// The arguments received from the previous screen, typically containing HTR results.
  final UploadHTRModel? args;

  /// Constructor for the `Segment` class.
  ///
  /// [args] is required and represents the arguments received from the previous screen.
  const Segment({required this.args, super.key});

  @override
  State<Segment> createState() => _SegmentState();
}

class _SegmentState extends State<Segment> {
  /// The threshold value for segmentation.
  double _thresholdValue = 80;

  /// The horizontal gap value for segmentation.
  double _horizontalValue = 3;

  /// The vertical gap value for segmentation.
  double _verticalValue = 40;

  /// A list to keep track of whether each segment is tapped.
  List<bool> _isTapped = [];

  /// A list to store the coordinates of segments.
  List<Cordinates> _cordinates = [];

  /// A list to store selected coordinates (segments).
  List<Cordinates> _selectedCordinates = [];

  /// A flag indicating whether data is loading.
  bool isLoading = false;

  /// The device width.
  double _deviceWidth = 0;

  List<Cordinates> _fullCordinates = [];
  int i = 0;
  int index = 0;

  /// Fetches segmentation coordinates using specified threshold values.
  _getCordinates() async {
    _fullCordinates = await postThresholdValues(
        _thresholdValue, _horizontalValue, _verticalValue, widget.args!.id);
    _cordinates = _fullCordinates.takeWhile((value) => value.p == i).toList();
    index = _fullCordinates.indexOf(_cordinates[0]);
    _isTapped = [for (int k = 0; k < _fullCordinates.length; k++) false];
    setState(() {});
  }

  /// Fetches segmentation coordinates using automatic segmentation values.
  _getAutoSegmentationCordinates(uploadHTR) async {
    _fullCordinates = await postAutoSegmentationValues(uploadHTR);
    _cordinates = _fullCordinates.takeWhile((value) => value.p == i).toList();
    index = _fullCordinates.indexOf(_cordinates[0]);
    _isTapped = [for (int k = 0; k < _fullCordinates.length; k++) false];
    setState(() {});
  }

  /// Retrieves extracted text based on selected coordinates (segments).
  _getExtractedText(uploadHTR) async {
    List<dynamic> extractedText =
        await postExtractText(_selectedCordinates, uploadHTR);
    return extractedText;
  }

  /// Navigates to the result screen with extracted text data.
  ///
  /// [extractedText] is the extracted text data to be passed as arguments to the result screen.

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
    setState(() {});
  }

  /// Callback function for the threshold slider onChanged event.
  ///
  /// [value] is the new threshold value selected by the user.
  void thresholdSliderOnChanged(value) {
    _selectedCordinates = [];
    setState(() {
      _thresholdValue = value;
    });
  }

  /// Callback function for the horizontal gap slider onChanged event.
  ///
  /// [value] is the new horizontal gap value selected by the user.
  void horizontalSliderOnChanged(value) {
    _selectedCordinates = [];
    setState(() {
      _horizontalValue = value;
    });
  }

  /// Callback function for the vertical gap slider onChanged event.
  ///
  /// [value] is the new vertical gap value selected by the user.
  void verticalSliderOnChanged(value) {
    _selectedCordinates = [];
    setState(() {
      _verticalValue = value;
    });
  }

  /// Returns a list of widgets to be used in the bottom sheet.
  ///
  /// [context] is the [BuildContext] used for localization and styling.

  List<Widget> getBottomSheetComponents(context) => [
        Container(width: 48, height: 4, margin: pT16B64, decoration: bDW32),
        Text(
            AppLocalizations.of(context)!
                .sheet_components_adjust, // Title for adjusting components.
            style: fB20SB,
            textAlign: TextAlign.center),
        h20,
        // Threshold value slider.
        TitleWithValue(
            title:
                AppLocalizations.of(context)!.sheet_components_threshold_value,
            value: _thresholdValue),
        Slider(
            value: _thresholdValue,
            min: 0,
            max: 300,
            onChanged: thresholdSliderOnChanged),
        // Horizontal spacing slider.
        TitleWithValue(
            title: AppLocalizations.of(context)!
                .sheet_components_horizontal_spacing,
            value: _horizontalValue),
        Slider(
            value: _horizontalValue,
            min: 0,
            max: 100,
            onChanged: horizontalSliderOnChanged),
        // Vertical spacing slider.
        TitleWithValue(
            title:
                AppLocalizations.of(context)!.sheet_components_vertical_spacing,
            value: _verticalValue),
        Slider(
            value: _verticalValue,
            min: 0,
            max: 100,
            onChanged: verticalSliderOnChanged),
        h16,
        // Button to apply changes.
        CustomElevatedButton(
            onPressed: _getCordinates,
            child:
                Text(AppLocalizations.of(context)!.eleveted_button_threshold)),
      ];

  /// Initializes the function based on the segmentation mode.
  ///
  /// If the [segment] is "auto," it fetches auto-segmented coordinates.
  /// If the [segment] is "manual," it fetches coordinates based on current settings.
  showWordSnackbar() {
    SnackBar snackBar = SnackBar(
      content: Text(AppLocalizations.of(context)!.word_snackbar),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


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
    // Initialize the widget state.
    initFunction();
  }

  /// Selects all coordinates on a button click.
  void selectAllOnClick() {
    setState(() {
      // Mark all coordinates as selected.
      _isTapped = [for (int k = 0; k < _cordinates.length; k++) true];
      // Add all coordinates to the selected list.
      for (var i = 0; i < _cordinates.length; i++) {
        _selectedCordinates.add(_cordinates[i]);
      }
    });
  }

  /// Handles the next button click.
  void nextOnClick() async {
    if (_selectedCordinates.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      // Fetch extracted text based on selected coordinates.
      List<dynamic> extractedText =
          await _getExtractedText(widget.args!.id) as List<dynamic>;
      // Navigate to the result screen with extracted text.
      navigateToResult(extractedText);
    } else {
      showWordSnackbar();
    }
  }

  /// Builder for loading images with a progress indicator.
  Widget imageLoadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return Center(
        child: CircularProgressIndicator(
            // Show loading progress as a percentage if available.
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null));
  }

  /// Handles bounding box selection on click.
  ///
  /// [j] is the index of the bounding box being clicked.
  void boundingBoxOnClick(int j) {
    setState(() {
      // Toggle the selection state of the bounding box.
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

  _goToNextPage() {
    _cordinates = [];
    setState(() {
      i += 1;
      _cordinates = _fullCordinates.where((value) => value.p == i).toList();
      index = _fullCordinates.indexOf(_cordinates[0]);
    });
    log(_cordinates.first.p.toString());
  }

  _goToPreviousPage() {
    _cordinates = [];
    setState(() {
      i -= 1;
      _cordinates = _fullCordinates.takeWhile((value) => value.p == i).toList();
      index = _fullCordinates.indexOf(_cordinates[0]);
    });
    log(_cordinates.first.p.toString());
  }

  @override
  Widget build(BuildContext context) {
    // Update device width based on the current context.
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            // App title in the app bar.
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.appbar_title, style: fB20N),
                Row(children: [
                  if (i > 0) ...[
                    CustomWhiteElevatedButton(
                        onPressed: _goToPreviousPage,
                        child: const Icon(Icons.chevron_left_rounded)),
                    w8,
                  ],
                  Container(
                      padding: pA8,
                      decoration: BoxDecoration(
                          color: kTextGreyColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: kTextGreyColor.withOpacity(0.4))),
                      child: Column(
                        children: [
                          Text('Page No', style: fG14N),
                          Text('${i + 1}', style: fB16M),
                        ],
                      )),
                  if (i < widget.args!.numberOfPages! - 1) ...[
                    w8,
                    CustomWhiteElevatedButton(
                        onPressed: _goToNextPage,
                        child: const Icon(Icons.chevron_right_rounded))
                  ]
                ]),
                const SizedBox()
              ],
            ),
            actions: [
              // TextButton(
              //     onPressed: selectAllOnClick,
              //     child:
              //         Text(AppLocalizations.of(context).text_button_selectall)),
              // w8,
              // Next button in the app bar.
              Padding(
                  padding: pR8,
                  child: CustomElevatedButton(
                      onPressed: nextOnClick,
                      child: Text(
                          AppLocalizations.of(context)!.elevated_button_next)))
            ]),
        body: isLoading
            ? const Center(child: LoadingIndicator())
            : Stack(fit: StackFit.expand, children: [
                ListView(children: [
                  // for (int i = 0; i < widget.args!.numberOfPages!; i++)
                  Column(children: [
                    // Display images with bounding boxes.
                    Stack(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          '$baseURL/media/pdf2img/${widget.args!.filename!.replaceAll('.pdf', '').replaceAll('.jpeg', '').replaceAll('.jpg', '').replaceAll('.png', '')}/$i.png',
                          loadingBuilder: imageLoadingBuilder,
                          fit: BoxFit.contain,
                        ),
                      ),
                      _cordinates.isNotEmpty
                          ? SizedBox(
                              height: _cordinates[i].imgH!.toDouble(),
                              child: Stack(children: [
                                for (int j = 0; j < _cordinates.length; j++)
                                  Positioned(
                                      left: _cordinates[j].x!.toDouble() *
                                          _deviceWidth /
                                          _cordinates[j].imgW!.toDouble(),
                                      top: _cordinates[j].y!.toDouble() *
                                          _deviceWidth /
                                          _cordinates[j].imgW!.toDouble(),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isTapped[j + index] =
                                                  _isTapped[j + index]
                                                      ? false
                                                      : true;
                                            });
                                            if (_isTapped[j + index]) {
                                              _selectedCordinates
                                                  .add(_cordinates[j]);
                                            } else {
                                              if (_selectedCordinates
                                                  .contains(_cordinates[j])) {
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
                                              width:
                                                  _cordinates[j].w!.toDouble() *
                                                      _deviceWidth /
                                                      _cordinates[j]
                                                          .imgW!
                                                          .toDouble(),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: _isTapped[
                                                              j + index]
                                                          ? kBlueColor
                                                          : kUnSelectedBlueColor,
                                                      width: 1)))))
                              ]))
                          : const SizedBox()
                    ]),
                    h18
                  ]),
                  h18
                ]),
                // Display threshold settings side sheet based on screen width.
                if (widget.args!.segment != "auto")
                  LayoutBuilder(
                      builder: (context, constraint) =>
                          (constraint.maxWidth < 700)
                              ? DraggableScrollableSheetForThresholding(
                                  getBottomSheetComponents:
                                      getBottomSheetComponents)
                              : ThresholdSideSheet(
                                  getBottomSheetComponents:
                                      getBottomSheetComponents(context)))
              ]));
  }
}
