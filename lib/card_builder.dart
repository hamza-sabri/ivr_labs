import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/builder.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/validation.dart';
import 'package:page_transition/page_transition.dart';
import 'data_collection.dart';
import 'epx_viewer.dart';

class CardBuilder extends StatefulWidget {
  final String path, college, university, from, labName;
  final document;
  final double width, height;
  final DataCollection dataCollection;
  CardBuilder({
    this.path,
    this.document,
    this.width,
    this.height,
    this.college,
    this.university,
    this.from,
    this.labName,
    @required this.dataCollection,
  });

  @override
  _CardBuilderState createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  String imageLink;
  var context;
  DataCollection localDataCollection;

  @override
  void initState() {
    super.initState();
    localDataCollection = widget.dataCollection;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _customLabCard();
  }

  Widget _customLabCard() {
    return Center(
      child: InkWell(
        onTap: () {
          if (!localDataCollection.isClicked) {
            _pathSetter(widget.document);
          } else {
            GeneralMethods methods = GeneralMethods(dataCollection: null);
            methods.toastMaker(
                'لا يمكن فتح أكثر من مختبر في نفس الوقت ... الرجاء الانتظار حتى الانتهاء من تحميل المختبر الحالي');
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
    localDataCollection.isClicked = true;
    _dynamicIVR(currentDocumentID);
    _gettingDataFromFireBase(document, currentDocumentID);
  }

  void _gettingDataFromFireBase(document, String currentDocumentID) {
    if (widget.university == 'univ' || widget.from == 'univ') return;
    Future<QuerySnapshot> d = _getPath(currentDocumentID);
    d.then((onValue) {
      if (localDataCollection.currentLabName == null ||
          localDataCollection.currentLabName != currentDocumentID) {
        localDataCollection.add();
        if (localDataCollection.contains(currentDocumentID)) {
          localDataCollection
            ..paths = localDataCollection.myList(currentDocumentID);
          localDataCollection.currentLabName = document.documentID;
        } else {
          localDataCollection.paths = [];
          localDataCollection.currentLabName = document.documentID;
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
    if (localDataCollection.paths.length == 0) {
      _addToListOfPaths(documents);
    }

    if (localDataCollection.paths.length > 0) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 850),
          child: Expviewer(
            university: widget.university,
            college: widget.college,
            labName: localDataCollection.currentLabName,
            paths: localDataCollection.paths,
            documentsOfExperiments: documents,
            imageLink: imageLink,
            dataCollection: localDataCollection,
          ),
        ),
      );
    }
  }

  void _addToListOfPaths(documents) {
    for (var doc in documents) {
      localDataCollection.paths.add(
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
      localDataCollection.isClicked = false;
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
            dataCollection: localDataCollection,
          ),
        ),
      );
    } else if (widget.from == 'univ') {
      localDataCollection.isClicked = false;
      //to refell the list again
      localDataCollection.streemList = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new MyBuilder(
            college: currentDocumentID,
            university: widget.university,
            title: currentDocumentID,
            from: '',
            isLab: true,
            dataCollection: localDataCollection,
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
