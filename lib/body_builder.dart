import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/card_builder.dart';
import 'package:ivr_labs/lab_name_builder.dart';
import 'package:ivr_labs/var.dart';

class BodyBuilder extends StatelessWidget {
  double mySquare;
  String college, university, from;
  var context, firebasePath;
//--------------------------------------------------------------------------------------
  List<DocumentSnapshot> streemList;
  BodyBuilder({
    this.college,
    this.from,
    this.university,
    this.streemList,
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _setWidthAndHeight();
    _pathSetter();
    return (streemList != null) ? _myWrap(streemList) : _myStreem();
  }

  Widget _myStreem() {
    return StreamBuilder(
      stream: firebasePath,
      builder: (context, snapShots) {
        return _streemHandler(snapShots);
      },
    );
  }

  //set the dimentions for width and hight of the card
  void _setWidthAndHeight() {
    int div = (university == 'univ' || from == 'univ') ? 0 : 1;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      mySquare = MediaQuery.of(context).size.width / (div + 2) - 10;
    } else {
      mySquare = MediaQuery.of(context).size.width / (div + 1) - 10;
    }
  }

  //choosing the path on the firebase to read from
  void _pathSetter() {
    if (university == 'univ') {
      //this line will bring all the universities in the database
      firebasePath = Firestore.instance.collection(university).snapshots();
    } else if (from == 'univ') {
      //this path will bring all the colleges in the university
      firebasePath = Firestore.instance
          .collection(from)
          .document(university)
          .collection('colleges')
          .snapshots();
    } else {
      //this path will bring all the labs  in this college from this university
      firebasePath = Firestore.instance
          .collection('univ')
          .document(university)
          .collection('colleges')
          .document(college)
          .collection('labs')
          .snapshots();
    }
  }

  //handels the snapShots of the streemBuilder
  Widget _streemHandler(snapShots) {
    if (snapShots.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }
    if (snapShots.hasError || snapShots.data == null) {
      return Center(
        child: Image.asset('lib/photos/cat_loading.gif'),
      );
    }
    if (streemList == null && university != 'univ' && from != 'univ') {
      StaticVars.streemList = snapShots.data.documents;
    }
    return _myWrap(snapShots.data.documents);
  }

  //loops throw the documents in the snapShots and send them to _customContainer
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

  //returns a container with a CardBuilder and a LabName on top of it
  Widget _customContainer(document) {
    String path = document['image'];
    String labName = document.documentID;

    return Container(
      width: mySquare,
      height: _dynamicHeight(),
      child: Stack(
        children: <Widget>[
          CardBuilder(
              college: college,
              mySquare: mySquare,
              path: path,
              document: document,
              university: university,
              from: from),
          LabName(name: labName),
        ],
      ),
    );
  }

  //returns a custom height depending on rhe receved attripute
  double _dynamicHeight() {
    return (university == 'univ' || from == 'univ') ? mySquare - 100 : mySquare;
  }
}
