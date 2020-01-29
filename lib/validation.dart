import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';
import 'epx_viewer.dart';

class GeneralMethods {
  final String labName;
  final TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
  final String massage =
      'هذا المختبر تنقصه بعض البانات التي تم اضافتها مؤخرا هل ترغب بمزامنة المختبر ؟';

  final TextStyle massageStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
  final context, documentsOfExperiments, paths;
  GeneralMethods({
    this.labName,
    this.context,
    this.documentsOfExperiments,
    this.paths,
  });
  bool syncronisingLap = false;

  void toastMaker(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: (msg.length < 25) ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  //check the non since thing that goes her
  //this method should belong to the static methods not her !!!
  Future<void> deletePaths() async {
    await _deleteHandler();
    if (!syncronisingLap) {
      toastMaker('lab has been deleted successfully');
    } else {
      toastMaker('تمت المزامنة بنجاح يمكنك الان اعادة تحميل المختبر');
    }
    StaticVars.labsMap.remove(labName);
    StaticVars.currentLabName = null;
    StaticVars.downloadedLabs.remove(labName);
    Expviewer.deletingFlag = false;
  }

  Future<void> _deleteHandler() async {
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
  }

  //from this line the rest of the method are to make sure that the user have the latest data
  bool hadChanges() {
    //if the user selected later the dialog will not appear
    if (Expviewer.later) return false;
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

  createDialog(context) async {
    await Future.delayed(const Duration(seconds: 1));
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'مزامنة البيانات',
                  style:
                      new TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
            content: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  massage,
                  style: massageStyle,
                ),
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
            Expviewer.later = true;
            toastMaker(
                'تحذير قد تكون البيانات المحملة حاليا ناقصة او مغلوطة يرجى مزامنة المختبر في اقرب وقت');
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
    syncronisingLap = true;
    await deletePaths();
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
