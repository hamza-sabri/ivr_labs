import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';

class Exp_viewer extends StatelessWidget {
  String labName;
  List<Paths> paths;
  Exp_viewer({this.paths, this.labName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(labName),
        centerTitle: true,
      ),
      body: 
      PDF_File_Reader(
        paths: paths,
      ),
    
    );
  }
}
