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
          final GeneralMethods methods = GeneralMethods(dataCollection: null); 
          if (!localDataCollection.isClicked) {
            if(widget.college != null && widget.college != '')
             methods.toastMaker(
                'المختبر قيد التحضير الرجاء الانتظار ... ');

            _pathSetter(widget.document);
          } else {

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
    String currentName = document['name'];
    localDataCollection.isClicked = true;
    _dynamicIVR(currentDocumentID,currentName);
    _gettingDataFromFireBase(document, currentDocumentID,currentName);
  }

  void _gettingDataFromFireBase(document, String currentDocumentID,String currentLabName) {
    if (widget.university == 'univ' || widget.from == 'univ') return;
    Future<QuerySnapshot> d = _getPath(currentDocumentID);
    d.then((onValue) {
      if (localDataCollection.currentLabName == null ||
          localDataCollection.currentLabName != currentLabName) {
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
            labID: localDataCollection.currentLabName,
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

  void _dynamicIVR(String currentDocumentID,String title) {
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
            title: title,
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
            title: title,
            from: '',
            isLab: true,
            dataCollection: localDataCollection,
          ),
        ),
      );
    }
  }

//this method is to get the data from the firebase
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
