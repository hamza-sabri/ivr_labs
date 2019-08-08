import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_viewer.dart';
import 'package:ivr_labs/pdf_viewer_with_fab.dart';
import 'package:ivr_labs/youtube_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

//this class returns a card when clicked opens the page PDF_Viewer_FAB

class PDF_File_Reader extends StatelessWidget {
  TextStyle loadingText = new TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
  List<Paths> paths;
  var context;
  PDF_File_Reader({
    this.paths,
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _myFutureCard();
  }

  Future<File> _getExpirementFileFromUrl(String url, String expName) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/experimen$expName.pdf");
      File urlPdf = await file.writeAsBytes(bytes);
      return urlPdf;
    } catch (e) {}
  }

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

  //returns a future card or a circulerProgressIndecator
  Widget _myFutureCard() {
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
          return SingleChildScrollView(
            child: Column(
              children: snapShot.data,
            ),
          );
        }
      },
    );
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

  Future<List<Widget>> _columnBuilder() async {
    List<Widget> cards = [
      Container(
        width: 1,
        height: 1,
      )
    ];
    for (int i = 0; i < paths.length; i++) {
      if (paths[i].exp_path == null) await _expirementPathSetter(paths[i]);
      if (paths[i].report_path == null) await _reportPathSetter(paths[i]);
      cards.add(_creatCardFor(paths[i]));
      if (paths[i].exp_path == null) {
        return null;
      }
    }
    return cards;
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
      title: Text('experiment number (${object.expNumber})'),
      subtitle: Text(object.expName),
      onTap: () {
        if (object.fab_maker != null &&
            object.fab_maker &&
            object.report_link != null &&
            object.report_path != null) {
          _navigator1(object);
        } else {
          _navigator2(object);
        }
      },
      trailing: YoutubeButton(url: object.video_link),
    );
  }

  Widget _myStack() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xffb7B81A1),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset(
            'lib/photos/lamb_loading.gif',
            scale: .0001,
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            child: Center(
              child: Text(
                'loading...',
                style: loadingText,
              ),
            ),
          ),
        )
      ],
    );
  }
}
