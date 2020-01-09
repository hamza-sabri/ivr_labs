import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/faviarot.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/validation.dart';
import 'package:ivr_labs/var.dart';

class Exp_viewer extends StatelessWidget {
  List<DocumentSnapshot> documentsOfExperiments;
  String college, labName, university;
  List<Paths> paths;
  GeneralMethods _generalMethods = new GeneralMethods();
  static bool deletingFlag = false;
 
  Exp_viewer({
    this.paths,
    this.college,
    this.labName,
    this.documentsOfExperiments,
    this.university,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _back();
      },
      child: Scaffold(
        appBar: _myAppBar(),
        body: _myBody(),
      ),
    );
  }

  //building a custom appBar woth favarot botton
  AppBar _myAppBar() {
    return AppBar(
      title: Text(labName),
      centerTitle: true,
      actions: <Widget>[
        _myFav(),
      ],
    );
  }

  //returns what FaviarotCreator is returning
  Widget _myFav() {
    bool isDownloaded = StaticVars.downloadedLabs.contains(labName);
    return FaviarotCreator(
      isDownloaded: isDownloaded,
      labName: labName,
    );
  }

  Widget _myBody() {
    return PDF_File_Reader(
      university: university,
      paths: paths,
      college: college,
      labName: labName,
    );
  }

  //check the non since thing that goes her
  //this method should belong to the static methods not her !!!
  Future<void> _deletePaths() async {
    var expDir, reportDir;
    String expTemp, reportTemp;
    for (var path in paths) {
      expTemp = path.exp_path;
      reportTemp = path.report_path;
      expDir = Directory(expTemp);
      await expDir.deleteSync(recursive: true);
      if (reportTemp != null && reportTemp.length > 10) {
        reportDir = Directory(reportTemp);
        await reportDir.deleteSync(recursive: true);
      }
    }
    _generalMethods.toastMaker('lab has been deleted successfully');
    StaticVars.labsMap.remove(labName);
    StaticVars.currentLabName = null;
    StaticVars.downloadedLabs.remove(labName);
    deletingFlag = false;
  }

  //deleting the exp if the flag is true
  Future<bool> _back() async {
    StaticVars.isClicked = false;
    if (deletingFlag) {
      _deletePaths();
    }
    return true;
  }
}
