import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/faviarot.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/validation.dart';
import 'package:ivr_labs/var.dart';

class Expviewer extends StatefulWidget {
  final List<DocumentSnapshot> documentsOfExperiments;
  final String college, labName, university, imageLink;
  final List<Paths> paths;
  static bool deletingFlag = false, later = false;

  Expviewer({
    this.paths,
    this.college,
    this.labName,
    this.documentsOfExperiments,
    this.university,
    this.imageLink,
  });

  @override
  _ExpviewerState createState() => _ExpviewerState();
}

class _ExpviewerState extends State<Expviewer> {
  @override
  Widget build(BuildContext context) {
    final GeneralMethods _generalMethods = new GeneralMethods(
      context: context,
      documentsOfExperiments: widget.documentsOfExperiments,
      paths: widget.paths,
      labName: widget.labName,
    );
    if (_generalMethods.hadChanges()) {
      _generalMethods.createDialog(context);
    }
    return WillPopScope(
      onWillPop: () {
        return _back(_generalMethods);
      },
      child: Scaffold(
        body: _myBody(),
      ),
    );
  }

  Widget _myFav() {
    bool isDownloaded = StaticVars.downloadedLabs.contains(widget.labName);
    return FaviarotCreator(
      isDownloaded: isDownloaded,
      labName: widget.labName,
    );
  }

  Widget _myBody() {
    return PDFFileReader(
      university: widget.university,
      paths: widget.paths,
      college: widget.college,
      labName: widget.labName,
      fav: _myFav(),
      imageLink: widget.imageLink,
    );
  }

  Future<bool> _back(_generalMethods) async {
    StaticVars.isClicked = false;
    if (Expviewer.deletingFlag) {
      _generalMethods.deletePaths();
    }
    Expviewer.later = false;
    return true;
  }
}
