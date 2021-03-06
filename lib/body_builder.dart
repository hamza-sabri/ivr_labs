import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/card_builder.dart';
import 'package:ivr_labs/data_collection.dart';
import 'package:ivr_labs/lab_name_builder.dart';

class BodyBuilder extends StatefulWidget {
  final String college, university, from;
  final List<DocumentSnapshot> streemList;
  final DataCollection dataCollection;
  BodyBuilder({
    this.college,
    this.from,
    this.university,
    this.streemList,
    @required this.dataCollection,
  });

  @override
  _BodyBuilderState createState() => _BodyBuilderState();
}

class _BodyBuilderState extends State<BodyBuilder> {
  var context, firebasePath;
  double mySquare;
  DataCollection localDataCollection;
  @override
  void initState() {
    super.initState();
    localDataCollection = widget.dataCollection;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _setWidthAndHeight();
    _pathSetter();
    return (widget.streemList != null)
        ? _myWrap(widget.streemList)
        : _myStreem();
  }

  Widget _myStreem() {
    return StreamBuilder(
      stream: firebasePath,
      builder: (context, snapShots) {
        return _streemHandler(snapShots);
      },
    );
  }

  void _setWidthAndHeight() {
    int div = (widget.university == 'univ' || widget.from == 'univ') ? 0 : 1;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      mySquare = MediaQuery.of(context).size.width / (div + 2) - 20;
    } else {
      mySquare = MediaQuery.of(context).size.width / (div + 1) - 18;
    }
  }

  void _pathSetter() {
    if (widget.university == 'univ') {
      //this line will bring all the universities in the database
      firebasePath =
          Firestore.instance.collection(widget.university).snapshots();
    } else if (widget.from == 'univ') {
      //this path will bring all the colleges in the university
      firebasePath = Firestore.instance
          .collection(widget.from)
          .document(widget.university)
          .collection('colleges')
          .snapshots();
    } else {
      //this path will bring all the labs  in this college from this university
      firebasePath = Firestore.instance
          .collection('univ')
          .document(widget.university)
          .collection('colleges')
          .document(widget.college)
          .collection('labs')
          .snapshots();
    }
  }

  Widget _streemHandler(snapShots) {
    if (snapShots.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }
    if (snapShots.hasError || snapShots.data == null) {
      return Center(
        child: Image.asset('lib/photos/cat_loading.gif'),
      );
    }
    if (widget.streemList == null &&
        widget.university != 'univ' &&
        widget.from != 'univ') {
      localDataCollection.streemList = snapShots.data.documents;
    }
    return _myWrap(snapShots.data.documents);
  }

  Widget _myWrap(documents) {
    List<Widget> wrapList = [];
    for (var temp in documents) {
      wrapList.add(_customContainer(temp));
    }
    return SingleChildScrollView(
      child: Center(
        child: Wrap(children: wrapList),
      ),
    );
  }

  Widget _customContainer(document) {
    String path = document['image'];
    String labName = document['name'];
    _saveme(labName,document.documentID);
    if (widget.college != null && widget.college != '') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
        child: SizedBox(
          width: mySquare + 2,
          height: _dynamicHeight() + 2,
          child: _customCard(path, document, labName),
        ),
      );
    }
    return SizedBox(
      width: mySquare + 2,
      height: _dynamicHeight() + 2,
      child: _customCard(path, document, labName),
    );
  }

  Widget _customCard(path, document, labName) {
    return Card(
      elevation: 9,
      borderOnForeground: false,
      color: Colors.white.withOpacity(0),
      child: Stack(
        children: <Widget>[
          CardBuilder(
            college: widget.college,
            width: mySquare,
            height: _dynamicHeight(),
            path: path,
            document: document,
            university: widget.university,
            from: widget.from,
            labName: labName,
            dataCollection: localDataCollection,
          ),
          LabName(name: labName)
        ],
      ),
    );
  }

  double _dynamicHeight() {
    return (widget.university == 'univ' || widget.from == 'univ')
        ? mySquare - 100
        : mySquare;
  }


  void _saveme(String labName , String labID){
  final Box box = Hive.box('names');
  labID = localDataCollection.dumMap(labID);
  box.put(labID, labName);
}
}
