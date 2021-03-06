import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/data_collection.dart';
import 'package:ivr_labs/faviarot.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/validation.dart';

class Expviewer extends StatefulWidget {
  final List<DocumentSnapshot> documentsOfExperiments;
  final String college, labID, university, imageLink;
  final List<Paths> paths;
  final DataCollection dataCollection;

  Expviewer({
    this.paths,
    this.college,
    this.labID,
    this.documentsOfExperiments,
    this.university,
    this.imageLink,
    @required this.dataCollection,
  });

  @override
  _ExpviewerState createState() => _ExpviewerState();
}

class _ExpviewerState extends State<Expviewer> {
  DataCollection localDataCollection;

  @override
  void initState() {
    super.initState();
    localDataCollection = widget.dataCollection;
  }

  @override
  Widget build(BuildContext context) {
    final GeneralMethods _generalMethods = new GeneralMethods(
      context: context,
      documentsOfExperiments: widget.documentsOfExperiments,
      paths: widget.paths,
      labID: widget.labID,//this is the ID from the firebase
      dataCollection: localDataCollection,
    );
    if (_generalMethods.hadChanges()) {
      _generalMethods.createDialog(context);
    }
    return WillPopScope(
      onWillPop: () {
        return _back(_generalMethods);
      },
      child: Scaffold(
        body: _myBody(),
      ),
    );
  }

  Widget _myFav() {
    bool isDownloaded =
        localDataCollection.downloadedLabs.contains(widget.labID);
    return FaviarotCreator(
      isDownloaded: isDownloaded,
      labID: widget.labID,
      dataCollection: localDataCollection,
    );
  }

  Widget _myBody() {
    return PDFFileReader(
        university: widget.university,
        paths: widget.paths,
        college: widget.college,
        labID: widget.labID,
        fav: _myFav(),
        imageLink: widget.imageLink,
        dataCollection: localDataCollection);
  }

  Future<bool> _back(_generalMethods) async {
    localDataCollection.isClicked = false;
    if (localDataCollection.deletingFlag) {
      _generalMethods.deletePaths();
    }
    localDataCollection.later = false;
    return true;
  }
}
