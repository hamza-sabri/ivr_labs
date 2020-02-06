import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/builder.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';
import 'package:page_transition/page_transition.dart';
import 'epx_viewer.dart';

class CardBuilder extends StatefulWidget {
  final String path, college, university, from, labName;
  final document;
  final double width, height;
  CardBuilder({
    this.path,
    this.document,
    this.width,
    this.height,
    this.college,
    this.university,
    this.from,
    this.labName,
  });

  @override
  _CardBuilderState createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  String imageLink;
  var context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _customLabCard();
  }

  Widget _customLabCard() {
    return Center(
      child: InkWell(
        onTap: () {
          if (!StaticVars.isClicked) {
            _pathSetter(widget.document);
          }
        },
        child: widget.path != null
            ? _myFadingImage(widget.path)
            : Image.asset('lib/photos/lab_image.jpg'),
      ),
    );
  }

  void _pathSetter(document) {
    String currentDocumentID = document.documentID;
    StaticVars.isClicked = true;
    _dynamicIVR(currentDocumentID);
    _gettingDataFromFireBase(document, currentDocumentID);
  }

  void _gettingDataFromFireBase(document, String currentDocumentID) {
    if (widget.university == 'univ' || widget.from == 'univ') return;
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

  Widget _myFadingImage(String path) {
    imageLink = path;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: FadeInImage.assetNetwork(
          fit: BoxFit.fill,
          width: widget.width,
          height: widget.height,
          placeholder: 'lib/photos/lamb_loading.gif',
          image: path),
    );
  }

  Future<void> _navigator(List<DocumentSnapshot> documents) async {
    if (StaticVars.paths.length == 0) {
      _addToListOfPaths(documents);
    }

    if (StaticVars.paths.length > 0) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 1000),
          child: Expviewer(
            university: widget.university,
            college: widget.college,
            labName: StaticVars.currentLabName,
            paths: StaticVars.paths,
            documentsOfExperiments: documents,
            imageLink: imageLink,
          ),
        ),
      );
    }
  }

  void _addToListOfPaths(documents) {
    for (var doc in documents) {
      StaticVars.paths.add(
        new Paths(
          expLink: doc['expLink'],
          expName: doc['expName'],
          expNumber: doc['expNumber'],
          reportLink: doc['report_link'],
          videoLink: doc['video_link'],
        ),
      );
    }
  }

  void _dynamicIVR(String currentDocumentID) {
    if (widget.university == 'univ') {
      StaticVars.isClicked = false;
      Box universityBox = Hive.box('universityName');
      universityBox.put('university_name', currentDocumentID);
      //up to this line it's good
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => new MyBuilder(
            from: widget.university,
            university: currentDocumentID,
            title: currentDocumentID,
            replacment: true,
          ),
        ),
      );
    } else if (widget.from == 'univ') {
      StaticVars.isClicked = false;
      //to refell the list again
      StaticVars.streemList = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new MyBuilder(
            college: currentDocumentID,
            university: widget.university,
            title: currentDocumentID,
            from: '',
            isLab: true,
          ),
        ),
      );
    }
  }

  Future<QuerySnapshot> _getPath(String currentDocumentID) {
    return Firestore.instance
        .collection('univ')
        .document(widget.university)
        .collection('colleges')
        .document(widget.college)
        .collection('labs')
        .document(currentDocumentID)
        .collection('exp')
        .getDocuments();
  }
}
