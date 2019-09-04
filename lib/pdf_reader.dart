import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_viewer.dart';
import 'package:ivr_labs/pdf_viewer_with_fab.dart';
import 'package:ivr_labs/youtube_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/*
this class returns a card when clicked opens the page PDF_Viewer_FAB
*/

class PDF_File_Reader extends StatelessWidget {
  TextStyle loadingTextStyle = new TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  List<Paths> paths;
  var context;
  PDF_File_Reader({
    this.paths,
  });

  //---------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _myFutureCardsList();
  }

  //this method is to call the _columnBuilder method and handel the returned value from it
  Widget _myFutureCardsList() {
    return FutureBuilder(
      future: _columnBuilder(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return _myStack();
        }
        if (snapShot.hasError || snapShot.data == null) {
          return Image.asset(
            'lib/photos/cat_loading.gif',
            scale: .0001,
          );
        }
        if (snapShot.hasData) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: SingleChildScrollView(
              child: Column(
                children: snapShot.data,
              ),
            ),
          );
        }
      },
    );
  }

  //this method is to loop throw the paths list and creat the cards from the data of the paths list
  Future<List<Widget>> _columnBuilder() async {
    List<Widget> cardsList = [];
    for (int i = 0; i < paths.length; i++) {
      if (paths[i].exp_path == null) await _expirementPathSetter(paths[i]);
      if (paths[i].report_path == null) await _reportPathSetter(paths[i]);
      cardsList.add(_creatCardFor(paths[i]));
      if (paths[i].exp_path == null) {
        //we return null so we know that error ocared while retreving data
        return null;
      }
    }
    return cardsList;
  }

  //as the name sugessts it returns a file with the expirement PDF file in it
  Future<File> _getExpirementFileFromUrl(String url, String expName) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/expirimen$expName.pdf");
      File urlPdf = await file.writeAsBytes(bytes);
      return urlPdf;
    } catch (e) {}
  }

  //as the name sugessts it returns a file with the report PDF file in it
  Future<File> _getReportFileFromUrl(String url, String expName) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/report$expName.pdf");
      File urlPdf = await file.writeAsBytes(bytes);
      return urlPdf;
    } catch (e) {}
  }

  //this method calls the (_getExpirementFileFromUrl()) method  and set the path of it to the urlpath attrepute
  Future<void> _expirementPathSetter(Paths object) async {
    File f = await _getExpirementFileFromUrl(object.exp_link, object.expName);
    if (f != null) {
      object.exp_path = f.path;
    }
  }

  //this method calls the (_getReportFileFromUrl()) method  and set the path of it to the urlpath attrepute
  Future<void> _reportPathSetter(Paths object) async {
    if (object.report_link == null) {
      return;
    }
    File f = await _getReportFileFromUrl(object.report_link, object.expName);
    if (f != null) {
      object.report_path = f.path;
    }
  }

  //switch to the pdf_viewer page with fab
  void _navigator1(Paths object) {
    if (object.exp_path == null ||
        object.exp_path.length == 0 ||
        object.report_path == null ||
        object.report_path.length == 0) {
      return;
    }
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => PDF_Viewer_FAB(
          urlpath: object.exp_path,
          appBarTitle: object.expName,
          reportFilePath: object.report_path,
        ),
      ),
    );
  }

  //switch to the pdf_viewer page without fab
  void _navigator2(Paths object) {
    if (object.exp_path == null || object.exp_path.length == 0) {
      return;
    }
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => PDF_Viewer(
          urlpath: object.exp_path,
          appBarTitle: object.expName,
        ),
      ),
    );
  }

  //takes object of Paths and creat a card Widget with the ListTile in it
  Widget _creatCardFor(Paths object) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: Card(
        elevation: 4,
        child: _myListTile(object),
      ),
    );
  }

  /*
  this method returns a ListTile with all the data needed 
  about the expirement like:
  number name and adds the youtube button at the end of the ListTile
  */
  Widget _myListTile(Paths object) {
    return ListTile(
      title: Text(object.expName),
      subtitle: (object.expNumber == null)
          ? Text('')
          : Text('experiment number (${object.expNumber})'),
      onTap: () {
        if (object.report_link != null && object.report_path != null) {
          _navigator1(object);
        } else {
          _navigator2(object);
        }
      },
      trailing: YoutubeButton(url: object.video_link),
    );
  }

  //this method is to set the loading gif and text on thier plases
  Widget _myStack() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xff191F26),
        ),
        _myLoading_gif(),
        _myPositionedText(),
      ],
    );
  }

  //returns the lab_loading gif centered in the screen
  Widget _myLoading_gif() {
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

  //returns the position of the loading... text the one with animation
  Widget _myPositionedText() {
    double myCenter = (MediaQuery.of(context).size.width / 2) - 27;
    return Positioned(
      bottom: 22,
      left: myCenter,
      child: _myAnimatedText(),
    );
  }

  /*
  this method returns  a row contains
  loading text 
  animation for the three dots folowing it
  */
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
}
