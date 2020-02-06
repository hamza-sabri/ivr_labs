import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_viewer.dart';
import 'package:ivr_labs/pdf_viewer_with_fab.dart';
import 'package:ivr_labs/var.dart';
import 'package:ivr_labs/youtube_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/*
this class returns a card when clicked opens the page PDF_Viewer_FAB
*/

class PDFFileReader extends StatefulWidget {
  final String college, labName, imageLink;
  final String university;
  final List<Paths> paths;
  final Widget fav;

  PDFFileReader(
      {this.university,
      this.college,
      this.labName,
      this.paths,
      this.fav,
      this.imageLink});

  @override
  _PDFFileReaderState createState() => _PDFFileReaderState();
}

class _PDFFileReaderState extends State<PDFFileReader> {
  final TextStyle loadingTextStyle = new TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  final TextStyle tipTextStyle = new TextStyle(
    fontSize: 20.0,
  );

  var context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      child: _myFutureCardsList(),
      onWillPop: () async {
        StaticVars.isClicked = false;
        return true;
      },
    );
  }

  Widget _myFutureCardsList() {
    return FutureBuilder(
      future: _columnBuilder(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return _myLoadingTips();
        } else if (snapShot.hasError || snapShot.data == null) {
          return Image.asset(
            'lib/photos/cat_loading.gif',
            scale: .0001,
          );
        }
        return _customScroll(snapShot);
      },
    );
  }

  Widget _customScroll(snapShot) {
    return CustomScrollView(
      slivers: <Widget>[
        _mySliver(),
        _sliverList(snapShot.data),
      ],
    );
  }

  _mySliver() {
    return SliverAppBar(
      title: Text(
        widget.labName,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      pinned: true,
      centerTitle: true,
      elevation: 20,
      expandedHeight: 200,
      actions: <Widget>[widget.fav],
      flexibleSpace: FlexibleSpaceBar(
        background: _customStack(),
      ),
    );
  }

  Widget _customStack() {
    return FadeInImage.assetNetwork(
      fit: BoxFit.cover,
      placeholder: 'lib/photos/lamb_loading.gif',
      image: widget.imageLink,
    );
  }

  SliverList _sliverList(List<Widget> expList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return expList[index];
        },
        childCount: expList.length,
      ),
    );
  }

  Future<List<Widget>> _columnBuilder() async {
    List<Widget> cardsList = [];
    for (Paths path in widget.paths) {
      if (path.expPath == null) await _expirementPathSetter(path);
      if (path.reportPath == null) await _reportPathSetter(path);
      cardsList.add(_creatCardFor(path));
      if (path.expPath == null) {
        //we return null so we know that error ocared while retreving data
        return null;
      }
    }
    return cardsList;
  }

  Future<File> _getExpirementFileFromUrl(String url, String expName) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File(
          "${dir.path}/expirimen${widget.college}${widget.labName}$expName.pdf");
      File urlPdf = await file.writeAsBytes(bytes);
      return urlPdf;
    } catch (e) {
      return null;
    }
  }

  Future<File> _getReportFileFromUrl(String url, String expName) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File(
          "${dir.path}/report${widget.college}${widget.labName}$expName.pdf");
      File urlPdf = await file.writeAsBytes(bytes);
      return urlPdf;
    } catch (e) {
      return null;
    }
  }

  Future<void> _expirementPathSetter(Paths object) async {
    File f = await _getExpirementFileFromUrl(object.expLink, object.expName);
    if (f != null) {
      object.expPath = f.path;
    }
  }

  Future<void> _reportPathSetter(Paths object) async {
    if (object.reportLink == null) {
      return;
    }
    File f = await _getReportFileFromUrl(object.reportLink, object.expName);
    if (f != null) {
      object.reportPath = f.path;
    }
  }

  void _navigator1(Paths object) {
    if (object.expPath == null ||
        object.expPath.length == 0 ||
        object.reportPath == null ||
        object.reportPath.length == 0) {
      return;
    }
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => PDFViewerWithFAB(
          urlpath: object.expPath,
          appBarTitle: object.expName,
          reportFilePath: object.reportPath,
          reportLink: object.reportLink,
        ),
      ),
    );
  }

  void _navigator2(Paths object) {
    if (object.expPath == null || object.expPath.length == 0) {
      return;
    }
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(
          urlpath: object.expPath,
          appBarTitle: object.expName,
        ),
      ),
    );
  }

  Widget _creatCardFor(Paths object) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: Card(
        elevation: 4,
        child: _myListTile(object),
      ),
    );
  }

  Widget _myListTile(Paths object) {
    return ListTile(
      title: Text((object.expName.length > 50)
          ? object.expName.substring(0, 50) + '...'
          : object.expName),
      subtitle: (object.expNumber == null)
          ? Text('')
          : Text('experiment number (${object.expNumber})'),
      onTap: () {
        if (object.reportLink != null && object.reportPath != null) {
          _navigator1(object);
        } else {
          _navigator2(object);
        }
      },
      trailing: YoutubeButton(url: object.videoLink),
    );
  }

  Widget _myLoadingTips() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('univ')
          .document(widget.university)
          .collection('colleges')
          .document(widget.college)
          .collection('labs')
          .document(widget.labName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _normalStack();
        }
        if (snapshot.hasError) {
          return _normalStack();
        }
        return _myTips(snapshot.data['tips']);
      },
    );
  }

  Widget _myTips(tips) {
    if (tips == null || tips.length == 0) {
      return _normalStack();
    }
    return Stack(
      children: <Widget>[
        _widthAndHeightSetUps(),
        _myLoadingGif(),
        _tipsBuilder(tips),
      ],
    );
  }

  Widget _tipsBuilder(tips) {
    return Positioned(
      left: 10,
      right: 8,
      bottom: -30,
      child: _centeringTip(
        tips,
      ),
    );
  }

  Widget _centeringTip(tips) {
    return Container(
      width: double.infinity,
      child: Center(
        child: _animatedTipBuilder(tips),
      ),
    );
  }

  Widget _animatedTipBuilder(tips) {
    int length = tips.length;
    return ColorizeAnimatedTextKit(
        text: [
          tips[_randomgenretor(length)],
          tips[_randomgenretor(length)],
        ],
        textStyle: tipTextStyle,
        colors: [Colors.purple, Colors.blue, Colors.yellow, Colors.red],
        textAlign: TextAlign.center,
        alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        );
  }

  Widget _widthAndHeightSetUps() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xff191F26),
    );
  }

  Widget _normalStack() {
    return Stack(
      children: <Widget>[
        _widthAndHeightSetUps(),
        _myLoadingGif(),
        _myPositionedText(),
        Positioned(
          top: 50,
          right: 8,
          child: widget.fav,
        )
      ],
    );
  }

  Widget _myLoadingGif() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Image.asset(
        'lib/photos/lab_loading.gif',
      ),
    );
  }

  Widget _myPositionedText() {
    double myCenter = (MediaQuery.of(context).size.width / 2) - 27;
    return Positioned(
      bottom: 22,
      left: myCenter,
      child: _myAnimatedText(),
    );
  }

  Widget _myAnimatedText() {
    return Row(
      children: <Widget>[
        Text(
          'loading.',
          style: loadingTextStyle,
        ),
        FadeAnimatedTextKit(
          text: <String>[
            '.',
            '..',
            '...',
          ],
          textStyle: loadingTextStyle,
        ),
      ],
    );
  }

  int _randomgenretor(int length) {
    return abs(Random().nextInt(length));
  }

  int abs(int random) {
    if (random < 0) return random * -1;
    return random;
  }
}
