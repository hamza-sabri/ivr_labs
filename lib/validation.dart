import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GeneralMethods {
  final String universityName, collegeName, labName;
  GeneralMethods({
    this.universityName,
    this.collegeName,
    this.labName,
  });

  bool push(List<String> data) {
    if (_validate(data)) {
      _addDataToFireBase(data);
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

  void _addDataToFireBase(data) {
    Firestore.instance
        .collection('univ')
        .document(universityName)
        .collection('colleges')
        .document(collegeName)
        .collection('labs')
        .document(labName)
        .collection('exp')
        .document()
        .setData({
      'expName': data[0],
      'expNumber': data[1],
      'expLink': data[2],
      'report_link': data[3],
      'video_link': data[4],
    });
  }

  void toastMaker(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
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
}
