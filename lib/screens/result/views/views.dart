import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/api.dart';
import 'package:htr/models/htr.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:io' show Platform;

class ResulPage extends StatefulWidget {
  final HTRModel? args;
  const ResulPage({this.args, super.key});

  @override
  State<ResulPage> createState() => _ResulPageState();
}

class _ResulPageState extends State<ResulPage> {
  final ScrollController _scController = ScrollController();
  PdfController? _pdfController;
  PdfControllerPinch? _pdfControllerPinch;
  giveSource(HTRModel args) {
    if (args.file != null) {
      _pdfController = PdfController(
          document:
              PdfDocument.openData(InternetFile.get(baseURL + args.file!)));
      _pdfControllerPinch = PdfControllerPinch(
          document:
              PdfDocument.openData(InternetFile.get(baseURL + args.file!)));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      giveSource(widget.args!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result Page'),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          if (widget.args != null) {
            giveSource(widget.args!);
          }
          log(constraint.maxWidth.toString());
          if (constraint.maxWidth > 700) {
            return LargeResultBody(
              scController: _scController,
              pdfController: _pdfController,
              pdfControllerPinch: _pdfControllerPinch,
              extractedText: widget.args!.extractedText,
            );
          } else {
            return SmallResultBody(
              scController: _scController,
              pdfController: _pdfController,
              pdfControllerPinch: _pdfControllerPinch,
              extractedText: widget.args!.extractedText,
            );
          }
        }));
  }
}

class LargeResultBody extends StatelessWidget {
  const LargeResultBody({
    super.key,
    required ScrollController scController,
    required PdfController? pdfController,
    required PdfControllerPinch? pdfControllerPinch,
    this.extractedText,
  })  : _scController = scController,
        _pdfControllerPinch = pdfControllerPinch,
        _pdfController = pdfController;

  final ScrollController _scController;
  final PdfController? _pdfController;
  final PdfControllerPinch? _pdfControllerPinch;
  final String? extractedText;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scController,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 1.5,
                width: MediaQuery.of(context).size.width / 2,
                child: kIsWeb || !Platform.isWindows
                    ? PdfViewPinch(controller: _pdfControllerPinch!)
                    : PdfView(
                        controller: _pdfController!,
                        renderer: (PdfPage page) => page.render(
                          width: page.width * 5,
                          height: page.height * 5,
                          format: PdfPageImageFormat.jpeg,
                          backgroundColor: '#FFFFFF',
                          quality: 100,
                        ),
                      )),
            SizedBox(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 2,
              child: TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: 42,
                minLines: 12,
                initialValue: extractedText,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SmallResultBody extends StatelessWidget {
  const SmallResultBody({
    super.key,
    required ScrollController scController,
    required PdfController? pdfController,
    required PdfControllerPinch? pdfControllerPinch,
    this.extractedText,
  })  : _scController = scController,
        _pdfControllerPinch = pdfControllerPinch,
        _pdfController = pdfController;

  final ScrollController _scController;
  final PdfController? _pdfController;
  final PdfControllerPinch? _pdfControllerPinch;
  final String? extractedText;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scController,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: kIsWeb || !Platform.isWindows
              ? PdfViewPinch(controller: _pdfControllerPinch!)
              : PdfView(
                  controller: _pdfController!,
                  renderer: (PdfPage page) => page.render(
                    width: page.width,
                    height: page.height,
                    format: PdfPageImageFormat.jpeg,
                    backgroundColor: '#FFFFFF',
                    quality: 100,
                  ),
                ),
        ),
        TextFormField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          maxLines: 42,
          minLines: 12,
          initialValue: extractedText,
        )
      ],
    );
  }
}
