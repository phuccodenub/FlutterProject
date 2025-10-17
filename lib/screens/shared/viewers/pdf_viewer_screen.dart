import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key, required this.path});
  final String path;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfControllerPinch controller;

  @override
  void initState() {
    super.initState();
    controller = PdfControllerPinch(
      document: PdfDocument.openFile(widget.path),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: PdfViewPinch(controller: controller),
    );
  }
}
