import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ivr_labs/pdf_viewer.dart';

class PDF_Viewer_FAB extends StatefulWidget {
  String urlpath, appBarTitle, reportFilePath;
  PDF_Viewer_FAB({
    Key key,
    this.urlpath,
    this.appBarTitle,
    this.reportFilePath,
  }) : super(key: key);
  @override
  _PDF_ViewerState createState() => _PDF_ViewerState();
}

class _PDF_ViewerState extends State<PDF_Viewer_FAB> {
  bool pdfGetted = false;
  @override
  Widget build(BuildContext context) {
    return _normalScaffold();
  }

  Widget _normalScaffold() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.appBarTitle),
      ),
      body: _myBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        child: Image.asset(
          'lib/photos/report.png',
          scale: 14,
        ),
        onPressed: () {
          _navigator();
        },
      ),
    );
  }

  Widget _myBody() {
    return Stack(
      children: <Widget>[
        _myPDFView(),
        !pdfGetted
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Offstage(),
      ],
    );
  }

  Widget _myPDFView() {
    return PDFView(
      filePath: widget.urlpath,
      autoSpacing: true,
      swipeHorizontal: true,
      enableSwipe: true,
      pageSnap: true,
      onPageChanged: (currentPage, totalPages) {
        setState(() {
          pdfGetted = true;
        });
      },
    );
  }

  void _navigator() {
    print('my widget = ${widget.reportFilePath}');
    if (widget.reportFilePath == null) {
      return;
    }
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => PDF_Viewer(
          urlpath: widget.reportFilePath,
          appBarTitle: widget.appBarTitle,
        ),
      ),
    );
  }
}
