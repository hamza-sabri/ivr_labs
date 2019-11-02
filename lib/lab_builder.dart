import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/card_builder.dart';
import 'package:ivr_labs/lab_name_builder.dart';
/* 
this class is to get the data from the firebase database and:
1) crats the cards
2) add the photos to the cards if exist
3) add the label name of the lab on the cards
4) make it clickable so if it's clicked it navigate to the 
   exp_viewer with the data as a list of pathes (the links of the pdf files)
   and any other data needed 
*/
class LabBuilder extends StatelessWidget {
  //some attributs ---------------------------------------------------------------------------------------------------
  double mySquare;
  String college;
  var context;

  LabBuilder({this.college});
  //------------------------------------------------------------------------------------------------------------------

  //the build method
  @override
  Widget build(BuildContext context) {
    this.context = context;
    _setWidthAndHeight();
    return _cardBuilder();
  }

  //this method is to set the mySquare to the  size it should be depending on the screen size
  void _setWidthAndHeight() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      mySquare = MediaQuery.of(context).size.width / 3 - 10;
    } else {
      mySquare = MediaQuery.of(context).size.width / 2 - 10;
    }
  }

  /*this method calls a StreemBuilder and returns a wrap 
    the wrap contains the cards specified for each lab 
  */
  Widget _cardBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection(college).snapshots(),
      builder: (context, snapShots) {
        if (snapShots.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        if (snapShots.hasError || snapShots.data == null) {
          return Center(
            child: Image.asset('lib/photos/cat_loading.gif'),
          );
        }
        return _myWrap(snapShots);
      },
    );
  }
  //----------------------------------------------------------------------------------------------------------------

  /*_myWrap() takes the snapShots of labs from the database 
    then returns them in wrap as list of cards
  */
  Widget _myWrap(AsyncSnapshot snapShots) {
    List<Widget> wrapList = [];
    int loop = snapShots.data.documents.length;
    for (int i = 0; i < loop; i++) {
      wrapList.add(
        _myContainer(snapShots.data.documents[i]),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Wrap(children: wrapList),
          ),
        ],
      ),
    );
  }
  //----------------------------------------------------------------------------------------------------------------

  /*takes a document each time it's called and returns a container with a card 
    depending on the document if it has the like of a photo or not
    if it has one it return  _myContainerWithNetworkImage 
    else that it returns _myContainerWithoutNetworkImage
  */
  Widget _myContainer(document) {
    String path = document['image'];
    String labName = document.documentID;
    return _myContainerWithNetworkImage(path, labName, document);
  }
  //----------------------------------------------------------------------------------------------------------------

  /*this method is just to spred data in a good way and collect the returns values in a container
    but it works if the document in the previous method has a photo like
  */
  Widget _myContainerWithNetworkImage(String path, String name, document) {
    return Container(
      width: mySquare,
      height: mySquare,
      child: Stack(
        children: <Widget>[
          CardBuilder(
            college: college,
            mySquare: mySquare,
            path: path,
            document: document,
          ),
          // _labCard(document, path),
          LabName(name: name),
        ],
      ),
    );
  }
}