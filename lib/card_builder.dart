import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/builder.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';
import 'epx_viewer.dart';

class CardBuilder extends StatelessWidget {
  final String path, college, university, from;
  var document, context;
  double mySquare;
  CardBuilder({
    this.path,
    this.document,
    this.mySquare,
    this.college,
    this.university,
    this.from,
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _customLabCard();
  }

  //returns a clickable card
  Widget _customLabCard() {
    return Card(
      color: Colors.white.withOpacity(0),
      elevation: 0,
      child: InkWell(
        onTap: () {
          if (!StaticVars.isClicked) {
            _pathSetter(document);
          }
        },
        child: path != null
            ? _myFadingImage(path)
            : Image.asset('lib/photos/lab_image.jpg'),
      ),
    );
  }

  //OMG
  void _pathSetter(document) {
    String currentDocumentID = document.documentID;
    StaticVars.isClicked = true;
    _dynamicIVR(currentDocumentID);
    _gettingDataFromFireBase(document, currentDocumentID);
  }

  //shit alot of fucken statics is going her and thats fucken bad
  /**
   * this method is to check if the lab is opened pefore then
   *  get it from the list else download it and save it in the list
   */
  void _gettingDataFromFireBase(document, String currentDocumentID) {
    if (university == 'univ' || from == 'univ') return;
    Future<QuerySnapshot> d = _getPath(currentDocumentID);
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
      _navigator(onValue.documents);
    });
  }

  //returns a fadingImage from the given path
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

  //handels the click event on the card
  void _navigator(List<DocumentSnapshot> documents) {
    if (StaticVars.paths.length == 0) {
      _addToListOfPaths(documents);
    }

    if (StaticVars.paths.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Exp_viewer(
              university: university,
              college: college,
              labName: StaticVars.currentLabName,
              paths: StaticVars.paths,
              documentsOfExperiments: documents),
        ),
      );
    }
  }

  //this method recives a list of documents and loop throw them extracting the data to the static list
  void _addToListOfPaths(documents) {
    for (var doc in documents) {
      StaticVars.paths.add(
        new Paths(
          exp_link: doc['expLink'],
          expName: doc['expName'],
          expNumber: doc['expNumber'],
          report_link: doc['report_link'],
          video_link: doc['video_link'],
        ),
      );
    }
  }

  //try to fix this method with ? thing cuz it sucks like this
  //infact you should fix it with a statfull widget insted of all this noun sence thats going on
  void _dynamicIVR(String currentDocumentID) {
    StaticVars.isClicked = false;
    if (university == 'univ') {
      Box universityBox = Hive.box('universityName');
      universityBox.put('university_name', currentDocumentID);
      //up to this line it's good
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => new MyBuilder(
            from: university,
            university: currentDocumentID,
            title: currentDocumentID,
            replacment: true,
          ),
        ),
      );
    } else if (from == 'univ') {
      //to refell the list again
      StaticVars.streemList = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new MyBuilder(
            college: currentDocumentID,
            university: university,
            title: currentDocumentID,
            from: '',
            isLab: true,
          ),
        ),
      );
    }
  }

  //returns the path to reed the exp from the firebase
  Future<QuerySnapshot> _getPath(String currentDocumentID) {
    return Firestore.instance
        .collection('univ')
        .document(university)
        .collection('colleges')
        .document(college)
        .collection('labs')
        .document(currentDocumentID)
        .collection('exp')
        .getDocuments();
  }
}
