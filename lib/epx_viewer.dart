import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ivr_labs/faviarot.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/var.dart';

/*
this class is to show the list of cards with the expirements names and numbers 
for each lab  
*/
class Exp_viewer extends StatelessWidget {
  //some attributs ---------------------------------------------------------------------------------------------------
  List<DocumentSnapshot> documentsOfExperiments;
  String college, labName;
  List<Paths> paths;
  static bool deletingFlag = false;
  //------------------------------------------
  Exp_viewer({
    this.paths,
    this.college,
    this.labName,
    this.documentsOfExperiments,
  });
  //-------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (deletingFlag) {
          _deletePaths();
        }
        return _back();
      },
      child: Scaffold(
        appBar: _myAppBar(),
        body: _myBody(),
      ),
    );
  }

  Widget _myBody() {
    return PDF_File_Reader(
      paths: paths,
      college: college,
      labName: labName,
    );
  }

  AppBar _myAppBar() {
    return AppBar(
      title: Text(labName),
      centerTitle: true,
      actions: <Widget>[
        _myFav(),
      ],
    );
  }

  Widget _myFav() {
    bool isDownloaded = StaticVars.downloadedLabs.contains(labName);
    return FaviarotCreator(
      isDownloaded: isDownloaded,
      labName: labName,
    );
  }

//this method is called when this activity is done "killed"
  Future<bool> _back() async {
    StaticVars.isClicked = false;
    return true;
  }

  Future<void> _deletePaths() async {
    //some vars
    var expDir, reportDir;
    int length = paths.length;
    String expTemp, reportTemp;
    //----------------------------------------------------------------------
    //looping throug out the paths list
    for (int i = 0; i < length; i++) {
      expTemp = paths[i].exp_path;
      reportTemp = paths[i].report_path;
      expDir = Directory(expTemp);
      await expDir.deleteSync(recursive: true);
      if (reportTemp != null && reportTemp.length > 10) {
        reportDir = Directory(reportTemp);
        await reportDir.deleteSync(recursive: true);
      }
    }
    //----------------------------------------------------------------------
    _toastMaker('lab has been deleted successfully');
    StaticVars.labsMap.remove(labName);
    StaticVars.currentLabName = null;
    StaticVars.downloadedLabs.remove(labName);
    deletingFlag = false;
  }

  void _toastMaker(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
