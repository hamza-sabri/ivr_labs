import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/faviarot.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/var.dart';
import 'package:path_provider/path_provider.dart';

/*
this class is to show the list of cards with the expirements names and numbers 
for each lab  
*/
class Exp_viewer extends StatelessWidget {
  //some attributs ---------------------------------------------------------------------------------------------------
  List<DocumentSnapshot> documentsOfExperiments;
  String college, labName;
  List<Paths> paths;
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
}
