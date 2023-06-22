import 'dart:developer';
import 'package:htr/providers/locale_provider.dart';
import 'package:htr/screens/home/widgets/widgets.dart';
import 'package:provider/provider.dart';


enum Segmentation { manual, auto }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  UploadHTRModel? htr;
  bool isUploading = false;
  FilePickerResult? result;
  Segmentation selectedSegment = Segmentation.auto;

  Future<void> uploadFile() async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    if (result != null) {
      setState(() {
        isUploading = true;
      });
      if (kIsWeb) {
        Uint8List? fileBytes = result!.files.first.bytes;
        String fileName = result!.files.first.name;
        if (fileBytes != null) {
          htr = await uploadHTRWeb(fileBytes, fileName);
          isUploading = false;
          setState(() {});
        }
      } else {
        file = File(result!.files.single.path!);
        if (file != null) {
          htr = await uploadHTR(file!);
          isUploading = false;
          setState(() {});
        }
      }
      // navigateToResult();
    }
  }

  void navigateToResult() {
    if (htr != null) {
      htr!.segment = selectedSegment.name;
      Navigator.of(context).pushNamed(RouteProvider.segment, arguments: htr);
    }
  }

  getCameraImage() async {
    if (mounted) {
      try {
        final XFile? capturedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (capturedImage == null) return;
        file = File(capturedImage.path);
        if (file != null) {
          htr = await uploadHTR(file!);
          isUploading = false;
          setState(() {});
        }
      } on Exception catch (e) {
        log('Failed to pick image: $e');
      }
    }
  }

  void removeHTR() {
    setState(() {
      htr = null;
    });
  }

  void segmentOnClick(Set<Segmentation> newSelection) {
    setState(() {
      selectedSegment = newSelection.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () => Provider.of<LocaleProvider>(context, listen: false)
                .changeLocale(),
            icon: const Icon(Icons.translate_rounded))
      ]),
      body: Padding(
        padding: pX32,
        child: Center(
          child: isUploading
              ? const UploadingIndicator()
              : htr == null
                  ? const UploadFileBody()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: pA32,
                          decoration: bDP16,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context).file_uploaded_title, style: fW16N),
                              h16,
                              UploadedFileContainer(
                                  htr: htr!, removeHTR: removeHTR),
                              h16,
                              SegmentedButton<Segmentation>(
                                  style: wPButtonStyle,
                                  segments:  <ButtonSegment<Segmentation>>[
                                    ButtonSegment<Segmentation>(
                                        value: Segmentation.manual,
                                        label: Text(AppLocalizations.of(context).segmentation_button_manual),
                                        icon: const Icon(Icons.tune_rounded)),
                                     ButtonSegment<Segmentation>(
                                        value: Segmentation.auto,
                                        label: Text(AppLocalizations.of(context).segmentation_button_auto),
                                        icon: const Icon(Icons.auto_awesome))
                                  ],
                                  selected: <Segmentation>{selectedSegment},
                                  onSelectionChanged: segmentOnClick),
                              h48,
                              ElevatedButton(
                                  onPressed: navigateToResult,
                                  style: wPButtonStyle,
                                  child:  Padding(
                                      padding: pA16, child: Text(AppLocalizations.of(context).segmentation_button_cont)))
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: htr == null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                    label: Text(AppLocalizations.of(context).upload_fab, style: fW16M),
                    icon: cloudUploadIcon,
                    onPressed: uploadFile),
                w8,
                if (Platform.isAndroid || Platform.isIOS)
                  FloatingActionButton(
                      onPressed: getCameraImage, child: iCamera)
              ],
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
