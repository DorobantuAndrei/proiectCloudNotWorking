import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import '../models/models.dart';
// import 'data.dart';
import 'examples/invoice.dart';

const examples = <Example>[
  // Example('RÉSUMÉ', 'resume.dart', generateResume),
  // Example('DOCUMENT', 'document.dart', generateDocument),
  Example('INVOICE', 'invoice.dart', generateInvoice, true),
  // Example('REPORT', 'report.dart', generateReport),
  // Example('CALENDAR', 'calendar.dart', generateCalendar),
  // Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
  PdfPageFormat pageFormat,
  List<MyTransaction> transactions,
  Furnizor furnizor,
);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
