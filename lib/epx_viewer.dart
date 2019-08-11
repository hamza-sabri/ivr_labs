import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/var.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Exp_viewer extends StatelessWidget {
  List<DocumentSnapshot> documentsOfExperiments;
  String labName;
  List<Paths> paths;
  Exp_viewer({
    this.paths,
    this.labName,
    this.documentsOfExperiments,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: labName,
          child: Text(labName),
        ),
        centerTitle: true,
      ),
      body: PDF_File_Reader(
        paths: paths,
      ),
    );
  }
}
