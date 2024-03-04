import 'dart:developer';
import 'dart:io';

import 'package:delta_to_pdf/delta_to_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:dhriti/api/api.dart';
import 'package:dhriti/api/htr.dart';
import 'package:dhriti/api/ocr.dart';
import 'package:dhriti/config/buttons/button_themes.dart';
import 'package:dhriti/config/measures/gap.dart';
import 'package:dhriti/models/ocr_result.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/widgets.dart' as pw;

class OCRResult extends StatefulWidget {
  const OCRResult({super.key, required this.ocrResult});

  final OCRResultModel? ocrResult;

  @override
  State<OCRResult> createState() => _OCRResultState();
}

class _OCRResultState extends State<OCRResult> {
  int i = 0;
  bool isTextLoading = false;

  getNextPage() async {
    if (widget.ocrResult!.ocr != null &&
        widget.ocrResult!.ocr!.numberOfPages! > 1) {
      setState(() {
        isTextLoading = true;
      });
      for (i = 1; i < widget.ocrResult!.ocr!.numberOfPages!; i++) {
        String? extractedText =
            await extractText(i, widget.ocrResult!.ocr!.id!);
        String text = widget.ocrResult!.quillController!.document.toPlainText();
        text += (extractedText ?? '');
        widget.ocrResult!.quillController!.clear();
        widget.ocrResult!.quillController!.document.insert(0, text);
        setState(() {
          isTextLoading = false;
        });
      }
    }
  }

  showSavedSnackbar(String downloadLocation, filename) {
    SnackBar snackBar = SnackBar(
        content: Text(
            AppLocalizations.of(context)!.snack_location(downloadLocation)),
        action: SnackBarAction(
            label: 'Open',
            onPressed: () => OpenAppFile.open('$downloadLocation/$filename')));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  copyText() async {
    await Clipboard.setData(ClipboardData(
        text: widget.ocrResult!.quillController!.document.toPlainText()));
    setState(() {
      SnackBar snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.clipboard_content));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  saveDOCX(pdf) async {
    /// Save the PDF as a temporary file
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/document.pdf");
    await file.writeAsBytes(await pdf.save());

    /// Convert the PDF to DOCX format
    String? filePath = await exportAsDOC(file);

    /// Download the converted DOCX file
    final request = await HttpClient().getUrl(Uri.parse(baseURL +
        filePath!.replaceFirst(".pdf", ".docx").replaceFirst("PDF", "Doc")));
    final response = await request.close();
    final docfile = File("${output.path}/document.docx");
    response.pipe(docfile.openWrite());
    showSavedSnackbar(output.path, 'document.docx');
  }

  getTheme() async {
    var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle
            .load("assets/font/mandharam/mandharam_regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/font/mandharam/mandharam_bold.ttf")),
        italic: pw.Font.ttf(await rootBundle
            .load("assets/font/mandharam/mandharam_italic.ttf")),
        boldItalic: pw.Font.ttf(await rootBundle
            .load("assets/font/mandharam/mandharam_bold_italic.ttf")));
    return myTheme;
  }

  exportDoc() async {
    final pdf = pw.Document(
      theme: await getTheme(),
    );
    var delta = widget.ocrResult!.quillController!.document.toDelta().toList();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          DeltaToPDF dpdf = DeltaToPDF();
          return dpdf.deltaToPDF(delta);
        }));

    await saveDOCX(pdf);
  }

  bool playing = false;
  final int date = DateTime.now().millisecondsSinceEpoch;
  final player = AudioPlayer();
  speak() async {
    setState(() {
      playing = !playing;
    });
    if (!playing) {
      await player.stop();
      return;
    }
    List<String> texts = widget.ocrResult!.quillController!.document
        .toPlainText()
        .replaceAll('\n\n', ". ")
        .replaceAll('\n', "")
        .split(RegExp('[.]'));
    log(texts.toString());
    // final int date = DateTime.now().millisecondsSinceEpoch;
    if (widget.ocrResult!.ocr != null) {
      // await textToSpeech(texts[0], 'ocr/${widget.ocrResult!.ocr!.id}', 0);
      String filepath =
          '$baseURL/media/speech/ocr/${widget.ocrResult!.ocr!.id}';
      await textToSpeech(texts[0], 'ocr/${widget.ocrResult!.ocr!.id}', 0);
      final playlist = ConcatenatingAudioSource(
          useLazyPreparation: false,
          children: [AudioSource.uri((Uri.parse('$filepath/0.wav')))]);

      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.setShuffleModeEnabled(false);
      player.setSpeed(0.8);
      player.play();
      for (var i = 1; i < texts.length; i++) {
        log('${texts[i]}ocr_offline/$date$i');
        if (texts[i] == " ") {
          continue;
        }
        await textToSpeech(texts[i], 'ocr/${widget.ocrResult!.ocr!.id}', i)
            .whenComplete(() =>
                playlist.add(AudioSource.uri((Uri.parse('$filepath/$i.wav')))));
      }
      // player.stop();
      setState(() {
        playing = false;
      });
    } else {
      String filepath = '$baseURL/media/speech/ocr_offline/$date';
      await textToSpeech(texts[0], 'ocr_offline/$date', 0);
      final playlist = ConcatenatingAudioSource(
          useLazyPreparation: false,
          children: [AudioSource.uri((Uri.parse('$filepath/0.wav')))]);

      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.setShuffleModeEnabled(false);
      player.setSpeed(0.8);
      player.play();
      for (var i = 1; i < texts.length; i++) {
        log('${texts[i]}ocr_offline/$date$i');
        if (texts[i] == " ") {
          continue;
        }
        await textToSpeech(texts[i], 'ocr_offline/$date', i).whenComplete(() =>
            playlist.add(AudioSource.uri((Uri.parse('$filepath/$i.wav')))));
      }
      // player.stop();
      setState(() {
        playing = false;
      });
    }
    // log(widget.ocrResult!.ocr.toString());
    // if (widget.ocrResult!.ocr != null) {
    //   await textToSpeech(texts[0], 'ocr/${widget.ocrResult!.ocr!.id}', 0);
    // } else {
    //   final date = DateTime.now().millisecondsSinceEpoch;
    //   await textToSpeech(text, 'ocr_offline/$date', 0);
    //   final playlist = ConcatenatingAudioSource(children: [
    //     AudioSource.uri(
    //         (Uri.parse('$baseURL/media/speech/ocr_offline/$date/0.wav')))
    //   ]);
    //   final player = AudioPlayer();
    //   await player.setAudioSource(playlist);
    //   player.play();
    // }
  }

  @override
  void initState() {
    super.initState();
    getNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Result'),
            actions: [
              CustomWhiteElevatedButton(
                  onPressed: () async => copyText(),
                  child: const Row(
                    children: [
                      Text("Copy All"),
                      w8,
                      Icon(Icons.copy_all_rounded)
                    ],
                  )),
              w8,
              CustomWhiteElevatedButton(
                  onPressed: () async => exportDoc(),
                  child: const Row(
                    children: [
                      Text("Export As"),
                      w8,
                      Icon(Icons.file_download_outlined)
                    ],
                  )),
              w8
            ],
            bottom: (isTextLoading)
                ? const PreferredSize(
                    preferredSize: Size(double.infinity, 16),
                    child: LinearProgressIndicator())
                : null),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (widget.ocrResult!.quillController != null) ...[
                fq.QuillToolbar.basic(
                    controller: widget.ocrResult!.quillController!),
                Expanded(
                    child: fq.QuillEditor.basic(
                        controller: widget.ocrResult!.quillController!,
                        readOnly: false))
              ]
            ])),
        floatingActionButton: (!isTextLoading)
            ? FloatingActionButton(
                onPressed: speak,
                child: Icon(
                  playing ? Icons.pause_rounded : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 34,
                ))
            : null);
  }
}
