import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/card_builder.dart';
import 'package:ivr_labs/lab_name_builder.dart';
import 'package:ivr_labs/var.dart';

class BodyBuilder extends StatefulWidget {
  final String college, university, from;
  final List<DocumentSnapshot> streemList;
  BodyBuilder({
    this.college,
    this.from,
    this.university,
    this.streemList,
  });

  @override
  _BodyBuilderState createState() => _BodyBuilderState();
}

class _BodyBuilderState extends State<BodyBuilder> {
  var context, firebasePath;
  double mySquare;
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
      mySquare = MediaQuery.of(context).size.width / (div + 2) - 10;
    } else {
      mySquare = MediaQuery.of(context).size.width / (div + 1) - 10;
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
      StaticVars.streemList = snapShots.data.documents;
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
    String labName = document.documentID;

    return Container(
      width: mySquare,
      height: _dynamicHeight(),
      child: Stack(
        children: <Widget>[
          CardBuilder(
              college: widget.college,
              mySquare: mySquare,
              path: path,
              document: document,
              university: widget.university,
              from: widget.from),
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
}
