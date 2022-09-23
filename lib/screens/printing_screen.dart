import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart' as pr;

class PrintingScreen extends StatelessWidget {
  const PrintingScreen({Key key, this.pdfFile}) : super(key: key);

  final pdfFile;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'Print',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: pr.PdfPreview(
          build: (format) => pdfFile,
          // padding: EdgeInsets.symmetric(
          //   horizontal: width * 0.3,
          //   vertical: 50,
          // ),
          pdfFileName: 'test',
          useActions: true,
          canChangeOrientation: true,
          canChangePageFormat: true,
          canDebug: false,
        ),
      ),
    );
  }
}
