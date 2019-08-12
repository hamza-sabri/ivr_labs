import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/epx_viewer.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';

/* 
this class is to get the data from the firebsae database and:
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
  TextStyle labNameStyle = new TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );
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
        return Center(
          child: _myWrap(snapShots),
        );
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
    return Center(
      child: SingleChildScrollView(
        child: Wrap(children: wrapList),
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
    if (path != null && path.length > 0) {
      return _myContainerWithNetworkImage(path, labName, document);
    }
    return _myContainerWithoutNetworkImage(labName, document);
  }
  //----------------------------------------------------------------------------------------------------------------

  /*this method is just to spred data in a good way and collect the returns values in a container
    but it works if the document in the previous method has a photo like
  */
  Widget _myContainerWithNetworkImage(String path, String name, document) {
    return Container(
      color: Colors.black.withOpacity(0),
      width: mySquare,
      height: mySquare,
      child: Stack(
        children: <Widget>[
          _myLabCard(document, path),
          _labName(name),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------------------------------------------
  /*this method is just to spred data in a good way and collect the returns values in a container
    but it works if the document in the previous method dont have a photo like
  */
  Widget _myContainerWithoutNetworkImage(String name, document) {
    return Stack(
      children: <Widget>[
        Container(
          width: mySquare,
          height: mySquare,
          child: _myLabCardWithNoPhoto(document),
        ),
        _labName(name),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------------------
  /*this method is the one creating the card
    but it works if the document in the previous method dont have a photo like
  */
  Widget _myLabCardWithNoPhoto(document) {
    return Card(
      elevation: 4,
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'lib/photos/lab_image.jpg',
            fit: BoxFit.fill,
          ),
        ),
        onTap: () {
          _navigator(document);
        },
      ),
    );
  }

  //----------------------------------------------------------------------------------------------------------------
  /*this method is the one creating the card
    but it works if the document in the previous method has a photo like
  */
  Widget _myLabCard(document, String path) {
    return Card(
      color: Colors.white.withOpacity(0),
      elevation: 0,
      child: InkWell(
        onTap: () {
          _navigator(document);
        },
        child: _myFadingImage(path),
      ),
    );
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

  //----------------------------------------------------------------------------------------------------------------
  //this method is just to add the lab name to the card
  Widget _labName(String name) {
    return Positioned(
      bottom: 20,
      right: 10,
      left: 10,
      child: Container(
        color: Colors.black.withOpacity(.6),
        child: Center(
          child: Text(
            name,
            style: labNameStyle,
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------------------------------------------------------------------------------------------
  //extract the data from it's own path and calls the pathSetter to start navigating
  void _navigator(document) {
    Future<QuerySnapshot> d = Firestore.instance
        .collection(college)
        .document(document.documentID)
        .collection('exp')
        .getDocuments();
    d.then((onValue) {
      if (Vars.currentLabName == null ||
          Vars.currentLabName != document.documentID) {
        Vars.paths = [];
        Vars.currentLabName = document.documentID;
      }
      _pathSetter(onValue.documents);
    });
  }

  /*add the pathes to the list if it's ready to be navigated
    then navigat it to the exp_viewer 
  */
  void _pathSetter(List<DocumentSnapshot> documents) {
    if (Vars.paths.length == 0) {
      for (int i = 0; i < documents.length; i++) {
        Vars.paths.add(
          new Paths(
            exp_link: documents[i]['expLinke'],
            expName: documents[i]['expName'],
            expNumber: documents[i]['expNumber'],
            fab_maker: true,
            report_link: documents[i]['report_link'],
            video_link: documents[i]['video_link'],
          ),
        );
      }
    }
    if (Vars.paths.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Exp_viewer(
            labName: Vars.currentLabName,
            paths: Vars.paths,
            documentsOfExperiments: documents,
          ),
        ),
      );
    }
  }
}
