import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/data_collection.dart';
import 'package:ivr_labs/paths.dart';

class GeneralMethods {
  final String universityName, collegeName;
  String labID;
  final TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
  final String massage =
      'هذا المختبر تنقصه بعض البيانات التي تم اضافتها مؤخرا هل ترغب بمزامنة المختبر ؟';

  final TextStyle massageStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
  final context, documentsOfExperiments, paths;

  final DataCollection dataCollection;

  GeneralMethods({
    this.labID,
    this.context,
    this.documentsOfExperiments,
    this.paths,
    this.universityName,
    this.collegeName,
    @required this.dataCollection,
  });

//-------------------------------------------------------------------------------------------------
//this method is to push the reports and the stuff to firebase
  bool push(List<String> data, String id) {
    if (_validate(data)) {
      _addDataToFireBase(data, id);
      return true;
    }
    toastMaker('failed for the mentioned reason');
    return false;
  }

  bool createNewUniversity(String newUniversityName, String imageLink) {
    Firestore.instance.collection('univ').document(newUniversityName);
    Firestore.instance
        .collection('univ')
        .document(newUniversityName)
        .setData({'image': imageLink});
    return true;
  }

  bool createNewCollege(String newCollegeName, String imageLink) {
    Firestore.instance
        .collection('univ')
        .document(universityName)
        .collection('colleges')
        .document(newCollegeName)
        .setData({'image': imageLink});
    return true;
  }

  bool createNewLab(String newLabName, String imageLink) {
    Firestore.instance
        .collection('univ')
        .document(universityName)
        .collection('colleges')
        .document(collegeName)
        .collection('labs')
        .document(newLabName)
        .setData({'image': imageLink});
    return true;
  }

  void _addDataToFireBase(data, id) {
    Firestore.instance
        .collection('univ')
        .document(universityName)
        .collection('colleges')
        .document(collegeName)
        .collection('labs')
        .document(labID)
        .collection('exp')
        .document(id)
        .setData({
      'expName': data[0],
      'expNumber': data[1],
      'expLink': data[2],
      'report_link': data[3],
      'video_link': data[4],
    });
  }

//expName -> 0
//expNumber -> 1
//expLink -> 2
//reportLink -> 3
//VideoLink -> 4
  bool _validate(List<String> data) {
    if (data[0] == null || data[0].length < 2) {
      toastMaker('not valid experiment name');
      return false;
    }
    if (data[1] == null || data[1].length > 3) {
      toastMaker('not valid experiment number');
      return false;
    }
    if (data[2] == null || data[2].length < 10) {
      toastMaker('not valid experiment link');
      return false;
    }
    if (data[3] == null || data[3].length < 2) {
      toastMaker('not valid report link');
      return false;
    }
    return true;
  }

  //----------------------------------------------------------------------------------------------------
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

  Future<void> deletePaths() async {
    await _deleteHandler();
    if (!syncronisingLap) {
    final namesBox = Hive.box('names');
    String name = namesBox.get(dataCollection.dumMap(labID));
      toastMaker('تم حذف $name بنجاح');
    } else {
      toastMaker('تمت المزامنة بنجاح يمكنك الان اعادة تحميل المختبر');
    }
    dataCollection.labsMap.remove(labID);
    dataCollection.currentLabName = null;
    dataCollection.downloadedLabs.remove(labID);
    dataCollection.deletingFlag = false;
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
      }
    }
  }

  //from this line the rest of the method are to make sure that the user have the latest data
  bool hadChanges() {
    //if the user selected later the dialog will not appear
    if (dataCollection.later) return false;
    List<Paths> list = dataCollection.labsMap[labID];
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
            dataCollection.later = true;
            toastMaker(
                'تحذير قد تكون البيانات المحملة حاليا ناقصة او مغلوطة يرجى مزامنة المختبر في اقرب وقت');
            Navigator.of(context).pop();
          }),
        ),
        _customButton('بدء المزامنة', () {
          dataCollection.downloadedLabs.remove(labID);
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
    dataCollection.isClicked = false;
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
