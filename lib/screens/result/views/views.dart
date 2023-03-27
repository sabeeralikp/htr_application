import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;

class ResulPage extends StatefulWidget {
  final List<dynamic>? args;
  const ResulPage({this.args, super.key});

  @override
  State<ResulPage> createState() => _ResulPageState();
}

class _ResulPageState extends State<ResulPage> {
  final fq.QuillController _controller = fq.QuillController.basic();
  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      String words = "";
      for (var str in widget.args!) {
        words = "$words $str";
      }
      _controller.document.insert(0, words);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result Page'),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download_for_offline_rounded))
          ],
        ),
        body: Column(
          children: [
            fq.QuillToolbar.basic(controller: _controller),
            Expanded(
              child: fq.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            )
          ],
        ));
  }
}
