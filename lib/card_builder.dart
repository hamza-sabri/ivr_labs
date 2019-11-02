import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';

import 'epx_viewer.dart';

class CardBuilder extends StatelessWidget {
  String path, college;
  var document;
  var context;
  double mySquare;
  CardBuilder({
    this.path,
    this.document,
    this.mySquare,
    this.college,
  });
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _customLabCard();
  }

  Widget _customLabCard() {
    return Card(
      color: Colors.white.withOpacity(0),
      elevation: 0,
      child: InkWell(
        onTap: () {
          _navigator(document);
        },
        child: path != null
            ? _myFadingImage(path)
            : Image.asset('lib/photos/lab_image.jpg'),
      ),
    );
  }

  void _navigator(document) {
    String currentDocumentID = document.documentID;
    Future<QuerySnapshot> d = Firestore.instance
        .collection(college)
        .document(currentDocumentID)
        .collection('exp')
        .getDocuments();
    d.then((onValue) {
      if (StaticVars.currentLabName == null ||
          StaticVars.currentLabName != currentDocumentID) {
        StaticVars.add();
        if (StaticVars.contains(currentDocumentID)) {
          StaticVars.paths = StaticVars.myList(currentDocumentID);
          StaticVars.currentLabName = document.documentID;
        } else {
          StaticVars.paths = [];
          StaticVars.currentLabName = document.documentID;
        }
      }
      _pathSetter(onValue.documents);
    });
  }

  //----------------------------------------------------------------------------------------------------------------
  //this method is just to creat a rounded photo
  Widget _myFadingImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: FadeInImage.assetNetwork(
          fit: BoxFit.fill,
          width: mySquare,
          height: mySquare,
          placeholder: 'lib/photos/lamb_loading.gif',
          image: path),
    );
  }

  void _pathSetter(List<DocumentSnapshot> documents) {
    if (StaticVars.paths.length == 0) {
      for (int i = 0; i < documents.length; i++) {
        StaticVars.paths.add(
          new Paths(
            exp_link: documents[i]['expLink'],
            expName: documents[i]['expName'],
            expNumber: documents[i]['expNumber'],
            report_link: documents[i]['report_link'],
            video_link: documents[i]['video_link'],
          ),
        );
      }
    }

    if (StaticVars.paths.length > 0) {
      if (StaticVars.isClicked) {
        return;
      }
      StaticVars.isClicked = true;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Exp_viewer(
            college: college,
            labName: StaticVars.currentLabName,
            paths: StaticVars.paths,
            documentsOfExperiments: documents,
          ),
        ),
      );
    }
  }
}
