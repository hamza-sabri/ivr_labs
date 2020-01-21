import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/faviarot.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/validation.dart';
import 'package:ivr_labs/var.dart';

class Expviewer extends StatelessWidget {
  final List<DocumentSnapshot> documentsOfExperiments;
  final String college, labName, university;
  final List<Paths> paths;
  final GeneralMethods _generalMethods = new GeneralMethods();
  final String massage =
      'هذا المختبر تنقصه بعض البانات التي تم اضافتها مؤخرا هل ترغب بمزامنة المختبر ؟';
  final TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
  final TextStyle massageStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
  static bool deletingFlag = false;
  Expviewer({
    this.paths,
    this.college,
    this.labName,
    this.documentsOfExperiments,
    this.university,
  });

  @override
  Widget build(BuildContext context) {
    if (_hadChanges()) {
      _createDialog(context);
    }
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
    return PDFFileReader(
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
      expTemp = path.expPath;
      reportTemp = path.reportPath;
      expDir = Directory(expTemp);
      try {
        await expDir.deleteSync(recursive: true);
        if (reportTemp != null && reportTemp.length > 10) {
          reportDir = Directory(reportTemp);
          await reportDir.deleteSync(recursive: true);
        }
      } catch (e) {
        print('deletion error');
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

  bool _hadChanges() {
    List<Paths> list = StaticVars.labsMap[labName];
    if (list == null) return false;
    if (list.length != documentsOfExperiments.length) return true;
    for (int i = 0; i < list.length; i++) {
      if (_compare(list[i], documentsOfExperiments[i])) {
        return true;
      }
    }
    return false;
  }

  bool _compare(Paths faviarot, DocumentSnapshot doc) {
    if (faviarot.expName != doc['expName']) return true;
    if (faviarot.expLink != doc['expLink']) return true;
    if (faviarot.expNumber != doc['expNumber']) return true;
    if (faviarot.reportLink != doc['report_link']) return true;
    if (faviarot.videoLink != doc['video_link']) return true;
    return false;
  }

  _createDialog(context) async {
    await Future.delayed(const Duration(seconds: 1));
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('مزامنة البيانات')),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                massage,
                style: massageStyle,
              ),
            ),
            actions: <Widget>[
              _myRow(context),
            ],
          );
        });
  }

  Widget _myRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: _customButton('لاحقا', () {
            Navigator.of(context).pop();
          }),
        ),
        _customButton('بدء المزامنة', () {
          StaticVars.downloadedLabs.remove(labName);
          _syncHandler(context);
        }),
      ],
    );
  }

  _syncHandler(context) async {
    await _deletePaths();
    Navigator.of(context).pop();
    Navigator.of(context).pop(context);
    StaticVars.isClicked = false;
  }

  _customButton(String msg, action()) {
    return RaisedButton(
      child: Text(msg, style: style),
      elevation: 8,
      color: Colors.blue,
      onPressed: () {
        action();
      },
    );
  }
}
