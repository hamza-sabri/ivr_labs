import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDF_Viewer extends StatefulWidget {
  String urlpath, appBarTitle;
  PDF_Viewer({
    Key key,
    this.urlpath,
    this.appBarTitle,
  }) : super(key: key);
  @override
  _PDF_ViewerState createState() => _PDF_ViewerState();
}

class _PDF_ViewerState extends State<PDF_Viewer> {
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
}
