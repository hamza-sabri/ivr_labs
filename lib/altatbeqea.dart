import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'lab_builder.dart';

class AltatbeqeaCollege extends StatelessWidget {
  List<Paths> pathes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('كلية التطبيقية'),
        centerTitle: true,
      ),
      body: LabBuilder(
        college: 'التطبيقية',
      ),
    );
  }
}
